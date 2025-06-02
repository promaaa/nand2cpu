# promaa 02/06/2025 - Assembleur principal (lecture, parsing, encodage, écriture)

from parser import Parser
from encoder import Encoder

def assemble_file(input_file, output_file):
    # Parser le fichier
    parser = Parser()
    instructions, labels = parser.parse_file(input_file)
    
    # Encoder les instructions
    encoder = Encoder()
    machine_code = []
    
    # Convertir chaque instruction en code machine
    for instr in instructions:
        # Reconstruire la ligne de texte pour l'encodeur
        line = instr['opcode'] + ' ' + ' '.join(instr['operands'])
        encoded = encoder.encode(line)
        if encoded is not None:
            machine_code.append(encoded)
    
    # Écrire le code machine dans le fichier de sortie
    with open(output_file, 'wb') as f:
        for code in machine_code:
            msb = (code >> 8) & 0xFF
            lsb = code & 0xFF
            f.write(bytes([msb, lsb]))
    
    # Créer aussi une version hex pour debug
    with open(output_file + '.hex', 'w') as f:
        for code in machine_code:
            f.write(f"{code:04X}\n")
    
    print(f"Assemblage terminé: {len(machine_code)} instructions")
    print(f"Fichier binaire: {output_file}")
    print(f"Fichier hex: {output_file + '.hex'}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 3:
        print("Usage: python main.py input.asm output.bin")
        sys.exit(1)
    
    assemble_file(sys.argv[1], sys.argv[2])