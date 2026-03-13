module memory (
    input [7:0] address,
    input [7:0] data_in,
    input write_en,
    output reg [7:0] data_out
);

reg [7:0] mem [0:300];
always @(data_in or address) begin
    mem[address] = data_in;
end

assign data_out = mem[address];
endmodule