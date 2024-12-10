module ScoreFND (i_score, o_score_one, o_score_ten, o_score_hun, o_score_thou);
    input  [11:0] i_score;
    output reg [3:0] o_score_one;
    output reg [3:0] o_score_ten; 
    output reg [3:0] o_score_hun;
    output reg [3:0] o_score_thou;

    reg [11:0] temp_score;

    always @(*) begin
        temp_score = i_score;

        o_score_one = 4'd10;
        o_score_ten = 4'd10;
        o_score_hun = 4'd10;
        o_score_thou = 4'd10;

        if (temp_score >= 1000) begin
            o_score_thou = temp_score / 1000;
            temp_score = temp_score % 1000; 
        end

        if (temp_score >= 100) begin
            o_score_hun = temp_score / 100;
            temp_score = temp_score % 100; 
        end

        if (temp_score >= 10) begin
            o_score_ten = temp_score / 10;
            temp_score = temp_score % 10; 
        end

        o_score_one = temp_score; 
    end

endmodule