
module Generate_Item_Pos(i_Clk, i_Rst, i_Body_x, i_Body_y, i_Body_size, o_item_x, o_item_y);

input               i_Clk, i_Rst;
input   [3359:0]    i_Body_x, i_Body_y;
input   [8:0]       i_Body_size;
output  [6:0]       o_item_x, o_item_y;


wire    [6:0]   random_x, random_y;
reg     [1:0]   c_State, n_State;
reg     [6:0]   c_Item_x, n_Item_x;
reg     [6:0]   c_Item_y, n_Item_y;
reg     [6:0]   r_Item_x, r_Item_y;
reg             c_Match, n_Match;
reg     [8:0]   c_CheckCnt, n_CheckCnt;

parameter   IDLE = 2'b00, CHECK = 2'b01, DONE = 2'b10;

wire    isCheck = i_Body_size == n_CheckCnt;

assign  o_item_x = r_Item_x;
assign  o_item_y = r_Item_y;

LFSR LFSR_X (i_Clk, i_Rst, random_x);
LFSR LFSR_Y (i_Clk, i_Rst, random_y);


always@ (posedge i_Clk, negedge i_Rst)
    if(!i_Rst) begin
        c_State     = 0;
        c_Item_x    = 0;
        c_Item_y    = 0;
        r_Item_x    = 0;
        r_Item_y    = 0;
        c_Match     = 0;
        c_CheckCnt  = 0;
    end else begin
        c_State     = n_State;
        c_Item_x    = n_Item_x;
        c_Item_y    = n_Item_y;
        c_Match     = n_Match;
        c_CheckCnt  = n_CheckCnt;
    end


always@ *
begin
    n_CheckCnt = 0;
    n_Match = 0;

    case(c_State)
        IDLE: begin
            n_Item_x = random_x > 80 ? random_x - 80 : random_x;
            n_Item_y = random_y > 60 ? random_y - 60 : random_y;

            n_State = CHECK;
        end
        CHECK: begin
            if(c_Item_x == i_Body_x[c_CheckCnt*7 +: 7] || c_Item_y == i_Body_y[c_CheckCnt*7 +: 7]) begin
                n_Match = 1;
            end else begin
                n_CheckCnt = c_CheckCnt + 1; 
            end
            
            if(isCheck) n_State = DONE;
            if(c_Match) n_State = IDLE;
        end
        DONE: begin
            r_Item_x = c_Item_x;
            r_Item_y = c_Item_y;

            n_State = IDLE;
        end
    endcase
end

endmodule
