# nand2cpu: From NAND to Neural Networks

<div align="center">

[![Stars](https://img.shields.io/github/stars/promaaa/nand2cpu?style=flat-square)](https://github.com/promaaa/nand2cpu/stargazers)
[![Issues](https://img.shields.io/github/issues/promaaa/nand2cpu?style=flat-square)](https://github.com/promaaa/nand2cpu/issues)
[![License](https://img.shields.io/github/license/promaaa/nand2cpu?style=flat-square)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/promaaa/nand2cpu?style=flat-square)](https://github.com/promaaa/nand2cpu/commits/main)

**Complete Edge AI accelerator: from silicon to quantized CNN**

*Building a complete Edge AI accelerator from the ground up - 6 months journey from logic gates to neural network inference*

[Documentation](docs/) • [Quick Start](#quick-start)

</div>

---

## Project Overview

This project documents the complete construction of an Edge AI accelerator, from logic gates to neural network inference. Inspired by the "Nand2Tetris" methodology, it covers the entire hardware/software stack necessary for efficiently deploying AI models on embedded devices.

**Target Goal:** Demonstrate int8 CNN inference on FPGA and MCU with custom hardware optimizations.

### Key Features

- **Bottom-up approach**: Each component built from NAND primitives
- **Complete documentation**: Detailed planning, test scripts, and implementation guide
- **Edge AI focus**: Optimizations specific for embedded inference
- **Open Source**: Code, schematics and documentation freely available

---

## Project Architecture

```
nand2cpu/
├── rtl/                      # Verilog RTL modules
│   ├── nand_gate.v           # Universal NAND gate
│   ├── and_gate.v            # AND gate (2× NAND)
│   ├── or_gate.v             # OR gate (3× NAND)
│   ├── alu8.v                # 8-bit ALU (7 operations)
│   └── alu16.v               # 16-bit ALU (chained)
├── assembler/                # Python assembler
│   ├── parser.py             # Syntax analysis
│   ├── encoder.py            # Machine code generation
│   ├── main.py               # User interface
│   └── test.asm              # Example program
├── tests/                    # Testbenches and validation
│   ├── tb_nand_gate.v        # Exhaustive NAND test
│   ├── tb_alu16.v            # ALU test with carry
│   └── add7_plus_8.v         # Specific addition test
├── docs/                     # Complete documentation
├── top.v                     # FPGA top-level module
└── top.xdc                   # Timing constraints
```

---

## RTL Modules

### Digital Logic Fundamentals

| Module | Description | NAND Gates | Functionality |
|--------|-------------|------------|---------------|
| `nand_gate.v` | Parametric NAND gate | 1 | Universal primitive |
| `and_gate.v` | 4-bit AND gate | 2 | A & B = ~(~(A & B)) |
| `or_gate.v` | OR gate | 3 | A \| B = ~(~A & ~B) |

### Arithmetic Logic Unit

**8-bit ALU (`alu8.v`)**
- **7 operations**: ADD, SUB, AND, OR, XOR, SHL, SHR, NOT
- **Flags**: Zero, Carry, Overflow
- **Latency**: 1 cycle (combinatorial)

**16-bit ALU (`alu16.v`)**
- **Architecture**: Chaining of 2× 8-bit ALUs
- **Carry management**: Automatic propagation
- **Special operations**: Inter-ALU shifts

### System Module (`top.v`)

- **Clock divider**: 100 MHz → 1 Hz
- **State machine**: Demonstration of 3 additions
- **FPGA interface**: Compatible with Pynq-Z1/Z2

---

## Python Assembler

The assembler converts human-readable assembly code into 16-bit machine instructions.

### Software Architecture

```python
# Assembler pipeline
Source ASM → Parser → Encoder → 16-bit Binary
```

**Components:**
- **`parser.py`**: Tokenization and syntax validation
- **`encoder.py`**: Opcode mapping + register encoding
- **`main.py`**: CLI interface

### Instruction Format

```assembly
# Supported syntax
ADD R0, R1, R2  ; R0 = R1 + R2 (addition)
SUB R3, R4, R5  ; R3 = R4 - R5 (subtraction)
AND R6, R7, R0  ; R6 = R7 & R0 (logical AND)
SHL R1, R2      ; R1 = R2 << 1 (left shift)
NOT R3, R4      ; R3 = ~R4 (inversion)
```

### Binary Format (16 bits)

```
[15:12] [11:9] [8:6] [5:3] [2:0]
Opcode   Rd    Rs1   Rs2  Flags
```

### Usage

```bash
cd assembler/
python main.py test.asm test.bin
hexdump -C test.bin  # Binary verification
```

---

## Testing and Validation

### Test Structure

```bash
tests/
├── Unit tests (logic gates)
├── Integration tests (ALU)
└── System tests (top module)
```

### Test Commands

```bash
# NAND gate test (complete truth table)
iverilog -o tests/results/tb_nand_gate rtl/nand_gate.v tests/tb_nand_gate.v
vvp tests/results/tb_nand_gate

# 8-bit ALU test - specific case 7+8=15
iverilog -o tests/results/add7_plus_8 rtl/alu8.v tests/add7_plus_8.v
vvp tests/results/add7_plus_8

# 16-bit ALU test with carry propagation
iverilog -o tests/results/tb_alu16 rtl/alu16.v rtl/alu8.v tests/tb_alu16.v
vvp tests/results/tb_alu16
```

### Functional Coverage

| Testbench | Coverage | Validation |
|-----------|----------|------------|
| `tb_nand_gate.v` | 100% combinations | ✅ Truth table |
| `tb_and_gate.v` | 16 4-bit vectors | ✅ Exhaustive |
| `add7_plus_8.v` | Critical case | ✅ Manual calculation |
| `tb_alu16.v` | 7 opcodes × carry | ✅ Chaining |

---

## Quick Start

### Installation

```bash
# System prerequisites (Ubuntu/Debian)
sudo apt update
sudo apt install iverilog python3 python3-pip git

# Clone and setup
git clone https://github.com/promaaa/nand2cpu.git
cd nand2cpu
```

### Quick Tests

```bash
# 1. Logic gates test
iverilog -o test_gates rtl/nand_gate.v rtl/and_gate.v tests/tb_and_gate.v
vvp test_gates

# 2. ALU test with 7+8 addition
iverilog -o test_alu rtl/alu8.v tests/add7_plus_8.v
vvp test_alu

# 3. Program assembly
cd assembler/
python main.py test.asm test.bin
echo "Generated binary:"
hexdump -C test.bin
```

### FPGA Simulation 

```bash
# Vivado bitstream generation
vivado -mode batch -source scripts/build_fpga.tcl
```

---

## Learning Resources

The complete development process of this project has been documented and is available for educational purposes.

**📺 Documentation:** [Link - Coming Soon]

---

## Contributing

This educational project welcomes:

- **Bug reports**: Failing tests, incomplete documentation
- **Suggestions**: RTL optimizations, new test cases
- **Documentation**: README improvements, code comments
- **Pull requests**: Fixes and enhancements

### Guidelines

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit with descriptive messages
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

Distributed under the **MIT** License.
---

## Acknowledgments

- **Nand2Tetris**: Methodology and educational inspiration
- **MIT 6.004**: Microarchitecture and pipeline concepts
- **OpenLane**: Open-source ASIC design flow
- **TinyML**: Embedded Edge AI community

---

<div align="center">

**If this project helps you, please consider giving it a star!**

[Contact](mailto:promaadev@proton.me) 

*Personal training project in Edge AI / Hardware*

</div>

