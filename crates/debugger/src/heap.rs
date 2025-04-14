/// Tagged objects all have an object header consisting of a tag and a forwarding pointer.
/// The forwarding pointer is only reserved if compiled for the incremental GC.
/// The tag is to describe their runtime type and serves to traverse the heap
/// (serialization, GC), but also for objectification of arrays.
/// 
/// The tag is a word at the beginning of the object.
/// 
/// The (skewed) forwarding pointer supports object moving in the incremental garbage collection.
/// 
///     obj header
/// ┌──────┬─────────┬──
/// │ tag  │ fwd ptr │ ...
/// └──────┴─────────┴──
/// 
/// The copying GC requires that all tagged objects in the dynamic heap space have at least
/// two words in order to replace them by `Indirection`. This condition is except for `Null`
/// that only lives in static heap space and is therefore not replaced by `Indirection` during
/// copying GC.
/// 
/// More details see: https://github.com/dfinity/motoko/blob/master/src/codegen/compile_classical.ml

use std::cell::Ref;
use anyhow::{Error, Ok};
use wasmi::{engine::executor::instrs::Executor, Func, Store, Val};
use wasmi_core::{UntypedVal, F32, F64};
use wasmi_wasi::WasiCtx;

const TAG_OFFSET: u32 = 1;
const DATA_OFFSET: u32 = 4;
const ARRAY_VAR_T_DATA_OFFSET: u32 = 8;

#[derive(Debug)]
enum Tagged {
    Object = 1,
    ArrayT = 3,
    ArrayVarT = 5,
    ArrayTuple = 7,
    ArrayShared = 9,
    Bits64Signed = 11,
    Bits64Unsigned = 13,
    Bits64Float = 15,
    MutBox = 17,
    Closure = 19,
    Some = 21,
    Variant = 23,
    BlobBlob = 25,
    BlobText = 27,
    BlobPrincipal = 29,
    BlobActor = 31,
    Indirection = 33,
    BigInt = 35,
    Concat = 37,
    Region = 39,
    Bits32Signed = 41,
    Bits32Unsigned = 43,
    Bits32Float = 45,
    Null = 47,
    OneWordFiller = 49,
    FreeSpace = 51,
    ArraySliceMinimum = 52,
    CoercionFailure = 0xffff_fffe,
    StableSeen = 0xffff_ffff,
}

impl Tagged {
    fn from_u64(value: u64) -> Result<Self, Error> {
        match value {
            1 => Ok(Tagged::Object),
            3 => Ok(Tagged::ArrayT),
            5 => Ok(Tagged::ArrayVarT),
            7 => Ok(Tagged::ArrayTuple),
            9 => Ok(Tagged::ArrayShared),
            11 => Ok(Tagged::Bits64Signed),
            13 => Ok(Tagged::Bits64Unsigned),
            15 => Ok(Tagged::Bits64Float),
            17 => Ok(Tagged::MutBox),
            19 => Ok(Tagged::Closure),
            21 => Ok(Tagged::Some),
            23 => Ok(Tagged::Variant),
            25 => Ok(Tagged::BlobBlob),
            27 => Ok(Tagged::BlobText),
            29 => Ok(Tagged::BlobPrincipal),
            31 => Ok(Tagged::BlobActor),
            33 => Ok(Tagged::Indirection),
            35 => Ok(Tagged::BigInt),
            37 => Ok(Tagged::Concat),
            39 => Ok(Tagged::Region),
            41 => Ok(Tagged::Bits32Signed),
            43 => Ok(Tagged::Bits32Unsigned),
            45 => Ok(Tagged::Bits32Float),
            47 => Ok(Tagged::Null),
            49 => Ok(Tagged::OneWordFiller),
            51 => Ok(Tagged::FreeSpace),
            52 => Ok(Tagged::ArraySliceMinimum),
            0xffff_fffe => Ok(Tagged::CoercionFailure),
            0xffff_ffff => Ok(Tagged::StableSeen),
            _ => Err(Error::msg(format!("Unknown tag value: {}", value))),
        }
    }
}

