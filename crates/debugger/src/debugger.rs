// use crate::commands::{backtrace, breakpoint};
// use crate::commands::debugger::{self, Debugger, DebuggerOpts, RawHostModule, RunResult};
use crate::commands::debugger::{self, Debugger, DebuggerOpts, RunResult};
use anyhow::{anyhow, Error, Ok, Result};
use log::{trace, warn};
use wasmi::store::StoreIdx;
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
use wasmi_collections::arena::{ArenaIndex, GuardedEntity};
use wasmi_core::UntypedVal;
use wasmi_ir::{Instruction, Reg, RegSpan};
use wasmi_wasi::{WasiCtx, WasiCtxBuilder};

type RawModule = Vec<u8>;

use wasmi::engine::executor::stack::CallFrame;
use wasmi::{instance, CompilationMode, Config, Engine, Func, Instance, Store};

static mut WASM_STORE: Option<Store<WasiCtx>> = None;
static mut WASM_ENGINE: Option<Engine> = None;
static mut WASM_STACK: Option<Stack> = None;

pub struct InstanceWithName {
    pub inner: Instance,
    pub import_func_len: u32,
    pub func_names: HashMap<u32, String>,
    pub global_names: HashMap<u32, String>,
    pub local_names: HashMap<u32, Vec<(u32, String)>>,
}

pub struct MainDebugger<'engine> {
    pub instance: Option<InstanceWithName>,
    start_fn_idx: Option<u32>,
    run_func: Option<Func>,
    invoked_func_index: Option<u32>,
    invoked_func_name: Option<String>,
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
    inst_in_file_0: Vec<u64>, // instr in file 0 for interrupt in first instr of file 0
}

impl Breakpoints {
    fn should_break_func(&self, name: &str) -> bool {
        // FIXME
        self.function_map
            .keys()
            .any(|k| name.contains(Clone::clone(&k)))
    }

