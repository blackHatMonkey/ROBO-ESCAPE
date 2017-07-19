module traps (flag, x_cord, y_cord, clock);

  // input values
  input  clock;
  input [8:0] x_cord, y_cord;

  // output values
  output [2:0] flag;

  reg [2:0] colour;
  
  always @(posedge clock)
    begin
	 colour = 3'b000;
	 
	 // draw the grass block
    if ((x_cord >= 9'd75 && x_cord <= 9'd200) && (y_cord >= 9'd236 && y_cord <= 9'd250))
      colour = 3'b100;
	 end
	 
	 assign flag = colour;
	 
endmodule