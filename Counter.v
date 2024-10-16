module Counter(i_Clk,i_Rst,i_Push,o_LED,o_FND);
  input i_Clk;
  input i_Rst;
  input [1:0] i_Push;
  output [3:0] o_LED;
  output [6:0] o_FND, FND2;
  
  reg [3:0] c_Cnt,n_Cnt;
  reg [1:0] c_UD,n_UD;
  
  wire fUp,fDn;
  
  always@(posedge i_Clk, negedge i_Rst)
  if(!i_Rst)begin
      c_Cnt=0;
      c_UD=2'b11;
  end else begin
      c_Cnt=n_Cnt;
      c_UD=n_UD;
  end
  
  assign {fUp,fDn}= ~i_Push&c_UD;
  assign o_LED=c_Cnt;
  FND FND0(c_Cnt,o_FND);
  
  always@*
  begin
    n_UD=i_Push;
    n_Cnt=fUp?(c_Cnt==4'b1001?4'b0000:c_Cnt+1):(fDn?(c_Cnt==4'b0000?4'b1001:c_Cnt-1):c_Cnt);
  end
endmodule