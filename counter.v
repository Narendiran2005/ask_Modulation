module mod32_counter (
    input  wire clk,       // Fast global clock
    input  wire rst,       // Active-high reset
    output reg  slow_clk   // Divided clock output
);
    reg [4:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count    <= 5'd0;
            slow_clk <= 1'b0;
        end else begin
            count <= count + 1'b1;
            // The Most Significant Bit (MSB) of a 5-bit counter toggles 
            // at 1/32nd the frequency of the input clock.
            slow_clk <= count[4]; 
        end
    end
endmodule