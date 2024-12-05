module SetHead(
    i_Clk, i_Rst,
    i_Way, i_Push, i_Head_x, i_Head_y,
    o_Head_x, o_Head_y, o_Way
);

    input i_Clk, i_Rst;
    input [1:0] i_Way;
    input [3:0] i_Push;
    input [6:0] i_Head_x, i_Head_y;

    output [6:0] o_Head_x, o_Head_y;
    output [1:0] o_Way;
    parameter   UP    = 0,
              	DOWN  = 1,
              	RIGHT = 2,
              	LEFT  = 3;

	wire isUnway = (!i_Push[UP] && i_Way==DOWN) ||
				     (!i_Push[DOWN] && i_Way==UP) ||
				     (!i_Push[RIGHT] && i_Way==LEFT) ||
				     (!i_Push[LEFT] && i_Way==RIGHT);

    wire [1:0] Push = !i_Push[0] ? 0 :
                      !i_Push[1] ? 1 :
                      !i_Push[2] ? 2 : 3;

    assign o_Way = isUnway ? i_Way : Push;
    assign o_Head_x = isUnway ? i_Head_x + (i_Way == UP ? -1 : (i_Way == DOWN ? 1 : 0)) : i_Head_x + (!i_Push[UP] ? -1 : (!i_Push[DOWN] ? 1 : 0));
    assign o_Head_y = isUnway ? i_Head_y + (i_Way == LEFT ? -1 : (i_Way == RIGHT ? 1 : 0)) : i_Head_x + (!i_Push[LEFT] ? -1 : (!i_Push[RIGHT] ? 1 : 0));

endmodule