module	ROL(i_Data, i_fRight, i_f1bit, o_Data);
input		[27:0]	i_Data;
input		i_fRight;
input		i_f1bit;
output	reg	[27:0]	o_Data;

always@*
	case({i_fRight, i_f1bit})
		2'b00	:	o_Data	 = {i_Data[25:0], i_Data[27:26]};	 // ROL2
		2'b01	:	o_Data	 = {i_Data[26:0], i_Data[27   ]};	 // ROL1
		2'b10	:	o_Data	 = {i_Data[ 1:0], i_Data[27: 2]};	 // ROR2
		default	:	o_Data	 = {i_Data[   0], i_Data[27: 1]};	 // ROR1
	endcase

endmodule

/*--------------------------------------------------------------------------------------------------------------*/

module	IP(i_Data, o_Data);
input			[63:0]	i_Data;
output	wire	[63:0]	o_Data;

assign o_Data = {	i_Data[ 6], i_Data[14], i_Data[22], i_Data[30], i_Data[38], i_Data[46], i_Data[54], i_Data[62], 
					i_Data[ 4], i_Data[12], i_Data[20], i_Data[28], i_Data[36], i_Data[44], i_Data[52], i_Data[60], 
					i_Data[ 2], i_Data[10], i_Data[18], i_Data[26], i_Data[34], i_Data[42], i_Data[50], i_Data[58], 
					i_Data[ 0], i_Data[ 8], i_Data[16], i_Data[24], i_Data[32], i_Data[40], i_Data[48], i_Data[56],
					i_Data[ 7], i_Data[15], i_Data[23], i_Data[31], i_Data[39], i_Data[47], i_Data[55], i_Data[63], 
					i_Data[ 5], i_Data[13], i_Data[21], i_Data[29], i_Data[37], i_Data[45], i_Data[53], i_Data[61], 
					i_Data[ 3], i_Data[11], i_Data[19], i_Data[27], i_Data[35], i_Data[43], i_Data[51], i_Data[59], 
					i_Data[ 1], i_Data[ 9], i_Data[17], i_Data[25], i_Data[33], i_Data[41], i_Data[49], i_Data[57]};
endmodule

/*--------------------------------------------------------------------------------------------------------------*/
module	InvIP(i_Data, o_Data);
input			[63:0]	i_Data;
output	wire	[63:0]	o_Data;

assign o_Data = {	i_Data[24], i_Data[56], i_Data[16], i_Data[48], i_Data[ 8], i_Data[40], i_Data[ 0], i_Data[32], 
					i_Data[25], i_Data[57], i_Data[17], i_Data[49], i_Data[ 9], i_Data[41], i_Data[ 1], i_Data[33], 
					i_Data[26], i_Data[58], i_Data[18], i_Data[50], i_Data[10], i_Data[42], i_Data[ 2], i_Data[34], 
					i_Data[27], i_Data[59], i_Data[19], i_Data[51], i_Data[11], i_Data[43], i_Data[ 3], i_Data[35], 
					i_Data[28], i_Data[60], i_Data[20], i_Data[52], i_Data[12], i_Data[44], i_Data[ 4], i_Data[36], 
					i_Data[29], i_Data[61], i_Data[21], i_Data[53], i_Data[13], i_Data[45], i_Data[ 5], i_Data[37], 
					i_Data[30], i_Data[62], i_Data[22], i_Data[54], i_Data[14], i_Data[46], i_Data[ 6], i_Data[38], 
					i_Data[31], i_Data[63], i_Data[23], i_Data[55], i_Data[15], i_Data[47], i_Data[ 7], i_Data[39]};
endmodule

/*--------------------------------------------------------------------------------------------------------------*/

module	E_Table(i_Data, o_Data);
input			[31:0]	i_Data;
output	wire	[47:0]	o_Data;

assign o_Data = {	i_Data[0],		i_Data[31:27],
					i_Data[28:23],	i_Data[24:19],
					i_Data[20:15],	i_Data[16:11],
					i_Data[12: 7],	i_Data[ 8: 3],
					i_Data[ 4: 0],	i_Data[31]};
endmodule

/*--------------------------------------------------------------------------------------------------------------*/

module	P_Table(i_Data, o_Data);
input			[31:0]	i_Data;
output	wire	[31:0]	o_Data;

