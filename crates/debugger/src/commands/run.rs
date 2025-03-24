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
        Ok(format!("{} {}", "process launch", args[1..].join(" ")))
    }
}
