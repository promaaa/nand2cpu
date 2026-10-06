// promaa 06/10/2026 - Computer: the CPU core with a 256-word program ROM and a 256-word RAM
// The two memories are behavioural arrays, like the built-in ROM and RAM chips of Nand2Tetris.

module computer #(parameter PROGRAM = "") (
  input  wire        clk,
  input  wire        reset,
  input  wire        en,
  output wire [15:0] out,
  output wire        halted
);

  reg  [15:0] rom [0:255];
  reg  [15:0] ram [0:255];
  wire [7:0]  pc, ram_addr;
  wire [15:0] ram_wdata;
  wire        ram_we;
  wire [15:0] instr     = rom[pc];
  wire [15:0] ram_rdata = ram[ram_addr];

  initial if (PROGRAM != "") $readmemh(PROGRAM, rom);
  always @(posedge clk) if (ram_we) ram[ram_addr] <= ram_wdata;

  cpu core (
    .clk(clk), .reset(reset), .en(en),
    .pc(pc), .instr(instr),
    .ram_addr(ram_addr), .ram_wdata(ram_wdata), .ram_we(ram_we), .ram_rdata(ram_rdata),
    .out(out), .halted(halted)
  );

endmodule
