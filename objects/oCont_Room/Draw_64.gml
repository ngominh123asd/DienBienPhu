/// @description Draw stats on left

#region Draw Hp on left side

draw_set_halign(fa_left);
draw_set_valign(fa_top);

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

// Check if radar jam debuff is active
var map_max_w = 220;
var map_max_h = 160;
var scale = min(map_max_w / room_width, map_max_h / room_height);
var minimap_w = room_width * scale;
var minimap_h = room_height * scale;

var padding = 10;
var map_x = padding;
var map_y = padding;

if (!(debuff_active && debuff_type == "radar_jam")) {
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
	
	// 4.5. Draw Special Markers
	// Base (obj_cancu)
	with (obj_cancu) {
		var bx = map_x + (x / room_width) * minimap_w;
		var by = map_y + (y / room_height) * minimap_h;
		
		draw_set_color(c_aqua);
		draw_rectangle(bx - 3, by - 3, bx + 3, by + 3, false);
	}
	
	// Bunker (oPar_locot)
	with (oPar_locot) {
		var lx = map_x + (x / room_width) * minimap_w;
		var ly = map_y + (y / room_height) * minimap_h;
		
		draw_set_color(c_orange);
		draw_rectangle(lx - 2, ly - 2, lx + 2, ly + 2, false);
	}
	
	// Boss (oEn_Dragon)
	with (oEn_Dragon) {
		var dx = map_x + (x / room_width) * minimap_w;
		var dy = map_y + (y / room_height) * minimap_h;
		
		draw_set_color(c_fuchsia);
		draw_circle(dx, dy, 4, false);
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
	
	// 5.5. Draw Location Names on Minimap
	draw_set_font(fnt_vietnamese);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	// Location data: [room_x, room_y, label]
	// 1) Cụm cứ điểm Him Lam - cluster of bunkers in upper-left area (~x:130, y:260)
	// 2) Sân bay Mường Thanh - airstrip in center area (~x:550, y:400)
	// 3) Tập đoàn cứ điểm - dense bunker complex on the right (~x:780, y:140)
	var loc_names = [
		[130, 260, "Him Lam"],
		[550, 400, "SB M.Thanh"],
		[780, 140, "TĐ Cứ Điểm"]
	];
	
	for (var i = 0; i < array_length(loc_names); i++) {
		var lbl_rx = loc_names[i][0]; // room x
		var lbl_ry = loc_names[i][1]; // room y
		var lbl_text = loc_names[i][2];
		
		// Convert room coords to minimap coords
		var lbl_mx = map_x + (lbl_rx / room_width) * minimap_w;
		var lbl_my = map_y + (lbl_ry / room_height) * minimap_h;
		
		// Clamp label inside minimap bounds with small margin
		lbl_mx = clamp(lbl_mx, map_x + 15, map_x + minimap_w - 15);
		lbl_my = clamp(lbl_my, map_y + 5, map_y + minimap_h - 5);
		
		// Draw dark pill background for readability
		var tw = string_width(lbl_text) * 0.45 + 4;
		var th = string_height(lbl_text) * 0.45 + 2;
		draw_set_color(c_black);
		draw_set_alpha(0.55);
		draw_rectangle(lbl_mx - tw/2, lbl_my - th/2, lbl_mx + tw/2, lbl_my + th/2, false);
		
		// Draw label text
		draw_set_alpha(0.9);
		draw_set_color(make_color_rgb(255, 230, 150)); // Warm gold color
		draw_text_transformed(lbl_mx, lbl_my, lbl_text, 0.45, 0.45, 0);
	}
} else {
	// Draw radar jam warning inside minimap box
	draw_set_color(c_black);
	draw_set_alpha(0.85);
	draw_rectangle(map_x, map_y, map_x + minimap_w, map_y + minimap_h, false);
	
	draw_set_color(c_red);
	draw_set_alpha(0.9);
	draw_rectangle(map_x - 1, map_y - 1, map_x + minimap_w + 1, map_y + minimap_h + 1, true);
	
	draw_set_font(fnt_vietnamese);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	var warning_pulse = 0.5 + sin(current_time * 0.015) * 0.5;
	draw_set_color(merge_color(c_red, c_yellow, warning_pulse));
	draw_text_transformed(map_x + minimap_w/2, map_y + minimap_h/2, "⚠ MẤT TÍN HIỆU ⚠\nRADAR BỊ NHIỄU", 1.0, 1.0, 0);
	draw_set_alpha(1.0);
}

// 6. Draw Sidequest Button next to Minimap
var sq_btn_x = map_x + minimap_w + 15;
var sq_btn_y = map_y;
var sq_btn_w = 150;
var sq_btn_h = 40;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var sq_btn_hover = (mx >= sq_btn_x && mx <= sq_btn_x + sq_btn_w && my >= sq_btn_y && my <= sq_btn_y + sq_btn_h);

var btn_pulse = 0.5 + sin(current_time * 0.01) * 0.5;

// Glassmorphic button background
if (sq_btn_hover) {
	draw_set_color(make_color_rgb(70, 70, 70));
	draw_set_alpha(0.85);
} else {
	draw_set_color(c_black);
	draw_set_alpha(0.7);
}
draw_rectangle(sq_btn_x, sq_btn_y, sq_btn_x + sq_btn_w, sq_btn_y + sq_btn_h, false);

// Glowing military gold/green border
var all_cleared = (chapter_questions_status[0][0] == 1 && chapter_questions_status[0][1] == 1 && chapter_questions_status[0][2] == 1 && chapter_questions_status[1][0] == 1 && chapter_questions_status[1][1] == 1 && chapter_questions_status[1][2] == 1 && chapter_questions_status[2][0] == 1 && chapter_questions_status[2][1] == 1 && chapter_questions_status[2][2] == 1);

if (all_cleared) {
	draw_set_color(make_color_rgb(50, 220, 100));
	draw_set_alpha(0.8);
} else {
	draw_set_color(merge_color(make_color_rgb(180, 150, 50), c_yellow, btn_pulse * 0.4));
	draw_set_alpha(0.7 + btn_pulse * 0.3);
}
draw_rectangle(sq_btn_x - 1, sq_btn_y - 1, sq_btn_x + sq_btn_w + 1, sq_btn_y + sq_btn_h + 1, true);

draw_set_font(fnt_vietnamese);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (all_cleared) {
	draw_set_color(make_color_rgb(50, 220, 100));
	draw_text_transformed(sq_btn_x + sq_btn_w/2, sq_btn_y + sq_btn_h/2, "✓ HOÀN THÀNH", 1.0, 1.0, 0);
} else {
	draw_set_color(c_yellow);
	draw_text_transformed(sq_btn_x + sq_btn_w/2, sq_btn_y + sq_btn_h/2, "NHIỆM VỤ PHỤ", 1.0, 1.0, 0);
}

// Reset draw settings
draw_set_alpha(1.0);
draw_set_color(c_white);
#endregion

#region Dien Bien Phu Tactical HUD Skills Panel
var hud_x = 410;
var hud_y = 635;
var hud_w = 460;
var hud_h = 75;

// Draw glassmorphism panel background
draw_set_color(c_black);
draw_set_alpha(0.75);
draw_rectangle(hud_x, hud_y, hud_x + hud_w, hud_y + hud_h, false);

// Draw gold military border
draw_set_color(make_color_rgb(180, 150, 50));
draw_set_alpha(0.85);
draw_rectangle(hud_x - 1, hud_y - 1, hud_x + hud_w + 1, hud_y + hud_h + 1, true);

// Set font and alignment
draw_set_font(fnt_vietnamese);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --- 1. [Q] AIR STRIKE BUTTON ---
var q_x1 = hud_x + 15;
var q_y1 = hud_y + 10;
var q_x2 = q_x1 + 95;
var q_y2 = q_y1 + 55;

// Background base
if (!skill_q_unlocked) {
    draw_set_color(c_black);
    draw_set_alpha(0.8);
} else if (bomb_cooldown == 0) {
    if (targeting_mode == 1) {
        var border_pulse = 0.5 + sin(current_time * 0.01) * 0.3;
        draw_set_color(make_color_rgb(150, 120, 20));
        draw_set_alpha(0.5 + border_pulse * 0.2);
    } else {
        draw_set_color(make_color_rgb(85, 30, 30)); // Deep tactical red
        draw_set_alpha(0.6);
    }
} else {
    draw_set_color(c_dkgray);
    draw_set_alpha(0.4);
}
draw_rectangle(q_x1, q_y1, q_x2, q_y2, false);

if (skill_q_unlocked && bomb_cooldown > 0) {
    var q_pct = bomb_cooldown / bomb_max_cooldown;
    draw_set_color(c_red);
    draw_set_alpha(0.35);
    draw_rectangle(q_x1, q_y2 - (q_y2 - q_y1) * q_pct, q_x2, q_y2, false);
}

draw_set_alpha(1.0);
if (!skill_q_unlocked) {
    draw_set_color(c_gray);
    draw_text_transformed((q_x1 + q_x2)/2, (q_y1 + q_y2)/2, "KHÓA\n(Sidequest)", 1.0, 1.0, 0);
} else if (bomb_cooldown > 0) {
    draw_set_color(c_white);
    draw_text_transformed((q_x1 + q_x2)/2, (q_y1 + q_y2)/2, "COOLDOWN\n" + string(ceil(bomb_cooldown / 60)) + "s", 1.0, 1.0, 0);
} else {
    draw_set_color(targeting_mode == 1 ? c_yellow : c_white);
    draw_text_transformed((q_x1 + q_x2)/2, (q_y1 + q_y2)/2, "KHÔNG KÍCH\nPHÍM R", 1.0, 1.0, 0);
}

if (skill_q_unlocked && targeting_mode == 1) {
    var border_pulse = 0.5 + sin(current_time * 0.01) * 0.3;
    draw_set_color(c_yellow);
    draw_set_alpha(0.7 + border_pulse * 0.3);
    draw_rectangle(q_x1 - 1, q_y1 - 1, q_x2 + 1, q_y2 + 1, true);
} else {
    draw_set_color(make_color_rgb(180, 150, 50));
    draw_set_alpha(skill_q_unlocked ? 0.5 : 0.2);
    draw_rectangle(q_x1, q_y1, q_x2, q_y2, true);
}


// --- 2. [W] AA FLAK BARRAGE BUTTON ---
var w_x1 = hud_x + 125;
var w_y1 = hud_y + 10;
var w_x2 = w_x1 + 95;
var w_y2 = w_y1 + 55;

// Background base
if (!skill_w_unlocked) {
    draw_set_color(c_black);
    draw_set_alpha(0.8);
} else if (w_cooldown == 0) {
    if (targeting_mode == 2) {
        var border_pulse = 0.5 + sin(current_time * 0.01) * 0.3;
        draw_set_color(make_color_rgb(150, 120, 20));
        draw_set_alpha(0.5 + border_pulse * 0.2);
    } else {
        draw_set_color(make_color_rgb(30, 80, 85)); // Steel cyan
        draw_set_alpha(0.6);
    }
} else {
    draw_set_color(c_dkgray);
    draw_set_alpha(0.4);
}
draw_rectangle(w_x1, w_y1, w_x2, w_y2, false);

if (skill_w_unlocked && w_cooldown > 0) {
    var w_pct = w_cooldown / w_max_cooldown;
    draw_set_color(c_red);
    draw_set_alpha(0.35);
    draw_rectangle(w_x1, w_y2 - (w_y2 - w_y1) * w_pct, w_x2, w_y2, false);
}

draw_set_alpha(1.0);
if (!skill_w_unlocked) {
    draw_set_color(c_gray);
    draw_text_transformed((w_x1 + w_x2)/2, (w_y1 + w_y2)/2, "KHÓA\n(Sidequest)", 1.0, 1.0, 0);
} else if (w_cooldown > 0) {
    draw_set_color(c_white);
    draw_text_transformed((w_x1 + w_x2)/2, (w_y1 + w_y2)/2, "COOLDOWN\n" + string(ceil(w_cooldown / 60)) + "s", 1.0, 1.0, 0);
} else {
    draw_set_color(targeting_mode == 2 ? c_yellow : c_white);
    draw_text_transformed((w_x1 + w_x2)/2, (w_y1 + w_y2)/2, "PHÒNG KHÔNG\nPHÍM T", 1.0, 1.0, 0);
}

if (skill_w_unlocked && targeting_mode == 2) {
    var border_pulse = 0.5 + sin(current_time * 0.01) * 0.3;
    draw_set_color(c_yellow);
    draw_set_alpha(0.7 + border_pulse * 0.3);
    draw_rectangle(w_x1 - 1, w_y1 - 1, w_x2 + 1, w_y2 + 1, true);
} else {
    draw_set_color(make_color_rgb(180, 150, 50));
    draw_set_alpha(skill_w_unlocked ? 0.5 : 0.2);
    draw_rectangle(w_x1, w_y1, w_x2, w_y2, true);
}


// --- 3. [E] KATYUSHA SALVO BUTTON ---
var e_x1 = hud_x + 235;
var e_y1 = hud_y + 10;
var e_x2 = e_x1 + 95;
var e_y2 = e_y1 + 55;

// Background base
if (!skill_e_unlocked) {
    draw_set_color(c_black);
    draw_set_alpha(0.8);
} else if (e_cooldown == 0) {
    if (targeting_mode == 3) {
        var border_pulse = 0.5 + sin(current_time * 0.01) * 0.3;
        draw_set_color(make_color_rgb(150, 120, 20));
        draw_set_alpha(0.5 + border_pulse * 0.2);
    } else {
        draw_set_color(make_color_rgb(30, 85, 40)); // Forest green
        draw_set_alpha(0.6);
    }
} else {
    draw_set_color(c_dkgray);
    draw_set_alpha(0.4);
}
draw_rectangle(e_x1, e_y1, e_x2, e_y2, false);

if (skill_e_unlocked && e_cooldown > 0) {
    var e_pct = e_cooldown / e_max_cooldown;
    draw_set_color(c_red);
    draw_set_alpha(0.35);
    draw_rectangle(e_x1, e_y2 - (e_y2 - e_y1) * e_pct, e_x2, e_y2, false);
}

draw_set_alpha(1.0);
if (!skill_e_unlocked) {
    draw_set_color(c_gray);
    draw_text_transformed((e_x1 + e_x2)/2, (e_y1 + e_y2)/2, "KHÓA\n(Sidequest)", 1.0, 1.0, 0);
} else if (e_cooldown > 0) {
    draw_set_color(c_white);
    draw_text_transformed((e_x1 + e_x2)/2, (e_y1 + e_y2)/2, "COOLDOWN\n" + string(ceil(e_cooldown / 60)) + "s", 1.0, 1.0, 0);
} else {
    draw_set_color(targeting_mode == 3 ? c_yellow : c_white);
    draw_text_transformed((e_x1 + e_x2)/2, (e_y1 + e_y2)/2, "HỎA TIỄN H6\nPHÍM Y", 1.0, 1.0, 0);
}

if (skill_e_unlocked && targeting_mode == 3) {
    var border_pulse = 0.5 + sin(current_time * 0.01) * 0.3;
    draw_set_color(c_yellow);
    draw_set_alpha(0.7 + border_pulse * 0.3);
    draw_rectangle(e_x1 - 1, e_y1 - 1, e_x2 + 1, e_y2 + 1, true);
} else {
    draw_set_color(make_color_rgb(180, 150, 50));
    draw_set_alpha(skill_e_unlocked ? 0.5 : 0.2);
    draw_rectangle(e_x1, e_y1, e_x2, e_y2, true);
}


// --- 4. [R] GIANT A1 TNT BOMB BUTTON ---
var r_x1 = hud_x + 345;
var r_y1 = hud_y + 10;
var r_x2 = r_x1 + 95;
var r_y2 = r_y1 + 55;

// Background base
if (!skill_r_unlocked) {
    draw_set_color(c_black);
    draw_set_alpha(0.8);
} else if (r_cooldown == 0) {
    if (targeting_mode == 4) {
        var border_pulse = 0.5 + sin(current_time * 0.01) * 0.3;
        draw_set_color(make_color_rgb(150, 120, 20));
        draw_set_alpha(0.5 + border_pulse * 0.2);
    } else {
        draw_set_color(make_color_rgb(75, 25, 80)); // Royal purple
        draw_set_alpha(0.6);
    }
} else {
    draw_set_color(c_dkgray);
    draw_set_alpha(0.4);
}
draw_rectangle(r_x1, r_y1, r_x2, r_y2, false);

if (skill_r_unlocked && r_cooldown > 0) {
    var r_pct = r_cooldown / r_max_cooldown;
    draw_set_color(c_red);
    draw_set_alpha(0.35);
    draw_rectangle(r_x1, r_y2 - (r_y2 - r_y1) * r_pct, r_x2, r_y2, false);
}

draw_set_alpha(1.0);
if (!skill_r_unlocked) {
    draw_set_color(c_gray);
    draw_text_transformed((r_x1 + r_x2)/2, (r_y1 + r_y2)/2, "KHÓA\n(Sidequest)", 1.0, 1.0, 0);
} else if (r_cooldown > 0) {
    draw_set_color(c_white);
    draw_text_transformed((r_x1 + r_x2)/2, (r_y1 + r_y2)/2, "COOLDOWN\n" + string(ceil(r_cooldown / 60)) + "s", 1.0, 1.0, 0);
} else {
    draw_set_color(targeting_mode == 4 ? c_yellow : c_white);
    draw_text_transformed((r_x1 + r_x2)/2, (r_y1 + r_y2)/2, "BỘC PHÁ A1\nPHÍM U", 1.0, 1.0, 0);
}

if (skill_r_unlocked && targeting_mode == 4) {
    var border_pulse = 0.5 + sin(current_time * 0.01) * 0.3;
    draw_set_color(c_yellow);
    draw_set_alpha(0.7 + border_pulse * 0.3);
    draw_rectangle(r_x1 - 1, r_y1 - 1, r_x2 + 1, r_y2 + 1, true);
} else {
    draw_set_color(make_color_rgb(180, 150, 50));
    draw_set_alpha(skill_r_unlocked ? 0.5 : 0.2);
    draw_rectangle(r_x1, r_y1, r_x2, r_y2, true);
}

// Reset draw settings
draw_set_alpha(1.0);
draw_set_color(c_white);
#endregion

#region Draw Rain Overlay & Weather Widget
// 1. Draw lightning screen-wide flash overlay during Storm
if (lightning_active && lightning_alpha > 0) {
    draw_set_color(c_white);
    draw_set_alpha(lightning_alpha);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1.0);
}

