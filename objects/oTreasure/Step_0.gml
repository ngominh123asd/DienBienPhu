/// @description Get treasure

RClick = mouse_check_button_pressed(mb_right);
NearPlayer = instance_nearest(x,y,oPar_PlayerUnit);

if image_index = 0 && RClick && position_meeting(mouse_x,mouse_y,self) && 
NearPlayer != noone && distance_to_object(NearPlayer) < 5{
	
	image_index = 1; //Open
	audio_play_sound(sndGetTreasure,10,0);
	
	//Give 5 Xp
	for (var a = 0; a < 5; a ++){
	
		instance_create_layer(x+irandom_range(-1,1),y+irandom_range(-1,1),"Instances",oExp);	
	}
	//Give 5 Hp
	for (var a = 0; a < 5; a ++){
	
		instance_create_layer(x+irandom_range(-1,1),y+irandom_range(-1,1),"Instances",oHp);	
	}
	
}