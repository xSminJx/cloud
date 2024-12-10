module VGA (#parameter MAX_SIZE = 18432)(
    i_Clk,            // 50 MHz 입력 클럭
    i_Rst,            // 리셋 신호
    i_worm_x,           // 지렁이 x 위치 배열
    i_worm_y,           // 지렁이 y 위치 배열
    i_item_x,           // 아이템의 x 위치 (0~64)
    i_item_y,           // 아이템의 y 위치 (0~48)
    i_size,
    o_hsync,            // 수평 동기 신호
    o_vsync,            // 수직 동기 신호
    o_red,              // 빨강 색상 데이터
    o_green,            // 초록 색상 데이터
    o_blue              // 파랑 색상 데이터
);
    
    input i_Clk;
    input i_Rst;

    input [MAX_SIZE-1:0] i_worm_x;
    input [MAX_SIZE-1:0] i_worm_y;

    input [5:0] i_item_x;
    input [5:0] i_item_y;

    input [9:0] i_size;

    output o_hsync;
    output o_vsync;

    output reg[3:0] o_red;
    output reg[3:0] o_green;
    output reg[3:0] o_blue;

    // 픽셀 클럭 분주 (50MHz -> 25MHz)
    reg pixel_clk;
    always @(posedge i_Clk or posedge i_Rst) begin
        if (i_Rst)
            pixel_clk <= 0;
        else
            pixel_clk <= ~pixel_clk;
    end

    // VGA 640x480 @ 60Hz (25.175 MHz 픽셀 클럭) 타이밍
    parameter H_DISPLAY = 640;
    parameter H_FRONT = 16;
    parameter H_SYNC = 96;
    parameter H_BACK = 48;
    parameter H_TOTAL = 800;

    parameter V_DISPLAY = 480;
    parameter V_FRONT = 10;
    parameter V_SYNC = 2;
    parameter V_BACK = 33;
    parameter V_TOTAL = 525;
    
    parameter PIXEL_SIZE = 10;

    reg [9:0] h_count; // 수평 픽셀 카운터
    reg [9:0] v_count; // 수직 픽셀 카운터

    wire active_area = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);

    // 동기 신호 생성
    assign o_hsync = ~(h_count >= (H_DISPLAY + H_FRONT) && h_count < (H_DISPLAY + H_FRONT + H_SYNC));
    assign o_vsync = ~(v_count >= (V_DISPLAY + V_FRONT) && v_count < (V_DISPLAY + V_FRONT + V_SYNC));

    // 아이템 위치 확대 스케일링
    wire [9:0] item_x_scaled = i_item_x * PIXEL_SIZE;
    wire [9:0] item_y_scaled = i_item_y * PIXEL_SIZE;

    wire item_active = h_count >= item_x_scaled && h_count < item_x_scaled + 10 &&
                       v_count >= item_y_scaled && v_count < item_y_scaled + 10;
    wire edge_active = h_count == 0 || h_count == H_DISPLAY - 1 ||
                       v_count == 0 || v_count == V_DISPLAY - 1;

    reg worm_active;

    // 반복문 변수 선언
    integer j;

    always @(posedge pixel_clk or posedge i_Rst) begin
        if (i_Rst) begin
            h_count <= 0;
            v_count <= 0;
            o_red <= 0;
            o_green <= 0;
            o_blue <= 0;
        end else begin
            // 수평 및 수직 카운터
            if (h_count < H_TOTAL - 1) begin
                h_count <= h_count + 1;
            end else begin
                h_count <= 0;
                if (v_count < V_TOTAL - 1) begin
                    v_count <= v_count + 1;
                end else begin
                    v_count <= 0;
                end
            end

            // 픽셀 데이터 출력
            if (active_area) begin
                worm_active = 0;
                // 지렁이 배열 확인
                for (j = 0; j < i_size; j = j + 1) begin
                    if (h_count >= i_worm_x[j * 6 +:6] * PIXEL_SIZE && h_count < i_worm_x[j * 6 +:6] * PIXEL_SIZE + PIXEL_SIZE &&
                        v_count >= i_worm_y[j * 6 +:6] * PIXEL_SIZE && v_count < i_worm_y[j * 6 +:6] * PIXEL_SIZE + PIXEL_SIZE) begin
                        worm_active = 1;
                    end
                end

                if (worm_active) begin
                    // 지렁이 위치 (빨강색)
                    o_red <= 4'hF;
                    o_green <= 4'h0;
                    o_blue <= 4'h0;
                end else if (item_active) begin
                    // 아이템 위치 (초록색)
                    o_red <= 4'h0;
                    o_green <= 4'hF;
                    o_blue <= 4'h0;
                end else if (edge_active) begin
                    // 가장자리 (흰색)
                    o_red <= 4'hF;
                    o_green <= 4'hF;
                    o_blue <= 4'hF;
                end else begin
                    // 나머지 영역 (검정색)
                    o_red <= 4'h0;
                    o_green <= 4'h0;
                    o_blue <= 4'h0;
                end
            end else begin
                // 640 * 480 영역 밖
                o_red <= 4'h0;
                o_green <= 4'h0;
                o_blue <= 4'h0;
            end
        end
    end
endmodule