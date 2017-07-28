module draw (x_out, y_out, colour_out, clock, max_x, max_y, key);

   input clock;
   input [8:0] max_x, max_y;
   input [3:0] key;

   output [8:0] x_out, y_out;
   output [2:0] colour_out;

   wire [8:0] 	x_out_wire, y_out_wire;
   wire [2:0] 	colour_out_wire;

   reg [8:0] 	x_cord, y_cord;
   reg [2:0] 	colour;
   reg [8:0] 	character_x_position, character_y_position;
   reg [8:0] 	projectile_x_position, projectile_y_position;
   reg 		jumping;
   reg [8:0] 	max_jump;
   reg 		reset_character;
   reg reset_projectile;

   wire [2:0] 	character_up, character_down, character_left, character_right;
   wire [2:0] 	character_up_trap, character_down_trap, character_left_trap, character_right_trap;

   wire 	new_clock;
   wire 	frq;
   wire 	speed;
   wire [2:0] 	flag;
   wire [2:0] 	cflag;
   wire [2:0] 	prflag;
   wire [2:0] 	trflag;


   wire [2:0] 	proj_collision;
   wire [2:0] 	trap_collision;

   limiter slow_clock(new_clock, clock, 8'd60);
   limiter frq_mod(frq, clock, 8'd30);
   limiter speed_mod(speed, clock, 8'd60);
   background bg(flag, x_cord, y_cord, clock);
   traps tr(trflag, x_cord, y_cord, clock);
   character ch1(cflag, x_cord, y_cord, character_x_position, character_y_position, clock);
   projectile p1(prflag, x_cord, y_cord, projectile_x_position, projectile_y_position, clock);

   // TODO needs more testing for collosion
   // collision between character and the projectile
   character projectile_collision(proj_collision, projectile_x_position, projectile_y_position, character_x_position, character_y_position, clock);

   // collision between character and the platforms
   collision_char_plat platform_collision(character_down, character_up, character_left, character_right, character_x_position, character_y_position, clock);

   // collision between character and the traps
   collision_char_traps trap_collision_mod(character_down_trap, character_up_trap, character_left_trap, character_right_trap, character_x_position, character_y_position, clock);

   // checks whether any of the hitboxes of the character overlaps with any of the traps. NOTE: It uses the same code as checking the platform collision so coming slightly close to the traps will reset the player position
   assign trap_collision = (character_down_trap | character_up_trap |  character_left_trap | character_right_trap);

   initial
     begin
	character_x_position = 9'd35;
	character_y_position = 9'd205;
	projectile_x_position = 9'd100;
	projectile_y_position = 9'd50;
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

	// draw the traps
	if (trflag != 3'b000)
	  colour = trflag;

	// draw the character
	if (cflag != 3'b111)
          colour = cflag;

	// draw the projectile
	if (prflag != 3'b000)
          colour = prflag;

	// checks all the condition where the character will "die" and reset
	if (key[1] == 1'b0 || (proj_collision != 3'b111) || (trap_collision != 3'b000))
  begin
	  reset_character = 1'b1;
    reset_projectile = 1'b1;
  end
  else
  begin
    reset_character = 1'b0;
    reset_projectile = 1'b0;
  end
 end


   always @ (posedge new_clock)
     begin
	// TODO could be a bug where key value is 1 it moves
	// move the chracter to the right if the right key is pressed (key[3])
	if (key[2] == 1'b0 && character_right == 3'b000) character_x_position = character_x_position + 9'd1;
	else character_x_position = character_x_position;

	// move the character to the left if the left key is pressed (key[2)
	if (key[3] == 1'b0 && character_left == 3'b000) character_x_position = character_x_position - 9'd1;
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
             max_jump = character_y_position - 9'd70;
          end
	else
          character_y_position = character_y_position;

	if (jumping == 1'b1 && character_up == 3'b000) character_y_position = character_y_position - 9'd1;

	// TODO test it to make sure it's not stuck on the platforms
	if (jumping == 1'b1 && (character_y_position == max_jump || character_up != 3'b000))
          begin
             jumping = 1'b0;
          end

	//reset the position of the character

	if (reset_character == 1'b1)
	  begin
	     character_x_position = 9'd45;
	     character_y_position = 9'd215;
	  end
	else
	  begin
	     character_x_position = character_x_position;
	     character_y_position = character_y_position;
	  end

     end
     reg [8:0] slope;
   always @ (posedge speed)
   //
   begin
     if (reset_projectile == 1'b1)
   	  begin
      projectile_x_position = 9'd100;
      projectile_y_position = 9'd50;
   	  end
   	else
   	  begin
   	     projectile_x_position = projectile_x_position;
   	     projectile_y_position = projectile_y_position;
   	  end
     /*begin
        if (projectile_x_position == max_x || frq == 1'b1)
          begin
             projectile_x_position = 9'd20;
             projectile_y_position = 9'd200;
          end
        else*/
	  // NOTE: this code might be a little buggy since we are updating the proj position by updating the slope ie the direction. It might give some weird results: tracking maybe.
	  // A better way is to keep a constant initial slope for the projectile and update the current projectile positon based on that only.
	  //begin
	     //slope = (character_y_position - projectile_y_position) / (character_x_position - projectile_x_position);
	     //projectile_x_position = projectile_x_position + 1;
       //projectile_y_position = projectile_y_position + slope;
      if (frq)
       if (character_x_position > projectile_x_position && character_y_position > projectile_y_position)
          begin
            projectile_x_position = projectile_x_position + 1;
            projectile_y_position = projectile_y_position + 1;
          end
      //
      else if (character_x_position < projectile_x_position && character_y_position > projectile_y_position)
         begin
           projectile_x_position = projectile_x_position - 1;
           projectile_y_position = projectile_y_position + 1;
         end
      //
      else if (character_x_position < projectile_x_position && character_y_position < projectile_y_position)
         begin
           projectile_x_position = projectile_x_position - 1;
           projectile_y_position = projectile_y_position - 1;
         end
      //
      else if (character_x_position > projectile_x_position && character_y_position == projectile_y_position)
         begin
           projectile_x_position = projectile_x_position + 1;
           projectile_y_position = projectile_y_position;
         end
      //
      else if (character_x_position == projectile_x_position && character_y_position < projectile_y_position)
         begin
           projectile_x_position = projectile_x_position;
           projectile_y_position = projectile_y_position - 1;
         end
      //
      else if (character_x_position < projectile_x_position && character_y_position == projectile_y_position)
         begin
           projectile_x_position = projectile_x_position - 1;
           projectile_y_position = projectile_y_position;
         end
      //
      else if (character_x_position == projectile_x_position && character_y_position > projectile_y_position)
         begin
           projectile_x_position = projectile_x_position;
           projectile_y_position = projectile_y_position + 1;
         end
      else
      //
         begin
           projectile_x_position = projectile_x_position + 1;
           projectile_y_position = projectile_y_position - 1;
         end
      end
      else //if (!frq)
        //
        begin
          projectile_x_position = projectile_x_position;
          projectile_y_position = projectile_y_position;
        end
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
