// use crate::commands::{backtrace, breakpoint};
// use crate::commands::debugger::{self, Debugger, DebuggerOpts, RawHostModule, RunResult};
use crate::commands::debugger::{self, Debugger, DebuggerOpts, RunResult};
use anyhow::{anyhow, Error, Ok, Result};
use log::{trace, warn};
use std::cell::RefCell;
use std::collections::HashMap;
use std::path::Path;
use std::rc::Rc;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::{usize, vec};
use wasmi::engine::code_map::CodeMap;
use wasmi::engine::executor::cache::CachedInstance;
use wasmi::engine::executor::instr_ptr::InstructionPtr;
use wasmi::engine::{self, executor, CallResults, EngineFunc};
use wasmi::engine::{CallParams, Stack};
use wasmi::{
    engine::executor::instrs::{ExecResult, Executor, Interceptor, Signal},
    func::FuncEntity,
    Val,
};
use wasmi_collections::arena::ArenaIndex;
use wasmi_core::UntypedVal;
use wasmi_ir::{Instruction, Reg, RegSpan};
use wasmi_wasi::{WasiCtx, WasiCtxBuilder};

type RawModule = Vec<u8>;

use wasmi::engine::executor::stack::CallFrame;
use wasmi::{instance, CompilationMode, Config, Engine, Func, Instance, Store};

static mut WASM_STORE: Option<Store<WasiCtx>> = None;
static mut WASM_ENGINE: Option<Engine> = None;
static mut WASM_STACK: Option<Stack> = None;

pub struct MainDebugger<'engine> {
    pub instance: Option<Instance>,
    start_fn_idx: Option<u32>,
    run_func: Option<Func>,
    executor: Option<Rc<RefCell<Executor<'engine>>>>,

    main_module: Option<(RawModule, String)>,
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
        false
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

