
module Generate_Item_Pos(i_Clk, i_Rst, i_Body_x, i_Body_y, i_Body_size, i_ItemNeed, o_Item_x, o_Item_y, o_isMakeItem_Done);

parameter   XSIZE = 48, YSIZE= 64, MAX_SIZE  = 20;

input                       i_Clk, i_Rst;
input   [MAX_SIZE*6-1:0]    i_Body_x, i_Body_y;
input   [11:0]              i_Body_size;
input                       i_ItemNeed;
output  [5:0]               o_Item_x, o_Item_y;
output                      o_isMakeItem_Done;

wire    [ 5:0]     random_x, random_y;
wire    [ 1:0]     buffer;
wire               isMatch, o_isRanDone;

reg     [ 2:0]     c_State, n_State;
reg     [ 5:0]     c_Item_x, n_Item_x;
reg     [ 5:0]     c_Item_y, n_Item_y;
reg     [19:0]     Match;

parameter   IDLE    = 3'b000,
            MAKERAN = 3'b001,
            CHECK   = 3'b010,
            CHECK2  = 3'b011,
            DONE    = 3'b100;

integer i;

assign  o_Item_x = c_Item_x;
assign  o_Item_y = c_Item_y;

assign o_isMakeItem_Done = c_State == DONE;
assign isMatch = |Match;

wire i_RandNeed = c_State == MAKERAN;
LFSR LFSR0 (i_Clk, i_Rst, i_RandNeed, {buffer, random_x, random_y}, o_isRanDone);


always@ (posedge i_Clk, negedge i_Rst)
    if(!i_Rst) begin
        c_State     = 0;
        c_Item_x    = 0;
        c_Item_y    = 0;
    end else begin
        c_State     = n_State;
        c_Item_x    = n_Item_x;
        c_Item_y    = n_Item_y;
    end


always@ *
begin
    n_Item_x    = c_Item_x;
    n_Item_y    = c_Item_y;
    Match       = 0;
    n_State = c_State;

    case(c_State)
        IDLE: begin
            n_State = i_ItemNeed ? MAKERAN : IDLE;
        end
        MAKERAN : begin
            n_State = CHECK;
        end
        CHECK: begin
            if(o_isRanDone) begin
                if(0<random_x&&random_x<XSIZE-1&&0<random_y&&random_x<YSIZE-1) begin
                    n_Item_x = random_x;
                    n_Item_y = random_y;
                    n_State = CHECK2;
                end
                else begin
                    n_State = MAKERAN;
                end
            end
        end
        CHECK2: begin
            for(i = 0; i < i_Body_size && i < MAX_SIZE; i = i + 1) begin
                Match[i] = (n_Item_x == i_Body_x[i*6 +: 6] && n_Item_y == i_Body_y[i*6 +: 6]);
            end
            
            n_State = isMatch ? MAKERAN : DONE;
        end
        DONE: begin
            n_State = IDLE;
        end
    endcase
end

endmodule