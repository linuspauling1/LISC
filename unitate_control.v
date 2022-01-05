`include "automat.v"
`include "ms.v"
`include "bcd.v"

//interfata unitate de control
module unitate_control(
    input clk, clr,
    input [1:0] in,
    output [3:0] mii,
    output [3:0] sute,
    output [3:0] zeci,
    output [3:0] unitati
);

wire fir_rst, fir_en;
wire [31:0] out;

automat i1(
    .clk(clk),
    .clr(clr),
    .in(in),
    .rst(fir_rst),
    .en(fir_en)
);

ms i2(
    .rst(fir_rst),
    .clk(clk),
    .en(fir_en),
    .out(out)
);

bcd i3(
    .in(out[9:0]),
    .mii(mii),
    .sute(sute),
    .zeci(zeci),
    .unitati(unitati)
);

endmodule;