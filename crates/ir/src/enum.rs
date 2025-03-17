use crate::{core::TrapCode, for_each_op, index::*, *};
use ::core::num::{NonZeroI32, NonZeroI64, NonZeroU32, NonZeroU64};
use ::std::vec::Vec;
macro_rules! define_enum {
    (
        $(
            $( #[doc = $doc:literal] )*
            #[snake_name($snake_name:ident)]
            $name:ident
            $(
                {
                    $(
                        @ $result_name:ident: $result_ty:ty,
                    )?
                    $(
                        $( #[$field_docs:meta] )*
                        $field_name:ident: $field_ty:ty
                    ),*
                    $(,)?
                }
            )?
        ),* $(,)?
    ) => {
        /// A Wasmi instruction.
        ///
        /// Wasmi instructions are composed of so-called instruction words.
        /// This type represents all such words and for simplicity we call the type [`Instruction`], still.
        ///
        /// Most instructions are composed of a single instruction word. An example of
        /// this is [`Instruction::I32Add`]. However, some instructions, like
        /// [`Instruction::Select`], are composed of two or more instruction words.
        ///
        /// The Wasmi bytecode translation makes sure that instructions always appear in valid sequences.
        /// The Wasmi executor relies on the guarantees that the Wasmi translator provides.
        ///
        /// The documentation of each [`Instruction`] describes its encoding in the
        /// `#Encoding` section of its documentation if it requires more than a single
        /// instruction for its encoding.
        #[derive(Debug, Copy, Clone, PartialEq, Eq)]
        #[repr(u16)]
        pub enum Instruction {
            $(
                $( #[doc = $doc] )*
                $name
                {
                    instr_offset: usize,
                    $(
                        $(
                            /// The register(s) storing the result of the instruction.
                            $result_name: $result_ty,
                        )?
                        $(
                            $( #[$field_docs] )*
                            $field_name: $field_ty
                        ),*
                    )?
                }
                
            ),*
        }

        impl Instruction {
            $(
                #[doc = concat!("Creates a new [`Instruction::", stringify!($name), "`].")]
                pub fn $snake_name(
                    $(
                        $( $result_name: impl Into<$result_ty>, )?
                        $( $field_name: impl Into<$field_ty> ),*
                    )?
                ) -> Self {
                    Self::$name {
                        instr_offset: 0,
                        $(
                            $( $result_name: $result_name.into(), )?
                            $( $field_name: $field_name.into() ),*
                        )?
                    }
                }
            )*

            pub fn set_offset_direct(&mut self, value: usize) {
                use std::ptr;
                unsafe {
                    let ptr1 = self as *mut Instruction; // 获取枚举的原始指针
                    let data_ptr = ptr1 as *mut usize; // 将指针转换为指向 u32 的指针
        
                    // 写入新的 u32 值
                    ptr::write(data_ptr, value);
                }
            }
        }
    };
}
for_each_op::for_each_op!(define_enum);

use wasmi_inst_macro::*;
use wasmparser::{for_each_operator, BrTable, OperatorsReader};

pub struct ZaxInstruction {
    pub kind: InstructionKind,
    pub offset: usize,
}

#[derive(Debug, Clone)]
pub struct BrTableData {
    pub table: Vec<u32>,
    pub default: u32,
}

trait WasmInstPayloadFrom<T>: Sized {
    type Error;
    fn from_payload(_: T) -> Result<Self, Self::Error>;
}

impl<T, U> WasmInstPayloadFrom<T> for U
where
    U: From<T>,
{
    type Error = wasmparser::BinaryReaderError;
    fn from_payload(from: T) -> Result<U, Self::Error> {
        Ok(From::<T>::from(from))
    }
}

impl WasmInstPayloadFrom<BrTable<'_>> for BrTableData {
    type Error = wasmparser::BinaryReaderError;
    fn from_payload(table: BrTable) -> Result<Self, Self::Error> {
        Ok(BrTableData {
            table: table.targets().collect::<Result<Vec<_>, _>>()?,
            default: table.default(),
        })
    }
}

for_each_operator!(define_instr_kind);

pub fn transform_inst(
    reader: &mut OperatorsReader,
    base_offset: usize,
) -> anyhow::Result<ZaxInstruction> {
    let (op, offset) = reader.read_with_offset()?;
    let kind = TryFrom::try_from(op)?;
    Ok(ZaxInstruction {
        kind,
        offset: offset - base_offset,
    })
}

impl Instruction {
    /// Creates a new [`Instruction::ReturnReg2`] for the given [`Reg`] indices.
    pub fn return_reg2_ext(reg0: impl Into<Reg>, reg1: impl Into<Reg>) -> Self {
        Self::return_reg2([reg0.into(), reg1.into()])
    }

    /// Creates a new [`Instruction::ReturnReg3`] for the given [`Reg`] indices.
    pub fn return_reg3_ext(
        reg0: impl Into<Reg>,
        reg1: impl Into<Reg>,
        reg2: impl Into<Reg>,
    ) -> Self {
        Self::return_reg3([reg0.into(), reg1.into(), reg2.into()])
    }

    /// Creates a new [`Instruction::ReturnMany`] for the given [`Reg`] indices.
    pub fn return_many_ext(
        reg0: impl Into<Reg>,
        reg1: impl Into<Reg>,
        reg2: impl Into<Reg>,
    ) -> Self {
        Self::return_many([reg0.into(), reg1.into(), reg2.into()])
    }

    /// Creates a new [`Instruction::ReturnNezReg2`] for the given `condition` and `value`.
    pub fn return_nez_reg2_ext(
        condition: impl Into<Reg>,
        value0: impl Into<Reg>,
        value1: impl Into<Reg>,
    ) -> Self {
        Self::return_nez_reg2(condition, [value0.into(), value1.into()])
    }

    /// Creates a new [`Instruction::ReturnNezMany`] for the given `condition` and `value`.
    pub fn return_nez_many_ext(
        condition: impl Into<Reg>,
        head0: impl Into<Reg>,
        head1: impl Into<Reg>,
    ) -> Self {
        Self::return_nez_many(condition, [head0.into(), head1.into()])
    }

    /// Creates a new [`Instruction::Copy2`].
    pub fn copy2_ext( results: RegSpan, value0: impl Into<Reg>, value1: impl Into<Reg>) -> Self {
        let span = FixedRegSpan::new(results).unwrap_or_else(|_| {
            panic!("encountered invalid `results` `RegSpan` for `Copy2`: {results:?}")
        });
        Self::copy2(span, [value0.into(), value1.into()])
    }

    /// Creates a new [`Instruction::CopyMany`].
    pub fn copy_many_ext(results: RegSpan, head0: impl Into<Reg>, head1: impl Into<Reg>) -> Self {
        Self::copy_many(results, [head0.into(), head1.into()])
    }

    /// Creates a new [`Instruction::CopyManyNonOverlapping`].
    pub fn copy_many_non_overlapping_ext(
        results: RegSpan,
        head0: impl Into<Reg>,
        head1: impl Into<Reg>,
    ) -> Self {
        Self::copy_many_non_overlapping(results, [head0.into(), head1.into()])
    }

    /// Creates a new [`Instruction::Register2`] instruction parameter.
    pub fn register2_ext(reg0: impl Into<Reg>, reg1: impl Into<Reg>) -> Self {
        Self::register2([reg0.into(), reg1.into()])
    }

    /// Creates a new [`Instruction::Register3`] instruction parameter.
    pub fn register3_ext(reg0: impl Into<Reg>, reg1: impl Into<Reg>, reg2: impl Into<Reg>) -> Self {
        Self::register3([reg0.into(), reg1.into(), reg2.into()])
    }

    /// Creates a new [`Instruction::RegisterList`] instruction parameter.
    pub fn register_list_ext(
        reg0: impl Into<Reg>,
        reg1: impl Into<Reg>,
        reg2: impl Into<Reg>,
    ) -> Self {
        Self::register_list([reg0.into(), reg1.into(), reg2.into()])
    }
}

#[test]
fn size_of() {
    // Note: In case this test starts failing:
    //
    // There currently is a bug in the Rust compiler that causes
    // Rust `enum` definitions with `#[repr(uN)]` to be incorrectly
    // sized: https://github.com/rust-lang/rust/issues/53657
    //
    // Until that bug is fixed we need to order the `enum` variant
    // fields in a precise order to end up with the correct `enum` size.
    assert_eq!(::core::mem::size_of::<Instruction>(), 8);
    assert_eq!(::core::mem::align_of::<Instruction>(), 4);
}
