/// @description Mass select units

if instance_exists(oEn_Dragon){
	TimePlayed ++;
}

#region Minimap Math & Check
var gui_w = 1280;
var gui_h = 720;
var map_max_w = 220;
var map_max_h = 160;
var scale = min(map_max_w / room_width, map_max_h / room_height);
var minimap_w = room_width * scale;
var minimap_h = room_height * scale;

var padding = 20;
var map_x = gui_w - minimap_w - padding;
var map_y = gui_h - minimap_h - padding;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var mouse_over_minimap = (mx >= map_x && mx <= map_x + minimap_w && my >= map_y && my <= map_y + minimap_h);

if (mouse_over_minimap) {
	CanClick = 0;
	if (mouse_check_button(mb_left)) {
		var rx = ((mx - map_x) / minimap_w) * room_width;
		var ry = ((my - map_y) / minimap_h) * room_height;
		
		if (instance_exists(oCamera)) {
			oCamera.DestX = rx;
			oCamera.DestY = ry;
		}
	}
} else {
	if (alarm[0] <= 0) {
		CanClick = 1;
	}
}
#endregion

#region Clicking units
//Get initial click
if mouse_check_button_pressed(mb_left) && CanClick{
	
	X1 = mouse_x;
	Y1 = mouse_y;
	Dragging = 1;
}

//Drag and set coords as dragging
if mouse_check_button(mb_left) && Dragging{
	
	X2 = mouse_x;
	Y2 = mouse_y;
}

//Let go of button and select troops inside
if mouse_check_button_released(mb_left) && Dragging{
	
	Dragging = 0;
	//Select if inside rect
	with(oPar_PlayerUnit){
		if collision_rectangle(oCont_Room.X1,oCont_Room.Y1,oCont_Room.X2,oCont_Room.Y2,self,0,0){
			Selected = 1;	
		}
	}
}

// Right click to move with formations
if mouse_check_button_pressed(mb_right) && !mouse_over_minimap {
	var sel_count = 0;
	var cx = 0;
	var cy = 0;
	var has_selected = false;
	
	with (oPar_PlayerUnit) {
		if (Selected) {
			cx += x;
			cy += y;
			sel_count++;
			has_selected = true;
		}
	}
	
	if (has_selected) {
		cx /= sel_count;
		cy /= sel_count;
		
		var mx = mouse_x;
		var my = mouse_y;
		var dir = point_direction(cx, cy, mx, my);
		
		with (oPar_PlayerUnit) {
			if (Selected) {
				if (object_index == oFr_Soldier || object_index == oFr_Villager) {
					DestX = mx;
					DestY = my;
				}
				else if (object_index == oFr_Archer) {
					DestX = mx - lengthdir_x(25, dir);
					DestY = my - lengthdir_y(25, dir);
				}
				else if (object_index == oFr_Mage) {
					DestX = mx - lengthdir_x(40, dir);
					DestY = my - lengthdir_y(40, dir);
				}
				else {
					DestX = mx;
					DestY = my;
				}
			}
		}
		
		if !instance_exists(oFx_GotoSpot) {
			instance_create_layer(mx, my, "Instances", oFx_GotoSpot);
		}
	}
}
#endregion

#region Water Effects

if irandom(1) = 1{
	
	instance_create_layer(irandom(room_width),irandom(room_height),"Instances",oFx_WaterShine);	
	instance_create_layer(irandom(room_width),irandom(room_height),"Instances",oFx_WaterShine);	
	instance_create_layer(irandom(room_width),irandom(room_height),"Instances",oFx_WaterShine);	
}

#endregion

#region Game Over

if !instance_exists(oPar_PlayerUnit){
	
	instance_create_layer(x,y,"Sensors",oTutText_GameOver);	
}
#endregion