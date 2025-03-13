use super::command::{Command, CommandContext, CommandResult};
use super::debugger::Debugger;
use anyhow::Result;

use structopt::StructOpt;

pub struct GlobalCommand {}

impl GlobalCommand {
    pub fn new() -> Self {
        Self {}
    }
}

#[derive(StructOpt)]
enum Opts {
    #[structopt(name = "read")]
    Read {
        #[structopt(name = "name")]
        name: Option<String>,
    },
}

impl<D: Debugger> Command<D> for GlobalCommand {
    fn name(&self) -> &'static str {
        "global"
    }

    fn description(&self) -> &'static str {
        "Commands for operating globals."
    }

    fn run(
        &self,
        debugger: &mut D,
        context: &CommandContext,
        args: Vec<&str>,
    ) -> Result<Option<CommandResult>> {
        let opts = Opts::from_iter_safe(args)?;
        match opts {
            Opts::Read { name: None } => {
                // for (index, value) in debugger.locals().iter().enumerate() {
                //     let output = format!("{: <3}: {:?}", index, value);
                //     context.printer.println(&output);
                // }
            }
            Opts::Read { name: Some(name) } => {
                let global = debugger.global(&name);
                if let Some(global) = global {
                    let output = format!("{}: {:?}", name, global);
                    context.printer.println(&output);
                } else {
                    context.printer.eprintln(&format!("Global {} not found", name));
                }
            }
        }
        Ok(None)
    }
}
