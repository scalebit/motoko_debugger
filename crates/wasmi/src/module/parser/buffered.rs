
use super::{
    CustomSectionsBuilder, ModuleBuilder, ModuleHeader, ModuleHeaderBuilder, ModuleParser,
};
use crate::{Error, Module};
use wasmparser::{Chunk, Payload, Validator};

impl ModuleParser {
    /// Starts parsing and validating the Wasm bytecode stream.
    ///
    /// Returns the compiled and validated Wasm [`Module`] upon success.
    ///
    /// # Errors
    ///
    /// If the Wasm bytecode stream fails to validate.
    pub fn parse_buffered(mut self, buffer: &[u8]) -> Result<Module, Error> {
        let features = self.engine.config().wasm_features();
        self.validator = Some(Validator::new_with_features(features));
        // SAFETY: we just pre-populated the Wasm module parser with a validator
        //         thus calling this method is safe.
        unsafe { self.parse_buffered_impl(buffer) }
    }

    /// Starts parsing and validating the Wasm bytecode stream.
    ///
    /// Returns the compiled and validated Wasm [`Module`] upon success.
    ///
    /// # Safety
    ///
    /// The caller is responsible to make sure that the provided
    /// `stream` yields valid WebAssembly bytecode.
    ///
    /// # Errors
    ///
    /// If the Wasm bytecode stream fails to validate.
    pub unsafe fn parse_buffered_unchecked(self, buffer: &[u8]) -> Result<Module, Error> {
        unsafe { self.parse_buffered_impl(buffer) }
    }

    /// Starts parsing and validating the Wasm bytecode stream.
    ///
    /// Returns the compiled and validated Wasm [`Module`] upon success.
    ///
    /// # Safety
    ///
    /// The caller is responsible to either
    ///
    /// 1) Populate the [`ModuleParser`] with a [`Validator`] prior to calling this method, OR;
    /// 2) Make sure that the provided `stream` yields valid WebAssembly bytecode.
    ///
    /// Otherwise this method has undefined behavior.
    ///
    /// # Errors
    ///
    /// If the Wasm bytecode stream fails to validate.
    unsafe fn parse_buffered_impl(mut self, mut buffer: &[u8]) -> Result<Module, Error> {
        let mut custom_sections = CustomSectionsBuilder::default();
        let mut code_section_base_offset: Option<usize> = None;
        let header = Self::parse_buffered_header(
            &mut self,
            &mut buffer,
            &mut custom_sections,
            &mut code_section_base_offset,
        )?;
        let builder = Self::parse_buffered_code(
            &mut self,
            &mut buffer,
            header,
            custom_sections,
            code_section_base_offset,
        )?;
        let module = Self::parse_buffered_data(&mut self, &mut buffer, builder)?;
        Ok(module)
    }

