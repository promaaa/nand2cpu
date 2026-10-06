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
        opcode = parts[0].upper()
        if opcode not in self.opcodes:
            raise ValueError(f"unknown instruction {parts[0]}")

        # ADD, SUB, AND, OR, XOR take Rd, Rs1, Rs2. SHL, SHR, NOT take Rd, Rs.
        count = 2 if opcode in ('SHL', 'SHR', 'NOT') else 3
        if len(parts) - 1 != count:
            raise ValueError(f"{opcode} takes {count} registers")
        regs = [self.register(p) for p in parts[1:]] + [0]
        return (self.opcodes[opcode] << 13) | (regs[0] << 10) | (regs[1] << 7) | (regs[2] << 4)

    @staticmethod
    def register(token):
        if token[:1].upper() != 'R' or not token[1:].isdigit() or int(token[1:]) > 7:
            raise ValueError(f"bad register {token}, expected R0 to R7")
        return int(token[1:])
