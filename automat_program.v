`include "unitate_control.v"
`include "eprom.v"
`include "sram.v"

//interfata automat pentru rularea programelor
module automat_program(
    input clk,//semnal de tact
    input rst,//semnal de reset asincron
    output [21:0] addr_bus,//magistrala de adrese
    inout [23:0] data_bus,//magistrala de date
    output [1:0] alu_in,//intrarea automatului
    input [15:0] alu_out,//iesirea automatului (avand patru cifre BCD)
    output reg rd,//semnal de read
    output reg wr,//semnal de write
    output reg alu_clk//semnal de tact pentru automat
);

localparam IF_ST = 3'd0;
localparam ID_ST = 3'd1;
localparam DT_ST = 3'd2;
localparam EX_ST = 3'd3;
localparam WB_ST = 3'd4;

reg [2:0] st,st_nxt;

always @(*) begin
    case(st)
        IF_ST: st_nxt = ID_ST;
        ID_ST: st_nxt = DT_ST;
        DT_ST: st_nxt = EX_ST;
        EX_ST: st_nxt = WB_ST;
        WB_ST: st_nxt = IF_ST;
    endcase
end

localparam nop = 2'd0;
localparam start = 2'd1;
localparam pause = 2'd2;
localparam stop = 2'd3;

reg [21:0] ar;//address register, conectat la magistrala de adrese
reg [23:0] dr;//data register, conectat la magistrala de date
reg [20:0] pc;//numaratorul de program
reg [1:0] ir;//va fi conectat la alu_in
reg [15:0] acc;//va fi conectat la alu_out

assign addr_bus = ar;
assign data_bus = wr ? dr : 24'bz;
assign alu_in = ir;

initial begin
    ar = 22'b0;
    dr = 22'bz;
    pc = 21'b0;
    ir = 2'b0;
    acc = 16'b0;

    alu_clk = 1'b0;
    rd = 1'b0;
    wr = 1'b0;
end

always @(st) begin
    case(st)
        IF_ST:
            begin
                ar <= {pc,1'b1};
                wr <= 1'b0;
            end
        ID_ST:
            begin
                pc <= pc + 1;
                rd <= 1'b1;
            end
        DT_ST:
            dr <= data_bus;
        EX_ST: 
            begin
                alu_clk <= 1'b1;
                ir <= dr[23:22];
                rd <= 1'b0;
            end
        WB_ST: 
            begin
                if(ir == pause || ir == stop) begin
                    ar <= dr[21:0];
                    dr <= alu_out;//in loc de acc
                    wr <= 1'b1;
                end
                alu_clk <= 1'b0;
            end
    endcase
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        ar = 22'b0;
        dr = 22'bz;
        pc = 21'b0;
        ir = 2'b0;
        acc = 16'b0;
        alu_clk = 1'b0;
        rd = 1'b0;
        wr = 1'b0;
        st <= IF_ST;
    end
    else
        st <= st_nxt;
end

endmodule;

//interfata sistem
module sistem(
    input clk,rst,
    input sel,
    input rd,wr,
    input [21:0] addr,
    output [15:0] out
);

wire [21:0] waddr,waddr_sram;
wire [23:0] wdata;
wire [15:0] wout;
wire [1:0] win;
wire wrd,wrd_sram,wwr,wwr_sram,wclk;

assign out = wdata[15:0];//sa putem vedea rezultatele automatului

automat_program i1(
    .clk(clk),
    .rst(rst),
    .addr_bus(waddr),
    .data_bus(wdata),
    .alu_in(win),
    .alu_out(wout),
    .rd(wrd),
    .wr(wwr),
    .alu_clk(wclk)
);

eprom i2(
    .clk(clk),
    .rd(wrd),
    .cs(waddr[0]),
    .addr(waddr[21:1]),
    .data(wdata)
);

unitate_control i3(
    .clk(wclk),
    .clr(wclr),
    .in(win),
    .mii(wout[15:12]),
    .sute(wout[11:8]),
    .zeci(wout[7:4]),
    .unitati(wout[3:0])
);

assign waddr_sram = sel ? addr : waddr;//am scris pe doua linii pentru
assign {wrd_sram,wwr_sram} = sel ? {rd,wr} : {wrd,wwr};//lizibilitate

sram i4(
    .clk(clk),
    .cs(~waddr_sram[0]),
    .rd(wrd_sram),
    .wr(wwr_sram),
    .addr(waddr_sram[21:1]),
    .data(wdata[7:0])
);

sram i5(
    .clk(clk),
    .cs(~waddr_sram[0]),
    .rd(wrd_sram),
    .wr(wwr_sram),
    .addr(waddr_sram[21:1]),
    .data(wdata[15:8])
);

endmodule


`timescale 1ns/1ns

//testbench pentru sistem
module sistem_tb;

reg clk,rst;
reg sel,rd,wr;
reg [21:0] addr;
wire [15:0] out;

sistem i1(
    .clk(clk),
    .rst(rst),
    .sel(sel),
    .rd(rd),
    .wr(wr),
    .addr(addr),
    .out(out)
);

initial begin
    rst = 1'b0;
    #10 rst = 1'b1;
end

initial begin
    clk = 1'b0;
    repeat (5*2*25010 + 5*2*4)
    #200 clk = ~clk;
end

initial begin
    sel = 1'b0;
    rd = 1'b1;
    wr = 1'b0;
    addr = 22'b10;
    #50024001 rd = 1'b0;
    #1000 rd = 1'b1;
    sel = 1'b1;
    #1200 rd = 1'b0;
    #800 rd = 1'b1;
    addr = 22'b110;   
end

initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,sistem_tb);
end

endmodule;