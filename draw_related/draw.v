module draw (x_out, y_out, colour_out, clock, max_x, max_y, key, led);

   input clock;
   input [8:0] max_x, max_y;
   input [3:0] key;
   output [7:0] led;

   output [8:0] x_out, y_out;
   output [2:0] colour_out;

   wire [8:0] 	x_out_wire, y_out_wire;
   wire [2:0] 	colour_out_wire;

   reg [8:0] 	x_cord, y_cord;
   reg [2:0] 	colour;
   reg [8:0] 	character_x_position, character_y_position;
   reg [8:0] 	projectile_x_position, projectile_y_position;

   reg [8:0] 	projectile2_x_position, projectile2_y_position;
   reg [8:0] 	projectile3_x_position, projectile3_y_position;

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
   wire [2:0]   pr2flag;
	wire [2:0] 	pr3flag;
   wire [2:0] 	trflag;
   wire [2:0]   egflag;


   reg 	proj_collision;
   reg 	trap_collision;
   reg [6:0] health;

   limiter slow_clock(new_clock, clock, 8'd60);
   limiter frq_mod(frq, clock, 8'd12);
   limiter speed_mod(speed, clock, 8'd60);
   background bg(flag, x_cord, y_cord, clock);
   traps tr(trflag, x_cord, y_cord, clock);
   character ch1(cflag, x_cord, y_cord, character_x_position, character_y_position, clock);
   projectile_1 p1(prflag, x_cord, y_cord, projectile_x_position, projectile_y_position, clock);
   projectile_2 p2(pr2flag, x_cord, y_cord, projectile2_x_position, projectile2_y_position, clock);
   projectile_3 p3(pr3flag, x_cord, y_cord, projectile3_x_position, projectile3_y_position, clock);

   end_goal eg(egflag, x_cord, y_cord, clock);

   // collision between character and the platforms
   collision_char_plat platform_collision(character_down, character_up, character_left, character_right, character_x_position, character_y_position, clock);


   initial
     begin
	character_x_position = 9'd35;
	character_y_position = 9'd205;
	projectile_x_position = 9'd200;
	projectile_y_position = 9'd20;

  projectile2_x_position = 9'd10;
	projectile2_y_position = 9'd200;

  projectile3_x_position = 9'd10;
	projectile3_y_position = 9'd50;

	jumping = 1'b0;
	max_jump = 9'b0;
  health = 8'b1111111;
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

  // draw the projectile
	if (pr2flag != 3'b000)
          colour = pr2flag;

  // draw the projectile
  if (pr3flag != 3'b000)
    colour = pr3flag;

  // draw the end goal
  if (egflag != 3'b111)
    colour = egflag;

  //collision between character and the projectile
  if (cflag != 3'b111 && (prflag != 3'b000 || pr2flag != 3'b000 || pr3flag != 3'b000)) proj_collision = 1'b1;
  else proj_collision = 1'b0;

  //collision between character and the traps
  if (cflag != 3'b111 && trflag != 3'b000) trap_collision = 1'b1;
  else trap_collision = 1'b0;

  //collision between character and the end goal
  if (cflag != 3'b111 && egflag != 3'b111)
  begin
	health = health + 1'b1;
	reset_character = 1'b1;
  end
  else
  begin
	health = health;
	reset_character = 1'b0;
  end

	// checks all the condition where the character will "die" and reset
	if (key[1] == 1'b0 || (proj_collision == 1'b1) || (trap_collision == 1'b1))
  begin
	  reset_character = 1'b1;
    reset_projectile = 1'b1;
    health = health - 1'b1;
  end
  else
  begin
    reset_character = 1'b0;
    reset_projectile = 1'b0;
  end
 end


   always @ (posedge clock)
     begin
	// TODO could be a bug where key value is 1 it moves
	// move the chracter to the right if the right key is pressed (key[3])
	if (key[2] == 1'b0 && character_right == 3'b000 && new_clock) character_x_position = character_x_position + 9'd1;
	else character_x_position = character_x_position;

	// move the character to the left if the left key is pressed (key[2)
	if (key[3] == 1'b0 && character_left == 3'b000 && new_clock) character_x_position = character_x_position - 9'd1;
	else character_x_position = character_x_position;

	// fall down if you are not jumping or on a surface(gravity)
	if (character_down == 3'b000 && jumping == 1'b0 && new_clock)
          begin
             character_y_position = character_y_position + 9'd1;
          end


	// TODO the value needs to be lowred
	// jump 70 pixels
	if (key[0] == 1'b0 && jumping == 1'b0 && character_down != 3'b000 && new_clock)
          begin
             jumping = 1'b1;
             max_jump = character_y_position - 9'd30;
          end
	else
          character_y_position = character_y_position;

	if (jumping == 1'b1 && character_up == 3'b000 && new_clock) character_y_position = character_y_position - 9'd1;

	// TODO test it to make sure it's not stuck on the platforms
	if (jumping == 1'b1 && (character_y_position == max_jump || character_up != 3'b000) && new_clock)
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
   always @ (posedge clock)
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
     if (character_x_position > projectile_x_position && character_y_position > projectile_y_position && frq)
        begin
          projectile_x_position = projectile_x_position + 1;
          projectile_y_position = projectile_y_position + 1;
        end
    //
    else if (character_x_position < projectile_x_position && character_y_position > projectile_y_position && frq)
       begin
         projectile_x_position = projectile_x_position - 1;
         projectile_y_position = projectile_y_position + 1;
       end
    //
    else if (character_x_position < projectile_x_position && character_y_position < projectile_y_position && frq)
       begin
         projectile_x_position = projectile_x_position - 1;
         projectile_y_position = projectile_y_position - 1;
       end
    //
    else if (character_x_position > projectile_x_position && character_y_position == projectile_y_position && frq)
       begin
         projectile_x_position = projectile_x_position + 1;
         projectile_y_position = projectile_y_position;
       end
    //
    else if (character_x_position == projectile_x_position && character_y_position < projectile_y_position && frq)
       begin
         projectile_x_position = projectile_x_position;
         projectile_y_position = projectile_y_position - 1;
       end
    //
    else if (character_x_position < projectile_x_position && character_y_position == projectile_y_position && frq)
       begin
         projectile_x_position = projectile_x_position - 1;
         projectile_y_position = projectile_y_position;
       end
    //
    else if (character_x_position == projectile_x_position && character_y_position > projectile_y_position && frq)
       begin
         projectile_x_position = projectile_x_position;
         projectile_y_position = projectile_y_position + 1;
       end
    else if (frq)
    //
       begin
         projectile_x_position = projectile_x_position + 1;
         projectile_y_position = projectile_y_position - 1;
       end

    if (speed)
      projectile2_x_position = projectile2_x_position + 1;

    if (speed)
      projectile3_x_position = projectile3_x_position + 1;
	  end

   // assign the registers to the wire counter parts
   assign x_out_wire = x_cord;
   assign y_out_wire = y_cord;
   assign colour_out_wire = colour;
   assign led = health;

   // assign the wires to the output
   assign x_out = x_out_wire;
   assign y_out = y_out_wire;
   assign colour_out = colour_out_wire;

endmodule
