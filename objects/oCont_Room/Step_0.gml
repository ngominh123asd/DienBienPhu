/// @description Mass select units

if (!loc_zones_initialized) {
    loc_zones_initialized = true;
    loc_zones = [];
    loc_zone_visited = [];
    with (obj_map_zone) {
        array_push(other.loc_zones, {
            x1: bbox_left,
            y1: bbox_top,
            x2: bbox_right,
            y2: bbox_bottom,
            name: zone_name,
            short_name: short_name,
            story: story_text
        });
        array_push(other.loc_zone_visited, false);
    }
}


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
		sidequest_current_chapter = -1; // Reset to Chapter selection list
		sidequest_current_question = -1;
		audio_play_sound(sndConvert, 10, false);
	}
}

// Main 3-Chapter Sidequest Event Handling
if (sidequest_open) {
	CanClick = 0;
	
	var box_x = 240; 
	var box_y = 100; 
	var box_w = 800; 
	var box_h = 520;
	
	if (sidequest_current_chapter == -1) {
		// --- TẦNG 1: DANH SÁCH 3 CHƯƠNG CHIẾN DỊCH ---
		for (var i = 0; i < 3; i++) {
			var ch_w = 700;
			var ch_h = 95;
			var ch_x = box_x + (box_w - ch_w) / 2;
			var ch_y = box_y + 110 + i * 110;
			
			var hover = (mx >= ch_x && mx <= ch_x + ch_w && my >= ch_y && my <= ch_y + ch_h);
			if (hover && mouse_check_button_pressed(mb_left)) {
				sidequest_current_chapter = i;
				sidequest_current_question = -1; // Go to Chapter question list
				audio_play_sound(sndConvert, 10, false);
			}
		}
		
		// Close button
		var close_w = 180;
		var close_h = 45;
		var close_x = box_x + (box_w - close_w) / 2;
		var close_y = box_y + box_h - 65;
		var close_hover = (mx >= close_x && mx <= close_x + close_w && my >= close_y && my <= close_y + close_h);
		if (close_hover && mouse_check_button_pressed(mb_left)) {
			sidequest_open = false;
			audio_play_sound(sndConvert, 10, false);
		}
	} 
	else if (sidequest_current_question == -1) {
		// --- TẦNG 2: DANH SÁCH 3 CÂU HỎI TRONG CHƯƠNG ---
		var ch_idx = sidequest_current_chapter;
		
		// 3 Question Buttons
		for (var i = 0; i < 3; i++) {
			var btn_w = 700;
			var btn_h = 65;
			var btn_x = box_x + (box_w - btn_w) / 2;
			var btn_y = box_y + 120 + i * 85;
			
			var hover = (mx >= btn_x && mx <= btn_x + btn_w && my >= btn_y && my <= btn_y + btn_h);
			if (hover && mouse_check_button_pressed(mb_left)) {
				// Only allow answering if not already correct
				if (chapter_questions_status[ch_idx][i] == 1) {
					audio_play_sound(sndLevelUp, 10, false);
				} else {
					sidequest_current_question = i;
					audio_play_sound(sndConvert, 10, false);
				}
			}
		}
		
		// Back to Chapter List button
		var back_w = 180;
		var back_h = 45;
		var back_x = box_x + (box_w - back_w) / 2;
		var back_y = box_y + box_h - 65;
		var back_hover = (mx >= back_x && mx <= back_x + back_w && my >= back_y && my <= back_y + back_h);
		if (back_hover && mouse_check_button_pressed(mb_left)) {
			sidequest_current_chapter = -1;
			audio_play_sound(sndConvert, 10, false);
		}
	} 
	else {
		// --- TẦNG 3: TRẢ LỜI CÂU HỎI TRẮC NGHIỆM ---
		var ch_idx = sidequest_current_chapter;
		var q_idx = sidequest_current_question;
		var q_data = sidequest_chapters[ch_idx].questions[q_idx];
		
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
					chapter_questions_status[ch_idx][q_idx] = 1;
					audio_play_sound(sndLevelUp, 10, false);
					sidequest_current_question = -1; // Return to Chapter question selection
					
					// --- Check for Chapter Completes (Rewards) ---
					// Chapter 1 Complete: Spawn Phan Đình Giót Hero + Unlock Q & W (R & T keys)
					if (ch_idx == 0 && !skill_q_unlocked) {
						if (chapter_questions_status[0][0] == 1 && chapter_questions_status[0][1] == 1 && chapter_questions_status[0][2] == 1) {
							skill_q_unlocked = true;
							skill_w_unlocked = true;
							
							// Spawn Phan Đình Giót
							if (instance_exists(obj_cancu)) {
								var hero = instance_create_layer(obj_cancu.x - 80, obj_cancu.y - 60, "Instances", oFr_Soldier);
								if (hero != noone) {
									hero.IsHero = true;
									hero.HeroName = "Phan Đình Giót";
									hero.MaxHp = 30;
									hero.CurHp = 30;
									hero.Power = 4;
									hero.Name = "Phan Đình Giót (Tướng)";
									hero.skill_cooldowns = [0, 0, 0];
									hero.skill_max_cooldowns = [300, 480, 600]; // 5s, 8s, 10s cooldowns
									hero.UnitScale = 0.2; // 30% larger than normal soldier (0.15)
									hero.vanguard_timer = 0;
									hero.shield_timer = 0;
									
									// Auto select and focus hero immediately
									hero.Selected = 1;
									focused_hero = hero;
									
									// Visual Effects & Notification
									instance_create_layer(hero.x, hero.y, "Instances", oFx_LevelUp);
									var txt = instance_create_layer(hero.x, hero.y, "Instances", oFx_ConvertText);
									if (txt != noone) {
										txt.Parent = hero;
										txt.Text = "PHAN ĐÌNH GIỚT XUẤT TRẬN!";
									}
								}
							}
						}
					}
					// Chapter 2 Complete: Spawn Bế Văn Đàn Hero + Unlock E (Y key) + Tăng 50% Công
					if (ch_idx == 1 && !skill_e_unlocked) {
						if (chapter_questions_status[1][0] == 1 && chapter_questions_status[1][1] == 1 && chapter_questions_status[1][2] == 1) {
							skill_e_unlocked = true;
							chapter_upgrade_power = true;
							
							// Spawn Bế Văn Đàn
							if (instance_exists(obj_cancu)) {
								var hero = instance_create_layer(obj_cancu.x - 140, obj_cancu.y - 60, "Instances", oFr_Archer);
								if (hero != noone) {
									hero.IsHero = true;
									hero.HeroName = "Bế Văn Đàn";
									hero.MaxHp = 25;
									hero.CurHp = 25;
									hero.Power = 3;
									hero.Name = "Bế Văn Đàn (Tướng)";
									hero.skill_cooldowns = [0, 0, 0];
									hero.skill_max_cooldowns = [360, 480, 720]; // 6s, 8s, 12s cooldowns
									hero.UnitScale = 0.2; // 30% larger than normal soldier, perfectly matched in size with Phan Đình Giót
									hero.vanguard_timer = 0;
									hero.shield_timer = 0;
									
									// Auto select and focus hero immediately
									hero.Selected = 1;
									focused_hero = hero;
									
									// Visual Effects & Notification
									instance_create_layer(hero.x, hero.y, "Instances", oFx_LevelUp);
									var txt = instance_create_layer(hero.x, hero.y, "Instances", oFx_ConvertText);
									if (txt != noone) {
										txt.Parent = hero;
										txt.Text = "BẾ VĂN ĐÀN XUẤT TRẬN!";
									}
								}
							}
						}
					}
					// Chapter 3 Complete: Unlock R (U key) + Cuồng nộ toàn quân + Bất tử 5s
					if (ch_idx == 2 && !skill_r_unlocked) {
						if (chapter_questions_status[2][0] == 1 && chapter_questions_status[2][1] == 1 && chapter_questions_status[2][2] == 1) {
							skill_r_unlocked = true;
							chapter_upgrade_stats = true;
							invincible_timer = 300; // 5 seconds of invincibility
							
							// Scale all current player units
							with (oPar_PlayerUnit) {
								MaxHp = ceil(MaxHp * 1.8); // +80% Max HP
								CurHp = MaxHp; // heal to full
								instance_create_layer(x, y, "Instances", oFx_LevelUp); // light effect!
							}
						}
					}
				} 
				else {
					// Incorrect!
					chapter_questions_status[ch_idx][q_idx] = 0;
					
					// Trigger random nightmare penalty debuff (20 seconds = 1200 frames)
					debuff_active = true;
					debuff_timer = 1200; 
					debuff_type = choose("french_air_strike", "french_counter_attack", "total_supply_cutoff", "extreme_storm_mines");
					
					audio_play_sound(sndDie, 10, false);
					
					// Handle French Air strike damage immediately
					if (debuff_type == "french_air_strike") {
						with (oPar_PlayerUnit) {
							CurHp = max(1, floor(CurHp * 0.6)); // Deal 40% current HP damage (leaves at least 1 HP)
							effect_create_above(ef_explosion, x, y, 0.5, c_red);
						}
						screen_shake = 20; // violent camera rumble!
					}
					
					sidequest_open = false; // Auto close on fail so players immediately face the punishment!
				}
			}
		}
		
		// Back to Chapter question selection
		var back_w = 180;
		var back_h = 45;
		var back_x = box_x + (box_w - back_w) / 2;
		var back_y = box_y + box_h - 65;
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

