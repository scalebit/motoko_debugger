//! Re-export the commonly used wasi-cap-std-sync crate here. This saves
//! consumers of this library from having to keep additional dependencies
//! in sync.

pub mod snapshots;

pub use wasi_common::sync::*;

#[doc(inline)]
pub use self::snapshots::preview_1::{
    add_wasi_snapshot_preview1_to_linker as add_to_linker,
    add_wasi_snapshot_preview1_to_linker_builder as add_to_linker_builder, AddWasi,
};

#[doc(inline)]
pub use self::snapshots::preview_0::{
    add_wasi_snapshot_preview0_to_linker as add_preview0_to_linker,
    add_wasi_snapshot_preview0_to_linker_builder as add_preview0_to_linker_builder,
    AddWasiPreview0,
};

#[doc(inline)]
pub use self::snapshots::motoko_syscall::{
    add_motoko_syscall_to_linker as add_motoko_syscall_to_linker,
    add_motoko_syscall_to_linker_builder as add_motoko_syscall_to_linker_builder,
    AddWasiMotokoSyscall,
};