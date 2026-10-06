// promaa 08/06/2025 - Top module for FPGA implementation (PYNQ-Z1)

module top(
    input  wire       clk,   // 125 MHz board clock
    output wire [3:0] led    // low 4 bits of the sum
);
    // Show one addition per second: 3+5=8 (1000), 7+8=15 (1111), 15+1=16 (0000)
    reg [26:0] div_cnt = 0;
    reg [1:0]  idx = 0;
    reg [7:0]  a = 0, b = 0;
    always @(posedge clk) begin
        div_cnt <= div_cnt + 1;
        if (div_cnt == 27'd124_999_999) begin
            div_cnt <= 0;
            idx <= idx + 1;
            case (idx)
                2'd0: begin a <= 8'd3;  b <= 8'd5;  end
                2'd1: begin a <= 8'd7;  b <= 8'd8;  end
                2'd2: begin a <= 8'd15; b <= 8'd1;  end
                default: ; // keep
            endcase
        end
    end

    wire [7:0] y;
    wire       carry;
    alu8 alu_inst (.A(a), .B(b), .Op(3'b000), .Cin(1'b0), .Y(y), .Cout(carry));

    assign led = y[3:0];
endmodule
