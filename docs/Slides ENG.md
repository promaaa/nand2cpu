---

## name: title  
class: center, middle

# Phase 1

## De la porte NAND à l’ALU 16 bits

### Promaa · Série « Build‑Your‑CPU »

---


---
![[miniatue.png|500]]

## From Bits to Chips



---

  
## Episode Goal  🎯 
**Understand how a single NAND gate computes**
$7 + 8 = 15$

– From gate → full-adder → 8-bit ALU → 16-bit scale





---

### **NAND in Detail**


![[nand_truth.png]]
  

> **NAND = NOT AND**

---
## NAND in verilog
![[nand-verilog.png | 400]]

![[verilog-1.png|500]]
> $Y = \overline{A \cdot B}$


---

### **With NAND, we can build everything!**

- ![[meme-nand.png]]
    

---

## **The ALU**

  

![[alu-intro.png]]

  

_(Arithmetic Logic Unit)_

---

### **Step 1 : Half-Adder (HA)**

  

![[half-adder.png]]

  

>$S = A \oplus B$ ,   $C = A \cdot B$ 


---

### **Step 2 : Full Adder (FA)**

  

![[full-adder.png]]

  

Handles **$Cin$** and **$Cout$**

---

## **Step 3 : 8-bit Chain**

  

![[alu_8.webp]]

  

Carry propagates from bit 0 $\rightarrow$ 7

---

### **Step 4 : Adding Operation Selector**

  

![[operation-selector.png]]

NAND decoder → MUX (3-bit $opcode$)

---

### **Step 5 : Generating flags**

- **$Z$**: Zero (all bits are $0$)
    
- **$C$**: Carry-out
    
- **$V$**: Overflow ($C_{n-1} \oplus C_n$)
    
- **$N$**: Negative (most significant bit)
    

---

## **8-bit ALU ✅**

![[alu-8-bits.png|450]]
![[verilog-2.png|500]]

---

## **Scaling from 8 to 16 Bits**

1. Duplicate the bit-slice
    
2. Carry flows through 16 elements = latency $\times 2$
    ![[carry.png|700]]


---

## **Live Demo**

- $0b0111$ (7) $+ 0b1000$ (8) $\rightarrow 0b1111$ (15)
- Carry-out = 0 (no overflow)

![[waveform_demo.vcd]]

---
# Pipeline
![[pipeline.png|800]]

---
## Latency comparison

![[comparison-latency.png|750]]

---
## Assembler Overview

![[assembler.png|500]]

- **Parser**: tokenize & validate `ADD R1, R2, R3`  
- **Encoder**:  
  - `ADD → 0010`  
  - `R1,R2,R3 → 001 010 011`  
  - Pack as `0010 001 010 011 000`
*Full code → https://github.com/promaaa/edge-asic/assembler/*
---
## Encoder in Action

```python
opcode_map = {
    'MOV': '0001',
    'ADD': '0010',  # key operation
    'SUB': '0011',
    'AND': '0100',
    'OR':  '0101',
    'XOR': '0110'
}

def encode_instruction(mnemonic, regs):
    op    = opcode_map[mnemonic]
    rbits = [reg_map[r] for r in regs]
    word  = f"{op} {rbits[0]} {rbits[1]} {rbits[2]} 000"
    write_to_bin(word)

```
---
## Conclusion

|      🔧 ALU       |  🚀 Pipeline  | 🐍 Assembler |
| :---------------: | :-----------: | :----------: |
| NAND → 16-bit ALU | 4× throughput | Source → bin |

---
### Coming next - Edge ai deep dive

- Meet the CNN (Convolutional Neural Network)  
- Shrink an image-recognition network to run on STM32
- Balance latency ↔ speed ↔ energy  

![[stm32.png|350]]


---
## **Thank you!**
  

Code, schematics & testbenches on :

https://github.com/promaaa/edge-asic

👍 Like, 💬 comment & 🔔 subscribe for next month’s FB2C episode.

---

![[logo_promaa.png]]