// 2. Draw diagonal rain streaks on GUI when weather is active (state > 0)
if (weather_state > 0) {
    var draw_col = (weather_state == 2) ? make_color_rgb(140, 180, 255) : make_color_rgb(180, 210, 255);
    var slant = (weather_state == 2) ? 0.8 : 0.4;
    var alpha = (weather_state == 2) ? 0.55 : 0.35;
    
    draw_set_color(draw_col);
    draw_set_alpha(alpha);
    for (var i = 0; i < array_length(rain_drops); i++) {
        var drop = rain_drops[i];
        draw_line_width(drop.x, drop.y, drop.x + drop.len * slant, drop.y + drop.len, (weather_state == 2) ? 2.0 : 1.5);
    }
    
    // Soft vignette/overlay color based on weather severity
    var overlay_col = (weather_state == 2) ? make_color_rgb(30, 45, 75) : make_color_rgb(50, 80, 120);
    var overlay_alpha = (weather_state == 2) ? 0.16 : 0.08;
    draw_set_color(overlay_col);
    draw_set_alpha(overlay_alpha);
    draw_rectangle(0, 0, 1280, 720, false);
}

// 3. Draw Weather Widget at bottom right
var wx = 1100;
var wy = 645;
var ww = 165;
var wh = 55;

// Glassmorphism background
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(wx, wy, wx + ww, wy + wh, false);

