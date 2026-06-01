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
	draw_text_transformed(map_x + minimap_w/2, map_y + minimap_h/2, "⚠ MẤT TÍN HIỆU ⚠\nRADAR BỊ NHIỄU", 0.65, 0.65, 0);
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
if (question_status[0] == 1 && question_status[1] == 1 && question_status[2] == 1 && question_status[3] == 1) {
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

if (question_status[0] == 1 && question_status[1] == 1 && question_status[2] == 1 && question_status[3] == 1) {
	draw_set_color(make_color_rgb(50, 220, 100));
	draw_text_transformed(sq_btn_x + sq_btn_w/2, sq_btn_y + sq_btn_h/2, "✓ HOÀN THÀNH", 0.6, 0.6, 0);
} else {
	draw_set_color(c_yellow);
	draw_text_transformed(sq_btn_x + sq_btn_w/2, sq_btn_y + sq_btn_h/2, "NHIỆM VỤ PHỤ", 0.6, 0.6, 0);
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
    draw_text_transformed((q_x1 + q_x2)/2, (q_y1 + q_y2)/2, "KHÓA\n(Sidequest)", 0.65, 0.65, 0);
} else if (bomb_cooldown > 0) {
    draw_set_color(c_white);
    draw_text((q_x1 + q_x2)/2, (q_y1 + q_y2)/2, "COOLDOWN\n" + string(ceil(bomb_cooldown / 60)) + "s");
} else {
    draw_set_color(targeting_mode == 1 ? c_yellow : c_white);
    draw_text((q_x1 + q_x2)/2, (q_y1 + q_y2)/2, "KHÔNG KÍCH\nPHÍM Q");
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
    draw_text_transformed((w_x1 + w_x2)/2, (w_y1 + w_y2)/2, "KHÓA\n(Sidequest)", 0.65, 0.65, 0);
} else if (w_cooldown > 0) {
    draw_set_color(c_white);
    draw_text((w_x1 + w_x2)/2, (w_y1 + w_y2)/2, "COOLDOWN\n" + string(ceil(w_cooldown / 60)) + "s");
} else {
    draw_set_color(targeting_mode == 2 ? c_yellow : c_white);
    draw_text((w_x1 + w_x2)/2, (w_y1 + w_y2)/2, "PHÒNG KHÔNG\nPHÍM W");
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
    draw_text_transformed((e_x1 + e_x2)/2, (e_y1 + e_y2)/2, "KHÓA\n(Sidequest)", 0.65, 0.65, 0);
} else if (e_cooldown > 0) {
    draw_set_color(c_white);
    draw_text((e_x1 + e_x2)/2, (e_y1 + e_y2)/2, "COOLDOWN\n" + string(ceil(e_cooldown / 60)) + "s");
} else {
    draw_set_color(targeting_mode == 3 ? c_yellow : c_white);
    draw_text((e_x1 + e_x2)/2, (e_y1 + e_y2)/2, "HỎA TIỄN H6\nPHÍM E");
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
    draw_text_transformed((r_x1 + r_x2)/2, (r_y1 + r_y2)/2, "KHÓA\n(Sidequest)", 0.65, 0.65, 0);
} else if (r_cooldown > 0) {
    draw_set_color(c_white);
    draw_text((r_x1 + r_x2)/2, (r_y1 + r_y2)/2, "COOLDOWN\n" + string(ceil(r_cooldown / 60)) + "s");
} else {
    draw_set_color(targeting_mode == 4 ? c_yellow : c_white);
    draw_text((r_x1 + r_x2)/2, (r_y1 + r_y2)/2, "BỘC PHÁ A1\nPHÍM R");
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
#endregion

#region Draw Active Debuff & Sidequest Dialog Overlay
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
    }
    
    draw_set_color(c_yellow);
    draw_text_transformed(db_x + db_w/2, db_y + 16, db_title + " (" + string(ceil(debuff_timer / 60)) + "s)", 0.65, 0.65, 0);
    draw_set_color(c_white);
    draw_text_transformed(db_x + db_w/2, db_y + 38, db_desc, 0.5, 0.5, 0);
    
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
    
    if (sidequest_current_question == -1) {
        // --- Selection Menu ---
        draw_set_color(c_yellow);
        draw_text_transformed(box_x + box_w/2, box_y + 35, "★ TRUNG TÂM CHỈ HUY - THỬ THÁCH LỊCH SỬ ★", 1.1, 1.1, 0);
        
        draw_set_color(c_white);
        draw_text_transformed(box_x + box_w/2, box_y + 65, "Trả lời đúng các câu hỏi lịch sử Điện Biên Phủ để mở khóa vũ khí chiến lược tương ứng.\nTránh trả lời sai nếu không muốn gánh chịu hiệu ứng bất lợi cực kỳ nghiêm trọng!", 0.65, 0.65, 0);
        
        // 4 Skill buttons
        for (var i = 0; i < 4; i++) {
            var btn_w = 700;
            var btn_h = 65;
            var btn_x = box_x + (box_w - btn_w) / 2;
            var btn_y = box_y + 110 + i * 80;
            
            var hover = (mx >= btn_x && mx <= btn_x + btn_w && my >= btn_y && my <= btn_y + btn_h);
            
            // Draw button background
            if (hover) {
                draw_set_color(make_color_rgb(50, 60, 50));
                draw_set_alpha(0.9);
            } else {
                draw_set_color(make_color_rgb(15, 20, 15));
                draw_set_alpha(0.7);
            }
            draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
            
            // Draw button border
            var border_col = make_color_rgb(180, 150, 50);
            if (question_status[i] == 1) border_col = make_color_rgb(50, 220, 100);
            else if (question_status[i] == 0) border_col = c_red;
            
            draw_set_color(border_col);
            draw_set_alpha(hover ? 0.9 : 0.5);
            draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, true);
            
            // Draw text
            var skill_label = "";
            if (i == 0) skill_label = "Kỹ Năng Q: KHÔNG KÍCH TÁC CHIẾN";
            if (i == 1) skill_label = "Kỹ Năng W: PHÒNG KHÔNG 37MM";
            if (i == 2) skill_label = "Kỹ Năng E: HỎA TIỄN H6 SALVO";
            if (i == 3) skill_label = "Kỹ Năng R: BỘC PHÁ ĐỒI A1 (930KG)";
            
            draw_set_color(c_white);
            draw_set_halign(fa_left);
            draw_text_transformed(btn_x + 25, btn_y + btn_h/2, skill_label, 0.75, 0.75, 0);
            
            // Draw status
            var status_text = "";
            var status_col = c_yellow;
            if (question_status[i] == 1) {
                status_text = "✓ ĐÃ MỞ KHÓA";
                status_col = make_color_rgb(50, 220, 100);
            } else if (question_status[i] == 0) {
                status_text = "✗ THẤT BẠI - BẤT LỢI 15S (Bấm để thử lại)";
                status_col = c_red;
            } else {
                status_text = "○ CHƯA HOÀN THÀNH";
                status_col = c_yellow;
            }
            
            draw_set_color(status_col);
            draw_set_halign(fa_right);
            draw_text_transformed(btn_x + btn_w - 25, btn_y + btn_h/2, status_text, 0.7, 0.7, 0);
        }
        
        // Draw Close button
        var close_w = 180;
        var close_h = 45;
        var close_x = box_x + (box_w - close_w) / 2;
        var close_y = box_y + box_h - 70;
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
        draw_text_transformed(close_x + close_w/2, close_y + close_h/2, "ĐÓNG", 0.8, 0.8, 0);
        
    } else {
        // --- Question Screen ---
        var q_idx = sidequest_current_question;
        var q_data = sidequest_questions[q_idx];
        
        draw_set_color(c_yellow);
        var q_title = "";
        if (q_idx == 0) q_title = "★ THỬ THÁCH MỞ KHÓA: KỸ NĂNG Q ★";
        if (q_idx == 1) q_title = "★ THỬ THÁCH MỞ KHÓA: KỸ NĂNG W ★";
        if (q_idx == 2) q_title = "★ THỬ THÁCH MỞ KHÓA: KỸ NĂNG E ★";
        if (q_idx == 3) q_title = "★ THỬ THÁCH MỞ KHÓA: KỸ NĂNG R ★";
        draw_text_transformed(box_x + box_w/2, box_y + 35, q_title, 1.1, 1.1, 0);
        
        // Draw Question Text with word-wrapping
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text_ext_transformed(box_x + box_w/2, box_y + 115, q_data.q, 25, 720, 0.8, 0.8, 0);
        
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
            draw_text_ext_transformed(opt_x + opt_w/2, opt_y + opt_h/2, q_data.a[i], 18, 320, 0.65, 0.65, 0);
        }
        
        // Draw Back button
        var back_w = 180;
        var back_h = 45;
        var back_x = box_x + (box_w - back_w) / 2;
        var back_y = box_y + box_h - 70;
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
        draw_text_transformed(back_x + back_w/2, back_y + back_h/2, "QUAY LẠI", 0.8, 0.8, 0);
    }
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
#endregion

#endregion

#endregion