/// @description Draw indicator above

if image_index = 0 && distance_to_object(NearPlayer) < 5{

	draw_sprite(sIndicator,0,x,y);
}

draw_self();