// Gold military border
draw_set_color(make_color_rgb(180, 150, 50));
draw_set_alpha(0.85);
draw_rectangle(wx - 1, wy - 1, wx + ww + 1, wy + wh + 1, true);

// Text styling
draw_set_font(fnt_vietnamese);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_set_alpha(0.5);
draw_text(wx + ww/2, wy + 12, "KHÍ HẬU CHIẾN TRƯỜNG");

// Status indicator
draw_set_alpha(1.0);
if (weather_state == 0) {
    draw_set_color(c_yellow);
    draw_text(wx + ww/2, wy + 28, "KHÔ RÁO");
} else if (weather_state == 1) {
    draw_set_color(make_color_rgb(100, 200, 255));
    draw_text(wx + ww/2, wy + 28, "BÙN LẦY (-30% SPD)");
} else if (weather_state == 2) {
    // Storm status flashes between purple and red!
    var pulse = 0.5 + sin(current_time * 0.015) * 0.5;
    var storm_col = merge_color(make_color_rgb(180, 0, 250), make_color_rgb(255, 60, 60), pulse);
    draw_set_color(storm_col);
    draw_text(wx + ww/2, wy + 28, "GIÔNG BÃO (-50% SPD)");
}

// Progress bar showing time until switch
var w_pct = 1 - (weather_timer / weather_duration);
draw_set_color(c_dkgray);
draw_rectangle(wx + 10, wy + wh - 10, wx + ww - 10, wy + wh - 7, false);

