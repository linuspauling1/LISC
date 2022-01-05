//interfata pentru memoria EPROM (de cod)
module eprom(
    input clk,
    input rd,
    input cs,
    input [20:0] addr,//adrese pe 21 de biti    
    output [23:0] data//date pe 24 de biti
);

reg [23:0] memory [2**21 -1 : 0];//memoria
reg [23:0] buffer;//pentru a evita erorile de compilare

assign data = (cs & rd) ? buffer : 24'bz;//datele vor fi situate pe magistrala numai cand citim

localparam nop = 2'd0;
localparam start = 2'd1;
localparam pause = 2'd2;
localparam stop = 2'd3;

integer i;

initial begin
    buffer = 0;
    for(i = 0; i < 2**21; i = i+1)
        memory[i] = 24'b0;
    memory[0] = {start,22'b0};
    memory[12501] = {pause,21'b1,1'b0};
    memory[12502] = {start,22'b0};
    memory[12500*2+3] = {stop,21'b11,1'b0};
end

always @(posedge clk) begin
        buffer <= memory[addr];//situare valorilor pe magistrala de date se face prin tampon
end

endmodule;