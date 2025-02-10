use crate::commands::{backtrace, breakpoint};
// use crate::commands::debugger::{self, Debugger, DebuggerOpts, RawHostModule, RunResult};
use crate::commands::debugger::{self, Debugger, DebuggerOpts, RunResult};
use crate::func_instance::DefinedFunctionInstance;
use anyhow::{anyhow, Context, Error, Result};
use log::{trace, warn};
use std::collections::HashMap;
use std::path::Path;
use std::rc::Rc;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::{cell::RefCell, usize};
use wasmi::engine::executor::cache::CachedInstance;
use wasmi::engine::executor::instr_ptr::InstructionPtr;
use wasmi::engine::executor::EngineExecutor;
use wasmi::engine::CallResults;
use wasmi::engine::{CallParams, Stack};
use wasmi::{
    engine::executor::instrs::{ExecResult, Executor, Interceptor, ModuleIndex, Signal},
    func::FuncEntity,
    Val,
};
use wasmi_core::ValType;
use wasmi_ir::{Instruction, Reg, RegSpan};
use wasmparser::NameSectionReader;
// use cap_std::ambient_authority;
// use wasmparser::WasmFeatures;
use wasmi::{
    // collections::arena::ArenaIndex,
    core::UntypedVal,
    store::Stored,
    AsContextMut,
    StoreContext,
};
use wasmi_wasi::WasiCtx;

type RawModule = Vec<u8>;

use wasmi::engine::{
    code_map::CodeMap,
    executor::stack::{CallFrame, FrameRegisters, ValueStack},
    DedupFuncType, EngineFunc,
};
use wasmi::{
    CompilationMode, Config, Engine, Extern, ExternType, Func, FuncType, Instance, Module, Store,
};

pub struct MainDebugger {
    pub instance: Option<Instance>,

    main_module: Option<(RawModule, String)>,
    store: Option<Store<WasiCtx>>,
    stack: Option<Stack>,
    engine: Option<Engine>,
    opts: DebuggerOpts,
    preopen_dirs: Vec<(String, String)>,
    envs: Vec<(String, String)>,

    breakpoints: Breakpoints,
    is_interrupted: Arc<AtomicBool>,
    selected_frame: Option<usize>,
}

#[derive(Default)]
struct Breakpoints {
    function_map: HashMap<String, debugger::Breakpoint>,
    inst_map: HashMap<usize, debugger::Breakpoint>,
}

impl Breakpoints {
    fn should_break_func(&self, name: &str) -> bool {
        // FIXME
        self.function_map
            .keys()
            .any(|k| name.contains(Clone::clone(&k)))
    }

    fn should_break_inst(&self, inst: &Instruction) -> bool {
        // self.inst_map.contains_key(&inst.offset)
        true
    }

    fn insert(&mut self, breakpoint: debugger::Breakpoint) {
        match &breakpoint {
            debugger::Breakpoint::Function { name } => {
                self.function_map.insert(name.clone(), breakpoint);
            }
            debugger::Breakpoint::Instruction { inst_offset } => {
                self.inst_map.insert(*inst_offset, breakpoint);
            }
        }
    }
}

impl MainDebugger {
    pub fn load_main_module(&mut self, module: &[u8], name: String) -> Result<()> {
        if let Err(err) = wasmparser::validate(module) {
            warn!("{}", err);
            return Err(err.into());
        }
        self.main_module = Some((module.to_vec(), name));
        Ok(())
    }

    pub fn new(preopen_dirs: Vec<(String, String)>, envs: Vec<(String, String)>) -> Result<Self> {
        let is_interrupted = Arc::new(AtomicBool::new(false));
        signal_hook::flag::register(signal_hook::consts::SIGINT, Arc::clone(&is_interrupted))?;
        Ok(Self {
            instance: None,
            store: None,
            engine: None,
            stack: None,
            main_module: None,
            opts: DebuggerOpts::default(),
            breakpoints: Default::default(),
            is_interrupted,
            preopen_dirs,
            envs,
            selected_frame: None,
        })
    }

