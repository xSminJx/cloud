`timescale 1 ns / 1 ns
module	tb_UART_Top();

reg	Clk;
reg	Rst;

wire			TOP_i_Rx;
wire			TOP_o_Tx;
reg		[3:0]	TOP_i_Push;

reg				Tx_i_fTx;
reg		[ 7:0]	Tx_i_Data;		// 1 byte to transmit
wire			Tx_o_fDone;		// when transmition is o_fDone
wire			Tx_o_fReady;	// when there is no data to transmit
wire			Tx_o;			// uart txd signal

wire			Rx_i;			// uart rxd signal
wire			Rx_o_fDone;		// when there is received data
wire	[7:0]	Rx_o_Data;			// received byte 
reg		[7:0]	RxData;


UART_Top	TOP(Clk, Rst, TOP_i_Rx, TOP_i_Push, TOP_o_Tx, , );
UART_TX 	TX0(Clk, Rst, Tx_i_fTx, Tx_i_Data,	Tx_o_fDone, Tx_o_fReady, Tx_o);
UART_RX 	RX0(Clk, Rst,			Rx_i,		Rx_o_fDone, Rx_o_Data);

assign	Rx_i		= TOP_o_Tx,
		TOP_i_Rx	= Tx_o;

always
	#10 Clk = ~Clk;

always@* begin
	RxData = 0;
	if(Rx_o_fDone)	begin
		$display("Rx Data: %x", Rx_o_Data);
		RxData = Rx_o_Data;
	end
end


initial
begin
	Clk			= 1;
	Rst			= 0;
	Tx_i_fTx	= 0;
	Tx_i_Data	= 0;
	TOP_i_Push	= 4'b1111;

	@(negedge Clk)	Rst = 1;
	TxByte(8'h3c);
	TxByte(8'he5);

	Push(0);
	Push(1);
	Push(2);
	Push(3);


	#5000 $stop;
end

task TxByte;
input	[7:0]	i_Data;
begin
	wait(Tx_o_fReady)	Tx_i_fTx = 1;	Tx_i_Data = i_Data;
	@(posedge Clk)		Tx_i_fTx = 0;	
	@(posedge Tx_o_fDone);
end
endtask

task Push;
input	[1:0]	i_Num;
begin
	case(i_Num)
		2'h0	:	TOP_i_Push	= 4'b1110;
		2'h1	:	TOP_i_Push	= 4'b1101;
		2'h2	:	TOP_i_Push	= 4'b1011;
		default	:	TOP_i_Push	= 4'b0111;
	endcase
	wait(Rx_o_fDone) TOP_i_Push = 4'b1111; #10000;
end
endtask

endmodule

