/// @description Idle around

MouseOver = position_meeting(mouse_x, mouse_y, self);
LClick = mouse_check_button_pressed(mb_left);
RClick = mouse_check_button_pressed(mb_right);
Cancel = keyboard_check_pressed(vk_escape);

// Fix scale dân làng
if !variable_instance_exists(id, "UnitScale") {
	UnitScale = 0.105;
}

// Timer hành động dân làng
if !variable_instance_exists(id, "DoingAction") {
	DoingAction = false;
}

if !variable_instance_exists(id, "ActionTimer") {
	ActionTimer = irandom_range(room_speed * 2, room_speed * 5);
}

if !variable_instance_exists(id, "ActionFrame") {
	ActionFrame = 0;
}

if !variable_instance_exists(id, "WorkDir") {
	WorkDir = choose(0, 90, 180, 270);
}

if !variable_instance_exists(id, "WorkMoveTimer") {
	WorkMoveTimer = 0;
}

if !variable_instance_exists(id, "WorkMoveCount") {
	WorkMoveCount = 0;
}

// Đếm thời gian
ActionTimer--;

// Hết giờ thì đổi trạng thái
if ActionTimer <= 0 {
	
	if DoingAction {
		// Dừng làm việc
		DoingAction = false;
		ActionFrame = 0;
		image_index = 0;
		
		// Chờ 3-8 giây mới làm tiếp
		ActionTimer = irandom_range(room_speed * 3, room_speed * 8);
	}
	else {
		// Bắt đầu làm việc
		DoingAction = true;
		ActionFrame = 0;
		image_index = 0;
		
		// Reset hướng làm việc cho lần hành động mới
		WorkDir = choose(0, 90, 180, 270);
		WorkMoveTimer = 0;
		WorkMoveCount = 0;
		
		// Làm việc trong 2-4 giây
		ActionTimer = irandom_range(room_speed * 2, room_speed * 4);
	}
}

// Giữ scale
if image_xscale < 0 {
	image_xscale = -UnitScale;
}
else {
	image_xscale = UnitScale;
}

image_yscale = UnitScale;

if CurHp <= 0 {
	instance_destroy();
}

// Idle move nhẹ
if irandom(room_speed * 2) == 1 {
	
	var Dist = 8;
	
	DestX = x + irandom_range(-Dist, Dist);
	DestY = y + irandom_range(-Dist, Dist);
	
	if collision_circle(DestX, DestY, 3, oPar_Collidable, 0, 1) {
		DestX = x;
		DestY = y;
	}
}
else {
	
	if distance_to_point(DestX, DestY) > 2 {
		mp_potential_step_object(DestX, DestY, .25, oPar_Collidable);
	}
}

// Animation làm việc + di chuyển nhẹ theo 1 hướng cố định
image_speed = 0;

if DoingAction {
	
	ActionFrame += 0.12;
	
	if ActionFrame >= image_number {
		ActionFrame = 0;
	}
	
	image_index = floor(ActionFrame);
	
	WorkMoveTimer--;
	
	// Chỉ nhích vài lần trong một lần hành động, không lắc trái/phải liên tục
	if WorkMoveTimer <= 0 && WorkMoveCount < 3 {
		
		WorkMoveTimer = 10;
		WorkMoveCount++;
		
		var work_step = 2;
		var move_x = lengthdir_x(work_step, WorkDir);
		var move_y = lengthdir_y(work_step, WorkDir);
		
		if !place_meeting(x + move_x, y, oPar_Collidable) {
			x += move_x;
		}
		
		if !place_meeting(x, y + move_y, oPar_Collidable) {
			y += move_y;
		}
	}
}
else {
	ActionFrame = 0;
	image_index = 0;
}

// Lật trái/phải
if x > xprevious {
	image_xscale = UnitScale;
}
else if x < xprevious {
	image_xscale = -UnitScale;
}

image_yscale = UnitScale;