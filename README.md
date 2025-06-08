# nand2cpu: From NAND to Neural Networks

<div align="center">

[![Stars](https://img.shields.io/github/stars/promaaa/nand2cpu?style=flat-square)](https://github.com/promaaa/nand2cpu/stargazers)
[![Issues](https://img.shields.io/github/issues/promaaa/nand2cpu?style=flat-square)](https://github.com/promaaa/nand2cpu/issues)
[![License](https://img.shields.io/github/license/promaaa/nand2cpu?style=flat-square)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/promaaa/nand2cpu?style=flat-square)](https://github.com/promaaa/nand2cpu/commits/main)

**Complete Edge AI accelerator: from silicon to quantized CNN** 🚀

*Building a complete Edge AI accelerator from the ground up - 6 months journey from logic gates to neural network inference*

[Quick Start](#quick-start) • [Testing](#testing) • [Contributing](#contributing)

</div>

---

## Overview 📋

This project documents the complete construction of an Edge AI accelerator, from logic gates to neural network inference. Inspired by the "Nand2Tetris" methodology, it covers the entire hardware/software stack for efficient AI deployment on embedded devices.

**Goal:** Demonstrate int8 CNN inference on FPGA and MCU with custom hardware optimizations.

### Key Features

- **Bottom-up approach**: Each component built from NAND primitives
- **Complete toolchain**: RTL modules, assembler, test suite, and build automation
- **Edge AI focus**: Optimizations for embedded inference
- **Open Source**: All code, schematics and documentation freely available

---

## Project Structure 📁

```
nand2cpu/
├── src/                      # Source code
│   ├── rtl/                  # Verilog RTL modules
│   │   ├── nand_gate.v       # Universal NAND gate
│   │   ├── and_gate.v        # AND gate (2× NAND)
│   │   ├── or_gate.v         # OR gate (3× NAND)
│   │   ├── alu8.v            # 8-bit ALU (7 operations)
│   │   └── alu16.v           # 16-bit ALU (chained)
│   ├── fpga/                 # FPGA top-level files
│   │   ├── top.v             # Main FPGA module
│   │   └── top.xdc           # Timing constraints
│   └── testbenches/          # Simulation testbenches
│       ├── tb_nand_gate.v    # NAND gate test
│       ├── tb_alu16.v        # 16-bit ALU test
│       └── add7_plus_8.v     # Specific test case
├── tools/                    # Development tools
│   ├── assembler/            # Python assembler
│   │   ├── main.py           # Main interface
│   │   ├── parser.py         # Instruction parser
│   │   └── encoder.py        # Machine code generator
│   └── scripts/              # Build automation
│       ├── build_sim.sh      # Simulation build
│       └── build_fpga.tcl    # FPGA build
├── build/                    # Build outputs (git-ignored)
├── examples/                 # Example programs
└── Makefile                  # Build automation
```

---

## Quick Start ⚡

### Prerequisites

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install iverilog python3 make

# macOS
brew install icarus-verilog python3
```

### Basic Usage

```bash
# Clone repository
git clone https://github.com/promaaa/nand2cpu.git
cd nand2cpu

# Run quick tests
make quick-test

# Test specific modules
make sim-tb_nand_gate      # Test NAND gate
make sim-add7_plus_8       # Test ALU with 7+8=15

# Test assembler
make assembler
hexdump -C tools/assembler/test.bin
```

---

## RTL Modules

### Logic Gates

| Module | Description | NAND Gates | Function |
|--------|-------------|------------|----------|
| `nand_gate.v` | Universal NAND gate | 1 | Basic primitive |
| `and_gate.v` | 4-bit AND gate | 2 | A & B |
| `or_gate.v` | OR gate | 3 | A \| B |

### Arithmetic Logic Unit

**8-bit ALU (`alu8.v`)**
- **Operations**: ADD, SUB, AND, OR, XOR, SHL, SHR, NOT
- **Flags**: Zero, Carry, Overflow
- **Latency**: 1 cycle (combinatorial)

**16-bit ALU (`alu16.v`)**
- **Architecture**: Chained 2× 8-bit ALUs
- **Carry management**: Automatic propagation

---

## Assembler

The Python assembler converts assembly code into 16-bit machine instructions.

### Instruction Format

```assembly
# 3-operand instructions
ADD R0, R1, R2  ; R0 = R1 + R2
SUB R3, R4, R5  ; R3 = R4 - R5
AND R6, R7, R0  ; R6 = R7 & R0

# 2-operand instructions  
SHL R1, R2      ; R1 = R2 << 1
NOT R3, R4      ; R3 = ~R4
```

### Binary Format (16 bits)

```
[15:13] [12:10] [9:7] [6:4] [3:0]
Opcode    Rd    Rs1   Rs2  Unused
```

---

## Testing

### Available Commands

```bash
# Quick validation
make quick-test           # NAND + ALU tests
make validate            # Structure validation

# Comprehensive testing
make test-gates          # All logic gate tests
make test-alu            # All ALU tests  
make test-all            # Complete test suite

# Individual tests
make sim-tb_nand_gate    # NAND gate test
make sim-tb_alu16        # 16-bit ALU test
make sim-add7_plus_8     # Addition test case

# Tools
make assembler           # Test assembler
make clean              # Clean build files
```

### Test Coverage

| Testbench | Coverage | Status |
|-----------|----------|--------|
| `tb_nand_gate.v` | All truth table | ✅ |
| `tb_and_gate.v` | 16 4-bit vectors | ✅ |
| `add7_plus_8.v` | Critical case | ✅ |
| `tb_alu16.v` | 7 opcodes + carry | ✅ |

---

## FPGA Deployment

```bash
# Generate bitstream (requires Vivado)
make fpga

# Manual build
vivado -mode batch -source tools/scripts/build_fpga.tcl
```

**Target**: Pynq-Z1/Z2 (xc7z020clg400-1)

---

## Contributing

Contributions welcome! Areas of interest:

- **Bug reports**: Test failures, documentation issues
- **Optimizations**: RTL improvements, new test cases
- **Features**: Additional instructions, hardware modules

### Process

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

## License

Distributed under the **MIT** License. See `LICENSE` for more information.

---

## Acknowledgments 🙏

- **Nand2Tetris**: Educational methodology and inspiration
- **MIT 6.004**: Computer architecture concepts
- **TinyML Community**: Embedded AI techniques

---

<div align="center">

**If this project helps you, please ⭐ star it!**

[Contact](mailto:promaadev@proton.me) • [Documentation](docs/)

*Educational project for Hardware/Software co-design*

</div>

