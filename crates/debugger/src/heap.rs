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
use anyhow::Error;
use wasmi::{engine::executor::instrs::Executor, Func, Store, Val};
use wasmi_core::{UntypedVal, F64};
use wasmi_wasi::WasiCtx;

const TAG_OFFSET: u32 = 1;
const DATA_OFFSET: u32 = 8;

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

impl From<u64> for Tagged {
    fn from(value: u64) -> Self {
        match value {
            1 => Tagged::Object,
            3 => Tagged::ArrayT,
            5 => Tagged::ArrayVarT,
            7 => Tagged::ArrayTuple,
            9 => Tagged::ArrayShared,
            11 => Tagged::Bits64Signed,
            13 => Tagged::Bits64Unsigned,
            15 => Tagged::Bits64Float,
            17 => Tagged::MutBox,
            19 => Tagged::Closure,
            21 => Tagged::Some,
            23 => Tagged::Variant,
            25 => Tagged::BlobBlob,
            27 => Tagged::BlobText,
            29 => Tagged::BlobPrincipal,
            31 => Tagged::BlobActor,
            33 => Tagged::Indirection,
            35 => Tagged::BigInt,
            37 => Tagged::Concat,
            39 => Tagged::Region,
            41 => Tagged::Bits32Signed,
            43 => Tagged::Bits32Unsigned,
            45 => Tagged::Bits32Float,
            47 => Tagged::Null,
            49 => Tagged::OneWordFiller,
            51 => Tagged::FreeSpace,
            52 => Tagged::ArraySliceMinimum,
            0xffff_fffe => Tagged::CoercionFailure,
            0xffff_ffff => Tagged::StableSeen,
            _ => panic!("Unknown tag value: {}", value),
        }
    }
}

pub fn display_local_in_heap(
    executor: Ref<'_, Executor>, 
    store: &mut Store<WasiCtx>, 
    address : u64, 
    val_type: wasmi_core::ValType,

    bigint_to_float64: Option<Func>,
    bigint_to_word64_wrap: Option<Func>,
    bigint_to_word32_wrap: Option<Func>,

) -> Result<String, Error> {
    let memory = wasmi_ir::index::Memory::from(0);
    let memory = executor.fetch_memory_bytes(memory, &store.inner);
    let loaded_value = load_i32_from_heap(
        memory, 
        address, 
        TAG_OFFSET
    )?;

    let ret = match Tagged::from(loaded_value.to_bits()) {
        Tagged::ArrayVarT  => handle_array_var_t(&memory, address, val_type)?,
        Tagged::BigInt => handle_bigint(
            store,
            address, 
            val_type, 
            bigint_to_float64, 
            bigint_to_word64_wrap,
             bigint_to_word32_wrap)?,
        _  => format!("HeapAddress: {}, {:?}", address, val_type),
    };
    Ok(ret)
}

fn handle_array_var_t(
    memory: &[u8],
    address: u64, 
    val_type: wasmi_core::ValType
) -> Result<String, Error> {
    let len = UntypedVal::i32_load(
        memory, 
        UntypedVal::from(address), 
        5
    ).map_err(|e| Error::msg(format!("{:?}", e)))?;

    let mut ret = String::new();
    ret.push_str("[");
    let len = len.to_bits() as u32;
    for i in 0..len {
        let loaded_value = load_from_heap(
            memory, 
            address, 
            TAG_OFFSET + DATA_OFFSET + i * get_heap_type_size(val_type),
            val_type
        )?;
        ret.push_str(&format!("{}, ", display_wasm_val(loaded_value, val_type)));
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
            bigint_to_word32_wrap
                .expect("No bigint_to_word32_wrap function")
                .call(store, &[Val::I32(address as i32)],&mut ret_val)?;
        },
        wasmi_core::ValType::I64 => {
            bigint_to_word64_wrap
                .expect("No bigint_to_word64_wrap function")
                .call(store, &[Val::I64(address as i64)],&mut ret_val)?;
        },
        _ => {
            return Err(Error::msg(format!("Unsupported value type: {:?}", val_type)));
        }
    };
    Ok(format!("{:?}", ret_val[0]))
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
        wasmi_core::ValType::F64 => 8,
        _ => panic!("Unsupported value type: {:?}", val_type),
    }
}

fn display_wasm_val(val: UntypedVal, val_type: wasmi_core::ValType) -> String {
    let val = if val.to_bits() & 1 == 0 {
         UntypedVal::from(val.to_bits() >> 1)
    } else {
        val
    };

    match val_type {
        wasmi_core::ValType::I32 => format!("{}", i32::from(val)),
        wasmi_core::ValType::I64 => format!("{}", i64::from(val)),
        wasmi_core::ValType::F32 => format!("{}", f32::from(val)),
        wasmi_core::ValType::F64 => format!("{}", f64::from(val)),
        _ => panic!("Unsupported value type: {:?}", val_type),
    }
}
