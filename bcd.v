module bcd(
    input [9:0] in,
    output [3:0] mii,
    output [3:0] sute,
    output [3:0] zeci,
    output [3:0] unitati
);

assign unitati = in%10;
assign zeci = (in/10)%10;
assign sute = (in/100)%10;
assign mii = (in/1000)%10;

endmodule;