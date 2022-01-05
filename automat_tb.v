//presupunem ca avem un semnal de tact cu o frecventa de 2,5MHz
`timescale 1ns/1ns

`include "automat.v"

//testbench pentru automat
module automat_tb;

reg clk,clr;
reg [1:0] in;
wire rst,en;

automat i1(
    .clk(clk),
    .clr(clr),
    .in(in),
    .rst(rst),
    .en(en)
);

initial begin
    clk = 1'b0;
    repeat (250000*2)
    #200 clk = ~clk;
end

initial begin
    clr = 1'b0;
    #1000000 clr = 1'b1;
end

initial begin
    in = 1;
    #400 in = 0;
    #1999600 in = 3;
    #2000000 in = 1;
    #400 in = 0;
    #1999600 in = 2;
    #2000000 in = 2;
    #2000000 in = 0;
    #2000000 in = 3;
    #2000000 in = 3;
    #2000000 in = 0;
    #2000000 in = 2;
    #2000000 in = 1;
    #400 in = 0;
    #1999600 in = 0;
    #2000000 in = 0;
    #2000000 in = 1;
end

initial begin
    $dumpfile("automat_tb.vcd");
    $dumpvars(0,automat_tb);
end

endmodule;