    /// Fetch next Wasm module payload and adust the `buffer`.
    ///
    /// # Errors
    ///
    /// If the parsed Wasm is malformed.
    fn next_payload<'a>(&mut self, buffer: &mut &'a [u8]) -> Result<(usize, Payload<'a>), Error> {
        match self.parser.parse(&buffer[..], true)? {
            Chunk::Parsed { consumed, payload } => Ok((consumed, payload)),
            Chunk::NeedMoreData(_hint) => {
                // This is not possible since `eof` is always true.
                unreachable!()
            }
        }
    }

    /// Consumes the parts of the buffer that have been processed.
    fn consume_buffer<'a>(consumed: usize, buffer: &mut &'a [u8]) -> &'a [u8] {
        let (consumed, remaining) = buffer.split_at(consumed);
        *buffer = remaining;
        consumed
    }

    /// Parse the Wasm module header.
    ///
    /// - The Wasm module header is the set of all sections that appear before
    ///   the Wasm code section.
    /// - We separate parsing of the Wasm module header since the information of
    ///   the Wasm module header is required for translating the Wasm code section.
    ///
    /// # Errors
    ///
    /// If the Wasm bytecode stream fails to parse or validate.
    fn parse_buffered_header(
        &mut self,
        buffer: &mut &[u8],
        custom_sections: &mut CustomSectionsBuilder,
        code_section_base_offset: &mut Option<usize>,
    ) -> Result<ModuleHeader, Error> {
        let mut header = ModuleHeaderBuilder::new(&self.engine);
        loop {
            let (consumed, payload) = self.next_payload(buffer)?;
            match payload {
                Payload::Version {
                    num,
                    encoding,
                    range,
                } => self.process_version(num, encoding, range),
                Payload::TypeSection(section) => self.process_types(section, &mut header),
                Payload::ImportSection(section) => self.process_imports(section, &mut header),
                Payload::FunctionSection(section) => self.process_functions(section, &mut header),
                Payload::TableSection(section) => self.process_tables(section, &mut header),
                Payload::MemorySection(section) => self.process_memories(section, &mut header),
                Payload::GlobalSection(section) => self.process_globals(section, &mut header),
                Payload::ExportSection(section) => self.process_exports(section, &mut header),
                Payload::StartSection { func, range } => {
                    self.process_start(func, range, &mut header)
                }
                Payload::ElementSection(section) => self.process_element(section, &mut header),
                Payload::DataCountSection { count, range } => self.process_data_count(count, range),
                Payload::CodeSectionStart { count, range, size } => {
                    *code_section_base_offset = Some(range.start.clone());
                    self.process_code_start(count, range, size)?;
                    Self::consume_buffer(consumed, buffer);
                    break;
                }
                Payload::DataSection(_) => {
                    break;
                }
                Payload::End(_) => {
                    break;
                }
                Payload::CustomSection(reader) => {
                    self.process_custom_section(custom_sections, None, reader)
                }
                unexpected => self.process_invalid_payload(unexpected),
            }?;
            Self::consume_buffer(consumed, buffer);
        }
        Ok(header.finish())
    }

    /// Parse the Wasm code section entries.
    ///
    /// We separate parsing of the Wasm code section since most of a Wasm module
    /// is made up of code section entries which we can parse and validate more efficiently
    /// by serving them with a specialized routine.
    ///
    /// # Errors
    ///
    /// If the Wasm bytecode stream fails to parse or validate.
    fn parse_buffered_code(
        &mut self,
        buffer: &mut &[u8],
        header: ModuleHeader,
        custom_sections: CustomSectionsBuilder,
        code_section_base_offset: Option<usize>,
    ) -> Result<ModuleBuilder, Error> {
        loop {
            let (consumed, payload) = self.next_payload(buffer)?;
            match payload {
                Payload::CodeSectionEntry(func_body) => {
                    // Note: Unfortunately the `wasmparser` crate is missing an API
                    //       to return the byte slice for the respective code section
                    //       entry payload. Please remove this work around as soon as
                    //       such an API becomes available.
                    let bytes = Self::consume_buffer(consumed, buffer);
                    let remaining = func_body.get_binary_reader().bytes_remaining();
                    let start = consumed - remaining;
                    let bytes = &bytes[start..];
                    self.process_code_entry(func_body, bytes, &header, code_section_base_offset)?;
                }
                _ => break,
            }
        }
        Ok(ModuleBuilder::new(header, custom_sections))
    }

    /// Parse the Wasm data section and finalize parsing.
    ///
    /// We separate parsing of the Wasm data section since it is the only Wasm
    /// section that comes after the Wasm code section that we have to separate
    /// out for technical reasons.
    ///
    /// # Errors
    ///
    /// If the Wasm bytecode stream fails to parse or validate.
    fn parse_buffered_data(
        &mut self,
        buffer: &mut &[u8],
        mut builder: ModuleBuilder,
    ) -> Result<Module, Error> {
        loop {
            let (consumed, payload) = self.next_payload(buffer)?;
            match payload {
                Payload::DataSection(section) => {
                    self.process_data(section, &mut builder)?;
                }
                Payload::End(offset) => {
                    self.process_end(offset)?;
                    break;
                }
                Payload::CustomSection(reader) => {
                    self.process_custom_section(&mut builder.custom_sections, Some(&builder.header), reader)?;
                }
                invalid => self.process_invalid_payload(invalid)?,
            }
            Self::consume_buffer(consumed, buffer);
        }
        Ok(builder.finish(&self.engine))
    }
}
