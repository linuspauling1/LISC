`include "generator.v"

//interfata numarator de ms
module ms(
    input rst,
    input clk,
    input en,
    output [31:0] out
);

wire fir;

generator i1(
    .rst(rst),
    .clk(clk),
    .en(en),
    .out(fir)
);

numarator i2(
    .rst(rst),
    .clr(rst),
    .clk(fir),
    .count_down(1'b0),
    .out(out)
);

endmodule;