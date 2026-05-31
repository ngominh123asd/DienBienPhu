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

var padding = 10;
var map_x = padding;
var map_y = padding;

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
	// Cooldown ngắn sau khi rời minimap để tránh click nhầm
	if (alarm[0] <= 0 && CanClick == 0) {
		alarm[0] = 10; // 10 frame delay
	}
	if (alarm[0] <= 0) {
		CanClick = 1;
	}
}
#endregion

#region Clicking units

// Decrement shake and cooldowns
if (bomb_cooldown > 0) bomb_cooldown--;
if (w_cooldown > 0) w_cooldown--;
if (e_cooldown > 0) e_cooldown--;
if (r_cooldown > 0) r_cooldown--;
if (screen_shake > 0) screen_shake -= 0.5;

// Update Weather Timer & State
weather_timer++;
if (weather_timer >= weather_duration) {
	weather_timer = 0;
	weather_state = 1 - weather_state;
	
	// Lightning flash and thunder rumble when transitioning to rain
	if (weather_state == 1) {
		screen_shake = 10;
		audio_play_sound(sndDragonfireHit, 9, false); // Thunder sound
	}
}

// Update rain particle positions & slow down enemies
if (weather_state == 1) {
	for (var i = 0; i < array_length(rain_drops); i++) {
		var drop = rain_drops[i];
		drop.x += drop.spd * 0.4;
		drop.y += drop.spd;
		if (drop.y > 720) {
			drop.y = -30;
			drop.x = irandom(1280);
		}
		if (drop.x > 1280) {
			drop.x = -30;
			drop.y = irandom(720);
		}
	}
	
	// Slow down all enemies in muddy rain season by 30%
	with (oPar_Enemy) {
		if (!variable_instance_exists(self, "base_spd")) {
			base_spd = Spd;
		}
		Spd = base_spd * 0.7;
	}
} else {
	// Restore normal speed when sunny
	with (oPar_Enemy) {
		if (variable_instance_exists(self, "base_spd")) {
			Spd = base_spd;
		}
	}
}

// Process Katyusha Rocket Strikes over time (salvo queue)
for (var i = array_length(katyusha_queue) - 1; i >= 0; i--) {
	var item = katyusha_queue[i];
	item.delay--;
	if (item.delay <= 0) {
		// Spawn rocket flying chéo chéo down to the target
		var rx = item.target_x - 120; // starts top-left offset
		var ry = item.target_y - 250;
		var rocket = instance_create_layer(rx, ry, "Instances", obj_air_bomb);
		if (rocket != noone) {
			rocket.bomb_type = 2; // Katyusha Rocket
			rocket.target_x = item.target_x;
			rocket.target_y = item.target_y;
			rocket.speed = 11;
			rocket.direction = point_direction(rx, ry, item.target_x, item.target_y);
			rocket.image_angle = rocket.direction - 90;
		}
		array_delete(katyusha_queue, i, 1);
	}
}

// Cancel targeting mode with Escape or Right Click (consume right click on cancellation)
if (keyboard_check_pressed(vk_escape) || mouse_check_button_pressed(mb_right)) {
	var did_cancel = false;
	if (targeting_mode > 0) {
		targeting_mode = 0;
		targeting_active = false;
		Dragging = 0;
		did_cancel = true;
	}
	if (did_cancel && mouse_check_button_pressed(mb_right)) {
		exit; // Consume the right click so units do not move to the click location
	}
}

// Toggle Air Strike (Q key)
if (keyboard_check_pressed(ord("Q"))) {
	if (bomb_cooldown == 0) {
		if (targeting_mode == 1) {
			targeting_mode = 0;
			targeting_active = false;
		} else {
			targeting_mode = 1;
			targeting_active = true;
			Dragging = 0;
		}
	}
}

// Toggle AA Flak Barrage (W key)
if (keyboard_check_pressed(ord("W"))) {
	if (w_cooldown == 0) {
		if (targeting_mode == 2) {
			targeting_mode = 0;
			targeting_active = false;
		} else {
			targeting_mode = 2;
			targeting_active = true;
			Dragging = 0;
		}
	}
}

// Toggle Katyusha Rocket Strike (E key)
if (keyboard_check_pressed(ord("E"))) {
	if (e_cooldown == 0) {
		if (targeting_mode == 3) {
			targeting_mode = 0;
			targeting_active = false;
		} else {
			targeting_mode = 3;
			targeting_active = true;
			Dragging = 0;
		}
	}
}

// Toggle Giant A1 TNT Charge (R key)
if (keyboard_check_pressed(ord("R"))) {
	if (r_cooldown == 0) {
		if (targeting_mode == 4) {
			targeting_mode = 0;
			targeting_active = false;
		} else {
			targeting_mode = 4;
			targeting_active = true;
			Dragging = 0;
		}
	}
}

// Handle Custom Clicks in Targeting Modes
if (mouse_check_button_pressed(mb_left) && CanClick) {
	if (targeting_mode > 0) {
		var tx = mouse_x;
		var ty = mouse_y;
		
		if (targeting_mode == 1) {
			// --- Q: Air Strike Action ---
			var cam_x = camera_get_view_x(view_camera[0]);
			var plane_x = cam_x - 120; // Spawn off-screen left
			var plane_y = ty;
			
			var plane = instance_create_layer(plane_x, plane_y, "Instances", obj_strike_plane);
			if (plane != noone) {
				plane.target_x = tx;
				plane.target_y = ty;
			}
			
			// Play alarm/conversion sound
			audio_play_sound(sndConvert, 10, false);
			
			bomb_cooldown = bomb_max_cooldown;
		}
		else if (targeting_mode == 2) {
			// --- W: Lô cốt Chiến hào ---
			var bunker = instance_create_layer(tx, ty, "Instances", obj_locot_player);
			if (bunker != noone) {
				effect_create_above(ef_smoke, tx, ty, 1, c_gray);
				effect_create_above(ef_ring, tx, ty, 1, c_aqua);
			}
			
			// Play alert sound
			audio_play_sound(sndConvert, 10, false);
			w_cooldown = w_max_cooldown;
		}
		else if (targeting_mode == 3) {
			// --- E: Trại Huấn Luyện ---
			var camp = instance_create_layer(tx, ty, "Instances", obj_training_camp);
			if (camp != noone) {
				effect_create_above(ef_smoke, tx, ty, 1, c_gray);
				effect_create_above(ef_ring, tx, ty, 1, c_green);
			}
			
			audio_play_sound(sndConvert, 10, false);
			e_cooldown = e_max_cooldown;
		}
		else if (targeting_mode == 4) {
			// --- R: Cao xạ 37mm ---
			var gun = instance_create_layer(tx, ty, "Instances", obj_anti_air_gun);
			if (gun != noone) {
				effect_create_above(ef_smoke, tx, ty, 1, c_gray);
				effect_create_above(ef_ring, tx, ty, 1, c_orange);
			}
			
			audio_play_sound(sndConvert, 10, false);
			r_cooldown = r_max_cooldown;
		}
		
		targeting_mode = 0;
		targeting_active = false;
		exit; // Stop executing standard click/drag
	}
}

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

// Right click to move with formations (safety bypass when targeting is active)
if mouse_check_button_pressed(mb_right) && !mouse_over_minimap && !targeting_active {
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