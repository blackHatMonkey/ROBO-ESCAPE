module projectile_1 (flag, x_cord, y_cord, character_x_position, character_y_position, clock);

  // input values
	input [8:0] x_cord, y_cord;
	input clock;
	input [8:0] character_x_position, character_y_position;

	// output values
	output [2:0] flag;

	reg [2:0] colour;

  always @(posedge clock)
		begin
			// set the default value for collision checking
			colour = 3'b000;
      if (((y_cord - character_y_position) * (y_cord - character_y_position)) + ((x_cord - character_x_position) * (x_cord - character_x_position)) <= 100)
        colour = 3'b100;
			end

		// assign the output
		assign flag = colour;

endmodule

module projectile_3 (flag, x_cord, y_cord, character_x_position, character_y_position, clock);

  // input values
	input [8:0] x_cord, y_cord;
	input clock;
	input [8:0] character_x_position, character_y_position;

	// output values
	output [2:0] flag;

	reg [2:0] colour;

  always @(posedge clock)
		begin
			// set the default value for collision checking
			colour = 3'b000;
			begin
			if (x_cord >= character_x_position && x_cord <= character_x_position + 8 && y_cord == character_y_position)
				colour = 3'b100;
			end
		end

		// assign the output
		assign flag = colour;

endmodule
