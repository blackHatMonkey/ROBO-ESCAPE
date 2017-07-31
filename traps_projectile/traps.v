module traps (flag, x_cord, y_cord, clock);

  // input values
  input  clock;
  input [8:0] x_cord, y_cord;

  // output values
  output [2:0] flag;

  reg [2:0] colour;
  limiter slow_elf (elf_clock, clock, 8'd15);
  // 0 == left, 1 == right
  reg elf_direction;
  reg [8:0] elf_x;
  wire elf_clock;

  // hard coded values for the traps
  localparam platform_1_x_start = 9'd60, platform_1_x_end = 9'd100, platform_1_y = 9'd183,
  platform_2_x_start = 9'd220, platform_2_x_end = 9'd240, platform_3_x_start = 9'd100,
  platform_3_x_end = 9'd140, platform_3_y = 9'd123, platform_4_x_start = 9'd180,
  platform_4_x_end = 9'd220, trap_base_lenght = 9'd3, trap_tip_lenght = 9'd2, black = 3'b000,
  red = 3'b100, yellow = 3'b110, elf_x_min = tower_x - 9'd2,
  elf_x_max = tower_x + tower_width + 2, tower_x = 9'd8, tower_width = 9'd26, tower_y = 9'd120;

  initial
    begin
      elf_x = tower_x + (tower_width / 9'd2);
      elf_direction = 1'b0;
    end

  always @(posedge clock)
    begin
      colour = 3'b000;

      // draw the lava block
      if ((x_cord >= 9'd75 && x_cord <= 9'd200) && (y_cord >= 9'd235 && y_cord <= 9'd250))
        colour = red;

      // draw the trap for platform 1
      // draw the base
      if ((x_cord >= platform_1_x_start + 9'd8 && x_cord <= platform_1_x_end - 9'd8 && x_cord % 2 == 0) &&
          (y_cord >= platform_1_y && y_cord <= (platform_1_y + trap_base_lenght)))
        colour = black;

      // draw the bloody tip
      if ((x_cord >= platform_1_x_start + 9'd8 && x_cord <= platform_1_x_end - 9'd8 && x_cord % 2 == 0) &&
          (y_cord >= (platform_1_y + trap_base_lenght) &&
            y_cord <= (platform_1_y + trap_base_lenght + trap_tip_lenght)))
        colour = red;

      // draw the trap for platform 2
      // draw the base
      if ((x_cord >= platform_2_x_start + 9'd8 && x_cord <= platform_2_x_end - 9'd8 && x_cord % 2 == 0) &&
          (y_cord >= platform_1_y && y_cord <= (platform_1_y + trap_base_lenght)))
        colour = black;

      // draw the bloody tip
      if ((x_cord >= platform_2_x_start + 9'd8 && x_cord <= platform_2_x_end - 9'd8 && x_cord % 2 == 0) &&
          (y_cord >= (platform_1_y + trap_base_lenght) &&
            y_cord <= (platform_1_y + trap_base_lenght + trap_tip_lenght)))
        colour = red;

      // draw the trap for platform 3
      // draw the base
      if ((x_cord >= platform_3_x_start + 9'd8 && x_cord <= platform_3_x_end - 9'd12 && x_cord % 2 == 0) &&
          (y_cord >= platform_3_y && y_cord <= (platform_3_y + trap_base_lenght)))
        colour = black;

      // draw the bloody tip
      if ((x_cord >= platform_3_x_start + 9'd8 && x_cord <= platform_3_x_end - 9'd12 && x_cord % 2 == 0) &&
          (y_cord >= (platform_3_y + trap_base_lenght) &&
            y_cord <= (platform_3_y + trap_base_lenght + trap_tip_lenght)))
        colour = red;

      // draw the trap for platform 4
      // draw the base
      if ((x_cord >= platform_4_x_start + 9'd8 && x_cord <= platform_4_x_end - 9'd8 && x_cord % 2 == 0) &&
          (y_cord >= platform_3_y && y_cord <= (platform_3_y + trap_base_lenght)))
        colour = black;

      // draw the bloody tip
      if ((x_cord >= platform_4_x_start + 9'd8 && x_cord <= platform_4_x_end - 9'd8 && x_cord % 2 == 0) &&
          (y_cord >= (platform_3_y + trap_base_lenght) &&
            y_cord <= (platform_3_y + trap_base_lenght + trap_tip_lenght)))
        colour = red;

    // draw the elf head
    if ((x_cord >= elf_x && x_cord <= elf_x + 9'd5) &&
        (y_cord >= (tower_y - 9'd10) && y_cord <= (tower_y - 9'd5)))
      colour = yellow;

    // draw the elf left eye
    if (x_cord == elf_x + 9'd2 && y_cord == tower_y - 9'd9)
      colour = 3'b010;

    // draw the elf left right
    if (x_cord == elf_x + 9'd4 && y_cord == tower_y - 9'd9)
      colour = 3'b010;

    // draw the elf left ear
    if (x_cord == elf_x - 9'd1 && y_cord == tower_y - 9'd9)
      colour = yellow;

    // draw the elf left eye
    if (x_cord == elf_x + 9'd6 && y_cord == tower_y - 9'd9)
      colour = yellow;

    // draw the elf's mouth
    if ((x_cord >= elf_x + 9'd2 && x_cord <= elf_x + 9'd4) &&
        (y_cord >= tower_y - 9'd7 && y_cord <= 9'd6))
      colour = 3'b111;

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

	 assign flag = colour;

endmodule