assign o_Data = {	i_Data[16], i_Data[25], i_Data[12], i_Data[11], 
					i_Data[ 3], i_Data[20], i_Data[ 4], i_Data[15], 
					i_Data[31], i_Data[17], i_Data[ 9], i_Data[ 6],
					i_Data[27], i_Data[14], i_Data[ 1], i_Data[22], 
					i_Data[30], i_Data[24], i_Data[ 8], i_Data[18], 
					i_Data[ 0], i_Data[ 5], i_Data[29], i_Data[23], 
					i_Data[13], i_Data[19], i_Data[ 2], i_Data[26], 
					i_Data[10], i_Data[21], i_Data[28], i_Data[ 7]};
endmodule

/*--------------------------------------------------------------------------------------------------------------*/

module	PC1(i_Data, o_Data);
input			[63:0]	i_Data;
output	wire	[55:0]	o_Data;


assign o_Data = {	i_Data[ 7], i_Data[15], i_Data[23], i_Data[31], i_Data[39], i_Data[47], i_Data[55], 
					i_Data[63], i_Data[ 6], i_Data[14], i_Data[22], i_Data[30], i_Data[38], i_Data[46], 
					i_Data[54], i_Data[62], i_Data[ 5], i_Data[13], i_Data[21], i_Data[29], i_Data[37], 
					i_Data[45], i_Data[53], i_Data[61], i_Data[ 4], i_Data[12], i_Data[20], i_Data[28],
					i_Data[ 1], i_Data[ 9], i_Data[17], i_Data[25], i_Data[33], i_Data[41], i_Data[49], 
					i_Data[57], i_Data[ 2], i_Data[10], i_Data[18], i_Data[26], i_Data[34], i_Data[42], 
					i_Data[50], i_Data[58], i_Data[ 3], i_Data[11], i_Data[19], i_Data[27], i_Data[35], 
					i_Data[43], i_Data[51], i_Data[59], i_Data[36], i_Data[44], i_Data[52], i_Data[60]};
endmodule

/*--------------------------------------------------------------------------------------------------------------*/

module	PC2(i_Data, o_Data);
input			[55:0]	i_Data;
output	wire	[47:0]	o_Data;


assign o_Data = {	i_Data[42], i_Data[39], i_Data[45], i_Data[32], i_Data[55], i_Data[51], 
					i_Data[53], i_Data[28], i_Data[41], i_Data[50], i_Data[35], i_Data[46], 	
					i_Data[33], i_Data[37], i_Data[44], i_Data[52], i_Data[30], i_Data[48], 	
					i_Data[40], i_Data[49], i_Data[29], i_Data[36], i_Data[43], i_Data[54], 	
					i_Data[15], i_Data[ 4], i_Data[25], i_Data[19], i_Data[ 9], i_Data[ 1], 	
					i_Data[26], i_Data[16], i_Data[ 5], i_Data[11], i_Data[23], i_Data[ 8], 	
					i_Data[12], i_Data[ 7], i_Data[17], i_Data[ 0], i_Data[22], i_Data[ 3], 	
					i_Data[10], i_Data[14], i_Data[ 6], i_Data[20], i_Data[27], i_Data[24]};
endmodule

/*--------------------------------------------------------------------------------------------------------------*/

module SBOX(i_Data, o_Data);
input			[47:0] i_Data;
output	wire	[31:0] o_Data;

wire	[1:0] row 		[0:7];
wire	[3:0] column	[0:7];
reg		[3:0] sbox		[0:7];

assign row[0]	= {i_Data[47],i_Data[42]}, column[0]  =  i_Data[46:43];
assign row[1]	= {i_Data[41],i_Data[36]}, column[1]  =  i_Data[40:37];
assign row[2]	= {i_Data[35],i_Data[30]}, column[2]  =  i_Data[34:31];
assign row[3]	= {i_Data[29],i_Data[24]}, column[3]  =  i_Data[28:25];
assign row[4]	= {i_Data[23],i_Data[18]}, column[4]  =  i_Data[22:19];
assign row[5]	= {i_Data[17],i_Data[12]}, column[5]  =  i_Data[16:13];
assign row[6]	= {i_Data[11],i_Data[ 6]}, column[6]  =  i_Data[10: 7];
assign row[7]	= {i_Data[ 5],i_Data[ 0]}, column[7]  =  i_Data[ 4: 1];
assign o_Data	= {sbox[0], sbox[1], sbox[2], sbox[3], sbox[4], sbox[5], sbox[6], sbox[7]};