    // fn executor(&self) -> Result<Rc<RefCell<Executor>>> {
    //     let instance = self.instance()?;
    //     if let Some(ref executor) = instance.executor {
    //         Ok(executor.clone())
    //     } else {
    //         Err(anyhow::anyhow!("No execution context"))
    //     }
    // }

    fn instance(&self) -> Result<&Instance> {
        if let Some(ref instance) = self.instance {
            Ok(instance)
        } else {
            Err(anyhow::anyhow!("No instance"))
        }
    }

    pub fn lookup_func(&self, store: impl AsContextMut, name: &str) -> Func {
        self.instance.unwrap().get_func(&store, "").unwrap()
    }

    pub fn execute_func(&mut self, func: Func, params: &[Val]) -> Result<RunResult> {
        let store = self.store.as_mut().unwrap();
        let stack = self.stack.as_mut().expect("no stack");
        let code_map = self.engine.as_ref().expect("no engine").code_map();
        let func_type = func.ty(&store);

        let wasm_func = match store.inner.resolve_func(&func) {
            FuncEntity::Wasm(x) => x,
            _ => {
                return Err(anyhow!("not support host"));
            }
        };

        // We reserve space on the stack to write the results of the root function execution.
        stack
            .values
            .extend_by(func_type.len_results() as usize, |_self| {})
            .map_err(|e| anyhow::anyhow!(e))?;

        let instance = *wasm_func.instance();
        let engine_func = wasm_func.func_body();
        let compiled_func = code_map.get(None, engine_func)?;
        let (mut uninit_params, offsets) = stack
            .values
            .alloc_call_frame(compiled_func, |_self| {})
            .map_err(|e| anyhow::anyhow!(e))?;
        for value in params.call_params() {
            unsafe { uninit_params.init_next(value) };
        }
        uninit_params.init_zeroes();
        stack
            .calls
            .push(
                CallFrame::new(
                    InstructionPtr::new(compiled_func.instrs().as_ptr()),
                    offsets,
                    RegSpan::new(Reg::from(0)),
                ),
                Some(instance),
            )
            .map_err(|e| anyhow::anyhow!(e))?;

        let mut run_result: Vec<Val> = func_type
            .results()
            .iter()
            .map(|x| Val::default(x.clone()))
            .collect();
        self.process(Some(&mut run_result))
    }

    // fn selected_frame(&self) -> Result<CallFrame> {
    //     // let executor = self.executor()?;
    //     // let executor = executor.borrow();
    //     // if let Some(frame_index) = self.selected_frame {
    //         // if frame_index != 0 {
    //         //     let frame = executor.stack.frame_at(frame_index - 1).map_err(|_| {
    //         //         anyhow!("Frame index {} is out of range", frame_index - 1)
    //         //     })?;
    //         //     match frame.ret_pc {
    //         //         Some(pc) => return Ok(pc),
    //         //         None => {
    //         //             return Err(anyhow!("No return address, maybe main or host function?"));
    //         //         }
    //         //     };
    //         // }
    //     }
    //     Ok(executor.stack.calls.frames[0])
    // }
}

impl debugger::Debugger for MainDebugger {
    fn get_opts(&self) -> DebuggerOpts {
        self.opts.clone()
    }
    fn set_opts(&mut self, opts: DebuggerOpts) {
        self.opts = opts
    }

    fn select_frame(&mut self, frame_index: Option<usize>) -> Result<()> {
        self.selected_frame = frame_index;
        Ok(())
    }

    fn set_breakpoint(&mut self, breakpoint: debugger::Breakpoint) {
        self.breakpoints.insert(breakpoint)
    }

