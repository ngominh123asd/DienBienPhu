/// @description Clicked - Show Level Select

var start_x = x;
var start_y = y;
var quit_x = x;
var quit_y = y + 60; // fallback

if (instance_exists(oBut_Quit)) {
	quit_x = oBut_Quit.x;
	quit_y = oBut_Quit.y;
	instance_destroy(oBut_Quit);
}

instance_destroy(); // Destroy oBut_Start

// Spawn selection buttons
instance_create_layer(start_x, start_y - 20, "Instances", oBut_Level1);
instance_create_layer(start_x, start_y + 40, "Instances", oBut_Level2);
instance_create_layer(quit_x, quit_y, "Instances", oBut_Back);