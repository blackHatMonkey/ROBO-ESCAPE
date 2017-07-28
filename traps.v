module traps (flag, x_cord, y_cord, clock);

  // input values
  input  clock;
  input [8:0] x_cord, y_cord;

  // output values
  output [2:0] flag;

  reg [2:0] colour;

  // hard coded values for the traps
  localparam platform_1_x_start = 9'd60, platform_1_x_end = 9'd100, platform_1_y = 9'd183,
  platform_2_x_start = 9'd220, platform_2_x_end = 9'd240, platform_3_x_start = 9'd100,
  platform_3_x_end = 9'd140, platform_3_y = 9'd123, platform_4_x_start = 9'd180,
  platform_4_x_end = 9'd220, trap_base_lenght = 9'd3, trap_tip_lenght = 9'd2, black = 3'b000,
  red = 3'b100;

  always @(posedge clock)
    begin
      colour = 3'b000;

      // draw the lava block
      if ((x_cord >= 9'd75 && x_cord <= 9'd200) && (y_cord >= 9'd236 && y_cord <= 9'd250))
        colour = red;

      // draw the trap for platform 1
      // draw the base
      if ((x_cord >= platform_1_x_start && x_cord <= platform_1_x_end && x_cord % 2 == 0) &&
          (y_cord >= platform_1_y && y_cord <= (platform_1_y + trap_base_lenght)))
        colour = black;

      // draw the bloody tip
      if ((x_cord >= platform_1_x_start && x_cord <= platform_1_x_end && x_cord % 2 == 0) &&
          (y_cord >= (platform_1_y + trap_base_lenght) &&
            y_cord <= (platform_1_y + trap_base_lenght + trap_tip_lenght)))
        colour = red;

      // draw the trap for platform 2
      // draw the base
      if ((x_cord >= platform_2_x_start && x_cord <= platform_2_x_end && x_cord % 2 == 0) &&
          (y_cord >= platform_1_y && y_cord <= (platform_1_y + trap_base_lenght)))
        colour = black;

      // draw the bloody tip
      if ((x_cord >= platform_2_x_start && x_cord <= platform_2_x_end && x_cord % 2 == 0) &&
          (y_cord >= (platform_1_y + trap_base_lenght) &&
            y_cord <= (platform_1_y + trap_base_lenght + trap_tip_lenght)))
        colour = red;

      // draw the trap for platform 3
      // draw the base
      if ((x_cord >= platform_3_x_start && x_cord <= platform_3_x_end && x_cord % 2 == 0) &&
          (y_cord >= platform_3_y && y_cord <= (platform_3_y + trap_base_lenght)))
        colour = black;

      // draw the bloody tip
      if ((x_cord >= platform_3_x_start && x_cord <= platform_3_x_end && x_cord % 2 == 0) &&
          (y_cord >= (platform_3_y + trap_base_lenght) &&
            y_cord <= (platform_3_y + trap_base_lenght + trap_tip_lenght)))
        colour = red;

      // draw the trap for platform 4
      // draw the base
      if ((x_cord >= platform_4_x_start && x_cord <= platform_4_x_end && x_cord % 2 == 0) &&
          (y_cord >= platform_3_y && y_cord <= (platform_3_y + trap_base_lenght)))
        colour = black;

      // draw the bloody tip
      if ((x_cord >= platform_4_x_start && x_cord <= platform_4_x_end && x_cord % 2 == 0) &&
          (y_cord >= (platform_3_y + trap_base_lenght) &&
            y_cord <= (platform_3_y + trap_base_lenght + trap_tip_lenght)))
        colour = red;

	 end

	 assign flag = colour;

endmodule
