// use crate::commands::{backtrace, breakpoint};
// use crate::commands::debugger::{self, Debugger, DebuggerOpts, RawHostModule, RunResult};
use crate::commands::debugger::{self, DebuggerOpts, RunResult};
use anyhow::{anyhow, Error, Ok, Result};
use log::warn;
use wasmi::module::utils::WasmiValueType;
use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::Rc;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::{usize, vec};
use crate::heap::display_local_in_heap;
use crate::breakpoint::Breakpoints;
use wasmi::engine::executor::cache::CachedInstance;
use wasmi::engine::executor::instr_ptr::InstructionPtr;
use wasmi::engine::{CallResults, EngineFunc};
use wasmi::engine::{CallParams, Stack};
use wasmi::{
    engine::executor::instrs::{ Executor, Interceptor, Signal},
    func::FuncEntity,
    Val,
};
use wasmi_collections::arena::ArenaIndex;
use wasmi_core::{UntypedVal, F32, F64};
use wasmi_ir::{Reg, RegSpan};
use wasmi_wasi::{WasiCtx, WasiCtxBuilder};

type RawModule = Vec<u8>;

use wasmi::engine::executor::stack::CallFrame;
use wasmi::{CompilationMode, Config, Engine, Func, Instance, Store};

static mut WASM_STORE: Option<Store<WasiCtx>> = None;
static mut WASM_ENGINE: Option<Engine> = None;
static mut WASM_STACK: Option<Stack> = None;

pub struct InstanceWithName {
    pub inner: Instance,
    pub import_func_len: u32,
    pub func_names: HashMap<u32, String>,
    pub global_names: HashMap<u32, String>,
    pub local_names: HashMap<u32, Vec<(u32, String)>>,
    pub local_dep_names: HashMap<u32, Vec<(u32, String)>>,
}

