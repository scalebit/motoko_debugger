# Rust Sourced Wasmi Benchmarks

This repository contains several benchmark test cases found in the `cases` directory
which are supposed to be used to benchmark the Wasmi WebAssembly interpreter.

Each benchmark test case can be compiled to WebAssembly, more precisely the `wasm32-unknown-unknown`
target via the `build_benches` workspace binary. The compiled WebAssembly binaries are stored
in the respective directory of each test case as `out.wasm`.

Wasmi uses these benchmarks by including them and their compiled artifacts as a Git submodule.

## Building

Build with

```
cargo run --package build_benches
```

This builds the benchmark `.wasm` files for all the Rust based benchmarks
such as `tiny_keccak`, `reverse_complement` and `regex_redux` with proper
optimizations and stores the results in their respective directories.

## Usage

Use this script whenever a benchmark has changed or when a new Rust, LLVM or `wasm-opt`
version has been released.

## License

Licensed under either of

  * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or <http://www.apache.org/licenses/LICENSE-2.0>)
  * MIT license ([LICENSE-MIT](LICENSE-MIT) or <http://opensource.org/licenses/MIT>)

at your option.
