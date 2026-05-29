/// @description Step

x += (xTo - x)*.05;
y += (yTo - y)*.05;
	
xTo = DestX
yTo = DestY

var vm = matrix_build_lookat(x,y,-10,x,y,0,0,1,0)
camera_set_view_mat(Camera,vm);

#region Move
if mouse_check_button_pressed(mb_middle){
	
	DestX = mouse_x;
	DestY = mouse_y;
}

//Get controls
MoveR = keyboard_check(vk_right) || keyboard_check(ord("D"));
MoveU = keyboard_check(vk_up) || keyboard_check(ord("W"));
MoveL = keyboard_check(vk_left) || keyboard_check(ord("A"));
MoveD = keyboard_check(vk_down) || keyboard_check(ord("S"));

DestX += (MoveR - MoveL) * 4;
DestY += (MoveD - MoveU) * 4;

var BufferW = ((CamInitW*ZoomFactor)/2);
var BufferH = ((CamInitH*ZoomFactor)/2)

//Keep DestXY in map
if DestX > room_width - BufferW {DestX = room_width - BufferW};
if DestX < BufferW {DestX =  BufferW};
if DestY > room_height - BufferH {DestY = room_height - BufferH};
if DestY <  BufferH {DestY = BufferH};

#endregion
