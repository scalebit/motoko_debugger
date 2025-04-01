use super::command::{Command, CommandContext, CommandResult};
use super::debugger::{Breakpoint, Debugger};
use anyhow::{anyhow, Result};
use structopt::StructOpt;
use super::command::AliasCommand;

pub struct BreakpointCommand {}

impl BreakpointCommand {
    pub fn new() -> Self {
        Self {}
    }
}

#[derive(StructOpt)]
enum Opts {
    /// Sets a breakpoint for the given symbol in executable
    #[structopt(name = "set")]
    Set(SetOpts),

    #[structopt(name = "list")]
    List,

    #[structopt(name = "delete")]
    Delete(DeleteOpts),
}

#[derive(StructOpt)]
struct SetOpts {
    #[structopt(short, long)]
    name: Option<String>,
    #[structopt(short, long)]
    address: Option<String>,
}

#[derive(StructOpt, Debug)]
pub struct DeleteOpts {
    /// The breakpoint ID to delete
    pub id: usize,
}


impl SetOpts {
    fn breakpoint(self) -> Result<Breakpoint> {
        if let Some(name) = self.name {
            Ok(Breakpoint::Function { name })
        } else if let Some(address) = self.address {
            let address = if address.starts_with("0x") {
                let raw = address.trim_start_matches("0x");
                usize::from_str_radix(raw, 16)?
            } else {
                address.parse::<usize>()?
            };
            Ok(Breakpoint::Instruction {
                inst_offset: address,
            })
        } else {
            Err(anyhow!("no breakpoint option"))
        }
    }
}

impl<D: Debugger> Command<D> for BreakpointCommand {
    fn name(&self) -> &'static str {
        "breakpoint"
    }

    fn description(&self) -> &'static str {
        "Commands for operating on breakpoints."
    }

    fn run(
        &self,
        debugger: &mut D,
        context: &CommandContext,
        args: Vec<&str>,
    ) -> Result<Option<CommandResult>> {
        let opts = Opts::from_iter_safe(args)?;
        match opts {
            Opts::Set(opts) => {
                debugger.set_breakpoint(opts.breakpoint()?);
                Ok(None)
            }
            Opts::List => {
                let breakpoints = debugger.list_breakpoints();
                for (index, breakpoint) in breakpoints.iter().enumerate() {
                    match breakpoint {
                        Breakpoint::Function { name } => {
                            let output = format!("{: <2}. function({})", index, name);
                            context.printer.println(&output);
                        }
                        Breakpoint::Instruction { inst_offset: _ } => {}
                    }
                }
                Ok(None)
            }
            Opts::Delete(opts) => {
                debugger.delete_breakpoint(opts.id)?;
                Ok(None)
            }
        }
    }
}




pub struct AliasBpCommand {}

impl AliasBpCommand {
    pub fn new() -> Self {
        Self {}
    }
}

impl AliasCommand for AliasBpCommand {
    fn name(&self) -> &'static str {
        "bp"
    }

    fn run(&self, args: Vec<&str>) -> Result<String> {
        Ok(format!("{} {}", "breakpoint", args[1..].join(" ")))
    }
}