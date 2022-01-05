`include "numarator.v"

//interfata pentru generatorul de pulsuri
module generator(
    input rst,
    input clk,
    input en,
    output reg out
);

wire [31:0] sarma;
wire clk_en;

numarator instanta(
    .clk(clk_en),
    .rst(1'b1),
    .clr(rst),
    .count_down(1'b1),
    .out(sarma)
);

assign clk_en = clk & en;

always @ * begin
    if(sarma == 32'b0)
        out = 1'b1;
    else
        out = 1'b0;
end

endmodule;