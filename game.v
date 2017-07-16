`timescale 1ns / 1ns // `timescale time_unit/time_precision

module game (CLOCK_50, KEY, SW, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B);

	//	50 MHz
	input			CLOCK_50;
	// TODO remove these after testing
	input [3:0] KEY;
	input [4:0] SW;

	// VGA related
	output VGA_CLK;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK_N;
	output VGA_SYNC_N;
	output [9:0] VGA_R;
	output [9:0] VGA_G;
	output [9:0] VGA_B;

	wire [2:0] colour;
	wire [8:0] x;
	wire [8:0] y;

	// create an instance of a VGA controller
	vga_adapter VGA(1'b1, CLOCK_50, colour, x, y, 1'b1, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);

	// define the resolution, number of colours as well as the initial background
	// image file (.MIF) for the controller
	defparam VGA.RESOLUTION = "320x240";
	defparam VGA.MONOCHROME = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE = "black.mif";

	draw d(x, y, colour, CLOCK_50, 9'd320, 9'd240, KEY[3:0]);

endmodule
