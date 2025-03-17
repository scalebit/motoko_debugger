use std::{eprintln, println};

use crate::{
    engine::{code_map::CompiledFuncEntity, WasmTranslator},
    Error,
};
use wasmparser::FunctionBody;

/// Translates Wasm bytecode into Wasmi bytecode for a single Wasm function.
pub struct FuncTranslationDriver<'parser, T> {
    /// The function body that shall be translated.
    func_body: FunctionBody<'parser>,
    /// The bytes that make up the entirety of the function body.
    bytes: &'parser [u8],
    /// Offset of code start section, for calu instr offset
    base_offset: usize,
    /// The underlying translator used for the translation (and validation) process.
    translator: T,
}

impl<'parser, T> FuncTranslationDriver<'parser, T> {
    /// Creates a new Wasm to Wasmi bytecode function translator.
    pub fn new(
        offset: impl Into<Option<usize>>,
        bytes: &'parser [u8],
        code_section_base_offset: Option<usize>,
        translator: T,
    ) -> Result<Self, Error> {
        let offset = offset.into().unwrap_or(0);
        let func_body = FunctionBody::new(offset, bytes);
        let base_offset = if let Some(offset) = code_section_base_offset {
            offset
        } else {
            0
        };
        Ok(Self {
            func_body,
            bytes,
            base_offset,
            translator,
        })
    }
}

impl<'parser, T> FuncTranslationDriver<'parser, T>
where
    T: WasmTranslator<'parser>,
{
    /// Starts translation of the Wasm stream into Wasmi bytecode.
    pub fn translate(
        mut self,
        finalize: impl FnOnce(CompiledFuncEntity),
    ) -> Result<T::Allocations, Error> {
        if self.translator.setup(self.bytes)? {
            let allocations = self.translator.finish(finalize)?;
            return Ok(allocations);
        }
        self.translate_locals()?;
        let offset = self.translate_operators()?;
        // println!("func offest, {}, self.base_offset {}", offset - self.base_offset, self.base_offset);
        let allocations = self.finish(offset, finalize)?;
        Ok(allocations)
    }

    /// Finishes construction of the function and returns its reusable allocations.
    fn finish(
        mut self,
        offset: usize,
        finalize: impl FnOnce(CompiledFuncEntity),
    ) -> Result<T::Allocations, Error> {
        self.translator.update_pos(offset);
        self.translator.finish(finalize).map_err(Into::into)
    }

    /// Translates local variables of the Wasm function.
    fn translate_locals(&mut self) -> Result<(), Error> {
        let mut reader = self.func_body.get_locals_reader()?;
        let len_locals = reader.get_count();
        for _ in 0..len_locals {
            let offset = reader.original_position();
            let (amount, value_type) = reader.read()?;
            self.translator.update_pos(offset);
            self.translator.translate_locals(amount, value_type)?;
        }
        self.translator.finish_translate_locals()?;
        Ok(())
    }

    /// Translates the Wasm operators of the Wasm function.
    ///
    /// Returns the offset of the `End` Wasm operator.
    fn translate_operators(&mut self) -> Result<usize, Error> {
        let mut reader = self.func_body.get_operators_reader()?;
        let mut before_len = self.translator.get_instr_encoder_len();
        while !reader.eof() {
            let pos = reader.original_position();
            self.translator.update_pos(pos);
            self.translator.update_visit_pos(pos - self.base_offset);
            reader.visit_operator(&mut self.translator)??;
            let after_len = self.translator.get_instr_encoder_len();
            if before_len != after_len {
                for _ in 0..after_len - before_len {
                    self.translator.push_instr_offset(pos - self.base_offset);
                }
                before_len = after_len;
            }
        }
        reader.ensure_end()?;
        Ok(reader.original_position())
    }
}
