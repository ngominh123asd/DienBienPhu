// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scrInitGame(){

	randomize();
	
	// Load some font
	var _resdir = working_directory + "Font.ttf"; 
	show_debug_message("Loading from ... " + string(_resdir));

	global.Font = font_add(_resdir, 12, false, false, 32, 128);
	draw_set_font(global.Font);
	display_set_gui_size(1280, 720); //Set gui size
	
	global.HurtCol = make_color_rgb(255,140,140);
	window_set_fullscreen(false);
	window_set_size(1280, 720);
	display_set_gui_size(1280, 720);
	
	//Start game
	room_goto(rmTitle);
}