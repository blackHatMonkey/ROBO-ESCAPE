/*
	This module is responsible for reducing the on board clock speed of 5 MHz
	(CLOCK_50) to the desired number of cycle determined by the rate argument.
*/
module limiter (out, clock, rate);

  // input values
  input clock;
  input [7:0] rate;

  // output values
  output out;

  wire [26:0] max_value;
  wire out_wire;

  reg out_reg;
  reg [26:0] counter;

  assign max_value = 26'd50000000 / rate;

  always @(posedge clock)
    begin
      if (counter == max_value)
        begin
          counter = 27'd0;
          out_reg = 1'b1;
        end
      else
        begin
          counter = counter + 27'd1;
          out_reg = 1'b0;
        end
    end

  // assign the output
  assign out = out_wire;
  assign out_wire = out_reg;

endmodule
