module collision_char_plat(character_down, character_up, character_left, character_right, character_x_position, character_y_position, clock);

   input [8:0] character_x_position, character_y_position, clock;
   output [2:0] character_down, character_up, character_left, character_right;
   
   
   wire [2:0] 	character_down_1, character_down_2, character_down_3;
   wire [2:0] 	character_right_1, character_right_2, character_right_3, character_right_4, character_right_5, character_right_6, character_right_7;
   wire [2:0] 	character_left_1, character_left_2, character_left_3, character_left_4, character_left_5, character_left_6, character_left_7;
   wire [2:0] 	character_up_1, character_up_2, character_up_3;


   //collision c_left(character_left, character_x_position - 4, character_y_position - 6, clock);
   //collision with the background
   background collision_down_1(character_down_1, character_x_position + 9'd4, character_y_position + 9'd13, clock);
   background collision_down_2(character_down_2, character_x_position + 9'd4 + 9'd2, character_y_position + 9'd13, clock);
   background collision_down_3(character_down_3, character_x_position + 9'd4 - 9'd2, character_y_position + 9'd13, clock);
   
   
   background collision_right_1(character_right_1, character_x_position + 9'd11, character_y_position + 9'd4, clock);
   background collision_right_2(character_right_2, character_x_position + 9'd11, character_y_position + 9'd4 + 9'd3, clock);
   background collision_right_3(character_right_3, character_x_position + 9'd11, character_y_position + 9'd4 - 9'd3, clock);
   background collision_right_4(character_right_4, character_x_position + 9'd11, character_y_position + 9'd4 + 9'd2, clock);
   background collision_right_5(character_right_5, character_x_position + 9'd11, character_y_position + 9'd4 - 9'd2, clock);
   background collision_right_6(character_right_6, character_x_position + 9'd11, character_y_position + 9'd4 + 9'd1, clock);
   background collision_right_7(character_right_7, character_x_position + 9'd11, character_y_position + 9'd4 - 9'd1, clock);

   
   background collistion_left_1(character_left_1, character_x_position - 9'd4, character_y_position + 9'd4, clock);
   background collistion_left_2(character_left_2, character_x_position - 9'd4, character_y_position + 9'd4 + 9'd3, clock);
   background collistion_left_3(character_left_3, character_x_position - 9'd4, character_y_position + 9'd4 - 9'd3, clock);
   background collistion_left_4(character_left_4, character_x_position - 9'd4, character_y_position + 9'd4 + 9'd2, clock);
   background collistion_left_5(character_left_5, character_x_position - 9'd4, character_y_position + 9'd4 - 9'd2, clock);
   background collistion_left_6(character_left_6, character_x_position - 9'd4, character_y_position + 9'd4 + 9'd1, clock);
   background collistion_left_7(character_left_7, character_x_position - 9'd4, character_y_position + 9'd4 - 9'd1, clock);
   
   background collistion_up_1(character_up_1, character_x_position  + 9'd4, character_y_position - 9'd6, clock);
   background collistion_up_2(character_up_2, character_x_position  + 9'd4 + 9'd2, character_y_position - 9'd6, clock);
   background collistion_up_3(character_up_3, character_x_position  + 9'd4 - 9'd2, character_y_position - 9'd6, clock);
   
   //

   assign character_down = (character_down_1 | character_down_2 | character_down_3);
   assign character_up = (character_up_1 | character_up_2 | character_up_3);
   assign character_left = (character_left_1 | character_left_2 | character_left_3 | character_left_4 | character_left_5 | character_left_6 | character_left_7);
   assign character_right = (character_right_1 | character_right_2 | character_right_3 | character_right_4 | character_right_5 | character_right_6 | character_right_7);
   
endmodule
