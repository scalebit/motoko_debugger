
use std::{
    pin::Pin,
    task::{Context, RawWaker, RawWakerVTable, Waker},
};
use wasi_common::{Error, WasiCtx};
use wasmi::{state::Constructing, Caller, Extern, Linker, LinkerBuilder};
// use wiggle::{anyhow::Ok, GuestMemory};
type HypervisorResult<T> = Result<T, wasmi::Error>;

// Creates a dummy `RawWaker`. We can only create Wakers from `RawWaker`s
fn dummy_raw_waker() -> RawWaker {
    fn no_op(_: *const ()) {}
    //returns a new RawWaker by calling dummy_raw_waker again
    fn clone(_: *const ()) -> RawWaker {
        dummy_raw_waker()
    }
    // RawWakerVTable specifies the functions that should be called when the RawWaker is cloned, woken, or dropped.
    let vtable = &RawWakerVTable::new(clone, no_op, no_op, no_op);

    RawWaker::new(std::ptr::null::<()>(), vtable)
}

// Creates a dummy waker which does *nothing*, as the future itsef polls to ready at first poll
// A waker is needed to do any polling at all, as it is the primary constituent of the `Context` for polling
fn run_in_dummy_executor<F: std::future::Future>(f: F) -> Result<F::Output, wasmi::Error> {
    let mut f = Pin::from(Box::new(f));
    let waker = unsafe { Waker::from_raw(dummy_raw_waker()) };
    let mut cx = Context::from_waker(&waker);
    match f.as_mut().poll(&mut cx) {
        std::task::Poll::Ready(val) => Ok(val),
        std::task::Poll::Pending => Err(wasmi::Error::new("Cannot wait on pending future")),
    }
}

/// Implemented by Wasmi [`Linker`] and [`LinkerBuilder`] to populate them with WASI definitions.
///
/// [`Linker`]: wasmi::Linker
/// [`LinkerBuilder`]: wasmi::LinkerBuilder
pub trait AddWasiMotokoSyscall<T> {
    /// Add Wasi preview1 definitions to `self`.
    fn add_wasi<U>(
        &mut self,
        wasi_ctx: impl Fn(&mut T) -> &mut U + Send + Sync + Copy + 'static,
    ) -> Result<(), Error>
    where
        U: MotokoSyscall;
}

/// Adds the entire WASI API to the Wasmi [`Linker`].
///
/// Once linked, users can make use of all the low-level functionalities that `WASI` provides.
///
/// You could call them `syscall`s and you'd be correct, because they mirror
/// what a non-os-dependent set of syscalls would look like.
/// You now have access to resources such as files, directories, random number generators,
/// and certain parts of the networking stack.
///
/// # Note
///
/// `WASI` is versioned in snapshots. It's still a WIP. Currently, this crate supports `preview_1`
/// Look [here](https://github.com/WebAssembly/WASI/blob/main/phases/snapshot/docs.md) for more details.
pub fn add_motoko_syscall_to_linker<T, U>(
    linker: &mut Linker<T>,
    wasi_ctx: impl Fn(&mut T) -> &mut U + Send + Sync + Copy + 'static,
) -> Result<(), Error>
where
    U: MotokoSyscall,
{
    <Linker<T> as AddWasiMotokoSyscall<T>>::add_wasi(linker, wasi_ctx)
}

/// Adds the entire WASI API to the Wasmi [`LinkerBuilder`].
///
/// For more information view [`add_wasi_snapshot_preview1_to_linker`].
pub fn add_motoko_syscall_to_linker_builder<T, U>(
    linker: &mut LinkerBuilder<Constructing, T>,
    wasi_ctx: impl Fn(&mut T) -> &mut U + Send + Sync + Copy + 'static,
) -> Result<(), Error>
where
    U: MotokoSyscall,
{
    <LinkerBuilder<Constructing, T> as AddWasiMotokoSyscall<T>>::add_wasi(linker, wasi_ctx)
}

