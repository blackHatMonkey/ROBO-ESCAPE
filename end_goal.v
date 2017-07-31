module end_goal(flag, x_cord, y_cord, clock);

  // input values
	input [8:0] x_cord, y_cord;
	input clock;

	// output values
	output [2:0] flag;

	reg [2:0] colour;


  always @(posedge clock)
		begin
			// set the default value for collision checking
			colour = 3'b111;

      if (x_cord >= 9'd5 && x_cord <= 9'd20 && y_cord >= 9'd15 && y_cord <= 9'd45)
        colour = 3'b000;

		end

		// assign the output
		assign flag = colour;

endmodule
