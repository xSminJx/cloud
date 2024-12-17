`timescale 1ns/1ps

module Vga_tb;
    reg i_Clk;
    reg i_Rst;

    parameter MAX_SIZE = 100;
    reg [MAX_SIZE * 6 - 1:0] i_worm_x;
    reg [MAX_SIZE * 6 - 1:0] i_worm_y;
    reg [5:0] i_item_x;
    reg [5:0] i_item_y;
    reg [11:0] i_size;

    // 출력 신호 선언
    wire o_hsync;
    wire o_vsync;
    wire [3:0] o_red;
    wire [3:0] o_green;
    wire [3:0] o_blue;

    Vga uut (
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),
        .i_worm_x(i_worm_x),
        .i_worm_y(i_worm_y),
        .i_item_x(i_item_x),
        .i_item_y(i_item_y),
        .i_size(i_size),
        .o_hsync(o_hsync),
        .o_vsync(o_vsync),
        .o_red(o_red),
        .o_green(o_green),
        .o_blue(o_blue)
    );

    always begin
        #10 i_Clk = ~i_Clk;  // 10ns 주기 (50MHz)
    end

    initial begin
        i_Clk = 0;
        i_Rst = 1;
        i_worm_x = 0;
        i_worm_y = 0;
        i_item_x = 0;
        i_item_y = 0;
        i_size = 0;

        #50 i_Rst = 0;

        #100 begin
            i_size = 12'd5;
            i_worm_x[5:0] = 6'd2;
            i_worm_x[11:6] = 6'd3;
            i_worm_x[17:12] = 6'd4;
            i_worm_x[23:18] = 6'd5;
            i_worm_x[29:24] = 6'd6;
            i_worm_x[MAX_SIZE * 6 - 1:30] = 0;

            i_worm_y[5:0] = 6'd4;
            i_worm_y[11:6] = 6'd4;
            i_worm_y[17:12] = 6'd4;
            i_worm_y[23:18] = 6'd4;
            i_worm_y[29:24] = 6'd;
            i_worm_y[MAX_SIZE * 6 - 1:30] = 0;

            i_item_x = 6'd10;
            i_item_y = 6'd10;
        end
    end
endmodule
