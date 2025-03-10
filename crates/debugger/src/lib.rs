pub mod commands;
mod debugger;
mod dwarf;
mod process;

use std::{cell::RefCell, rc::Rc};

pub use commands::command::CommandContext;
pub use commands::command::CommandResult;
pub use commands::debugger::{Debugger, RunResult};
pub use debugger::MainDebugger;
pub use linefeed;
pub use process::Interactive;
pub use process::Process;

use anyhow::Result;
use commands::command;
use log::warn;

pub fn try_load_dwarf(
    buffer: &[u8],
    context: &mut commands::command::CommandContext,
) -> Result<()> {
    use dwarf::transform_dwarf;
    let debug_info = transform_dwarf(buffer)?;
    

    // for (offset, line) in debug_info.sourcemap.address_sorted_rows.iter() {
    //     println!("offset: {}, line: {:?}", offset, line);
    // }
    context.sourcemap = Box::new(debug_info.sourcemap);
    context.subroutine = Box::new(debug_info.subroutine);
    Ok(())
}

struct ConsolePrinter {}
impl commands::debugger::OutputPrinter for ConsolePrinter {
    fn println(&self, output: &str) {
        println!("{}", output);
    }
    fn eprintln(&self, output: &str) {
        eprintln!("{}", output);
    }
}

pub struct ModuleInput {
    pub bytes: Vec<u8>,
    pub basename: String,
}

pub fn start_debugger(
    module_input: Option<ModuleInput>,
    preopen_dirs: Vec<(String, String)>,
    envs: Vec<(String, String)>,
) -> Result<(
    process::Process<debugger::MainDebugger<'static>>,
    command::CommandContext,
)> {
    let mut debugger = debugger::MainDebugger::new(preopen_dirs, envs)?;
    let mut context = commands::command::CommandContext {
        sourcemap: Box::new(commands::sourcemap::EmptySourceMap::new()),
        subroutine: Box::new(commands::subroutine::EmptySubroutineMap::new()),
        printer: Box::new(ConsolePrinter {}),
    };

    if let Some(ref module_input) = module_input {
        debugger.load_main_module(&module_input.bytes, module_input.basename.clone())?;
        match try_load_dwarf(&module_input.bytes, &mut context) {
            Ok(_) => (),
            Err(err) => {
                warn!("Failed to load dwarf info: {}", err);
            }
        }
    }
    let process = process::Process::new(
        debugger,
        vec![
            Box::new(commands::thread::ThreadCommand::new()),
            Box::new(commands::list::ListCommand::new()),
            // Box::new(commands::memory::MemoryCommand::new()),
            Box::new(commands::stack::StackCommand::new()),
            Box::new(commands::breakpoint::BreakpointCommand::new()),
            Box::new(commands::local::LocalCommand::new()),
            Box::new(commands::frame::FrameCommand::new()),
            Box::new(commands::settings::SettingsCommand::new()),
            Box::new(commands::process::ProcessCommand::new()),
        ],
        vec![
            Box::new(commands::run::RunCommand::new()),
            Box::new(commands::backtrace::BacktraceCommand::new()),
        ],
    )?;
    Ok((process, context))
}

pub fn run_loop(
    module_input: Option<ModuleInput>,
    init_source: Option<String>,
    preopen_dirs: Vec<(String, String)>,
    envs: Vec<(String, String)>,
) -> Result<()> {
    let (process, context) = start_debugger(module_input, preopen_dirs, envs)?;
    let mut interactive = Interactive::new_with_loading_history()?;
    let process = Rc::new(RefCell::new(process));
    while let CommandResult::ProcessFinish(_) = interactive.run_loop(&context, process.clone())? {}
    Ok(())
}

use std::fs::File;
use std::io::Read;
use wasmi::{Config, StackLimits};

fn load_file(filename: &str) -> anyhow::Result<Vec<u8>> {
    let mut f = ::std::fs::File::open(filename)?;
    let mut buffer = Vec::new();
    f.read_to_end(&mut buffer)?;
    Ok(buffer)
}

/// Returns the Wasm binary at the given `file_name` as `Vec<u8>`.
///
/// # Note
///
/// This includes validation and compilation to Wasmi bytecode.
///
/// # Panics
///
/// If the benchmark Wasm file could not be opened, read or parsed.
#[track_caller]
pub fn load_wasm_from_file(file_name: &str) -> Vec<u8> {
    let mut file = File::open(file_name)
        .unwrap_or_else(|error| panic!("could not open benchmark file {}: {}", file_name, error));
    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer).unwrap_or_else(|error| {
        panic!("could not read file at {} to buffer: {}", file_name, error)
    });
    buffer
}

