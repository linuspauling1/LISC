//presupunem ca avem un semnal de tact cu o frecventa de 2,5MHz
`timescale 1ns/1ns

`include "ms.v"

//testbench pentru numaratorul de ms
module ms_tb;

reg rst,clk,en;
wire [31:0] out;

ms i1(
    .rst(rst),
    .clk(clk),
    .en(en),
    .out(out)
);

initial begin
    clk = 1'b0;
    repeat (250000*2)
    #200 clk = ~clk;
end

initial begin
    rst = 1'b0;
    #1000000 rst = 1'b1;
    #3000000 rst = 1'b0;
    #2000000 rst = 1'b1;
end

initial en = 1'b1;

initial begin
    $dumpfile("ms_tb.vcd");
    $dumpvars(0,ms_tb);
end

endmodule;