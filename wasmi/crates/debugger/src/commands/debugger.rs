use anyhow::Error;
use anyhow::Result;

// use wasminspect_vm::{HostValue, Instruction, ModuleIndex, Signal, Store, WasmValue};
use wasmi::{
    engine::executor::instrs::{ModuleIndex, Signal},
    Val,
};
// use wasmi::{Val, engine::executor::instrs::{Signal, ExecResult, ModuleIndex, Executor, Interceptor}};

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
    fn instantiate(&mut self) -> Result<(), Error>;

    fn run(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<RunResult>;
    fn is_running(&self) -> bool;
    fn frame(&self) -> Vec<String>;
    // fn current_frame(&self) -> Option<FunctionFrame>;
    // fn locals(&self) -> Vec<Val>;
    // fn memory(&self) -> Result<Vec<u8>>;
    // fn store(&self) -> Result<&Store>;
    fn set_breakpoint(&mut self, breakpoint: Breakpoint);
    // fn stack_values(&self) -> Vec<Val>;
    // fn selected_instructions(&self) -> Result<(&[Instruction], usize)>;
    fn step(&self, style: StepStyle) -> Result<Signal>;
    fn process(&self) -> Result<RunResult>;
    fn select_frame(&mut self, frame_index: Option<usize>) -> Result<()>;
}
