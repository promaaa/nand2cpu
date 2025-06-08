# promaa 02/06/2025 - Assembly instruction parser (basic structure)

import re

class Parser:
    def __init__(self):
        self.labels = {}
        self.instructions = []
    
    def parse_file(self, filename):
        """Parse an assembly file and return instructions and labels"""
        instructions = []
        labels = {}
        
        try:
            with open(filename, 'r') as file:
                lines = file.readlines()
            
            for line_num, line in enumerate(lines, 1):
                # Clean the line
                clean_line = self._clean_line(line)
                if not clean_line:
                    continue
                
                # Detect labels
                if clean_line.endswith(':'):
                    label = clean_line[:-1].strip()
                    labels[label] = len(instructions)
                    continue
                
                # Parse the instruction
                instruction = self._parse_instruction(clean_line, line_num)
                if instruction:
                    instructions.append(instruction)
        
        except FileNotFoundError:
            print(f"Error: File {filename} not found")
            return [], {}
        
        return instructions, labels
    
    def _clean_line(self, line):
        """Clean a line: remove comments and spaces"""
        # Remove comments
        if ';' in line:
            line = line[:line.index(';')]
        
        # Remove leading/trailing spaces
        return line.strip()
    
    def _parse_instruction(self, line, line_num):
        """Parse an individual instruction"""
        # Separate opcode and operands
        parts = line.split()
        if not parts:
            return None
        
        opcode = parts[0].upper()
        operands = parts[1:] if len(parts) > 1 else []
        
        # Clean operands (remove commas)
        clean_operands = []
        for op in operands:
            clean_op = op.replace(',', '').strip()
            if clean_op:
                clean_operands.append(clean_op)
        
        return {
            'opcode': opcode,
            'operands': clean_operands,
            'line': line_num
        }