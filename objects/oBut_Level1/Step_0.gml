/// @description Global Click to Close

// Inherit parent behavior
event_inherited();

if (mouse_check_button_pressed(mb_left)) {
	// If clicked outside of level 1 and level 2
	if (!position_meeting(mouse_x, mouse_y, oBut_Level1) && !position_meeting(mouse_x, mouse_y, oBut_Level2)) {
		
		var sx = variable_instance_exists(id, "orig_start_x") ? orig_start_x : x;
		var sy = variable_instance_exists(id, "orig_start_y") ? orig_start_y : y + 20;
		var qx = variable_instance_exists(id, "orig_quit_x") ? orig_quit_x : x;
		var qy = variable_instance_exists(id, "orig_quit_y") ? orig_quit_y : y + 148;
		
		if (instance_exists(oBut_Level2)) instance_destroy(oBut_Level2);
		
		if (instance_exists(oBut_Start)) instance_destroy(oBut_Start);
		if (instance_exists(oBut_Quit)) instance_destroy(oBut_Quit);
		
		var ns = instance_create_layer(sx, sy, "Instances", oBut_Start);
		ns.image_xscale = 1.5;
		ns.image_yscale = 1.5;
		
		var nq = instance_create_layer(qx, qy, "Instances", oBut_Quit);
		nq.image_xscale = 1.5;
		nq.image_yscale = 1.5;
		
		audio_play_sound(sndBoop, 10, false); // Play sound for back action
		
		instance_destroy(); // Destroy oBut_Level1
	}
}