pub fn display_local_in_heap(
    executor: Ref<'_, Executor>, 
    store: &mut Store<WasiCtx>, 
    address: u64, 
    val_type: wasmi_core::ValType,

    bigint_to_float64: Option<Func>,
    bigint_to_word64_wrap: Option<Func>,
    bigint_to_word32_wrap: Option<Func>,
) -> Result<String, Error> {
    if address & 1 == 0 {
        let typed_val = match val_type {
            wasmi_core::ValType::I32 => Val::I32(address as i32),
            wasmi_core::ValType::I64 => Val::I64(address as i64),
            wasmi_core::ValType::F32 => Val::F32(F32::from(address as f32)),
            wasmi_core::ValType::F64 => Val::F64(F64::from(address as f64)),
            _ => return Ok(format!("Unsupported type {:?}", val_type))
        };
        return Ok(format!("{:?}", typed_val))
    }
    let memory = wasmi_ir::index::Memory::from(0);
    let memory = executor.fetch_memory_bytes(memory, &store.inner).to_vec();
    let loaded_value = load_i32_from_heap(
        memory.as_slice(), 
        address, 
        TAG_OFFSET
    )?;

    let ret = match Tagged::from_u64(loaded_value.to_bits())? {
        Tagged::ArrayVarT  => handle_array_var_t(
            memory.as_slice(), 
            address, 
            val_type, 
            executor, 
            store, 
            bigint_to_float64, 
            bigint_to_word64_wrap,
             bigint_to_word32_wrap)?,
        Tagged::MutBox => handle_mut_box(&memory, address)?,
        Tagged::BigInt => handle_bigint(
            store, 
            address, 
            val_type, 
            bigint_to_float64, 
            bigint_to_word64_wrap, 
            bigint_to_word32_wrap)?,
        Tagged::Bits64Float => handle_f64(&memory, address)?,
        Tagged::Bits32Float => handle_f32(&memory, address)?,
        Tagged::BlobText => handle_blob_text(&memory, address)?,
        Tagged::Concat => handle_concat(&memory, address, executor, store)?,
        // Tagged::Object => handle_object(
        //     &memory, 
        //     address, 
        //     val_type, 
        //     executor, 
        //     store, 
        //     bigint_to_float64, 
        //     bigint_to_word64_wrap,
        //      bigint_to_word32_wrap)?,
        _  => format!(
            "HeapAddress: {}, tagged: {:?}, {:?}", 
            address, 
            Tagged::from_u64(loaded_value.to_bits())?, 
            val_type),
    };
    Ok(ret)
}

fn handle_array_var_t(
    memory: &[u8],
    address: u64, 
    val_type: wasmi_core::ValType,
    executor: Ref<'_, Executor>,
    store: &mut Store<WasiCtx>,
    bigint_to_float64: Option<Func>,
    bigint_to_word64_wrap: Option<Func>,
    bigint_to_word32_wrap: Option<Func>,
) -> Result<String, Error> {
    let len = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        TAG_OFFSET + DATA_OFFSET
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;

    let mut ret = String::new();
    ret.push_str("[");
    let len = len.to_bits() as u32;
    for i in 0..len {
        let loaded_value = load_from_heap(
            memory, 
            address, 
            TAG_OFFSET + ARRAY_VAR_T_DATA_OFFSET + i * get_heap_type_size(val_type),
            val_type
        )?;
        ret.push_str(
            &format!(
                "{}, ", 
                display_wasm_val(
                    loaded_value, 
                    val_type, 
                    val_type.is_float(),
                    Ref::<'_, Executor<'_>>::clone(&executor),
                    store,
                    bigint_to_float64, 
                    bigint_to_word64_wrap, 
                    bigint_to_word32_wrap
                )?
            )
        );
    }
    ret.push_str("]");
    return Ok(ret);
}

