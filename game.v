// Part 2 skeleton

module lab_6_3
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
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
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
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
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
	
	reg [15:0] counter;
	reg [7:0] x_reg, y_reg;
	reg [2:0] col;
	reg [7:0] position;
	wire slow_clock_var;
	
	slow_clock sc(CLOCK_50, slow_clock_var);
	
	initial
	begin
		x_reg = 8'b1;
		y_reg = 8'b00000001;
		position = 8'd10;
	end
	
	always @ (posedge CLOCK_50) 
	begin
	
		/*if (counter[15:8] == 8'd50 && (counter[7:0] >= 8'd30 && counter[7:0] >= 8'd50))
		begin 
			col = 3'b000;
			counter[7:0] = counter[7:0] + 1'b1;
		end*/
		if(SW[0] == 1'b1)
			begin 
			position = 8'd50;
			end
		else
			begin 
			position = 8'd80;
			counter = 8'b0;
			end


		if ((counter[7:0] == position) && (counter[15:8] <= 8'd84 && counter[15:8] >= 8'd80))
			begin
			col = 3'b010;
			end
		else if ((counter[15:8] == 8'd50) && (counter[7:0] <= 8'd80 && counter[7:0] >= 8'd30))
			begin
			col = 3'b111;
			end
		else
			begin
			col = 3'b000;
			end
		
		if (counter[15:8] < 8'd119 && counter[7:0] < 8'd159)
			begin
			counter[7:0] = counter[7:0] + 1'b1;
			end
		else if (counter[15:8] < 8'd119 && counter[7:0] >= 8'd159)
			begin
			counter[7:0] = 8'b0;
			counter[15:8] = counter[15:8] + 1'b1;
			end
		else if (counter[15:8] >= 8'd119 && counter[7:0] >= 8'd159)
			begin
			counter = 8'b0;
			end
		x_reg = counter[7:0];
		y_reg = counter[15:8];
	
		
	end
	hex_displayer h0(position[3:0],HEX0);
	hex_displayer h1(position[7:4],HEX1);
	
	/*always @ (SW[0])
	begin
		position = position + 8'd5;
	end*/
	
	assign x = x_reg;
	assign y = y_reg;
	assign writeEn = 1'b1;
	assign colour = col;
	
endmodule

module hex_displayer(input_values, out);

    // assign input and ouput
    input [3:0]input_values;
    output reg [6:0] out;

    // run this on any change
    always @(*)
    begin
        // in case any of the input change, change the output as well
        case(input_values[3:0])
            4'h0: out = 7'b1000000;
            4'h1: out = 7'b1111001;
            4'h2: out = 7'b0100100;
            4'h3: out = 7'b0110000;
            4'h4: out = 7'b0011001;
            4'h5: out = 7'b0010010;
            4'h6: out = 7'b0000010;
            4'h7: out = 7'b1111000;
            4'h8: out = 7'b0000000;
            4'h9: out = 7'b0011000;
            4'hA: out = 7'b0001000;
            4'hB: out = 7'b0000011;
            4'hC: out = 7'b1000110;
            4'hD: out = 7'b0100001;
            4'hE: out = 7'b0000110;
            4'hF: out = 7'b0001110;
            default: out = 7'b1000000;


        endcase
    end
endmodule


module slow_clock(clock, out);

	input clock;
	output out;
	
	reg [20:0] counter;
	
	initial
	begin
		counter = 21'b0;
	end
	

	always @(clock)
	begin
	
	if (counter == 21'b1001100010010110100000) counter = 21'b0;
	else counter = counter + 1'b1;
	
	end
	
endmodule