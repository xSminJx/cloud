
module LFSR(i_Clk, i_Rst, i_Seed, o_RandNum);

input           i_Clk, i_Rst;
input   [6:0]   i_Seed;
output  [6:0]   o_RandNum;

wire            feedback;
reg     [6:0]   c_State, n_State;


assign  feedback    = c_State[6] ^ c_State[5];
assign  o_RandNum   = c_State;

always@ (posedge i_Clk, negedge i_Rst)
    if(!i_Rst) begin
        c_State = i_Seed;
    end else begin
        c_State = n_State;
    end

always@ *
begin   
    n_State = {c_State[5:0], feedback};
end

endmodule