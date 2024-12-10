module ScoreFND (score, score_one, score_ten, score_hun);
    input  [8:0] score;
    output reg [3:0] score_one;
    output reg [3:0] score_ten; 
    output reg [3:0] score_hun;



    integer temp_score;
    always @(*) begin
        temp_score = score;

        score_one = 4'd10;
        score_ten = 4'd10;
        score_hun = 4'd10;

        if (temp_score >= 100) begin
            score_hun = temp_score / 100;
            temp_score = temp_score % 100; 
        end

        if (temp_score >= 10) begin
            score_ten = temp_score / 10;
            temp_score = temp_score % 10; 
        end

        score_one = temp_score; 
    end

endmodule