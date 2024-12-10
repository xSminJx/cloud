module SpeedFND (speed, speed_one, speed_ten);
    input  [7:0] speed;
    output reg [3:0] speed_one;
    output reg [3:0] speed_ten; 

    integer temp_speed;
    always @(*) begin
        temp_speed = speed;

        speed_one = 4'd10;
        speed_ten = 4'd10;

        if (temp_speed >= 10) begin
            speed_ten = temp_speed / 10; 
            temp_speed = temp_speed % 10; 
        end

        speed_one = temp_speed;
    end

endmodule