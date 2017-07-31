module background (flag, x_cord, y_cord, clock);

  // input values
  input  clock;
  input [8:0] x_cord, y_cord;

  // output values
  output [2:0] flag;

  reg [2:0] colour;

  reg [8:0] platform_5_x;

  reg [8:0] helicopter_y;

  reg [8:0] elf_x;

  // 0 == left, 1 == right
  reg platform_direction;

  // 0 == down, 1 == up
  reg helicopter_direction;

  // 0 == left, 1 == right
  reg elf_direction;

  wire platform_clock;
  wire helicopter_clock;
  wire elf_clock;

  limiter slow_platform (platform_clock, clock, 8'd40);
  limiter slow_helicopter (helicopter_clock, clock, 8'd10);
  limiter slow_elf (elf_clock, clock, 8'd15);


  // hard coded positions for the background objects
  localparam white = 3'b111, platform_1_x = 9'd60, platform_1_y = 9'd180,
  full_platform_length = 9'd40, full_platform_width = 9'd3, platform_2_x = 9'd220,
  platform_3_x = 9'd100, platform_3_y = 9'd120, platform_4_x = 9'd180,
  platform_5_y = 9'd70, platform_5_x_min = 9'd40, platform_5_x_max = 9'd250,
  small_platform_length = 9'd10, small_platform_width = 9'd3,
  small_platform_1_x = 9'd45,
  small_platform_1_y = 9'd210, small_platform_2_x = 9'd270,
  small_platform_3_x = 9'd130, small_platform_3_y = 9'd160,
  small_platform_4_x = 9'd170, small_platform_5_x = 9'd150,
  small_platform_5_y = 9'd145, small_platform_6_x = 9'd80,
  small_platform_6_y = 9'd110, small_platform_7_x = 9'd240,
  small_platform_8_x = 9'd120, small_platform_8_y = 9'd95,
  small_platform_9_x = 9'd200, tower_x = 9'd8, tower_y = 9'd120,
  tower_lenght = 9'd120, tower_width = 9'd26, window_border_length = 9'd320,
  window_border_width = 9'd240, top_left_corner = 9'd0, top_right_corner = 9'd320,
  bottom_left_corner = 9'd240 , helicopter_x = 9'd240, helicopter_y_max = 9'd10,
  helicopter_y_min = 9'd40, grass_y_start = 9'd236, grass_y_end = 9'd250,
  yellow = 3'b110, elf_x_min = tower_x - 9'd2,
  elf_x_max = tower_x + tower_width + 2;

  initial
    begin
      platform_5_x = 9'd160;
      platform_direction = 1'b0;

      helicopter_y = 9'd10;
      helicopter_direction = 1'b0;

      elf_x = tower_x + (tower_width / 9'd2);
      elf_direction = 1'b0;
    end

  // draw all the intractable background objects
  always @(posedge clock)
    begin
    // default colour
    colour = 3'b000;

    // draw the top border
    if (y_cord == top_left_corner && (x_cord >= top_left_corner &&
        x_cord <= window_border_length))
      colour = 3'b001;

    // draw the left border
    if (x_cord == top_left_corner && (y_cord >= top_left_corner &&
        y_cord <= top_left_corner + window_border_width))
      colour = 3'b001;

    // draw the bottom border
    if (y_cord == bottom_left_corner && (x_cord >= top_left_corner &&
        x_cord <= (top_left_corner + window_border_length)))
      colour = 3'b001;

    // draw the right border
    if (x_cord == top_right_corner && (y_cord >= top_left_corner &&
        y_cord <= top_left_corner + window_border_width))
      colour = 3'b001;

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
        (y_cord >= small_platform_6_y && (y_cord <= (small_platform_6_y + small_platform_width))))
      colour = white;

    // draw small platform 7
    if ((x_cord >= small_platform_7_x && x_cord <= (small_platform_7_x + small_platform_length)) &&
        (y_cord >= small_platform_6_y && (y_cord <= (small_platform_6_y + small_platform_width))))
      colour = white;

    // draw small platform 8
    if ((x_cord >= small_platform_8_x && x_cord <= (small_platform_8_x + small_platform_length)) &&
        (y_cord >= small_platform_8_y && (y_cord <= (small_platform_8_y + small_platform_width))))
      colour = white;

    // draw small platform 9
    if ((x_cord >= small_platform_9_x && x_cord <= (small_platform_9_x + small_platform_length)) &&
        (y_cord >= small_platform_8_y && (y_cord <= (small_platform_8_y + small_platform_width))))
      colour = white;

    // draw the grass block
    if ((x_cord >= 9'd0&& x_cord <= 9'd74) &&
        (y_cord >= grass_y_start && y_cord <= grass_y_end))
      colour = 3'b010;

    //
    if ((x_cord >= 9'd201 && x_cord <= 9'd320) &&
      (y_cord >= grass_y_start && y_cord <= grass_y_end))
    colour = 3'b010;

    // draw the tower body
    if ((x_cord >= tower_x && x_cord <= (tower_x + tower_width)) &&
        (y_cord >= tower_y && y_cord <= (tower_y + tower_lenght)))
      colour = white;

    // draw the tower top
    if ((x_cord >= (tower_x - 9'd3) && x_cord <= (tower_x + tower_width + 9'd3)) &&
        (y_cord >= (tower_y - 9'd5) && y_cord <= tower_y))
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

    // draw the helicopter's front weapon
    if ((x_cord >= (helicopter_x - 9) && x_cord <= (helicopter_x - 5)) &&
        (y_cord >= (helicopter_y + 13) && y_cord <= (helicopter_y + 17)))
      colour = 3'b110;

    // draw the helicopters propeller base
    if ((x_cord >= (helicopter_x + 10) && x_cord <= (helicopter_x + 14)) &&
        (y_cord >= helicopter_y && y_cord <= (helicopter_y - 4)))
      colour = 3'b110;

    // draw the helicopters propeller
    if ((x_cord >= (helicopter_x -3) && x_cord <= (helicopter_x + 29)) &&
        (y_cord >= (helicopter_y - 6) && y_cord <= (helicopter_y - 4)))
      colour = 3'b110;

    // draw the helicopter's cabin base line
    if ((x_cord >= helicopter_x && x_cord <= (helicopter_x + 20)) &&
        (y_cord == (helicopter_y + 10)))
      colour = 3'b011;

    // draw the helicopter's cabin window line
    if ((x_cord == (helicopter_x + 10) &&
        (y_cord >= helicopter_y && y_cord <= (helicopter_y + 10))))
      colour = 3'b011;
    end

    // move the platform right and left
    always @(posedge platform_clock)
      begin
        // reverse the direction if we have reached the end of line
        if (platform_5_x == platform_5_x_min)
          platform_direction = 1'b1;
        else if (platform_5_x == platform_5_x_max)
          platform_direction = 1'b0;

        // when we should moving left
        if (platform_direction == 1'b0)
          platform_5_x = platform_5_x - 9'd1;
        // when we should moving right
        else
          platform_5_x = platform_5_x + 9'd1;
      end


    // move the helicopter up and down
    always @(posedge helicopter_clock)
      begin
        // reverse the direction if we have reached the end points
        if (helicopter_y == helicopter_y_max)
          helicopter_direction = 1'b0;
        else if (helicopter_y == helicopter_y_min)
          helicopter_direction = 1'b1;

        // when we should moving down
        if (helicopter_direction == 1'b0)
          helicopter_y = helicopter_y + 9'd1;
        // when we should moving up
        else
          helicopter_y = helicopter_y - 9'd1;
      end

    // move the elf left and right
    always @(posedge elf_clock)
      begin
        // reverse the direction if we have reached the end of line
        if (elf_x == elf_x_min)
          elf_direction = 1'b1;
        else if (elf_x == elf_x_max)
          elf_direction = 1'b0;

        // when we should moving left
        if (elf_direction == 1'b0)
          elf_x = elf_x - 9'd1;
        // when we should moving right
        else
          elf_x = elf_x + 9'd1;
      end

  // assign the output
  assign flag = colour;

endmodule
