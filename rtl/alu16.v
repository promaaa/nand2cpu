// promaa 16/05/2025 - ALU 16 bits par chaînage de deux ALUs 8 bits

module alu16 (
  input  wire [15:0] A,     // Premier opérande
  input  wire [15:0] B,     // Second opérande
  input  wire [2:0]  Op,    // Code opération
  input  wire        Cin,   // Carry in
  output wire [15:0] Y,     // Résultat
  output wire        Cout   // Carry out
);

  // Séparation des opérandes en parties haute et basse
  wire [7:0] A_low  = A[7:0];
  wire [7:0] A_high = A[15:8];
  wire [7:0] B_low  = B[7:0];
  wire [7:0] B_high = B[15:8];
  
  // Résultats intermédiaires
  wire [7:0] Y_low, Y_high;
  wire       C_middle;      // Carry entre les deux ALUs
  
  // Gestion spéciale pour les décalages (connexion entre les ALUs)
  wire shift_bit_right = (Op == 3'b110) ? A_high[0] : 1'b0;  // Pour le décalage à droite, bit LSB de A_high
  wire shift_bit_left  = (Op == 3'b101) ? A_low[7]  : 1'b0;  // Pour le décalage à gauche, bit MSB de A_low
  
  // ALU partie basse (bits 0-7)
  alu8 alu_low (
    .A(A_low),
    .B(B_low),
    .Op(Op),
    .Cin(Cin),
    .Y(Y_low),
    .Cout(C_middle)
  );
  
  // ALU partie haute (bits 8-15)
  // Pour les opérations d'addition/soustraction, le carry de l'ALU low est utilisé
  // Pour le décalage à gauche, le MSB de l'ALU low devient le LSB de l'ALU high
  alu8 alu_high (
    .A(A_high),
    .B(B_high),
    .Op(Op),
    .Cin((Op == 3'b000 || Op == 3'b001) ? C_middle : 
         (Op == 3'b101) ? shift_bit_left : 
         (Op == 3'b110) ? 1'b0 : 1'b0),
    .Y(Y_high),
    .Cout(Cout)
  );
  
  // Concaténation des résultats
  assign Y = {Y_high, Y_low};
  
endmodule