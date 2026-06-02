/// @description Step

x += (xTo - x)*.05;
y += (yTo - y)*.05;
	
xTo = DestX
yTo = DestY

var shake_x = 0;
var shake_y = 0;
if (instance_exists(oCont_Room) && variable_instance_exists(oCont_Room, "screen_shake")) {
	var s = oCont_Room.screen_shake;
	if (s > 0) {
		shake_x = random_range(-s, s);
		shake_y = random_range(-s, s);
	}
}

var vm = matrix_build_lookat(x + shake_x, y + shake_y, -10, x + shake_x, y + shake_y, 0, 0, 1, 0)
camera_set_view_mat(Camera,vm);

#region Move
if mouse_check_button_pressed(mb_middle){
	
	DestX = mouse_x;
	DestY = mouse_y;
}

// Get GUI mouse position for MOBA-style edge scrolling (1280x720 window boundaries)
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var edge_margin = 15;   // Distance in pixels from screen border to trigger scroll
var scroll_speed = 8;   // Smooth gliding speed

MoveR = (mx >= 1280 - edge_margin) || keyboard_check(vk_right);
MoveL = (mx <= edge_margin) || keyboard_check(vk_left);
MoveD = (my >= 720 - edge_margin) || keyboard_check(vk_down);
MoveU = (my <= edge_margin) || keyboard_check(vk_up);

DestX += (MoveR - MoveL) * scroll_speed;
DestY += (MoveD - MoveU) * scroll_speed;

var BufferW = ((CamInitW*ZoomFactor)/2);
var BufferH = ((CamInitH*ZoomFactor)/2)

//Keep DestXY in map
if DestX > room_width - BufferW {DestX = room_width - BufferW};
if DestX < BufferW {DestX =  BufferW};
if DestY > room_height - BufferH {DestY = room_height - BufferH};
if DestY <  BufferH {DestY = BufferH};

#endregion
