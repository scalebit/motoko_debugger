# 🛠️ Motoko Debugger

**Motoko Debugger** is a debugging tool specifically built for the [Motoko](https://github.com/dfinity/motoko) language. It helps developers debug Motoko smart contracts running inside Wasm-based canister containers on the Internet Computer (ICP). This project provides a developer-friendly interface for inspecting execution state, variables, breakpoints, and more—bridging the gap between Motoko and low-level WebAssembly debugging.

## ✨ Highlights

* 🔧 **Motoko-specific**: Built from the ground up for Motoko’s actor model and async runtime.
* 🐛 **Native Wasm debugging**: Supports DWARF debugging info for accurate source mapping.
* 💻 **Cross-platform support**: CLI debugger for Linux and macOS.
* 🧩 **VSCode integration**: One-click debugging from Visual Studio Code (planned).
* 🌐 **Web IDE support**: Planned integration with the Motoko online IDE.

## 🚀 Features

* Step-by-step execution (step in/step over/step out)
* Breakpoint setting and management
* Variable and memory inspection
* Call stack viewing
* Source-level mapping from Wasm with DWARF
* Async actor operation awareness (planned)

## 📦 Installation and Prerequisites

> ⚠️ Early-stage development. Currently supports Linux/macOS. Windows not supported due to Motoko compiler limitations.

* Motoko compiler with DWARF output support
* Rust + Cargo

### Build Instructions

```bash
# Clone the repo
git clone https://github.com/scalebit-labs/motoko-debugger.git
cd motoko-debugger

# Build the debugger core
cargo build --release
```

## 💡 Usage Example

```bash
./motoko-debugger target/canister.wasm
```

> Documentation and usage examples are coming soon in the [`docs/`](./docs) folder.


## 👨‍👩‍👧‍👦 Team: BitsLab

We are a security and infrastructure-focused Web3 team. Our previous work includes:

### 🔍 Vulnerability Scanners

* **[MoveScanner](https://2024.issta.org/details/issta-2024-papers/134)**: A high-performance Move smart contract analyzer (ISSTA 2024 paper).

  * Detected 97,169 issues across 37,302 contracts on Aptos & Sui.
* **[ZkScanner](https://www.scalebit.xyz/blog/post/Securing-the-circuit-with-zkscanner-part-1-Introduction.html)**: Static analyzer for Circom and Halo2 ZK circuits.

### 🧰 Developer Tools

* **[sui-move-analyzer](https://github.com/movebit/sui-move-analyzer)**: VSCode plugin for Sui Move.
* **[aptos-move-analyzer](https://github.com/movebit/aptos-move-analyzer)**: VSCode plugin for Aptos Move.
* **[Move Formatter](https://github.com/movebit/movefmt)**: Now part of the official `aptos-cli`.
* **[BitsLabIDE](https://https://ide.bitslab.xyz/)**: Browser-based Move IDE with Wasm-native compilation and deployment.

## 🔍 Why this matters

Motoko contracts are rapidly growing in the ICP ecosystem, with thousands of GitHub repositories and active developer communities on Discord and Twitter. However, a usable, Motoko-specific debugging tool is still missing. This project fills a crucial gap in the developer toolchain for ICP smart contracts.

## 🧠 Key Assumptions

* The Motoko compiler produces usable DWARF info.
* Developers have access to Linux/macOS development environments.

## 🙋 Get Involved

We welcome developers, contributors, and testers from the Motoko and broader ICP community.

* Star the repo ⭐
* File issues 🐞
* Submit PRs 🔧
* Join our discussions 💬

## 📬 Contact

* Website: [https://www.scalebit.xyz](https://www.scalebit.xyz)
* Twitter: [@scalebit\_xyz](https://twitter.com/scalebit_xyz)
* Blog: [https://www.scalebit.xyz/blog](https://www.scalebit.xyz/blog)

---

We’re building a critical piece of infrastructure for the future of Motoko and WebAssembly smart contracts. Your feedback and participation can shape its future.