`timescale 1ns/1ns

`include "bcd.v"

//testbench pentru convertorul bcd
module bcd_tb;

output reg [9:0] in;
wire [3:0] mii, sute, zeci, unitati;

bcd i1(
    .in(in),
    .mii(mii),
    .sute(sute),
    .zeci(zeci),
    .unitati(unitati)
);

initial begin
    in = 0;
    for(integer i = 0;i < 2**10;i = i+1)
    #10 in = i;
end

initial begin
    $dumpfile("bcd_tb.vcd");
    $dumpvars(0,bcd_tb);
end

endmodule;