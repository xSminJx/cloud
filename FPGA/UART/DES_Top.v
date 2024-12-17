module DES_Top(
	i_Clk, i_Rst,
	i_Rx,
	o_Tx, o_LED
);

input i_Clk, i_Rst;
input i_Rx;

output [9:0] o_LED;
output o_Tx;

wire [63:0] DES_o_Data;
wire [7:0] RX_o_Data, TX_i_DATA;
wire RX_o_fDone, TX_o_fDone, TX_o_fReady;
wire Tx_i_fTx, DES_i_fStart, DES_o_fDone, fLstByte;

reg [63:0] c_Key     , n_Key,
		   c_Text    , n_Text;
reg [2:0]  c_State   , n_State,
		   c_ByteCnt , n_ByteCnt;
reg [1:0]  c_Cmd     , n_Cmd;

parameter IDLE 		= 3'b000,
		  RX_KEY 	= 3'b001,
		  RX_TEXT 	= 3'b010,
		  START_DES = 3'b011,
		  WAIT_DES 	= 3'b100,
		  TX_RES 	= 3'b101,
		  TX_TEXT 	= 3'b110;


UART_RX R0 (i_Clk, i_Rst, i_Rx, RX_o_fDone, RX_o_Data);
UART_TX T0 (i_Clk, i_Rst, Tx_i_fTx, TX_i_DATA, TX_o_fDone, TX_o_fReady, o_Tx);
DES 	DES0 (i_Clk, i_Rst, DES_i_fStart, c_Cmd[0], c_Key, c_Text, DES_o_fDone, DES_o_Data);

assign Tx_i_fTx = TX_o_fReady && (c_State == TX_RES || c_State == TX_TEXT);
assign TX_i_DATA = c_State == TX_RES ? c_Cmd : c_Text[63:56];
assign DES_i_fStart = c_State == START_DES;
assign fLstByte = c_ByteCnt == 3'h7;

assign o_LED[0] = i_Clk;
assign o_LED[1] = (c_Key != 0);
assign o_LED[2] = (c_State == IDLE);
assign o_LED[3] = (c_State == RX_KEY);
assign o_LED[4] = (c_State == RX_TEXT);

always @(posedge i_Clk, negedge i_Rst) begin
	if(!i_Rst) begin
		c_Key = 0;
		c_Text = 0;
		c_State = IDLE;
		c_ByteCnt = 0;
		c_Cmd = 0;
	end
	else begin
		c_Key     = n_Key;
		c_Text    = n_Text;
		c_State   = n_State;
		c_ByteCnt = n_ByteCnt;
		c_Cmd     = n_Cmd;
	end
end

always @* begin
	n_Cmd 	  = c_Cmd;
	n_Text 	  = c_Text;
	n_Key 	  = c_Key;
	n_ByteCnt = 0;
	n_State = c_State;

	case (c_State)
		IDLE	: begin
			if(RX_o_fDone) begin
				n_Cmd = RX_o_Data;
				n_State = RX_o_Data[1] ? RX_TEXT : RX_KEY;
			end
		end
		RX_KEY	: begin
			n_Key = RX_o_fDone ? {c_Key[55:0],RX_o_Data} : c_Key;
			n_ByteCnt = RX_o_fDone ? c_ByteCnt + 1 : c_ByteCnt;
			if(RX_o_fDone && fLstByte) n_State = TX_RES;
		end
		RX_TEXT	: begin
			n_Text = RX_o_fDone ? {c_Text[55:0],RX_o_Data} : c_Text;
			n_ByteCnt = RX_o_fDone ? c_ByteCnt + 1 : c_ByteCnt;
			if(RX_o_fDone && fLstByte) n_State = START_DES;
		end
		START_DES	: begin
			n_State = WAIT_DES;
		end
		WAIT_DES	: begin
			n_Text = DES_o_fDone ? DES_o_Data : c_Text;
			if(DES_o_fDone) n_State = TX_RES;
		end
		TX_RES	: begin
			if(!c_Cmd[1]) n_State = IDLE;
			else if(TX_o_fDone) n_State = TX_TEXT;
		end
		TX_TEXT	: begin
			n_ByteCnt = TX_o_fDone ? c_ByteCnt + 1 : c_ByteCnt;
			n_Text = TX_o_fDone ? {c_Text[55:0],RX_o_Data} : c_Text;
			if(TX_o_fDone && fLstByte) n_State = IDLE;
		end
	endcase
end

endmodule