    fn should_break_inst(&self, inst: u32) -> bool {
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
            invoked_func_index: None,
            invoked_func_name: None,
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

    fn instance(&self) -> Option<&Instance> {
        if let Some(ref instance) = self.instance {
            Some(&instance.inner)
        } else {
            None
        }
    }

    fn get_func_name_by_idx(&self, func_idx: u32) -> Option<String> {
        if let Some(instance) = &self.instance {
            instance.func_names.get(&func_idx).map(|s| s.clone())
        } else {
            None
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
        Ok(())
    }

    fn running_func(&self) -> Result<Func> {
        if let Some(func) = self.run_func {
            Ok(func)
        } else {
            Err(anyhow::anyhow!("No Run Func"))
        }
    }

    pub fn lookup_func_by_name(&self, name: &str) -> Option<Func> {
        let store = get_store();
        if let Some(instance) = self.instance() {
            if let Some(func) = instance.get_func(&store, name) {
                Some(func)
            } else {
                let instance_with_name = self.instance.as_ref().unwrap();
                for (idx, func_name) in instance_with_name.func_names.iter() {
                    if func_name == name {
                        return Some(instance.get_func_by_index(&store, *idx).unwrap());
                    }
                }
                None
            }
        } else {
            None
        }
    }

    pub fn lookup_func_by_index(&self, index: u32) -> Option<Func> {
        let store = get_store();
        if let Some(instance) = self.instance() {
            instance.get_func_by_index(store, index)
        } else {
            None
        }
    }

    pub fn lookup_start_func(&self) -> Option<Func> {
        if let Some(instance) = self.instance() {
            let store = get_store();
            if let Some(idx) =  self.start_fn_idx {
                instance.get_func_by_index(store, idx)
            } else {
                None
            }
        } else {
            None
        }
    }

    pub fn get_finish_result(&self) -> Result<Vec<Val>> {
        let stack = get_stack();
        let func_type = self.running_func()?.ty(&get_store());
        let results: &mut [Val] = &mut func_type
            .results()
            .iter()
            .map(|x| Val::default(x.clone()))
            .collect::<Vec<Val>>();

        results.call_results(&stack.values.as_slice()[..results.len_results()]);
        Ok(results.to_vec())
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


        let instance = stack.calls.instance_expect();
        let cache = CachedInstance::new(&mut store.inner, &instance);
        self.executor = Some(Rc::new(RefCell::new(Executor::new(
            stack, &code_map, cache,
        ))));

        Ok(())
    }

    pub fn run_step(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<()> {
        let func = if let Some(name) = name {
            let f = if let std::result::Result::Ok(index) =  name.parse::<u32>() {
                self.lookup_func_by_index(index)
            } else {
                self.lookup_func_by_name(name)
            };
            f
        } else {
            self.lookup_start_func()
        };

        if let Some(func) = func {
            self.run_func = Some(func);
            self.execute_func(func, &args)?;
        } else {
            return Err(anyhow::anyhow!("No function {} found", name.unwrap_or("start")));
        }
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

    fn selected_instr_offset(&self) -> Result<Option<usize>> {
        let executor = self.executor()?;
        let executor = executor.borrow();
        let ip = executor.ip.get().clone();
        let offset = ip.get_offset();
        Ok(Some(offset))
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

    fn locals(&self) -> Result<(u32, String ,Vec<(u32, String, i32)>)>{
        let executor = self.executor()?;
        let executor = executor.borrow();
        
        if let Some(func_idx) = self.invoked_func_index {
            let func_name = if let Some(name) = self.invoked_func_name.as_ref() {
                name.clone()
            } else {
                "".to_string()
            };
            let invoked_func = self.instance.as_ref().unwrap().local_names.get(&func_idx);
            if let Some(invoked_func) = invoked_func {
                let mut ret = Vec::new();
                for (index, name) in invoked_func.iter() {
                    let reg = i16::try_from(*index)
                        .ok()
                        .map(Reg::from)
                        .unwrap_or_else(|| {
                            panic!("Index {} is out of bounds", index);
                        });
                    let val = executor.get_register(reg);
                    let val = i32::from(val);
                    ret.push((*index, name.clone(), val));
                }
                Ok((func_idx, func_name, ret))
            } else {
                Err(anyhow::anyhow!("No local names found in func {:?} or index {:?}", func_name, func_idx))
            }
        } else {
            Err(anyhow::anyhow!("No invoked func index found {:?}", self.invoked_func_index))
        }
    }

    fn global(&self, name: &str) -> Option<Val> {
        if let Some(global)= self.instance()?.get_global(get_store(), name) {
            Some(global.get(get_store()))
        } else {
            None
        }
                
    }


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

    fn step(&mut self, style: debugger::StepStyle) -> Result<RunResult> {
        fn frame_depth(executor: &Executor) -> usize {
            executor.stack.calls.frames.len()
        }

        let store = get_store();
        let executor = self.executor()?;

        use debugger::StepStyle::*;
        match style {
            InstIn => {
                executor.borrow_mut().execute_step(store, self)?;
                Ok(RunResult::Next)
            },
            InstOver => {
                let initial_frame_depth = frame_depth(&executor.borrow());
                let mut last_signal = executor.borrow_mut().execute_step(store, self)?;
                if let Signal::Breakpoint = last_signal {
                    return Ok(RunResult::Breakpoint);
                } else if let Signal::End = last_signal {
                    let results = self.get_finish_result()?;
                    return Ok(RunResult::Finish(results));
                }
                
                while initial_frame_depth < frame_depth(&executor.borrow()) {
                    last_signal = executor.borrow_mut().execute_step(store, self)?;
                    if let Signal::Breakpoint = last_signal {
                        return Ok(RunResult::Breakpoint);
                    } else if let Signal::End = last_signal {
                        let results = self.get_finish_result()?;
                        return Ok(RunResult::Finish(results));
                    }
                }
                Ok(RunResult::Next)
            }
            Out => {
                let initial_frame_depth = frame_depth(&executor.borrow());
                let mut last_signal = executor.borrow_mut().execute_step(store, self)?;
                while initial_frame_depth <= frame_depth(&executor.borrow()) {
                    last_signal = executor.borrow_mut().execute_step(store, self)?;
                    if let Signal::Breakpoint = last_signal {
                        return Ok(RunResult::Breakpoint);
                    } else if let Signal::End = last_signal {
                        let results = self.get_finish_result()?;
                        return Ok(RunResult::Finish(results));
                    }
                }
                Ok(RunResult::Next)
            }
        }
    }

    fn process(&mut self) -> Result<RunResult> {
        let store = get_store();
        let executor = self.executor()?;
        self.get_instr_offset()?;
        loop {
            match executor.borrow_mut().execute_step(store, self)? {
                Signal::Next => continue,
                Signal::Breakpoint => return Ok(RunResult::Breakpoint),
                Signal::End => {
                    let results = self.get_finish_result()?;
                    return Ok(RunResult::Finish(results));
                }
            }
        }
    }

    fn run(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<RunResult> {
        self.is_interrupted.swap(true, Ordering::SeqCst);
        let func = if let Some(name) = name {
            let f = if let std::result::Result::Ok(index) =  name.parse::<u32>() {
                self.lookup_func_by_index(index)
            } else {
                self.lookup_func_by_name(name)
            };
            f
        } else {
            self.lookup_start_func()
        };

        if func.is_none() {
            return Err(anyhow::anyhow!("No function {} found", name.unwrap_or("start")));
        }

        let func = func.unwrap();
        self.run_func = Some(func);
        self.execute_func(func, &args)?;
        self.process()
    }

    fn instantiate(&mut self, inst_in_file_0: Vec<u64>) -> Result<(), Error> {
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

        wasmi_wasi::add_motoko_syscall_to_linker(&mut linker, |ctx| ctx).map_err(|error| {
            anyhow!("failed to add motoko syscall to the linker: {error}")
        })?;

        let instance = linker.instantiate(&mut store, &module)?.start(&mut store)?;
        println!("import_func_len: {:?}", module.import_func_len());
        self.breakpoints.inst_in_file_0 = inst_in_file_0;
        self.instance = Some(InstanceWithName {
            inner: instance,
            import_func_len: module.import_func_len() as u32,
            func_names: module.name_custom_sections().functions.clone(),
            global_names: module.name_custom_sections().globals.clone(),
            local_names: module.name_custom_sections().locals.clone(),
        });

        unsafe {
            WASM_STACK = Some(engine.stacks().lock().reuse_or_new());
            WASM_STORE = Some(store);
            WASM_ENGINE = Some(engine);
        }
        Ok(()) 
    }
}

impl<'engine> Interceptor for MainDebugger<'engine> {
    fn invoke_func(&mut self, func_idx: i32, table: Option<wasmi::Table>) -> Signal {
        let mut func_idx = func_idx as u32;
        if let Some(table) = table {
            let funcref = get_store()
                .inner
                .resolve_table(&table)
                .get_untyped(func_idx as u32)
                .map(wasmi::FuncRef::from)
                .unwrap();
            let func = funcref.func().unwrap();
            func_idx = func.as_inner().entity_idx.into_usize() as u32;
        } 
        self.invoked_func_index = Some(func_idx);
        self.invoked_func_name = None;
        if let Some(name) = self.get_func_name_by_idx(func_idx) {
            println!("invoke func_name: {:?}", name);
            self.invoked_func_name = Some(name);
            if self.breakpoints.should_break_func(&self.invoked_func_name.as_ref().unwrap()) {
                Signal::Breakpoint
            } else {
                Signal::Next
            }
        } else {
            Signal::Next
        }
    }

    fn get_import_func_len(&self) -> u32 {
        self.instance.as_ref().unwrap().import_func_len
    }

    fn execute_inst(&self, instr_offset: u32) -> Signal {
        // if self.is_interrupted.load(Ordering::SeqCst) && self.breakpoints.inst_in_file_0.contains(&(instr_offset as u64)) {
        //     self.is_interrupted.store(false, Ordering::SeqCst);
        //     Signal::Breakpoint
        // } else if self.breakpoints.should_break_inst(instr_offset) {
        //     Signal::Breakpoint
        // } else {
        //     Signal::Next
        // }
        Signal::Next
    }
}

pub fn get_store() -> &'static mut Store<WasiCtx> {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    #[allow(unsafe_code)]
    unsafe { WASM_STORE.as_mut().unwrap() }
}

pub fn get_engine() -> &'static mut Engine {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    #[allow(unsafe_code)]
    unsafe { WASM_ENGINE.as_mut().unwrap() }
}

pub fn get_stack() -> &'static mut Stack {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    unsafe { WASM_STACK.as_mut().unwrap() }
}
