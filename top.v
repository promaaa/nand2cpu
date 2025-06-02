// top.v — wrapper pour Pynq Z1 qui fait tourner l’ALU en continu
module top (
    input  wire       CLK_100MHZ,   // horloge 100 MHz de la carte
    input  wire       BTN0,         // bouton reset (actif bas)
    output wire       LED0          // LSB du résultat de l’ALU
);

  // ------------------------------------------------------------
  // 1) Diviseur d’horloge pour obtenir ≈1 Hz à partir de 100 MHz
  // ------------------------------------------------------------
  reg [26:0] counter = 0;
  reg        tick    = 0;
  always @(posedge CLK_100MHZ or negedge BTN0) begin
    if (!BTN0) begin
      counter <= 0;
      tick    <= 0;
    end else if (counter == 100_000_000-1) begin
      counter <= 0;
      tick    <= ~tick;
    end else begin
      counter <= counter + 1;
    end
  end

  // ------------------------------------------------------------
  // 2) Machine à états pour sélectionner trois cas d’addition
  // ------------------------------------------------------------
  reg [1:0] state = 0;
  always @(posedge tick or negedge BTN0) begin
    if (!BTN0)
      state <= 0;
    else
      state <= state + 1;
  end

  // ------------------------------------------------------------
  // 3) Choix des opérandes A et B selon l’état
  // ------------------------------------------------------------
  reg [7:0] A, B;
  always @(*) begin
    case (state)
      2'd0: begin A = 8'd3;  B = 8'd5;  end
      2'd1: begin A = 8'd7;  B = 8'd8;  end
      2'd2: begin A = 8'd15; B = 8'd1;  end
      default: begin A = 8'd0;  B = 8'd0; end
    endcase
  end

  // ------------------------------------------------------------
  // 4) Instanciation de l’ALU 8 bits (alu8.v)
  // ------------------------------------------------------------
  wire [7:0] Y;
  wire       Cout;
  alu8 u_alu (
    .A   (A),
    .B   (B),
    .Op  (3'b000),  // toujours ADD
    .Cin (1'b0),
    .Y   (Y),
    .Cout(Cout)
  );

  // ------------------------------------------------------------
  // 5) Exposer le bit de poids faible sur LED0
  // ------------------------------------------------------------
  assign LED0 = Y[0];

endmodule
