module character (flag, x_cord, y_cord, character_x_position, character_y_position, clock);

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
			colour = 3'b111;

			// draw character
			// draw head of the character
			if ((x_cord >= (character_x_position + 1) && x_cord <= (character_x_position + 6)) &&
					(y_cord >= (character_y_position - 5) && y_cord <= character_y_position))
				colour = 3'b000;

			// draw the torso of the chracter
			if ((x_cord >= character_x_position && x_cord <= (character_x_position + 7)) &&
					(y_cord >= character_y_position && y_cord <= (character_y_position + 7)))
				colour = 3'b101;

			// draw the left arm of the character
			if ((x_cord >= (character_x_position - 1) && x_cord <= character_x_position) &&
					(y_cord >= (character_y_position + 2) && y_cord <= (character_y_position + 4)))
				colour = 3'b000;

			if ((x_cord >= (character_x_position - 3) && x_cord <= (character_x_position - 1)) &&
					(y_cord >= (character_y_position - 5) && y_cord <= (character_y_position + 4)))
				colour = 3'b000;

			// draw the right arm of the character
			if ((x_cord >= (character_x_position + 7) && x_cord <= (character_x_position + 8)) &&
					(y_cord >= (character_y_position + 2) && y_cord <= (character_y_position + 4)))
				colour = 3'b000;

			if ((x_cord >= (character_x_position + 8) && x_cord <= (character_x_position + 10)) &&
					(y_cord >= (character_y_position - 5) && y_cord <= (character_y_position + 4)))
				colour = 3'b000;


			// draw the left foot of the character
			if ((x_cord >= (character_x_position + 1) && x_cord <= (character_x_position + 3)) &&
					(y_cord >= (character_y_position + 7) && y_cord <= (character_y_position + 11)))
				colour = 3'b000;

			// draw the right foot of the character
			if ((x_cord >= (character_x_position + 4) && x_cord <= (character_x_position + 6)) &&
					(y_cord >= (character_y_position + 7) && y_cord <= (character_y_position + 11)))
				colour = 3'b000;

			// draw the left eye of the character
			if (x_cord == (character_x_position + 2) &&  y_cord == (character_y_position - 3))
				colour = 3'b100;

			// draw the right eye of the character
			if (x_cord == (character_x_position + 4) &&  y_cord == (character_y_position - 3))
				colour = 3'b100;

		end

		// assign the output
		assign flag = colour;

endmodule