var bar_col = c_yellow;
if (weather_state == 1) bar_col = make_color_rgb(0, 150, 255);
else if (weather_state == 2) bar_col = make_color_rgb(180, 0, 200); // Purple bar for storm!

draw_set_color(bar_col);
draw_rectangle(wx + 10, wy + wh - 10, wx + 10 + (ww - 20) * w_pct, wy + wh - 7, false);

// Reset draw settings
draw_set_alpha(1.0);
draw_set_color(c_white);

#region Draw Active Debuff, Sidequest Overlay & Hero Skills
// 1. Draw Active Debuff Warning Banner
if (debuff_active) {
    var db_x = 490;
    var db_y = 90;
    var db_w = 300;
    var db_h = 55;
    
    // Flashing red/black background
    var pulse = 0.5 + sin(current_time * 0.01) * 0.5;
    var bg_col = merge_color(c_black, make_color_rgb(100, 10, 10), pulse);
    draw_set_color(bg_col);
    draw_set_alpha(0.85);
    draw_rectangle(db_x, db_y, db_x + db_w, db_y + db_h, false);
    
    draw_set_color(c_red);
    draw_set_alpha(0.9);
    draw_rectangle(db_x - 1, db_y - 1, db_x + db_w + 1, db_y + db_h + 1, true);
    
    draw_set_font(fnt_vietnamese);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var db_title = "";
    var db_desc = "";
    if (debuff_type == "radar_jam") {
        db_title = "⚠️ MẤT LIÊN LẠC RADAR";
        db_desc = "Bản đồ nhỏ tạm thời bị nhiễu sóng!";
    } else if (debuff_type == "mud_slow") {
        db_title = "⚠️ BÃO BÙN LẦY CỰC HẠN";
        db_desc = "Tốc độ di chuyển quân ta giảm 50%!";
    } else if (debuff_type == "ammo_shortage") {
        db_title = "⚠️ HỤT ĐẠN DƯỢC QUÂN NHU";
        db_desc = "Quân lính tạm thời không thể tấn công!";
    } else if (debuff_type == "enemy_rage") {
        db_title = "⚠️ ĐỊCH TỔNG CÔNG KÍCH";
        db_desc = "Tốc độ di chuyển kẻ địch tăng 50%!";
    } else if (debuff_type == "french_air_strike") {
        db_title = "⚠️ KHÔNG KÍCH PHÁP B-26";
        db_desc = "Bị oanh tạc! Mất 40% máu lính hiện tại!";
    } else if (debuff_type == "french_counter_attack") {
        db_title = "⚠️ ĐỊCH TỔNG PHẢN CÔNG";
        db_desc = "Tốc độ và công quân địch tăng GẤP ĐÔI!";
    } else if (debuff_type == "total_supply_cutoff") {
        db_title = "⚠️ ĐƯỜNG TIẾP TẾ BỊ CẮT";
        db_desc = "Cấm lính tấn công, quân ta liên tục rút máu!";
    } else if (debuff_type == "extreme_storm_mines") {
        db_title = "⚠️ BÃO GIÔNG & MÌN BẪY";
        db_desc = "Lực chạy -70%, tắt radar, cam rung dữ dội!";
    }
    
    draw_set_color(c_yellow);
    draw_text_transformed(db_x + db_w/2, db_y + 16, db_title + " (" + string(ceil(debuff_timer / 60)) + "s)", 1.0, 1.0, 0);
    draw_set_color(c_white);
    draw_text_ext_transformed(db_x + db_w/2, db_y + 38, db_desc, 22, 280, 1.0, 1.0, 0);
    
    draw_set_alpha(1.0);
}

