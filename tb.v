`timescale 1ns / 1ps

module tb_ask_modulator;

    // Testbench signals
    reg         clk;
    reg         rst;
    reg         load;
    reg  [31:0] parallel_in;
    wire [7:0]  ask_out;

    // Instantiate the Device Under Test (DUT)
    ask_modulator dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .parallel_in(parallel_in),
        .ask_out(ask_out)
    );

    // 1. Clock Generation: 50 MHz clock (20ns period) 
    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end

    // 2. Test Sequence
    initial begin
        // Initialize inputs
        rst = 1;
        load = 0;
        // Test pattern: 1011_0000_... (Hex: B0000000)
        // This will let us easily see the ON-OFF-ON-ON waveform.
        parallel_in = 32'hB0000000; 

        // Hold reset for a few cycles, then release
        #100;
        rst = 0;

        // Wait a bit, then pulse the load signal.
        // We must hold 'load' high long enough for the slow clock domain 
        // inside the PISO to register it. (Slow clock period = 32 * 20ns = 640ns)
        #50;
        load = 1;
        #700; 
        load = 0;

        // Let the simulation run to observe the data shifting out.
        // 4 bits * 640ns per bit = 2560ns. We'll run it a bit longer.
        #4000;

        // End simulation
        $finish;
    end

    // 3. VCD Dump for Waveform Viewers 
    initial begin
        $dumpfile("ask_modulator.vcd");
        $dumpvars(0, tb_ask_modulator);
    end

endmodule