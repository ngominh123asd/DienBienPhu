/// @description Get clicked

if position_meeting(mouse_x,mouse_y,self){
	
	if image_index = 0{
		
		image_index = 1;
		audio_play_sound(sndBoop,10,0);
		
	}
	
	if mouse_check_button_pressed(mb_left){
		
		audio_play_sound(sndClickBut,10,0);
		event_user(0)
	}
	
}else{
	
	image_index = 0;	
}