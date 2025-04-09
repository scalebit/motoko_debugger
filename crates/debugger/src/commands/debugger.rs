use anyhow::Error;
use anyhow::Result;

use wasmi::{
    engine::executor::instrs::ModuleIndex,
    Val,
};
use wasmi_core::UntypedVal;

#[derive(Default, Clone)]
pub struct DebuggerOpts {
    pub watch_memory: bool,
}

pub enum Breakpoint {
    Function { name: String },
    Instruction { inst_offset: usize },
}

pub enum RunResult {
    Finish(Vec<Val>),
    Breakpoint,
    Next, // Only for step
}

#[derive(Clone, Copy)]
pub enum StepStyle {
    InstIn,
    InstOver,
    Out,
}

pub struct FunctionFrame {
    pub module_index: ModuleIndex,
    pub argument_count: usize,
}

pub trait OutputPrinter {
    fn println(&self, _: &str);
    fn eprintln(&self, _: &str);
}
// pub type RawHostModule = std::collections::HashMap<String, HostValue>;

pub trait Debugger {
    fn get_opts(&self) -> DebuggerOpts;
    fn set_opts(&mut self, opts: DebuggerOpts);

    /// Creates a new [`Context`].
    ///
    /// # Errors
    ///
    /// - If parsing, validating, compiling or instantiating the Wasm module failed.
    /// - If adding WASI defintions to the linker failed.
    fn instantiate(&mut self, inst_in_file_0: Vec<u64>) -> Result<(), Error>;

    fn run(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<RunResult>;
    fn is_running(&self) -> bool;
    fn frame(&self) -> Vec<String>;
    // fn current_frame(&self) -> Option<FunctionFrame>;
    fn locals(&self) -> Result<(u32, String ,Vec<(u32, String, String)>)>;
    // fn memory(&self) -> Result<Vec<u8>>;
    // fn store(&self) -> Result<&Store>;
    fn global(&self, name: &str) -> Option<Val>;
    fn set_breakpoint(&mut self, breakpoint: Breakpoint);
    fn list_breakpoints(&self) -> Vec<&Breakpoint>;
    fn delete_breakpoint(&mut self, id: usize) -> Result<(), anyhow::Error>;
    fn stack_values(&self) -> Vec<UntypedVal>;
    fn selected_instr_offset(&self) -> Result<Option<usize>>;
    fn step(&mut self, style: StepStyle) -> Result<RunResult>;
    fn process(&mut self) -> Result<RunResult>;
    fn select_frame(&mut self, frame_index: Option<usize>) -> Result<()>;
}