always@*
begin
   	case(row[0])	
		0 : case(column[0])
			 0 : sbox[0] = 14; 	 1 : sbox[0] =  4; 	 2 : sbox[0] = 13; 	 3 : sbox[0] =  1;
			 4 : sbox[0] =  2; 	 5 : sbox[0] = 15; 	 6 : sbox[0] = 11; 	 7 : sbox[0] =  8;
			 8 : sbox[0] =  3; 	 9 : sbox[0] = 10; 	10 : sbox[0] =  6; 	11 : sbox[0] = 12;
			12 : sbox[0] =  5; 	13 : sbox[0] =  9; 	14 : sbox[0] =  0; 	15 : sbox[0] =  7; 
		endcase
		1 : case(column[0])
			 0 : sbox[0] =  0; 	 1 : sbox[0] = 15; 	 2 : sbox[0] =  7; 	 3 : sbox[0] =  4;
			 4 : sbox[0] = 14; 	 5 : sbox[0] =  2; 	 6 : sbox[0] = 13; 	 7 : sbox[0] =  1;
			 8 : sbox[0] = 10; 	 9 : sbox[0] =  6; 	10 : sbox[0] = 12; 	11 : sbox[0] = 11;
			12 : sbox[0] =  9; 	13 : sbox[0] =  5; 	14 : sbox[0] =  3; 	15 : sbox[0] =  8; 
		endcase
		2 : case(column[0])
			 0 : sbox[0] =  4; 	 1 : sbox[0] =  1; 	 2 : sbox[0] = 14; 	 3 : sbox[0] =  8;
			 4 : sbox[0] = 13; 	 5 : sbox[0] =  6; 	 6 : sbox[0] =  2; 	 7 : sbox[0] = 11;
			 8 : sbox[0] = 15; 	 9 : sbox[0] = 12; 	10 : sbox[0] =  9; 	11 : sbox[0] =  7;
			12 : sbox[0] =  3; 	13 : sbox[0] = 10; 	14 : sbox[0] =  5; 	15 : sbox[0] =  0; 
		endcase
		 3 : case(column[0])
			 0 : sbox[0] = 15; 	 1 : sbox[0] = 12; 	 2 : sbox[0] =  8; 	 3 : sbox[0] =  2;
			 4 : sbox[0] =  4; 	 5 : sbox[0] =  9; 	 6 : sbox[0] =  1; 	 7 : sbox[0] =  7;
			 8 : sbox[0] =  5; 	 9 : sbox[0] = 11; 	10 : sbox[0] =  3; 	11 : sbox[0] = 14;
			12 : sbox[0] = 10; 	13 : sbox[0] =  0; 	14 : sbox[0] =  6; 	15 : sbox[0] = 13; 
		endcase
	endcase

   	case(row[1])
		0 : case(column[1])
			 0 : sbox[1] = 15; 	 1 : sbox[1] =  1; 	 2 : sbox[1] =  8; 	 3 : sbox[1] = 14;
			 4 : sbox[1] =  6; 	 5 : sbox[1] = 11; 	 6 : sbox[1] =  3; 	 7 : sbox[1] =  4;
			 8 : sbox[1] =  9; 	 9 : sbox[1] =  7; 	10 : sbox[1] =  2; 	11 : sbox[1] = 13;
			12 : sbox[1] = 12; 	13 : sbox[1] =  0; 	14 : sbox[1] =  5; 	15 : sbox[1] = 10; 
		endcase
		1 : case(column[1])
			 0 : sbox[1] =  3; 	 1 : sbox[1] = 13; 	 2 : sbox[1] =  4; 	 3 : sbox[1] =  7;
			 4 : sbox[1] = 15; 	 5 : sbox[1] =  2; 	 6 : sbox[1] =  8; 	 7 : sbox[1] = 14;
			 8 : sbox[1] = 12; 	 9 : sbox[1] =  0; 	10 : sbox[1] =  1; 	11 : sbox[1] = 10;
			12 : sbox[1] =  6; 	13 : sbox[1] =  9; 	14 : sbox[1] = 11; 	15 : sbox[1] =  5; 
		endcase
		2 : case(column[1])
			 0 : sbox[1] =  0; 	 1 : sbox[1] = 14; 	 2 : sbox[1] =  7; 	 3 : sbox[1] = 11;
			 4 : sbox[1] = 10; 	 5 : sbox[1] =  4; 	 6 : sbox[1] = 13; 	 7 : sbox[1] =  1;
			 8 : sbox[1] =  5; 	 9 : sbox[1] =  8; 	10 : sbox[1] = 12; 	11 : sbox[1] =  6;
			12 : sbox[1] =  9; 	13 : sbox[1] =  3; 	14 : sbox[1] =  2; 	15 : sbox[1] = 15; 
		endcase
		3 : case(column[1])
			 0 : sbox[1] = 13; 	 1 : sbox[1] =  8; 	 2 : sbox[1] = 10; 	 3 : sbox[1] =  1;
			 4 : sbox[1] =  3; 	 5 : sbox[1] = 15; 	 6 : sbox[1] =  4; 	 7 : sbox[1] =  2;
			 8 : sbox[1] = 11; 	 9 : sbox[1] =  6; 	10 : sbox[1] =  7; 	11 : sbox[1] = 12;
			12 : sbox[1] =  0; 	13 : sbox[1] =  5; 	14 : sbox[1] = 14; 	15 : sbox[1] =  9; 
		endcase
	endcase

 	case(row[2])
		0 : case(column[2])
			 0 : sbox[2] = 10; 	 1 : sbox[2] =  0; 	 2 : sbox[2] =  9; 	 3 : sbox[2] = 14;
			 4 : sbox[2] =  6; 	 5 : sbox[2] =  3; 	 6 : sbox[2] = 15; 	 7 : sbox[2] =  5;
			 8 : sbox[2] =  1; 	 9 : sbox[2] = 13; 	10 : sbox[2] = 12; 	11 : sbox[2] =  7;
			12 : sbox[2] = 11; 	13 : sbox[2] =  4; 	14 : sbox[2] =  2; 	15 : sbox[2] =  8; 
		endcase
		1 : case(column[2])
			 0 : sbox[2] = 13; 	 1 : sbox[2] =  7; 	 2 : sbox[2] =  0; 	 3 : sbox[2] =  9;
			 4 : sbox[2] =  3; 	 5 : sbox[2] =  4; 	 6 : sbox[2] =  6; 	 7 : sbox[2] = 10;
			 8 : sbox[2] =  2; 	 9 : sbox[2] =  8; 	10 : sbox[2] =  5; 	11 : sbox[2] = 14;
			12 : sbox[2] = 12; 	13 : sbox[2] = 11; 	14 : sbox[2] = 15; 	15 : sbox[2] =  1; 
		endcase
		2 : case(column[2])
			 0 : sbox[2] = 13; 	 1 : sbox[2] =  6; 	 2 : sbox[2] =  4; 	 3 : sbox[2] =  9;
			 4 : sbox[2] =  8; 	 5 : sbox[2] = 15; 	 6 : sbox[2] =  3; 	 7 : sbox[2] =  0;
			 8 : sbox[2] = 11; 	 9 : sbox[2] =  1; 	10 : sbox[2] =  2; 	11 : sbox[2] = 12;
			12 : sbox[2] =  5; 	13 : sbox[2] = 10; 	14 : sbox[2] = 14; 	15 : sbox[2] =  7; 
		endcase
		3 : case(column[2])
			 0 : sbox[2] =  1; 	 1 : sbox[2] = 10; 	 2 : sbox[2] = 13; 	 3 : sbox[2] =  0;
			 4 : sbox[2] =  6; 	 5 : sbox[2] =  9; 	 6 : sbox[2] =  8; 	 7 : sbox[2] =  7;
			 8 : sbox[2] =  4; 	 9 : sbox[2] = 15; 	10 : sbox[2] = 14; 	11 : sbox[2] =  3;
			12 : sbox[2] = 11; 	13 : sbox[2] =  5; 	14 : sbox[2] =  2; 	15 : sbox[2] = 12; 
		endcase
	endcase

   	case(row[3])
		0 : case(column[3])
			 0 : sbox[3] =  7; 	 1 : sbox[3] = 13; 	 2 : sbox[3] = 14; 	 3 : sbox[3] =  3;
			 4 : sbox[3] =  0; 	 5 : sbox[3] =  6; 	 6 : sbox[3] =  9; 	 7 : sbox[3] = 10;
			 8 : sbox[3] =  1; 	 9 : sbox[3] =  2; 	10 : sbox[3] =  8; 	11 : sbox[3] =  5;
			12 : sbox[3] = 11; 	13 : sbox[3] = 12; 	14 : sbox[3] =  4; 	15 : sbox[3] = 15; 
		endcase
		1 : case(column[3])
			 0 : sbox[3] = 13; 	 1 : sbox[3] =  8; 	 2 : sbox[3] = 11; 	 3 : sbox[3] =  5;
			 4 : sbox[3] =  6; 	 5 : sbox[3] = 15; 	 6 : sbox[3] =  0; 	 7 : sbox[3] =  3;
			 8 : sbox[3] =  4; 	 9 : sbox[3] =  7; 	10 : sbox[3] =  2; 	11 : sbox[3] = 12;
			12 : sbox[3] =  1; 	13 : sbox[3] = 10; 	14 : sbox[3] = 14; 	15 : sbox[3] =  9; 
		endcase
		2 : case(column[3])
			 0 : sbox[3] = 10; 	 1 : sbox[3] =  6; 	 2 : sbox[3] =  9; 	 3 : sbox[3] =  0;
			 4 : sbox[3] = 12; 	 5 : sbox[3] = 11; 	 6 : sbox[3] =  7; 	 7 : sbox[3] = 13;
			 8 : sbox[3] = 15; 	 9 : sbox[3] =  1; 	10 : sbox[3] =  3; 	11 : sbox[3] = 14;
			12 : sbox[3] =  5; 	13 : sbox[3] =  2; 	14 : sbox[3] =  8; 	15 : sbox[3] =  4; 
		endcase				
		3 : case(column[3])
			 0 : sbox[3] =  3; 	 1 : sbox[3] = 15; 	 2 : sbox[3] =  0; 	 3 : sbox[3] =  6;
			 4 : sbox[3] = 10; 	 5 : sbox[3] =  1; 	 6 : sbox[3] = 13; 	 7 : sbox[3] =  8;
			 8 : sbox[3] =  9; 	 9 : sbox[3] =  4; 	10 : sbox[3] =  5; 	11 : sbox[3] = 11;
			12 : sbox[3] = 12; 	13 : sbox[3] =  7; 	14 : sbox[3] =  2; 	15 : sbox[3] = 14; 
		endcase				
	endcase

  	case(row[4])
		0 : case(column[4])
			 0 : sbox[4] =  2; 	 1 : sbox[4] = 12; 	 2 : sbox[4] =  4; 	 3 : sbox[4] =  1;
			 4 : sbox[4] =  7; 	 5 : sbox[4] = 10; 	 6 : sbox[4] = 11; 	 7 : sbox[4] =  6;
			 8 : sbox[4] =  8; 	 9 : sbox[4] =  5; 	10 : sbox[4] =  3; 	11 : sbox[4] = 15;
			12 : sbox[4] = 13; 	13 : sbox[4] =  0; 	14 : sbox[4] = 14; 	15 : sbox[4] =  9; 
		endcase				
		1 : case(column[4])
			 0 : sbox[4] = 14; 	 1 : sbox[4] = 11; 	 2 : sbox[4] =  2; 	 3 : sbox[4] = 12;
			 4 : sbox[4] =  4; 	 5 : sbox[4] =  7; 	 6 : sbox[4] = 13; 	 7 : sbox[4] =  1;
			 8 : sbox[4] =  5; 	 9 : sbox[4] =  0; 	10 : sbox[4] = 15; 	11 : sbox[4] = 10;
			12 : sbox[4] =  3; 	13 : sbox[4] =  9; 	14 : sbox[4] =  8; 	15 : sbox[4] =  6; 
		endcase				
		2 : case(column[4])
			 0 : sbox[4] =  4; 	 1 : sbox[4] =  2; 	 2 : sbox[4] =  1; 	 3 : sbox[4] = 11;
			 4 : sbox[4] = 10; 	 5 : sbox[4] = 13; 	 6 : sbox[4] =  7; 	 7 : sbox[4] =  8;
			 8 : sbox[4] = 15; 	 9 : sbox[4] =  9; 	10 : sbox[4] = 12; 	11 : sbox[4] =  5;
			12 : sbox[4] =  6; 	13 : sbox[4] =  3; 	14 : sbox[4] =  0; 	15 : sbox[4] = 14; 
		endcase				
		3 : case(column[4])
			 0 : sbox[4] = 11; 	 1 : sbox[4] =  8; 	 2 : sbox[4] = 12; 	 3 : sbox[4] =  7;
			 4 : sbox[4] =  1; 	 5 : sbox[4] = 14; 	 6 : sbox[4] =  2; 	 7 : sbox[4] = 13;
			 8 : sbox[4] =  6; 	 9 : sbox[4] = 15; 	10 : sbox[4] =  0; 	11 : sbox[4] =  9;
			12 : sbox[4] = 10; 	13 : sbox[4] =  4; 	14 : sbox[4] =  5; 	15 : sbox[4] =  3; 
		endcase				
	endcase				

   	case(row[5])
		0 : case(column[5])
			 0 : sbox[5] = 12; 	 1 : sbox[5] =  1; 	 2 : sbox[5] = 10; 	 3 : sbox[5] = 15;
			 4 : sbox[5] =  9; 	 5 : sbox[5] =  2; 	 6 : sbox[5] =  6; 	 7 : sbox[5] =  8;
			 8 : sbox[5] =  0; 	 9 : sbox[5] = 13; 	10 : sbox[5] =  3; 	11 : sbox[5] =  4;
			12 : sbox[5] = 14; 	13 : sbox[5] =  7; 	14 : sbox[5] =  5; 	15 : sbox[5] = 11; 
		endcase				
		1 : case(column[5])
			 0 : sbox[5] = 10; 	 1 : sbox[5] = 15; 	 2 : sbox[5] =  4; 	 3 : sbox[5] =  2;
			 4 : sbox[5] =  7; 	 5 : sbox[5] = 12; 	 6 : sbox[5] =  9; 	 7 : sbox[5] =  5;
			 8 : sbox[5] =  6; 	 9 : sbox[5] =  1; 	10 : sbox[5] = 13; 	11 : sbox[5] = 14;
			12 : sbox[5] =  0; 	13 : sbox[5] = 11; 	14 : sbox[5] =  3; 	15 : sbox[5] =  8; 
		endcase				
		2 : case(column[5])
			 0 : sbox[5] =  9; 	 1 : sbox[5] = 14; 	 2 : sbox[5] = 15; 	 3 : sbox[5] =  5;
			 4 : sbox[5] =  2; 	 5 : sbox[5] =  8; 	 6 : sbox[5] = 12; 	 7 : sbox[5] =  3; 
			 8 : sbox[5] =  7; 	 9 : sbox[5] =  0; 	10 : sbox[5] =  4; 	11 : sbox[5] = 10; 
			12 : sbox[5] =  1; 	13 : sbox[5] = 13; 	14 : sbox[5] = 11; 	15 : sbox[5] =  6; 
		endcase				
		3 : case(column[5])
			 0 : sbox[5] =  4; 	 1 : sbox[5] =  3; 	 2 : sbox[5] =  2; 	 3 : sbox[5] = 12; 
			 4 : sbox[5] =  9; 	 5 : sbox[5] =  5; 	 6 : sbox[5] = 15; 	 7 : sbox[5] = 10; 
			 8 : sbox[5] = 11; 	 9 : sbox[5] = 14; 	10 : sbox[5] =  1; 	11 : sbox[5] =  7; 
			12 : sbox[5] =  6; 	13 : sbox[5] =  0; 	14 : sbox[5] =  8; 	15 : sbox[5] = 13; 
		endcase				
	endcase	

   	case(row[6])
		0 : case(column[6])
			 0 : sbox[6] =  4; 	 1 : sbox[6] = 11; 	 2 : sbox[6] =  2; 	 3 : sbox[6] = 14; 
			 4 : sbox[6] = 15; 	 5 : sbox[6] =  0; 	 6 : sbox[6] =  8; 	 7 : sbox[6] = 13; 
			 8 : sbox[6] =  3; 	 9 : sbox[6] = 12; 	10 : sbox[6] =  9; 	11 : sbox[6] =  7; 
			12 : sbox[6] =  5; 	13 : sbox[6] = 10; 	14 : sbox[6] =  6; 	15 : sbox[6] =  1; 
		endcase				
		1 : case(column[6])
			 0 : sbox[6] = 13; 	 1 : sbox[6] =  0; 	 2 : sbox[6] = 11; 	 3 : sbox[6] =  7; 
			 4 : sbox[6] =  4; 	 5 : sbox[6] =  9; 	 6 : sbox[6] =  1; 	 7 : sbox[6] = 10; 
			 8 : sbox[6] = 14; 	 9 : sbox[6] =  3; 	10 : sbox[6] =  5; 	11 : sbox[6] = 12; 
			12 : sbox[6] =  2; 	13 : sbox[6] = 15; 	14 : sbox[6] =  8; 	15 : sbox[6] =  6; 
		endcase
		2 : case(column[6])
			 0 : sbox[6] =  1; 	 1 : sbox[6] =  4; 	 2 : sbox[6] = 11; 	 3 : sbox[6] = 13; 
			 4 : sbox[6] = 12; 	 5 : sbox[6] =  3; 	 6 : sbox[6] =  7; 	 7 : sbox[6] = 14; 
			 8 : sbox[6] = 10; 	 9 : sbox[6] = 15; 	10 : sbox[6] =  6; 	11 : sbox[6] =  8; 
			12 : sbox[6] =  0; 	13 : sbox[6] =  5; 	14 : sbox[6] =  9; 	15 : sbox[6] =  2; 
		endcase
		3 : case(column[6])
			 0 : sbox[6] =  6; 	 1 : sbox[6] = 11; 	 2 : sbox[6] = 13; 	 3 : sbox[6] =  8; 
			 4 : sbox[6] =  1; 	 5 : sbox[6] =  4; 	 6 : sbox[6] = 10; 	 7 : sbox[6] =  7; 
			 8 : sbox[6] =  9; 	 9 : sbox[6] =  5; 	10 : sbox[6] =  0; 	11 : sbox[6] = 15; 
			12 : sbox[6] = 14; 	13 : sbox[6] =  2; 	14 : sbox[6] =  3; 	15 : sbox[6] = 12; 
		endcase				
	endcase

   	case(row[7])
		0 : case(column[7])
			 0 : sbox[7] = 13; 	 1 : sbox[7] =  2; 	 2 : sbox[7] =  8; 	 3 : sbox[7] =  4; 
			 4 : sbox[7] =  6; 	 5 : sbox[7] = 15; 	 6 : sbox[7] = 11; 	 7 : sbox[7] =  1; 
			 8 : sbox[7] = 10; 	 9 : sbox[7] =  9; 	10 : sbox[7] =  3; 	11 : sbox[7] = 14; 
			12 : sbox[7] =  5; 	13 : sbox[7] =  0; 	14 : sbox[7] = 12; 	15 : sbox[7] =  7; 
		endcase
		1 : case(column[7])
			 0 : sbox[7] =  1; 	 1 : sbox[7] = 15; 	 2 : sbox[7] = 13; 	 3 : sbox[7] =  8; 
			 4 : sbox[7] = 10; 	 5 : sbox[7] =  3; 	 6 : sbox[7] =  7; 	 7 : sbox[7] =  4; 
			 8 : sbox[7] = 12; 	 9 : sbox[7] =  5; 	10 : sbox[7] =  6; 	11 : sbox[7] = 11; 
			12 : sbox[7] =  0; 	13 : sbox[7] = 14; 	14 : sbox[7] =  9; 	15 : sbox[7] =  2; 
		endcase
		2 : case(column[7])
			 0 : sbox[7] =  7; 	 1 : sbox[7] = 11; 	 2 : sbox[7] =  4; 	 3 : sbox[7] =  1; 
			 4 : sbox[7] =  9; 	 5 : sbox[7] = 12; 	 6 : sbox[7] = 14; 	 7 : sbox[7] =  2; 
			 8 : sbox[7] =  0; 	 9 : sbox[7] =  6; 	10 : sbox[7] = 10; 	11 : sbox[7] = 13; 
			12 : sbox[7] = 15; 	13 : sbox[7] =  3; 	14 : sbox[7] =  5; 	15 : sbox[7] =  8; 
		endcase
		3 : case(column[7])
			 0 : sbox[7] =  2; 	 1 : sbox[7] =  1; 	 2 : sbox[7] = 14; 	 3 : sbox[7] =  7; 
			 4 : sbox[7] =  4; 	 5 : sbox[7] = 10; 	 6 : sbox[7] =  8; 	 7 : sbox[7] = 13; 
			 8 : sbox[7] = 15; 	 9 : sbox[7] = 12; 	10 : sbox[7] =  9; 	11 : sbox[7] =  0; 
			12 : sbox[7] =  3; 	13 : sbox[7] =  5; 	14 : sbox[7] =  6; 	15 : sbox[7] = 11; 
		endcase	
	endcase
