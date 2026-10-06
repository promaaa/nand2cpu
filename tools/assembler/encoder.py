# promaa 02/06/2025 - Assembly instruction encoder to machine code

class Encoder:
    def __init__(self):
        # Opcode and operands of each instruction: r = register, i = immediate, a = address or label
        self.instructions = {
            'ADD':  (0b0000, 'rrr'),  # Addition
            'SUB':  (0b0001, 'rrr'),  # Subtraction
            'AND':  (0b0010, 'rrr'),  # Logical AND
            'OR':   (0b0011, 'rrr'),  # Logical OR
            'XOR':  (0b0100, 'rrr'),  # Exclusive OR
            'SHL':  (0b0101, 'rr'),   # Left shift
            'SHR':  (0b0110, 'rr'),   # Right shift
            'NOT':  (0b0111, 'rr'),   # Bitwise complement
            'LDI':  (0b1000, 'ri'),   # Load a signed 9-bit immediate
            'LD':   (0b1001, 'rr'),   # Load from RAM
            'ST':   (0b1010, 'rr'),   # Store to RAM
            'OUT':  (0b1011, 'r'),    # Write the output register
            'BZ':   (0b1100, 'ra'),   # Branch if zero
            'BNZ':  (0b1101, 'ra'),   # Branch if not zero
            'JMP':  (0b1110, 'a'),    # Jump
            'HALT': (0b1111, ''),     # Stop
        }

    def encode(self, instruction, labels):
        parts = instruction.replace(',', ' ').split()
        name = parts[0].upper()
        if name not in self.instructions:
            raise ValueError(f"unknown instruction {parts[0]}")
        opcode, operands = self.instructions[name]
        if len(parts) - 1 != len(operands):
            raise ValueError(f"{name} takes {len(operands)} operands")

        # Registers fill bits 11-9, 8-6 and 5-3 in order
        word, shift = opcode << 12, 9
        for kind, token in zip(operands, parts[1:]):
            if kind == 'r':
                word |= self.register(token) << shift
                shift -= 3
            elif kind == 'i':
                word |= self.number(token, -256, 255) & 0x1FF
            else:
                address = labels[token] if token in labels else self.number(token, 0, 255)
                if address > 255:
                    raise ValueError(f"{token} is after the end of the 256-word ROM")
                word |= address
        return word

    @staticmethod
    def register(token):
        token = token.strip('[]')
        if token[:1].upper() != 'R' or not token[1:].isdigit() or int(token[1:]) > 7:
            raise ValueError(f"bad register {token}, expected R0 to R7")
        return int(token[1:])

    @staticmethod
    def number(token, low, high):
        try:
            value = int(token, 0)
        except ValueError:
            raise ValueError(f"unknown label or bad number {token}") from None
        if not low <= value <= high:
            raise ValueError(f"{token} is outside {low} to {high}")
        return value
