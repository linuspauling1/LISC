//interfata sram
module sram(
    input clk,
    input cs,
    input rd,
    input wr,
    input [20:0] addr,//adrese pe 21 de biti
    inout [7:0] data//date pe 8 biti
);

reg [7:0] memory[2**21 - 1 : 0];
reg [7:0] buffer;

assign data = (cs & rd) ? buffer : 8'bz;

always @(posedge clk) begin
    if(rd & cs)
        buffer <= memory[addr];
    else if(wr & cs)
        memory[addr] <= data;
end

endmodule;