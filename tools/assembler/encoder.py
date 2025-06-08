# promaa 02/06/2025 - Assembly instruction encoder to machine code

class Encoder:
    def __init__(self):
        # Opcode definitions
        self.opcodes = {
            'ADD': 0b000,  # Addition
            'SUB': 0b001,  # Subtraction
            'AND': 0b010,  # Logical AND
            'OR':  0b011,  # Logical OR
            'XOR': 0b100,  # Exclusive OR
            'SHL': 0b101,  # Left shift
            'SHR': 0b110,  # Right shift
            'NOT': 0b111,  # Bitwise complement
        }
    
    def encode(self, instruction):
        parts = instruction.replace(',', ' ').split()
        if not parts:
            return None
            
        opcode = parts[0].upper()
        if opcode not in self.opcodes:
            return None
            
        op_code = self.opcodes[opcode]
        
        # Format for ADD, SUB, AND, OR, XOR
        if opcode in ['ADD', 'SUB', 'AND', 'OR', 'XOR']:
            if len(parts) != 4:
                return None
            rd = int(parts[1][1:])  # R0-R7
            rs1 = int(parts[2][1:])
            rs2 = int(parts[3][1:])
            return (op_code << 13) | (rd << 10) | (rs1 << 7) | (rs2 << 4)
            
        # Format for SHL, SHR, NOT
        elif opcode in ['SHL', 'SHR', 'NOT']:
            if len(parts) != 3:
                return None
            rd = int(parts[1][1:])
            rs = int(parts[2][1:])
            return (op_code << 13) | (rd << 10) | (rs << 7)
            
        return None

    def encode_file(self, input_file, output_file):
        with open(input_file, 'r') as f:
            lines = f.readlines()
            
        machine_code = []
        for line in lines:
            # Ignore comments
            if ';' in line:
                line = line.split(';')[0]
            line = line.strip()
            if not line:
                continue
                
            encoded = self.encode(line)
            if encoded is not None:
                machine_code.append(encoded)
                
        with open(output_file, 'wb') as f:
            for code in machine_code:
                # Write each instruction in big-endian
                msb = (code >> 8) & 0xFF
                lsb = code & 0xFF
                f.write(bytes([msb, lsb]))
                
        # Hex version for debugging
        with open(output_file + '.hex', 'w') as f:
            for code in machine_code:
                f.write(f"{code:04X}\n")