use std::{collections::HashMap, io::Read};
use wasmi::{CompilationMode, LinkerBuilder};
use wasmi_debugger::{start_debugger, Debugger, RunResult};
use wasmi_wasi::{wasi_common, WasiCtxBuilder};

fn load_file(filename: &str) -> anyhow::Result<Vec<u8>> {
    let mut f = ::std::fs::File::open(filename)?;
    let mut buffer = Vec::new();
    f.read_to_end(&mut buffer)?;
    Ok(buffer)
}

#[test]
fn test_load_and_execute() -> anyhow::Result<()> {
    let (mut process, _) = start_debugger(None, vec![], vec![])?;

    // let bytes = load_file("/data/zhangxiao/rust-project/debugger/motoko_debugger/wasmi/crates/debugger/tests/addthree.wasm")?;
    let wasm_file_path = std::path::Path::new("/data/zhangxiao/rust-project/debugger/motoko_debugger/wasmi/crates/debugger/tests/addthree.wasm");
    // let wasm_file_path = std::path::Path::new(
    //     "/data/zhangxiao/rust-project/debugger/motoko_debugger/wasminspect/tests/fib-wasm.mo.wasm",
    // );
    let mut wasi_ctx_builder = WasiCtxBuilder::new();
    let ctx = wasi_ctx_builder.build();

    // process
    //     .debugger
    //     .load_main_module(&bytes, String::from("calc.wasm"))?;
    process
        .debugger
        .instantiate(wasm_file_path, ctx, None, CompilationMode::Eager)?;
    let run_result = process.debugger.run(
        Some("AddThree"),
        [wasmi::Val::I32(10), wasmi::Val::I32(1)].to_vec(),
        // None,
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
