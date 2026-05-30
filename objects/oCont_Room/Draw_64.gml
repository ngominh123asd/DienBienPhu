/// @description Draw stats on left

#region Draw Hp on left side

var a = 0

with(oPar_PlayerUnit){
	
	if Selected{
		
		draw_set_color(c_white)
		draw_text(5, 190 + (a * 20), string(Name) + " Lv" + string(Level) + "- HP " + string(CurHp) + "/" + string(MaxHp))
		a ++;
	}
}

#endregion

var Minutes = floor(TimePlayed/60/60);
var Seconds = floor(TimePlayed/60) - (Minutes * 60);
		
if Minutes < 10 {Minutes = "0" + string(Minutes)};
if Seconds < 10 {Seconds = "0" + string(Seconds)};
		
var PlayedString = string(Minutes) + ":" + string(Seconds);

draw_set_halign(fa_right);
draw_set_color(c_yellow);
draw_text(1275,10,"Press 'BACKSPACE' to Quit");
draw_set_halign(fa_left);
draw_text(5,700,"Time: " + string(PlayedString));

#region Draw Minimap

// Minimap dimensions & bounding box matching Step_0.gml
var map_max_w = 220;
var map_max_h = 160;
var scale = min(map_max_w / room_width, map_max_h / room_height);
var minimap_w = room_width * scale;
var minimap_h = room_height * scale;

var padding = 10;
var map_x = padding;
var map_y = padding;

// 1. Draw Background (Dark transparent glass)
draw_set_color(c_black);
draw_set_alpha(0.65);
draw_rectangle(map_x, map_y, map_x + minimap_w, map_y + minimap_h, false);

// 2. Draw Borders (Glowing blue border)
draw_set_color(make_color_rgb(0, 150, 255));
draw_set_alpha(0.8);
draw_rectangle(map_x - 1, map_y - 1, map_x + minimap_w + 1, map_y + minimap_h + 1, true);
draw_set_alpha(0.3);
draw_rectangle(map_x - 2, map_y - 2, map_x + minimap_w + 2, map_y + minimap_h + 2, true);

// 3. Draw Player Units (Green dots)
draw_set_alpha(1.0);
with (oPar_PlayerUnit) {
	var px = map_x + (x / room_width) * minimap_w;
	var py = map_y + (y / room_height) * minimap_h;
	
	draw_set_color(make_color_rgb(50, 220, 100));
	draw_circle(px, py, 2.5, false);
}

// 4. Draw Enemies (Red dots)
with (oPar_Enemy) {
	var ex = map_x + (x / room_width) * minimap_w;
	var ey = map_y + (y / room_height) * minimap_h;
	
	draw_set_color(make_color_rgb(255, 60, 60));
	draw_circle(ex, ey, 2.5, false);
}

// 5. Draw Viewport Camera Box (White transparent rect showing where the camera is looking)
if (instance_exists(oCamera)) {
	var cam_w = camera_get_view_width(oCamera.Camera);
	var cam_h = camera_get_view_height(oCamera.Camera);
	var cam_x = oCamera.x - cam_w / 2;
	var cam_y = oCamera.y - cam_h / 2;
	
	var cv_x1 = map_x + (cam_x / room_width) * minimap_w;
	var cv_y1 = map_y + (cam_y / room_height) * minimap_h;
	var cv_x2 = map_x + ((cam_x + cam_w) / room_width) * minimap_w;
	var cv_y2 = map_y + ((cam_y + cam_h) / room_height) * minimap_h;
	
	// Clamp inside minimap box
	cv_x1 = clamp(cv_x1, map_x, map_x + minimap_w);
	cv_y1 = clamp(cv_y1, map_y, map_y + minimap_h);
	cv_x2 = clamp(cv_x2, map_x, map_x + minimap_w);
	cv_y2 = clamp(cv_y2, map_y, map_y + minimap_h);
	
	draw_set_color(c_white);
	draw_set_alpha(0.35);
	draw_rectangle(cv_x1, cv_y1, cv_x2, cv_y2, true);
	draw_set_alpha(0.08);
	draw_rectangle(cv_x1, cv_y1, cv_x2, cv_y2, false);
}

// Reset draw settings
draw_set_alpha(1.0);
draw_set_color(c_white);

#endregion