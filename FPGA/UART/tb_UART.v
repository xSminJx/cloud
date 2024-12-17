`timescale 1 ns / 1 ns
module	tb_UART();

reg	Clk;
reg	Rst;

reg				Tx_i_fTx;
reg		[ 7:0]	Tx_i_Data;		// 1 byte to transmit
wire			Tx_o_fDone;		// when transmition is o_fDone
wire			Tx_o_fReady;	// when there is no data to transmit
wire			Tx_o;			// uart txd signal

wire			Rx_i;			// uart rxd signal
wire			Rx_o_fDone;		// when there is received data
wire	[7:0]	Rx_o_Data;			// received byte 
reg		[7:0]	RxData;


UART_TX TX0(Clk, Rst, Tx_i_fTx, Tx_i_Data,	Tx_o_fDone, Tx_o_fReady, Tx_o);
UART_RX RX0(Clk, Rst,			Rx_i,		Rx_o_fDone, Rx_o_Data);

assign	Rx_i = Tx_o;

always
	#10 Clk = ~Clk;

always@*
	if(Rx_o_fDone)	begin
		$display("Rx Data: %x", Rx_o_Data);
		RxData = Rx_o_Data;
	end

initial
begin
	Clk			= 1;
	Rst			= 0;
	Tx_i_fTx	= 0;
	Tx_i_Data	= 0;
	RxData		= 0;

	@(negedge Clk)	Rst = 1;
	TxByte(8'h3c);
	TxByte(8'he5);

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

endmodule

