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
    o_blue,    
    o_sync,
    o_blank,
    o_clk
);
    input i_Clk;
    input i_Rst;

    parameter MAX_SIZE = 20;
    input [MAX_SIZE*6 - 1: 0] i_worm_x;
    input [MAX_SIZE*6 - 1: 0] i_worm_y;

    input [5:0] i_item_x;
    input [5:0] i_item_y;

    input [19:0] i_size;

    output o_hsync;
    output o_vsync;

    output [7:0] o_red;
    output [7:0] o_green;
    output [7:0] o_blue;
    output o_sync;
    output o_blank;
    output o_clk;

    parameter [9:0] H_ACTIVE  =  10'd639 ;
    parameter [9:0] H_FRONT   =  10'd15 ;
    parameter [9:0] H_PULSE   =  10'd95 ;
    parameter [9:0] H_BACK    =  10'd47 ;

    parameter [9:0] V_ACTIVE   =  10'd479 ;
    parameter [9:0] V_FRONT    =  10'd9 ;
    parameter [9:0] V_PULSE    =  10'd1 ;
    parameter [9:0] V_BACK     =  10'd32 ;

    parameter   LOW     = 1'b0;
    parameter   HIGH    = 1'b1;

    parameter   [7:0]   H_ACTIVE_STATE    = 8'd0 ;
    parameter   [7:0]   H_FRONT_STATE     = 8'd1 ;
    parameter   [7:0]   H_PULSE_STATE     = 8'd2 ;
    parameter   [7:0]   H_BACK_STATE      = 8'd3 ;

    parameter   [7:0]    V_ACTIVE_STATE    = 8'd0 ;
    parameter   [7:0]   V_FRONT_STATE     = 8'd1 ;
    parameter   [7:0]   V_PULSE_STATE    = 8'd2 ;
    parameter   [7:0]   V_BACK_STATE     = 8'd3 ;

    parameter PIXEL_SIZE = 10;
    wire [9:0] item_x_scaled = i_item_x * PIXEL_SIZE;
    wire [9:0] item_y_scaled = i_item_y * PIXEL_SIZE;


    reg              n_hysnc;
    reg              n_vsync;
    reg     [7:0]    n_red;
    reg     [7:0]    n_green;
    reg     [7:0]    n_blue;
    reg              line_done;

    reg     [9:0]   h_counter;
    reg     [9:0]   v_counter;

    reg     [7:0]    h_state;
    reg     [7:0]    v_state;
	 

    reg worm_active;

    wire edge_active =  ( (v_counter >= 0 && v_counter < 10) || (v_counter >= 470 && v_counter < 480) ||
                         (h_counter >= 0 && h_counter < 10) || (h_counter >= 630 && h_counter < 640));

    wire item_active =  ( (h_counter >= item_y_scaled && h_counter < item_y_scaled + 10) &&
                         (v_counter >= item_x_scaled && v_counter < item_x_scaled + 10));

	 reg clk_25m;
    always @(posedge i_Clk or negedge i_Rst) begin
        if (!i_Rst)
            clk_25m <= 0;
        else
            clk_25m <= ~clk_25m;
    end

    integer j;

    always@(posedge clk_25m, negedge i_Rst) begin
        if (!i_Rst) begin
            h_counter = 10'd0;
            v_counter = 10'd0;
            h_state   = H_ACTIVE_STATE;
            v_state   = V_ACTIVE_STATE;
            line_done   = LOW ;
        end
        else begin
            
            if (h_state == H_ACTIVE_STATE) begin
                h_counter <= (h_counter==H_ACTIVE)?10'd_0:(h_counter + 10'd1) ;
                n_hysnc <= HIGH ;
                line_done <= LOW ;
                h_state <= (h_counter == H_ACTIVE)?H_FRONT_STATE:H_ACTIVE_STATE ;
            end
            if (h_state == H_FRONT_STATE) begin
                h_counter <= (h_counter==H_FRONT)?10'd_0:(h_counter + 10'd1) ;
                n_hysnc <= HIGH ;
                h_state <= (h_counter == H_FRONT)?H_PULSE_STATE:H_FRONT_STATE ;
            end
            if (h_state == H_PULSE_STATE) begin
                h_counter <= (h_counter==H_PULSE)?10'd_0:(h_counter + 10'd1) ;
                n_hysnc <= LOW ;
                h_state <= (h_counter == H_PULSE)?H_BACK_STATE:H_PULSE_STATE ;
            end
            if (h_state == H_BACK_STATE) begin
                h_counter <= (h_counter==H_BACK)?10'd_0:(h_counter + 10'd1) ;
                n_hysnc <= HIGH ;
                h_state <= (h_counter == H_BACK)?H_ACTIVE_STATE:H_BACK_STATE ;
                line_done <= (h_counter == (H_BACK-1))?HIGH:LOW ;
            end

            if (v_state == V_ACTIVE_STATE) begin
                v_counter<=(line_done==HIGH)?((v_counter==V_ACTIVE)?10'd_0:(v_counter+10'd1)):v_counter ;
                n_vsync <= HIGH ;
                v_state<=(line_done==HIGH)?((v_counter==V_ACTIVE)?V_FRONT_STATE:V_ACTIVE_STATE):V_ACTIVE_STATE ;
            end
            if (v_state == V_FRONT_STATE) begin
                v_counter<=(line_done==HIGH)?((v_counter==V_FRONT)?10'd_0:(v_counter + 10'd1)):v_counter ;
                n_vsync <= HIGH;
                v_state<=(line_done==HIGH)?((v_counter==V_FRONT)?V_PULSE_STATE:V_FRONT_STATE):V_FRONT_STATE;
            end
            if (v_state == V_PULSE_STATE) begin
                v_counter<=(line_done==HIGH)?((v_counter==V_PULSE)?10'd_0:(v_counter + 10'd1)):v_counter ;
                n_vsync <= LOW ;
                v_state<=(line_done==HIGH)?((v_counter==V_PULSE)?V_BACK_STATE:V_PULSE_STATE):V_PULSE_STATE;
            end
            if (v_state == V_BACK_STATE) begin
                v_counter<=(line_done==HIGH)?((v_counter==V_BACK)?10'd_0:(v_counter + 10'd1)):v_counter ;
                n_vsync <= HIGH;
                v_state<=(line_done==HIGH)?((v_counter==V_BACK)?V_ACTIVE_STATE:V_BACK_STATE):V_BACK_STATE ;
            end

            worm_active = 0;
            for (j=0; j < i_size && j < MAX_SIZE; j=j+1) begin
                if ((v_counter >= i_worm_x[j*6+:6] * PIXEL_SIZE) && (v_counter < (i_worm_x[j*6+:6] * PIXEL_SIZE) + PIXEL_SIZE )&&
                    (h_counter >= i_worm_y[j*6+:6] * PIXEL_SIZE ) && ( h_counter < (i_worm_y[j*6+:6] * PIXEL_SIZE) + PIXEL_SIZE)) begin
                        worm_active = 1;
                end
            end
           
            if (h_state == H_ACTIVE_STATE && v_state == V_ACTIVE_STATE) begin
                if (edge_active) begin
                    n_red   = 8'hFF;
                    n_green = 8'hFF;
                    n_blue  = 8'hFF;
                end else if (item_active) begin
                    n_red   = 8'h00;
                    n_green = 8'hFF;
                    n_blue  = 8'h00;
                end else if (worm_active) begin
                    n_red   = 8'hFF;
                    n_green = 8'h00;
                    n_blue  = 8'h00;
                end else begin
                    n_red   = 8'h00;
                    n_green = 8'h00;
                    n_blue  = 8'h00;
                end
            end else begin
                n_red   = 8'hFF;
                n_green = 8'hFF;
                n_blue  = 8'hFF;
            end

          end
      end
    assign o_hsync = n_hysnc ;
    assign o_vsync = n_vsync ;
    assign o_red   = n_red ;
    assign o_green = n_green ;
    assign o_blue  = n_blue ;
    assign o_clk   = clk_25m ;
    assign o_sync  = 1'b0 ;
    assign o_blank = n_hysnc & n_vsync ;

endmodule