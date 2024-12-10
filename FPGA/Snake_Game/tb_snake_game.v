`timescale 1 ns / 1 ns
`include "snake_game.v"
`include "SetHead.v"
`include "Vga.v"
`include "Generate_Item_Pos.v"
`include "LFSR.v"

module	tb_SetHead();

reg	Clk;
reg	Rst;

reg [3:0] i_Push;

always
	#10 Clk = ~Clk;

Snake_Game G0(Clk, Rst, i_Pause, i_Push,
              , , , , , , , );

initial begin
	$dumpfile("test_out.vcd");
	$dumpvars;
end

initial
begin
	Clk			= 1;
	Rst			= 0;
    i_Push      = 4'b1111;
    i_Pause     = 0;

	@(negedge Clk)	Rst = 1;

    #100 i_Push = 4'b1110;
    #100000 i_Pause = 1;
    #10000 i_Pause = 0;

    #50000 i_Push = 4'b1101;
    #50000 i_Push = 4'b1011;
    #50000 i_Push = 4'b0111;

	$stop;
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