// 2. Draw Sidequest Dialog Modal Overlay
if (sidequest_open) {
    // Dark glass overlay
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_rectangle(0, 0, 1280, 720, false);
    
    // Dialog Box
    var box_x = 240; 
    var box_y = 100; 
    var box_w = 800; 
    var box_h = 520;
    
    draw_set_color(make_color_rgb(25, 30, 25)); // Dark military green-gray
    draw_set_alpha(0.95);
    draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, false);
    
    // Glowing border (flashing gold)
    var border_pulse = 0.5 + sin(current_time * 0.01) * 0.5;
    draw_set_color(merge_color(make_color_rgb(180, 150, 50), c_yellow, border_pulse * 0.2));
    draw_set_alpha(0.8);
    draw_rectangle(box_x - 1, box_y - 1, box_x + box_w + 1, box_y + box_h + 1, true);
    draw_set_alpha(0.3);
    draw_rectangle(box_x - 3, box_y - 3, box_x + box_w + 3, box_y + box_h + 3, true);
    
    draw_set_font(fnt_vietnamese);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    if (sidequest_current_chapter == -1) {
        // --- TẦNG 1: MENU CHỌN 3 CHƯƠNG CHIẾN DỊCH ---
        draw_set_color(c_yellow);
        draw_text_transformed(box_x + box_w/2, box_y + 35, "★ HÀNH TRÌNH LỊCH SỬ ĐIỆN BIÊN PHỦ ★", 1.0, 1.0, 0);
        
        draw_set_color(c_white);
        draw_text_transformed(box_x + box_w/2, box_y + 65, "Trả lời các câu hỏi lịch sử tương ứng với 3 đợt tiến công của chiến dịch.\nHoàn thành chương để mở khóa các kỹ năng chiến thuật và tướng quân tối thượng!", 1.0, 1.0, 0);
        
        for (var i = 0; i < 3; i++) {
            var ch_w = 720;
            var ch_h = 90;
            var ch_x = box_x + (box_w - ch_w) / 2;
            var ch_y = box_y + 105 + i * 105;
            
            var hover = (mx >= ch_x && mx <= ch_x + ch_w && my >= ch_y && my <= ch_y + ch_h);
            
            if (hover) {
                draw_set_color(make_color_rgb(50, 60, 50));
                draw_set_alpha(0.9);
            } else {
                draw_set_color(make_color_rgb(15, 20, 15));
                draw_set_alpha(0.7);
            }
            draw_rectangle(ch_x, ch_y, ch_x + ch_w, ch_y + ch_h, false);
            
            // Check status of all 3 questions in this chapter
            var solved_count = 0;
            for (var q = 0; q < 3; q++) {
                if (chapter_questions_status[i][q] == 1) solved_count++;
            }
            
            var border_col = make_color_rgb(180, 150, 50);
            if (solved_count == 3) border_col = make_color_rgb(50, 220, 100);
            
            draw_set_color(border_col);
            draw_set_alpha(hover ? 0.9 : 0.5);
            draw_rectangle(ch_x, ch_y, ch_x + ch_w, ch_y + ch_h, true);
            
            // Draw text
            draw_set_color(c_yellow);
            draw_set_halign(fa_left);
            draw_text_transformed(ch_x + 20, ch_y + 20, sidequest_chapters[i].name, 1.0, 1.0, 0);
            
            draw_set_color(c_white);
            draw_text_transformed(ch_x + 20, ch_y + 45, sidequest_chapters[i].sub, 1.0, 1.0, 0);
            
            draw_set_color(make_color_rgb(200, 200, 200));
            draw_text_transformed(ch_x + 20, ch_y + 68, "Thưởng: " + sidequest_chapters[i].reward_txt, 1.0, 1.0, 0);
            
            // Draw progress status
            var status_text = "";
            var status_col = c_yellow;
            if (solved_count == 3) {
                status_text = "✓ ĐÃ HOÀN THÀNH";
                status_col = make_color_rgb(50, 220, 100);
            } else {
                status_text = "○ TIẾN ĐỘ: " + string(solved_count) + "/3";
                status_col = c_yellow;
            }
            
            draw_set_color(status_col);
            draw_set_halign(fa_right);
            draw_text_transformed(ch_x + ch_w - 20, ch_y + ch_h/2, status_text, 1.0, 1.0, 0);
        }
        
        // Draw Close button
        var close_w = 180;
        var close_h = 45;
        var close_x = box_x + (box_w - close_w) / 2;
        var close_y = box_y + box_h - 65;
        var close_hover = (mx >= close_x && mx <= close_x + close_w && my >= close_y && my <= close_y + close_h);
        
        if (close_hover) {
            draw_set_color(make_color_rgb(120, 40, 40));
            draw_set_alpha(0.9);
        } else {
            draw_set_color(make_color_rgb(60, 20, 20));
            draw_set_alpha(0.75);
        }
        draw_rectangle(close_x, close_y, close_x + close_w, close_y + close_h, false);
        
        draw_set_color(c_white);
        draw_set_alpha(0.8);
        draw_rectangle(close_x, close_y, close_x + close_w, close_y + close_h, true);
        
        draw_set_halign(fa_center);
        draw_text_transformed(close_x + close_w/2, close_y + close_h/2, "ĐÓNG GIAO DIỆN", 1.0, 1.0, 0);
    } 
    else if (sidequest_current_question == -1) {
        // --- TẦNG 2: MENU CHỌN CÂU HỎI TRONG CHƯƠNG ---
        var ch_idx = sidequest_current_chapter;
        
        draw_set_color(c_yellow);
        draw_text_transformed(box_x + box_w/2, box_y + 35, sidequest_chapters[ch_idx].name, 1.0, 1.0, 0);
        
        draw_set_color(c_white);
        draw_text_transformed(box_x + box_w/2, box_y + 65, sidequest_chapters[ch_idx].sub, 1.0, 1.0, 0);
        
        for (var i = 0; i < 3; i++) {
            var btn_w = 700;
            var btn_h = 65;
            var btn_x = box_x + (box_w - btn_w) / 2;
            var btn_y = box_y + 120 + i * 85;
            
            var hover = (mx >= btn_x && mx <= btn_x + btn_w && my >= btn_y && my <= btn_y + btn_h);
            
            if (hover) {
                draw_set_color(make_color_rgb(50, 60, 50));
                draw_set_alpha(0.9);
            } else {
                draw_set_color(make_color_rgb(15, 20, 15));
                draw_set_alpha(0.7);
            }
            draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
            
            var border_col = make_color_rgb(180, 150, 50);
            if (chapter_questions_status[ch_idx][i] == 1) border_col = make_color_rgb(50, 220, 100);
            else if (chapter_questions_status[ch_idx][i] == 0) border_col = c_red;
            
            draw_set_color(border_col);
            draw_set_alpha(hover ? 0.9 : 0.5);
            draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, true);
            
            // Draw Question index
            draw_set_color(c_white);
            draw_set_halign(fa_left);
            draw_text_transformed(btn_x + 25, btn_y + btn_h/2, "Giải mã mật lệnh " + string(i + 1), 1.0, 1.0, 0);
            
            // Draw status
            var status_text = "";
            var status_col = c_yellow;
            if (chapter_questions_status[ch_idx][i] == 1) {
                status_text = "✓ ĐÃ GIẢI MÃ";
                status_col = make_color_rgb(50, 220, 100);
            } else if (chapter_questions_status[ch_idx][i] == 0) {
                status_text = "✗ THẤT BẠI - CẦN GIẢI LẠI";
                status_col = c_red;
            } else {
                status_text = "○ CHƯA GIẢI MÃ";
                status_col = c_yellow;
            }
            
            draw_set_color(status_col);
            draw_set_halign(fa_right);
            draw_text_transformed(btn_x + btn_w - 25, btn_y + btn_h/2, status_text, 1.0, 1.0, 0);
        }
        
        // Back to Chapter List button
        var back_w = 180;
        var back_h = 45;
        var back_x = box_x + (box_w - back_w) / 2;
        var back_y = box_y + box_h - 65;
        var back_hover = (mx >= back_x && mx <= back_x + back_w && my >= back_y && my <= back_y + back_h);
        
        if (back_hover) {
            draw_set_color(make_color_rgb(80, 80, 80));
            draw_set_alpha(0.9);
        } else {
            draw_set_color(make_color_rgb(40, 40, 40));
            draw_set_alpha(0.75);
        }
        draw_rectangle(back_x, back_y, back_x + back_w, back_y + back_h, false);
        
        draw_set_color(c_white);
        draw_set_alpha(0.8);
        draw_rectangle(back_x, back_y, back_x + back_w, back_y + back_h, true);
        
        draw_set_halign(fa_center);
        draw_text_transformed(back_x + back_w/2, back_y + back_h/2, "QUAY LẠI", 1.0, 1.0, 0);
    } 
    else {
        // --- TẦNG 3: TRẢ LỜI CÂU HỎI TRẮC NGHIỆM ---
        var ch_idx = sidequest_current_chapter;
        var q_idx = sidequest_current_question;
        var q_data = sidequest_chapters[ch_idx].questions[q_idx];
        
        draw_set_color(c_yellow);
        draw_text_transformed(box_x + box_w/2, box_y + 35, "★ MẬT LỆNH CHIẾN TRƯỜNG " + string(q_idx + 1) + " ★", 1.0, 1.0, 0);
        
        // Draw Question Text with word-wrapping
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text_ext_transformed(box_x + box_w/2, box_y + 110, q_data.q, 25, 720, 1.0, 1.0, 0);
        
        // Draw 4 options in 2x2 grid
        for (var i = 0; i < 4; i++) {
            var opt_w = 340;
            var opt_h = 80;
            var opt_x = box_x + 40 + (i % 2) * 380;
            var opt_y = box_y + 220 + floor(i / 2) * 110;
            
            var hover = (mx >= opt_x && mx <= opt_x + opt_w && my >= opt_y && my <= opt_y + opt_h);
            
            if (hover) {
                draw_set_color(make_color_rgb(40, 60, 80));
                draw_set_alpha(0.9);
            } else {
                draw_set_color(make_color_rgb(15, 20, 25));
                draw_set_alpha(0.7);
            }
            draw_rectangle(opt_x, opt_y, opt_x + opt_w, opt_y + opt_h, false);
            
            draw_set_color(hover ? c_aqua : make_color_rgb(180, 150, 50));
            draw_set_alpha(hover ? 0.9 : 0.5);
            draw_rectangle(opt_x, opt_y, opt_x + opt_w, opt_y + opt_h, true);
            
            draw_set_color(c_white);
            draw_set_alpha(1.0);
            draw_set_halign(fa_center);
            draw_text_ext_transformed(opt_x + opt_w/2, opt_y + opt_h/2, q_data.a[i], 22, 320, 1.0, 1.0, 0);
        }
        
        // Draw Back button
        var back_w = 180;
        var back_h = 45;
        var back_x = box_x + (box_w - back_w) / 2;
        var back_y = box_y + box_h - 65;
        var back_hover = (mx >= back_x && mx <= back_x + back_w && my >= back_y && my <= back_y + back_h);
        
        if (back_hover) {
            draw_set_color(make_color_rgb(80, 80, 80));
            draw_set_alpha(0.9);
        } else {
            draw_set_color(make_color_rgb(40, 40, 40));
            draw_set_alpha(0.75);
        }
        draw_rectangle(back_x, back_y, back_x + back_w, back_y + back_h, false);
        
        draw_set_color(c_white);
        draw_set_alpha(0.8);
        draw_rectangle(back_x, back_y, back_x + back_w, back_y + back_h, true);
        
        draw_set_halign(fa_center);
        draw_text_transformed(back_x + back_w/2, back_y + back_h/2, "QUAY LẠI CƠ BẢN", 1.0, 1.0, 0);
    }
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

