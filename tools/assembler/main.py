# promaa 02/06/2025 - Main assembler (reading, parsing, encoding, writing)

from parser import Parser
from encoder import Encoder

def assemble_file(input_file, output_file):
    # Parse the file
    parser = Parser()
    instructions, labels = parser.parse_file(input_file)
    
    # Encode the instructions
    encoder = Encoder()
    machine_code = []
    
    # Convert each instruction to machine code
    for instr in instructions:
        # Reconstruct text line for encoder
        line = instr['opcode'] + ' ' + ' '.join(instr['operands'])
        encoded = encoder.encode(line)
        if encoded is not None:
            machine_code.append(encoded)
    
    # Write machine code to output file
    with open(output_file, 'wb') as f:
        for code in machine_code:
            msb = (code >> 8) & 0xFF
            lsb = code & 0xFF
            f.write(bytes([msb, lsb]))
    
    # Also create hex version for debugging
    with open(output_file + '.hex', 'w') as f:
        for code in machine_code:
            f.write(f"{code:04X}\n")
    
    print(f"Assembly completed: {len(machine_code)} instructions")
    print(f"Binary file: {output_file}")
    print(f"Hex file: {output_file + '.hex'}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 3:
        print("Usage: python main.py input.asm output.bin")
        sys.exit(1)
    
    assemble_file(sys.argv[1], sys.argv[2])