/// @description Clicked - Back to Title Menu

var back_x = x;
var back_y = y;

var start_x = x;
var start_y = y - 60; // fallback

if (instance_exists(oBut_Level1)) {
	start_x = oBut_Level1.x;
	start_y = oBut_Level1.y + 20;
	instance_destroy(oBut_Level1);
}
if (instance_exists(oBut_Level2)) {
	instance_destroy(oBut_Level2);
}

instance_destroy(); // Destroy oBut_Back

// Re-create Title Buttons
instance_create_layer(start_x, start_y, "Instances", oBut_Start);
instance_create_layer(back_x, back_y, "Instances", oBut_Quit);
