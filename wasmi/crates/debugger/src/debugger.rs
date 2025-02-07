use crate::commands::{backtrace, breakpoint};
// use crate::commands::debugger::{self, Debugger, DebuggerOpts, RawHostModule, RunResult};
use crate::commands::debugger::{self, Debugger, DebuggerOpts, RunResult};
use crate::func_instance::DefinedFunctionInstance;
use anyhow::{anyhow, Context, Error, Result};
use log::{trace, warn};
use wasmi::engine::executor::cache::CachedInstance;
use wasmi::engine::executor::instr_ptr::InstructionPtr;
use wasmi::engine::executor::EngineExecutor;
use std::collections::HashMap;
use std::path::Path;
use std::rc::Rc;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::{cell::RefCell, usize};
use wasmi_core::ValType;
use wasmparser::NameSectionReader;
use wasmi::engine::{CallParams, CallResults, Stack};
use wasmi::{
    engine::executor::instrs::{ExecResult, Executor, Interceptor, ModuleIndex, Signal},
    Val,
    func::FuncEntity
};
use wasmi_ir::{Instruction, Reg, RegSpan};
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

pub struct MainDebugger<'a> {
    pub instance: Option<Instance>,

    main_module: Option<(RawModule, String)>,
    pub executor: Option<Rc<RefCell<Executor<'a>>>>,
    // code_map: Option<Rc<RefCell<&'a CodeMap>>>,
    // stack: Option<&'a Stack>,
    // /// The given Wasm module.
    // module: Module,
    /// The used Wasm store.
    store: Option<Store<WasiCtx>>,
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

impl<'a> MainDebugger<'a>  {
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
            executor: None,
            store: None,
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

impl<'a> debugger::Debugger for MainDebugger<'a> {
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

    fn process(
        &mut self, 
        // store: &mut Store<WasiCtx>, 
        func: Func, 
        params: &[Val], 
        stack: &mut Stack, 
        code_map: &CodeMap
    ) -> Result<RunResult> {
        let store = self.store.as_mut().unwrap();
        let ret_ty = func.ty(&store);
        let ret_types = ret_ty.results();
        let mut ret_slice: Vec<Val> = ret_types.iter().map(|x| Val::default(x.clone())).collect();
        let res2_slice: &mut [Val] = &mut ret_slice;
        match store.inner.resolve_func(&func) {
            FuncEntity::Wasm(wasm_func) => {
                // We reserve space on the stack to write the results of the root function execution.
                let len_results = res2_slice.len_results();
                let a = stack.values.extend_by(
                    len_results, 
                    |_self| {}
                ).map_err(|e| anyhow::anyhow!(e))?;

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
                stack.calls.push(
                    CallFrame::new(
                        InstructionPtr::new(compiled_func.instrs().as_ptr()),
                        offsets,
                        RegSpan::new(Reg::from(0)),
                    ),
                    Some(instance),
                ).map_err(|e| anyhow::anyhow!(e))?;
                // store.invoke_call_hook(CallHook::CallingWasm)?;
                let instance = stack.calls.instance_expect();
                let cache = CachedInstance::new(&mut store.inner, instance);

                let mut exec = Executor::new(stack, &code_map, cache);

                loop {
                    match exec.execute_step(store)? {
                        Signal::Next => {},
                        Signal::Breakpoint => {
                            use std::io::Write;
                            // 提示用户输入
                            println!("Execution paused at breakpoint. Enter any key to continue, or type 'break' to exit.");

                            // 读取用户输入
                            let mut input = String::new();
                            std::io::stdout().flush().unwrap();  // 刷新输出，确保提示立即显示
                            std::io::stdin().read_line(&mut input).unwrap();
                            let input = input.trim();  // 去除空格和换行符

                            // 判断输入是否为 "break"
                            if input.eq_ignore_ascii_case("break") {
                                break;
                            }
                        }
                        Signal::End => {
                            res2_slice.call_results(&stack.values.as_slice()[..len_results]);
                            println!("Signal::End: {:?}", res2_slice);
                            break;
                        }
                    }
                    
                }
            }
            _ => {}
        }
        Err(anyhow::anyhow!("No instance"))
    }

