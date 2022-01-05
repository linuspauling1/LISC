//presupunem ca avem un semnal de tact cu o frecventa de 2,5MHz
`timescale 1ns/1ns

`include "unitate_control.v"

//testbench pentru unitatea de control
module unitate_control_tb;

reg clk, clr;
reg [1:0] in;

wire [3:0] mii, sute, zeci, unitati;

unitate_control i1(
    .clk(clk),
    .clr(clr),
    .in(in),
    .mii(mii),
    .sute(sute),
    .zeci(zeci),
    .unitati(unitati)
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
    in = 3;
    repeat (5) begin
        for (integer i = 1; i < 4; i = i+1) begin
            #3000000 in = i;
            if(i == 1)
                #400 in = 0;
            else
                #1000000 in = 0;
        end
    end
end

initial begin
    $dumpfile("unitate_control_tb.vcd");
    $dumpvars(0,unitate_control_tb);
end

endmodule;