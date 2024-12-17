module UART_Top(
	i_Clk, i_Rst,
	i_Rx, i_Push,
	o_Tx, o_FND0, o_FND1
);

input i_Clk, i_Rst;
input i_Rx;
input [3:0] i_Push;

output [6:0] o_FND0, o_FND1;
output o_Tx;

wire [7:0] o_Data, TX_DATA;
wire o_fDoneRX, o_fDoneTX, o_fReady;
wire Tx_i_fTx, n_nPush;

reg [3:0] c_FND0,  n_FND0,
          c_FND1,  n_FND1;
reg 	  c_fPush, n_fPush;

FND16 FND0 (c_FND0, o_FND0);
FND16 FND1 (c_FND1, o_FND1);

UART_RX R0 (i_Clk, i_Rst, i_Rx, o_fDoneRX, o_Data);
UART_TX T0 (i_Clk, i_Rst, Tx_i_fTx, TX_DATA, o_fDoneTX, o_fReady, o_Tx);

assign n_nPush = n_fPush;
assign Tx_i_fTx = c_fPush && !n_nPush;
assign TX_DATA = 
    (i_Push == 4'b1110) ? 8'd1 :
    (i_Push == 4'b1101) ? 8'd2 :
    (i_Push == 4'b1011) ? 8'd3 : 8'd0;

always @(posedge i_Clk, negedge i_Rst) begin
	if(!i_Rst) begin
		c_FND0 		= 0;
        c_FND1 		= 0;
		c_fPush 	= 1;
	end
	else begin
		c_FND0 		= n_FND0;
		c_FND1 		= n_FND1;
		c_fPush 	= n_fPush;
	end
end

always @* begin
	n_fPush = &i_Push;

    if(o_fDoneRX) begin
        n_FND0 = o_Data[3:0];
        n_FND1 = o_Data[7:4];
    end
	else begin
    	n_FND0  = c_FND0;
    	n_FND1  = c_FND1;
	end
end

endmodule
