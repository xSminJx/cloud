module SpeedFND (i_speed, o_speed_one, o_speed_ten);
    input  [7:0] i_speed;
    output reg [3:0] o_speed_one;
    output reg [3:0] o_speed_ten; 

    reg [7:0] temp_speed;

    always @(*) begin
        temp_speed = i_speed;

        o_speed_one = 4'd10;
        o_speed_ten = 4'd10;

        if (temp_speed >= 10) begin
            o_speed_ten = temp_speed / 10; 
            temp_speed = temp_speed % 10; 
        end

        o_speed_one = temp_speed;
    end

endmodule