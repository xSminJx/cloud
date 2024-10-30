module StopWatch (
  i_Clk,
  i_Rst,
  i_fStart,
  i_fStop,
  o_Sec0,
  o_Sec1,
  o_Sec2
);
  
  input i_Clk, i_Rst, i_fStart, i_fStop;
  output [6:0] o_Sec0, o_Sec1, o_Sec2;

  reg [1:0]   c_state,  n_state;
  reg         c_fStart, n_fStart,
              c_fStop,  n_fStop;
  reg [3:0]   c_Sec0,   n_Sec0,
              c_Sec1,   n_Sec1,
              c_Sec2,   n_Sec2;
  reg [22:0]  c_ClkCnt, n_ClkCnt;

  parameter LST_CLK = 100_000_000/20- 1;
  parameter IDLE = 2'b00, WORK = 2'b01, PAUSE = 2'b10;

  wire isLstClk;
  wire isLstSec0, isLstSec1, isLstSec2;
  wire isInSec0, isInSec1, isInSec2;
  wire fStart, fStop;

  FND FND0(c_Sec0, o_Sec0);
  FND FND1(c_Sec1, o_Sec1);
  FND FND2(c_Sec2, o_Sec2);

  always @(posedge i_Clk, negedge i_Rst) begin
    if(!i_Rst) begin
      c_fStart = 1;
      c_fStop  = 1;
      c_Sec0   = 0;
      c_Sec1   = 0;
      c_Sec2   = 0;
      c_ClkCnt = 0;
      c_state    = IDLE;
    end else begin
      c_fStart = n_fStart;
      c_fStop  = n_fStop;
      c_Sec0   = n_Sec0;
      c_Sec1   = n_Sec1;
      c_Sec2   = n_Sec2;
      c_ClkCnt = n_ClkCnt;
      c_state  = n_state;
    end
  end

  assign isLstClk = c_ClkCnt == LST_CLK;
  assign fStart = !i_fStart && c_fStart,
         fStop  = !i_fStop  && c_fStop;
  assign isInSec0 = isLstClk,
         isInSec1 = isInSec0 & isLstSec0,
         isInSec2 = isInSec1 & isLstSec1;
  assign isLstSec0 = c_Sec0 == 9,
         isLstSec1 = c_Sec1 == 9,
         isLstSec2 = c_Sec2 == 9;
  
  always@* begin
    n_fStart = i_fStart;
    n_fStop = i_fStop;
	 
    n_state = c_state;
    n_Sec0 = c_Sec0;
    n_Sec1 = c_Sec1;
    n_Sec2 = c_Sec2;
    n_ClkCnt = c_ClkCnt;

    case(c_state)
        IDLE : begin
          n_Sec0   = 0;
          n_Sec1   = 0;
          n_Sec2   = 0;
          n_ClkCnt = 0;
          if (fStart) n_state = WORK;
        end
        WORK : begin
          n_ClkCnt = isLstClk ? 0 : c_ClkCnt + 1;
          if(isInSec0) n_Sec0 = isLstSec0 ? 0 : c_Sec0 + 1; 
          if(isInSec1) n_Sec1 = isLstSec1 ? 0 : c_Sec1 + 1; 
          if(isInSec2) n_Sec2 = isLstSec2 ? 0 : c_Sec2 + 1; 

          if(fStop) n_state = IDLE;
          else if(fStart) n_state = PAUSE;
        end
        PAUSE : begin
          if(fStop) n_state = IDLE;
          else if(fStart) n_state = WORK;
        end
    endcase
  end
endmodule
