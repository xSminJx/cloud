`timescale 1 ns / 1 ns

module	tb_SetHead();

reg	Clk;
reg	Rst;

reg [3:0] i_Push;
reg i_Pause;
always
	#10 Clk = ~Clk;

Snake_Game G0(Clk, Rst, i_Pause, i_Push,
              , , , , , , , );

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
    #200000;

	$stop;
end

endmodule