#[allow(unused)]
pub struct MainDebugger<'engine> {
    pub instance: Option<InstanceWithName>,
    start_fn_idx: Option<u32>,
    run_func: Option<Func>,
    invoked_func_index: Vec<u32>,
    executor: Option<Rc<RefCell<Executor<'engine>>>>,

    main_module: Option<(RawModule, String)>,
    opts: DebuggerOpts,
    preopen_dirs: Vec<(String, String)>,
    envs: Vec<(String, String)>,

    breakpoints: Breakpoints,
    is_interrupted: Arc<AtomicBool>,
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
        let is_interrupted = Arc::new(AtomicBool::new(true));
        signal_hook::flag::register(signal_hook::consts::SIGINT, Arc::clone(&is_interrupted))?;
        Ok(Self {
            instance: None,
            start_fn_idx: None,
            run_func: None,
            invoked_func_index: Vec::new(),
            executor: None,
            main_module: None,
            opts: DebuggerOpts::default(),
            breakpoints: Default::default(),
            is_interrupted,
            preopen_dirs,
            envs,
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
        // println!("init func: {}", engine_func.into_usize() as u32);
        self.invoked_func_index.push(engine_func.into_usize() as u32 + self.get_import_func_len());
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

    pub fn get_params_locals_types(&self, func_idx: u32, types: &mut Vec<wasmi_core::ValType>) -> Result<()> {
        let store = get_store();
        let func = self.instance()
            .ok_or_else(|| anyhow::anyhow!("No instance found"))?
            .get_func_by_index(&store, func_idx)
            .ok_or_else(|| anyhow::anyhow!("No func found in index {:?}", func_idx))?;

        let wasm_func = match store.inner.resolve_func(&func) {
            FuncEntity::Wasm(x) => x,
            _ => return Err(anyhow!("not support host")),
        };
        let engine_func = wasm_func.func_body();
        
        let func_type = func.ty(&store);
        func_type.params().iter().for_each(|ty| {
            types.push(ty.clone());
        });
        
        self.executor()?
            .borrow()
            .code_map.get(None, engine_func)?
            .value_types()
            .iter()
            .for_each(|ty| {
                types.push(WasmiValueType::from(ty.clone()).into_inner());
            });
        Ok(())
    }

    pub fn get_display_locals(
        &self, 
        local_names: &Vec<(u32, String)>, 
        types: &Vec<wasmi_core::ValType>
    ) -> Result<Vec<(u32, String, wasmi_core::ValType)>> {
        let mut ret = Vec::new();
        local_names.iter().zip(types.iter()).for_each(|((idx, name), ty)| {
            ret.push((*idx, name.clone(), ty.clone()));
        });
        Ok(ret)
    }

    fn display_val_in_stack(&self, ty: wasmi_core::ValType, value: UntypedVal, shr: usize) -> String {
        let divided_value = UntypedVal::from(value.to_bits() >> shr);
        let typed_val = match ty {
            wasmi_core::ValType::I32 => Val::I32(i32::from(divided_value)),
            wasmi_core::ValType::I64 => Val::I64(i64::from(divided_value)),
            wasmi_core::ValType::F32 => Val::F32(F32::from(value)),
            wasmi_core::ValType::F64 => Val::F64(F64::from(value)),
            _ => return format!("Unsupported type {:?}", ty)
        };
        format!("{:?}", typed_val)
    }

    fn display_valtype_with_value(&self, ty: wasmi_core::ValType, value: UntypedVal) -> Result<String> {
        let typed_val_str = 
            if value.to_bits() & 1 == 0 {
                self.display_val_in_stack(ty, value, 1)
            } else if ty.is_num() {
                // If LSBit is 1, then it is a pointer into the heap
                match display_local_in_heap(
                    self.executor()?.borrow(), 
                    &mut get_store(), 
                    value.to_bits(),
                    ty,
                    self.lookup_func_by_name("bigint_to_float64"),
                    self.lookup_func_by_name("bigint_to_word64_wrap"),
                    self.lookup_func_by_name("bigint_to_word32_trap_with"),
                ) {
                    std::result::Result::Ok(s) =>  {s},
                    Err(_) => {self.display_val_in_stack(ty, value, 0)}
                }
            } else {
                return Ok(format!("Unsupported type {:?}", ty))
            };
        Ok(typed_val_str)
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

    fn select_frame(&mut self, _frame_index: Option<usize>) -> Result<()> {
        // self.selected_frame = frame_index;
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

    fn list_breakpoints(&self) -> Vec<&debugger::Breakpoint> {
        self.breakpoints.function_map().values().collect::<Vec<_>>()
    }

    fn delete_breakpoint(&mut self, id: usize) -> Result<(), anyhow::Error> {
        self.breakpoints.delete(id)
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

    fn locals(&self) -> Result<(u32, String, Vec<(u32, String, String)>)> {
        let executor = self.executor()?;
        let executor = executor.borrow();
        dump_func_types(&executor)?;

        let func_idx = self.invoked_func_index
            .last()
            .ok_or_else(|| anyhow::anyhow!("No invoked func index found"))?;
        
        let func_name = self.get_func_name_by_idx(*func_idx)
            .unwrap_or_default();
        
        let local_names = self.instance
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("No instance found"))?
            .local_names
            .get(func_idx)
            .ok_or_else(|| anyhow::anyhow!("No local names found in func {:?} or index {:?}", func_name, func_idx))?;
        
        let mut types = Vec::new();
        self.get_params_locals_types(*func_idx, &mut types)?;
        let locals = self.get_display_locals(local_names, &types)?;
        
        let mut ret_locals = locals
            .iter()
            .map(
                |(index, name, ty)| {
                    let reg = i16::try_from(*index).map(Reg::from)?;
                    let val = executor.get_register(reg);
                    let typed_val_display = self.display_valtype_with_value(*ty, val)?;
                    Ok((*index, name.clone(), typed_val_display))
                }
            )
            .collect::<Result<Vec<_>>>()?;
        ret_locals.sort_by_key(|item| item.0);
        Ok((*func_idx, func_name, ret_locals))
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
        let mut res = Vec::new();
        for idx in self.invoked_func_index.iter() {
            if let Some(name) = self.get_func_name_by_idx(*idx) {
                res.push(name);
            } else {
                res.push("unknown func".to_string());
            }
        }
        res
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
                let _instr_offset = executor.borrow_mut().execute_step(store, self)?;
                while initial_frame_depth <= frame_depth(&executor.borrow()) {
                    let last_signal = executor.borrow_mut().execute_step(store, self)?;
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
        self.breakpoints.inst_in_file_0 = inst_in_file_0;
        self.instance = Some(InstanceWithName {
            inner: instance,
            import_func_len: module.import_func_len() as u32,
            func_names: module.name_custom_sections().functions.clone(),
            global_names: module.name_custom_sections().globals.clone(),
            local_names: module.name_custom_sections().locals.clone(),
            local_dep_names: module.name_custom_sections().locals_dep.clone(),
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
        self.invoked_func_index.push(func_idx);
        
        // println!("\n--------------func index: {:?}", func_idx);
        if let Some(name) = self.get_func_name_by_idx(func_idx) {
            // println!("invoke func_name: {:?}", name);
            if self.breakpoints.should_break_func(&name) {
                Signal::Breakpoint
            } else {
                Signal::Next
            }
        } else {
            Signal::Next
        }
    }

    fn pop_frame(&mut self) {
        self.invoked_func_index.pop();
    }

    fn get_import_func_len(&self) -> u32 {
        self.instance.as_ref().unwrap().import_func_len
    }

    fn execute_inst(&self, _instr_offset: u32) -> Signal {
        if self.is_interrupted.load(Ordering::SeqCst) 
        && self.breakpoints.inst_in_file_0.contains(&(_instr_offset as u64)) {
            self.is_interrupted.store(false, Ordering::SeqCst);
            Signal::Breakpoint
        } 
        // // else if self.breakpoints.should_break_inst(instr_offset) {
        // //     Signal::Breakpoint
        // // } 
        else {
            Signal::Next
        }
        // Signal::Next
    }
}

pub fn get_store() -> &'static mut Store<WasiCtx> {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    #[allow(static_mut_refs)]
    unsafe { WASM_STORE.as_mut().unwrap() }
}


pub fn get_engine() -> &'static mut Engine {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    #[allow(static_mut_refs)]
    unsafe { WASM_ENGINE.as_mut().unwrap() }
}

pub fn get_stack() -> &'static mut Stack {
    // SAFETY: Within Wasm bytecode execution we are guaranteed by
    //         Wasm validation and Wasmi codegen to never run out
    //         of valid bounds using this method.
    #[allow(static_mut_refs)]
    unsafe { WASM_STACK.as_mut().unwrap() }
}

use std::fs::File;
use std::io::Write;

pub fn dump_func_types(executor: &Executor) -> Result<()> {
    let mut file = File::create("tmp")?;
    for i in 0..100 {
        if let std::result::Result::Ok(types) = executor.code_map
            .get(None, EngineFunc::from_usize(i))
            .map(|f| f.value_types()) 
        {
            writeln!(file, "\n\n-------------")?;
            writeln!(file, "len = {}", types.len())?;
            writeln!(file, "func {}: {:?}", i, types)?;
        }
    }
    Ok(())
}