fn handle_bigint(
    store: &mut Store<WasiCtx>,
    address: u64,
    val_type: wasmi_core::ValType,
    bigint_to_float64: Option<Func>,
    bigint_to_word64_wrap: Option<Func>,    
    bigint_to_word32_wrap: Option<Func>,
) -> Result<String, Error> {
    let mut ret_val = Vec::<Val>::new();
    ret_val.push(Val::default(val_type));

    match val_type {
        wasmi_core::ValType::F64 => {
            bigint_to_float64
                .expect("No bigint_to_word64_wrap function")
                .call(store, &[Val::F64(F64::from_bits(address as _))],&mut ret_val)?;
        },
        wasmi_core::ValType::I32 => {
            let a = bigint_to_word32_wrap
                .expect("No bigint_to_word32_wrap function")
                .call(store, &[Val::I32(address as i32), Val::I32(2097319)],&mut ret_val);
            println!("bigint_to_word32_wrap: {:?}",a);
            a?
        },
        wasmi_core::ValType::I64 => {
            let a = bigint_to_word64_wrap
                .expect("No bigint_to_word64_wrap function")
                .call(store, &[Val::I64(address as i64)],&mut ret_val);
            println!("bigint_to_word64_wrap: {:?}",a);
            a?
        },
        _ => {
            return Err(Error::msg(format!("Unsupported value type: {:?}", val_type)));
        }
    };
    Ok(format!("{:?}", ret_val[0]))
}

fn handle_mut_box(
    memory: &[u8],
    address: u64, 
) -> Result<String, Error> {
    let len = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        TAG_OFFSET + DATA_OFFSET
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;
    Ok(format!("{:?}", len))
}
 
fn handle_f64(
    memory: &[u8],
    address: u64,
) -> Result<String, Error> {
    let loaded_value = load_f64_from_heap(memory, address, TAG_OFFSET + DATA_OFFSET)?;
    Ok(format!("{:?}", f64::from_bits(loaded_value.to_bits())))
}

fn handle_f32(
    memory: &[u8],
    address: u64,
) -> Result<String, Error> {
    let loaded_value = load_f32_from_heap(memory, address, TAG_OFFSET + DATA_OFFSET)?;
    Ok(format!("{:?}", f32::from_bits(loaded_value.to_bits() as u32)))
}
 
fn handle_blob_text(
    memory: &[u8],
    address: u64,
) -> Result<String, Error> {
    let len = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        TAG_OFFSET + DATA_OFFSET
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;
    let mut ret = String::new();

    for i in 0..len.to_bits() {
        let loaded_char = UntypedVal::i32_load8_u(
            memory, 
            UntypedVal::from(address), 
            TAG_OFFSET + ARRAY_VAR_T_DATA_OFFSET + i as u32
        ).map_err(|e| Error::msg(format!("{:?}", e)))?;
        ret.push(char::from(loaded_char.to_bits() as u8));
    }
    Ok(ret)
}

fn handle_concat(
    memory: &[u8],
    address: u64,
    executor: Ref<'_, Executor>,
    store: &mut Store<WasiCtx>,
) -> Result<String, Error> {
    let len = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        TAG_OFFSET + DATA_OFFSET
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;
    println!("len: {:?}", len);

    let text1 = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        TAG_OFFSET + ARRAY_VAR_T_DATA_OFFSET
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;

    let text2 = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        TAG_OFFSET + ARRAY_VAR_T_DATA_OFFSET + 4
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;

    let text1_str = display_local_in_heap(
        Ref::<'_, Executor<'_>>::clone(&executor), 
        store, 
        text1.to_bits(), 
        wasmi_core::ValType::I32, 
        None, 
        None, 
        None
    )?;

    let text2_str = display_local_in_heap(
        Ref::<'_, Executor<'_>>::clone(&executor), 
        store, 
        text2.to_bits(), 
        wasmi_core::ValType::I32, 
        None, 
        None, 
        None
    )?;
    Ok(format!("{}{}", text1_str, text2_str))
}

#[allow(dead_code)]
fn handle_object(
    memory: &[u8],
    address: u64, 
    val_type: wasmi_core::ValType,
    executor: Ref<'_, Executor>,
    store: &mut Store<WasiCtx>,
    bigint_to_float64: Option<Func>,
    bigint_to_word64_wrap: Option<Func>,
    bigint_to_word32_wrap: Option<Func>,
) -> Result<String, Error> {
    let len = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        TAG_OFFSET + DATA_OFFSET
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;


    for i in 0..len.to_bits() {
        let s = display_local_in_heap(
            Ref::<'_, Executor<'_>>::clone(&executor),  
            store, 
            address + TAG_OFFSET as u64 + DATA_OFFSET as u64 + 4 as u64 + i * 4 as u64, 
            val_type,
            bigint_to_float64,  
            bigint_to_word64_wrap, 
            bigint_to_word32_wrap,
        )?;
        println!("s: {:?}", s);
    }

    Ok(format!("handle_object: {:?}", len))
}

