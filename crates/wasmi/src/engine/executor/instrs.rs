use std::println;

use wasmi_collections::arena::ArenaIndex;

pub use self::call::{dispatch_host_func, ResumableHostError};
use super::{cache::CachedInstance, InstructionPtr, Stack};
use crate::{
    core::{hint, Trap, TrapCode, UntypedVal},
    engine::{
        code_map::CodeMap,
        executor::stack::{CallFrame, FrameRegisters, ValueStack},
        utils::unreachable_unchecked,
        DedupFuncType, EngineFunc,
    },
    ir::{index, BlockFuel, Const16, Instruction, Reg, ShiftAmount},
    memory::DataSegment,
    store::StoreInner,
    table::ElementSegment,
    Error, Func, FuncRef, Global, Memory, Store, Table,
};

// use std::hash::Hash;

#[cfg(doc)]
use crate::Instance;

mod binary;
mod branch;
mod call;
mod comparison;
mod conversion;
mod copy;
mod global;
mod load;
mod memory;
mod return_;
mod select;
mod store;
mod table;
mod unary;

pub enum Signal {
    Next,
    Breakpoint,
    End,
}

macro_rules! forward_return {
    ($expr:expr) => {{
        if hint::unlikely($expr.is_break()) {
            return Ok(());
        }
    }};
}

macro_rules! forward_return_dbg {
    ($self:expr, $expr:expr) => {{
        if $self.stack.calls.is_empty() {
            return Ok(Signal::End); // 如果为空，返回 Signal::End
        }

        if hint::unlikely($expr.is_break()) {
            return Ok(Signal::End);
        }
    }};
}

/// Executes compiled function instructions until execution returns from the root function.
///
/// # Errors
///
/// If the execution encounters a trap.
#[inline(never)]
pub fn execute_instrs<'engine, T>(
    store: &mut Store<T>,
    stack: &'engine mut Stack,
    code_map: &'engine CodeMap,
) -> Result<(), Error> {
    let instance = stack.calls.instance_expect();
    let cache = CachedInstance::new(&mut store.inner, instance);
    Executor::new(stack, code_map, cache).execute(store)
}

pub type ExecResult<T> = Result<T, Trap>;

#[derive(Copy, Clone, Hash, PartialEq, Eq, Debug)]
pub struct ModuleIndex(pub u32);

/// An execution context for executing a Wasmi function frame.
#[derive(Debug)]
pub struct Executor<'engine> {
    /// Stores the value stack of live values on the Wasm stack.
    pub sp: FrameRegisters,
    /// The pointer to the currently executed instruction.
    pub ip: InstructionPtr,
    /// The cached instance and instance related data.
    pub cache: CachedInstance,
    /// The value and call stacks.
    pub stack: &'engine mut Stack,
    /// The static resources of an [`Engine`].
    ///
    /// [`Engine`]: crate::Engine
    pub code_map: &'engine CodeMap,
}

impl<'engine> Executor<'engine> {
    /// Creates a new [`Executor`] for executing a Wasmi function frame.
    #[inline(always)]
    pub fn new(
        stack: &'engine mut Stack,
        code_map: &'engine CodeMap,
        cache: CachedInstance,
    ) -> Self {
        let frame = stack
            .calls
            .peek()
            .expect("must have call frame on the call stack");
        // Safety: We are using the frame's own base offset as input because it is
        //         guaranteed by the Wasm validation and translation phase to be
        //         valid for all register indices used by the associated function body.
        let sp = unsafe { stack.values.stack_ptr_at(frame.base_offset()) };
        let ip = frame.instr_ptr();
        Self {
            sp,
            ip,
            cache,
            stack,
            code_map,
        }
    }

