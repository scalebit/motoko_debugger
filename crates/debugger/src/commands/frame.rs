use super::command::{Command, CommandContext, CommandResult};
use super::debugger::Debugger;
use anyhow::Result;

use structopt::StructOpt;

pub struct FrameCommand {}

impl FrameCommand {
    pub fn new() -> Self {
        Self {}
    }
}

#[derive(StructOpt)]
enum Opts {
    #[structopt(name = "variable")]
    Variable,
    #[structopt(name = "select")]
    Select {
        #[structopt(name = "index")]
        frame_index: usize,
    },
}

impl<D: Debugger> Command<D> for FrameCommand {
    fn name(&self) -> &'static str {
        "frame"
    }

    fn description(&self) -> &'static str {
        "Commands for selecting current stack frame."
    }

    #[allow(unused)]
    fn run(
        &self,
        debugger: &mut D,
        context: &CommandContext,
        args: Vec<&str>,
    ) -> Result<Option<CommandResult>> {
        let opts = Opts::from_iter_safe(args)?;
        match opts {
            Opts::Variable => {
                // <TODO><robin> show var
                // let (insts, next_index) = debugger.selected_instructions()?;
                // let current_index = if next_index == 0 { 0 } else { next_index - 1 };
                // let current_inst = insts[current_index].clone();
                // let variable_names = context.subroutine.variable_name_list(current_inst.offset)?;
                // for variable in variable_names {
                //     let output = format!("{}: {}", variable.name, variable.type_name);
                //     context.printer.println(&output);
                // }
                // Ok(None)
            }
            Opts::Select { frame_index } => {
                // debugger.select_frame(Some(frame_index))?;
                // Ok(None)
            }
        }
        Ok(None)
    }
}
