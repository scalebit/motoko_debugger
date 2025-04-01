use super::command::AliasCommand;
use anyhow::Result;

pub struct RunCommand {}

impl RunCommand {
    pub fn new() -> Self {
        Self {}
    }
}

impl AliasCommand for RunCommand {
    fn name(&self) -> &'static str {
        "run"
    }

    fn run(&self, args: Vec<&str>) -> Result<String> {
        if args.len() == 1 {
            Ok(format!("{}", "process launch init"))
        } else {
            Ok(format!("{} {}", "process launch", args[1..].join(" ")))
        }
    }
}
