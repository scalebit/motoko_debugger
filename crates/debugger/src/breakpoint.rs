use std::collections::HashMap;

use crate::commands::debugger::Breakpoint;

#[derive(Default)]
pub struct Breakpoints {
    function_map: HashMap<String, Breakpoint>,
    inst_map: HashMap<usize, Breakpoint>,
    pub inst_in_file_0: Vec<u64>, // instr in file 0 for interrupt in first instr of file 0
}

impl Breakpoints {
    pub fn function_map(&self) -> &HashMap<String, Breakpoint> {
        &self.function_map
    }

    pub fn inst_map(&self) -> &HashMap<usize, Breakpoint> {
        &self.inst_map
    }

    pub fn should_break_func(&self, name: &str) -> bool {
        // FIXME
        self.function_map
            .keys()
            .any(|k| name.contains(Clone::clone(&k)))
    }

    pub fn should_break_inst(&self, inst: u32) -> bool {
        // self.inst_map.contains_key(&inst.offset)
        false
    }

    pub fn insert(&mut self, breakpoint: Breakpoint) {
        match &breakpoint {
            Breakpoint::Function { name } => {
                self.function_map.insert(name.clone(), breakpoint);
            }
            Breakpoint::Instruction { inst_offset } => {
                self.inst_map.insert(*inst_offset, breakpoint);
            }
        }
    }

    pub fn delete(&mut self, id: usize) -> Result<(), anyhow::Error> {
        if id >= self.function_map.len() + self.inst_map.len() {
            return Err(anyhow::anyhow!("Invalid breakpoint id"));
        }

        if id < self.function_map.len() {
            if let Some(key) = self.function_map.keys().nth(id).cloned() {
                self.function_map.remove(&key); 
                return Ok(());
            }
        } 

        let id = id - self.function_map.len();
        if let Some(key) = self.inst_map.keys().nth(id).cloned() {
            self.inst_map.remove(&key); 
            return Ok(());
        }
        Ok(())
    }
}