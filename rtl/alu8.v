// promaa 15/05/2025 - ALU 8 bits (opérations arithmétiques et logiques)

module alu8 (
  input  wire [7:0] A,     // Premier opérande
  input  wire [7:0] B,     // Second opérande
  input  wire [2:0] Op,    // Code opération
  input  wire       Cin,   // Carry in
  output reg  [7:0] Y,     // Résultat
  output reg        Cout   // Carry out
);

  // Variables temporaires
  reg [8:0] result;      // 9 bits pour capturer le carry out
  
  // Opérations ALU
  always @(*) begin
    case (Op)
      3'b000: begin  // Addition
        result = A + B + Cin;
        Y = result[7:0];
        Cout = result[8];
      end
      3'b001: begin  // Soustraction
        result = A - B - Cin;
        Y = result[7:0];
        Cout = result[8];
      end
      3'b010: begin  // AND logique
        Y = A & B;
        Cout = 0;
      end
      3'b011: begin  // OR logique
        Y = A | B;
        Cout = 0;
      end
      3'b100: begin  // XOR logique
        Y = A ^ B;
        Cout = 0;
      end
      3'b101: begin  // Décalage à gauche
        Y = A << 1;
        Cout = A[7];
      end
      3'b110: begin  // Décalage à droite
        Y = A >> 1;
        Cout = A[0];
      end
      3'b111: begin  // NOT (complément à 1)
        Y = ~A;
        Cout = 0;
      end
      default: begin
        Y = A;
        Cout = 0;
      end
    endcase
  end

endmodule