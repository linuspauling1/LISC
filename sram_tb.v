`timescale 1ns/1ns

`include "sram.v"

//testbench sram
module sram_tb;

reg clk,cs,rd,wr;
reg [20:0] addr;
wire [7:0] data;
reg [7:0] buffer;

sram i1(
    .clk(clk),
    .cs(cs),
    .rd(rd),
    .wr(wr),
    .addr(addr),
    .data(data)
);

initial begin
    clk = 1'b0;
    repeat(2**18)
    #5 clk = ~clk;
end

initial begin
    cs = 1'b1;
    #50 cs = 1'b0;
    #50 cs = 1'b1;
end

initial begin
    {addr,rd,wr,buffer} = 0;
    for(integer i = 0;i < 2**17;i = i+1) begin
        #10
        buffer = i;
        {rd,addr[15:0]} = i;
        wr = ~rd;
    end
end

initial begin
    $dumpfile("sram_tb.vcd");
    $dumpvars(0,sram_tb);
end

assign data = (cs & wr) ? buffer : 8'bz;

endmodule;