    // fn stack_values(&self) -> Vec<Val> {
    //     if let Ok(ref executor) = self.executor() {
    //         let executor = executor.borrow();
    //         let values = executor.stack.peek_values();
    //         let mut new_values = Vec::<Val>::new();
    //         for v in values {
    //             new_values.push(*v);
    //         }
    //         new_values
    //     } else {
    //         Vec::new()
    //     }
    // }

    // fn store(&self) -> Result<&Store> {
    //     let instance = self.instance()?;
    //     Ok(&instance.store)
    // }

    // fn locals(&self) -> Vec<Val> {
    //     if let Ok(ref executor) = self.executor() {
    //         let executor = executor.borrow();
    //         let frame_index = self.selected_frame.unwrap_or(0);
    //         if let Ok(frame) = executor.stack.frame_at(frame_index) {
    //             return frame.locals.clone()
    //         }
    //     }
    //     vec![]
    // }
    // fn current_frame(&self) -> Option<debugger::FunctionFrame> {
    //     let frame = self.selected_frame().ok()?;
    //     let func = match self.store() {
    //         Ok(store) => store.func_global(frame.exec_addr()),
    //         Err(_) => return None,
    //     };

    //     Some(debugger::FunctionFrame {
    //         module_index: frame.module_index(),
    //         argument_count: func.ty().params().len(),
    //     })
    // }
    // fn frame(&self) -> Vec<String> {
    //     let instance = if let Ok(instance) = self.instance() {
    //         instance
    //     } else {
    //         return vec![];
    //     };
    //     let executor = if let Some(executor) = instance.executor.clone() {
    //         executor
    //     } else {
    //         return vec![];
    //     };
    //     let executor = executor.borrow();
    //     let frames = executor.stack.peek_frames();
    //     return frames
    //         .iter()
    //         .map(|frame| instance.store.func_global(frame.exec_addr).name().clone())
    //         .collect();
    // }
    // fn memory(&self) -> Result<Vec<u8>> {
    //     let instance = self.instance()?;
    //     let store = &instance.store;
    //     if store.memory_count(instance.main_module_index) == 0 {
    //         return Ok(vec![]);
    //     }
    //     let addr = MemoryAddr::new_unsafe(instance.main_module_index, 0);
    //     Ok(store.memory(addr).borrow().raw_data().to_vec())
    // }

    fn is_running(&self) -> bool {
        // self.executor().is_ok()
        true
    }

    fn step(&self, style: debugger::StepStyle) -> Result<Signal> {
        // let store = self.store;
        // let executor = self.executor()?;
        // use debugger::StepStyle::*;

        // fn frame_depth(executor: &Executor) -> usize {
        //     // executor.stack.peek_frames().len()
        //     1
        // }
        // match style {
        //     InstIn => {
        //         return Ok(executor
        //             .borrow_mut()
        //             .execute_step(store)?)
        //     }
        //     InstOver => {
        //         let initial_frame_depth = frame_depth(&executor.borrow());
        //         let mut last_signal =
        //             executor
        //                 .borrow_mut()
        //                 .execute_step(store)?;
        //         while initial_frame_depth < frame_depth(&executor.borrow()) {
        //             last_signal = executor
        //                 .borrow_mut()
        //                 .execute_step(store)?;
        //             if let Signal::Breakpoint = last_signal {
        //                 return Ok(last_signal);
        //             }
        //         }
        //         Ok(last_signal)
        //     }
        //     Out => {
        //         let initial_frame_depth = frame_depth(&executor.borrow());
        //         let mut last_signal =
        //             executor
        //                 .borrow_mut()
        //                 .execute_step(store)?;
        //         while initial_frame_depth <= frame_depth(&executor.borrow()) {
        //             last_signal = executor
        //                 .borrow_mut()
        //                 .execute_step(store)?;
        //             if let Signal::Breakpoint = last_signal {
        //                 return Ok(last_signal);
        //             }
        //         }
        //         Ok(last_signal)
        //     }
        // }

        Ok(Signal::Next)
    }

