use crate::RunResult;

use super::command::{Command, CommandContext, CommandResult};
use super::debugger::Debugger;
use anyhow::anyhow;
use anyhow::Result;
use structopt::StructOpt;
use wasmi::Val;
use wasmi_core::{F32, F64};

pub struct ProcessCommand {}

impl ProcessCommand {
    pub fn new() -> Self {
        Self {}
    }
}

#[derive(StructOpt)]
enum Opts {
    #[structopt(name = "continue")]
    Continue,

    /// Start WASI entry point
    #[structopt(name = "launch")]
    Launch {
        /// Entry point to start
        #[structopt(name = "FUNCTION NAME")]
        start: Option<String>,

        /// Arguments to pass to the WASI entry point
        #[structopt(name = "ARGS", last = true)]
        args: Vec<String>,
    },
}

impl<D: Debugger> Command<D> for ProcessCommand {
    fn name(&self) -> &'static str {
        "process"
    }

    fn description(&self) -> &'static str {
        "Commands for interacting with processes."
    }

    fn run(
        &self,
        debugger: &mut D,
        context: &CommandContext,
        args: Vec<&str>,
    ) -> Result<Option<CommandResult>> {
        let opts = Opts::from_iter_safe(args)?;
        match opts {
            Opts::Continue => match debugger.process()? {
                RunResult::Finish(result) => {
                    let output = format!("{:?}", result);
                    context.printer.println(&output);
                    return Ok(Some(CommandResult::ProcessFinish(result)));
                }
                RunResult::Breakpoint => {
                    context.printer.println("Hit breakpoint");
                }
                _ => {}
            },
            Opts::Launch { start, args } => {
                return self.start_debugger(debugger, context, start, args);
            }
        }
        Ok(None)
    }
}
impl ProcessCommand {
    fn start_debugger<D: Debugger>(
        &self,
        debugger: &mut D,
        context: &CommandContext,
        start: Option<String>,
        wasi_args: Vec<String>,
    ) -> Result<Option<CommandResult>> {
        use std::io::Write;
        if debugger.is_running() {
            print!("There is a running process, kill it and restart?: [Y/n] ");
            std::io::stdout().flush().unwrap();
            let stdin = std::io::stdin();
            let mut input = String::new();
            stdin.read_line(&mut input).unwrap();
            if input == "Y\n" || input == "y\n" {
                // return Ok(None);
                debugger.instantiate(context.sourcemap.inst_in_file_0())?;
            }
        } else {
            debugger.instantiate(context.sourcemap.inst_in_file_0())?;
        }
        

        let args = convert_to_val(wasi_args)?;

        match debugger.run(start.as_deref(), args) {
            Ok(RunResult::Finish(values)) => {
                let output = format!("finish: {:?}", values);
                context.printer.println(&output);
                return Ok(Some(CommandResult::ProcessFinish(values)));
            }
            Ok(RunResult::Breakpoint) => {
                context.printer.println("\nHit breakpoint");
            }
            Ok(RunResult::Next) => {}
            Err(msg) => {
                let output = format!("{}", msg);
                context.printer.eprintln(&output);
            }
        }
        Ok(None)
    }
}

fn convert_to_val(v: Vec<String>) -> Result<Vec<Val>> {
    v.into_iter()
        .map(|s| {
            if let Ok(val) = s.parse::<i32>() {
                Ok(Val::from(val))
            } else if let Ok(val) = s.parse::<f32>() {
                Ok(Val::from(F32::from(val)))
            } else if let Ok(val) = s.parse::<i64>() {
                Ok(Val::from(val))
            } else if let Ok(val) = s.parse::<f64>() {
                Ok(Val::from(F64::from(val)))
            } else {
                Err(anyhow!(format!(
                    "Failed to parse '{}' as a valid number",
                    s
                )))
            }
        })
        .collect::<Result<Vec<Val>>>() // 在这里收集结果，并返回错误
}
