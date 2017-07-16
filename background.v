module background (flag, x_cord, y_cord, clock);

  // input values
  input  clock;
  input [8:0] x_cord, y_cord;

  // output values
  output [2:0] flag;

  reg [2:0] colour;

  // hard coded positions for the background objects
  localparam platform_1_x_start = 9'd60, platform_1_x_end = 9'd100, platform_1_y = 9'd180,
  platform_2_x_start = 9'd220, platform_2_x_end = 9'd260, platform_2_y = 9'd180,
  platform_3_x_start = 9'd100, platform_3_x_end = 9'd140, platform_3_y = 9'd120,
  platform_4_x_start = 9'd180, platform_4_x_end = 9'd220, platform_4_y = 9'd120,
  platform_5_x_start = 9'd140, platform_5_x_end = 9'd180, platform_5_y = 9'd60,
  grave_y = 9'd169, grave_length = 8, grave_x = 9'd245, grave_width = 6,
  grass_y_start = 9'd234, grass_y_end = 9'd239,
  sacred_tree_x_start = 9'd15, sacred_tree_x_end = 9'd45;

  always @(posedge clock)
    begin
    // default colour
    colour = 3'b000;

    // draw platform 1
    if (y_cord == platform_1_y && (x_cord >= platform_1_x_start && x_cord <= platform_1_x_end))
      colour = 3'b111;

    // draw platform 2
    if (y_cord == platform_2_y && (x_cord >= platform_2_x_start && x_cord <= platform_2_x_end))
      colour = 3'b111;

    // draw platform 3
    if (y_cord == platform_3_y && (x_cord >= platform_3_x_start && x_cord <= platform_3_x_end))
      colour = 3'b111;

    // draw platform 4
    if (y_cord == platform_4_y && (x_cord >= platform_4_x_start && x_cord <= platform_4_x_end))
      colour = 3'b111;

    // draw platform 5
    if (y_cord == platform_5_y && (x_cord >= platform_5_x_start && x_cord <= platform_5_x_end))
      colour = 3'b111;

    // draw the grass block
    if ((x_cord >= 9'd0 && x_cord <= 9'd320) && (y_cord >= 9'd236 && y_cord <= 9'd250))
      colour = 3'b010;

    // draw the tree
    if (x_cord >= sacred_tree_x_start && x_cord <= sacred_tree_x_end)
      colour = 3'b111;

    // draw the grave on platform 2
    if ((x_cord >= grave_x && x_cord <= (grave_x + grave_width)) && (y_cord >= grave_y && y_cord <= (grave_y + grave_length)))
      colour = 3'b111;

    end

  // assign the output
  assign flag = colour;

endmodule