    fn process(&mut self, results: Option<&mut [Val]>) -> Result<RunResult> {
        let store = self.store.as_mut().unwrap();
        // let ret_ty = func.ty(&store);
        // let ret_types = ret_ty.results();
        // let mut ret_slice: Vec<Val> = ret_types.iter().map(|x| Val::default(x.clone())).collect();
        // let res2_slice: &mut [Val] = &mut ret_slice;

        let stack = self.stack.as_mut().expect("no stack");
        let code_map = self.engine.as_ref().expect("no engine").code_map();
        let instance = stack.calls.instance_expect();
        let cache = CachedInstance::new(&mut store.inner, instance);
        let mut exec = Executor::new(stack, &code_map, cache);

        loop {
            match exec.execute_step(store)? {
                Signal::Next => continue,
                Signal::Breakpoint => return Ok(RunResult::Breakpoint),
                Signal::End => {
                    let results = results.expect("signal end but not got result array");
                    results.call_results(&stack.values.as_slice()[..results.len_results()]);
                    return Ok(RunResult::Finish(results.to_vec()));
                }
            }
        }
    }

    fn run(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<RunResult, Error> {
        let instance = self
            .instance
            .as_mut()
            .with_context(|| "No instance".to_string())?;

        let func_name = name.unwrap_or("start");

        let export_func = instance
            .get_func(&self.store.as_ref().unwrap(), func_name)
            .unwrap();
        let params: &[Val] = &args;

        let signal = self.execute_func(export_func, params)?;
        // stacks.lock().recycle(stack);
        return Ok(signal);
    }

    fn instantiate(
        &mut self,
        wasm_file: &Path,
        wasi_ctx: WasiCtx,
        fuel: Option<u64>,
        compilation_mode: CompilationMode,
    ) -> Result<u32, Error> {
        let mut config = Config::default();
        if fuel.is_some() {
            config.consume_fuel(true);
        }
        config.compilation_mode(compilation_mode);
        let engine = wasmi::Engine::new(&config);
        let wasm_bytes = crate::commands::utils::read_wasm_or_wat(wasm_file)?;
        let module = wasmi::Module::new(&engine, &wasm_bytes[..]).map_err(|error| {
            anyhow!("failed to parse and validate Wasm module {wasm_file:?}: {error}")
        })?;
        let mut store = wasmi::Store::new(&engine, wasi_ctx);
        if let Some(fuel) = fuel {
            store.set_fuel(fuel).unwrap_or_else(|error| {
                panic!("error: fuel metering is enabled but encountered: {error}")
            });
        }

        let mut linker = <wasmi::Linker<WasiCtx>>::new(&engine);
        wasmi_wasi::add_to_linker(&mut linker, |ctx| ctx)
            .map_err(|error| anyhow!("failed to add WASI definitions to the linker: {error}"))?;
        let instance = linker
            .instantiate(&mut store, &module)
            .and_then(|pre| pre.start(&mut store))
            .map_err(|error| anyhow!("failed to instantiate and start the Wasm module: {error}"))?;

        let engine = store.engine().clone();
        self.stack = Some(engine.stacks().lock().reuse_or_new());
        self.engine = Some(engine);
        self.store = Some(store);
        self.instance = Some(instance);

        Ok(1)
    }
}

impl Interceptor for MainDebugger {
    fn invoke_func(&self, name: &str) -> ExecResult<Signal> {
        trace!("Invoke function '{}'", name);
        if self.breakpoints.should_break_func(name) {
            Ok(Signal::Breakpoint)
        } else {
            Ok(Signal::Next)
        }
    }

    fn execute_inst(&self, inst: &Instruction) -> ExecResult<Signal> {
        if self.breakpoints.should_break_inst(inst) {
            Ok(Signal::Breakpoint)
        } else if self.is_interrupted.swap(false, Ordering::Relaxed) {
            println!("Interrupted by signal");
            Ok(Signal::Breakpoint)
        } else {
            Ok(Signal::Next)
        }
    }
}
