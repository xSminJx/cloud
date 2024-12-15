module Snake_Game (
    i_Clk, i_Rst,
    i_Pause, i_Push,
    o_Speed_FND0, o_Speed_FND1, o_Score_FND0, o_Score_FND1, o_Score_FND2, o_Score_FND3,
    o_Hsync, o_Vsync, o_Red, o_Blue, o_Green, sync, blank, clk
);
    
    input i_Clk, i_Rst;
    input [3:0] i_Push;
    input i_Pause;

    output [6:0] o_Speed_FND0, o_Speed_FND1, o_Score_FND0,
                 o_Score_FND1, o_Score_FND2, o_Score_FND3;
    output o_Hsync, o_Vsync;
    output [7:0] o_Red, o_Blue, o_Green;
    output sync, blank, clk;

    parameter XSIZE     = 48,
              YSIZE     = 64,
              MAX_SIZE  = 20,
              LST_CLK   = 1_000, // 원래값 : 25_000_000, 시뮬레이션 위해 1_000으로 임시 변경

              IDLE      = 3'b000,
              RUN       = 3'b001,
              CHANGE    = 3'b010,
              SETBODY   = 3'b011,
              PAUSE     = 3'b100,
              STOP      = 3'b101;

    parameter DEF_SPD   = 2,
              DEF_SIZE  = 3;

    reg [24:0] c_ClkCnt, n_ClkCnt;
    reg [MAX_SIZE*6-1:0]  c_Body_x, n_Body_x, // 뱀의 몸통을 저장할 배열(큐 역할)
                          c_Body_y, n_Body_y; 
    reg [5:0]  c_Head_x, n_Head_x,   // 뱀의 머리 위치 저장
               c_Head_y, n_Head_y;
    reg [5:0]  c_Item_x, n_Item_x,   // 아이템 위치 저장
               c_Item_y, n_Item_y;
    reg [11:0] c_Size, n_Size;       // 뱀 크기(점수랑 같은 역할)
    reg [1:0]  c_Way, n_Way,         // 뱀이 움직였던 방향
               c_Push, n_Push;       // 조이스틱 입력 저장
    reg [2:0]  c_State, n_State;
    reg [4:0]  c_Speed, n_Speed;
    reg [4:0]  c_SpdTimeCnt, n_SpdTimeCnt; // 먹이를 먹으면 일정 시간동안 속도가 빨라지는데, 그 일정시간을 저장할 레지스터
    reg        prev_isEat;
    reg [MAX_SIZE-1:0] Match;

    wire [5:0] SH_o_Head_x, SH_o_Head_y;
    wire [1:0] SH_o_Way;

    wire isLstClk = c_ClkCnt >= LST_CLK;
    wire isEat = (n_Head_x == c_Item_x && n_Head_y == c_Item_y) && c_State == CHANGE;
    wire isGameOver = (n_Head_x == 0 || n_Head_y == 0 || n_Head_x == XSIZE - 1 || n_Head_y == YSIZE - 1) || |Match;
    wire isSpdDw = c_SpdTimeCnt == 16;

    //사이즈값(2진수) -> FND로 변환하는거 추가해야함(스탑워치에서 했던거 써서 모듈로 따로 분리하면 될듯)

    always @(posedge i_Clk or negedge i_Rst) begin
        if(!i_Rst) begin
            c_ClkCnt     = 0;
            c_Head_x     = XSIZE >> 1;
            c_Head_y     = YSIZE >> 1;
            c_Item_x     = 12;
            c_Item_y     = 32;
            c_Size       = DEF_SIZE;
            c_Way        = 0;
            c_Push       = 0;
            c_State      = IDLE;
            c_Speed      = DEF_SPD;
            c_SpdTimeCnt = 0;
            prev_isEat   = 0;

            c_Body_x     = c_Head_x;
            c_Body_y     = c_Head_y;
        end else begin
            c_ClkCnt     = n_ClkCnt;
            c_Head_x     = n_Head_x;
            c_Head_y     = n_Head_y;
            c_Item_x     = n_Item_x;
            c_Item_y     = n_Item_y;
            c_Size       = n_Size;
            c_Way        = n_Way;
            c_Push       = n_Push;
            c_State      = n_State;
            c_Speed      = n_Speed;
            c_SpdTimeCnt = n_SpdTimeCnt;
            prev_isEat   = isEat;

            c_Body_x     = n_Body_x;
            c_Body_y     = n_Body_y;
        end
    end

    // SetHead모듈 연결
    SetHead SH0 (i_Clk, i_Rst,
                 c_Way, c_Push, c_Head_x, c_Head_y,
                 SH_o_Head_x, SH_o_Head_y, SH_o_Way);

    // 점수, 속도 모듈 연결
    wire [3:0] SF_o_F0, SF_o_F1, CF_o_F0, CF_o_F1, CF_o_F2, CF_o_F3;
    SpeedFND SF0(c_Speed, SF_o_F0, SF_o_F1);
    ScoreFND CF0(c_Size, CF_o_F0, CF_o_F1, CF_o_F2, CF_o_F3);
    FND F0(SF_o_F0, o_Speed_FND0);
    FND F1(SF_o_F1, o_Speed_FND1);
    FND F2(CF_o_F0, o_Score_FND0);
    FND F3(CF_o_F0, o_Score_FND1);
    FND F4(CF_o_F0, o_Score_FND2);
    FND F5(CF_o_F0, o_Score_FND3);

    //VGA모듈 연결
    Vga V0(i_Clk, i_Rst, c_Body_x, c_Body_y, c_Item_x, c_Item_y, c_Size,
           o_Hsync, o_Vsync, o_Red, o_Blue, o_Green);

    wire o_isMakeItem_Done;
    wire [5:0] GI_o_Item_x, GI_o_Item_y;
    wire GI_i_isStart = isEat && !prev_isEat;
    Generate_Item_Pos GI0(i_Clk, i_Rst, c_Body_x, c_Body_y, c_Size,
                          GI_i_isStart, GI_o_Item_x, GI_o_Item_y, o_isMakeItem_Done);


    integer i, j;
    always @* begin
        n_Head_x = c_Head_x;
        n_Head_y = c_Head_y;
        n_Item_x = c_Item_x;
        n_Item_y = c_Item_y;
        n_Size   = c_Size;
        n_ClkCnt = 0;
        n_Way    = c_Way;
        n_Push   = c_Push;
        n_State  = c_State;
        n_Speed  = c_Speed;
        n_SpdTimeCnt = c_SpdTimeCnt;
        Match  = 0;
        
        n_Body_x = c_Body_x;
        n_Body_y = c_Body_y;

        case(c_State)
            IDLE : begin
                n_Head_x = XSIZE>>1;
                n_Head_y = YSIZE>>1;
                n_Item_x = 12;
                n_Item_y = 32;
                n_Speed  = DEF_SPD;
                n_Size   = DEF_SIZE;
                if(!(&i_Push)) begin
                    n_State = RUN;
                    n_ClkCnt = 0;
                end
            end
            RUN  : begin
                n_ClkCnt = isLstClk ? 0 : c_ClkCnt + c_Speed;
                n_Push = !i_Push[0] ? 0 :
                         !i_Push[1] ? 1 :
                         !i_Push[2] ? 2 :
                         !i_Push[3] ? 3 : c_Push;

                if(isLstClk) begin
                    //속도 조절 로직
                    n_SpdTimeCnt = isSpdDw ? 0 : c_SpdTimeCnt + 1;
                    n_Speed = isSpdDw ? DEF_SPD : c_Speed; // 시간 다되면 기본 속도

                    //헤드 위치, 방향 갱신
                    {n_Head_x,n_Head_y} = {SH_o_Head_x,SH_o_Head_y};
                    n_Way = SH_o_Way;
                end
                n_State = i_Pause ? PAUSE : (isLstClk ? CHANGE : c_State);
            end
            CHANGE : begin // n_Head값들 바뀐거로 사이즈값 변경이랑 게임 오버 판정, 아이템 새로 만듬
                if(isEat && !prev_isEat) begin
                    n_Size = c_Size + (c_Speed >> 1); // 속도의 절반만큼 점수가 오름
                    if(o_isMakeItem_Done) begin
                        n_Item_x = GI_o_Item_x;
                        n_Item_y = GI_o_Item_y;
                    end
                    n_Speed = c_Speed + 1;
                    n_SpdTimeCnt = 0;
                end
                for(i = 0; i < c_Size && i < MAX_SIZE; i = i+1) begin
                    Match[i] = (n_Head_x == c_Body_x[i*6 +: 6] && n_Head_y == c_Body_y[i*6 +: 6]);
                end
                n_State = isGameOver ? STOP : (o_isMakeItem_Done ? SETBODY : c_State);
            end
            SETBODY : begin // 사이즈값 갱신했으니 그걸로 몸통 큐 갱신
                n_Body_x[5:0] = c_Head_x;
                n_Body_y[5:0] = c_Head_y;
                j = 6;
                for(i=0;i<(MAX_SIZE-1)*6;i=i+6) begin
                    n_Body_x[j+:6] = c_Body_x[i+:6];
                    n_Body_y[j+:6] = c_Body_y[i+:6];
                    j = j + 6;
                end
                n_State = RUN;
            end
            PAUSE : begin
                n_State = !i_Pause ? RUN : c_State;
            end
            STOP : begin
                n_ClkCnt = isLstClk ? 0 : c_ClkCnt + DEF_SPD;
                if(isLstClk) begin
                    n_Body_x[119:114] = XSIZE-1;
                    n_Body_y[119:114] = YSIZE-1;
                    j = 6;
                    for(i=0;i<(MAX_SIZE-1)*6;i=i+6) begin
                        n_Body_x[i+:6] = c_Body_x[j+:6];
                        n_Body_y[i+:6] = c_Body_y[j+:6];
                        j = j + 6;
                    end
                end

                if(c_Body_x[5:0] == XSIZE-1 && isLstClk) n_State = IDLE;
            end
        endcase
    end
endmodule