module Rx_Top(
	i_Clk, i_Rst,
    i_Rx,
    o_FND0, o_FND1
);

input i_Clk, i_Rst;
input i_Rx;

output [6:0] o_FND0, o_FND1;

wire [7:0] o_Data;
wire o_fDone;

reg [3:0] c_FND0, n_FND0,
          c_FND1, n_FND1;

FND FND0 (c_FND0, o_FND0);
FND FND1 (c_FND1, o_FND1);

UART_RX U0 (i_Clk, i_Rst, i_Rx, o_fDone, o_Data);

always @(posedge i_Clk, negedge i_Rst) begin
	if(!i_Rst) begin
        c_FND0 = 0;
        c_FND1 = 0;
	end
	else begin
        c_FND0   = n_FND0;
        c_FND1   = n_FND1;
	end
end

always @* begin
    n_FND0 = c_FND0;
    n_FND1 = c_FND1;
    if(o_fDone) begin
        n_FND0 = o_Data[3:0];
        n_FND1 = o_Data[7:4];
    end
end

endmodule
