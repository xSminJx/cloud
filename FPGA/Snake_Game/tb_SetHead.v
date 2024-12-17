`timescale 1 ns / 1 ns
`include "snake_game.v"
`include "SetHead.v"
`include "SpeedFND.v"
`include "ScoreFND.v"
`include "FND.v"
`include "Vga.v"
module	tb_SetHead();

reg	Clk;
reg	Rst;

reg [1:0] i_Way;
reg [3:0] i_Push;
reg [5:0] i_Head_x, i_Head_y;

always
	#10 Clk = ~Clk;

SetHead S0(Clk, Rst, i_Way, i_Push, i_Head_x, i_Head_y, , ,);

initial begin
	$dumpfile("test_out.vcd");
	$dumpvars;
end

initial
begin
	Clk			= 1;
	Rst			= 0;
	i_Way = 0;
    i_Push = 4'b1111;
    i_Head_x = 1;
    i_Head_y = 1;

	@(negedge Clk)	Rst = 1;

    #100 input_data(4'b1110);
    #100 input_data(4'b1101);
    #100 input_data(4'b1011);
    #100 input_data(4'b0111);


	#100 $stop;
	$finish;
end

task input_data;
    input [3:0] i_Data;
    begin
        i_Push = i_Data;
        #10 i_Way = 0;
        #10 i_Way = 1;
        #10 i_Way = 2;
        #10 i_Way = 3;
    end
endtask

endmodule

