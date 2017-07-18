module collision(is_colliding, character_x_position, character_y_position, side_arg, clock);

  // input values
	input [8:0] character_x_position, character_y_position;
	input clock;

	// output values
	output is_colliding;

	reg collision;
	reg c2;

	reg [8:0] counter = character_y_position;
	reg [8:0] max_value = character_y_position + 10;

	wire [2:0] back_out;


	background b_check(back_out, character_x_position, counter, clock)

  always @(posedge clock)
		begin
			collision = 1;

			if (counter == max_value && c2 == 1'b0)
				begin
					counter = character_y_position;
					collision = 1'b0;
					c2 = 1'b1;
				end
			else
				begin

				if (back_out != 3'b000)
					c2 = 1'b0;
					counter = counter + 9'd1;

				end

		end

		// assign the output
		assign is_colliding = collision;

endmodule
