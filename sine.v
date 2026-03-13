module sine_wave_generator (
    input  wire       clk,        // Fast system clock
    input  wire       rst,        // Active-high reset
    output reg  [7:0] sine_out    // 8-bit digital sine wave amplitude
);

    // 1. The Phase Accumulator (Counter)
    // We need 5 bits to address 32 different samples (2^5 = 32)
    reg [4:0] phase_acc;

    // 2. The Look-Up Table (ROM)
    // 32 memory locations, each 8 bits wide
    reg [7:0] sine_rom [0:31];

    // Initialize the ROM with pre-calculated sine values.
    // These values represent one full cycle of sin(x) scaled to 0-255 (8-bit unsigned).
    // Center point is 127. Peak is 255. Trough is 0.
    initial begin
        sine_rom[0]  = 8'd127; sine_rom[1]  = 8'd152; sine_rom[2]  = 8'd176; sine_rom[3]  = 8'd198;
        sine_rom[4]  = 8'd218; sine_rom[5]  = 8'd234; sine_rom[6]  = 8'd245; sine_rom[7]  = 8'd253;
        sine_rom[8]  = 8'd255; sine_rom[9]  = 8'd253; sine_rom[10] = 8'd245; sine_rom[11] = 8'd234;
        sine_rom[12] = 8'd218; sine_rom[13] = 8'd198; sine_rom[14] = 8'd176; sine_rom[15] = 8'd152;
        sine_rom[16] = 8'd127; sine_rom[17] = 8'd103; sine_rom[18] = 8'd79;  sine_rom[19] = 8'd57;
        sine_rom[20] = 8'd37;  sine_rom[21] = 8'd21;  sine_rom[22] = 8'd10;  sine_rom[23] = 8'd2;
        sine_rom[24] = 8'd0;   sine_rom[25] = 8'd2;   sine_rom[26] = 8'd10;  sine_rom[27] = 8'd21;
        sine_rom[28] = 8'd37;  sine_rom[29] = 8'd57;  sine_rom[30] = 8'd79;  sine_rom[31] = 8'd103;
    end

    // Sequential logic to drive the phase accumulator and fetch ROM data
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            phase_acc <= 5'd0;
            sine_out  <= 8'd127; // Reset to the zero-crossing center value
        end else begin
            // Increment the counter. It will naturally roll over from 31 back to 0.
            phase_acc <= phase_acc + 1'b1;
            
            // Output the sine wave value at the current phase index
            sine_out  <= sine_rom[phase_acc];
        end
    end

endmodule