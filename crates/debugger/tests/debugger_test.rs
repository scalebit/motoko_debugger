use std::{collections::HashMap, io::Read};
use wasmi::{CompilationMode, LinkerBuilder};
use wasmi_debugger::{commands::debugger::StepStyle, start_debugger, Debugger, RunResult};
use wasmi_wasi::{wasi_common, WasiCtxBuilder};

fn load_file(filename: &str) -> anyhow::Result<Vec<u8>> {
    let mut f = ::std::fs::File::open(filename)?;
    let mut buffer = Vec::new();
    f.read_to_end(&mut buffer)?;
    Ok(buffer)
}

#[test]
fn test_load_and_run() -> anyhow::Result<()> {
    let (mut process, _) = start_debugger(None, vec![], vec![])?;

    let bytes = load_file("/data/zhangxiao/rust-project/debugger/motoko_debugger/wasmi/crates/debugger/tests/addthree.wasm")?;
    // let wasm_file_path = std::path::Path::new("/data/zhangxiao/rust-project/debugger/motoko_debugger/wasmi/crates/debugger/tests/addthree.wasm");
    // let wasm_file_path = std::path::Path::new(
    //     "/data/zhangxiao/rust-project/debugger/motoko_debugger/wasminspect/tests/fib-wasm.mo.wasm",
    // );

    process
        .debugger
        .load_main_module(&bytes, String::from("addthree.wasm"))?;
    process.debugger.instantiate()?;

    let run_result = process.debugger.run(
        Some("AddThree"),
        [wasmi::Val::I32(10), wasmi::Val::I32(1)].to_vec(),
        // Some("testtt"),
        // [].to_vec(),
    )?;
    match run_result {
        RunResult::Finish(finied_vec) => {
            eprintln!("finied_vec = {:?}", finied_vec);
        }
        RunResult::Breakpoint => {
            eprintln!("Breakpoint");
        }
    }
    Ok(())
}

#[test]
fn test_load_and_step() -> anyhow::Result<()> {
    let (mut process, _) = start_debugger(None, vec![], vec![])?;

    // let wasm_file_path = std::path::Path::new(
    //     "/data/zhangxiao/rust-project/debugger/motoko_debugger/wasmi/crates/debugger/tests/test_step.wasm"
    // );
    let bytes = load_file("/data/zhangxiao/rust-project/debugger/motoko_debugger/crates/debugger/tests/test_step.wasm")?;
    process
        .debugger
        .load_main_module(&bytes, String::from("test_step.wasm"))?;

    process.debugger.instantiate()?;

    process.debugger.run_step(Some("testtt"), [].to_vec())?;

    process.debugger.step(StepStyle::InstOver)?;
    process.debugger.step(StepStyle::InstOver)?;
    process.debugger.step(StepStyle::InstOver)?;
    process.debugger.step(StepStyle::Out)?;
    process.debugger.step(StepStyle::Out)?;
    process.debugger.step(StepStyle::Out)?;
    Ok(())
}
