use std::{io::Read, str::FromStr};

use wasmi::CompilationMode;
use wasmi_debugger::{start_debugger, Debugger, RunResult};
use wasmi_wasi::wasi_common;

fn load_file(filename: &str) -> anyhow::Result<Vec<u8>> {
    let mut f = ::std::fs::File::open(filename)?;
    let mut buffer = Vec::new();
    f.read_to_end(&mut buffer)?;
    Ok(buffer)
}

#[test]
fn test_load_and_execute() -> anyhow::Result<()> {
    let (mut process, _) = start_debugger(None, vec![], vec![])?;
    let example_fille = 
        std::path::Path::new("/home/zax/rust-project/debugger/motoko_debugger/wasmi/crates/debugger/tests/test2.wasm");
    // let bytes = load_file(example_fille.to_str().unwrap())?;
    // let args = vec![];

    let random = wasi_common::sync::random_ctx();
    let clocks = wasi_common::sync::clocks_ctx();
    let sched = wasi_common::sync::sched_ctx();
    let table = wasi_common::Table::new();
    let ctx = wasi_common::WasiCtx::new(random, clocks, sched, table);

    // process
    //     .debugger
    //     .load_main_module(&bytes, String::from("test.wasm"))?;
    // process.debugger.set_breakpoint(wasmi_debugger::commands::debugger::Breakpoint::Instruction{ inst_offset: 3}); // 指令的位置 
    process.debugger.instantiate(&example_fille, ctx, None, CompilationMode::Eager)?; 
    // let run_result = process
    //     .debugger
    //     .run(Some("addTwo"), vec![WasmValue::I32(1), WasmValue::I32(2)])?;
    
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