end

endmodule

module DES(
	i_Clk, i_Rst,
	i_fStart, i_fDec,
	i_Key, i_Text,
	o_fDone, o_Text
);

input i_Clk, i_Rst;
input i_fStart, i_fDec;
input [63:0] i_Key, i_Text;

output reg o_fDone;
output reg [63:0] o_Text;

reg [31:0] c_L, n_L,
		   c_R, n_R;
reg [27:0] c_C, n_C,
		   c_D, n_D;
reg [3:0]  c_Rnd, n_Rnd;
reg [1:0]  c_State, n_State;

wire [63:0] IP_o, InvIP_o;
wire [55:0] PC1_o;
wire [47:0] E_o, PC2_o;
wire [31:0] SB_o, PT_o;
wire [27:0] Rot_C, Rot_D;
wire fRot1bit;

parameter IDLE = 2'b00;
parameter ENC  = 2'b01;
parameter DEC  = 2'b10;
parameter DONE = 2'b11;

PC1 P1 (i_Key, PC1_o);
ROL ROL1 (c_C, i_fDec, fRot1bit, Rot_C);
ROL ROL2 (c_D, i_fDec, fRot1bit, Rot_D);
PC2 P2 ({c_C,c_D}, PC2_o);

IP IP0 (i_Text, IP_o);
E_Table ET0 (c_R, E_o);
SBOX SB0 (E_o^PC2_o, SB_o);
P_Table PT0 (SB_o, PT_o);

