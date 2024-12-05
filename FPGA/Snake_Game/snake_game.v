module Snake_Game (
    i_Clk, i_Rst,
    i_Pause, i_Speedup, i_Push,
    o_FND1, o_FND2, o_FND3, o_vga
);
    
    input i_Clk, i_Rst;
    input [7:0] i_Speedup;
    input [3:0] i_Push;
    input i_Pause;

    output [6:0] o_FND1, o_FND2, o_FND3;
    // output vga;

    parameter XSIZE     = 60,
              YSIZE     = 80,
              LST_CLK   = 25_000_000,

              IDLE      = 3'b000,
              RUN       = 3'b001,
              CHANGE    = 3'b010,
              SETBODY   = 3'b011,
              PAUSE     = 3'b100,
              STOP      = 3'b101;

    parameter DEF_SPD   = 2,
              DEF_SIZE  = 3;

    //좌표 0, 0은 NULL역할
    reg [24:0] c_ClkCnt, n_ClkCnt;
    reg [6:0]  c_Body_x[XSIZE*YSIZE], n_Body_x[XSIZE*YSIZE], // 뱀의 몸통을 저장할 배열(큐 역할)
               c_Body_y[XSIZE*YSIZE], n_Body_y[XSIZE*YSIZE]; 
    reg [6:0]  c_Head_x, n_Head_x,   // 뱀의 머리 위치 저장
               c_Head_y, n_Head_y;
    reg [6:0]  c_Item_x, n_Item_x,   // 아이템 위치 저장
               c_Item_y, n_Item_y;
    reg [8:0]  c_Size, n_Size;       // 뱀 크기(점수랑 같은 역할)
    reg [1:0]  c_Way, n_Way;         // 뱀이 움직였던 방향
    reg [2:0]  c_State, n_State;
    reg [4:0]  c_Speed, n_Speed;
    reg [4:0]  c_SpdTimeCnt, n_SpdTimeCnt; // 먹이를 먹으면 일정 시간동안 속도가 빨라지는데, 그 일정시간을 저장할 레지스터

    wire o_Head_x, o_Head_y;
    wire [1:0] o_Way;

    wire isLstClk = c_ClkCnt <= LST_CLK;
    wire isEat = (n_Head_x == c_Item_x && n_Head_y == c_Item_y) && c_State == CHANGE;
    wire isGameOver = (n_Head_x == 0 || n_Head_y == 0 || n_Heao_x > XSIZE + 1 || n_Head_y > YSIZE); // 그리고 몸통에 박았는지도 확인(병렬처리하셈 아니면 모듈 만들던가)
    wire isSpdDw = c_SpdTimeCnt == 16;

    //사이즈값(2진수) -> FND로 변환하는거 추가해야함(스탑워치에서 했던거 써서 모듈로 따로 분리하면 될듯)

    always @(posedge i_Clk or negedge i_Rst) begin
        if(!i_Rst) begin
            c_ClkCnt     = 0;
            c_Head_x     = XSIZE >> 1;
            c_Head_y     = YSIZE >> 1;
            c_Item_x     = 0;
            c_Item_y     = 0;
            c_Size       = DEF_SIZE;
            c_Way        = 0; // 상하좌우를 제외한 값(4는 움직임X)
            c_State      = IDLE;
            c_Speed      = DEF_SPD;
            c_SpdTimeCnt = 0;
        end else begin
            c_ClkCnt     = n_ClkCnt;
            c_Head_x     = n_Head_x;
            c_Head_y     = n_Head_y;
            c_Size       = n_Size;
            c_Way        = n_Way;
            c_Body       = n_Body;
            c_State      = n_State;
            c_Speed      = n_Speed;
            c_SpdTimeCnt = n_SpdTimeCnt;
        end
    end

    SetHead S0 (i_Clk, i_Rst, c_Way, i_Push, c_Head_x, c_Head_y, o_Head_x, o_Head_y, o_Way);

    always @* begin
        n_Head_x = c_Head_x;
        n_Head_y = c_Head_y;
        n_Item_x = c_Item_x;
        n_Item_y = c_Item_y;
        n_Size   = c_Size;
        n_ClkCnt = 0;
        n_Way    = c_Way;
        n_State  = c_State;
        n_Speed  = c_Speed;
        n_SpdTimeCnt = c_SpdTimeCnt;

        case(c_State)
            IDLE : begin
                n_ClkCnt = c_ClkCnt + 1;
                if(!&i_Push) begin
                    n_State = RUN;
                    n_ClkCnt = 0;
                end
            end
            RUN  : begin
                n_ClkCnt = isLstClk ? 0 : c_ClkCnt + c_Speed;
                if(isLstClk) begin
                    //속도 조절 로직
                    n_SpdTimeCnt = isSpdDw ? 0 : c_SpdTimeCnt + 1;
                    n_Speed = isSpdDw ? DEF_SPD : c_Speed;

                    //헤드 위치, 방향 갱신
                    {n_Head_x,n_Head_y} = {o_Head_x,o_Head_y};
                    n_Way = o_Way;

                    n_State = CHANGE;
                end
                n_State = i_Pause ? PAUSE : RUN;
            end
            CHANGE : begin // n_Head값들 바뀐거로 사이즈값 변경이랑 게임 오버 판정, 아이템 새로 만듬
                if(isEat) begin
                    n_Size = c_Size + (c_Speed >> 1); // 속도의 절반만큼 점수가 오름
                    //n_Item_x = ;
                    //n_Item_y = ; // 시드값 넣어서 아이템 위치 랜덤으로 뽑아주는 함수 만들어오셈 (IDLE 상태에서 입력값이 들어온 시점에서의 ClkCnt값을 시드로 써서 난수 발생기 만들기(IDLE값이 아니면 시드값을 갱신 안하는 방식이면 될듯))
                    n_Speed = c_Speed + 1;
                    n_SpdTimeCnt = 0;
                end
                n_State = o_isMakeItem_Done ? (isGameOver ? STOP : SETQU) : c_State;
            end
            SETBODY : begin // 사이즈값 갱신했으니 그걸로 몸통 큐 갱신
                //{n_Body_x,n_Body_y} = ; // 사이즈값, 현재 몸통 큐 받아서 큐 갱신하는 함수 만드셈
                n_State = isSetBody_Done ? RUN : c_State;
            end
            PAUSE : begin
                n_State = !i_Pause ? RUN : c_State;
            end
            STOP : begin

            end
        endcase
    end
endmodule