module parallel_to_serial_shift_reg (
    input  wire        clk,          // Clock signal (from the Mod-32 counter)
    input  wire        rst,          // Active-high reset
    input  wire        load,         // Control signal: 1 = Load data, 0 = Shift data
    input  wire [31:0] parallel_in,  // 32-bit parallel data input (D0 to D31)
    output wire        serial_out    // 1-bit serial data output (feeds the MUX)
);

    // Internal 32-bit register to hold the data while shifting
    reg [31:0] shift_reg; 

    // Sequential logic triggered on the rising edge of the clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // On reset, clear the register to all zeros
            shift_reg <= 32'd0;
        end else if (load) begin
            // When load is high, capture the 32-bit input all at once
            shift_reg <= parallel_in;
        end else begin
            // When load is low, shift the bits left by one position.
            // The Most Significant Bit (MSB) shifts out, and a 0 shifts into the LSB.
            shift_reg <= {shift_reg[30:0], 1'b0}; 
        end
    end

    // The serial output is continuously driven by the MSB of the internal register
    assign serial_out = shift_reg[31];

endmodule

module parallel_to_serial_shift_reg_2 (
    input  wire        clk,
    input  wire        rst,
    input  wire        load,
    input  wire [31:0] parallel_in,
    output wire        serial_out
);

reg [31:0] data_reg;
reg [4:0]  bit_index;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_reg  <= 32'd0;
        bit_index <= 5'd31;
    end 
    else if (load) begin
        data_reg  <= parallel_in;
        bit_index <= 5'd31;
    end 
    else begin
        bit_index <= bit_index - 1;
    end
end

assign serial_out = data_reg[bit_index];

endmodule