    fn run(&mut self, name: Option<&str>, args: Vec<Val>) -> Result<debugger::RunResult, Error> {
        let instance = self
            .instance
            .as_mut()
            .with_context(|| "No instance".to_string())?;

        let func_name = name.unwrap_or("start");
 
        let export_func = instance
            .get_func(&self.store.as_ref().unwrap(), func_name)
            .unwrap();
        let params: &[Val] = &args;

        // let ret_ty = export_func.ty(&self.store.as_ref().unwrap());
        // let ret_types = ret_ty.results();
        // let mut ret_slice: Vec<Val> = ret_types.iter().map(|x| Val::default(x.clone())).collect();
        // let res2_slice: &mut [Val] = &mut ret_slice;
        // export_func.call(self.store.as_mut().unwrap(), params, res2_slice)?;

        
        let engine = self.store.as_mut().unwrap().engine().clone();
        let stacks = engine.stacks();
        let mut stack = stacks.lock().reuse_or_new();
        let code_map = engine.code_map();
        stack.reset();
        self.process(export_func,  params, &mut stack, code_map)?;
        stacks.lock().recycle(stack);
        // self.store = Some(store);
        // let call_signal =
            // export_func.call_dbg(&mut self.store.as_mut().unwrap(), &args, &mut res2_slice)?;

        // return match call_signal {
        //     Signal::Breakpoint => {
        //         println!("get breakpoint");
        //         match instance
        //             .get_export(&self.store.as_ref().unwrap(), "result")
        //             .unwrap()
        //         {
        //             Extern::Global(a) => {
        //                 println!(
        //                     "Extern::Global {:?}",
        //                     a.get(&self.store.as_ref().unwrap())
        //                 )
        //             }
        //             _ => {}
        //         }
        //         Ok(debugger::RunResult::Breakpoint)
        //     }
        //     Signal::Next => Ok(debugger::RunResult::Breakpoint),
        //     Signal::End => Ok(debugger::RunResult::Finish(res2_slice.to_vec())),
        // };
    
        // println!("res = {:?}", res2_slice);
        Err(anyhow::anyhow!("No instance"))
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

        // let store_borrow = self.store.as_ref().unwrap().borrow(); 
        // let code_map = store.engine().code_map().clone();
        // self.code_map = Some(Rc::new(RefCell::new(code_map)));

        self.store = Some(store);
        self.instance = Some(instance);
        
        

        // match instance
        //     .get_export(&self.store.as_ref().unwrap(), "result")
        //     .unwrap()
        // {
        //     Extern::Global(a) => {
        //         println!("Extern::Global {:?}", a.get(&self.store.as_ref().unwrap()))
        //     }
        //     _ => {}
        // }

        // let addTwoFunc = instance
        //     .get_func(&self.store.as_ref().unwrap(), "AddTwo")
        //     .unwrap();
        // let mut res: [Val; 1] = [Val::I32(0)];
        // addTwoFunc.call(
        //     &mut self.store.as_mut().unwrap(),
        //     &[wasmi::Val::I32(1), wasmi::Val::I32(1)],
        //     &mut res,
        // )?;
        // println!("res = {:?}", res);
        // let input: &[Val] = &[wasmi::Val::I32(1), wasmi::Val::I32(1)];

        // let mut res2: [Val; 1] = [Val::I32(0)];
        // let res2_slice: &mut [Val] = &mut res2;

        // let dbg_ret = addTwoFunc.call_dbg(
        //     &mut self.store,
        //     &[wasmi::Val::I32(2), wasmi::Val::I32(2)],
        //     &mut res,
        // )?;
        // println!("res = {:?}", dbg_ret);
        // self.instance.
        // DefinedFunctionInstance::new();

        Ok(1)
    }
}

impl<'a> Interceptor for MainDebugger<'a> {
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
