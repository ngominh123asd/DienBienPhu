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

// Disable minimap hover if radar is jammed
if (debuff_active && debuff_type == "radar_jam") {
	mouse_over_minimap = false;
}

// Check sidequest button click
var sq_btn_x = map_x + minimap_w + 15;
var sq_btn_y = map_y;
var sq_btn_w = 150;
var sq_btn_h = 40;
var mouse_over_sq_btn = (mx >= sq_btn_x && mx <= sq_btn_x + sq_btn_w && my >= sq_btn_y && my <= sq_btn_y + sq_btn_h);

if (mouse_over_sq_btn && !sidequest_open) {
	CanClick = 0;
	if (mouse_check_button_pressed(mb_left)) {
		sidequest_open = true;
		sidequest_current_question = -1; // Reset to selection menu
		audio_play_sound(sndConvert, 10, false);
	}
}

// Main Sidequest Event Handling
if (sidequest_open) {
	CanClick = 0;
	
	var box_x = 240; 
	var box_y = 100; 
	var box_w = 800; 
	var box_h = 520;
	
	if (sidequest_current_question == -1) {
		// Selection Menu Click Handling
		for (var i = 0; i < 4; i++) {
			var btn_w = 700;
			var btn_h = 65;
			var btn_x = box_x + (box_w - btn_w) / 2;
			var btn_y = box_y + 110 + i * 80;
			
			var hover = (mx >= btn_x && mx <= btn_x + btn_w && my >= btn_y && my <= btn_y + btn_h);
			if (hover && mouse_check_button_pressed(mb_left)) {
				if (question_status[i] == 1) {
					audio_play_sound(sndLevelUp, 10, false);
				} else {
					sidequest_current_question = i;
					audio_play_sound(sndConvert, 10, false);
				}
			}
		}
		
		// Close button at bottom of Menu
		var close_w = 180;
		var close_h = 45;
		var close_x = box_x + (box_w - close_w) / 2;
		var close_y = box_y + box_h - 70;
		
		var close_hover = (mx >= close_x && mx <= close_x + close_w && my >= close_y && my <= close_y + close_h);
		if (close_hover && mouse_check_button_pressed(mb_left)) {
			sidequest_open = false;
			audio_play_sound(sndConvert, 10, false);
		}
	} else {
		// Question Click Handling
		var q_idx = sidequest_current_question;
		var q_data = sidequest_questions[q_idx];
		
		// 4 Multiple Choice buttons
		for (var i = 0; i < 4; i++) {
			var opt_w = 340;
			var opt_h = 80;
			var opt_x = box_x + 40 + (i % 2) * 380;
			var opt_y = box_y + 220 + floor(i / 2) * 110;
			
			var hover = (mx >= opt_x && mx <= opt_x + opt_w && my >= opt_y && my <= opt_y + opt_h);
			if (hover && mouse_check_button_pressed(mb_left)) {
				if (i == q_data.correct) {
					// Correct!
					question_status[q_idx] = 1;
					if (q_idx == 0) skill_q_unlocked = true;
					if (q_idx == 1) skill_w_unlocked = true;
					if (q_idx == 2) skill_e_unlocked = true;
					if (q_idx == 3) skill_r_unlocked = true;
					
					audio_play_sound(sndLevelUp, 10, false);
					sidequest_current_question = -1; // Return to selection menu
				} else {
					// Incorrect!
					question_status[q_idx] = 0;
					
					// Trigger random debuff
					debuff_active = true;
					debuff_timer = 900; // 15 seconds
					debuff_type = choose("radar_jam", "mud_slow", "ammo_shortage", "enemy_rage");
					
					audio_play_sound(sndDie, 10, false);
					sidequest_open = false; // Auto close on fail to show the consequence!
				}
			}
		}
		
		// Back to Menu button
		var back_w = 180;
		var back_h = 45;
		var back_x = box_x + (box_w - back_w) / 2;
		var back_y = box_y + box_h - 70;
		
		var back_hover = (mx >= back_x && mx <= back_x + back_w && my >= back_y && my <= back_y + back_h);
		if (back_hover && mouse_check_button_pressed(mb_left)) {
			sidequest_current_question = -1;
			audio_play_sound(sndConvert, 10, false);
		}
	}
	
	exit; // Bypasses standard movement/clicks completely!
}

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