// 3. Draw Focused Hero Skills Panel (MOBA Skill HUD)
if (focused_hero != noone && instance_exists(focused_hero)) {
    var p_x = 920;
    var p_y = 10;
    var p_w = 350;
    var p_h = 160;
    
    // Glassmorphic panel
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(p_x, p_y, p_x + p_w, p_y + p_h, false);
    
    draw_set_color(make_color_rgb(180, 150, 50));
    draw_set_alpha(0.9);
    draw_rectangle(p_x - 1, p_y - 1, p_x + p_w + 1, p_y + p_h + 1, true);
    
    // Hero Name and Icon
    draw_set_font(fnt_vietnamese);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    
    draw_set_color(c_yellow);
    draw_text_transformed(p_x + 15, p_y + 22, "★ " + focused_hero.Name, 1.0, 1.0, 0);
    
    // HP Bar of Hero
    draw_set_color(c_dkgray);
    draw_rectangle(p_x + 15, p_y + 40, p_x + p_w - 15, p_y + 50, false);
    
    var hp_pct = focused_hero.CurHp / focused_hero.MaxHp;
    draw_set_color(make_color_rgb(220, 50, 50));
    draw_rectangle(p_x + 15, p_y + 40, p_x + 15 + (p_w - 30) * hp_pct, p_y + 50, false);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text_transformed(p_x + p_w/2, p_y + 45, string(focused_hero.CurHp) + " / " + string(focused_hero.MaxHp), 1.0, 1.0, 0);
    
    // Draw 3 skills
    var skill_names = [];
    var skill_keys = ["PHÍM Q", "PHÍM W", "PHÍM E"];
    if (focused_hero.HeroName == "Phan Đình Giót") {
        skill_names = ["BOM XĂNG", "XUNG PHONG", "Ý CHÍ THÉP"];
    } else {
        skill_names = ["MƯA TÊN", "GIÁ SÚNG", "LÁ CHẮN"];
    }
    
    draw_set_halign(fa_center);
    for (var i = 0; i < 3; i++) {
        var s_x = p_x + 60 + i * 115;
        var s_y = p_y + 98;
        var s_r = 28;
        
        // Draw skill background
        var cd = focused_hero.skill_cooldowns[i];
        var max_cd = focused_hero.skill_max_cooldowns[i];
        
        if (cd <= 0) {
            draw_set_color(make_color_rgb(40, 80, 50)); // Greenish for ready
            draw_set_alpha(0.7);
        } else {
            draw_set_color(c_dkgray);
            draw_set_alpha(0.5);
        }
        draw_circle(s_x, s_y, s_r, false);
        
        // Cooldown radial / wedge overlay
        if (cd > 0) {
            draw_set_color(c_red);
            draw_set_alpha(0.3);
            var cd_pct = cd / max_cd;
            draw_rectangle(s_x - s_r, s_y + s_r - (s_r * 2 * cd_pct), s_x + s_r, s_y + s_r, false);
        }
        
        // Border
        draw_set_color(make_color_rgb(180, 150, 50));
        draw_set_alpha(0.8);
        draw_circle(s_x, s_y, s_r, true);
        
        // Text
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        draw_text_transformed(s_x, s_y - 8, skill_names[i], 1.0, 1.0, 0);
        
        if (cd <= 0) {
            draw_set_color(c_yellow);
            draw_text_transformed(s_x, s_y + 8, skill_keys[i], 1.0, 1.0, 0);
        } else {
            draw_set_color(c_orange);
            draw_text_transformed(s_x, s_y + 8, string(ceil(cd / 60)) + "s", 1.0, 1.0, 0);
        }
    }
    
    // Draw switching instruction
    draw_set_color(c_yellow);
    draw_set_alpha(0.6 + sin(current_time * 0.01) * 0.2);
    draw_set_halign(fa_center);
    draw_text_transformed(p_x + p_w/2, p_y + p_h - 10, "ẤN 'TAB' ĐỂ CHUYỂN ĐỔI ANH HÙNG", 1.0, 1.0, 0);
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
#endregion

#endregion