/// @description Draw indicator above

var NearPlayer = instance_nearest(x,y,oPar_PlayerUnit);

if distance_to_object(NearPlayer) < 5{

	var zoom = 1;
	if instance_exists(oCamera) zoom = oCamera.ZoomFactor;

	draw_sprite_ext(sIndicator,0,x,y,zoom,zoom,0,c_white,1);
	
	//Prompt to click
	if position_meeting(mouse_x,mouse_y,self){
		
		// Moved to Draw_64.gml
	}
}

draw_self();
