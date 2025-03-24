use super::command::{Command, CommandContext, CommandResult};
use super::debugger::Debugger;
use anyhow::Result;

use structopt::StructOpt;

pub struct LocalCommand {}

impl LocalCommand {
    pub fn new() -> Self {
        Self {}
    }
}

#[derive(StructOpt)]
enum Opts {
    #[structopt(name = "read")]
    Read {
        #[structopt(name = "NAME")]
        local_name: Option<String>,
    },
}

impl<D: Debugger> Command<D> for LocalCommand {
    fn name(&self) -> &'static str {
        "local"
    }

    fn description(&self) -> &'static str {
        "Commands for operating locals."
    }

    fn run(
        &self,
        debugger: &mut D,
        context: &CommandContext,
        args: Vec<&str>,
    ) -> Result<Option<CommandResult>> {
        let opts = Opts::from_iter_safe(args)?;
        let (func_idx, func_name, locals) = match debugger.locals() {
            Ok((func_idx, func_name, locals)) => (func_idx, func_name, locals),
            Err(e) => {
                context.printer.println(&format!("Error getting locals: {:?}", e));
                return Ok(None);
            }
        };

        match opts {
            Opts::Read { local_name: None } => {
                
                let output = format!("{}. function name: {}", func_idx, func_name);
                context.printer.println(&output);
                for (index, name, value) in locals.iter() {
                    let output = format!("  {: <3}. {: <10}: {:?}", index, name, value);
                    context.printer.println(&output);
                }
            }
            Opts::Read { local_name: Some(local_name) } => {
                let mut output = String::new();
                for (index, name, value) in locals.iter() {
                    if name.eq(&local_name) {
                        output = format!("{: <3}. {: <10}: {:?}", index, name, value);
                    }
                }
                if output.is_empty() {
                    context.printer.println(&format!("No local variable with name {:?} in function {:?}", local_name, func_name));
                } else {
                    context.printer.println(&output);
                }
            }
        }
        Ok(None)
    }
}
