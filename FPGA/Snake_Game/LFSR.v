
module LFSR(i_Clk, i_Rst, i_RandNeed, o_RandNum, o_isRanDone);

input           i_Clk, i_Rst;
input           i_RandNeed;
output  [13:0]  o_RandNum;
output o_isRanDone;

wire            feedback;
reg     [ 1:0]  c_State, n_State;
reg     [13:0]  c_Num, n_Num;
reg     [13:0]  r_Num;

parameter   IDLE = 2'b00, RUN = 2'b01, DONE = 2'b10;

assign  feedback    = c_Num[13] ^ c_Num[12] ^ c_Num[11] ^ c_Num[1];
assign  o_RandNum   = c_Num;
assign o_isRanDone = c_State == DONE;

always@ (posedge i_Clk, negedge i_Rst)
    if(!i_Rst) begin
        c_State = 0;
        c_Num   = 14'b11000010101111; //14'b10101011000011;
        r_Num   = 0;
    end else begin
        c_State = n_State;
        c_Num   = n_Num;
        r_Num   = c_State == DONE ? c_Num : 0;
    end

always@ *
begin
    n_State = c_State;
    n_Num   = c_Num;

    case(c_State)
    IDLE: begin
        if(i_RandNeed)
            n_State = RUN;
    end
    RUN: begin
        n_Num   = {c_Num[12:0], feedback};

        n_State = DONE;
    end
    DONE: begin
        n_State = IDLE;
    end
    endcase
end

endmodule