module UART_RX(
	i_Clk, i_Rst,
	i_Rx,
	o_fDone, o_Data
);
input i_Clk, i_Rst;
input i_Rx;

output o_fDone;
output [7:0] o_Data;

wire fLstClk;
wire fCapture;
wire fLstBit;

reg [8:0] c_ClkCnt, n_ClkCnt;
reg [7:0] c_Data  , n_Data;
reg [2:0] c_BitCnt, n_BitCnt;
reg [1:0] c_State , n_State;
reg 	  c_Rx	  , n_Rx;

parameter BAUD = 115200;
parameter LSTCLk = 50_000_000 / BAUD;
parameter IDLE 	   = 2'b00,
		  RX_START = 2'b01,
		  RX_DATA  = 2'b10,
		  RX_STOP  = 2'b11;

assign fLstClk  = c_ClkCnt == LSTCLk;
assign fCapture = c_ClkCnt == LSTCLk/2;
assign fLstBit  = fLstClk && &c_BitCnt;

assign o_fDone = c_State == RX_STOP;
assign o_Data  = o_fDone ? c_Data : 0;

always @(posedge i_Clk, negedge i_Rst) begin
	if(!i_Rst) begin
		c_ClkCnt = 0;
		c_Data   = 0;
		c_BitCnt = 0;
		c_State  = 0;
		c_Rx     = 0;
	end
	else begin
		c_ClkCnt = n_ClkCnt;
		c_Data   = n_Data;
		c_BitCnt = n_BitCnt;
		c_State  = n_State;
		c_Rx	 = i_Rx;	
	end
end

always @* begin
	n_Rx	 = i_Rx;
	n_State  = c_State;
	n_BitCnt = 0;
	n_ClkCnt = 0;
	n_Data 	 = c_Data;
	case(c_State)
		IDLE : begin
			n_Data   = 0;
			if(!c_Rx) n_State = RX_START;
		end
		RX_START : begin
			n_ClkCnt = fLstClk ? 0 : c_ClkCnt + 1;
			if(fLstClk) n_State = RX_DATA;
		end
		RX_DATA : begin
			n_ClkCnt = fLstClk ? 0 : c_ClkCnt + 1;
			n_BitCnt = fLstClk ? c_BitCnt + 1 : c_BitCnt;
			if(fCapture) n_Data   = {c_Rx,c_Data[7:1]};
			if(fLstBit)  n_State  = RX_STOP;
		end
		RX_STOP : begin
			n_State = IDLE;
		end
	endcase
end

endmodule