fn load_from_heap(
    memory: &[u8],
    address: u64,
    offset: u32,
    val_type: wasmi_core::ValType
) -> Result<UntypedVal, Error> {
    match val_type {
        wasmi_core::ValType::I32 => load_i32_from_heap(memory, address, offset),
        wasmi_core::ValType::I64 => load_i64_from_heap(memory, address, offset),
        wasmi_core::ValType::F32 => load_f32_from_heap(memory, address, offset),
        wasmi_core::ValType::F64 => load_f64_from_heap(memory, address, offset),
        _ => Err(Error::msg(format!("Unsupported heap type: {:?}", val_type))),
    }
}

fn load_i32_from_heap(
    memory: &[u8],
    address: u64,
    offset: u32
) -> Result<UntypedVal, Error> {
    let loaded_value = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        offset
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;
    Ok(loaded_value)
}

fn load_i64_from_heap(
    memory: &[u8],
    address: u64,
    offset: u32
) -> Result<UntypedVal, Error> {
    let loaded_value = UntypedVal::i64_load(
        memory, 
        UntypedVal::from(address), 
        offset
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;
    Ok(loaded_value)
}

fn load_f32_from_heap(
    memory: &[u8],
    address: u64,
    offset: u32
) -> Result<UntypedVal, Error> {
    let loaded_value = UntypedVal::f32_load(
        memory, 
        UntypedVal::from(address), 
        offset
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;
    Ok(loaded_value)
}

fn load_f64_from_heap(
    memory: &[u8],
    address: u64,
    offset: u32
) -> Result<UntypedVal, Error> {
    let loaded_value = UntypedVal::f64_load(
        memory, 
        UntypedVal::from(address), 
        offset
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;
    Ok(loaded_value)
}



fn get_heap_type_size(val_type: wasmi_core::ValType) -> u32 {
    match val_type {
        wasmi_core::ValType::I32 => 4,
        wasmi_core::ValType::I64 => 8,
        wasmi_core::ValType::F32 => 4,
        wasmi_core::ValType::F64 => {println!("get f64 333"); 8},
        _ => panic!("Unsupported value type: {:?}", val_type),
    }
}

fn display_wasm_val(
    val: UntypedVal, 
    val_type: wasmi_core::ValType, 
    is_float: bool,

    executor: Ref<'_, Executor>,
    store: &mut Store<WasiCtx>,
    bigint_to_float64: Option<Func>,
    bigint_to_word64_wrap: Option<Func>,
    bigint_to_word32_wrap: Option<Func>,
) -> Result<String, Error> {
    if val.to_bits() & 1 == 0 && !is_float {
        println!("lsb is 1, {:?}, type {:?}", val, val_type);
        let val = UntypedVal::from(val.to_bits() >> 1);
        match val_type {
            wasmi_core::ValType::I32 => Ok(format!("{}", i32::from(val))),
            wasmi_core::ValType::I64 => Ok(format!("{}", i64::from(val))),
            wasmi_core::ValType::F32 => Ok(format!("{}", f32::from(val))),
            wasmi_core::ValType::F64 => Ok(format!("{}", f64::from(val))),
            _ => panic!("Unsupported value type: {:?}", val_type),
        }
    } else {
        println!("lsb is 0, {:?}", val);
        match display_local_in_heap(
            executor, 
            store, 
            val.to_bits(), 
            val_type, 
            bigint_to_float64, 
            bigint_to_word64_wrap, 
            bigint_to_word32_wrap
        ) {
            std::result::Result::Ok(ret) => Ok(ret),
            Err(_) => Ok(format!("{}", f64::from_bits(val.to_bits()))),
        }
    }
}