/// Returns a [`Config`] useful for benchmarking.
pub fn bench_config() -> Config {
    let mut config = Config::default();
    config.wasm_tail_call(true);
    config.set_stack_limits(StackLimits::new(1024, 1024 * 1024, 64 * 1024).unwrap());
    config
}

/// Parses the Wasm binary at the given `file_name` into a Wasmi module.
///
/// # Note
///
/// This includes validation and compilation to Wasmi bytecode.
///
/// # Panics
///
/// If the benchmark Wasm file could not be opened, read or parsed.
pub fn load_module_from_file(file_name: &str) -> wasmi::Module {
    let wasm: Vec<u8> = load_wasm_from_file(file_name);
    let engine = wasmi::Engine::new(&bench_config());
    wasmi::Module::new(&engine, &wasm[..]).unwrap_or_else(|error| {
        panic!(
            "could not parse Wasm module from file {}: {}",
            file_name, error
        )
    })
}

/// Parses the Wasm binary from the given `file_name` into a Wasmi module.
///
/// # Note
///
/// This includes validation and compilation to Wasmi bytecode.
///
/// # Panics
///
/// If the benchmark Wasm file could not be opened, read or parsed.
pub fn load_instance_from_file(file_name: &str) -> (wasmi::Store<()>, wasmi::Instance) {
    let module = load_module_from_file(file_name);
    let linker = <wasmi::Linker<()>>::new(module.engine());
    let mut store = wasmi::Store::new(module.engine(), ());
    let instance = linker
        .instantiate(&mut store, &module)
        .unwrap()
        .start(&mut store)
        .unwrap();
    (store, instance)
}

/// Converts the `.wat` encoded `bytes` into `.wasm` encoded bytes.
pub fn wat2wasm(bytes: &[u8]) -> Vec<u8> {
    wat::parse_bytes(bytes).unwrap().into_owned()
}

/// Parses the Wasm source from the given `.wat` bytes into a Wasmi module.
///
/// # Note
///
/// This includes validation and compilation to Wasmi bytecode.
///
/// # Panics
///
/// If the benchmark Wasm file could not be opened, read or parsed.
pub fn load_instance_from_wat(wat_bytes: &[u8]) -> (wasmi::Store<()>, wasmi::Instance) {
    let wasm = wat2wasm(wat_bytes);
    let engine = wasmi::Engine::new(&bench_config());
    let module = wasmi::Module::new(&engine, &wasm[..]).unwrap();
    let linker = <wasmi::Linker<()>>::new(&engine);
    let mut store = wasmi::Store::new(&engine, ());
    let instance = linker
        .instantiate(&mut store, &module)
        .unwrap()
        .start(&mut store)
        .unwrap();
    (store, instance)
}

#[test]
fn test_load_and_execute() -> anyhow::Result<()> {
    let (mut process, _) = start_debugger(None, vec![], vec![])?;
    let example_dir = std::path::Path::new(file!())
        .parent()
        .unwrap()
        .join("/Users/edy/workspace/scalebit/motoko_debugger/wasminspect/tests/simple-example");
    let bytes = load_file(example_dir.join("calc.wasm").to_str().unwrap())?;
    process
        .debugger
        .load_main_module(&bytes, String::from("calc.wasm"))?;
    // process.debugger.instantiate(host_modules, Some(&args))?;

    fn bench_with(wasm: &[u8], n: usize) {
        /// How often the host functions are called per benchmark run.
        const ITERATIONS: i64 = 5_000;

        let (mut store, instance) = load_instance_from_wat(wasm);
        let func_name = format!("run/{n}");
        let run = instance
            .get_typed_func::<i64, i64>(&store, &func_name)
            .unwrap();
        eprintln!("run = {:?}", run);
        let result = run.call(&mut store, ITERATIONS).unwrap();
        eprintln!("result = {}", result);
    }

    let bytes2 = load_file(example_dir.join("/Users/edy/workspace/scalebit/motoko_debugger/wasmi/crates/wasmi/benches/wat/nested_calls.wat").to_str().unwrap())?;
    for n in [1, 8, 16] {
        bench_with(&bytes2, n);
    }
    // process.debugger.set_breakpoint(debugger::Breakpoint::Instruction{ inst_offset: 3});
    // let run_result = process
    //     .debugger
    //     .run(Some("add"), vec![WasmValue::I32(1), WasmValue::I32(2)])?;

    // match run_result {
    //     RunResult::Finish(finied_vec) => {
    //         eprintln!("finied_vec = {:?}", finied_vec);
    //     },
    //     RunResult::Breakpoint => {
    //         eprintln!("Breakpoint");
    //     }
    // }
    Ok(())
}
