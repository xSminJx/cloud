module FND(i_sel,o_out);
  input [3:0]i_sel;
  output reg [6:0]o_out;
  
  always@*
  case(i_sel)
    4'h0:o_out=7'b1000000;
    4'h1:o_out=7'b1111001;
    4'h2:o_out=7'b0100100;
    4'h3:o_out=7'b0110000;
    4'h4:o_out=7'b0011001;
    4'h5:o_out=7'b0010010;
    4'h6:o_out=7'b0000010;
    4'h7:o_out=7'b1011000; 
    4'h8:o_out=7'b0000000;
    4'h9:o_out=7'b0010000;
	 default o_out=7'b1111111;
  endcase
endmodule