<div align="center">

# nand2cpu

**A 16-bit ALU wired from one kind of gate: 830 two-input NANDs, in Verilog.<br/>The code for the first episode of the From Bits to Chips video series.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![Verilog](https://img.shields.io/badge/Verilog-Icarus%20Verilog-6e4a7e?style=flat-square)](#quick-start)
[![Python](https://img.shields.io/badge/Python-3-3776ab?style=flat-square&logo=python&logoColor=white)](#python-assembler)
[![YouTube](https://img.shields.io/badge/YouTube-Building%20a%20CPU%20Core-ff0000?style=flat-square&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=wIBkvQ6MfKQ)

<a href="https://www.youtube.com/watch?v=wIBkvQ6MfKQ"><img src="docs/Images/youtube_thumbnail.png" alt="From Bits to Chips: Building a CPU Core, video thumbnail" width="100%"/></a>

<sub>Click on the image to watch the episode on YouTube</sub>

</div>

## Highlights

- **One gate.** [`nand_gate.v`](src/rtl/nand_gate.v) holds the only logic expression in the design, `y = ~(a & b)`. Every other module connects NAND instances. After flattening, Yosys finds nothing but NAND gates in the 16-bit ALU.
- **Eight operations.** ADD, SUB, AND, OR, XOR, SHL, SHR and NOT, with the carry, borrow or shifted bit passed between the two bytes.
- **Tested on every input.** `tb_alu8` compares all 1,048,576 combinations of A, B, Op and Cin with a behavioural model. `tb_alu16` checks 1,296 byte-boundary cases and 100,000 random ones.
- **The video demo.** `make sim-add7_plus_8` prints the `PASS : Y=15, Cout=0` shown in the episode.

## How it works

1. One NAND with its inputs tied is a NOT. Two NANDs make an AND, three an OR, four an XOR or a 2:1 multiplexer.
2. An XOR and an AND make a half adder. Two half adders and an OR make a full adder.
3. Eight full adders in a chain make the 8-bit adder. For SUB, `Op[0]` inverts B and the carry with XOR gates, because A − B = A + ~B + 1.
4. A tree of six 2:1 multiplexers selects one result with `Op[0]`, then `Op[1]`, then `Op[2]`.
5. Two 8-bit ALUs and three multiplexers make the 16-bit ALU. The carry goes from the low byte to the high byte, and the other way for SHR.

![The 8-bit ALU: B and Cin go through XOR gates controlled by Op[0] into a chain of eight full adders, then a second XOR gives the borrow. AND, OR, XOR and NOT blocks and the two shift wirings feed a tree of six 2:1 multiplexers driven by Op[0], Op[1] and Op[2], which outputs Cout and Y](docs/Images/alu8.svg)

## Gate count and delay

| Block | Built from | NAND gates | Longest path (NAND levels) |
|---|---|--:|--:|
| NOT | one NAND, inputs tied | 1 | 1 |
| AND | NAND, then NOT | 2 | 2 |
| OR | NOT a, NOT b, then NAND | 3 | 2 |
| XOR | four NANDs | 4 | 3 |
| 2:1 multiplexer | NOT and three NANDs | 4 | 3 |
| Half adder | XOR and AND | 6 | 3 |
| Full adder | two half adders and OR | 15 | 7 |
| **8-bit ALU** | adder, logic, six multiplexers | **408** | **45** |
| **16-bit ALU** | two 8-bit ALUs, three multiplexers | **830** | **93** |

The path doubles from 8 to 16 bits because the carry ripples through every full adder. The video uses this delay to introduce carry look-ahead and pipelining. The full adder follows the construction in the video, so it uses 15 NAND gates where a hand-optimised one needs 9.

<details>
<summary><b>Measure it yourself</b> with Yosys</summary>

```bash
yosys -p "read_verilog src/rtl/*.v; hierarchy -top alu16; proc; flatten; techmap; stat; ltp -noff"
```

Yosys maps each NAND to one `$_AND_` and one `$_NOT_` cell. These are the only logic cells in the report, and the `$scopeinfo` cells only record the module hierarchy. The number of `$_AND_` cells is the NAND count. Divide the longest-path length by two to get NAND levels.

</details>

## Operations

| `Op` | Name | `Y` | `Cout` |
|:-:|---|---|---|
| `000` | ADD | A + B + Cin | carry |
| `001` | SUB | A − B − Cin | borrow |
| `010` | AND | A & B | 0 |
| `011` | OR | A \| B | 0 |
| `100` | XOR | A ^ B | 0 |
| `101` | SHL | A << 1, Cin enters bit 0 | old top bit |
| `110` | SHR | A >> 1, Cin enters the top bit | old bit 0 |
| `111` | NOT | ~A | 0 |

[`alu8`](src/rtl/alu8.v) and [`alu16`](src/rtl/alu16.v) have the same ports: `A`, `B`, `Op`, `Cin`, `Y`, `Cout`.

## Quick start

Requirements: [Icarus Verilog](https://steveicarus.github.io/iverilog/), Python 3 and make.

```bash
sudo apt install iverilog python3 make    # Debian, Ubuntu
sudo pacman -S iverilog python make       # Arch
brew install icarus-verilog python3       # macOS
```

```bash
git clone https://github.com/promaaa/nand2cpu.git && cd nand2cpu
make test
```

`make test` runs every testbench, checks the assembler output and compiles the FPGA top level. It takes about 30 seconds, mostly for the exhaustive 8-bit test. The main lines of the output are:

```
PASS : all 1048576 combinations of A, B, Op and Cin
PASS : 101296 boundary and random cases
PASS : Y=15, Cout=0
All tests passed.
```

Run one testbench with `make sim-<name>`, for example `make sim-add7_plus_8`. The gate testbenches and the demo write waveforms to `build/sim/*.vcd`, which [GTKWave](https://gtkwave.sourceforge.net/) opens.

## Python assembler

The assembler from the video turns assembly into 16-bit words. The opcode is the ALU `Op`, and registers are R0 to R7. Nothing in this repository runs these words yet: a CPU also needs a register file and an instruction decoder.

```
 15 13   12 10   9   7   6   4   3    0
[ Op  ] [ Rd  ] [ Rs1 ] [ Rs2 ] [ 0000 ]
```

```asm
start:
    ADD R0, R1, R2  ; R0 = R1 + R2    -> 00A0
    SUB R3, R4, R5  ; R3 = R4 - R5    -> 2E50
    AND R6, R7, R0  ; R6 = R7 & R0    -> 5B80
loop:
    SHL R1, R2      ; R1 = R2 << 1    -> A500
    NOT R3, R4      ; R3 = ~R4        -> EE00
```

`make assembler` assembles this file, [`tools/assembler/test.asm`](tools/assembler/test.asm), into `test.bin` and `test.bin.hex`. An unknown instruction or a register outside R0 to R7 stops the assembler with the file and line number.

## FPGA

[`src/fpga/top.v`](src/fpga/top.v) shows one addition per second on the four LEDs of a PYNQ-Z1 board (Zynq XC7Z020): 3 + 5 = 8, then 7 + 8 = 15 with all four LEDs on, then 15 + 1 = 16 with the LEDs off. `make fpga` builds the bitstream with Vivado. This build has not been tested on a board yet.

## Repository

| Path | Contents |
|---|---|
| [`src/rtl/`](src/rtl/) | The NAND gate and every module wired from it, up to [`alu8.v`](src/rtl/alu8.v) and [`alu16.v`](src/rtl/alu16.v) |
| [`src/testbenches/`](src/testbenches/) | Self-checking testbenches, with the 7 + 8 = 15 demo in [`add7_plus_8.v`](src/testbenches/add7_plus_8.v) |
| [`src/fpga/`](src/fpga/) | PYNQ-Z1 top level and pin constraints |
| [`tools/assembler/`](tools/assembler/) | Python assembler: parser, encoder, example program |
| [`tools/scripts/`](tools/scripts/) | Vivado build script |
| [`docs/`](docs/) | [Video script](docs/Script%20ENG.md), [slides](docs/Slides%20ENG.md) and images |

## License

MIT, see [LICENSE](LICENSE). The bottom-up approach follows [Nand2Tetris](https://www.nand2tetris.org/) and MIT 6.004.
