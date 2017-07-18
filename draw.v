module draw (x_out, y_out, colour_out, clock, max_x, max_y, key);

  input clock;
  input [8:0] max_x, max_y;
  input [3:0] key;

  output [8:0] x_out, y_out;
  output [2:0] colour_out;

  wire [8:0] x_out_wire, y_out_wire;
  wire [2:0] colour_out_wire;

  reg [8:0] x_cord, y_cord;
  reg [2:0] colour;
  reg [8:0] character_x_position, character_y_position;
  reg [8:0] projectile_x_position, projectile_y_position;
  reg jumping;
  reg [8:0] max_jump;
  reg reset_character;



  wire [2:0] character_down;
  wire [2:0] character_right;
  wire [2:0] character_left;
  wire [2:0] character_up;

  wire new_clock;
  wire frq;
  wire speed;
  wire [2:0] flag;
  wire [2:0] cflag;
  wire [2:0] prflag;

  limiter slow_clock(new_clock, clock, 8'd60);
  limiter frq_mod(frq, clock, 8'd1);
  limiter speed_mod(speed, clock, 8'd100);
  background bg(flag, x_cord, y_cord, clock);
  character ch1(cflag, x_cord, y_cord, character_x_position, character_y_position, clock);
  projectile p1(prflag, x_cord, y_cord, projectile_x_position, projectile_y_position, clock);

  // TODO needs more testing for collosion
  background collision_down(character_down, character_x_position + 9'd4, character_y_position + 9'd12, clock);
  background collision_right(character_right, character_x_position + 9'd11, character_y_position + 9'd4, clock);
  background collistion_left(character_left, character_x_position - 9'd4, character_y_position + 9'd4, clock);
  background collistion_up(character_up, character_x_position  + 9'd4, character_y_position - 9'd6, clock);

  initial
		begin
			character_x_position = 9'd35;
			character_y_position = 9'd205;
      projectile_x_position = 9'd100;
      projectile_y_position = 9'd150;
			jumping = 1'b0;
			max_jump = 9'b0;
		end



	always @ (posedge clock)
    begin
      // set the background colour to black
      colour = 3'b001;

      // if we have reached the maximum x cordinate move to the next row otherwise move to the
      // next pixel
      if (x_cord == max_x)
        begin
          x_cord = 9'b0;
          y_cord = y_cord + 9'd1;
        end
      else
        x_cord = x_cord + 9'd1;

      // if we have reached the maximum y value start from the begining
      if (y_cord == max_y)
        y_cord = 9'b0;

      // draw the platforms
      if (flag != 3'b000)
        colour = flag;

      // draw the character
      if (cflag != 3'b111 && prflag == 3'b000)
        colour = cflag;
      else if (cflag != 3'b111 && prflag != 3'b000)
        reset_character = 1'b1;

      // draw the projectile
      if (prflag != 3'b000)
        colour = prflag;
    end

  always @ (posedge new_clock)
    begin
      // TODO could be a bug where key value is 1 it moves
      // move the chracter to the right if the right key is pressed (key[3])
      if (key[3] == 1'b1 && character_right == 3'b000) character_x_position = character_x_position + 9'd1;
      else character_x_position = character_x_position;

      // move the character to the left if the left key is pressed (key[2)
      if (key[2] == 1'b1 && character_left == 3'b000) character_x_position = character_x_position - 9'd1;
      else character_x_position = character_x_position;

      // fall down if you are not jumping or on a surface(gravity)
      if (character_down == 3'b000 && jumping == 1'b0)
        begin
          character_y_position = character_y_position + 9'd1;
        end


      // TODO the value needs to be lowred
      // jump 70 pixels
      if (key[0] == 1'b0 && jumping == 1'b0 && character_down != 3'b000)
        begin
          jumping = 1'b1;
          max_jump = character_y_position - 9'd40;
        end
      else
        character_y_position = character_y_position;

      if (jumping == 1'b1 && character_up == 3'b000) character_y_position = character_y_position - 9'd1;

      // TODO test it to make sure it's not stuck on the platforms
      if (jumping == 1'b1 && (character_y_position == max_jump || character_up != 3'b000))
        begin
          jumping = 1'b0;
        end

      if (reset_character == 1'b1)
        begin
          character_x_position = 9'd20;
          character_y_position = 9'd220;
          reset_character = 1'b0;
        end


    end

    /*always @ (posedge frq)
      begin
        projectile_x_position = 9'd20;
        projectile_y_position = 9'd200;
      end*/

    always @ (posedge speed)
      begin
        if (projectile_x_position == max_x)
          begin
          projectile_x_position = 9'd20;
          projectile_y_position = 9'd200;
          end
        else
          projectile_x_position = projectile_x_position + 1;
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
