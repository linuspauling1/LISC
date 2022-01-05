//interfata automat
module automat(
    input clk,clr,
    input [1:0] in,
    output reg rst,en
);

localparam START_ST = 2'd0;
localparam PAUSE_ST = 2'd1;
localparam STOP_ST = 2'd2;
localparam RESTART_ST = 2'd3;

localparam nop = 2'd0;
localparam start = 2'd1;
localparam pause = 2'd2;
localparam stop = 2'd3;

reg [1:0] st;
reg [1:0] st_nxt;

always @(*) begin
    case(st)
        START_ST:
            if(in == nop)
                st_nxt = START_ST;
            else if(in == start)
                st_nxt = RESTART_ST;
            else if(in == pause)
                st_nxt = PAUSE_ST;
            else if(in == stop)
                st_nxt = STOP_ST;
        PAUSE_ST:
            if(in == nop || in == pause)
                st_nxt = PAUSE_ST;
            else if(in == start)
                st_nxt = START_ST;
            else if(in == stop)
                st_nxt = STOP_ST;
        STOP_ST:
            if(in == nop || in == stop)
                st_nxt = STOP_ST;
            else if(in == pause)
                st_nxt = PAUSE_ST;
            else if(in == start)
                st_nxt = START_ST;
        RESTART_ST:
            st_nxt = START_ST;
    endcase
end

initial {rst,en} = 2'd0;
initial st = STOP_ST;
initial st_nxt = STOP_ST;

always @(*) begin
    case(st)
        START_ST:
            {rst,en} = 2'd3;
        PAUSE_ST:
            {rst,en} = 2'd2;
        STOP_ST:
            rst = 1'd0;
        RESTART_ST:
            rst = 1'd0;
    endcase
end

always @ (posedge clk)
    if(!clr) st <= st;
    else st <= st_nxt;

endmodule;