module projectile (flag, x_cord, y_cord, character_x_position, character_y_position, clock);

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

      if (x_cord == character_x_position && y_cord == character_y_position)
        colour = 3'b100;

		end

		// assign the output
		assign flag = colour;

endmodule