// Creates the function item `add_wasi_snapshot_preview1_to_wasmi_linker` which when called adds all
// `wasi preview_1` functions to the linker
macro_rules! add_funcs_to_linker {
    (
        $linker:ty,
        $(
            $( #[$docs:meta] )*
            fn $fname:ident ($( $arg:ident : $typ:ty ),* $(,)? ) -> $ret:tt
        );+ $(;)?
    ) => {
        impl<T> AddWasiMotokoSyscall<T> for $linker {
            fn add_wasi<U>(
                &mut self,
                wasi_ctx: impl Fn(&mut T) -> &mut U + Send + Sync + Copy + 'static,
            ) -> Result<(), Error>
            where
                U: MotokoSyscall,
            {
                $(
                    // $(#[$docs])* // TODO: find place for docs
                    self.func_wrap(
                        "ic0",
                        stringify!($fname),
                        move |mut caller: Caller<'_, T>, $($arg : $typ,)*| -> Result<$ret, wasmi::Error> {
                            let result = async {
                                let memory = match caller.get_export("mem") {
                                    Some(Extern::Memory(m)) => m,
                                    _ => {
                                        let err_msg = format!("missing required WASI memory export in ic0::{}", stringify!($fname));
                                        return Err(wasmi::Error::new(String::from(err_msg)))
                                    },
                                };
                                let(memory, ctx) = memory.data_and_store_mut(&mut caller);
                                let ctx = wasi_ctx(ctx);
                                // let mut memory = WasmiGuestMemory::Unshared(memory);
                                match MotokoSyscall::$fname(ctx, memory,  $($arg,)*) {
                                    std::result::Result::Ok(r) => Ok(<$ret>::from(r)),
                                    _ => Err(wasmi::Error::new(String::from("error")))
                                }
                            };
                            run_in_dummy_executor(result)?
                        }
                    ).map_err(wiggle::anyhow::Error::from).map_err(wasi_common::Error::trap)?;
                )*
                Ok(())
            }
        }
    }
}

macro_rules! apply_wasi_definitions {
    ($mac:ident, $linker:ty) => {
        $mac! {
            $linker,

            fn msg_caller_copy(a: u32, b: u32, c: u32) -> (); 
            fn msg_caller_size() -> u32; 
            fn msg_arg_data_size() -> u32; 
            fn msg_arg_data_copy(a: u32, b: u32, c: u32) -> (); 
            fn msg_method_name_size() -> u32; 
            fn msg_method_name_copy(a: u32, b: u32, c: u32) -> (); 
            fn accept_message() -> (); 
            fn msg_reply_data_append(a: u32, b: u32) -> (); 
            fn msg_reply() -> (); 
            fn msg_reject_code() -> i32; 
            fn msg_reject(a: u32, b: u32) -> (); 
            fn msg_reject_msg_size() -> u32; 
            fn msg_reject_msg_copy(a: u32, b: u32, c: u32) -> (); 
            fn canister_self_size() -> i32; 
            fn canister_self_copy(a: u32, b: u32, c: u32) -> (); 
            fn controller_size() -> i32; 
            fn controller_copy(a: u32, b: u32, c: u32) -> (); 
            fn debug_print(a: u32, b: u32) -> (); 
            fn trap(a: u32, b: u32) -> (); 
            fn call_simple(a: u32, b: u32, c: u32, d: u32, e: u32, f: u32, g: u32, h: u32, i: u32, j: u32) -> i32; 
            fn call_new(a: u32, b: u32, c: u32, d: u32, e: u32, f: u32, g: u32, h: u32) -> (); 
            fn call_data_append(a: u32, b: u32) -> (); 
            fn call_with_best_effort_response(timeout_seconds: u32) -> ();
            fn call_on_cleanup(a: u32, b: u32) -> (); 
            fn call_cycles_add(cycles: u64) -> (); 
            fn call_perform() -> i32; 
            fn stable_size() -> u32; 
            fn stable_grow(a: u32) -> i32; 
            fn stable_read(a: u32, b: u32, c: u32) -> (); 
            fn stable_write(a: u32, b: u32, c: u32) -> (); 
            fn stable64_size() -> u64; 
            fn stable64_grow(a: u64) -> i64; 
            fn stable64_read(a: u64, b: u64, c: u64) -> (); 
            fn stable64_write(a: u64, b: u64, c: u64) -> (); 
            fn update_available_memory(a: i32, b: u32) -> i32; 
            fn canister_cycle_balance() -> u64; 
            fn canister_cycles_balance128(a: u32) -> (); 
            fn msg_cycles_available() -> u64; 
            fn msg_cycles_available128(a: u32) -> (); 
            fn msg_cycles_refunded() -> u64; 
            fn msg_cycles_refunded128(a: u32) -> (); 
            fn msg_cycles_accept(cycles: u64) -> u64; 
            fn certified_data_set(a: u32, b: u32) -> (); 
            fn data_certificate_present() -> i32; 
            fn data_certificate_size() -> i32; 
            fn data_certificate_copy(a: u32, b: u32, c: u32) -> (); 
            fn canister_status() -> u32; 
            fn mint_cycles(cycles: u64) -> u64;
            fn mint_cycles128(amount_high: u64, amount_low: u64, dst: u32) -> ();

            fn call_cycles_add128(amount_high: u64, amount_low: u64) ->();
            fn canister_cycle_balance128(dst: u32) -> ();
            fn canister_version() -> u64;
            fn is_controller(a: u32, b: u32) -> u32; 
            fn in_replicated_execution() -> u32;
            fn msg_cycles_accept128(max_amount_high: u64, max_amount_low: u64, dst: u32) -> ();
            fn cycles_burn128(amount_high: u64, amount_low: u64, dst: u32) -> ();
            fn msg_deadline() -> u64;
            fn performance_counter(counter_type: u32) -> u64;
            fn time() -> u64;
            fn global_timer_set(timestamp: u64) -> u64;

            fn cost_call(method_name_size: u64, payload_size: u64, dst: u32) -> ();
            fn cost_create_canister(dst: u32) -> ();
            fn cost_http_request(request_size: u64, max_res_bytes: u64, dst: u32) -> ();
            fn cost_sign_with_ecdsa(src: u32, size: u32, ecdsa_curve: u32, dst: u32) -> u32;
            fn cost_sign_with_schnorr(src: u32, size: u32, algorithm: u32, dst: u32) -> u32;
            fn cost_vetkd_derive_key(src: u32, size: u32, vetkd_curve: u32, dst: u32) -> u32;

            fn subnet_self_copy(dst: u32, offset: u32, size: u32) -> ();
            fn subnet_self_size() -> u32;
        }
    };
}

