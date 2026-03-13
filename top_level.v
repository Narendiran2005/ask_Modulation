module ask_modulator (
    input  wire        clk,          // Fast global system clock
    input  wire        rst,          // System reset
    input  wire        load,         // Control signal to load parallel data
    input  wire [31:0] parallel_in,  // 32-bit data to transmit
    output wire [7:0]  ask_out       // 8-bit digital analog output to DAC
);

    // Internal wires for interconnecting modules
    wire       slow_clk;
    wire       serial_data;
    wire [7:0] carrier_wave;

    // A. 5-Bit Counter [cite: 181-182]
    mod32_counter u_counter (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );

    // B. Parallel to Serial Shift Register [cite: 171-178]
    parallel_to_serial_shift_reg u_piso (
        .clk(slow_clk),       // Driven by the slowed-down clock
        .rst(rst),
        .load(load),
        .parallel_in(parallel_in),
        .serial_out(serial_data)
    );

    // C. Sine Wave Generator [cite: 179]
    sine_wave_generator u_sine_gen (
        .clk(clk),            // Driven by the fast global clock
        .rst(rst),
        .sine_out(carrier_wave)
    );

    // D. 2x1 MUX (The Modulator) [cite: 166-170]
    // If the serial data bit is 1, pass the carrier wave.
    // If the serial data bit is 0, pass 8'd0 (acting as GND1)[cite: 180].
    assign ask_out = (serial_data == 1'b1) ? carrier_wave : 8'd0;

endmodule