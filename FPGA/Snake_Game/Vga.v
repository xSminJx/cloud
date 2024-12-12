module Vga (
    i_Clk,            
    i_Rst,           
    i_worm_x,
    i_worm_y,
    i_item_x,           
    i_item_y,           
    i_size,
    o_hsync,            
    o_vsync,            
    o_red,              
    o_green,           
    o_blue             
);
    
    input i_Clk;
    input i_Rst;

    parameter MAX_SIZE = 100;
    input [MAX_SIZE*6 - 1: 0] i_worm_x;
    input [MAX_SIZE*6 - 1: 0] i_worm_y;
    reg [MAX_SIZE*6 - 1: 0] i_worm_x;
	 reg [MAX_SIZE*6 - 1: 0] i_worm_y;
    input [5:0] i_item_x;
    input [5:0] i_item_y;

    input [11:0] i_size;

    output o_hsync;
    output o_vsync;

    output reg[3:0] o_red;
    output reg[3:0] o_green;
    output reg[3:0] o_blue;

 
    parameter H_DISPLAY = 640;
    parameter H_FRONT = 16;
    parameter H_SYNC = 96;
    parameter H_BACK = 48;
    parameter H_TOTAL = 800;

    parameter V_DISPLAY = 480;
    parameter V_FRONT = 10;
    parameter V_SYNC = 2;
    parameter V_BACK = 33;
    parameter V_TOTAL = 525;
    
    parameter PIXEL_SIZE = 10;

    parameter WALL_TOP = V_SYNC + V_BACK; // 35
    parameter WALL_BOTTOM = V_TOTAL - PIXEL_SIZE; // 515


    reg [9:0] h_count; 
    reg [9:0] v_count; 


    assign o_hsync = (h_count < H_SYNC) ? 1'b1 : 1'b0;
    assign o_vsync = (v_count < V_SYNC) ? 1'b1 : 1'b0;

    wire [9:0] item_x_scaled = i_item_x * PIXEL_SIZE;
    wire [9:0] item_y_scaled = i_item_y * PIXEL_SIZE;

    wire active_area = ((H_SYNC + H_BACK <= h_count) && (h_count < H_SYNC + H_BACK + H_DISPLAY) && (V_SYNC + V_BACK <= v_count)  && (v_count < V_SYNC + V_BACK + V_DISPLAY));
    
    wire item_active = h_count - (H_SYNC + H_BACK) >= item_x_scaled && h_count - (H_SYNC + H_BACK) < item_x_scaled + 10 &&
                       v_count - (V_SYNC + V_BACK) >= item_y_scaled && v_count - (V_SYNC + V_BACK) < item_y_scaled + 10;


    wire edge_active =  ( (v_count >= WALL_TOP && v_count < WALL_TOP + 10) || (v_count >= WALL_BOTTOM && v_count < WALL_BOTTOM + 10) ) ||
                        ( (h_count >= H_SYNC + H_BACK && h_count < H_SYNC + H_BACK + 10) || (h_count >= H_SYNC + H_BACK + H_DISPLAY - 10 && h_count < H_SYNC + H_BACK + H_DISPLAY));
    

    reg pixel_clk;
    always @(posedge i_Clk or posedge i_Rst) begin
        if (i_Rst)
            pixel_clk <= 0;
        else
            pixel_clk <= ~pixel_clk;
    end

    reg worm_active;
    integer j;
    always @(posedge pixel_clk or posedge i_Rst) begin
        if (i_Rst) begin
            h_count = 0;
            v_count = 0;
            o_red = 0;
            o_green = 0;
            o_blue = 0;
            worm_active = 0;
        end else begin
            if (h_count < H_TOTAL - 1) begin
                h_count = h_count + 1;
            end else begin
                h_count = 0;
                if (v_count < V_TOTAL - 1) begin
                    v_count = v_count + 1;
                end else begin
                    v_count = 0;
                end
            end

            worm_active = 0;
            for (j=0; j < i_size && j < MAX_SIZE; j=j+1) begin
                if ((h_count - (H_SYNC + H_BACK) >= i_worm_x[j*6+:6] * PIXEL_SIZE) && (h_count - (H_SYNC + H_BACK) < (i_worm_x[j*6+:6] * PIXEL_SIZE) + PIXEL_SIZE )&&
                    (v_count - (V_SYNC + V_BACK) >= i_worm_y[j*6+:6] * PIXEL_SIZE ) && ( v_count - (V_SYNC + V_BACK) < (i_worm_y[j*6+:6] * PIXEL_SIZE) + PIXEL_SIZE)) begin
                        worm_active = 1;
                end
            end
            if (active_area) begin

                if (worm_active) begin
                    o_red = 4'hF;
                    o_green = 4'h0;
                    o_blue = 4'h0;

                end else if (item_active) begin
                    o_red = 4'h0;
                    o_green = 4'hF;
                    o_blue = 4'h0;
                end else if (edge_active) begin
                    o_red = 4'hF;
                    o_green = 4'hF;
                    o_blue = 4'hF;
                end else begin
                    o_red = 4'h0;
                    o_green = 4'h0;
                    o_blue = 4'h0;
                end
            end else begin
                o_red = 4'h0;
                o_green = 4'h0;
                o_blue = 4'h0;
            end
        end
    end
endmodule