#region Location Zone Detection
// Check camera center against zone boundaries
if (instance_exists(oCamera)) {
	var cam_cx = oCamera.x;
	var cam_cy = oCamera.y;
	
	var new_zone = -1;
	for (var i = 0; i < array_length(loc_zones); i++) {
		var z = loc_zones[i];
		if (cam_cx >= z.x1 && cam_cx <= z.x2 && cam_cy >= z.y1 && cam_cy <= z.y2) {
			new_zone = i;
			break;
		}
	}
	
	// Detect zone transition
	if (new_zone != loc_zone_current) {
		loc_zone_prev = loc_zone_current;
		loc_zone_current = new_zone;
		
		if (new_zone != -1) {
			loc_zone_alpha = 0;
			loc_zone_timer = 0;
			loc_zone_visited[new_zone] = true;
		}
	}
	
	// Animate popup
	if (loc_zone_current != -1) {
		loc_zone_timer++;
		
		// Fade in (first 30 frames)
		if (loc_zone_timer <= 30) {
			loc_zone_alpha = loc_zone_timer / 30;
		}
		// Hold
		else if (loc_zone_timer < loc_zone_show_duration - 60) {
			loc_zone_alpha = 1.0;
		}
		// Fade out (last 60 frames)
		else if (loc_zone_timer < loc_zone_show_duration) {
			loc_zone_alpha = (loc_zone_show_duration - loc_zone_timer) / 60;
		}
		else {
			loc_zone_alpha = 0;
		}
	} else {
		// Quick fade out when leaving zone
		loc_zone_alpha = max(0, loc_zone_alpha - 0.03);
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
	
	// Apply continuous screen shake for extreme_storm_mines
	if (debuff_type == "extreme_storm_mines") {
		if (screen_shake < 6) screen_shake = 6;
	}
}

// Update invincible timer
if (invincible_timer > 0) invincible_timer--;

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
if (debuff_active && debuff_type == "french_counter_attack") {
	enemy_speed_mult = 2.0; // 100% speed increase!
} else if (debuff_active && debuff_type == "enemy_rage") {
	enemy_speed_mult = 1.5;
}
var weather_slow_mult = (weather_state == 2) ? 0.5 : ((weather_state == 1) ? 0.7 : 1.0);

with (oPar_Enemy) {
	if (!variable_instance_exists(self, "base_spd")) {
		base_spd = Spd;
	}
	Spd = base_spd * weather_slow_mult * enemy_speed_mult;
}

// Player slow and upgrade multiplier
var player_slow_mult = 1.0;
if (debuff_active) {
	if (debuff_type == "mud_slow") player_slow_mult = 0.5;
	else if (debuff_type == "extreme_storm_mines") player_slow_mult = 0.3; // -70% slow!
}
var ch3_speed_mult = chapter_upgrade_stats ? 1.5 : 1.0; // +50% speed increase!

with (oPar_PlayerUnit) {
	if (!variable_instance_exists(self, "base_spd")) {
		base_spd = Spd;
	}
	Spd = base_spd * player_slow_mult * ch3_speed_mult;
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

// --- 1.7. TAB Key Hero Cycling ---
if (keyboard_check_pressed(vk_tab)) {
	var selected_heroes = [];
	with (oPar_PlayerUnit) {
		if (Selected && variable_instance_exists(self, "IsHero") && IsHero) {
			array_push(selected_heroes, id);
		}
	}
	
	var hero_count = array_length(selected_heroes);
	if (hero_count > 1) {
		var current_idx = -1;
		for (var i = 0; i < hero_count; i++) {
			if (selected_heroes[i] == focused_hero) {
				current_idx = i;
				break;
			}
		}
		
		var next_idx = (current_idx + 1) % hero_count;
		focused_hero = selected_heroes[next_idx];
		audio_play_sound(sndConvert, 10, false);
	}
}

// Keep focused_hero validated and selected
var heroes_list = [];
with (oPar_PlayerUnit) {
	if (Selected && variable_instance_exists(self, "IsHero") && IsHero) {
		array_push(heroes_list, id);
	}
}
if (array_length(heroes_list) > 0) {
	var found = false;
	for (var i = 0; i < array_length(heroes_list); i++) {
		if (heroes_list[i] == focused_hero) {
			found = true;
			break;
		}
	}
	if (!found) {
		focused_hero = heroes_list[0];
	}
} else {
	focused_hero = noone;
}

// Q, W, E keys activate currently focused Hero's skills 1, 2, 3
if (focused_hero != noone && instance_exists(focused_hero)) {
	if (keyboard_check_pressed(ord("Q"))) {
		with (focused_hero) event_user(1); // Skill 1
	}
	if (keyboard_check_pressed(ord("W"))) {
		with (focused_hero) event_user(2); // Skill 2
	}
	if (keyboard_check_pressed(ord("E"))) {
		with (focused_hero) event_user(3); // Skill 3
	}
} else {
	if (keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("E"))) {
		if (skill_q_unlocked || skill_e_unlocked) {
			audio_play_sound(sndDie, 10, false);
			if (instance_exists(oCamera)) {
				var txt = instance_create_layer(oCamera.x, oCamera.y - 40, "Instances", oFx_ConvertText);
				if (txt != noone) {
					txt.Parent = noone;
					txt.Text = "HÃY CHỌN TƯỚNG ANH HÙNG TRƯỚC!";
					txt.life_timer = 90;
				}
			}
		}
	}
}

// Toggle Air Strike (R key) - locked until Chapter 1 cleared
if (keyboard_check_pressed(ord("R")) && skill_q_unlocked) {
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

// Toggle AA Flak Barrage (T key) - locked until Chapter 1 cleared
if (keyboard_check_pressed(ord("T")) && skill_w_unlocked) {
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

// Toggle Katyusha Rocket Strike (Y key) - locked until Chapter 2 cleared
if (keyboard_check_pressed(ord("Y")) && skill_e_unlocked) {
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

// Toggle Giant A1 TNT Charge (U key) - locked until Chapter 3 cleared
if (keyboard_check_pressed(ord("U")) && skill_r_unlocked) {
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

var is_video_playing = false;
if (instance_exists(obj_locot_boss) && variable_instance_exists(obj_locot_boss, "VideoState") && obj_locot_boss.VideoState > 0) {
	is_video_playing = true;
}

if (!instance_exists(oPar_PlayerUnit) && !is_video_playing) {
	if (!instance_exists(oTutText_GameOver)) {
		instance_create_layer(x,y,"Sensors",oTutText_GameOver);	
	}
}
#endregion