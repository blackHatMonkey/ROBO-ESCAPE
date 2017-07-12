
module game
	(
		CLOCK_50,						//	On Board 50 MHz
    KEY,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX0,
		HEX1
	);

	input			CLOCK_50;				//	50 MHz
	// TODO remove these after testing
	input   [3:0]   KEY;

	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output [6:0] HEX0, HEX1;

	wire resetn;

	assign resetn = 1'b1;

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [9:0] x;
	wire [9:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

	draw d(x, y, colour, CLOCK_50, 10'd320, 10'd240, !KEY[3:0]);
	reg [0:0] a, b, c, d2;
	wire a1, b1, c1, d1;

	always @ (*)
		begin
			if (OTG_DATA[0] == 1'b1) a = 1'b1;
			else a = 1'b0;

			if (OTG_DATA[1] == 1'b1) b = 1'b1;
			else b = 1'b0;

			if (OTG_DATA[2] == 1'b1) c = 1'b1;
			else c = 1'b0;

			if (OTG_DATA[3] == 1'b1) d2 = 1'b1;
			else d2 = 1'b0;
		end

	assign writeEn = 1'b1;
	assign a1 = a;
	assign b1 = b;
	assign c1 = c;
	assign d1 = d2;
	assign LEDR[0] = a1;
	assign LEDR[1] = b1;
	assign LEDR[2] = c1;
	assign LEDR[3] = d1;


endmodule

module draw (x_out, y_out, colour_out, clock, max_x, max_y, key);

	input clock;
	input [9:0] max_x, max_y;
	input [3:0] key;

	output [9:0] x_out, y_out;
	output [2:0] colour_out;

	wire [9:0] x_out_wire, y_out_wire;
	wire [2:0] colour_out_wire;

	reg [9:0] x_cord, y_cord;
	reg [2:0] colour;
	reg [9:0] character_x_position, character_y_position;

	wire new_clock;

	limiter l(new_clock, clock, 27'd30);

	initial
		begin
			character_x_position = 10'd0;
			character_y_position = 10'd205;
		end

		localparam platform_1_x_start = 10'd60, platform_1_x_end = 10'd100, platform_1_y = 10'd180,
							 platform_2_x_start = 10'd220, platform_2_x_end =10'd260, platform_2_y = 10'd180,
							 platform_3_x_start = 10'd100, platform_3_x_end = 10'd140, platform_3_y = 10'd120,
							 platform_4_x_start = 10'd180, platform_4_x_end = 10'd220, platform_4_y = 10'd120,
							 platform_5_x_start = 10'd140, platform_5_x_end = 10'd180, platform_5_y = 10'd60,
							 grave_y = 10'd169, grave_length = 8, grave_x = 10'd245, grave_width = 6,
							 grass_y_start = 10'd234, grass_y_end = 10'd239,
							 sacred_tree_x_start = 10'd15, sacred_tree_x_end = 10'd45;


	always @ (posedge clock)
		begin
			// set the background colour to black
			colour = 3'b001;

			// if we have reached the maximum x cordinate move to the next row otherwise move to the
			// next pixel
			if (x_cord == max_x)
				begin
					x_cord = 10'b0;
					y_cord = y_cord + 1;
				end
			else
				begin
					x_cord = x_cord + 1;
				end

			// if we have reached the maximum y value start from the begining
			if (y_cord == max_y)
				begin
					y_cord = 10'b0;
				end

			// draw platform 1
			if (y_cord == platform_1_y && (x_cord >= platform_1_x_start && x_cord <= platform_1_x_end))
				begin
					colour = 3'b111;
				end

			// draw platform 2
			if (y_cord == platform_2_y && (x_cord >= platform_2_x_start && x_cord <= platform_2_x_end))
				begin
					colour = 3'b111;
				end

			// draw platform 3
			if (y_cord == platform_3_y && (x_cord >= platform_3_x_start && x_cord <= platform_3_x_end))
				begin
					colour = 3'b111;
				end

			// draw platform 4
			if (y_cord == platform_4_y && (x_cord >= platform_4_x_start && x_cord <= platform_4_x_end))
				begin
					colour = 3'b111;
				end

			// draw platform 5
			if (y_cord == platform_5_y && (x_cord >= platform_5_x_start && x_cord <= platform_5_x_end))
				begin
					colour = 3'b111;
				end

			// draw the grass
			if (x_cord % 2 == 0 && (y_cord >= grass_y_start && y_cord <= grass_y_end))
				begin
					colour = 3'b010;
				end

			// draw the tree
			if (x_cord >= sacred_tree_x_start && x_cord <= sacred_tree_x_end)
				begin
					colour = 3'b111;
				end

			// draw the grave on platform 2
			if ((x_cord >= grave_x && x_cord <= (grave_x + width)) && (y_cord >= grave_y && y_cord <= (grave_y + grave_length)))
				begin
					colour = 3'b111;
				end

			// draw character
			// draw head of the character
			if ((x_cord >= (character_x_position + 1) && x_cord <= (character_x_position + 6)) &&
				  (y_cord >= (character_y_position - 5) && y_cord <= character_y_position))
				begin
					colour = 3'b000;
				end

			// draw the torso of the chracter
			if ((x_cord >= character_x_position && x_cord <= (character_x_position + 7)) &&
					(y_cord >= character_y_position && y_cord <= (character_y_position + 7)))
				begin
					colour = 3'b101;
				end

			// draw the left arm of the character
			if ((x_cord >= (character_x_position - 1) && x_cord <= character_x_position) &&
					(y_cord >= (character_y_position + 2) && y_cord <= (character_y_position + 4)))
				begin
					colour = 3'b000;
				end

			if ((x_cord >= (character_x_position - 3) && x_cord <= (character_x_position - 1)) &&
					(y_cord >= (character_y_position - 5) && y_cord <= (character_y_position + 4)))
				begin
					colour = 3'b000;
				end

			// draw the right arm of the character
			if ((x_cord >= (character_x_position + 7) && x_cord <= (character_x_position + 8)) &&
					(y_cord >= (character_y_position + 2) && y_cord <= (character_y_position + 4)))
				begin
					colour = 3'b000;
				end

			if ((x_cord >= (character_x_position + 8) && x_cord <= (character_x_position + 10)) &&
					(y_cord >= (character_y_position - 5) && y_cord <= (character_y_position + 4)))
				begin
					colour = 3'b000;
				end

			// draw the left foot of the character
			if ((x_cord >= (character_x_position + 1) && x_cord <= (character_x_position + 3)) &&
					(y_cord >= (character_y_position + 7) && y_cord <= (character_y_position + 11)))
				begin
					colour = 3'b000;
				end

			// draw the right foot of the character
			if ((x_cord >= (character_x_position + 4) && x_cord <= (character_x_position + 6)) &&
					(y_cord >= (character_y_position + 7) && y_cord <= (character_y_position + 11)))
				begin
					colour = 3'b000;
				end

			// draw the left eye of the character
			if (x_cord == (character_x_position + 2) &&  y_cord == (character_y_position - 3))
				begin
					colour = 3'b100;
				end

			// draw the right eye of the character
			if (x_cord == (character_x_position + 4) &&  y_cord == (character_y_position - 3))
				begin
					colour = 3'b100;
				end
		end

		always @ (posedge new_clock)
			begin
				// move the character to the left if the left key is pressed (key[1])
				if (key[1] == 1'b1) character_x_position = character_x_position - 1;
				else character_x_position = character_x_position;

				// move the chracter to the right if the right key is pressed (key[0])
				if (key[0] == 1'b1) character_x_position = character_x_position + 1;
				else character_x_position = character_x_position;
			end

	// assign the registers to the wire counter parts
	assign x_out_wire = x_cord;
	assign y_out_wire = y_cord;
	assign colour_out_wire = colour;

	// assign the wires to the output
	assign x_out = x_out_wire;
	assign y_out = y_out_wire;
	assign colour_out = colour_out_wire;

endmodule


/*
	This module is responsible for reducing the on board clock speed of 5 MHz
	(CLOCK_50) to the desired number of cycle determined by the rate argument.
*/
module limiter (out, clock, rate);

	input clock;
	input [26:0] rate;

	output out;

	wire [26:0] max_value;
	wire out_wire;
	reg out_reg;

	assign max_value = 26'd50000000 / rate;
	reg [26:0] counter;

	always @(posedge clock)
		begin
			if (counter == max_value)
			begin
				counter = 26'd0;
				out_reg = 1'b1;
			end
			else
				begin
					counter = counter + 1;
					out_reg = 1'b0;
				end
		end

	assign out = out_wire;
	assign out_wire = out_reg;

endmodule
