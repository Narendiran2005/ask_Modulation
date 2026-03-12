`timescale 1ns/1ps

module tb_parallel_to_serial_shift_reg_2;

    // Testbench signals
    reg clk;
    reg rst;
    reg load;
    reg [31:0] parallel_in;
    wire serial_out;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial_shift_reg dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .parallel_in(parallel_in),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    integer i;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        load = 0;
        parallel_in = 32'd0;

        // Apply reset
        #10 rst = 0;

        // Load parallel data
        #10;
        load = 1;
        parallel_in = 32'b10110011100011110000111100001111;

        #10;
        load = 0;

        // Shift for 32 clock cycles
        for (i = 0; i < 32; i = i + 1) begin
            #10;
            $display("Time=%0t Serial Out=%b", $time, serial_out);
        end

        #20 $finish;
    end

    // Monitor signals
    always @(posedge clk) begin
    $display("Time=%0t load=%b shift_reg=%b serial_out=%b",
              $time, load, dut.shift_reg, serial_out);
end

endmodule

