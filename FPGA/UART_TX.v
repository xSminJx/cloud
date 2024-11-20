module UART_TX(
	i_Clk, i_Rst,
	i_fTx, i_Data,
	o_fDone, o_fReady, o_Tx
);
input i_Clk, i_Rst;
input i_fTx;
input [7:0] i_Data;

output o_fDone, o_fReady, o_Tx;

wire fLstClk;
wire fLstBit;

reg [8:0] c_ClkCnt, n_ClkCnt,
		  c_Data,	n_Data;
reg [2:0] c_BitCnt, n_BitCnt;
reg [1:0] c_State , n_State;

parameter BAUD = 115200;
parameter LSTCLk = 50_000_000 / BAUD;
parameter IDLE 	   = 2'b00,
		  TX_START = 2'b01,
		  TX_DATA  = 2'b10,
		  TX_STOP  = 2'b11;

assign fLstClk  = c_ClkCnt == LSTCLk;
assign fLstBit  = fLstClk && &c_BitCnt;

assign o_fDone  = c_State == TX_STOP && fLstClk;
assign o_fReady = c_State == IDLE;
assign o_Tx		= c_Data[0];


always @(posedge i_Clk, negedge i_Rst) begin
	if(!i_Rst) begin
		c_ClkCnt = 0;
		c_Data   = 9'b111111111;
		c_BitCnt = 0;
		c_State  = IDLE;
	end
	else begin
		c_ClkCnt = n_ClkCnt;
		c_Data   = n_Data;
		c_BitCnt = n_BitCnt;
		c_State  = n_State;
	end
end

always @* begin
	n_ClkCnt = c_ClkCnt;
	n_BitCnt = 0;
	n_Data	 = c_Data;
	case(c_State)
		IDLE : begin
			n_ClkCnt = 0;
			n_Data = i_fTx ? {i_Data,1'b0} : c_Data;
			if(i_fTx) n_State = TX_START;
		end
		TX_START : begin
			n_ClkCnt = fLstClk ? 0 : c_ClkCnt + 1;
			if(fLstClk) n_State = TX_DATA;
			n_Data = fLstClk ? {1'b1,c_Data[8:1]} : c_Data;
		end
		TX_DATA : begin
			n_ClkCnt = fLstClk ? 0 : c_ClkCnt + 1;
			n_BitCnt = fLstClk ? c_BitCnt + 1 : c_BitCnt;
			n_Data = fLstClk ? {1'b1,c_Data[8:1]} : c_Data;
			if(fLstBit)  n_State  = TX_STOP;
		end
		TX_STOP : begin
			n_ClkCnt = fLstClk ? 0 : c_ClkCnt + 1;
			n_State = fLstClk ? IDLE : c_State;
			if(fLstClk) n_State = IDLE;
		end
	endcase
end

endmodule