// Update active penalty debuff timer
if (debuff_active) {
	debuff_timer--;
	if (debuff_timer <= 0) {
		debuff_active = false;
		debuff_type = "";
	}
}

// Update Weather Timer & State
weather_timer++;
if (weather_timer >= weather_duration) {
	weather_timer = 0;
	weather_state = (weather_state + 1) % 3; // Sunny (0) -> Rainy (1) -> Stormy (2)
	
	// Create screen-wide flash & thunder clap when transitioning to rain or storm!
	if (weather_state == 1 || weather_state == 2) {
		screen_shake = 12;
		audio_play_sound(sndDragonfireHit, 9, false); // Thunder sound
	}
}

// Lightning simulator during Stormy weather (state == 2)
if (weather_state == 2) {
	if (!lightning_active && irandom(160) == 0) { // Trigger lightning strike
		lightning_active = true;
		lightning_alpha = 0.8;
		screen_shake = 18; // Heavy ground rumble!
		audio_play_sound(sndDragonfireHit, 10, false); // Massive thunder strike
	}
	
	if (lightning_active) {
		// Natural double-strike flicker simulation
		lightning_alpha -= random_range(0.04, 0.1);
		if (lightning_alpha <= 0) {
			lightning_active = false;
			lightning_alpha = 0;
		}
	}
} else {
	lightning_active = false;
	lightning_alpha = 0;
}

// 1. Update rain particle positions
if (weather_state > 0) {
	var speed_mult = (weather_state == 2) ? 2.2 : 1.0;
	
	for (var i = 0; i < array_length(rain_drops); i++) {
		var drop = rain_drops[i];
		drop.x += drop.spd * 0.8 * speed_mult; // Heavy wind slant
		drop.y += drop.spd * speed_mult;
		if (drop.y > 720) {
			drop.y = -30;
			drop.x = irandom(1280);
		}
		if (drop.x > 1280) {
			drop.x = -30;
			drop.y = irandom(720);
		}
	}
}

// 2. Calculate movement speeds based on weather and debuffs
var enemy_speed_mult = 1.0;
if (debuff_active && debuff_type == "enemy_rage") {
	enemy_speed_mult = 1.5;
}
var weather_slow_mult = (weather_state == 2) ? 0.5 : ((weather_state == 1) ? 0.7 : 1.0);

with (oPar_Enemy) {
	if (!variable_instance_exists(self, "base_spd")) {
		base_spd = Spd;
	}
	Spd = base_spd * weather_slow_mult * enemy_speed_mult;
}

// Player slow multiplier
var player_slow_mult = 1.0;
if (debuff_active && debuff_type == "mud_slow") {
	player_slow_mult = 0.5;
}

with (oPar_PlayerUnit) {
	if (!variable_instance_exists(self, "base_spd")) {
		base_spd = Spd;
	}
	Spd = base_spd * player_slow_mult;
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

// Toggle Air Strike (Q key) - locked until sidequest cleared
if (keyboard_check_pressed(ord("Q")) && skill_q_unlocked) {
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

// Toggle AA Flak Barrage (W key) - locked until sidequest cleared
if (keyboard_check_pressed(ord("W")) && skill_w_unlocked) {
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

// Toggle Katyusha Rocket Strike (E key) - locked until sidequest cleared
if (keyboard_check_pressed(ord("E")) && skill_e_unlocked) {
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

// Toggle Giant A1 TNT Charge (R key) - locked until sidequest cleared
if (keyboard_check_pressed(ord("R")) && skill_r_unlocked) {
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