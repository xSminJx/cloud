
module Generate_Item_Pos(i_Clk, i_Rst, i_Body_x, i_Body_y, i_Body_size, o_Item_x, o_Item_y, o_isMakeItem_Done);

parameter   XSIZE = 48, YSIZE= 64, MAX_SIZE  = 100;

input                       i_Clk, i_Rst;
input   [MAX_SIZE*6-1:0]    i_Body_x, i_Body_y;
input   [11:0]               i_Body_size;
output  [5:0]               o_Item_x, o_Item_y;
output o_isMakeItem_Done;

wire    [6:0]   random_x, random_y;
wire    [6:0]   seed_x, seed_y;
reg     [1:0]   c_State, n_State;
reg     [5:0]   c_Item_x, n_Item_x;
reg     [5:0]   c_Item_y, n_Item_y;
reg     [5:0]   r_Item_x, r_Item_y;
reg             c_Match, n_Match;

parameter   IDLE = 2'b00, CHECK = 2'b01, DONE = 2'b10;

integer i;

assign  o_Item_x = r_Item_x;
assign  o_Item_y = r_Item_y;

assign seed_x = c_Item_x ? random_x : 7'b1010101;
assign seed_y = c_Item_y ? random_y : 7'b1000011;
assign o_isMakeItem_Done = c_State == DONE;

LFSR LFSR_X (i_Clk, i_Rst, seed_x, random_x);
LFSR LFSR_Y (i_Clk, i_Rst, seed_y, random_y);


always@ (posedge i_Clk, negedge i_Rst)
    if(!i_Rst) begin
        c_State     = 0;
        c_Item_x    = 0;
        c_Item_y    = 0;
        c_Match     = 0;
    end else begin
        c_State     = n_State;
        c_Item_x    = n_Item_x;
        c_Item_y    = n_Item_y;
        c_Match     = n_Match;
    end


always@ *
begin
    n_Match = 0;

    case(c_State)
        IDLE: begin
            n_Item_x = random_x > XSIZE ? random_x - XSIZE : random_x;
            n_Item_y = random_y > YSIZE ? random_y - YSIZE : random_y;

            n_State = CHECK;
        end
        CHECK: begin
            for(i = 0; i < i_Body_size*6-1; i = i+6) begin
                if(c_Item_x == i_Body_x[i +: 6] && c_Item_y == i_Body_y[i +: 6])
                    n_Match = 1;
            end
            
            n_State = c_Match ? IDLE : DONE;
        end
        DONE: begin
            r_Item_x = c_Item_x;
            r_Item_y = c_Item_y;

            n_State = IDLE;
        end
    endcase
end

endmodule