InvIP Inv0 ({c_R,c_L}, InvIP_o);

assign fRot1bit = c_Rnd == 0 ||
				  c_Rnd == 7 ||
				  c_Rnd == 14||
				  c_Rnd == 15;


always @(posedge i_Clk, negedge i_Rst) begin
	if(!i_Rst) begin
		c_L = 0;
		c_R = 0;
		c_C = 0;
		c_D = 0;
		c_Rnd = 0;
		c_State = IDLE;
	end else begin
		c_L = n_L;
		c_R = n_R;
		c_C = n_C;
		c_D = n_D;
		c_Rnd = n_Rnd;
		c_State = n_State;
	end
end

always @* begin
	n_Rnd = c_Rnd;
	n_L = c_L;
	n_R = c_R;
	n_C = c_C;	
	n_D = c_D;
	o_fDone = 0;
	o_Text = 0;
	n_State = c_State;
	case(c_State)
		IDLE	: begin
			if(i_fStart) begin
				n_Rnd = 0;
				n_L = IP_o[63:32];
				n_R = IP_o[31: 0];
				n_C = i_fDec ? PC1_o[55:28] : {PC1_o[54:28],PC1_o[55]};
				n_D = i_fDec ? PC1_o[27: 0] : {PC1_o[26: 0],PC1_o[27]};
				n_State = i_fDec ? DEC : ENC;
			end
			else begin
				n_L = 0;
				n_R = 0;
				n_C = 0;
				n_D = 0;
			end
		end
		DEC		: begin
			n_Rnd = c_Rnd + 1;
			n_L = c_R;
			n_R = c_L^PT_o;
			n_C = Rot_C;
			n_D = Rot_D;
			if(c_Rnd==15) n_State = DONE;
		end
		ENC		: begin
			n_Rnd = c_Rnd + 1;
			n_L = c_R;
			n_R = c_L^PT_o;
			n_C = Rot_C;
			n_D = Rot_D;
			if(c_Rnd==15) n_State = DONE;
		end
		DONE	: begin
			n_Rnd = 0;
			n_L = 0;
			n_R = 0;
			n_C = 0;
			n_D = 0;
			o_fDone = 1;
			o_Text = InvIP_o;
			n_State = IDLE;
		end
	endcase
end
endmodule