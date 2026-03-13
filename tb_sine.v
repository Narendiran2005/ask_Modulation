`timescale 1ns/1ps

module tb_sine_wave_generator;

    // Testbench signals
    reg clk;
    reg rst;
    wire [7:0] sine_out;

    // Instantiate DUT
    sine_wave_generator dut (
        .clk(clk),
        .rst(rst),
        .sine_out(sine_out)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    integer i;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;

        // Apply reset
        #20;
        rst = 0;

        // Run for several cycles
        for (i = 0; i < 80; i = i + 1) begin
            @(posedge clk);
            $display("Time=%0t Phase=%0d Sine_out=%0d",
                      $time, dut.phase_acc, sine_out);
        end

        $finish;
    end

    // Optional waveform dump (for GTKWave / ModelSim)
    initial begin
        $dumpfile("sine_wave.vcd");
        $dumpvars(0, tb_sine_wave_generator);
    end

endmodule