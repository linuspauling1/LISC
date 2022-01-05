//interfata numarator
module numarator(
    input clk,
    input rst,
    input clr,
    input count_down,
    output [31:0] out
);

reg [31:0] count_next, count_reg;

initial begin 
    count_next = 32'd0;
    count_reg = 32'd0;
end

always @ * begin
    if(count_down == 1'b1)
        if(count_reg == 0)
            count_next = 2500 - 1;
        else
            count_next = count_reg - 1; 
    else if(count_down == 1'b0)
        if(count_reg == 2500 - 1)
            count_next = 0;
        else
            count_next = count_reg + 1;
    else
        count_next = count_reg;//pentru cazul in care primeste X sau Z 
end

always @ (posedge clk or negedge rst)
begin
    if(!rst || !clr)
        count_reg <= 32'b0;
    else
        count_reg <= count_next;
end

assign out = count_reg;

endmodule;