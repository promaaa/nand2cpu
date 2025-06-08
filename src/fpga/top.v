// promaa 08/06/2025 - Top module for FPGA implementation

module top(
    input  wire CLK100MHZ,
    output wire LED0
);
    // clock divider: 100 MHz -> ~1 Hz (toggle every 50 M cycles)
    reg [26:0] div_cnt = 0;
    reg        slow_clk = 0;
    always @(posedge CLK100MHZ) begin
        div_cnt <= div_cnt + 1;
        if (div_cnt == 27'd10) begin
            div_cnt <= 0;
            slow_clk <= ~slow_clk;
        end
    end

    // test vector sequencer
    reg [1:0]  idx = 0;
    reg [7:0]  a = 0, b = 0;
    wire [7:0] y;
    wire       carry;
    alu8 alu_inst(.a(a), .b(b), .op(2'b00), .y(y), .carry(carry));

    always @(posedge slow_clk) begin
        idx <= idx + 1;
        case(idx)
            2'd0: begin a <= 8'd3;  b <= 8'd5;  end
            2'd1: begin a <= 8'd7;  b <= 8'd8;  end
            2'd2: begin a <= 8'd15; b <= 8'd1;  end
            default: ; // keep
        endcase
    end

    assign LED0 = y[0];  // visualise bit 0 of result
endmodule