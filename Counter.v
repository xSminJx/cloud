module Counter(i_Clk,i_Rst,i_Push,o_LED,o_LED2,o_FND,o_FND2);
  input i_Clk;
  input i_Rst;
  input [1:0] i_Push;
  output [3:0] o_LED, o_LED2;
  output [6:0] o_FND, o_FND2;
  
  reg [3:0] c_Cnt,n_Cnt, c_Cnt2,n_Cnt2;
  reg [1:0] c_UD,n_UD;
  
  wire fUp,fDn;
  
  always@(posedge i_Clk, negedge i_Rst)
  if(!i_Rst)begin
      c_Cnt=0;
      c_Cnt2=0;
      c_UD=2'b11;
  end else begin
      c_Cnt=n_Cnt;
      c_Cnt2=n_Cnt2;
      c_UD=n_UD;
  end
  
  assign {fUp,fDn}= ~i_Push&c_UD;
  assign o_LED=c_Cnt;
  assign o_LED2=c_Cnt2;

  FND FND0(c_Cnt,o_FND);
  FND FND1(c_Cnt2,o_FND2);

  always@*
  begin
    n_UD=i_Push;
	 n_Cnt = c_Cnt;
    n_Cnt2 = c_Cnt2;
    n_Cnt=fUp?c_Cnt+1:(fDn?c_Cnt-1:c_Cnt);

    if(n_Cnt==10) begin
      n_Cnt=0;
      n_Cnt2=c_Cnt2+1;
      if(n_Cnt2==10) n_Cnt2=0;
    end
    else if(n_Cnt==4'b1111) begin
      n_Cnt=9;
      n_Cnt2=c_Cnt2-1;
      if(n_Cnt2==4'b1111) n_Cnt2=9;
    end
  end
endmodule
