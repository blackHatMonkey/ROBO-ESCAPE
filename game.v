
module game
	(
		CLOCK_50,						//	On Board 50 MHz
    KEY,
    SW,
	 LEDR,
	 GPIO,
	 OTG_DATA,
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
	input [6:0] OTG_DATA;
	input [10:0] GPIO;
	output [10:0] LEDR;

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

	draw d(x, y, colour, CLOCK_50, 10'd320, 10'd240);
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

module draw (x_out, y_out, colour_out, clock, max_x, max_y);

	input clock;
	input [9:0] max_x, max_y;

	output [9:0] x_out, y_out;
	output [2:0] colour_out;

	wire [9:0] x_out_wire, y_out_wire;
	wire [2:0] colour_out_wire;

	reg [9:0] x_cord, y_cord;
	reg [2:0] colour;
	reg [9:0] position, y_position;
	reg [9:0] h0_start, h0_end, h0_y, h1_start, h1_end, h1_y, b0_start, b0_end, b0_y, b1_start,
						b1_end, b1_y, b2_start, b2_end, b2_y;

	reg [9:0] ghost_l1_start, ghost_l1_end, ghost_l1_y,
						ghost_l2_start,	ghost_l2_end, ghost_l2_y,
						ghost_l3_start, ghost_l3_end, ghost_l3_y,
						ghost_l4_start, ghost_l4_end, ghost_l4_y,
						ghost_l5_start, ghost_l5_end, ghost_l5_y,
						ghost_l6_start, ghost_l6_end, ghost_l6_y,
						ghost_l7_start, ghost_l7_end, ghost_l7_y,
						ghost_l8_start, ghost_l8_end, ghost_l8_y,
						ghost_l9_start, ghost_l9_end, ghost_l9_y,
						ghost_l10_start, ghost_l10_end, ghost_l10_y;

	wire new_clock;

	limiter l(new_clock, clock, 27'd30);

	initial
		begin
			position = 10'd0;
			y_position = 10'd205;
			
		end

		localparam platform_1_x_start = 10'd60, platform_1_x_end = 10'd100, platform_1_y = 10'd180,
							 platform_2_x_start = 10'd220, platform_2_x_end =10'd260, platform_2_y = 10'd180,
							 platform_3_x_start = 10'd100, platform_3_x_end = 10'd140, platform_3_y = 10'd120,
							 platform_4_x_start = 10'd180, platform_4_x_end = 10'd220, platform_4_y = 10'd120,
							 platform_5_x_start = 10'd140, platform_5_x_end = 10'd180, platform_5_y = 10'd60,
							 flag_pole_y_start = 10'd39, flag_pole_y_end = 10'd59, flag_pole_x = 10'd160,
							 flag1_x_start = 10'd161, flag1_x_end = 10'd181, flag1_y = 10'd39,
							 flag2_x_start = 10'd161, flag2_x_end = 10'd181, flag2_y = 10'd40,
							 grave_part1_y_start = 10'd169, grave_part1_y_end = 10'd179, grave_part1_x = 10'd245,
							 grave_part2_y_start = 10'd169, grave_part2_y_end = 10'd179, grave_part2_x = 10'd244,
							 grave_part3_x_start = 10'd241, grave_part3_x_end = 10'd249, grave_part3_y = 10'd169,
							 grave_part4_x_start = 10'd241, grave_part4_x_end = 10'd249, grave_part4_y = 10'd170,
							 grass_y_start = 10'd234, grass_y_end = 10'd239,
							 sacred_tree_x_start = 10'd15, sacred_tree_x_end = 10'd45;
							 
							
	always @ (posedge clock)
		begin
			// set the background colour to black
			colour = 3'b001;


			// character positioning
			b1_start = position - 12;
			b1_end = position + 12;
			b1_y = 10'd210;
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


			// ghost positioning
			/*ghost_l1_start = ghost_x_position - 1;
			ghost_l1_end = ghost_x_position + 1;
			ghost_l1_y = ghost_l2_y - 1;
			ghost_l2_start = ghost_x_position - 1;
			ghost_l2_end = ghost_x_position + 1;
			ghost_l2_y = ghost_l3_y - 1;
			ghost_l3_start = ghost_x_position - 2;
			ghost_l3_end = ghost_x_position + 2;
			ghost_l3_y = ghost_l4_y - 1;
			ghost_l4_start = ghost_x_position - 3;
			ghost_l4_end = ghost_x_position + 3;
			ghost_l4_y = ghost_l5_y - 1;
			ghost_l5_start = ghost_x_position - 5;
			ghost_l5_end = ghost_x_position + 5;
			ghost_l5_y = 10'd180;
			ghost_l6_start = ghost_l5_start;
			ghost_l6_end = ghost_l5_end;
			ghost_l6_y = ghost_l5_y + 1;
			ghost_l7_start = ghost_l5_start;
			ghost_l7_end = ghost_l5_end;
			ghost_l7_y = ghost_l6_y + 1;
			ghost_l8_start = ghost_l5_start;
			ghost_l8_end = ghost_l5_end;
			ghost_l8_y = ghost_l7_y + 1;
			ghost_l9_start = ghost_l5_start;
			ghost_l9_end = ghost_l5_end;
			ghost_l9_y = ghost_l8_y + 1;
			ghost_l10_start = ghost_l5_start;
			ghost_l10_end = ghost_l5_end;
			ghost_l10_y = ghost_l9_y + 1;*/


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
				
				/*if ((x_cord >= position && x_cord <= (position + 5)) && (y_cord <= y_position + 5 && y_cord >= y_position))
					begin
						colour = 3'b000;
					end*/
					
				
				if ((((position - x_cord) * (position - x_cord) + (y_position - y_cord) * (y_position - y_cord)) <= 100) &&
					 (((position - x_cord) * (position - x_cord) + (y_position - y_cord) * (y_position - y_cord)) >= 20))	
					begin
						colour = 3'b000;
					end
				
				
				/*if (x_cord >= (position - 3) && x_cord <= (position - 1) && (y_cord <= (y_position + 5) && y_cord >= y_position))
					begin
						colour = 3'b000;
					end
				
				
				if (x_cord >= (position + 6) && x_cord <= (position + 8) && (y_cord <= y_position + 5 && y_cord >= y_position))
					begin
						colour = 3'b000;
					end
					
				if (x_cord >= position && x_cord <= (position + 1) && (y_cord <= y_position + 10 && y_cord >= y_position + 6))
					begin
						colour = 3'b000;
					end
				
				if (x_cord >= (position + 4) && x_cord <= (position + 5) && (y_cord <= (y_position + 10) && y_cord >= (y_position + 6)))
					begin
						colour = 3'b000;
					end*/
				
				// drawing main character
				// draw h0
				/*if (y_cord == h0_y && (x_cord >= h0_start && x_cord <= h0_end))
					begin
						colour = 3'b000;
					end

				// draw h1
				if (y_cord == h1_y && (x_cord >= platform_3_x_start && x_cord <= platform_3_x_end))
					begin
						colour = 3'b000;
					end

				// draw b0
				if (y_cord == b0_y && (x_cord >= b0_start && x_cord <= b0_end))
					begin
						colour = 3'b000;
					end

				// draw b1
				if (y_cord == b1_y && (x_cord >= b1_start && x_cord <= b1_end))
					begin
						colour = 3'b000;
					end

				// draw b2
				if (y_cord == b2_y && (x_cord >= b2_start && x_cord <= b2_end))
					begin
						colour = 3'b000;
					end*/

				// draw ghost layer 1
				/*if (x_cord == ghost_l1_y && (x_cord >=  ghost_l1_start && x_cord <= ghost_l1_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 2
				if (x_cord == ghost_l2_y && (x_cord >=  ghost_l2_start && x_cord <= ghost_l2_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 3
				if (x_cord == ghost_l3_y && (x_cord >=  ghost_l3_start && x_cord <= ghost_l3_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 4
				if (x_cord == ghost_l4_y && (x_cord >=  ghost_l4_start && x_cord <= ghost_l4_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 5
				if (x_cord == ghost_l5_y && (x_cord >=  ghost_l5_start && x_cord <= ghost_l5_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 6
				if (x_cord == ghost_l6_y && (x_cord >=  ghost_l6_start && x_cord <= ghost_l6_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 7
				if (x_cord == ghost_l7_y && (x_cord >=  ghost_l7_start && x_cord <= ghost_l7_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 8
				if (x_cord == ghost_l8_y && (x_cord >=  ghost_l8_start && x_cord <= ghost_l8_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 9
				if (x_cord == ghost_l9_y && (x_cord >=  ghost_l9_start && x_cord <= ghost_l9_end))
					begin
						colour = 3'b110;
					end

				// draw ghost layer 10
				if (x_cord == ghost_l10_y && (x_cord >=  ghost_l10_start && x_cord <= ghost_l10_end))
					begin
						colour = 3'b110;
					end*/
		end

		always @ (posedge new_clock)
			begin
				if (position == max_x) position = 10'd0;
				else position = position + 1;
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