    // AddTwo: CallInternal -> I32Add -> GlobalSet -> ReturnReg -> main: CallInternal -> I32Add -> GlobalSet -> ReturnReg -> Return
    /// Executes the function frame until it returns or traps.
    #[inline(always)]
    fn execute<T>(mut self, store: &mut Store<T>) -> Result<(), Error> {
        use Instruction as Instr;
        loop {
            match *self.ip.get() {
                Instr::Trap { instr_offset: _, trap_code } => self.execute_trap(trap_code)?,
                Instr::ConsumeFuel { instr_offset: _, block_fuel } => {
                    self.execute_consume_fuel(&mut store.inner, block_fuel)?
                }
                Instr::Return { instr_offset: _ } => {
                    forward_return!(self.execute_return(&mut store.inner))
                }
                Instr::ReturnReg { instr_offset: _, value } => {
                    forward_return!(self.execute_return_reg(&mut store.inner, value))
                }
                Instr::ReturnReg2 { instr_offset: _, values } => {
                    forward_return!(self.execute_return_reg2(&mut store.inner, values))
                }
                Instr::ReturnReg3 { instr_offset: _, values } => {
                    forward_return!(self.execute_return_reg3(&mut store.inner, values))
                }
                Instr::ReturnImm32 { instr_offset: _, value } => {
                    forward_return!(self.execute_return_imm32(&mut store.inner, value))
                }
                Instr::ReturnI64Imm32 { instr_offset: _, value } => {
                    forward_return!(self.execute_return_i64imm32(&mut store.inner, value))
                }
                Instr::ReturnF64Imm32 { instr_offset: _, value } => {
                    forward_return!(self.execute_return_f64imm32(&mut store.inner, value))
                }
                Instr::ReturnSpan { instr_offset: _, values } => {
                    forward_return!(self.execute_return_span(&mut store.inner, values))
                }
                Instr::ReturnMany { instr_offset: _, values } => {
                    forward_return!(self.execute_return_many(&mut store.inner, values))
                }
                Instr::ReturnNez { instr_offset: _, condition } => {
                    forward_return!(self.execute_return_nez(&mut store.inner, condition))
                }
                Instr::ReturnNezReg { instr_offset: _, condition, value } => {
                    forward_return!(self.execute_return_nez_reg(&mut store.inner, condition, value))
                }
                Instr::ReturnNezReg2 { instr_offset: _, condition, values } => {
                    forward_return!(self.execute_return_nez_reg2(
                        &mut store.inner,
                        condition,
                        values
                    ))
                }
                Instr::ReturnNezImm32 { instr_offset: _, condition, value } => {
                    forward_return!(self.execute_return_nez_imm32(
                        &mut store.inner,
                        condition,
                        value
                    ))
                }
                Instr::ReturnNezI64Imm32 { instr_offset: _, condition, value } => {
                    forward_return!(self.execute_return_nez_i64imm32(
                        &mut store.inner,
                        condition,
                        value
                    ))
                }
                Instr::ReturnNezF64Imm32 { instr_offset: _, condition, value } => {
                    forward_return!(self.execute_return_nez_f64imm32(
                        &mut store.inner,
                        condition,
                        value
                    ))
                }
                Instr::ReturnNezSpan { instr_offset: _, condition, values } => {
                    forward_return!(self.execute_return_nez_span(
                        &mut store.inner,
                        condition,
                        values
                    ))
                }
                Instr::ReturnNezMany { instr_offset: _, condition, values } => {
                    forward_return!(self.execute_return_nez_many(
                        &mut store.inner,
                        condition,
                        values
                    ))
                }
                Instr::Branch { instr_offset: _, offset } => self.execute_branch(offset),
                Instr::BranchTable0 { instr_offset: _, index, len_targets } => {
                    self.execute_branch_table_0(index, len_targets)
                }
                Instr::BranchTable1 { instr_offset: _, index, len_targets } => {
                    self.execute_branch_table_1(index, len_targets)
                }
                Instr::BranchTable2 { instr_offset: _, index, len_targets } => {
                    self.execute_branch_table_2(index, len_targets)
                }
                Instr::BranchTable3 { instr_offset: _, index, len_targets } => {
                    self.execute_branch_table_3(index, len_targets)
                }
                Instr::BranchTableSpan { instr_offset: _, index, len_targets } => {
                    self.execute_branch_table_span(index, len_targets)
                }
                Instr::BranchTableMany { instr_offset: _, index, len_targets } => {
                    self.execute_branch_table_many(index, len_targets)
                }
                Instr::BranchCmpFallback { instr_offset: _, lhs, rhs, params } => {
                    self.execute_branch_cmp_fallback(lhs, rhs, params)
                }
                Instr::BranchI32And { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_and(lhs, rhs, offset)
                }
                Instr::BranchI32AndImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_and_imm(lhs, rhs, offset)
                }
                Instr::BranchI32Or { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_or(lhs, rhs, offset)
                }
                Instr::BranchI32OrImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_or_imm(lhs, rhs, offset)
                }
                Instr::BranchI32Xor { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_xor(lhs, rhs, offset)
                }
                Instr::BranchI32XorImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_xor_imm(lhs, rhs, offset)
                }
                Instr::BranchI32AndEqz { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_and_eqz(lhs, rhs, offset)
                }
                Instr::BranchI32AndEqzImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_and_eqz_imm(lhs, rhs, offset)
                }
                Instr::BranchI32OrEqz { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_or_eqz(lhs, rhs, offset)
                }
                Instr::BranchI32OrEqzImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_or_eqz_imm(lhs, rhs, offset)
                }
                Instr::BranchI32XorEqz { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_xor_eqz(lhs, rhs, offset)
                }
                Instr::BranchI32XorEqzImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_xor_eqz_imm(lhs, rhs, offset)
                }
                Instr::BranchI32Eq { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_eq(lhs, rhs, offset)
                }
                Instr::BranchI32EqImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_eq_imm(lhs, rhs, offset)
                }
                Instr::BranchI32Ne { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_ne(lhs, rhs, offset)
                }
                Instr::BranchI32NeImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_ne_imm(lhs, rhs, offset)
                }
                Instr::BranchI32LtS { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_lt_s(lhs, rhs, offset)
                }
                Instr::BranchI32LtSImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_lt_s_imm(lhs, rhs, offset)
                }
                Instr::BranchI32LtU { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_lt_u(lhs, rhs, offset)
                }
                Instr::BranchI32LtUImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_lt_u_imm(lhs, rhs, offset)
                }
                Instr::BranchI32LeS { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_le_s(lhs, rhs, offset)
                }
                Instr::BranchI32LeSImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_le_s_imm(lhs, rhs, offset)
                }
                Instr::BranchI32LeU { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_le_u(lhs, rhs, offset)
                }
                Instr::BranchI32LeUImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_le_u_imm(lhs, rhs, offset)
                }
                Instr::BranchI32GtS { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_gt_s(lhs, rhs, offset)
                }
                Instr::BranchI32GtSImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_gt_s_imm(lhs, rhs, offset)
                }
                Instr::BranchI32GtU { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_gt_u(lhs, rhs, offset)
                }
                Instr::BranchI32GtUImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_gt_u_imm(lhs, rhs, offset)
                }
                Instr::BranchI32GeS { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_ge_s(lhs, rhs, offset)
                }
                Instr::BranchI32GeSImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_ge_s_imm(lhs, rhs, offset)
                }
                Instr::BranchI32GeU { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_ge_u(lhs, rhs, offset)
                }
                Instr::BranchI32GeUImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i32_ge_u_imm(lhs, rhs, offset)
                }
                Instr::BranchI64Eq { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_eq(lhs, rhs, offset)
                }
                Instr::BranchI64EqImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_eq_imm(lhs, rhs, offset)
                }
                Instr::BranchI64Ne { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_ne(lhs, rhs, offset)
                }
                Instr::BranchI64NeImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_ne_imm(lhs, rhs, offset)
                }
                Instr::BranchI64LtS { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_lt_s(lhs, rhs, offset)
                }
                Instr::BranchI64LtSImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_lt_s_imm(lhs, rhs, offset)
                }
                Instr::BranchI64LtU { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_lt_u(lhs, rhs, offset)
                }
                Instr::BranchI64LtUImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_lt_u_imm(lhs, rhs, offset)
                }
                Instr::BranchI64LeS { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_le_s(lhs, rhs, offset)
                }
                Instr::BranchI64LeSImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_le_s_imm(lhs, rhs, offset)
                }
                Instr::BranchI64LeU { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_le_u(lhs, rhs, offset)
                }
                Instr::BranchI64LeUImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_le_u_imm(lhs, rhs, offset)
                }
                Instr::BranchI64GtS { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_gt_s(lhs, rhs, offset)
                }
                Instr::BranchI64GtSImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_gt_s_imm(lhs, rhs, offset)
                }
                Instr::BranchI64GtU { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_gt_u(lhs, rhs, offset)
                }
                Instr::BranchI64GtUImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_gt_u_imm(lhs, rhs, offset)
                }
                Instr::BranchI64GeS { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_ge_s(lhs, rhs, offset)
                }
                Instr::BranchI64GeSImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_ge_s_imm(lhs, rhs, offset)
                }
                Instr::BranchI64GeU { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_ge_u(lhs, rhs, offset)
                }
                Instr::BranchI64GeUImm { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_i64_ge_u_imm(lhs, rhs, offset)
                }
                Instr::BranchF32Eq { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f32_eq(lhs, rhs, offset)
                }
                Instr::BranchF32Ne { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f32_ne(lhs, rhs, offset)
                }
                Instr::BranchF32Lt { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f32_lt(lhs, rhs, offset)
                }
                Instr::BranchF32Le { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f32_le(lhs, rhs, offset)
                }
                Instr::BranchF32Gt { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f32_gt(lhs, rhs, offset)
                }
                Instr::BranchF32Ge { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f32_ge(lhs, rhs, offset)
                }
                Instr::BranchF64Eq { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f64_eq(lhs, rhs, offset)
                }
                Instr::BranchF64Ne { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f64_ne(lhs, rhs, offset)
                }
                Instr::BranchF64Lt { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f64_lt(lhs, rhs, offset)
                }
                Instr::BranchF64Le { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f64_le(lhs, rhs, offset)
                }
                Instr::BranchF64Gt { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f64_gt(lhs, rhs, offset)
                }
                Instr::BranchF64Ge { instr_offset: _, lhs, rhs, offset } => {
                    self.execute_branch_f64_ge(lhs, rhs, offset)
                }
                Instr::Copy { instr_offset: _, result, value } => self.execute_copy(result, value),
                Instr::Copy2 { instr_offset: _, results, values } => self.execute_copy_2(results, values),
                Instr::CopyImm32 { instr_offset: _, result, value } => self.execute_copy_imm32(result, value),
                Instr::CopyI64Imm32 { instr_offset: _, result, value } => self.execute_copy_i64imm32(result, value),
                Instr::CopyF64Imm32 { instr_offset: _, result, value } => self.execute_copy_f64imm32(result, value),
                Instr::CopySpan {
                    instr_offset: _,
                    results,
                    values,
                    len,
                } => self.execute_copy_span(results, values, len),
                Instr::CopySpanNonOverlapping {
                    instr_offset: _,
                    results,
                    values,
                    len,
                } => self.execute_copy_span_non_overlapping(results, values, len),
                Instr::CopyMany { instr_offset: _, results, values } => self.execute_copy_many(results, values),
                Instr::CopyManyNonOverlapping { instr_offset: _, results, values } => {
                    self.execute_copy_many_non_overlapping(results, values)
                }
                Instr::ReturnCallInternal0 { instr_offset: _, func } => {
                    self.execute_return_call_internal_0(&mut store.inner, EngineFunc::from(func))?
                }
                Instr::ReturnCallInternal { instr_offset: _, func } => {
                    self.execute_return_call_internal(&mut store.inner, EngineFunc::from(func))?
                }
                Instr::ReturnCallImported0 { instr_offset: _, func } => {
                    self.execute_return_call_imported_0::<T>(store, func)?
                }
                Instr::ReturnCallImported { instr_offset: _, func } => {
                    self.execute_return_call_imported::<T>(store, func)?
                }
                Instr::ReturnCallIndirect0 { instr_offset: _, func_type } => {
                    self.execute_return_call_indirect_0::<T>(store, func_type)?
                }
                Instr::ReturnCallIndirect0Imm16 { instr_offset: _, func_type } => {
                    self.execute_return_call_indirect_0_imm16::<T>(store, func_type)?
                }
                Instr::ReturnCallIndirect { instr_offset: _, func_type } => {
                    self.execute_return_call_indirect::<T>(store, func_type)?
                }
                Instr::ReturnCallIndirectImm16 { instr_offset: _, func_type } => {
                    self.execute_return_call_indirect_imm16::<T>(store, func_type)?
                }
                Instr::CallInternal0 { instr_offset: _, results, func } => {
                    self.execute_call_internal_0(&mut store.inner, results, EngineFunc::from(func))?
                }
                Instr::CallInternal { instr_offset: _, results, func } => {
                    self.execute_call_internal(&mut store.inner, results, EngineFunc::from(func))?
                }
                Instr::CallImported0 { instr_offset: _, results, func } => {
                    self.execute_call_imported_0::<T>(store, results, func)?
                }
                Instr::CallImported { instr_offset: _, results, func } => {
                    self.execute_call_imported::<T>(store, results, func)?
                }
                Instr::CallIndirect0 { instr_offset: _, results, func_type } => {
                    self.execute_call_indirect_0::<T>(store, results, func_type)?;
                }
                Instr::CallIndirect0Imm16 { instr_offset: _, results, func_type } => {
                    self.execute_call_indirect_0_imm16::<T>(store, results, func_type)?;
                }
                Instr::CallIndirect { instr_offset: _, results, func_type } => {
                    self.execute_call_indirect::<T>(store, results, func_type)?;
                }
                Instr::CallIndirectImm16 { instr_offset: _, results, func_type } => {
                    self.execute_call_indirect_imm16::<T>(store, results, func_type)?;
                }
                Instr::Select { instr_offset: _, result, lhs } => self.execute_select(result, lhs),
                Instr::SelectImm32Rhs { instr_offset: _, result, lhs } => self.execute_select_imm32_rhs(result, lhs),
                Instr::SelectImm32Lhs { instr_offset: _, result, lhs } => self.execute_select_imm32_lhs(result, lhs),
                Instr::SelectImm32 { instr_offset: _, result, lhs } => self.execute_select_imm32(result, lhs),
                Instr::SelectI64Imm32Rhs { instr_offset: _, result, lhs } => {
                    self.execute_select_i64imm32_rhs(result, lhs)
                }
                Instr::SelectI64Imm32Lhs { instr_offset: _, result, lhs } => {
                    self.execute_select_i64imm32_lhs(result, lhs)
                }
                Instr::SelectI64Imm32 { instr_offset: _, result, lhs } => self.execute_select_i64imm32(result, lhs),
                Instr::SelectF64Imm32Rhs { instr_offset: _, result, lhs } => {
                    self.execute_select_f64imm32_rhs(result, lhs)
                }
                Instr::SelectF64Imm32Lhs { instr_offset: _, result, lhs } => {
                    self.execute_select_f64imm32_lhs(result, lhs)
                }
                Instr::SelectF64Imm32 { instr_offset: _, result, lhs } => self.execute_select_f64imm32(result, lhs),
                Instr::RefFunc { instr_offset: _, result, func } => self.execute_ref_func(result, func),
                Instr::GlobalGet { instr_offset: _, result, global } => {
                    self.execute_global_get(&store.inner, result, global)
                }
                Instr::GlobalSet { instr_offset: _, global, input } => {
                    self.execute_global_set(&mut store.inner, global, input)
                }
                Instr::GlobalSetI32Imm16 { instr_offset: _, global, input } => {
                    self.execute_global_set_i32imm16(&mut store.inner, global, input)
                }
                Instr::GlobalSetI64Imm16 { instr_offset: _, global, input } => {
                    self.execute_global_set_i64imm16(&mut store.inner, global, input)
                }
                Instr::I32Load { instr_offset: _, result, memory } => {
                    self.execute_i32_load(&store.inner, result, memory)?
                }
                Instr::I32LoadAt { instr_offset: _, result, address } => {
                    self.execute_i32_load_at(&store.inner, result, address)?
                }
                Instr::I32LoadOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i32_load_offset16(result, ptr, offset)?,
                Instr::I64Load { instr_offset: _, result, memory } => {
                    self.execute_i64_load(&store.inner, result, memory)?
                }
                Instr::I64LoadAt { instr_offset: _, result, address } => {
                    self.execute_i64_load_at(&store.inner, result, address)?
                }
                Instr::I64LoadOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i64_load_offset16(result, ptr, offset)?,
                Instr::F32Load { instr_offset: _, result, memory } => {
                    self.execute_f32_load(&store.inner, result, memory)?
                }
                Instr::F32LoadAt { instr_offset: _, result, address } => {
                    self.execute_f32_load_at(&store.inner, result, address)?
                }
                Instr::F32LoadOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_f32_load_offset16(result, ptr, offset)?,
                Instr::F64Load { instr_offset: _, result, memory } => {
                    self.execute_f64_load(&store.inner, result, memory)?
                }
                Instr::F64LoadAt { instr_offset: _, result, address } => {
                    self.execute_f64_load_at(&store.inner, result, address)?
                }
                Instr::F64LoadOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_f64_load_offset16(result, ptr, offset)?,
                Instr::I32Load8s { instr_offset: _, result, memory } => {
                    self.execute_i32_load8_s(&store.inner, result, memory)?
                }
                Instr::I32Load8sAt { instr_offset: _, result, address } => {
                    self.execute_i32_load8_s_at(&store.inner, result, address)?
                }
                Instr::I32Load8sOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i32_load8_s_offset16(result, ptr, offset)?,
                Instr::I32Load8u { instr_offset: _, result, memory } => {
                    self.execute_i32_load8_u(&store.inner, result, memory)?
                }
                Instr::I32Load8uAt { instr_offset: _, result, address } => {
                    self.execute_i32_load8_u_at(&store.inner, result, address)?
                }
                Instr::I32Load8uOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i32_load8_u_offset16(result, ptr, offset)?,
                Instr::I32Load16s { instr_offset: _, result, memory } => {
                    self.execute_i32_load16_s(&store.inner, result, memory)?
                }
                Instr::I32Load16sAt { instr_offset: _, result, address } => {
                    self.execute_i32_load16_s_at(&store.inner, result, address)?
                }
                Instr::I32Load16sOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i32_load16_s_offset16(result, ptr, offset)?,
                Instr::I32Load16u { instr_offset: _, result, memory } => {
                    self.execute_i32_load16_u(&store.inner, result, memory)?
                }
                Instr::I32Load16uAt { instr_offset: _, result, address } => {
                    self.execute_i32_load16_u_at(&store.inner, result, address)?
                }
                Instr::I32Load16uOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i32_load16_u_offset16(result, ptr, offset)?,
                Instr::I64Load8s { instr_offset: _, result, memory } => {
                    self.execute_i64_load8_s(&store.inner, result, memory)?
                }
                Instr::I64Load8sAt { instr_offset: _, result, address } => {
                    self.execute_i64_load8_s_at(&store.inner, result, address)?
                }
                Instr::I64Load8sOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i64_load8_s_offset16(result, ptr, offset)?,
                Instr::I64Load8u { instr_offset: _, result, memory } => {
                    self.execute_i64_load8_u(&store.inner, result, memory)?
                }
                Instr::I64Load8uAt { instr_offset: _, result, address } => {
                    self.execute_i64_load8_u_at(&store.inner, result, address)?
                }
                Instr::I64Load8uOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i64_load8_u_offset16(result, ptr, offset)?,
                Instr::I64Load16s { instr_offset: _, result, memory } => {
                    self.execute_i64_load16_s(&store.inner, result, memory)?
                }
                Instr::I64Load16sAt { instr_offset: _, result, address } => {
                    self.execute_i64_load16_s_at(&store.inner, result, address)?
                }
                Instr::I64Load16sOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i64_load16_s_offset16(result, ptr, offset)?,
                Instr::I64Load16u { instr_offset: _, result, memory } => {
                    self.execute_i64_load16_u(&store.inner, result, memory)?
                }
                Instr::I64Load16uAt { instr_offset: _, result, address } => {
                    self.execute_i64_load16_u_at(&store.inner, result, address)?
                }
                Instr::I64Load16uOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i64_load16_u_offset16(result, ptr, offset)?,
                Instr::I64Load32s { instr_offset: _, result, memory } => {
                    self.execute_i64_load32_s(&store.inner, result, memory)?
                }
                Instr::I64Load32sAt { instr_offset: _, result, address } => {
                    self.execute_i64_load32_s_at(&store.inner, result, address)?
                }
                Instr::I64Load32sOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i64_load32_s_offset16(result, ptr, offset)?,
                Instr::I64Load32u { instr_offset: _, result, memory } => {
                    self.execute_i64_load32_u(&store.inner, result, memory)?
                }
                Instr::I64Load32uAt { instr_offset: _, result, address } => {
                    self.execute_i64_load32_u_at(&store.inner, result, address)?
                }
                Instr::I64Load32uOffset16 {
                    instr_offset: _,
                    result,
                    ptr,
                    offset,
                } => self.execute_i64_load32_u_offset16(result, ptr, offset)?,
                Instr::I32Store { instr_offset: _, ptr, memory } => {
                    self.execute_i32_store(&mut store.inner, ptr, memory)?
                }
                Instr::I32StoreImm16 { instr_offset: _, ptr, memory } => {
                    self.execute_i32_store_imm16(&mut store.inner, ptr, memory)?
                }
                Instr::I32StoreOffset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i32_store_offset16(ptr, offset, value)?
                }
                Instr::I32StoreOffset16Imm16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i32_store_offset16_imm16(ptr, offset, value)?
                }
                Instr::I32StoreAt { instr_offset: _, address, value } => {
                    self.execute_i32_store_at(&mut store.inner, address, value)?
                }
                Instr::I32StoreAtImm16 { instr_offset: _, address, value } => {
                    self.execute_i32_store_at_imm16(&mut store.inner, address, value)?
                }
                Instr::I32Store8 { instr_offset: _, ptr, memory } => {
                    self.execute_i32_store8(&mut store.inner, ptr, memory)?
                }
                Instr::I32Store8Imm { instr_offset: _, ptr, memory } => {
                    self.execute_i32_store8_imm(&mut store.inner, ptr, memory)?
                }
                Instr::I32Store8Offset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i32_store8_offset16(ptr, offset, value)?
                }
                Instr::I32Store8Offset16Imm { instr_offset: _, ptr, offset, value } => {
                    self.execute_i32_store8_offset16_imm(ptr, offset, value)?
                }
                Instr::I32Store8At { instr_offset: _, address, value } => {
                    self.execute_i32_store8_at(&mut store.inner, address, value)?
                }
                Instr::I32Store8AtImm { instr_offset: _, address, value } => {
                    self.execute_i32_store8_at_imm(&mut store.inner, address, value)?
                }
                Instr::I32Store16 { instr_offset: _, ptr, memory } => {
                    self.execute_i32_store16(&mut store.inner, ptr, memory)?
                }
                Instr::I32Store16Imm { instr_offset: _, ptr, memory } => {
                    self.execute_i32_store16_imm(&mut store.inner, ptr, memory)?
                }
                Instr::I32Store16Offset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i32_store16_offset16(ptr, offset, value)?
                }
                Instr::I32Store16Offset16Imm { instr_offset: _, ptr, offset, value } => {
                    self.execute_i32_store16_offset16_imm(ptr, offset, value)?
                }
                Instr::I32Store16At { instr_offset: _, address, value } => {
                    self.execute_i32_store16_at(&mut store.inner, address, value)?
                }
                Instr::I32Store16AtImm { instr_offset: _, address, value } => {
                    self.execute_i32_store16_at_imm(&mut store.inner, address, value)?
                }
                Instr::I64Store { instr_offset: _, ptr, memory } => {
                    self.execute_i64_store(&mut store.inner, ptr, memory)?
                }
                Instr::I64StoreImm16 { instr_offset: _, ptr, memory } => {
                    self.execute_i64_store_imm16(&mut store.inner, ptr, memory)?
                }
                Instr::I64StoreOffset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i64_store_offset16(ptr, offset, value)?
                }
                Instr::I64StoreOffset16Imm16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i64_store_offset16_imm16(ptr, offset, value)?
                }
                Instr::I64StoreAt { instr_offset: _, address, value } => {
                    self.execute_i64_store_at(&mut store.inner, address, value)?
                }
                Instr::I64StoreAtImm16 { instr_offset: _, address, value } => {
                    self.execute_i64_store_at_imm16(&mut store.inner, address, value)?
                }
                Instr::I64Store8 { instr_offset: _, ptr, memory } => {
                    self.execute_i64_store8(&mut store.inner, ptr, memory)?
                }
                Instr::I64Store8Imm { instr_offset: _, ptr, memory } => {
                    self.execute_i64_store8_imm(&mut store.inner, ptr, memory)?
                }
                Instr::I64Store8Offset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i64_store8_offset16(ptr, offset, value)?
                }
                Instr::I64Store8Offset16Imm { instr_offset: _, ptr, offset, value } => {
                    self.execute_i64_store8_offset16_imm(ptr, offset, value)?
                }
                Instr::I64Store8At { instr_offset: _, address, value } => {
                    self.execute_i64_store8_at(&mut store.inner, address, value)?
                }
                Instr::I64Store8AtImm { instr_offset: _, address, value } => {
                    self.execute_i64_store8_at_imm(&mut store.inner, address, value)?
                }
                Instr::I64Store16 { instr_offset: _, ptr, memory } => {
                    self.execute_i64_store16(&mut store.inner, ptr, memory)?
                }
                Instr::I64Store16Imm { instr_offset: _, ptr, memory } => {
                    self.execute_i64_store16_imm(&mut store.inner, ptr, memory)?
                }
                Instr::I64Store16Offset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i64_store16_offset16(ptr, offset, value)?
                }
                Instr::I64Store16Offset16Imm { instr_offset: _, ptr, offset, value } => {
                    self.execute_i64_store16_offset16_imm(ptr, offset, value)?
                }
                Instr::I64Store16At { instr_offset: _, address, value } => {
                    self.execute_i64_store16_at(&mut store.inner, address, value)?
                }
                Instr::I64Store16AtImm { instr_offset: _, address, value } => {
                    self.execute_i64_store16_at_imm(&mut store.inner, address, value)?
                }
                Instr::I64Store32 { instr_offset: _, ptr, memory } => {
                    self.execute_i64_store32(&mut store.inner, ptr, memory)?
                }
                Instr::I64Store32Imm16 { instr_offset: _, ptr, memory } => {
                    self.execute_i64_store32_imm16(&mut store.inner, ptr, memory)?
                }
                Instr::I64Store32Offset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i64_store32_offset16(ptr, offset, value)?
                }
                Instr::I64Store32Offset16Imm16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_i64_store32_offset16_imm16(ptr, offset, value)?
                }
                Instr::I64Store32At { instr_offset: _, address, value } => {
                    self.execute_i64_store32_at(&mut store.inner, address, value)?
                }
                Instr::I64Store32AtImm16 { instr_offset: _, address, value } => {
                    self.execute_i64_store32_at_imm16(&mut store.inner, address, value)?
                }
                Instr::F32Store { instr_offset: _, ptr, memory } => {
                    self.execute_f32_store(&mut store.inner, ptr, memory)?
                }
                Instr::F32StoreOffset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_f32_store_offset16(ptr, offset, value)?
                }
                Instr::F32StoreAt { instr_offset: _, address, value } => {
                    self.execute_f32_store_at(&mut store.inner, address, value)?
                }
                Instr::F64Store { instr_offset: _, ptr, memory } => {
                    self.execute_f64_store(&mut store.inner, ptr, memory)?
                }
                Instr::F64StoreOffset16 { instr_offset: _, ptr, offset, value } => {
                    self.execute_f64_store_offset16(ptr, offset, value)?
                }
                Instr::F64StoreAt { instr_offset: _, address, value } => {
                    self.execute_f64_store_at(&mut store.inner, address, value)?
                }
                Instr::I32Eq { instr_offset: _, result, lhs, rhs } => self.execute_i32_eq(result, lhs, rhs),
                Instr::I32EqImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_eq_imm16(result, lhs, rhs)
                }
                Instr::I32Ne { instr_offset: _, result, lhs, rhs } => self.execute_i32_ne(result, lhs, rhs),
                Instr::I32NeImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_ne_imm16(result, lhs, rhs)
                }
                Instr::I32LtS { instr_offset: _, result, lhs, rhs } => self.execute_i32_lt_s(result, lhs, rhs),
                Instr::I32LtSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_lt_s_imm16(result, lhs, rhs)
                }
                Instr::I32LtU { instr_offset: _, result, lhs, rhs } => self.execute_i32_lt_u(result, lhs, rhs),
                Instr::I32LtUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_lt_u_imm16(result, lhs, rhs)
                }
                Instr::I32LeS { instr_offset: _, result, lhs, rhs } => self.execute_i32_le_s(result, lhs, rhs),
                Instr::I32LeSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_le_s_imm16(result, lhs, rhs)
                }
                Instr::I32LeU { instr_offset: _, result, lhs, rhs } => self.execute_i32_le_u(result, lhs, rhs),
                Instr::I32LeUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_le_u_imm16(result, lhs, rhs)
                }
                Instr::I32GtS { instr_offset: _, result, lhs, rhs } => self.execute_i32_gt_s(result, lhs, rhs),
                Instr::I32GtSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_gt_s_imm16(result, lhs, rhs)
                }
                Instr::I32GtU { instr_offset: _, result, lhs, rhs } => self.execute_i32_gt_u(result, lhs, rhs),
                Instr::I32GtUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_gt_u_imm16(result, lhs, rhs)
                }
                Instr::I32GeS { instr_offset: _, result, lhs, rhs } => self.execute_i32_ge_s(result, lhs, rhs),
                Instr::I32GeSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_ge_s_imm16(result, lhs, rhs)
                }
                Instr::I32GeU { instr_offset: _, result, lhs, rhs } => self.execute_i32_ge_u(result, lhs, rhs),
                Instr::I32GeUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_ge_u_imm16(result, lhs, rhs)
                }
                Instr::I64Eq { instr_offset: _, result, lhs, rhs } => self.execute_i64_eq(result, lhs, rhs),
                Instr::I64EqImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_eq_imm16(result, lhs, rhs)
                }
                Instr::I64Ne { instr_offset: _, result, lhs, rhs } => self.execute_i64_ne(result, lhs, rhs),
                Instr::I64NeImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_ne_imm16(result, lhs, rhs)
                }
                Instr::I64LtS { instr_offset: _, result, lhs, rhs } => self.execute_i64_lt_s(result, lhs, rhs),
                Instr::I64LtSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_lt_s_imm16(result, lhs, rhs)
                }
                Instr::I64LtU { instr_offset: _, result, lhs, rhs } => self.execute_i64_lt_u(result, lhs, rhs),
                Instr::I64LtUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_lt_u_imm16(result, lhs, rhs)
                }
                Instr::I64LeS { instr_offset: _, result, lhs, rhs } => self.execute_i64_le_s(result, lhs, rhs),
                Instr::I64LeSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_le_s_imm16(result, lhs, rhs)
                }
                Instr::I64LeU { instr_offset: _, result, lhs, rhs } => self.execute_i64_le_u(result, lhs, rhs),
                Instr::I64LeUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_le_u_imm16(result, lhs, rhs)
                }
                Instr::I64GtS { instr_offset: _, result, lhs, rhs } => self.execute_i64_gt_s(result, lhs, rhs),
                Instr::I64GtSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_gt_s_imm16(result, lhs, rhs)
                }
                Instr::I64GtU { instr_offset: _, result, lhs, rhs } => self.execute_i64_gt_u(result, lhs, rhs),
                Instr::I64GtUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_gt_u_imm16(result, lhs, rhs)
                }
                Instr::I64GeS { instr_offset: _, result, lhs, rhs } => self.execute_i64_ge_s(result, lhs, rhs),
                Instr::I64GeSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_ge_s_imm16(result, lhs, rhs)
                }
                Instr::I64GeU { instr_offset: _, result, lhs, rhs } => self.execute_i64_ge_u(result, lhs, rhs),
                Instr::I64GeUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_ge_u_imm16(result, lhs, rhs)
                }
                Instr::F32Eq { instr_offset: _, result, lhs, rhs } => self.execute_f32_eq(result, lhs, rhs),
                Instr::F32Ne { instr_offset: _, result, lhs, rhs } => self.execute_f32_ne(result, lhs, rhs),
                Instr::F32Lt { instr_offset: _, result, lhs, rhs } => self.execute_f32_lt(result, lhs, rhs),
                Instr::F32Le { instr_offset: _, result, lhs, rhs } => self.execute_f32_le(result, lhs, rhs),
                Instr::F32Gt { instr_offset: _, result, lhs, rhs } => self.execute_f32_gt(result, lhs, rhs),
                Instr::F32Ge { instr_offset: _, result, lhs, rhs } => self.execute_f32_ge(result, lhs, rhs),
                Instr::F64Eq { instr_offset: _, result, lhs, rhs } => self.execute_f64_eq(result, lhs, rhs),
                Instr::F64Ne { instr_offset: _, result, lhs, rhs } => self.execute_f64_ne(result, lhs, rhs),
                Instr::F64Lt { instr_offset: _, result, lhs, rhs } => self.execute_f64_lt(result, lhs, rhs),
                Instr::F64Le { instr_offset: _, result, lhs, rhs } => self.execute_f64_le(result, lhs, rhs),
                Instr::F64Gt { instr_offset: _, result, lhs, rhs } => self.execute_f64_gt(result, lhs, rhs),
                Instr::F64Ge { instr_offset: _, result, lhs, rhs } => self.execute_f64_ge(result, lhs, rhs),
                Instr::I32Clz { instr_offset: _, result, input } => self.execute_i32_clz(result, input),
                Instr::I32Ctz { instr_offset: _, result, input } => self.execute_i32_ctz(result, input),
                Instr::I32Popcnt { instr_offset: _, result, input } => self.execute_i32_popcnt(result, input),
                Instr::I32Add { instr_offset: _, result, lhs, rhs } => self.execute_i32_add(result, lhs, rhs),
                Instr::I32AddImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_add_imm16(result, lhs, rhs)
                }
                Instr::I32Sub { instr_offset: _, result, lhs, rhs } => self.execute_i32_sub(result, lhs, rhs),
                Instr::I32SubImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_sub_imm16_lhs(result, lhs, rhs)
                }
                Instr::I32Mul { instr_offset: _, result, lhs, rhs } => self.execute_i32_mul(result, lhs, rhs),
                Instr::I32MulImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_mul_imm16(result, lhs, rhs)
                }
                Instr::I32DivS { instr_offset: _, result, lhs, rhs } => self.execute_i32_div_s(result, lhs, rhs)?,
                Instr::I32DivSImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_div_s_imm16_rhs(result, lhs, rhs)?
                }
                Instr::I32DivSImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_div_s_imm16_lhs(result, lhs, rhs)?
                }
                Instr::I32DivU { instr_offset: _, result, lhs, rhs } => self.execute_i32_div_u(result, lhs, rhs)?,
                Instr::I32DivUImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_div_u_imm16_rhs(result, lhs, rhs)
                }
                Instr::I32DivUImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_div_u_imm16_lhs(result, lhs, rhs)?
                }
                Instr::I32RemS { instr_offset: _, result, lhs, rhs } => self.execute_i32_rem_s(result, lhs, rhs)?,
                Instr::I32RemSImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_rem_s_imm16_rhs(result, lhs, rhs)?
                }
                Instr::I32RemSImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_rem_s_imm16_lhs(result, lhs, rhs)?
                }
                Instr::I32RemU { instr_offset: _, result, lhs, rhs } => self.execute_i32_rem_u(result, lhs, rhs)?,
                Instr::I32RemUImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_rem_u_imm16_rhs(result, lhs, rhs)
                }
                Instr::I32RemUImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_rem_u_imm16_lhs(result, lhs, rhs)?
                }
                Instr::I32And { instr_offset: _, result, lhs, rhs } => self.execute_i32_and(result, lhs, rhs),
                Instr::I32AndEqz { instr_offset: _, result, lhs, rhs } => self.execute_i32_and_eqz(result, lhs, rhs),
                Instr::I32AndEqzImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_and_eqz_imm16(result, lhs, rhs)
                }
                Instr::I32AndImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_and_imm16(result, lhs, rhs)
                }
                Instr::I32Or { instr_offset: _, result, lhs, rhs } => self.execute_i32_or(result, lhs, rhs),
                Instr::I32OrEqz { instr_offset: _, result, lhs, rhs } => self.execute_i32_or_eqz(result, lhs, rhs),
                Instr::I32OrEqzImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_or_eqz_imm16(result, lhs, rhs)
                }
                Instr::I32OrImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_or_imm16(result, lhs, rhs)
                }
                Instr::I32Xor { instr_offset: _, result, lhs, rhs } => self.execute_i32_xor(result, lhs, rhs),
                Instr::I32XorEqz { instr_offset: _, result, lhs, rhs } => self.execute_i32_xor_eqz(result, lhs, rhs),
                Instr::I32XorEqzImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_xor_eqz_imm16(result, lhs, rhs)
                }
                Instr::I32XorImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_xor_imm16(result, lhs, rhs)
                }
                Instr::I32Shl { instr_offset: _, result, lhs, rhs } => self.execute_i32_shl(result, lhs, rhs),
                Instr::I32ShlBy { instr_offset: _, result, lhs, rhs } => self.execute_i32_shl_by(result, lhs, rhs),
                Instr::I32ShlImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_shl_imm16(result, lhs, rhs)
                }
                Instr::I32ShrU { instr_offset: _, result, lhs, rhs } => self.execute_i32_shr_u(result, lhs, rhs),
                Instr::I32ShrUBy { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_shr_u_by(result, lhs, rhs)
                }
                Instr::I32ShrUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_shr_u_imm16(result, lhs, rhs)
                }
                Instr::I32ShrS { instr_offset: _, result, lhs, rhs } => self.execute_i32_shr_s(result, lhs, rhs),
                Instr::I32ShrSBy { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_shr_s_by(result, lhs, rhs)
                }
                Instr::I32ShrSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_shr_s_imm16(result, lhs, rhs)
                }
                Instr::I32Rotl { instr_offset: _, result, lhs, rhs } => self.execute_i32_rotl(result, lhs, rhs),
                Instr::I32RotlBy { instr_offset: _, result, lhs, rhs } => self.execute_i32_rotl_by(result, lhs, rhs),
                Instr::I32RotlImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_rotl_imm16(result, lhs, rhs)
                }
                Instr::I32Rotr { instr_offset: _, result, lhs, rhs } => self.execute_i32_rotr(result, lhs, rhs),
                Instr::I32RotrBy { instr_offset: _, result, lhs, rhs } => self.execute_i32_rotr_by(result, lhs, rhs),
                Instr::I32RotrImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i32_rotr_imm16(result, lhs, rhs)
                }
                Instr::I64Clz { instr_offset: _, result, input } => self.execute_i64_clz(result, input),
                Instr::I64Ctz { instr_offset: _, result, input } => self.execute_i64_ctz(result, input),
                Instr::I64Popcnt { instr_offset: _, result, input } => self.execute_i64_popcnt(result, input),
                Instr::I64Add { instr_offset: _, result, lhs, rhs } => self.execute_i64_add(result, lhs, rhs),
                Instr::I64AddImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_add_imm16(result, lhs, rhs)
                }
                Instr::I64Sub { instr_offset: _, result, lhs, rhs } => self.execute_i64_sub(result, lhs, rhs),
                Instr::I64SubImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_sub_imm16_lhs(result, lhs, rhs)
                }
                Instr::I64Mul { instr_offset: _, result, lhs, rhs } => self.execute_i64_mul(result, lhs, rhs),
                Instr::I64MulImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_mul_imm16(result, lhs, rhs)
                }
                Instr::I64DivS { instr_offset: _, result, lhs, rhs } => self.execute_i64_div_s(result, lhs, rhs)?,
                Instr::I64DivSImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_div_s_imm16_rhs(result, lhs, rhs)?
                }
                Instr::I64DivSImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_div_s_imm16_lhs(result, lhs, rhs)?
                }
                Instr::I64DivU { instr_offset: _, result, lhs, rhs } => self.execute_i64_div_u(result, lhs, rhs)?,
                Instr::I64DivUImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_div_u_imm16_rhs(result, lhs, rhs)
                }
                Instr::I64DivUImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_div_u_imm16_lhs(result, lhs, rhs)?
                }
                Instr::I64RemS { instr_offset: _, result, lhs, rhs } => self.execute_i64_rem_s(result, lhs, rhs)?,
                Instr::I64RemSImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_rem_s_imm16_rhs(result, lhs, rhs)?
                }
                Instr::I64RemSImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_rem_s_imm16_lhs(result, lhs, rhs)?
                }
                Instr::I64RemU { instr_offset: _, result, lhs, rhs } => self.execute_i64_rem_u(result, lhs, rhs)?,
                Instr::I64RemUImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_rem_u_imm16_rhs(result, lhs, rhs)
                }
                Instr::I64RemUImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_rem_u_imm16_lhs(result, lhs, rhs)?
                }
                Instr::I64And { instr_offset: _, result, lhs, rhs } => self.execute_i64_and(result, lhs, rhs),
                Instr::I64AndImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_and_imm16(result, lhs, rhs)
                }
                Instr::I64Or { instr_offset: _, result, lhs, rhs } => self.execute_i64_or(result, lhs, rhs),
                Instr::I64OrImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_or_imm16(result, lhs, rhs)
                }
                Instr::I64Xor { instr_offset: _, result, lhs, rhs } => self.execute_i64_xor(result, lhs, rhs),
                Instr::I64XorImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_xor_imm16(result, lhs, rhs)
                }
                Instr::I64Shl { instr_offset: _, result, lhs, rhs } => self.execute_i64_shl(result, lhs, rhs),
                Instr::I64ShlBy { instr_offset: _, result, lhs, rhs } => self.execute_i64_shl_by(result, lhs, rhs),
                Instr::I64ShlImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_shl_imm16(result, lhs, rhs)
                }
                Instr::I64ShrU { instr_offset: _, result, lhs, rhs } => self.execute_i64_shr_u(result, lhs, rhs),
                Instr::I64ShrUBy { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_shr_u_by(result, lhs, rhs)
                }
                Instr::I64ShrUImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_shr_u_imm16(result, lhs, rhs)
                }
                Instr::I64ShrS { instr_offset: _, result, lhs, rhs } => self.execute_i64_shr_s(result, lhs, rhs),
                Instr::I64ShrSBy { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_shr_s_by(result, lhs, rhs)
                }
                Instr::I64ShrSImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_shr_s_imm16(result, lhs, rhs)
                }
                Instr::I64Rotl { instr_offset: _, result, lhs, rhs } => self.execute_i64_rotl(result, lhs, rhs),
                Instr::I64RotlBy { instr_offset: _, result, lhs, rhs } => self.execute_i64_rotl_by(result, lhs, rhs),
                Instr::I64RotlImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_rotl_imm16(result, lhs, rhs)
                }
                Instr::I64Rotr { instr_offset: _, result, lhs, rhs } => self.execute_i64_rotr(result, lhs, rhs),
                Instr::I64RotrBy { instr_offset: _, result, lhs, rhs } => self.execute_i64_rotr_by(result, lhs, rhs),
                Instr::I64RotrImm16 { instr_offset: _, result, lhs, rhs } => {
                    self.execute_i64_rotr_imm16(result, lhs, rhs)
                }
                Instr::I32WrapI64 { instr_offset: _, result, input } => self.execute_i32_wrap_i64(result, input),
                Instr::I32Extend8S { instr_offset: _, result, input } => self.execute_i32_extend8_s(result, input),
                Instr::I32Extend16S { instr_offset: _, result, input } => self.execute_i32_extend16_s(result, input),
                Instr::I64Extend8S { instr_offset: _, result, input } => self.execute_i64_extend8_s(result, input),
                Instr::I64Extend16S { instr_offset: _, result, input } => self.execute_i64_extend16_s(result, input),
                Instr::I64Extend32S { instr_offset: _, result, input } => self.execute_i64_extend32_s(result, input),
                Instr::F32Abs { instr_offset: _, result, input } => self.execute_f32_abs(result, input),
                Instr::F32Neg { instr_offset: _, result, input } => self.execute_f32_neg(result, input),
                Instr::F32Ceil { instr_offset: _, result, input } => self.execute_f32_ceil(result, input),
                Instr::F32Floor { instr_offset: _, result, input } => self.execute_f32_floor(result, input),
                Instr::F32Trunc { instr_offset: _, result, input } => self.execute_f32_trunc(result, input),
                Instr::F32Nearest { instr_offset: _, result, input } => self.execute_f32_nearest(result, input),
                Instr::F32Sqrt { instr_offset: _, result, input } => self.execute_f32_sqrt(result, input),
                Instr::F32Add { instr_offset: _, result, lhs, rhs } => self.execute_f32_add(result, lhs, rhs),
                Instr::F32Sub { instr_offset: _, result, lhs, rhs } => self.execute_f32_sub(result, lhs, rhs),
                Instr::F32Mul { instr_offset: _, result, lhs, rhs } => self.execute_f32_mul(result, lhs, rhs),
                Instr::F32Div { instr_offset: _, result, lhs, rhs } => self.execute_f32_div(result, lhs, rhs),
                Instr::F32Min { instr_offset: _, result, lhs, rhs } => self.execute_f32_min(result, lhs, rhs),
                Instr::F32Max { instr_offset: _, result, lhs, rhs } => self.execute_f32_max(result, lhs, rhs),
                Instr::F32Copysign { instr_offset: _, result, lhs, rhs } => {
                    self.execute_f32_copysign(result, lhs, rhs)
                }
                Instr::F32CopysignImm { instr_offset: _, result, lhs, rhs } => {
                    self.execute_f32_copysign_imm(result, lhs, rhs)
                }
                Instr::F64Abs { instr_offset: _, result, input } => self.execute_f64_abs(result, input),
                Instr::F64Neg { instr_offset: _, result, input } => self.execute_f64_neg(result, input),
                Instr::F64Ceil { instr_offset: _, result, input } => self.execute_f64_ceil(result, input),
                Instr::F64Floor { instr_offset: _, result, input } => self.execute_f64_floor(result, input),
                Instr::F64Trunc { instr_offset: _, result, input } => self.execute_f64_trunc(result, input),
                Instr::F64Nearest { instr_offset: _, result, input } => self.execute_f64_nearest(result, input),
                Instr::F64Sqrt { instr_offset: _, result, input } => self.execute_f64_sqrt(result, input),
                Instr::F64Add { instr_offset: _, result, lhs, rhs } => self.execute_f64_add(result, lhs, rhs),
                Instr::F64Sub { instr_offset: _, result, lhs, rhs } => self.execute_f64_sub(result, lhs, rhs),
                Instr::F64Mul { instr_offset: _, result, lhs, rhs } => self.execute_f64_mul(result, lhs, rhs),
                Instr::F64Div { instr_offset: _, result, lhs, rhs } => self.execute_f64_div(result, lhs, rhs),
                Instr::F64Min { instr_offset: _, result, lhs, rhs } => self.execute_f64_min(result, lhs, rhs),
                Instr::F64Max { instr_offset: _, result, lhs, rhs } => self.execute_f64_max(result, lhs, rhs),
                Instr::F64Copysign { instr_offset: _, result, lhs, rhs } => {
                    self.execute_f64_copysign(result, lhs, rhs)
                }
                Instr::F64CopysignImm { instr_offset: _, result, lhs, rhs } => {
                    self.execute_f64_copysign_imm(result, lhs, rhs)
                }
                Instr::I32TruncF32S { instr_offset: _, result, input } => {
                    self.execute_i32_trunc_f32_s(result, input)?
                }
                Instr::I32TruncF32U { instr_offset: _, result, input } => {
                    self.execute_i32_trunc_f32_u(result, input)?
                }
                Instr::I32TruncF64S { instr_offset: _, result, input } => {
                    self.execute_i32_trunc_f64_s(result, input)?
                }
                Instr::I32TruncF64U { instr_offset: _, result, input } => {
                    self.execute_i32_trunc_f64_u(result, input)?
                }
                Instr::I64TruncF32S { instr_offset: _, result, input } => {
                    self.execute_i64_trunc_f32_s(result, input)?
                }
                Instr::I64TruncF32U { instr_offset: _, result, input } => {
                    self.execute_i64_trunc_f32_u(result, input)?
                }
                Instr::I64TruncF64S { instr_offset: _, result, input } => {
                    self.execute_i64_trunc_f64_s(result, input)?
                }
                Instr::I64TruncF64U { instr_offset: _, result, input } => {
                    self.execute_i64_trunc_f64_u(result, input)?
                }
                Instr::I32TruncSatF32S { instr_offset: _, result, input } => {
                    self.execute_i32_trunc_sat_f32_s(result, input)
                }
                Instr::I32TruncSatF32U { instr_offset: _, result, input } => {
                    self.execute_i32_trunc_sat_f32_u(result, input)
                }
                Instr::I32TruncSatF64S { instr_offset: _, result, input } => {
                    self.execute_i32_trunc_sat_f64_s(result, input)
                }
                Instr::I32TruncSatF64U { instr_offset: _, result, input } => {
                    self.execute_i32_trunc_sat_f64_u(result, input)
                }
                Instr::I64TruncSatF32S { instr_offset: _, result, input } => {
                    self.execute_i64_trunc_sat_f32_s(result, input)
                }
                Instr::I64TruncSatF32U { instr_offset: _, result, input } => {
                    self.execute_i64_trunc_sat_f32_u(result, input)
                }
                Instr::I64TruncSatF64S { instr_offset: _, result, input } => {
                    self.execute_i64_trunc_sat_f64_s(result, input)
                }
                Instr::I64TruncSatF64U { instr_offset: _, result, input } => {
                    self.execute_i64_trunc_sat_f64_u(result, input)
                }
                Instr::F32DemoteF64 { instr_offset: _, result, input } => self.execute_f32_demote_f64(result, input),
                Instr::F64PromoteF32 { instr_offset: _, result, input } => {
                    self.execute_f64_promote_f32(result, input)
                }
                Instr::F32ConvertI32S { instr_offset: _, result, input } => {
                    self.execute_f32_convert_i32_s(result, input)
                }
                Instr::F32ConvertI32U { instr_offset: _, result, input } => {
                    self.execute_f32_convert_i32_u(result, input)
                }
                Instr::F32ConvertI64S { instr_offset: _, result, input } => {
                    self.execute_f32_convert_i64_s(result, input)
                }
                Instr::F32ConvertI64U { instr_offset: _, result, input } => {
                    self.execute_f32_convert_i64_u(result, input)
                }
                Instr::F64ConvertI32S { instr_offset: _, result, input } => {
                    self.execute_f64_convert_i32_s(result, input)
                }
                Instr::F64ConvertI32U { instr_offset: _, result, input } => {
                    self.execute_f64_convert_i32_u(result, input)
                }
                Instr::F64ConvertI64S { instr_offset: _, result, input } => {
                    self.execute_f64_convert_i64_s(result, input)
                }
                Instr::F64ConvertI64U { instr_offset: _, result, input } => {
                    self.execute_f64_convert_i64_u(result, input)
                }
                Instr::TableGet { instr_offset: _, result, index } => {
                    self.execute_table_get(&store.inner, result, index)?
                }
                Instr::TableGetImm { instr_offset: _, result, index } => {
                    self.execute_table_get_imm(&store.inner, result, index)?
                }
                Instr::TableSize { instr_offset: _, result, table } => {
                    self.execute_table_size(&store.inner, result, table)
                }
                Instr::TableSet { instr_offset: _, index, value } => {
                    self.execute_table_set(&mut store.inner, index, value)?
                }
                Instr::TableSetAt { instr_offset: _, index, value } => {
                    self.execute_table_set_at(&mut store.inner, index, value)?
                }
                Instr::TableCopy { instr_offset: _, dst, src, len } => {
                    self.execute_table_copy(&mut store.inner, dst, src, len)?
                }
                Instr::TableCopyTo { instr_offset: _, dst, src, len } => {
                    self.execute_table_copy_to(&mut store.inner, dst, src, len)?
                }
                Instr::TableCopyFrom { instr_offset: _, dst, src, len } => {
                    self.execute_table_copy_from(&mut store.inner, dst, src, len)?
                }
                Instr::TableCopyFromTo { instr_offset: _, dst, src, len } => {
                    self.execute_table_copy_from_to(&mut store.inner, dst, src, len)?
                }
                Instr::TableCopyExact { instr_offset: _, dst, src, len } => {
                    self.execute_table_copy_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableCopyToExact { instr_offset: _, dst, src, len } => {
                    self.execute_table_copy_to_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableCopyFromExact { instr_offset: _, dst, src, len } => {
                    self.execute_table_copy_from_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableCopyFromToExact { instr_offset: _, dst, src, len } => {
                    self.execute_table_copy_from_to_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableInit { instr_offset: _, dst, src, len } => {
                    self.execute_table_init(&mut store.inner, dst, src, len)?
                }
                Instr::TableInitTo { instr_offset: _, dst, src, len } => {
                    self.execute_table_init_to(&mut store.inner, dst, src, len)?
                }
                Instr::TableInitFrom { instr_offset: _, dst, src, len } => {
                    self.execute_table_init_from(&mut store.inner, dst, src, len)?
                }
                Instr::TableInitFromTo { instr_offset: _, dst, src, len } => {
                    self.execute_table_init_from_to(&mut store.inner, dst, src, len)?
                }
                Instr::TableInitExact { instr_offset: _, dst, src, len } => {
                    self.execute_table_init_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableInitToExact { instr_offset: _, dst, src, len } => {
                    self.execute_table_init_to_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableInitFromExact { instr_offset: _, dst, src, len } => {
                    self.execute_table_init_from_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableInitFromToExact { instr_offset: _, dst, src, len } => {
                    self.execute_table_init_from_to_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableFill { instr_offset: _, dst, len, value } => {
                    self.execute_table_fill(&mut store.inner, dst, len, value)?
                }
                Instr::TableFillAt { instr_offset: _, dst, len, value } => {
                    self.execute_table_fill_at(&mut store.inner, dst, len, value)?
                }
                Instr::TableFillExact { instr_offset: _, dst, len, value } => {
                    self.execute_table_fill_exact(&mut store.inner, dst, len, value)?
                }
                Instr::TableFillAtExact { instr_offset: _, dst, len, value } => {
                    self.execute_table_fill_at_exact(&mut store.inner, dst, len, value)?
                }
                Instr::TableGrow {
                    instr_offset: _,
                    result,
                    delta,
                    value,
                } => self.execute_table_grow(store, result, delta, value)?,
                Instr::TableGrowImm {
                    instr_offset: _,
                    result,
                    delta,
                    value,
                } => self.execute_table_grow_imm(store, result, delta, value)?,
                Instr::ElemDrop { instr_offset: _, index } => self.execute_element_drop(&mut store.inner, index),
                Instr::DataDrop { instr_offset: _, index } => self.execute_data_drop(&mut store.inner, index),
                Instr::MemorySize { instr_offset: _, result, memory } => {
                    self.execute_memory_size(&store.inner, result, memory)
                }
                Instr::MemoryGrow { instr_offset: _, result, delta } => {
                    self.execute_memory_grow(store, result, delta)?
                }
                Instr::MemoryGrowBy { instr_offset: _, result, delta } => {
                    self.execute_memory_grow_by(store, result, delta)?
                }
                Instr::MemoryCopy { instr_offset: _, dst, src, len } => {
                    self.execute_memory_copy(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryCopyTo { instr_offset: _, dst, src, len } => {
                    self.execute_memory_copy_to(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryCopyFrom { instr_offset: _, dst, src, len } => {
                    self.execute_memory_copy_from(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryCopyFromTo { instr_offset: _, dst, src, len } => {
                    self.execute_memory_copy_from_to(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryCopyExact { instr_offset: _, dst, src, len } => {
                    self.execute_memory_copy_exact(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryCopyToExact { instr_offset: _, dst, src, len } => {
                    self.execute_memory_copy_to_exact(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryCopyFromExact { instr_offset: _, dst, src, len } => {
                    self.execute_memory_copy_from_exact(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryCopyFromToExact { instr_offset: _, dst, src, len } => {
                    self.execute_memory_copy_from_to_exact(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryFill { instr_offset: _, dst, value, len } => {
                    self.execute_memory_fill(&mut store.inner, dst, value, len)?
                }
                Instr::MemoryFillAt { instr_offset: _, dst, value, len } => {
                    self.execute_memory_fill_at(&mut store.inner, dst, value, len)?
                }
                Instr::MemoryFillImm { instr_offset: _, dst, value, len } => {
                    self.execute_memory_fill_imm(&mut store.inner, dst, value, len)?
                }
                Instr::MemoryFillExact { instr_offset: _, dst, value, len } => {
                    self.execute_memory_fill_exact(&mut store.inner, dst, value, len)?
                }
                Instr::MemoryFillAtImm { instr_offset: _, dst, value, len } => {
                    self.execute_memory_fill_at_imm(&mut store.inner, dst, value, len)?
                }
                Instr::MemoryFillAtExact { instr_offset: _, dst, value, len } => {
                    self.execute_memory_fill_at_exact(&mut store.inner, dst, value, len)?
                }
                Instr::MemoryFillImmExact { instr_offset: _, dst, value, len } => {
                    self.execute_memory_fill_imm_exact(&mut store.inner, dst, value, len)?
                }
                Instr::MemoryFillAtImmExact { instr_offset: _, dst, value, len } => {
                    self.execute_memory_fill_at_imm_exact(&mut store.inner, dst, value, len)?
                }
                Instr::MemoryInit { instr_offset: _, dst, src, len } => {
                    self.execute_memory_init(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryInitTo { instr_offset: _, dst, src, len } => {
                    self.execute_memory_init_to(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryInitFrom { instr_offset: _, dst, src, len } => {
                    self.execute_memory_init_from(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryInitFromTo { instr_offset: _, dst, src, len } => {
                    self.execute_memory_init_from_to(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryInitExact { instr_offset: _, dst, src, len } => {
                    self.execute_memory_init_exact(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryInitToExact { instr_offset: _, dst, src, len } => {
                    self.execute_memory_init_to_exact(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryInitFromExact { instr_offset: _, dst, src, len } => {
                    self.execute_memory_init_from_exact(&mut store.inner, dst, src, len)?
                }
                Instr::MemoryInitFromToExact { instr_offset: _, dst, src, len } => {
                    self.execute_memory_init_from_to_exact(&mut store.inner, dst, src, len)?
                }
                Instr::TableIndex { .. }
                | Instr::MemoryIndex { .. }
                | Instr::DataIndex { .. }
                | Instr::ElemIndex { .. }
                | Instr::Const32 { .. }
                | Instr::I64Const32 { .. }
                | Instr::F64Const32 { .. }
                | Instr::BranchTableTarget { .. }
                | Instr::BranchTableTargetNonOverlapping { .. }
                | Instr::Register { .. }
                | Instr::Register2 { .. }
                | Instr::Register3 { .. }
                | Instr::RegisterAndImm32 { .. }
                | Instr::Imm16AndImm32 { .. }
                | Instr::RegisterSpan { .. }
                | Instr::RegisterList { .. }
                | Instr::CallIndirectParams { .. }
                | Instr::CallIndirectParamsImm16 { .. } => self.invalid_instruction_word()?,
            }
        }
    }
}

impl<'engine> Executor<'engine> {
    pub fn execute_step<T, I: Interceptor>(
        &mut self,
        store: &mut Store<T>,
        interceptor: &I,
    ) -> Result<Signal, Error> {
        let signal_inst = interceptor.execute_inst(self.ip.get().get_offset() as u32);

        let mut call_idx = -1;
        let mut table_idx = None;
        let result = self.execute_instr(store, &mut call_idx, &mut table_idx)?;
        let signal_call = if call_idx != -1 {
            if let Some(table_idx) = table_idx {
                let table = self.get_table(table_idx);
                interceptor.invoke_func(call_idx, Some(table))
            } else {
                interceptor.invoke_func(call_idx, None)
            }
        } else {
            Signal::Next
        };

        Ok(match (signal_inst, signal_call, result) {
            (_, _, Signal::End) => Signal::End,
            (Signal::Breakpoint, _, Signal::Next) => Signal::Breakpoint,
            (_, Signal::Breakpoint, Signal::Next) => Signal::Breakpoint,
            (_, _, other) => other,
        })
    }

    #[inline(always)]
    pub fn execute_instr<T>(&mut self, store: &mut Store<T>, call_idx: &mut i32, table_idx: &mut Option<index::Table>) -> Result<Signal, Error> {
        use Instruction as Instr;
        match *self.ip.get() {
            Instr::Trap { instr_offset: _, trap_code } => self.execute_trap(trap_code)?,
            Instr::ConsumeFuel { instr_offset: _, block_fuel } => {
                self.execute_consume_fuel(&mut store.inner, block_fuel)?
            }
            Instr::Return { instr_offset: _ } => {
                forward_return_dbg!(self, self.execute_return(&mut store.inner))
            }
            Instr::ReturnReg { instr_offset: _, value } => {
                forward_return_dbg!(self, self.execute_return_reg(&mut store.inner, value))
            }
            Instr::ReturnReg2 { instr_offset: _, values } => {
                forward_return_dbg!(self, self.execute_return_reg2(&mut store.inner, values))
            }
            Instr::ReturnReg3 { instr_offset: _, values } => {
                forward_return_dbg!(self, self.execute_return_reg3(&mut store.inner, values))
            }
            Instr::ReturnImm32 { instr_offset: _, value } => {
                forward_return_dbg!(self, self.execute_return_imm32(&mut store.inner, value))
            }
            Instr::ReturnI64Imm32 { instr_offset: _, value } => {
                forward_return_dbg!(self, self.execute_return_i64imm32(&mut store.inner, value))
            }
            Instr::ReturnF64Imm32 { instr_offset: _, value } => {
                forward_return_dbg!(self, self.execute_return_f64imm32(&mut store.inner, value))
            }
            Instr::ReturnSpan { instr_offset: _, values } => {
                forward_return_dbg!(self, self.execute_return_span(&mut store.inner, values))
            }
            Instr::ReturnMany { instr_offset: _, values } => {
                forward_return_dbg!(self, self.execute_return_many(&mut store.inner, values))
            }
            Instr::ReturnNez { instr_offset: _, condition } => {
                forward_return_dbg!(self, self.execute_return_nez(&mut store.inner, condition))
            }
            Instr::ReturnNezReg { instr_offset: _, condition, value } => {
                forward_return_dbg!(
                    self,
                    self.execute_return_nez_reg(&mut store.inner, condition, value)
                )
            }
            Instr::ReturnNezReg2 { instr_offset: _, condition, values } => {
                forward_return_dbg!(
                    self,
                    self.execute_return_nez_reg2(&mut store.inner, condition, values)
                )
            }
            Instr::ReturnNezImm32 { instr_offset: _, condition, value } => {
                forward_return_dbg!(
                    self,
                    self.execute_return_nez_imm32(&mut store.inner, condition, value)
                )
            }
            Instr::ReturnNezI64Imm32 { instr_offset: _, condition, value } => {
                forward_return_dbg!(
                    self,
                    self.execute_return_nez_i64imm32(&mut store.inner, condition, value)
                )
            }
            Instr::ReturnNezF64Imm32 { instr_offset: _, condition, value } => {
                forward_return_dbg!(
                    self,
                    self.execute_return_nez_f64imm32(&mut store.inner, condition, value)
                )
            }
            Instr::ReturnNezSpan { instr_offset: _, condition, values } => {
                forward_return_dbg!(
                    self,
                    self.execute_return_nez_span(&mut store.inner, condition, values)
                )
            }
            Instr::ReturnNezMany { instr_offset: _, condition, values } => {
                forward_return_dbg!(
                    self,
                    self.execute_return_nez_many(&mut store.inner, condition, values)
                )
            }
            Instr::Branch { instr_offset: _, offset } => self.execute_branch(offset),
            Instr::BranchTable0 { instr_offset: _, index, len_targets } => {
                self.execute_branch_table_0(index, len_targets)
            }
            Instr::BranchTable1 { instr_offset: _, index, len_targets } => {
                self.execute_branch_table_1(index, len_targets)
            }
            Instr::BranchTable2 { instr_offset: _, index, len_targets } => {
                self.execute_branch_table_2(index, len_targets)
            }
            Instr::BranchTable3 { instr_offset: _, index, len_targets } => {
                self.execute_branch_table_3(index, len_targets)
            }
            Instr::BranchTableSpan { instr_offset: _, index, len_targets } => {
                self.execute_branch_table_span(index, len_targets)
            }
            Instr::BranchTableMany { instr_offset: _, index, len_targets } => {
                self.execute_branch_table_many(index, len_targets)
            }
            Instr::BranchCmpFallback { instr_offset: _, lhs, rhs, params } => {
                self.execute_branch_cmp_fallback(lhs, rhs, params)
            }
            Instr::BranchI32And { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_and(lhs, rhs, offset)
            }
            Instr::BranchI32AndImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_and_imm(lhs, rhs, offset)
            }
            Instr::BranchI32Or { instr_offset: _, lhs, rhs, offset } => self.execute_branch_i32_or(lhs, rhs, offset),
            Instr::BranchI32OrImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_or_imm(lhs, rhs, offset)
            }
            Instr::BranchI32Xor { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_xor(lhs, rhs, offset)
            }
            Instr::BranchI32XorImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_xor_imm(lhs, rhs, offset)
            }
            Instr::BranchI32AndEqz { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_and_eqz(lhs, rhs, offset)
            }
            Instr::BranchI32AndEqzImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_and_eqz_imm(lhs, rhs, offset)
            }
            Instr::BranchI32OrEqz { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_or_eqz(lhs, rhs, offset)
            }
            Instr::BranchI32OrEqzImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_or_eqz_imm(lhs, rhs, offset)
            }
            Instr::BranchI32XorEqz { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_xor_eqz(lhs, rhs, offset)
            }
            Instr::BranchI32XorEqzImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_xor_eqz_imm(lhs, rhs, offset)
            }
            Instr::BranchI32Eq { instr_offset: _, lhs, rhs, offset } => self.execute_branch_i32_eq(lhs, rhs, offset),
            Instr::BranchI32EqImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_eq_imm(lhs, rhs, offset)
            }
            Instr::BranchI32Ne { instr_offset: _, lhs, rhs, offset } => self.execute_branch_i32_ne(lhs, rhs, offset),
            Instr::BranchI32NeImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_ne_imm(lhs, rhs, offset)
            }
            Instr::BranchI32LtS { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_lt_s(lhs, rhs, offset)
            }
            Instr::BranchI32LtSImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_lt_s_imm(lhs, rhs, offset)
            }
            Instr::BranchI32LtU { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_lt_u(lhs, rhs, offset)
            }
            Instr::BranchI32LtUImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_lt_u_imm(lhs, rhs, offset)
            }
            Instr::BranchI32LeS { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_le_s(lhs, rhs, offset)
            }
            Instr::BranchI32LeSImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_le_s_imm(lhs, rhs, offset)
            }
            Instr::BranchI32LeU { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_le_u(lhs, rhs, offset)
            }
            Instr::BranchI32LeUImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_le_u_imm(lhs, rhs, offset)
            }
            Instr::BranchI32GtS { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_gt_s(lhs, rhs, offset)
            }
            Instr::BranchI32GtSImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_gt_s_imm(lhs, rhs, offset)
            }
            Instr::BranchI32GtU { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_gt_u(lhs, rhs, offset)
            }
            Instr::BranchI32GtUImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_gt_u_imm(lhs, rhs, offset)
            }
            Instr::BranchI32GeS { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_ge_s(lhs, rhs, offset)
            }
            Instr::BranchI32GeSImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i32_ge_s_imm(lhs, rhs, offset)
            }
            Instr::BranchI32GeU { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i32_ge_u(lhs, rhs, offset)
            }
            Instr::BranchI32GeUImm { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i32_ge_u_imm(lhs, rhs, offset)
            }
            Instr::BranchI64Eq { instr_offset: _, lhs, rhs, offset } => self.execute_branch_i64_eq(lhs, rhs, offset),
            Instr::BranchI64EqImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i64_eq_imm(lhs, rhs, offset)
            }
            Instr::BranchI64Ne { instr_offset: _, lhs, rhs, offset } => self.execute_branch_i64_ne(lhs, rhs, offset),
            Instr::BranchI64NeImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i64_ne_imm(lhs, rhs, offset)
            }
            Instr::BranchI64LtS { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i64_lt_s(lhs, rhs, offset)
            }
            Instr::BranchI64LtSImm { instr_offset: _, lhs, rhs, offset } => {
                self.execute_branch_i64_lt_s_imm(lhs, rhs, offset)
            }
            Instr::BranchI64LtU { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_lt_u(lhs, rhs, offset)
            }
            Instr::BranchI64LtUImm { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_lt_u_imm(lhs, rhs, offset)
            }
            Instr::BranchI64LeS { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_le_s(lhs, rhs, offset)
            }
            Instr::BranchI64LeSImm { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_le_s_imm(lhs, rhs, offset)
            }
            Instr::BranchI64LeU { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_le_u(lhs, rhs, offset)
            }
            Instr::BranchI64LeUImm { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_le_u_imm(lhs, rhs, offset)
            }
            Instr::BranchI64GtS { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_gt_s(lhs, rhs, offset)
            }
            Instr::BranchI64GtSImm { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_gt_s_imm(lhs, rhs, offset)
            }
            Instr::BranchI64GtU { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_gt_u(lhs, rhs, offset)
            }
            Instr::BranchI64GtUImm { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_gt_u_imm(lhs, rhs, offset)
            }
            Instr::BranchI64GeS { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_ge_s(lhs, rhs, offset)
            }
            Instr::BranchI64GeSImm { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_ge_s_imm(lhs, rhs, offset)
            }
            Instr::BranchI64GeU { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_ge_u(lhs, rhs, offset)
            }
            Instr::BranchI64GeUImm { instr_offset: _,lhs, rhs, offset } => {
                self.execute_branch_i64_ge_u_imm(lhs, rhs, offset)
            }
            Instr::BranchF32Eq { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f32_eq(lhs, rhs, offset),
            Instr::BranchF32Ne { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f32_ne(lhs, rhs, offset),
            Instr::BranchF32Lt { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f32_lt(lhs, rhs, offset),
            Instr::BranchF32Le { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f32_le(lhs, rhs, offset),
            Instr::BranchF32Gt { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f32_gt(lhs, rhs, offset),
            Instr::BranchF32Ge { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f32_ge(lhs, rhs, offset),
            Instr::BranchF64Eq { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f64_eq(lhs, rhs, offset),
            Instr::BranchF64Ne { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f64_ne(lhs, rhs, offset),
            Instr::BranchF64Lt { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f64_lt(lhs, rhs, offset),
            Instr::BranchF64Le { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f64_le(lhs, rhs, offset),
            Instr::BranchF64Gt { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f64_gt(lhs, rhs, offset),
            Instr::BranchF64Ge { instr_offset: _, lhs, rhs, offset } => self.execute_branch_f64_ge(lhs, rhs, offset),
            Instr::Copy { instr_offset: _, result, value } => self.execute_copy(result, value),
            Instr::Copy2 { instr_offset: _, results, values } => self.execute_copy_2(results, values),
            Instr::CopyImm32 { instr_offset: _, result, value } => self.execute_copy_imm32(result, value),
            Instr::CopyI64Imm32 { instr_offset: _, result, value } => self.execute_copy_i64imm32(result, value),
            Instr::CopyF64Imm32 { instr_offset: _, result, value } => self.execute_copy_f64imm32(result, value),
            Instr::CopySpan {
                instr_offset: _,
                results,
                values,
                len,
            } => self.execute_copy_span(results, values, len),
            Instr::CopySpanNonOverlapping {
                instr_offset: _,
                results,
                values,
                len,
            } => self.execute_copy_span_non_overlapping(results, values, len),
            Instr::CopyMany { instr_offset: _, results, values } => self.execute_copy_many(results, values),
            Instr::CopyManyNonOverlapping { instr_offset: _, results, values } => {
                self.execute_copy_many_non_overlapping(results, values)
            }
            Instr::ReturnCallInternal0 { instr_offset: _, func } => {
                self.execute_return_call_internal_0(&mut store.inner, EngineFunc::from(func))?
            }
            Instr::ReturnCallInternal { instr_offset: _, func } => {
                self.execute_return_call_internal(&mut store.inner, EngineFunc::from(func))?
            }
            Instr::ReturnCallImported0 { instr_offset: _, func } => {
                self.execute_return_call_imported_0::<T>(store, func)?
            }
            Instr::ReturnCallImported { instr_offset: _, func } => {
                self.execute_return_call_imported::<T>(store, func)?
            }
            Instr::ReturnCallIndirect0 { instr_offset: _, func_type } => {
                self.execute_return_call_indirect_0::<T>(store, func_type)?
            }
            Instr::ReturnCallIndirect0Imm16 { instr_offset: _, func_type } => {
                self.execute_return_call_indirect_0_imm16::<T>(store, func_type)?
            }
            Instr::ReturnCallIndirect { instr_offset: _,func_type } => {
                self.execute_return_call_indirect::<T>(store, func_type)?
            }
            Instr::ReturnCallIndirectImm16 { instr_offset: _,func_type } => {
                self.execute_return_call_indirect_imm16::<T>(store, func_type)?
            }
            Instr::CallInternal0 { instr_offset: _,results, func } => {
                *call_idx = u32::from(func).try_into().unwrap_or_default();
                self.execute_call_internal_0(&mut store.inner, results, EngineFunc::from(func))?
                // return Ok(Signal::Breakpoint);
            }
            Instr::CallInternal { instr_offset: _,results, func } => {
                *call_idx = u32::from(func).try_into().unwrap_or_default();;
                self.execute_call_internal(&mut store.inner, results, EngineFunc::from(func))?
            }
            Instr::CallImported0 { instr_offset: _,results, func } => {
                self.execute_call_imported_0::<T>(store, results, func)?;
                *call_idx = u32::from(func).try_into().unwrap_or_default();;
            }
            Instr::CallImported { instr_offset: _,results, func } => {
                self.execute_call_imported::<T>(store, results, func)?;
                *call_idx = u32::from(func).try_into().unwrap_or_default();;
            }
            Instr::CallIndirect0 { instr_offset: _,results, func_type } => {
                let (c_idx, tab) = self.execute_call_indirect_0::<T>(store, results, func_type)?;
                *call_idx = c_idx.try_into().unwrap_or_default();
                *table_idx = Some(tab);
            }
            Instr::CallIndirect0Imm16 { instr_offset: _,results, func_type } => {
                let (c_idx, tab) = self.execute_call_indirect_0_imm16::<T>(store, results, func_type)?;
                *call_idx = c_idx.try_into().unwrap_or_default();
                *table_idx = Some(tab);
            }
            Instr::CallIndirect { instr_offset: _,results, func_type } => {
                let (c_idx, tab) = self.execute_call_indirect::<T>(store, results, func_type)?;
                *call_idx = c_idx.try_into().unwrap_or_default();
                *table_idx = Some(tab);
            }
            Instr::CallIndirectImm16 { instr_offset: _,results, func_type } => {
                let (c_idx, tab) =  self.execute_call_indirect_imm16::<T>(store, results, func_type)?;
                *call_idx = c_idx.try_into().unwrap_or_default();
                *table_idx = Some(tab);
            }
            Instr::Select { instr_offset: _,result, lhs } => self.execute_select(result, lhs),
            Instr::SelectImm32Rhs { instr_offset: _, result, lhs } => self.execute_select_imm32_rhs(result, lhs),
            Instr::SelectImm32Lhs { instr_offset: _, result, lhs } => self.execute_select_imm32_lhs(result, lhs),
            Instr::SelectImm32 { instr_offset: _, result, lhs } => self.execute_select_imm32(result, lhs),
            Instr::SelectI64Imm32Rhs { instr_offset: _, result, lhs } => {
                self.execute_select_i64imm32_rhs(result, lhs)
            }
            Instr::SelectI64Imm32Lhs { instr_offset: _, result, lhs } => {
                self.execute_select_i64imm32_lhs(result, lhs)
            }
            Instr::SelectI64Imm32 { instr_offset: _, result, lhs } => self.execute_select_i64imm32(result, lhs),
            Instr::SelectF64Imm32Rhs { instr_offset: _, result, lhs } => {
                self.execute_select_f64imm32_rhs(result, lhs)
            }
            Instr::SelectF64Imm32Lhs { instr_offset: _, result, lhs } => {
                self.execute_select_f64imm32_lhs(result, lhs)
            }
            Instr::SelectF64Imm32 { instr_offset: _, result, lhs } => self.execute_select_f64imm32(result, lhs),
            Instr::RefFunc { instr_offset: _, result, func } => self.execute_ref_func(result, func),
            Instr::GlobalGet { instr_offset: _, result, global } => {
                self.execute_global_get(&store.inner, result, global)
            }
            Instr::GlobalSet { instr_offset: _, global, input } => {
                self.execute_global_set(&mut store.inner, global, input)
            }
            Instr::GlobalSetI32Imm16 { instr_offset: _, global, input } => {
                self.execute_global_set_i32imm16(&mut store.inner, global, input)
            }
            Instr::GlobalSetI64Imm16 { instr_offset: _, global, input } => {
                self.execute_global_set_i64imm16(&mut store.inner, global, input)
            }
            Instr::I32Load { instr_offset: _, result, memory } => {
                self.execute_i32_load(&store.inner, result, memory)?
            }
            Instr::I32LoadAt { instr_offset: _, result, address } => {
                self.execute_i32_load_at(&store.inner, result, address)?
            }
            Instr::I32LoadOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i32_load_offset16(result, ptr, offset)?,
            Instr::I64Load { instr_offset: _, result, memory } => {
                self.execute_i64_load(&store.inner, result, memory)?
            }
            Instr::I64LoadAt { instr_offset: _, result, address } => {
                self.execute_i64_load_at(&store.inner, result, address)?
            }
            Instr::I64LoadOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i64_load_offset16(result, ptr, offset)?,
            Instr::F32Load { instr_offset: _, result, memory } => {
                self.execute_f32_load(&store.inner, result, memory)?
            }
            Instr::F32LoadAt { instr_offset: _, result, address } => {
                self.execute_f32_load_at(&store.inner, result, address)?
            }
            Instr::F32LoadOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_f32_load_offset16(result, ptr, offset)?,
            Instr::F64Load { instr_offset: _, result, memory } => {
                self.execute_f64_load(&store.inner, result, memory)?
            }
            Instr::F64LoadAt { instr_offset: _, result, address } => {
                self.execute_f64_load_at(&store.inner, result, address)?
            }
            Instr::F64LoadOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_f64_load_offset16(result, ptr, offset)?,
            Instr::I32Load8s { instr_offset: _, result, memory } => {
                self.execute_i32_load8_s(&store.inner, result, memory)?
            }
            Instr::I32Load8sAt { instr_offset: _, result, address } => {
                self.execute_i32_load8_s_at(&store.inner, result, address)?
            }
            Instr::I32Load8sOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i32_load8_s_offset16(result, ptr, offset)?,
            Instr::I32Load8u { instr_offset: _, result, memory } => {
                self.execute_i32_load8_u(&store.inner, result, memory)?
            }
            Instr::I32Load8uAt { instr_offset: _, result, address } => {
                self.execute_i32_load8_u_at(&store.inner, result, address)?
            }
            Instr::I32Load8uOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i32_load8_u_offset16(result, ptr, offset)?,
            Instr::I32Load16s { instr_offset: _, result, memory } => {
                self.execute_i32_load16_s(&store.inner, result, memory)?
            }
            Instr::I32Load16sAt { instr_offset: _, result, address } => {
                self.execute_i32_load16_s_at(&store.inner, result, address)?
            }
            Instr::I32Load16sOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i32_load16_s_offset16(result, ptr, offset)?,
            Instr::I32Load16u { instr_offset: _, result, memory } => {
                self.execute_i32_load16_u(&store.inner, result, memory)?
            }
            Instr::I32Load16uAt { instr_offset: _, result, address } => {
                self.execute_i32_load16_u_at(&store.inner, result, address)?
            }
            Instr::I32Load16uOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i32_load16_u_offset16(result, ptr, offset)?,
            Instr::I64Load8s { instr_offset: _, result, memory } => {
                self.execute_i64_load8_s(&store.inner, result, memory)?
            }
            Instr::I64Load8sAt { instr_offset: _, result, address } => {
                self.execute_i64_load8_s_at(&store.inner, result, address)?
            }
            Instr::I64Load8sOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i64_load8_s_offset16(result, ptr, offset)?,
            Instr::I64Load8u { instr_offset: _, result, memory } => {
                self.execute_i64_load8_u(&store.inner, result, memory)?
            }
            Instr::I64Load8uAt { instr_offset: _, result, address } => {
                self.execute_i64_load8_u_at(&store.inner, result, address)?
            }
            Instr::I64Load8uOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i64_load8_u_offset16(result, ptr, offset)?,
            Instr::I64Load16s { instr_offset: _, result, memory } => {
                self.execute_i64_load16_s(&store.inner, result, memory)?
            }
            Instr::I64Load16sAt { instr_offset: _, result, address } => {
                self.execute_i64_load16_s_at(&store.inner, result, address)?
            }
            Instr::I64Load16sOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i64_load16_s_offset16(result, ptr, offset)?,
            Instr::I64Load16u { instr_offset: _, result, memory } => {
                self.execute_i64_load16_u(&store.inner, result, memory)?
            }
            Instr::I64Load16uAt { instr_offset: _, result, address } => {
                self.execute_i64_load16_u_at(&store.inner, result, address)?
            }
            Instr::I64Load16uOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i64_load16_u_offset16(result, ptr, offset)?,
            Instr::I64Load32s { instr_offset: _, result, memory } => {
                self.execute_i64_load32_s(&store.inner, result, memory)?
            }
            Instr::I64Load32sAt { instr_offset: _, result, address } => {
                self.execute_i64_load32_s_at(&store.inner, result, address)?
            }
            Instr::I64Load32sOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i64_load32_s_offset16(result, ptr, offset)?,
            Instr::I64Load32u { instr_offset: _, result, memory } => {
                self.execute_i64_load32_u(&store.inner, result, memory)?
            }
            Instr::I64Load32uAt { instr_offset: _, result, address } => {
                self.execute_i64_load32_u_at(&store.inner, result, address)?
            }
            Instr::I64Load32uOffset16 {
                instr_offset: _,
                result,
                ptr,
                offset,
            } => self.execute_i64_load32_u_offset16(result, ptr, offset)?,
            Instr::I32Store { instr_offset: _, ptr, memory } => {
                self.execute_i32_store(&mut store.inner, ptr, memory)?
            }
            Instr::I32StoreImm16 { instr_offset: _, ptr, memory } => {
                self.execute_i32_store_imm16(&mut store.inner, ptr, memory)?
            }
            Instr::I32StoreOffset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i32_store_offset16(ptr, offset, value)?
            }
            Instr::I32StoreOffset16Imm16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i32_store_offset16_imm16(ptr, offset, value)?
            }
            Instr::I32StoreAt { instr_offset: _, address, value } => {
                self.execute_i32_store_at(&mut store.inner, address, value)?
            }
            Instr::I32StoreAtImm16 { instr_offset, address, value } => {
                self.execute_i32_store_at_imm16(&mut store.inner, address, value)?
            }
            Instr::I32Store8 { instr_offset: _, ptr, memory } => {
                self.execute_i32_store8(&mut store.inner, ptr, memory)?
            }
            Instr::I32Store8Imm { instr_offset: _, ptr, memory } => {
                self.execute_i32_store8_imm(&mut store.inner, ptr, memory)?
            }
            Instr::I32Store8Offset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i32_store8_offset16(ptr, offset, value)?
            }
            Instr::I32Store8Offset16Imm { instr_offset: _, ptr, offset, value } => {
                self.execute_i32_store8_offset16_imm(ptr, offset, value)?
            }
            Instr::I32Store8At { instr_offset: _, address, value } => {
                self.execute_i32_store8_at(&mut store.inner, address, value)?
            }
            Instr::I32Store8AtImm { instr_offset: _, address, value } => {
                self.execute_i32_store8_at_imm(&mut store.inner, address, value)?
            }
            Instr::I32Store16 { instr_offset: _, ptr, memory } => {
                self.execute_i32_store16(&mut store.inner, ptr, memory)?
            }
            Instr::I32Store16Imm { instr_offset: _, ptr, memory } => {
                self.execute_i32_store16_imm(&mut store.inner, ptr, memory)?
            }
            Instr::I32Store16Offset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i32_store16_offset16(ptr, offset, value)?
            }
            Instr::I32Store16Offset16Imm { instr_offset: _, ptr, offset, value } => {
                self.execute_i32_store16_offset16_imm(ptr, offset, value)?
            }
            Instr::I32Store16At { instr_offset: _, address, value } => {
                self.execute_i32_store16_at(&mut store.inner, address, value)?
            }
            Instr::I32Store16AtImm { instr_offset: _, address, value } => {
                self.execute_i32_store16_at_imm(&mut store.inner, address, value)?
            }
            Instr::I64Store { instr_offset: _, ptr, memory } => {
                self.execute_i64_store(&mut store.inner, ptr, memory)?
            }
            Instr::I64StoreImm16 { instr_offset: _, ptr, memory } => {
                self.execute_i64_store_imm16(&mut store.inner, ptr, memory)?
            }
            Instr::I64StoreOffset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i64_store_offset16(ptr, offset, value)?
            }
            Instr::I64StoreOffset16Imm16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i64_store_offset16_imm16(ptr, offset, value)?
            }
            Instr::I64StoreAt { instr_offset: _, address, value } => {
                self.execute_i64_store_at(&mut store.inner, address, value)?
            }
            Instr::I64StoreAtImm16 { instr_offset: _, address, value } => {
                self.execute_i64_store_at_imm16(&mut store.inner, address, value)?
            }
            Instr::I64Store8 { instr_offset: _, ptr, memory } => {
                self.execute_i64_store8(&mut store.inner, ptr, memory)?
            }
            Instr::I64Store8Imm { instr_offset: _, ptr, memory } => {
                self.execute_i64_store8_imm(&mut store.inner, ptr, memory)?
            }
            Instr::I64Store8Offset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i64_store8_offset16(ptr, offset, value)?
            }
            Instr::I64Store8Offset16Imm { instr_offset: _, ptr, offset, value } => {
                self.execute_i64_store8_offset16_imm(ptr, offset, value)?
            }
            Instr::I64Store8At { instr_offset: _, address, value } => {
                self.execute_i64_store8_at(&mut store.inner, address, value)?
            }
            Instr::I64Store8AtImm { instr_offset: _, address, value } => {
                self.execute_i64_store8_at_imm(&mut store.inner, address, value)?
            }
            Instr::I64Store16 { instr_offset: _, ptr, memory } => {
                self.execute_i64_store16(&mut store.inner, ptr, memory)?
            }
            Instr::I64Store16Imm { instr_offset: _, ptr, memory } => {
                self.execute_i64_store16_imm(&mut store.inner, ptr, memory)?
            }
            Instr::I64Store16Offset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i64_store16_offset16(ptr, offset, value)?
            }
            Instr::I64Store16Offset16Imm { instr_offset: _, ptr, offset, value } => {
                self.execute_i64_store16_offset16_imm(ptr, offset, value)?
            }
            Instr::I64Store16At { instr_offset: _, address, value } => {
                self.execute_i64_store16_at(&mut store.inner, address, value)?
            }
            Instr::I64Store16AtImm { instr_offset: _, address, value } => {
                self.execute_i64_store16_at_imm(&mut store.inner, address, value)?
            }
            Instr::I64Store32 { instr_offset: _, ptr, memory } => {
                self.execute_i64_store32(&mut store.inner, ptr, memory)?
            }
            Instr::I64Store32Imm16 { instr_offset: _, ptr, memory } => {
                self.execute_i64_store32_imm16(&mut store.inner, ptr, memory)?
            }
            Instr::I64Store32Offset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i64_store32_offset16(ptr, offset, value)?
            }
            Instr::I64Store32Offset16Imm16 { instr_offset: _, ptr, offset, value } => {
                self.execute_i64_store32_offset16_imm16(ptr, offset, value)?
            }
            Instr::I64Store32At { instr_offset: _, address, value } => {
                self.execute_i64_store32_at(&mut store.inner, address, value)?
            }
            Instr::I64Store32AtImm16 { instr_offset: _, address, value } => {
                self.execute_i64_store32_at_imm16(&mut store.inner, address, value)?
            }
            Instr::F32Store { instr_offset: _, ptr, memory } => {
                self.execute_f32_store(&mut store.inner, ptr, memory)?
            }
            Instr::F32StoreOffset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_f32_store_offset16(ptr, offset, value)?
            }
            Instr::F32StoreAt { instr_offset: _, address, value } => {
                self.execute_f32_store_at(&mut store.inner, address, value)?
            }
            Instr::F64Store { instr_offset: _, ptr, memory } => {
                self.execute_f64_store(&mut store.inner, ptr, memory)?
            }
            Instr::F64StoreOffset16 { instr_offset: _, ptr, offset, value } => {
                self.execute_f64_store_offset16(ptr, offset, value)?
            }
            Instr::F64StoreAt { instr_offset: _, address, value } => {
                self.execute_f64_store_at(&mut store.inner, address, value)?
            }
            Instr::I32Eq { instr_offset: _, result, lhs, rhs } => self.execute_i32_eq(result, lhs, rhs),
            Instr::I32EqImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i32_eq_imm16(result, lhs, rhs),
            Instr::I32Ne { instr_offset: _, result, lhs, rhs } => self.execute_i32_ne(result, lhs, rhs),
            Instr::I32NeImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i32_ne_imm16(result, lhs, rhs),
            Instr::I32LtS { instr_offset: _, result, lhs, rhs } => self.execute_i32_lt_s(result, lhs, rhs),
            Instr::I32LtSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_lt_s_imm16(result, lhs, rhs)
            }
            Instr::I32LtU { instr_offset: _, result, lhs, rhs } => self.execute_i32_lt_u(result, lhs, rhs),
            Instr::I32LtUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_lt_u_imm16(result, lhs, rhs)
            }
            Instr::I32LeS { instr_offset: _, result, lhs, rhs } => self.execute_i32_le_s(result, lhs, rhs),
            Instr::I32LeSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_le_s_imm16(result, lhs, rhs)
            }
            Instr::I32LeU { instr_offset: _, result, lhs, rhs } => self.execute_i32_le_u(result, lhs, rhs),
            Instr::I32LeUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_le_u_imm16(result, lhs, rhs)
            }
            Instr::I32GtS { instr_offset: _, result, lhs, rhs } => self.execute_i32_gt_s(result, lhs, rhs),
            Instr::I32GtSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_gt_s_imm16(result, lhs, rhs)
            }
            Instr::I32GtU { instr_offset: _, result, lhs, rhs } => self.execute_i32_gt_u(result, lhs, rhs),
            Instr::I32GtUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_gt_u_imm16(result, lhs, rhs)
            }
            Instr::I32GeS { instr_offset: _, result, lhs, rhs } => self.execute_i32_ge_s(result, lhs, rhs),
            Instr::I32GeSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_ge_s_imm16(result, lhs, rhs)
            }
            Instr::I32GeU { instr_offset: _, result, lhs, rhs } => self.execute_i32_ge_u(result, lhs, rhs),
            Instr::I32GeUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_ge_u_imm16(result, lhs, rhs)
            }
            Instr::I64Eq { instr_offset: _, result, lhs, rhs } => self.execute_i64_eq(result, lhs, rhs),
            Instr::I64EqImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i64_eq_imm16(result, lhs, rhs),
            Instr::I64Ne { instr_offset: _, result, lhs, rhs } => self.execute_i64_ne(result, lhs, rhs),
            Instr::I64NeImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i64_ne_imm16(result, lhs, rhs),
            Instr::I64LtS { instr_offset: _, result, lhs, rhs } => self.execute_i64_lt_s(result, lhs, rhs),
            Instr::I64LtSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_lt_s_imm16(result, lhs, rhs)
            }
            Instr::I64LtU { instr_offset: _, result, lhs, rhs } => self.execute_i64_lt_u(result, lhs, rhs),
            Instr::I64LtUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_lt_u_imm16(result, lhs, rhs)
            }
            Instr::I64LeS { instr_offset: _, result, lhs, rhs } => self.execute_i64_le_s(result, lhs, rhs),
            Instr::I64LeSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_le_s_imm16(result, lhs, rhs)
            }
            Instr::I64LeU { instr_offset: _, result, lhs, rhs } => self.execute_i64_le_u(result, lhs, rhs),
            Instr::I64LeUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_le_u_imm16(result, lhs, rhs)
            }
            Instr::I64GtS { instr_offset: _, result, lhs, rhs } => self.execute_i64_gt_s(result, lhs, rhs),
            Instr::I64GtSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_gt_s_imm16(result, lhs, rhs)
            }
            Instr::I64GtU { instr_offset: _, result, lhs, rhs } => self.execute_i64_gt_u(result, lhs, rhs),
            Instr::I64GtUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_gt_u_imm16(result, lhs, rhs)
            }
            Instr::I64GeS { instr_offset: _, result, lhs, rhs } => self.execute_i64_ge_s(result, lhs, rhs),
            Instr::I64GeSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_ge_s_imm16(result, lhs, rhs)
            }
            Instr::I64GeU { instr_offset: _, result, lhs, rhs } => self.execute_i64_ge_u(result, lhs, rhs),
            Instr::I64GeUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_ge_u_imm16(result, lhs, rhs)
            }
            Instr::F32Eq { instr_offset: _, result, lhs, rhs } => self.execute_f32_eq(result, lhs, rhs),
            Instr::F32Ne { instr_offset: _, result, lhs, rhs } => self.execute_f32_ne(result, lhs, rhs),
            Instr::F32Lt { instr_offset: _, result, lhs, rhs } => self.execute_f32_lt(result, lhs, rhs),
            Instr::F32Le { instr_offset: _, result, lhs, rhs } => self.execute_f32_le(result, lhs, rhs),
            Instr::F32Gt { instr_offset: _, result, lhs, rhs } => self.execute_f32_gt(result, lhs, rhs),
            Instr::F32Ge { instr_offset: _, result, lhs, rhs } => self.execute_f32_ge(result, lhs, rhs),
            Instr::F64Eq { instr_offset: _, result, lhs, rhs } => self.execute_f64_eq(result, lhs, rhs),
            Instr::F64Ne { instr_offset: _, result, lhs, rhs } => self.execute_f64_ne(result, lhs, rhs),
            Instr::F64Lt { instr_offset: _, result, lhs, rhs } => self.execute_f64_lt(result, lhs, rhs),
            Instr::F64Le { instr_offset: _, result, lhs, rhs } => self.execute_f64_le(result, lhs, rhs),
            Instr::F64Gt { instr_offset: _, result, lhs, rhs } => self.execute_f64_gt(result, lhs, rhs),
            Instr::F64Ge { instr_offset: _, result, lhs, rhs } => self.execute_f64_ge(result, lhs, rhs),
            Instr::I32Clz { instr_offset: _, result, input } => self.execute_i32_clz(result, input),
            Instr::I32Ctz { instr_offset: _, result, input } => self.execute_i32_ctz(result, input),
            Instr::I32Popcnt { instr_offset: _, result, input } => self.execute_i32_popcnt(result, input),
            Instr::I32Add { instr_offset: _, result, lhs, rhs } => {
                // println!("result: {:?}, lhs: {:?}, rhs: {:?}", result, lhs, rhs);
                self.execute_i32_add(result, lhs, rhs)
            },
            Instr::I32AddImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i32_add_imm16(result, lhs, rhs),
            Instr::I32Sub { instr_offset: _, result, lhs, rhs } => self.execute_i32_sub(result, lhs, rhs),
            Instr::I32SubImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_sub_imm16_lhs(result, lhs, rhs)
            }
            Instr::I32Mul { instr_offset: _, result, lhs, rhs } => self.execute_i32_mul(result, lhs, rhs),
            Instr::I32MulImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i32_mul_imm16(result, lhs, rhs),
            Instr::I32DivS { instr_offset: _, result, lhs, rhs } => self.execute_i32_div_s(result, lhs, rhs)?,
            Instr::I32DivSImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_div_s_imm16_rhs(result, lhs, rhs)?
            }
            Instr::I32DivSImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_div_s_imm16_lhs(result, lhs, rhs)?
            }
            Instr::I32DivU { instr_offset: _, result, lhs, rhs } => self.execute_i32_div_u(result, lhs, rhs)?,
            Instr::I32DivUImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_div_u_imm16_rhs(result, lhs, rhs)
            }
            Instr::I32DivUImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_div_u_imm16_lhs(result, lhs, rhs)?
            }
            Instr::I32RemS { instr_offset: _, result, lhs, rhs } => self.execute_i32_rem_s(result, lhs, rhs)?,
            Instr::I32RemSImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_rem_s_imm16_rhs(result, lhs, rhs)?
            }
            Instr::I32RemSImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_rem_s_imm16_lhs(result, lhs, rhs)?
            }
            Instr::I32RemU { instr_offset: _, result, lhs, rhs } => self.execute_i32_rem_u(result, lhs, rhs)?,
            Instr::I32RemUImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_rem_u_imm16_rhs(result, lhs, rhs)
            }
            Instr::I32RemUImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_rem_u_imm16_lhs(result, lhs, rhs)?
            }
            Instr::I32And { instr_offset: _, result, lhs, rhs } => self.execute_i32_and(result, lhs, rhs),
            Instr::I32AndEqz { instr_offset: _, result, lhs, rhs } => self.execute_i32_and_eqz(result, lhs, rhs),
            Instr::I32AndEqzImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_and_eqz_imm16(result, lhs, rhs)
            }
            Instr::I32AndImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i32_and_imm16(result, lhs, rhs),
            Instr::I32Or { instr_offset: _, result, lhs, rhs } => self.execute_i32_or(result, lhs, rhs),
            Instr::I32OrEqz { instr_offset: _, result, lhs, rhs } => self.execute_i32_or_eqz(result, lhs, rhs),
            Instr::I32OrEqzImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_or_eqz_imm16(result, lhs, rhs)
            }
            Instr::I32OrImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i32_or_imm16(result, lhs, rhs),
            Instr::I32Xor { instr_offset: _, result, lhs, rhs } => self.execute_i32_xor(result, lhs, rhs),
            Instr::I32XorEqz { instr_offset: _, result, lhs, rhs } => self.execute_i32_xor_eqz(result, lhs, rhs),
            Instr::I32XorEqzImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_xor_eqz_imm16(result, lhs, rhs)
            }
            Instr::I32XorImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i32_xor_imm16(result, lhs, rhs),
            Instr::I32Shl { instr_offset: _, result, lhs, rhs } => self.execute_i32_shl(result, lhs, rhs),
            Instr::I32ShlBy { instr_offset: _, result, lhs, rhs } => self.execute_i32_shl_by(result, lhs, rhs),
            Instr::I32ShlImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i32_shl_imm16(result, lhs, rhs),
            Instr::I32ShrU { instr_offset: _, result, lhs, rhs } => self.execute_i32_shr_u(result, lhs, rhs),
            Instr::I32ShrUBy { instr_offset: _, result, lhs, rhs } => self.execute_i32_shr_u_by(result, lhs, rhs),
            Instr::I32ShrUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_shr_u_imm16(result, lhs, rhs)
            }
            Instr::I32ShrS { instr_offset: _, result, lhs, rhs } => self.execute_i32_shr_s(result, lhs, rhs),
            Instr::I32ShrSBy { instr_offset: _, result, lhs, rhs } => self.execute_i32_shr_s_by(result, lhs, rhs),
            Instr::I32ShrSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_shr_s_imm16(result, lhs, rhs)
            }
            Instr::I32Rotl { instr_offset: _, result, lhs, rhs } => self.execute_i32_rotl(result, lhs, rhs),
            Instr::I32RotlBy { instr_offset: _, result, lhs, rhs } => self.execute_i32_rotl_by(result, lhs, rhs),
            Instr::I32RotlImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_rotl_imm16(result, lhs, rhs)
            }
            Instr::I32Rotr { instr_offset: _, result, lhs, rhs } => self.execute_i32_rotr(result, lhs, rhs),
            Instr::I32RotrBy { instr_offset: _, result, lhs, rhs } => self.execute_i32_rotr_by(result, lhs, rhs),
            Instr::I32RotrImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i32_rotr_imm16(result, lhs, rhs)
            }
            Instr::I64Clz { instr_offset: _, result, input } => self.execute_i64_clz(result, input),
            Instr::I64Ctz { instr_offset: _, result, input } => self.execute_i64_ctz(result, input),
            Instr::I64Popcnt { instr_offset: _, result, input } => self.execute_i64_popcnt(result, input),
            Instr::I64Add { instr_offset: _, result, lhs, rhs } => self.execute_i64_add(result, lhs, rhs),
            Instr::I64AddImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i64_add_imm16(result, lhs, rhs),
            Instr::I64Sub { instr_offset: _, result, lhs, rhs } => self.execute_i64_sub(result, lhs, rhs),
            Instr::I64SubImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_sub_imm16_lhs(result, lhs, rhs)
            }
            Instr::I64Mul { instr_offset: _, result, lhs, rhs } => self.execute_i64_mul(result, lhs, rhs),
            Instr::I64MulImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i64_mul_imm16(result, lhs, rhs),
            Instr::I64DivS { instr_offset: _, result, lhs, rhs } => self.execute_i64_div_s(result, lhs, rhs)?,
            Instr::I64DivSImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_div_s_imm16_rhs(result, lhs, rhs)?
            }
            Instr::I64DivSImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_div_s_imm16_lhs(result, lhs, rhs)?
            }
            Instr::I64DivU { instr_offset: _, result, lhs, rhs } => self.execute_i64_div_u(result, lhs, rhs)?,
            Instr::I64DivUImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_div_u_imm16_rhs(result, lhs, rhs)
            }
            Instr::I64DivUImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_div_u_imm16_lhs(result, lhs, rhs)?
            }
            Instr::I64RemS { instr_offset: _, result, lhs, rhs } => self.execute_i64_rem_s(result, lhs, rhs)?,
            Instr::I64RemSImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_rem_s_imm16_rhs(result, lhs, rhs)?
            }
            Instr::I64RemSImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_rem_s_imm16_lhs(result, lhs, rhs)?
            }
            Instr::I64RemU { instr_offset: _, result, lhs, rhs } => self.execute_i64_rem_u(result, lhs, rhs)?,
            Instr::I64RemUImm16Rhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_rem_u_imm16_rhs(result, lhs, rhs)
            }
            Instr::I64RemUImm16Lhs { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_rem_u_imm16_lhs(result, lhs, rhs)?
            }
            Instr::I64And { instr_offset: _, result, lhs, rhs } => self.execute_i64_and(result, lhs, rhs),
            Instr::I64AndImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i64_and_imm16(result, lhs, rhs),
            Instr::I64Or { instr_offset: _, result, lhs, rhs } => self.execute_i64_or(result, lhs, rhs),
            Instr::I64OrImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i64_or_imm16(result, lhs, rhs),
            Instr::I64Xor { instr_offset: _, result, lhs, rhs } => self.execute_i64_xor(result, lhs, rhs),
            Instr::I64XorImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i64_xor_imm16(result, lhs, rhs),
            Instr::I64Shl { instr_offset: _, result, lhs, rhs } => self.execute_i64_shl(result, lhs, rhs),
            Instr::I64ShlBy { instr_offset: _, result, lhs, rhs } => self.execute_i64_shl_by(result, lhs, rhs),
            Instr::I64ShlImm16 { instr_offset: _, result, lhs, rhs } => self.execute_i64_shl_imm16(result, lhs, rhs),
            Instr::I64ShrU { instr_offset: _, result, lhs, rhs } => self.execute_i64_shr_u(result, lhs, rhs),
            Instr::I64ShrUBy { instr_offset: _, result, lhs, rhs } => self.execute_i64_shr_u_by(result, lhs, rhs),
            Instr::I64ShrUImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_shr_u_imm16(result, lhs, rhs)
            }
            Instr::I64ShrS { instr_offset: _, result, lhs, rhs } => self.execute_i64_shr_s(result, lhs, rhs),
            Instr::I64ShrSBy { instr_offset: _, result, lhs, rhs } => self.execute_i64_shr_s_by(result, lhs, rhs),
            Instr::I64ShrSImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_shr_s_imm16(result, lhs, rhs)
            }
            Instr::I64Rotl { instr_offset: _, result, lhs, rhs } => self.execute_i64_rotl(result, lhs, rhs),
            Instr::I64RotlBy { instr_offset: _, result, lhs, rhs } => self.execute_i64_rotl_by(result, lhs, rhs),
            Instr::I64RotlImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_rotl_imm16(result, lhs, rhs)
            }
            Instr::I64Rotr { instr_offset: _, result, lhs, rhs } => self.execute_i64_rotr(result, lhs, rhs),
            Instr::I64RotrBy { instr_offset: _, result, lhs, rhs } => self.execute_i64_rotr_by(result, lhs, rhs),
            Instr::I64RotrImm16 { instr_offset: _, result, lhs, rhs } => {
                self.execute_i64_rotr_imm16(result, lhs, rhs)
            }
            Instr::I32WrapI64 { instr_offset: _, result, input } => self.execute_i32_wrap_i64(result, input),
            Instr::I32Extend8S { instr_offset: _, result, input } => self.execute_i32_extend8_s(result, input),
            Instr::I32Extend16S { instr_offset: _, result, input } => self.execute_i32_extend16_s(result, input),
            Instr::I64Extend8S { instr_offset: _, result, input } => self.execute_i64_extend8_s(result, input),
            Instr::I64Extend16S { instr_offset: _, result, input } => self.execute_i64_extend16_s(result, input),
            Instr::I64Extend32S { instr_offset: _, result, input } => self.execute_i64_extend32_s(result, input),
            Instr::F32Abs { instr_offset: _, result, input } => self.execute_f32_abs(result, input),
            Instr::F32Neg { instr_offset: _, result, input } => self.execute_f32_neg(result, input),
            Instr::F32Ceil { instr_offset: _, result, input } => self.execute_f32_ceil(result, input),
            Instr::F32Floor { instr_offset: _, result, input } => self.execute_f32_floor(result, input),
            Instr::F32Trunc { instr_offset: _, result, input } => self.execute_f32_trunc(result, input),
            Instr::F32Nearest { instr_offset: _, result, input } => self.execute_f32_nearest(result, input),
            Instr::F32Sqrt { instr_offset: _, result, input } => self.execute_f32_sqrt(result, input),
            Instr::F32Add { instr_offset: _, result, lhs, rhs } => self.execute_f32_add(result, lhs, rhs),
            Instr::F32Sub { instr_offset: _, result, lhs, rhs } => self.execute_f32_sub(result, lhs, rhs),
            Instr::F32Mul { instr_offset: _, result, lhs, rhs } => self.execute_f32_mul(result, lhs, rhs),
            Instr::F32Div { instr_offset: _, result, lhs, rhs } => self.execute_f32_div(result, lhs, rhs),
            Instr::F32Min { instr_offset: _, result, lhs, rhs } => self.execute_f32_min(result, lhs, rhs),
            Instr::F32Max { instr_offset: _, result, lhs, rhs } => self.execute_f32_max(result, lhs, rhs),
            Instr::F32Copysign { instr_offset: _, result, lhs, rhs } => self.execute_f32_copysign(result, lhs, rhs),
            Instr::F32CopysignImm { instr_offset: _, result, lhs, rhs } => {
                self.execute_f32_copysign_imm(result, lhs, rhs)
            }
            Instr::F64Abs { instr_offset: _, result, input } => self.execute_f64_abs(result, input),
            Instr::F64Neg { instr_offset: _, result, input } => self.execute_f64_neg(result, input),
            Instr::F64Ceil { instr_offset: _, result, input } => self.execute_f64_ceil(result, input),
            Instr::F64Floor { instr_offset: _, result, input } => self.execute_f64_floor(result, input),
            Instr::F64Trunc { instr_offset: _, result, input } => self.execute_f64_trunc(result, input),
            Instr::F64Nearest { instr_offset: _, result, input } => self.execute_f64_nearest(result, input),
            Instr::F64Sqrt { instr_offset: _, result, input } => self.execute_f64_sqrt(result, input),
            Instr::F64Add { instr_offset: _, result, lhs, rhs } => self.execute_f64_add(result, lhs, rhs),
            Instr::F64Sub { instr_offset: _, result, lhs, rhs } => self.execute_f64_sub(result, lhs, rhs),
            Instr::F64Mul { instr_offset: _, result, lhs, rhs } => self.execute_f64_mul(result, lhs, rhs),
            Instr::F64Div { instr_offset: _, result, lhs, rhs } => self.execute_f64_div(result, lhs, rhs),
            Instr::F64Min { instr_offset: _, result, lhs, rhs } => self.execute_f64_min(result, lhs, rhs),
            Instr::F64Max { instr_offset: _, result, lhs, rhs } => self.execute_f64_max(result, lhs, rhs),
            Instr::F64Copysign { instr_offset: _, result, lhs, rhs } => self.execute_f64_copysign(result, lhs, rhs),
            Instr::F64CopysignImm { instr_offset: _, result, lhs, rhs } => {
                self.execute_f64_copysign_imm(result, lhs, rhs)
            }
            Instr::I32TruncF32S { instr_offset: _, result, input } => self.execute_i32_trunc_f32_s(result, input)?,
            Instr::I32TruncF32U { instr_offset: _, result, input } => self.execute_i32_trunc_f32_u(result, input)?,
            Instr::I32TruncF64S { instr_offset: _, result, input } => self.execute_i32_trunc_f64_s(result, input)?,
            Instr::I32TruncF64U { instr_offset: _, result, input } => self.execute_i32_trunc_f64_u(result, input)?,
            Instr::I64TruncF32S { instr_offset: _, result, input } => self.execute_i64_trunc_f32_s(result, input)?,
            Instr::I64TruncF32U { instr_offset: _, result, input } => self.execute_i64_trunc_f32_u(result, input)?,
            Instr::I64TruncF64S { instr_offset: _, result, input } => self.execute_i64_trunc_f64_s(result, input)?,
            Instr::I64TruncF64U { instr_offset: _, result, input } => self.execute_i64_trunc_f64_u(result, input)?,
            Instr::I32TruncSatF32S { instr_offset: _, result, input } => {
                self.execute_i32_trunc_sat_f32_s(result, input)
            }
            Instr::I32TruncSatF32U { instr_offset: _, result, input } => {
                self.execute_i32_trunc_sat_f32_u(result, input)
            }
            Instr::I32TruncSatF64S { instr_offset: _, result, input } => {
                self.execute_i32_trunc_sat_f64_s(result, input)
            }
            Instr::I32TruncSatF64U { instr_offset: _, result, input } => {
                self.execute_i32_trunc_sat_f64_u(result, input)
            }
            Instr::I64TruncSatF32S { instr_offset: _, result, input } => {
                self.execute_i64_trunc_sat_f32_s(result, input)
            }
            Instr::I64TruncSatF32U { instr_offset: _, result, input } => {
                self.execute_i64_trunc_sat_f32_u(result, input)
            }
            Instr::I64TruncSatF64S { instr_offset: _, result, input } => {
                self.execute_i64_trunc_sat_f64_s(result, input)
            }
            Instr::I64TruncSatF64U { instr_offset: _, result, input } => {
                self.execute_i64_trunc_sat_f64_u(result, input)
            }
            Instr::F32DemoteF64 { instr_offset: _, result, input } => self.execute_f32_demote_f64(result, input),
            Instr::F64PromoteF32 { instr_offset: _, result, input } => self.execute_f64_promote_f32(result, input),
            Instr::F32ConvertI32S { instr_offset: _, result, input } => {
                self.execute_f32_convert_i32_s(result, input)
            }
            Instr::F32ConvertI32U { instr_offset: _, result, input } => {
                self.execute_f32_convert_i32_u(result, input)
            }
            Instr::F32ConvertI64S { instr_offset: _, result, input } => {
                self.execute_f32_convert_i64_s(result, input)
            }
            Instr::F32ConvertI64U { instr_offset: _, result, input } => {
                self.execute_f32_convert_i64_u(result, input)
            }
            Instr::F64ConvertI32S { instr_offset: _, result, input } => {
                self.execute_f64_convert_i32_s(result, input)
            }
            Instr::F64ConvertI32U { instr_offset: _, result, input } => {
                self.execute_f64_convert_i32_u(result, input)
            }
            Instr::F64ConvertI64S { instr_offset: _, result, input } => {
                self.execute_f64_convert_i64_s(result, input)
            }
            Instr::F64ConvertI64U { instr_offset: _, result, input } => {
                self.execute_f64_convert_i64_u(result, input)
            }
            Instr::TableGet { instr_offset: _, result, index } => {
                self.execute_table_get(&store.inner, result, index)?
            }
            Instr::TableGetImm { instr_offset: _, result, index } => {
                self.execute_table_get_imm(&store.inner, result, index)?
            }
            Instr::TableSize { instr_offset: _, result, table } => {
                self.execute_table_size(&store.inner, result, table)
            }
            Instr::TableSet { instr_offset: _, index, value } => {
                self.execute_table_set(&mut store.inner, index, value)?
            }
            Instr::TableSetAt { instr_offset: _, index, value } => {
                self.execute_table_set_at(&mut store.inner, index, value)?
            }
            Instr::TableCopy { instr_offset: _, dst, src, len } => {
                self.execute_table_copy(&mut store.inner, dst, src, len)?
            }
            Instr::TableCopyTo { instr_offset: _, dst, src, len } => {
                self.execute_table_copy_to(&mut store.inner, dst, src, len)?
            }
            Instr::TableCopyFrom { instr_offset: _, dst, src, len } => {
                self.execute_table_copy_from(&mut store.inner, dst, src, len)?
            }
            Instr::TableCopyFromTo { instr_offset: _, dst, src, len } => {
                self.execute_table_copy_from_to(&mut store.inner, dst, src, len)?
            }
            Instr::TableCopyExact { instr_offset: _, dst, src, len } => {
                self.execute_table_copy_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableCopyToExact { instr_offset: _, dst, src, len } => {
                self.execute_table_copy_to_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableCopyFromExact { instr_offset: _, dst, src, len } => {
                self.execute_table_copy_from_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableCopyFromToExact { instr_offset: _, dst, src, len } => {
                self.execute_table_copy_from_to_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableInit { instr_offset: _, dst, src, len } => {
                self.execute_table_init(&mut store.inner, dst, src, len)?
            }
            Instr::TableInitTo { instr_offset: _, dst, src, len } => {
                self.execute_table_init_to(&mut store.inner, dst, src, len)?
            }
            Instr::TableInitFrom { instr_offset: _, dst, src, len } => {
                self.execute_table_init_from(&mut store.inner, dst, src, len)?
            }
            Instr::TableInitFromTo { instr_offset: _, dst, src, len } => {
                self.execute_table_init_from_to(&mut store.inner, dst, src, len)?
            }
            Instr::TableInitExact { instr_offset: _, dst, src, len } => {
                self.execute_table_init_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableInitToExact { instr_offset: _, dst, src, len } => {
                self.execute_table_init_to_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableInitFromExact { instr_offset: _, dst, src, len } => {
                self.execute_table_init_from_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableInitFromToExact { instr_offset: _, dst, src, len } => {
                self.execute_table_init_from_to_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableFill { instr_offset: _, dst, len, value } => {
                self.execute_table_fill(&mut store.inner, dst, len, value)?
            }
            Instr::TableFillAt { instr_offset: _, dst, len, value } => {
                self.execute_table_fill_at(&mut store.inner, dst, len, value)?
            }
            Instr::TableFillExact { instr_offset: _, dst, len, value } => {
                self.execute_table_fill_exact(&mut store.inner, dst, len, value)?
            }
            Instr::TableFillAtExact { instr_offset: _, dst, len, value } => {
                self.execute_table_fill_at_exact(&mut store.inner, dst, len, value)?
            }
            Instr::TableGrow {
                instr_offset: _,
                result,
                delta,
                value,
            } => self.execute_table_grow(store, result, delta, value)?,
            Instr::TableGrowImm {
                instr_offset: _,
                result,
                delta,
                value,
            } => self.execute_table_grow_imm(store, result, delta, value)?,
            Instr::ElemDrop { instr_offset: _, index } => self.execute_element_drop(&mut store.inner, index),
            Instr::DataDrop { instr_offset: _, index } => self.execute_data_drop(&mut store.inner, index),
            Instr::MemorySize { instr_offset: _, result, memory } => {
                self.execute_memory_size(&store.inner, result, memory)
            }
            Instr::MemoryGrow { instr_offset: _, result, delta } => {
                self.execute_memory_grow(store, result, delta)?
            }
            Instr::MemoryGrowBy { instr_offset: _, result, delta } => {
                self.execute_memory_grow_by(store, result, delta)?
            }
            Instr::MemoryCopy { instr_offset: _, dst, src, len } => {
                self.execute_memory_copy(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryCopyTo { instr_offset: _, dst, src, len } => {
                self.execute_memory_copy_to(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryCopyFrom { instr_offset: _, dst, src, len } => {
                self.execute_memory_copy_from(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryCopyFromTo { instr_offset: _, dst, src, len } => {
                self.execute_memory_copy_from_to(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryCopyExact { instr_offset: _, dst, src, len } => {
                self.execute_memory_copy_exact(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryCopyToExact { instr_offset: _, dst, src, len } => {
                self.execute_memory_copy_to_exact(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryCopyFromExact { instr_offset: _, dst, src, len } => {
                self.execute_memory_copy_from_exact(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryCopyFromToExact { instr_offset: _, dst, src, len } => {
                self.execute_memory_copy_from_to_exact(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryFill { instr_offset: _, dst, value, len } => {
                self.execute_memory_fill(&mut store.inner, dst, value, len)?
            }
            Instr::MemoryFillAt { instr_offset: _, dst, value, len } => {
                self.execute_memory_fill_at(&mut store.inner, dst, value, len)?
            }
            Instr::MemoryFillImm { instr_offset: _, dst, value, len } => {
                self.execute_memory_fill_imm(&mut store.inner, dst, value, len)?
            }
            Instr::MemoryFillExact { instr_offset: _, dst, value, len } => {
                self.execute_memory_fill_exact(&mut store.inner, dst, value, len)?
            }
            Instr::MemoryFillAtImm { instr_offset: _, dst, value, len } => {
                self.execute_memory_fill_at_imm(&mut store.inner, dst, value, len)?
            }
            Instr::MemoryFillAtExact { instr_offset: _, dst, value, len } => {
                self.execute_memory_fill_at_exact(&mut store.inner, dst, value, len)?
            }
            Instr::MemoryFillImmExact { instr_offset: _, dst, value, len } => {
                self.execute_memory_fill_imm_exact(&mut store.inner, dst, value, len)?
            }
            Instr::MemoryFillAtImmExact { instr_offset: _, dst, value, len } => {
                self.execute_memory_fill_at_imm_exact(&mut store.inner, dst, value, len)?
            }
            Instr::MemoryInit { instr_offset: _, dst, src, len } => {
                self.execute_memory_init(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryInitTo { instr_offset: _, dst, src, len } => {
                self.execute_memory_init_to(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryInitFrom { instr_offset: _, dst, src, len } => {
                self.execute_memory_init_from(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryInitFromTo { instr_offset: _, dst, src, len } => {
                self.execute_memory_init_from_to(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryInitExact { instr_offset: _, dst, src, len } => {
                self.execute_memory_init_exact(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryInitToExact { instr_offset: _, dst, src, len } => {
                self.execute_memory_init_to_exact(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryInitFromExact { instr_offset: _, dst, src, len } => {
                self.execute_memory_init_from_exact(&mut store.inner, dst, src, len)?
            }
            Instr::MemoryInitFromToExact { instr_offset: _, dst, src, len } => {
                self.execute_memory_init_from_to_exact(&mut store.inner, dst, src, len)?
            }
            Instr::TableIndex { .. }
            | Instr::MemoryIndex { .. }
            | Instr::DataIndex { .. }
            | Instr::ElemIndex { .. }
            | Instr::Const32 { .. }
            | Instr::I64Const32 { .. }
            | Instr::F64Const32 { .. }
            | Instr::BranchTableTarget { .. }
            | Instr::BranchTableTargetNonOverlapping { .. }
            | Instr::Register { .. }
            | Instr::Register2 { .. }
            | Instr::Register3 { .. }
            | Instr::RegisterAndImm32 { .. }
            | Instr::Imm16AndImm32 { .. }
            | Instr::RegisterSpan { .. }
            | Instr::RegisterList { .. }
            | Instr::CallIndirectParams { .. }
            | Instr::CallIndirectParamsImm16 { .. } => self.invalid_instruction_word()?,
        }

        return Ok(Signal::Next);
    }
}

pub trait Interceptor {
    fn invoke_func(&self, func_idx: i32, table: Option<Table>) -> Signal;
    fn execute_inst(&self, instr_offset: u32) -> Signal;
}

macro_rules! get_entity {
    (
        $(
            fn $name:ident(&self, index: $index_ty:ty) -> $id_ty:ty;
        )*
    ) => {
        $(
            #[doc = ::core::concat!(
                "Returns the [`",
                ::core::stringify!($id_ty),
                "`] at `index` for the currently used [`Instance`].\n\n",
                "# Panics\n\n",
                "- If there is no [`",
                ::core::stringify!($id_ty),
                "`] at `index` for the currently used [`Instance`] in `store`."
            )]
            #[inline]
            fn $name(&self, index: $index_ty) -> $id_ty {
                unsafe { self.cache.$name(index) }
                    .unwrap_or_else(|| {
                        const ENTITY_NAME: &'static str = ::core::stringify!($id_ty);
                        // Safety: within the Wasmi executor it is assumed that store entity
                        //         indices within the Wasmi bytecode are always valid for the
                        //         store. This is an invariant of the Wasmi translation.
                        unsafe {
                            unreachable_unchecked!(
                                "missing {ENTITY_NAME} at index {index:?} for the currently used instance",
                            )
                        }
                    })
            }
        )*
    }
}

impl Executor<'_> {
    get_entity! {
        fn get_func(&self, index: index::Func) -> Func;
        fn get_func_type_dedup(&self, index: index::FuncType) -> DedupFuncType;
        fn get_memory(&self, index: index::Memory) -> Memory;
        fn get_table(&self, index: index::Table) -> Table;
        fn get_global(&self, index: index::Global) -> Global;
        fn get_data_segment(&self, index: index::Data) -> DataSegment;
        fn get_element_segment(&self, index: index::Elem) -> ElementSegment;
    }

    /// Returns the [`Reg`] value.
    fn get_register(&self, register: Reg) -> UntypedVal {
        // Safety: - It is the responsibility of the `Executor`
        //           implementation to keep the `sp` pointer valid
        //           whenever this method is accessed.
        //         - This is done by updating the `sp` pointer whenever
        //           the heap underlying the value stack is changed.
        unsafe { self.sp.get(register) }
    }

    /// Returns the [`Reg`] value.
    fn get_register_as<T>(&self, register: Reg) -> T
    where
        T: From<UntypedVal>,
    {
        T::from(self.get_register(register))
    }

    /// Sets the [`Reg`] value to `value`.
    fn set_register(&mut self, register: Reg, value: impl Into<UntypedVal>) {
        // Safety: - It is the responsibility of the `Executor`
        //           implementation to keep the `sp` pointer valid
        //           whenever this method is accessed.
        //         - This is done by updating the `sp` pointer whenever
        //           the heap underlying the value stack is changed.
        unsafe { self.sp.set(register, value.into()) };
    }

    /// Shifts the instruction pointer to the next instruction.
    #[inline(always)]
    fn next_instr(&mut self) {
        self.next_instr_at(1)
    }

    /// Shifts the instruction pointer to the next instruction.
    ///
    /// Has a parameter `skip` to denote how many instruction words
    /// to skip to reach the next actual instruction.
    ///
    /// # Note
    ///
    /// This is used by Wasmi instructions that have a fixed
    /// encoding size of two instruction words such as [`Instruction::Branch`].
    #[inline(always)]
    fn next_instr_at(&mut self, skip: usize) {
        self.ip.add(skip)
    }

    /// Shifts the instruction pointer to the next instruction and returns `Ok(())`.
    ///
    /// # Note
    ///
    /// This is a convenience function for fallible instructions.
    #[inline(always)]
    fn try_next_instr(&mut self) -> Result<(), Error> {
        self.try_next_instr_at(1)
    }

    /// Shifts the instruction pointer to the next instruction and returns `Ok(())`.
    ///
    /// Has a parameter `skip` to denote how many instruction words
    /// to skip to reach the next actual instruction.
    ///
    /// # Note
    ///
    /// This is a convenience function for fallible instructions.
    #[inline(always)]
    fn try_next_instr_at(&mut self, skip: usize) -> Result<(), Error> {
        self.next_instr_at(skip);
        Ok(())
    }

    /// Returns the [`FrameRegisters`] of the [`CallFrame`].
    fn frame_stack_ptr_impl(value_stack: &mut ValueStack, frame: &CallFrame) -> FrameRegisters {
        // Safety: We are using the frame's own base offset as input because it is
        //         guaranteed by the Wasm validation and translation phase to be
        //         valid for all register indices used by the associated function body.
        unsafe { value_stack.stack_ptr_at(frame.base_offset()) }
    }

    /// Initializes the [`Executor`] state for the [`CallFrame`].
    ///
    /// # Note
    ///
    /// The initialization of the [`Executor`] allows for efficient execution.
    fn init_call_frame(&mut self, frame: &CallFrame) {
        Self::init_call_frame_impl(&mut self.stack.values, &mut self.sp, &mut self.ip, frame)
    }

    /// Initializes the [`Executor`] state for the [`CallFrame`].
    ///
    /// # Note
    ///
    /// The initialization of the [`Executor`] allows for efficient execution.
    fn init_call_frame_impl(
        value_stack: &mut ValueStack,
        sp: &mut FrameRegisters,
        ip: &mut InstructionPtr,
        frame: &CallFrame,
    ) {
        *sp = Self::frame_stack_ptr_impl(value_stack, frame);
        *ip = frame.instr_ptr();
    }

    /// Executes a generic unary [`Instruction`].
    #[inline(always)]
    fn execute_unary(&mut self, result: Reg, input: Reg, op: fn(UntypedVal) -> UntypedVal) {
        let value = self.get_register(input);
        self.set_register(result, op(value));
        self.next_instr();
    }

    /// Executes a fallible generic unary [`Instruction`].
    #[inline(always)]
    fn try_execute_unary(
        &mut self,
        result: Reg,
        input: Reg,
        op: fn(UntypedVal) -> Result<UntypedVal, TrapCode>,
    ) -> Result<(), Error> {
        let value = self.get_register(input);
        self.set_register(result, op(value)?);
        self.try_next_instr()
    }

    /// Executes a generic binary [`Instruction`].
    #[inline(always)]
    fn execute_binary(
        &mut self,
        result: Reg,
        lhs: Reg,
        rhs: Reg,
        op: fn(UntypedVal, UntypedVal) -> UntypedVal,
    ) {
        let lhs = self.get_register(lhs);
        let rhs = self.get_register(rhs);
        self.set_register(result, op(lhs, rhs));
        self.next_instr();
    }

    /// Executes a generic binary [`Instruction`].
    #[inline(always)]
    fn execute_binary_imm16<T>(
        &mut self,
        result: Reg,
        lhs: Reg,
        rhs: Const16<T>,
        op: fn(UntypedVal, UntypedVal) -> UntypedVal,
    ) where
        T: From<Const16<T>>,
        UntypedVal: From<T>,
    {
        let lhs = self.get_register(lhs);
        let rhs = UntypedVal::from(<T>::from(rhs));
        self.set_register(result, op(lhs, rhs));
        self.next_instr();
    }

    /// Executes a generic binary [`Instruction`] with reversed operands.
    #[inline(always)]
    fn execute_binary_imm16_lhs<T>(
        &mut self,
        result: Reg,
        lhs: Const16<T>,
        rhs: Reg,
        op: fn(UntypedVal, UntypedVal) -> UntypedVal,
    ) where
        T: From<Const16<T>>,
        UntypedVal: From<T>,
    {
        let lhs = UntypedVal::from(<T>::from(lhs));
        let rhs = self.get_register(rhs);
        self.set_register(result, op(lhs, rhs));
        self.next_instr();
    }

    /// Executes a generic shift or rotate [`Instruction`].
    #[inline(always)]
    fn execute_shift_by<T>(
        &mut self,
        result: Reg,
        lhs: Reg,
        rhs: ShiftAmount<T>,
        op: fn(UntypedVal, UntypedVal) -> UntypedVal,
    ) where
        T: From<ShiftAmount<T>>,
        UntypedVal: From<T>,
    {
        let lhs = self.get_register(lhs);
        let rhs = UntypedVal::from(<T>::from(rhs));
        self.set_register(result, op(lhs, rhs));
        self.next_instr();
    }

    /// Executes a fallible generic binary [`Instruction`].
    #[inline(always)]
    fn try_execute_binary(
        &mut self,
        result: Reg,
        lhs: Reg,
        rhs: Reg,
        op: fn(UntypedVal, UntypedVal) -> Result<UntypedVal, TrapCode>,
    ) -> Result<(), Error> {
        let lhs = self.get_register(lhs);
        let rhs = self.get_register(rhs);
        self.set_register(result, op(lhs, rhs)?);
        self.try_next_instr()
    }

    /// Executes a fallible generic binary [`Instruction`].
    #[inline(always)]
    fn try_execute_divrem_imm16_rhs<NonZeroT>(
        &mut self,
        result: Reg,
        lhs: Reg,
        rhs: Const16<NonZeroT>,
        op: fn(UntypedVal, NonZeroT) -> Result<UntypedVal, Error>,
    ) -> Result<(), Error>
    where
        NonZeroT: From<Const16<NonZeroT>>,
    {
        let lhs = self.get_register(lhs);
        let rhs = <NonZeroT>::from(rhs);
        self.set_register(result, op(lhs, rhs)?);
        self.try_next_instr()
    }

    /// Executes a fallible generic binary [`Instruction`].
    #[inline(always)]
    fn execute_divrem_imm16_rhs<NonZeroT>(
        &mut self,
        result: Reg,
        lhs: Reg,
        rhs: Const16<NonZeroT>,
        op: fn(UntypedVal, NonZeroT) -> UntypedVal,
    ) where
        NonZeroT: From<Const16<NonZeroT>>,
    {
        let lhs = self.get_register(lhs);
        let rhs = <NonZeroT>::from(rhs);
        self.set_register(result, op(lhs, rhs));
        self.next_instr()
    }

    /// Executes a fallible generic binary [`Instruction`] with reversed operands.
    #[inline(always)]
    fn try_execute_binary_imm16_lhs<T>(
        &mut self,
        result: Reg,
        lhs: Const16<T>,
        rhs: Reg,
        op: fn(UntypedVal, UntypedVal) -> Result<UntypedVal, TrapCode>,
    ) -> Result<(), Error>
    where
        T: From<Const16<T>>,
        UntypedVal: From<T>,
    {
        let lhs = UntypedVal::from(<T>::from(lhs));
        let rhs = self.get_register(rhs);
        self.set_register(result, op(lhs, rhs)?);
        self.try_next_instr()
    }

    /// Skips all [`Instruction`]s belonging to an [`Instruction::RegisterList`] encoding.
    #[inline(always)]
    fn skip_register_list(ip: InstructionPtr) -> InstructionPtr {
        let mut ip = ip;
        while let Instruction::RegisterList { .. } = *ip.get() {
            ip.add(1);
        }
        // We skip an additional `Instruction` because we know that `Instruction::RegisterList` is always followed by one of:
        // - `Instruction::Register`
        // - `Instruction::Register2`
        // - `Instruction::Register3`.
        ip.add(1);
        ip
    }

    /// Returns the optional `memory` parameter for a `load_at` [`Instruction`].
    ///
    /// # Note
    ///
    /// - Returns the default [`index::Memory`] if the parameter is missing.
    /// - Bumps `self.ip` if a [`Instruction::MemoryIndex`] parameter was found.
    #[inline(always)]
    fn fetch_optional_memory(&mut self) -> index::Memory {
        let mut addr: InstructionPtr = self.ip;
        addr.add(1);
        match *addr.get() {
            Instruction::MemoryIndex { instr_offset: _, index } => {
                hint::cold();
                self.ip = addr;
                index
            }
            _ => index::Memory::from(0),
        }
    }
}

impl Executor<'_> {
    /// Used for all [`Instruction`] words that are not meant for execution.
    ///
    /// # Note
    ///
    /// This includes [`Instruction`] variants such as [`Instruction::TableIndex`]
    /// that primarily carry parameters for actually executable [`Instruction`].
    fn invalid_instruction_word(&mut self) -> Result<(), Error> {
        // Safety: Wasmi translation guarantees that branches are never taken to instruction parameters directly.
        unsafe {
            unreachable_unchecked!(
                "expected instruction but found instruction parameter: {:?}",
                *self.ip.get()
            )
        }
    }

    /// Executes a Wasm `unreachable` instruction.
    fn execute_trap(&mut self, trap_code: TrapCode) -> Result<(), Error> {
        Err(Error::from(trap_code))
    }

    /// Executes an [`Instruction::ConsumeFuel`].
    fn execute_consume_fuel(
        &mut self,
        store: &mut StoreInner,
        block_fuel: BlockFuel,
    ) -> Result<(), Error> {
        // We do not have to check if fuel metering is enabled since
        // [`Instruction::ConsumeFuel`] are only generated if fuel metering
        // is enabled to begin with.
        store
            .fuel_mut()
            .consume_fuel_unchecked(block_fuel.to_u64())?;
        self.try_next_instr()
    }

    /// Executes an [`Instruction::RefFunc`].
    fn execute_ref_func(&mut self, result: Reg, func_index: index::Func) {
        let func = self.get_func(func_index);
        let funcref = FuncRef::new(func);
        self.set_register(result, funcref);
        self.next_instr();
    }
}

/// Extension method for [`UntypedVal`] required by the [`Executor`].
trait UntypedValueExt {
    /// Executes a fused `i32.and` + `i32.eqz` instruction.
    fn i32_and_eqz(x: UntypedVal, y: UntypedVal) -> UntypedVal;

    /// Executes a fused `i32.or` + `i32.eqz` instruction.
    fn i32_or_eqz(x: UntypedVal, y: UntypedVal) -> UntypedVal;

    /// Executes a fused `i32.xor` + `i32.eqz` instruction.
    fn i32_xor_eqz(x: UntypedVal, y: UntypedVal) -> UntypedVal;
}

impl UntypedValueExt for UntypedVal {
    fn i32_and_eqz(x: UntypedVal, y: UntypedVal) -> UntypedVal {
        (i32::from(UntypedVal::i32_and(x, y)) == 0).into()
    }

    fn i32_or_eqz(x: UntypedVal, y: UntypedVal) -> UntypedVal {
        (i32::from(UntypedVal::i32_or(x, y)) == 0).into()
    }

    fn i32_xor_eqz(x: UntypedVal, y: UntypedVal) -> UntypedVal {
        (i32::from(UntypedVal::i32_xor(x, y)) == 0).into()
    }
}
