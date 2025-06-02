# Building a CPU from NAND

## Project Introduction

Why does your phone crunch numbers in binary without breaking a sweat?  
I’m **Promaa**: welcome to the From Bits to Chip series, six months, six videos, and by the end, a mini-processor capable of Edge AI.  
All code and schematics will be available freely on GitHub.  
Today’s first step: let’s pop the hood on microarchitecture.

## Episode Goal

CPUs are everywhere—calculators, phones, computers—anything that does even a little bit of computation has one.

> Today’s first challenge: understand how a **single** logic gate, the NAND, ends up calculating 7 + 8 = 15.

### Refresher on Logic Gates and NAND in Detail

A logic gate is a black box that takes 0s and 1s as inputs and returns a 0 or 1. NAND stands for _NOT AND_.  
It is defined by the following truth table—a truth table shows how a logic gate behaves depending on its input values.  

#### Verilog
To run my simulations, I will be using verilog which is a common standard for hardware description. It allows engineers to model digital circuits at different levels of abstraction and simulate their behavior before synthesizing them onto physical hardware like FPGAs.

#### One to rule them all
One single gate, the NAND, is enough to build everything. By connecting its two inputs together, you get a NOT gate; two well-placed NANDs give you AND; three make OR; four produce XOR.

> With **only** NAND gates, we already have all the building blocks.

### 8-Bit ALU Implementation and Scaling to 16 Bits

> Stack those building blocks and you get the **ALU**—the Arithmetic and Logic Unit, the heart of every CPU. Today, we’ll build an **8-bit** one… then double it to 16.

It essentially is a circuit capable of performing both arithmetic (like addition and subtraction) and logical operations on binary-coded data.

To construct this ALU, we proceed step by step:

1. **First**, we need to create a **Half-Adder**.
    
    - A half-adder computes the sum of two bits, A and B, without considering any carry-in.
        
    - It’s implemented using a XOR (for the sum) and an AND (for the carry), both of which can be built from NAND gates.
        
    
2. **Next**, we move on to building a **Full-Adder**.
    
    - The full-adder takes A, B, and a carry-in (Cin) to produce a sum bit (S) and a carry-out (Cout).
        
    - To build it, we combine two half-adders and an OR gate—again, all made from NAND gates—into a single circuit.
        
    
3. **After that**, we extend this to multiple bits by **chaining for 8 bits**.
    
    - By repeating the full-adder circuit for each bit and linking the Cout of one to the Cin of the next, we create an 8-bit adder.
        
    - Carry propagation, however, introduces latency. We'll break this bottleneck soon with a look-ahead carry circuit.
        
    
4. **Then**, we add **operation selection**.
    
    - A small decoder interprets an operation code (opcode) and uses NAND-based multiplexers to activate the desired function—addition, subtraction (A plus the complement of B with Cin = 1), or basic logical operations.
        
    - Each bit-slice, whether it’s performing arithmetic or logic, routes its result through a multiplexer that selects the final output sent to the ALU’s output bus.
        
    
5. **Finally**, we add **flag generation**.
	- In the output stage, we compute flags as shown on this slide. These are single‐bit indicators that reflect specific conditions after an arithmetic or logical operation.

Our 8 bit ALU is now finished and after implementing it in verilog we can see that the output returned by the addition of 7 and 8 is in fact 15.

Now let’s move from the 8-bit ALU to 16 bit

### Scaling from 8 to 16 Bits

1. **Duplicate the Bit-Slice**: scale from 8 to 16 lines, same schematic.
    
2. **Problem**: the carry now propagates across 16 elements → latency × 2.

**Visual**: two vertical progress bars: 8 blocks (0.8 ns) / 16 blocks (1.6 ns).

### Tests and Demonstration

If everything’s still making sense, a thumbs-up really helps me keep going.  
Now that we’ve covered the theory, it’s time to get our hands dirty.

- **Split screen**: on the left, Verilator waveforms; on the right, a real calculator.
    
- **Voiceover**: “Live test. Input: 0b0111 (7) + 0b1000 (8). ALU Output: 0b1111 (15). The calculator confirms.”
    
- **Zoom in** on the bits changing in the simulator.

As the saying goes, so far so good. But in the world of processors, a 16-bit ALU is pipelined. What does that mean? Let's find out
## Pipelining 
Pipelining is a method commonly used to speed up our CPU. But what does it consist in ? 

Pipelining is like making breakfast by toasting bread, frying eggs, and cooking bacon all at once instead of one after the other. In a pipelined CPU, each stage works on a different instruction in parallel—just as you’d heat the pan, toast the bread, and fry the bacon simultaneously. 



This turns 16 sequential stages of 0.1 ns each  into a 4-stage pipeline of 0.4 ns per stage as shown in the benchmark.

## Python Assembler Overview
> Here we are — now we're capable of thinking a little bit… or to be more precise, to handle 16 bits. To feed our CPU, I built a simple Python assembler that turns human-readable instructions into 16-bit machine code.

The assembler can be separated in two main parts : 
1. First you have the **Parser** which Reads each assembly line (e.g. `ADD R1, R2, R3`), tokenizes the mnemonic and operands, and validates syntax.  
2. Second is the **Encoder** that Maps the mnemonic to its 4-bit opcode (e.g. `ADD → 0010`), encodes register fields into their bit positions, and packs everything into a 16-bit word.

Here is a quick look at the python encoder's code.


**Live demo** (split-screen):
## Conclusion

> “That wraps up Part 1! Today we:
> 
> - Built and tested an 8-bit ALU (scaled it to 16 bits),
>     
> - Explored the benefits of pipelining,
>     
> - And introduced our Python-based assembler.”
>     

## **Coming in Month 2**:

>In the next video, we will bridge low-level hardware design with live Edge AI by discovering neural networks running on a tiny board: we will compress a model, load it onto a microcontroller, watch it make real-time predictions, and explore how fast, accurate, and energy-efficient it really is.


## **Lower-third overlay**: GitHub logo + repo URL + “Subscribe for more”
If you found this content helpful and want to support me, please **like**, **comment**, and **subscribe** so you don’t miss next month’s deep dive into Edge AI on real hardware!











