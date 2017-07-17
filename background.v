module background (flag, x_cord, y_cord, clock);

  // input values
  input  clock;
  input [8:0] x_cord, y_cord;

  // output values
  output [2:0] flag;

  reg [2:0] colour;

  // hard coded positions for the background objects
  localparam white = 3'b111, platform_1_x = 9'd60, platform_1_y = 9'd180, full_platform_length = 40,
  full_platform_width = 3, platform_2_x = 9'd220, platform_3_x = 9'd100, platform_3_y = 9'd120,
  platform_4_x = 9'd180, platform_5_x = 9'd140, platform_5_y = 9'd60, grave_y = 9'd169,
  grave_length = 8, grave_x = 9'd245, grave_width = 6, small_platform_length = 10,
  small_platform_width = 3, small_platform_1_x = 9'd75, small_platform_1_y = 9'd220,
  small_platform_2_x = 9'd240, small_platform_3_x = 9'd45, small_platform_3_y = 9'd200,
  small_platform_4_x = 9'd270, small_platform_5_x = 9'd90, small_platform_5_y = 9'd160,
  small_platform_6_x = 9'd210, small_platform_7_x = 9'd160, small_platform_7_y = 9'd140,
  small_platform_8_x = 9'd80, small_platform_8_y = 9'd100, small_platform_9_x = 9'd240,
  small_platform_10_x = 9'd120, small_platform_10_y = 9'd80, small_platform_11_x = 9'd200,
  sacred_tree_x_start = 9'd8, sacred_tree_x_end = 9'd33;

  always @(posedge clock)
    begin
    // default colour
    colour = 3'b000;

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
        (y_cord >= platform_2_y && y_cord <= (platform_3_y + full_platform_width)))
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

    // draw the tree
    if (x_cord >= sacred_tree_x_start && x_cord <= sacred_tree_x_end)
      colour = white;

    // draw the grave on platform 2
    if ((x_cord >= grave_x && x_cord <= (grave_x + grave_width)) &&
        (y_cord >= grave_y && y_cord <= (grave_y + grave_length)))
      colour = white;

    end

  // assign the output
  assign flag = colour;

endmodule
