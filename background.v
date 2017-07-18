module background (flag, x_cord, y_cord, clock);

  // input values
  input  clock;
  input [8:0] x_cord, y_cord;

  // output values
  output [2:0] flag;

  reg [2:0] colour;

  // hard coded positions for the background objects
  localparam white = 3'b111, platform_1_x = 9'd60, platform_1_y = 9'd180,
  full_platform_length = 40, full_platform_width = 3, platform_2_x = 9'd220,
  platform_3_x = 9'd100, platform_3_y = 9'd120, platform_4_x = 9'd180,
  platform_5_x = 9'd140, platform_5_y = 9'd60,
  small_platform_length = 10, small_platform_width = 3,
  small_platform_1_x = 9'd75, small_platform_1_y = 9'd220,
  small_platform_2_x = 9'd240, small_platform_3_x = 9'd45,
  small_platform_3_y = 9'd200, small_platform_4_x = 9'd270,
  small_platform_5_x = 9'd90, small_platform_5_y = 9'd160,
  small_platform_6_x = 9'd210, small_platform_7_x = 9'd160,
  small_platform_7_y = 9'd140, small_platform_8_x = 9'd80,
  small_platform_8_y = 9'd100, small_platform_9_x = 9'd240,
  small_platform_10_x = 9'd120, small_platform_10_y = 9'd80,
  small_platform_11_x = 9'd200, tower_x = 9'd8, tower_y = 9'd120,
  tower_lenght = 120, tower_width = 25, window_border_length = 320,
  window_border_width = 240, top_left_corner = 9'd0, top_right_corner = 9'd320,
  bottom_left_corner = 9'd240 , helicopter_x = 9'd170, helicopter_y = 9'd50;

  always @(posedge clock)
    begin
    // default colour
    colour = 3'b000;

    // draw the top border
    if (y_cord == top_left_corner && (x_cord >= top_left_corner &&
        x_cord <= (top_left_corner + window_border_length)))
      colour = white;

    // draw the left border
    if (x_cord == top_left_corner && (y_cord >= top_left_corner &&
        y_cord <= top_left_corner + window_border_width))
      colour = white;

    // draw the bottom border
    if (y_cord == bottom_left_corner && (x_cord >= top_left_corner &&
        x_cord <= (top_left_corner + window_border_length)))
      colour = white;

    // draw the right border
    if (x_cord == top_right_corner && (y_cord >= top_left_corner &&
        y_cord <= top_left_corner + window_border_width))
      colour = white;

    // draw platform 1
    if ((x_cord >= platform_1_x && x_cord <= (platform_1_x + full_platform_length)) &&
        (y_cord >= platform_1_y && y_cord <= (platform_1_y + full_platform_width)))
      colour = white;

    // draw platform 2
    if ((x_cord >= platform_2_x && x_cord <= (platform_2_x + full_platform_length)) &&
        (y_cord >= platform_1_y && y_cord <= (platform_1_y + full_platform_width)))
      colour = white;

    // draw platform 3
    if ((x_cord >= platform_3_x && x_cord <= (platform_3_x + full_platform_length)) &&
        (y_cord >= platform_3_y && y_cord <= (platform_3_y + full_platform_width)))
      colour = white;

    // draw platform 4
    if ((x_cord >= platform_4_x && x_cord <= (platform_4_x + full_platform_length)) &&
        (y_cord >= platform_3_y && y_cord <= (platform_3_y + full_platform_width)))
      colour = white;

    // draw platform 5
    if ((x_cord >= platform_5_x && x_cord <= (platform_5_x + full_platform_length)) &&
        (y_cord >= platform_5_y && y_cord <= (platform_5_y + full_platform_width)))
      colour = white;


    // draw small platform 1
    if ((x_cord >= small_platform_1_x && x_cord <= (small_platform_1_x + small_platform_length)) &&
        (y_cord >= small_platform_1_y && (y_cord <= (small_platform_1_y + small_platform_width))))
      colour = white;

    // draw small platform 2
    if ((x_cord >= small_platform_2_x && x_cord <= (small_platform_2_x + small_platform_length)) &&
        (y_cord >= small_platform_1_y && (y_cord <= (small_platform_1_y + small_platform_width))))
      colour = white;

    // draw small platform 3
    if ((x_cord >= small_platform_3_x && x_cord <= (small_platform_3_x + small_platform_length)) &&
        (y_cord >= small_platform_3_y && (y_cord <= (small_platform_3_y + small_platform_width))))
      colour = white;

    // draw small platform 4
    if ((x_cord >= small_platform_4_x && x_cord <= (small_platform_4_x + small_platform_length)) &&
        (y_cord >= small_platform_3_y && (y_cord <= (small_platform_3_y + small_platform_width))))
      colour = white;

    // draw small platform 5
    if ((x_cord >= small_platform_5_x && x_cord <= (small_platform_5_x + small_platform_length)) &&
        (y_cord >= small_platform_5_y && (y_cord <= (small_platform_5_y + small_platform_width))))
      colour = white;

    // draw small platform 6
    if ((x_cord >= small_platform_6_x && x_cord <= (small_platform_6_x + small_platform_length)) &&
        (y_cord >= small_platform_5_y && (y_cord <= (small_platform_5_y + small_platform_width))))
      colour = white;

    // draw small platform 7
    if ((x_cord >= small_platform_7_x && x_cord <= (small_platform_7_x + small_platform_length)) &&
        (y_cord >= small_platform_7_y && (y_cord <= (small_platform_7_y + small_platform_width))))
      colour = white;

    // draw small platform 8
    if ((x_cord >= small_platform_8_x && x_cord <= (small_platform_8_x + small_platform_length)) &&
        (y_cord >= small_platform_8_y && (y_cord <= (small_platform_8_y + small_platform_width))))
      colour = white;

    // draw small platform 9
    if ((x_cord >= small_platform_9_x && x_cord <= (small_platform_9_x + small_platform_length)) &&
        (y_cord >= small_platform_8_y && (y_cord <= (small_platform_8_y + small_platform_width))))
      colour = white;

    // draw small platform 10
    if ((x_cord >= small_platform_10_x && x_cord <= (small_platform_10_x + small_platform_length)) &&
        (y_cord >= small_platform_10_y && (y_cord <= (small_platform_10_y + small_platform_width))))
      colour = white;

    // draw small platform 11
    if ((x_cord >= small_platform_11_x && x_cord <= (small_platform_11_x + small_platform_length)) &&
        (y_cord >= small_platform_10_y && (y_cord <= (small_platform_10_y + small_platform_width))))
      colour = white;

    // draw the grass block
    if ((x_cord >= 9'd0 && x_cord <= 9'd320) && (y_cord >= 9'd236 && y_cord <= 9'd250))
      colour = 3'b010;

    // draw the tower body
    if ((x_cord >= tower_x && x_cord <= (tower_x + tower_width)) &&
        (y_cord <= tower_y && y_cord <= (tower_y + tower_lenght)))
      colour = white;

    // draw the tower top
    if ((x_cord >= (tower_x - 3) && x_cord <= (tower_x + tower_width + 3)) &&
        (y_cord >= (tower_y - 5) && y_cord <= tower_y))
      colour = white;

    // draw the helicopter's main body
    if ((x_cord >= helicopter_x && x_cord <= (helicopter_x + 20)) &&
        (y_cord >= helicopter_y && y_cord <= (helicopter_y + 20)))
      colour = 3'b110;

    // draw the helicopter's back part 1
    if ((x_cord >= (helicopter_x + 20) && x_cord <= (helicopter_x + 30)) &&
        (y_cord >= (helicopter_y + 5) && y_cord <= (helicopter_y + 15)))
      colour = 3'b110;

    // draw the helicopter's back part 2
    if ((x_cord >= (helicopter_x + 30) && x_cord <= (helicopter_x + 35)) &&
        (y_cord >= helicopter_y && y_cord <= (helicopter_y + 15)))
      colour = 3'b110;

    // draw the helicopter's front
    if ((x_cord >= (helicopter_x - 5) && x_cord <= helicopter_x) &&
        (y_cord >= (helicopter_y + 10) && y_cord <= (helicopter_y + 20)))
      colour = 3'b110;

    end

  // assign the output
  assign flag = colour;

endmodule
