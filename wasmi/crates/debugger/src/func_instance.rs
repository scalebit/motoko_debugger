use anyhow::Error;
use gimli::ValueType;
use wasmi::{engine::executor::instrs::ModuleIndex};
use wasmi_ir::{r#enum::transform_inst, ZaxInstruction, Instr};
use wasmparser::{FuncType, FunctionBody, OperatorsReader, ValType};
use std::iter;
// use wasmi_ir::Instruction:::

#[derive(Clone, Copy, Debug)]
pub struct InstIndex(pub u32);



pub struct DefinedFunctionInstance {
    name: String,
    ty: FuncType,
    module_index: ModuleIndex,
    instructions: Vec<ZaxInstruction>,
    default_locals: Vec<ValType>,
}


impl DefinedFunctionInstance {
    pub(crate) fn new(
        name: String,
        ty: FuncType,
        module_index: ModuleIndex,
        body: FunctionBody,
        base_offset: usize,
    ) -> Result<Self, Error> {
        
        let mut locals = Vec::new();
        let reader = body.get_locals_reader()?;
        for local in reader {
            let (count, value_type) = local?;
            let elements = iter::repeat(value_type).take(count as usize);
            locals.append(&mut elements.collect());
        }
        let mut reader = body.get_operators_reader()?;
        let mut instructions = Vec::new();
        while !reader.eof() {
            let inst = transform_inst(&mut reader, base_offset)?;
            instructions.push(inst);
        }

        // Compute default local values here instead of frame initialization
        // to avoid re-computation
        let mut local_tys = ty.params().to_vec();
        local_tys.append(&mut locals.to_vec());
        let mut default_locals = Vec::new();
        for ty in local_tys {
            default_locals.push(ty);
        }

        if false {
            unimplemented!("local initialization of type {:?}", ty)
        }

        Ok(Self {
            name,
            ty,
            module_index,
            instructions,
            default_locals,
        })
        
    }

    pub fn name(&self) -> &String {
        &self.name
    }

    pub fn ty(&self) -> &FuncType {
        &self.ty
    }

    pub fn module_index(&self) -> ModuleIndex {
        self.module_index
    }

    pub fn instructions(&self) -> &[ZaxInstruction] {
        &self.instructions
    }

    pub(crate) fn inst(&self, index: InstIndex) -> Option<&ZaxInstruction> {
        self.instructions.get(index.0 as usize)
    }

    pub(crate) fn default_locals(&self) -> &[ValType] {
        &self.default_locals
    }
}

