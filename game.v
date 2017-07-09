
module game
	(
		CLOCK_50,						//	On Board 50 MHz
    KEY,
    SW,
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
	input   [9:0]   SW;
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
	wire [7:0] x;
	wire [6:0] y;
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

	draw d(x, y, colour, CLOCK_50, 8'd160, 8'd120);

	assign writeEn = 1'b1;

endmodule

module draw (x_out, y_out, colour_out, clock, max_x, max_y);

	input clock;
	input [7:0] max_x, max_y;

	output [7:0] x_out, y_out;
	output [2:0] colour_out;

	wire [7:0] x_out_wire, y_out_wire;
	wire [2:0] colour_out_wire;

	reg [7:0] x_cord, y_cord;
	reg [2:0] colour;
	reg [7:0] position;
	reg [7:0] h0_start, h0_end, h0_y, h1_start, h1_end, h1_y, b0_start, b0_end, b0_y, b1_start,
						b1_end, b1_y, b2_start, b2_end, b2_y;

	wire new_clock;

	limiter l(new_clock, clock, 27'd30);

	initial
		begin
			position = 8'd0;
		end

		localparam platform_1_x_start = 8'd60, platform_1_x_end = 8'd100, platform_1_y = 8'd180,
							 platform_2_x_start = 8'd220, platform_2_x_end =8'd260, platform_2_y = 8'd180,
							 platform_3_x_start = 8'd100, platform_3_x_end = 8'd140, platform_3_y = 8'd120,
							 platform_4_x_start = 8'd180, platform_4_x_end = 8'd220, platform_4_y = 8'd120,
							 platform_5_x_start = 8'd140, platform_5_x_end = 8'd180, platform_5_y = 8'd60,
							 flag_pole_y_start = 8'd39, flag_pole_y_end = 8'd59, flag_pole_x = 8'd160,
							 flag1_x_start = 8'd161, flag1_x_end = 8'd181, flag1_y = 8'd39,
							 flag2_x_start = 8'd161, flag2_x_end = 8'd181, flag2_y = 8'd40,
							 grave_part1_y_start = 8'd169, grave_part1_y_end = 8'd179, grave_part1_x = 8'd245,
							 grave_part2_y_start = 8'd169, grave_part2_y_end = 8'd179, grave_part2_x = 8'd244,
							 grave_part3_x_start = 8'd239, grave_part3_x_end = 8'd, grave_part3_y = 8'd169,
							 grave_part4_x_start = 8'd250, grave_part4_x_end = 8'd, grave_part4_y = 8'd170,
							 grass_y_start = 8'd234, grass_y_end = 8'd239,
							 sacred_tree_x_start = 8'd15, sacred_tree_x_end = 8'd45;

	always @ (posedge clock)
		begin
			// set the background colour to black
			colour = 3'b001;


			b1_start = position - 12;
			b1_end = position + 12;
			b1_y = 8'd80;
			b0_start = b1_start;
			b0_end = b1_end;
			b0_y = b1_y - 1;
			b2_start = b1_start;
			b2_end = b1_end;
			b2_y = b1_y + 1;
			h1_start = position - 6;
			h1_end = position + 6;
			h1_y = b0_y - 1;
			h0_start = h1_start;
			h0_end = h1_end;
			h0_y = h1_y - 1;


			// if we have reached the maximum x cordinate move to the next row otherwise move to the
			// next pixel
			if (x_cord == max_x)
				begin
					x_cord = 8'b0;
					y_cord = y_cord + 1;
				end
			else
				begin
					x_cord = x_cord + 1;
				end

			// if we have reached the maximum y value start from the begining
			if (y_cord == max_y)
				begin
					y_cord = 8'b0;
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

				// drawing main character
				// draw h0
				if (y_cord == h0_y && (x_cord >= h0_start && x_cord <= h0_end))
					begin
						colour = 3'b010;
					end

				// draw h1
				if (y_cord == h1_y && (x_cord >= platform_3_x_start && x_cord <= platform_3_x_end))
					begin
						colour = 3'b010;
					end

				// draw b0
				if (y_cord == b0_y && (x_cord >= b0_start && x_cord <= b0_end))
					begin
						colour = 3'b010;
					end

				// draw b1
				if (y_cord == b1_y && (x_cord >= b1_start && x_cord <= b1_end))
					begin
						colour = 3'b010;
					end

				// draw b2
				if (y_cord == b2_y && (x_cord >= b2_start && x_cord <= b2_end))
					begin
						colour = 3'b010;
					end
		end

	assign x_out_wire = x_cord;
	assign y_out_wire = y_cord;
	assign colour_out_wire = colour;

	assign x_out = x_out_wire;
	assign y_out = y_out_wire;
	assign colour_out = colour_out_wire;

endmodule

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
			if (counter == max_value) begin counter = 26'd0; out_reg = 1'b1; end
			else begin counter = counter + 1; out_reg = 1'b0; end
		end

	assign out = out_wire;
	assign out_wire = out_reg;

endmodule


module control_path ();

endmodule