apply_wasi_definitions!(add_funcs_to_linker, Linker<T>);
apply_wasi_definitions!(add_funcs_to_linker, LinkerBuilder<Constructing, T>);


pub trait MotokoSyscall {
    fn msg_caller_copy(&self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn msg_caller_size(&self, memory: &mut [u8]) -> HypervisorResult<u32>; 
    fn msg_arg_data_size(&self, memory: &mut [u8]) -> HypervisorResult<u32>; 
    fn msg_arg_data_copy(&self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn msg_method_name_size(&self, memory: &mut [u8]) -> HypervisorResult<u32>; 
    fn msg_method_name_copy(&self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn accept_message(&mut self, memory: &mut [u8]) -> HypervisorResult<()>; 
    fn msg_reply_data_append(&mut self, memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()>; 
    fn msg_reply(&mut self, memory: &mut [u8]) -> HypervisorResult<()>; 
    fn msg_reject_code(&self, memory: &mut [u8]) -> HypervisorResult<i32>; 
    fn msg_reject(&mut self, memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()>; 
    fn msg_reject_msg_size(&self, memory: &mut [u8]) -> HypervisorResult<u32>; 
    fn msg_reject_msg_copy(&self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn canister_self_size(&self, memory: &mut [u8]) -> HypervisorResult<i32>; 
    fn canister_self_copy(&mut self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn controller_size(&self, memory: &mut [u8]) -> HypervisorResult<i32>; 
    fn controller_copy(&mut self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn debug_print(&self, memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()>; 
    fn trap(&self, memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()>; 
    fn call_simple(&mut self, memory: &mut [u8], _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32) -> HypervisorResult<i32>; 
    fn call_new(&mut self, memory: &mut [u8], _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn call_data_append(&mut self, memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()>; 
    fn call_with_best_effort_response(&mut self, memory: &mut [u8], _: u32) -> HypervisorResult<()>;
    fn call_on_cleanup(&mut self, memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()>; 
    fn call_cycles_add(&mut self, memory: &mut [u8], _: u64) -> HypervisorResult<()>; 
    fn call_perform(&mut self, memory: &mut [u8]) -> HypervisorResult<i32>; 
    fn stable_size(&self, memory: &mut [u8]) -> HypervisorResult<u32>; 
    fn stable_grow(&mut self, memory: &mut [u8], _: u32) -> HypervisorResult<i32>; 
    fn stable_read(&self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn stable_write(&mut self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn stable64_size(&self, memory: &mut [u8]) -> HypervisorResult<u64>; 
    fn stable64_grow(&mut self, memory: &mut [u8], _: u64) -> HypervisorResult<i64>; 
    fn stable64_read(&self, memory: &mut [u8], _: u64, _: u64, _: u64) -> HypervisorResult<()>; 
    fn stable64_write(&mut self, memory: &mut [u8], _: u64, _: u64, _: u64) -> HypervisorResult<()>; 
    fn update_available_memory(&mut self, memory: &mut [u8], _: i32, _: u32) -> HypervisorResult<i32>; 
    fn canister_cycle_balance(&self, memory: &mut [u8]) -> HypervisorResult<u64>; 
    fn canister_cycles_balance128(&self, memory: &mut [u8], _: u32) -> HypervisorResult<()>; 
    fn msg_cycles_available(&self, memory: &mut [u8]) -> HypervisorResult<u64>; 
    fn msg_cycles_available128(&self, memory: &mut [u8], _: u32) -> HypervisorResult<()>; 
    fn msg_cycles_refunded(&self, memory: &mut [u8]) -> HypervisorResult<u64>; 
    fn msg_cycles_refunded128(&self, memory: &mut [u8], _: u32) -> HypervisorResult<()>; 
    fn msg_cycles_accept(&mut self, memory: &mut [u8], _: u64) -> HypervisorResult<u64>; 
    fn certified_data_set(&mut self, memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()>; 
    fn data_certificate_present(&self, memory: &mut [u8]) -> HypervisorResult<i32>; 
    fn data_certificate_size(&self, memory: &mut [u8]) -> HypervisorResult<i32>; 
    fn data_certificate_copy(&self, memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()>; 
    fn canister_status(&self, memory: &mut [u8]) -> HypervisorResult<u32>; 
    fn mint_cycles(&self, memory: &mut [u8], cycles: u64) -> HypervisorResult<u64>;
    fn mint_cycles128(&self, memory: &mut [u8], amount_high: u64, amount_low: u64, dst: u32) -> HypervisorResult<()>;

    fn call_cycles_add128(&mut self, memory: &mut [u8], amount_high: u64, amount_low: u64) -> HypervisorResult<()>;
    fn canister_cycle_balance128(&mut self, memory: &mut [u8], dst: u32) -> HypervisorResult<()>;
    fn canister_version(&self, memory: &mut [u8]) -> HypervisorResult<u64>;
    fn is_controller(&self, memory: &mut [u8], a: u32, b: u32) -> HypervisorResult<u32>;
    fn in_replicated_execution(&self, memory: &mut [u8]) -> HypervisorResult<u32>;
    fn msg_cycles_accept128(&mut self, memory: &mut [u8], max_amount_high: u64, max_amount_low: u64, dst: u32) -> HypervisorResult<()>;
    fn cycles_burn128(&mut self, memory: &mut [u8], amount_high: u64, amount_low: u64, dst: u32) -> HypervisorResult<()>;
    fn msg_deadline(&self, memory: &mut [u8]) -> HypervisorResult<u64>;
    fn performance_counter(&self, memory: &mut [u8], counter_type: u32) -> HypervisorResult<u64>;
    fn time(&self, memory: &mut [u8]) -> HypervisorResult<u64>;
    fn global_timer_set(&mut self, memory: &mut [u8], timestamp: u64) -> HypervisorResult<u64>;

    fn cost_call(&mut self, memory: &mut [u8], method_name_size: u64, payload_size: u64, dst: u32) -> HypervisorResult<()>;
    fn cost_create_canister(&mut self, memory: &mut [u8], dst: u32) -> HypervisorResult<()>;
    fn cost_http_request(&mut self, memory: &mut [u8], request_size: u64, max_res_bytes: u64, dst: u32) -> HypervisorResult<()>;
    fn cost_sign_with_ecdsa(&mut self, memory: &mut [u8], src: u32, size: u32, ecdsa_curve: u32, dst: u32) -> HypervisorResult<u32>;
    fn cost_sign_with_schnorr(&mut self, memory: &mut [u8], src: u32, size: u32, algorithm: u32, dst: u32) -> HypervisorResult<u32>;
    fn cost_vetkd_derive_key(&mut self, memory: &mut [u8], src: u32, size: u32, vetkd_curve: u32, dst: u32) -> HypervisorResult<u32>;
    
    fn subnet_self_copy(&self, memory: &mut [u8], dst: u32, offset: u32, size: u32) -> HypervisorResult<()>;
    fn subnet_self_size(&self, memory: &mut [u8]) -> HypervisorResult<u32>;

}


impl MotokoSyscall for WasiCtx {
    fn msg_caller_copy(&self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_caller_size(&self, _memory: &mut [u8]) -> HypervisorResult<u32> {
        Ok(0)
    }
    
    fn msg_arg_data_size(&self, _memory: &mut [u8]) -> HypervisorResult<u32> {
        Ok(0)
    }
    
    fn msg_arg_data_copy(&self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_method_name_size(&self, _memory: &mut [u8]) -> HypervisorResult<u32> {
        Ok(0)
    }
    
    fn msg_method_name_copy(&self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn accept_message(&mut self, _memory: &mut [u8]) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_reply_data_append(&mut self, _memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_reply(&mut self, _memory: &mut [u8]) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_reject_code(&self, _memory: &mut [u8]) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn msg_reject(&mut self, _memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_reject_msg_size(&self, _memory: &mut [u8]) -> HypervisorResult<u32> {
        Ok(0)
    }
    
    fn msg_reject_msg_copy(&self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn canister_self_size(&self, _memory: &mut [u8]) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn canister_self_copy(&mut self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn controller_size(&self, _memory: &mut [u8]) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn controller_copy(&mut self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn debug_print(&self, _memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn trap(&self, memory: &mut [u8], str: u32, len: u32) -> HypervisorResult<()> {
        const MAX_ERROR_MESSAGE_SIZE: usize = 16 * 1024;
        let size = len  as usize;
        let src = str as usize;
        let size = size.min(MAX_ERROR_MESSAGE_SIZE);
        let result = std::str::from_utf8(&memory[src..src + size]);
        println!("result: {:?}", result);
        // Err(result)
        Ok(())
    }
    
    fn call_simple(&mut self, _memory: &mut [u8], _: u32,_: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn call_new(&mut self, _memory: &mut [u8], _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn call_with_best_effort_response(&mut self, _memory: &mut [u8], _: u32) -> HypervisorResult<()> {
        Ok(())
    }

    fn call_data_append(&mut self, _memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn call_on_cleanup(&mut self, _memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn call_cycles_add(&mut self, _memory: &mut [u8], _: u64) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn call_perform(&mut self, _memory: &mut [u8]) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn stable_size(&self, _memory: &mut [u8]) -> HypervisorResult<u32> {
        Ok(0)
    }
    
    fn stable_grow(&mut self, _memory: &mut [u8], _: u32) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn stable_read(&self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn stable_write(&mut self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn stable64_size(&self, _memory: &mut [u8]) -> HypervisorResult<u64> {
        Ok(0)
    }
    
    fn stable64_grow(&mut self, _memory: &mut [u8], _: u64) -> HypervisorResult<i64> {
        Ok(0)
    }
    
    fn stable64_read(&self, _memory: &mut [u8], _: u64, _: u64, _: u64) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn stable64_write(&mut self, _memory: &mut [u8], _: u64, _: u64, _: u64) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn update_available_memory(&mut self, _memory: &mut [u8], _: i32, _: u32) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn canister_cycle_balance(&self, _memory: &mut [u8]) -> HypervisorResult<u64> {
        Ok(0)
    }
    
    fn canister_cycles_balance128(&self, _memory: &mut [u8], _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_cycles_available(&self, _memory: &mut [u8]) -> HypervisorResult<u64> {
        Ok(0)
    }
    
    fn msg_cycles_available128(&self, _memory: &mut [u8], _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_cycles_refunded(&self, _memory: &mut [u8]) -> HypervisorResult<u64> {
        Ok(0)
    }
    
    fn msg_cycles_refunded128(&self, _memory: &mut [u8], _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn msg_cycles_accept(&mut self, _memory: &mut [u8], _: u64) -> HypervisorResult<u64> {
        Ok(0)
    }
    
    fn certified_data_set(&mut self, _memory: &mut [u8], _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn data_certificate_present(&self, _memory: &mut [u8]) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn data_certificate_size(&self, _memory: &mut [u8]) -> HypervisorResult<i32> {
        Ok(0)
    }
    
    fn data_certificate_copy(&self, _memory: &mut [u8], _: u32, _: u32, _: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn canister_status(&self, _memory: &mut [u8]) -> HypervisorResult<u32> {
        Ok(0)
    }
    
    fn mint_cycles(&self, _memory: &mut [u8], cycles: u64) -> HypervisorResult<u64> {
        Ok(cycles) // Returning the input value as a placeholder
    }

    fn mint_cycles128(&self, _memory: &mut [u8], _amount_high: u64, _amount_low: u64, _dst: u32) -> HypervisorResult<()> {
        Ok(())
    }
    
    fn call_cycles_add128(&mut self, _memory: &mut [u8], _amount_high: u64, _amount_low: u64) -> HypervisorResult<()> {
        Ok(())
    }

    fn canister_cycle_balance128(&mut self, _memory: &mut [u8], _dst: u32) -> HypervisorResult<()> {
        Ok(())
    }

    fn canister_version(&self, _memory: &mut [u8]) -> HypervisorResult<u64> {
        Ok(0)
    }

    fn is_controller(&self, _memory: &mut [u8], _a: u32, _b: u32) -> HypervisorResult<u32> {
        Ok(0)
    }

    fn in_replicated_execution(&self, _memory: &mut [u8]) -> HypervisorResult<u32> {
        Ok(0)
    }

    fn msg_cycles_accept128(&mut self, _memory: &mut [u8], _max_amount_high: u64, _max_amount_low: u64, _dst: u32) -> HypervisorResult<()> {
        Ok(())
    }

    fn cycles_burn128(&mut self, _memory: &mut [u8], _amount_high: u64, _amount_low: u64, _dst: u32) -> HypervisorResult<()> {
        Ok(())
    }

    fn msg_deadline(&self, _memory: &mut [u8]) -> HypervisorResult<u64> {
        Ok(0)
    }

    fn performance_counter(&self, _memory: &mut [u8], _counter_type: u32) -> HypervisorResult<u64> {
        Ok(0)
    }

    fn time(&self, _memory: &mut [u8]) -> HypervisorResult<u64> {
        Ok(0)
    }

    fn global_timer_set(&mut self, _memory: &mut [u8], timestamp: u64) -> HypervisorResult<u64> {
        Ok(timestamp)
    }

    fn cost_call(&mut self, _memory: &mut [u8], _method_name_size: u64, _payload_size: u64, _dst: u32) -> HypervisorResult<()> {
        Ok(())
    }

    fn cost_create_canister(&mut self, _memory: &mut [u8], _dst: u32) -> HypervisorResult<()> {
        Ok(())
    }

    fn cost_http_request(&mut self, _memory: &mut [u8], _request_size: u64, _max_res_bytes: u64, _dst: u32) -> HypervisorResult<()> {
        Ok(())
    }

    fn cost_sign_with_ecdsa(&mut self, _memory: &mut [u8], _src: u32, _size: u32, _ecdsa_curve: u32, _dst: u32) -> HypervisorResult<u32> {
        Ok(0)
    }   

    fn cost_sign_with_schnorr(&mut self, _memory: &mut [u8], _src: u32, _size: u32, _algorithm: u32, _dst: u32) -> HypervisorResult<u32> {
        Ok(0)
    }

    fn cost_vetkd_derive_key(&mut self, _memory: &mut [u8], _src: u32, _size: u32, _vetkd_curve: u32, _dst: u32) -> HypervisorResult<u32> {
        Ok(0)
    }

    fn subnet_self_copy(&self, _memory: &mut [u8], _dst: u32, _offset: u32, _size: u32) -> HypervisorResult<()> {
        Ok(())
    }

    fn subnet_self_size(&self, _memory: &mut [u8]) -> HypervisorResult<u32> {
        Ok(0)
    }

}



#[derive(Copy, Clone)]
pub struct InternalAddress(usize);

impl InternalAddress {
    pub fn new(value: usize) -> Self {
        Self(value)
    }
    pub fn get(&self) -> usize {
        self.0
    }
    pub fn checked_add(self, rhs: Self) -> Result<InternalAddress, String> {
        self.get()
            .checked_add(rhs.get())
            .map(InternalAddress::new)
            .ok_or_else(|| "Invalid InternalAddress.".to_string())
    }
    pub fn checked_sub(self, rhs: Self) -> Result<InternalAddress, String> {
        self.get()
            .checked_sub(rhs.get())
            .map(InternalAddress::new)
            .ok_or_else(|| "Invalid InternalAddress.".to_string())
    }
}

