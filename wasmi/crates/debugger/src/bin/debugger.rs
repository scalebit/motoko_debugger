use std::{collections::HashMap, env, io::Read};
use wasmi::CompilationMode;
use wasmi_debugger::{start_debugger, Debugger};
use wasmi_wasi::wasi_common;


fn main() -> anyhow::Result<()> {
    let args: Vec<String> = env::args().collect();
    let (mut process, _) = start_debugger(None, vec![], vec![])?;
    let wasm_file_path = std::path::Path::new(&args[1]);
    let random = wasi_common::sync::random_ctx();
    let clocks = wasi_common::sync::clocks_ctx();
    let sched = wasi_common::sync::sched_ctx();
    let table = wasi_common::Table::new();
    let ctx = wasi_common::WasiCtx::new(random, clocks, sched, table);

    process
        .debugger
        .instantiate(wasm_file_path, ctx, None, CompilationMode::Eager)?;
    println!("----------------------------------------------");
    println!("---------------- Wasm Debugger ---------------");
    process.debugger.run(
        Some("AddThree"), 
        [wasmi::Val::I32(10), wasmi::Val::I32(1)].to_vec()
    )?;
    Ok(())
}