impl<'engine> MainDebugger<'engine> {
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
            start_fn_idx: None,
            run_func: None,
            executor: None,
            main_module: None,
            opts: DebuggerOpts::default(),
            breakpoints: Default::default(),
            is_interrupted,
            preopen_dirs,
            envs,
            selected_frame: None,
        })
    }

    fn instance(&self) -> Result<&Instance> {
        if let Some(ref instance) = self.instance {
            Ok(instance)
        } else {
            Err(anyhow::anyhow!("No instance"))
        }
    }

    fn executor(&self) -> Result<Rc<RefCell<Executor<'engine>>>> {
        if let Some(executor) = self.executor.as_ref() {
            Ok(executor.clone())
        } else {
            Err(anyhow::anyhow!("No execution context"))
        }
    }

    pub fn get_instr_offset(&self) -> Result<()> {
        let executor = self.executor()?;
        let executor = executor.borrow();
        let frame = executor.stack.calls.frames.last().unwrap();
        let func = frame.func.clone();

        let code_map = get_engine().code_map();
        let compiled_func = code_map.get(None, EngineFunc::from_usize(func as usize))?;
        let offsets = compiled_func.offsets();
        let offset = offsets.get(frame.instr_count as usize).unwrap();
        println!("curr inst offset: {}", offset);
        Ok(())
    }

    fn running_func(&self) -> Result<Func> {
        if let Some(func) = self.run_func {
            Ok(func)
        } else {
            Err(anyhow::anyhow!("No Run Func"))
        }
    }

    pub fn lookup_func(&self, name: &str) -> Result<Func> {
        let store = get_store();
        let instance = self.instance.as_ref().unwrap();

        if let Some(func) = instance.get_func(store, name) {
            Ok(func)
        } else {
            Err(anyhow!("Entry function {} not found", name))
        }
    }

    pub fn lookup_start_func(&self) -> Func {
        let instance = self.instance.as_ref().expect("no instance");
        let store = get_store();
        let start_idx = self
            .start_fn_idx
            .unwrap_or_else(|| panic!("module do not have `_start` function"));

        instance
            .get_func_by_index(store, start_idx)
            .unwrap_or_else(|| panic!("encountered invalid start function after validation"))
    }

    pub fn execute_func(&mut self, func: Func, params: &[Val]) -> Result<()> {
        let store = get_store();
        let stack = get_stack();
        let code_map = get_engine().code_map();

        let func_type = func.ty(&store);

        func.verify_and_prepare_inputs(&store, params)?;

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
                    engine_func,
                    InstructionPtr::new(compiled_func.instrs().as_ptr()),
                    offsets,
                    RegSpan::new(Reg::from(0)),
                ),
                Some(instance),
            )
            .map_err(|e| anyhow::anyhow!(e))?;

        // let store = get_store();
        // let stack = get_stack();
        // let code_map = get_engine().code_map();

        let instance = stack.calls.instance_expect();
        let cache = CachedInstance::new(&mut store.inner, &instance);
        self.executor = Some(Rc::new(RefCell::new(Executor::new(
            stack, &code_map, cache,
        ))));

        Ok(())
    }

    pub fn run_step(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<()> {
        let func = if let Some(name) = name {
            self.lookup_func(name)?
        } else {
            self.lookup_start_func()
        };

        self.execute_func(func, &args)?;
        Ok(())
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

impl<'engine> debugger::Debugger for MainDebugger<'engine> {
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

    fn stack_values(&self) -> Vec<UntypedVal> {
        if self.executor.is_none() {
            return vec![];
        }
        let executor = self.executor.clone().unwrap();
        let executor = executor.borrow();
        let values = executor.stack.values.values.iter().collect::<Vec<_>>();

        let mut new_values = Vec::<UntypedVal>::new();
        for v in values {
            new_values.push(*v);
        }
        new_values
    }

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

    fn frame(&self) -> Vec<String> {
        let executor = if let Some(executor) = self.executor.clone() {
            executor
        } else {
            return vec![];
        };

        let frames = &executor.borrow().stack.calls.frames;
        let instances = &executor.borrow().stack.calls.instances;

        if instances.last().is_none() {
            return vec![];
        }
        let mut frames_string = vec![];
        let mut all_instances = instances.rest().iter().collect::<Vec<_>>();
        all_instances.push(instances.last().unwrap());
        for f in frames.iter() {
            frames_string.push(format!(
                "{:?} - func {}",
                all_instances.last().unwrap(),
                f.func
            ));
        }
        return frames_string;
    }

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
        self.executor().is_ok()
    }

    fn step(&self, style: debugger::StepStyle) -> Result<Signal> {
        fn frame_depth(executor: &Executor) -> usize {
            executor.stack.calls.frames.len()
        }

        let store = get_store();
        let executor = self.executor()?;

        use debugger::StepStyle::*;
        match style {
            InstIn => return Ok(executor.borrow_mut().execute_step(store, self)?),
            InstOver => {
                let initial_frame_depth = frame_depth(&executor.borrow());
                let mut last_signal = executor.borrow_mut().execute_step(store, self)?;
                while initial_frame_depth < frame_depth(&executor.borrow()) {
                    self.get_instr_offset();
                    last_signal = executor.borrow_mut().execute_step(store, self)?;
                    if let Signal::Breakpoint = last_signal {
                        return Ok(last_signal);
                    } else if let Signal::End = last_signal {
                        println!("signal::End");
                        return Ok(last_signal);
                    }
                }

                println!(
                    "over global A: {:?}",
                    self.instance()?
                        .get_global(&store, "A")
                        .unwrap()
                        .get(&store)
                );
                Ok(last_signal)
            }
            Out => {
                let initial_frame_depth = frame_depth(&executor.borrow());
                let mut last_signal = executor.borrow_mut().execute_step(store, self)?;
                while initial_frame_depth <= frame_depth(&executor.borrow()) {
                    self.get_instr_offset();
                    last_signal = executor.borrow_mut().execute_step(store, self)?;
                    if let Signal::Breakpoint = last_signal {
                        println!("signal::break");
                        break;
                    } else if let Signal::End = last_signal {
                        println!("signal::End");
                        break;
                    }
                }

                println!(
                    "out global A: {:?}",
                    self.instance()?
                        .get_global(&store, "A")
                        .unwrap()
                        .get(&store)
                );

                Ok(last_signal)
            }
        }
    }

    fn process(&self) -> Result<RunResult> {
        let store = get_store();
        let stack = get_stack();
        let executor = self.executor()?;

        loop {
            match executor.borrow_mut().execute_step(store, self)? {
                Signal::Next => continue,
                Signal::Breakpoint => return Ok(RunResult::Breakpoint),
                Signal::End => {
                    let func_type = self.running_func()?.ty(&get_store());
                    let results: &mut [Val] = &mut func_type
                        .results()
                        .iter()
                        .map(|x| Val::default(x.clone()))
                        .collect::<Vec<Val>>();

                    results.call_results(&stack.values.as_slice()[..results.len_results()]);
                    return Ok(RunResult::Finish(results.to_vec()));
                }
            }
        }
    }

    fn run(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<RunResult> {
        let func = if let Some(name) = name {
            self.lookup_func(name)?
        } else {
            self.lookup_start_func()
        };

        println!(
            "over global A: {:?}",
            self.instance()?
                .get_global(get_store(), "A")
                .unwrap()
                .get(get_store())
        );

        self.run_func = Some(func);
        self.execute_func(func, &args)?;
        let a = self.process();
        println!(
            "over global A: {:?}",
            self.instance()?
                .get_global(get_store(), "A")
                .unwrap()
                .get(get_store())
        );
        return a;
    }

    fn instantiate(&mut self) -> Result<(), Error> {
        let mut wasi_ctx_builder = WasiCtxBuilder::new();
        let wasi_ctx = wasi_ctx_builder.build();

        let mut config = Config::default();
        let fuel = None;
        if fuel.is_some() {
            config.consume_fuel(true);
        }
        config.compilation_mode(CompilationMode::Eager);
        let engine = wasmi::Engine::new(&config);
        let mut store = wasmi::Store::new(&engine, wasi_ctx);

        let (main_module, basename) = if let Some((main_module, basename)) = &self.main_module {
            (main_module, basename.clone())
        } else {
            return Err(anyhow::anyhow!("No main module registered"));
        };

        let module = wasmi::Module::new(&engine, &main_module[..]).map_err(|error| {
            anyhow!("failed to parse and validate Wasm module from  {basename:?}: {error}")
        })?;

        if let Some(fuel) = fuel {
            store.set_fuel(fuel).unwrap_or_else(|error| {
                panic!("error: fuel metering is enabled but encountered: {error}")
            });
        }

        let mut linker = <wasmi::Linker<WasiCtx>>::new(&engine);
        wasmi_wasi::add_to_linker(&mut linker, |ctx| ctx)
            .map_err(|error| anyhow!("failed to add WASI definitions to the linker: {error}"))?;

        wasmi_wasi::add_preview0_to_linker(&mut linker, |ctx| ctx).map_err(|error| {
            anyhow!("failed to add preview0 WASI definitions to the linker: {error}")
        })?;

        let instance = linker.instantiate(&mut store, &module).map(|pre| {
            self.start_fn_idx = pre.start_fn();
            pre.initialize_instance(&mut store)
        })?;

        self.instance = Some(instance);
        unsafe {
            WASM_STACK = Some(engine.stacks().lock().reuse_or_new());
            WASM_STORE = Some(store);
            WASM_ENGINE = Some(engine);
        }
        Ok(())
    }
}

impl<'engine> Interceptor for MainDebugger<'engine> {
    fn invoke_func(&self, name: &str) -> Signal {
        if self.breakpoints.should_break_func(name) {
            Signal::Breakpoint
        } else {
            Signal::Next
        }
    }

    fn execute_inst(&self, inst: &Instruction) -> Signal {
        if self.breakpoints.should_break_inst(inst) {
            Signal::Breakpoint
        } else {
            Signal::Next
        }
    }
}

pub fn get_store() -> &'static mut Store<WasiCtx> {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    unsafe { WASM_STORE.as_mut().unwrap() }
}

pub fn get_engine() -> &'static mut Engine {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    unsafe { WASM_ENGINE.as_mut().unwrap() }
}

pub fn get_stack() -> &'static mut Stack {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    unsafe { WASM_STACK.as_mut().unwrap() }
}
