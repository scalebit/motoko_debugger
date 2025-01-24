use crate::commands::backtrace;
// use crate::commands::debugger::{self, Debugger, DebuggerOpts, RawHostModule, RunResult};
use crate::commands::debugger::{self, Debugger, DebuggerOpts, RunResult};
use crate::func_instance::DefinedFunctionInstance;
use anyhow::{anyhow, Context, Error, Result};
use log::{trace, warn};
use wasmi_core::ValType;
use std::collections::HashMap;
use std::path::Path;
use std::rc::Rc;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::{cell::RefCell, usize};
use wasmparser::NameSectionReader;

use wasmi::{
    engine::executor::instrs::{ExecResult, Executor, Interceptor, ModuleIndex, Signal},
    Val,
};
use wasmi_ir::Instruction;
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
use wasmi::{CompilationMode, Config, Extern, ExternType, Func, FuncType, Instance, Module, Store};




pub struct MainDebugger {
    pub instance: Option<Instance>,

    main_module: Option<(RawModule, String)>,

    // /// The given Wasm module.
    // module: Module,
    // /// The used Wasm store.
    // store: Store<WasiCtx>,
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

    // fn selected_instructions(&self) -> Result<(&[Instruction], usize)> {
    //     let pc = self.selected_frame()?;
    //     let func = self.store()?.func_global(pc.exec_addr());
    //     let func = func.defined().ok_or(anyhow!("Function not found"))?;
    //     let insts = func.instructions();
    //     Ok((insts, pc.inst_index().0 as usize))
    // }

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

    fn process(&mut self) -> Result<RunResult> {
        self.selected_frame = None;
        // let mut store = &self.store;
        // let mut executor = self.executor()?;
        // loop {
        //     let result = executor
        //         .borrow_mut()
        //         .execute_for_debug(store, self);
        //     match result {
        //         Ok(Signal::Next) => continue,
        //         Ok(Signal::Breakpoint) => return Ok(RunResult::Breakpoint),
        //         Ok(Signal::End) => {
        //             // let pc = executor.borrow().pc;
        //             // let func = store.func_global(pc.exec_addr());
        //             // let results = executor
        //             //     .borrow_mut()
        //             //     .pop_result(func.ty().results().to_vec())?;
        //             // return Ok(RunResult::Finish(results));
        //             return Ok(RunResult::Finish(vec![]));

        //         }
        //         Err(err) => return Err(anyhow!("Function exec failure {}", err)),
        //     }
        // }
        return Ok(RunResult::Finish(vec![]));
    }

    // fn run(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<debugger::RunResult> {
    //     let main_module = self.main_module()?;
    //     let start_func_addr = *main_module.start_func_addr();
    //     let func = {
    //         if let Some(name) = name {
    //             self.lookup_func(self.store, name)
    //         } else {
    //             self.lookup_func(self.store, "_start")
    //         }
    //     };

    //     let inputs = [Val::I32(1)];
    //     let mut results = [0_i32; 4].map(Val::from);
    //     let expected = [1_i32; 4];
    //     func.call(&mut self.store, &inputs[..], &mut results[..]);
    // }

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
        // self.store = store;
        self.instance = Some(instance);
        match instance.get_export(&store, "result").unwrap() {
            Extern::Global(a) => println!("Extern::Global {:?}", a.get(&store)),
            _ => {}
        }
        
        let addTwoFunc = instance.get_func(&store, "AddTwo").unwrap();
        let mut res: [Val;1] = [Val::I32(0)];
        addTwoFunc.call(&mut store, &[wasmi::Val::I32(1),wasmi::Val::I32(1)], &mut res)?;
        
        
        let input: &[Val] = &[wasmi::Val::I32(1),wasmi::Val::I32(1)];

        let mut res2: [Val;1] = [Val::I32(0)];
        let res2_slice: &mut [Val] = &mut res2;

        let dbg_ret = addTwoFunc.call_dbg(&mut store, &[wasmi::Val::I32(2),wasmi::Val::I32(2)], &mut res)?;
        println!("res = {:?}", dbg_ret);
        // self.instance.
        // DefinedFunctionInstance::new();

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
