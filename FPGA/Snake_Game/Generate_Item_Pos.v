
module Generate_Item_Pos(i_Clk, i_Rst, i_Body_x, i_Body_y, i_Body_size, i_ItemNeed, o_Item_x, o_Item_y, o_isMakeItem_Done);

parameter   XSIZE = 48, YSIZE= 64, MAX_SIZE  = 20;

input                       i_Clk, i_Rst;
input   [MAX_SIZE*6-1:0]    i_Body_x, i_Body_y;
input   [11:0]              i_Body_size;
input                       i_ItemNeed;
output  [5:0]               o_Item_x, o_Item_y;
output                      o_isMakeItem_Done;

wire    [ 6:0]     random_x, random_y;
wire               isMatch;

reg     [ 1:0]     c_State, n_State;
reg     [ 5:0]     c_Item_x, n_Item_x;
reg     [ 5:0]     c_Item_y, n_Item_y;
reg     [ 5:0]     r_Item_x, r_Item_y;
reg                r_RandNeed;
reg     [19:0]     Match;

parameter   IDLE = 2'b00, GET = 2'b01, CHECK = 2'b10, DONE = 2'b11;

integer i;

assign  o_Item_x = r_Item_x;
assign  o_Item_y = r_Item_y;

assign o_isMakeItem_Done = c_State == DONE;
assign isMatch = |Match;

LFSR LFSR0 (i_Clk, i_Rst, r_RandNeed, {random_x, random_y});


always@ (posedge i_Clk, negedge i_Rst)
    if(!i_Rst) begin
        c_State     = 0;
        c_Item_x    = 0;
        c_Item_y    = 0;
        r_Item_x    = 0;
        r_Item_y    = 0;
        Match       = 0;
    end else begin
        c_State     = n_State;
        c_Item_x    = n_Item_x;
        c_Item_y    = n_Item_y;
        r_Item_x    = n_State == CHECK ? c_Item_x : r_Item_x;
        r_Item_y    = n_State == CHECK ? c_Item_y : r_Item_y;
    end


always@ *
begin
    r_RandNeed  = i_ItemNeed;
    n_Item_x    = c_Item_x;
    n_Item_y    = c_Item_y;
    Match       = 0;

    case(c_State)
        IDLE: begin
            n_State = i_ItemNeed ? GET : IDLE;
        end
        GET: begin
            n_Item_x = (random_x < XSIZE) ? random_x : (random_x - XSIZE);
            n_Item_y = (random_y < YSIZE) ? random_y : (random_y - YSIZE);

            n_State = ((n_Item_x != c_Item_x) && (n_Item_y != c_Item_y)) ? CHECK : GET;
        end
        CHECK: begin
            for(i = 0; i < i_Body_size && i < MAX_SIZE; i = i + 1) begin
                Match[i] = (c_Item_x == i_Body_x[i*6 +: 6] && c_Item_y == i_Body_y[i*6 +: 6]);
            end
            
            n_State = isMatch ? GET : DONE;
        end
        DONE: begin
            n_State = IDLE;
        end
    endcase
end

endmodule