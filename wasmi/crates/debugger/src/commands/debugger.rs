use anyhow::Result;
use anyhow::{anyhow, Error};
use std::path::Path;
// use wasminspect_vm::{HostValue, Instruction, ModuleIndex, Signal, Store, WasmValue};
use wasmi::{Val, engine::executor::instrs::{Signal, ModuleIndex}};
// use wasmi::{Val, engine::executor::instrs::{Signal, ExecResult, ModuleIndex, Executor, Interceptor}};
use wasmi_ir::{Instruction};
use wasmi::{CompilationMode, Config, ExternType, Func, FuncType, Instance, Module, Store};
use wasmi_wasi::WasiCtx;

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
    fn instantiate(
        &mut self, 
        wasm_file: &Path,
        wasi_ctx: WasiCtx,
        fuel: Option<u64>,
        compilation_mode: CompilationMode,
    ) -> Result<u32, Error>;

    // fn run(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<RunResult>;
    fn is_running(&self) -> bool;
    fn frame(&self) -> Vec<String>;
    // fn current_frame(&self) -> Option<FunctionFrame>;
    fn locals(&self) -> Vec<Val>;
    // fn memory(&self) -> Result<Vec<u8>>;
    // fn store(&self) -> Result<&Store>;
    fn set_breakpoint(&mut self, breakpoint: Breakpoint);
    fn stack_values(&self) -> Vec<Val>;
    fn selected_instructions(&self) -> Result<(&[Instruction], usize)>;
    fn step(&self, style: StepStyle) -> Result<Signal>;
    fn process(&mut self) -> Result<RunResult>;
    fn select_frame(&mut self, frame_index: Option<usize>) -> Result<()>;
}
