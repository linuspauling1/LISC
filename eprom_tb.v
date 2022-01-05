`timescale 1ns/1ns

`include "eprom.v"

//testbench eprom
module eprom_tb;

    reg clk,rd,cs;
    reg [20:0] addr;
    wire [23:0] data;

    eprom i1(
        .clk(clk),
        .rd(rd),
        .cs(cs),
        .addr(addr),
        .data(data)
    );

    initial begin
        clk = 1'b0;
        repeat (2*25010)
        #5 clk = ~clk;
    end

    initial begin
        rd = 1'b1;
        #50 rd = 1'b0;
        #50 rd = 1'b1;
    end

    initial begin
        cs = 1'b1;
        #100 cs = 1'b0;
        #50 cs = 1'b1;
    end

    initial begin
        addr = 0;
        for(integer i = 0; i < 25010; i = i+1)
        #10 addr = i;
    end

initial begin
    $dumpfile("eprom_tb.vcd");
    $dumpvars(0,eprom_tb);
end

endmodule;