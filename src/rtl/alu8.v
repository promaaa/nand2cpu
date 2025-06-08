// promaa 15/05/2025 - 8-bit ALU (arithmetic and logic operations)

module alu8 (
  input  wire [7:0] A,     // First operand
  input  wire [7:0] B,     // Second operand
  input  wire [2:0] Op,    // Operation code
  input  wire       Cin,   // Carry in
  output reg  [7:0] Y,     // Result
  output reg        Cout   // Carry out
);

  reg [8:0] result;      // 9 bits to capture carry out
  
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
      3'b101: begin  // Left shift
        Y = A << 1;
        Cout = A[7];
      end
      3'b110: begin  // Right shift
        Y = A >> 1;
        Cout = A[0];
      end
      3'b111: begin  // NOT (bitwise complement)
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