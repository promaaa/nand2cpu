// promaa 08/06/2025 - Top module for FPGA implementation (PYNQ-Z1)

module top(
    input  wire       clk,   // 125 MHz board clock
    output wire [3:0] led    // Low 4 bits of the CPU output register
);
    // Run 8 instructions per second, slow enough to follow the LEDs by eye
    reg [23:0] div_cnt = 0;
    reg        en = 0;
    always @(posedge clk) begin
        if (div_cnt == 24'd15_624_999) begin
            div_cnt <= 0;
            en      <= 1;
        end else begin
            div_cnt <= div_cnt + 1;
            en      <= 0;
        end
    end

    // The flip-flops start at 0, so the CPU starts at address 0 without a reset
    wire [15:0] out;
    computer #(.PROGRAM("program.mem")) cpu_inst (
        .clk(clk), .reset(1'b0), .en(en), .out(out), .halted()
    );

    assign led = out[3:0];
endmodule
