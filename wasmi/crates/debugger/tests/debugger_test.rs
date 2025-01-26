use std::{collections::HashMap, io::Read};
use wasmi::CompilationMode;
use wasmi_debugger::{start_debugger, Debugger};
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

    let bytes = load_file("/home/zax/rust-project/debugger/motoko_debugger/wasmi/crates/debugger/tests/addTwoExportWithMain4.wasm")?;
    let wasm_file_path = std::path::Path::new("/home/zax/rust-project/debugger/motoko_debugger/wasmi/crates/debugger/tests/addTwoExportWithMain4.wasm");
    let random = wasi_common::sync::random_ctx();
    let clocks = wasi_common::sync::clocks_ctx();
    let sched = wasi_common::sync::sched_ctx();
    let table = wasi_common::Table::new();
    let ctx = wasi_common::WasiCtx::new(random, clocks, sched, table);
    process
        .debugger
        .load_main_module(&bytes, String::from("calc.wasm"))?;
    process
        .debugger
        .instantiate(wasm_file_path, ctx, None, CompilationMode::Eager)?;
    process.debugger.run(Some("main"), [].to_vec())?;
    Ok(())
}
