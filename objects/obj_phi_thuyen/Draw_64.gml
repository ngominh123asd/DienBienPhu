/// @description Draw Hearts GUI & Game Over

if (won) {
    // 1. Dark overlay background
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, 1280, 720, false);
    
    // 2. Victory Text
    draw_set_alpha(1.0);
    draw_set_font(fnt_vietnamese);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Glowing gold/yellow victory title with soft shadow
    draw_set_color(c_black);
    draw_text_ext_transformed(640 + 2, 200 + 2, "VICTORY!", 24, 600, 3, 3, 0);
    draw_set_color(c_yellow);
    draw_text_ext_transformed(640, 200, "VICTORY!", 24, 600, 3, 3, 0);
    
    // Tactical historical flavor text
    draw_set_color(c_white);
    var Minutes = floor(time_played / 60 / 60);
    var Seconds = floor(time_played / 60) - (Minutes * 60);
    if (Minutes < 10) { Minutes = "0" + string(Minutes); }
    if (Seconds < 10) { Seconds = "0" + string(Seconds); }
    var PlayedString = string(Minutes) + ":" + string(Seconds);
    
    var desc = "Chúc mừng! Bạn đã xuất sắc tiêu diệt toàn bộ máy bay tiêm kích địch bảo vệ vùng trời chiến dịch Điện Biên Phủ.\n\nThời gian hoàn thành: " + PlayedString;
    if (variable_instance_exists(id, "kamikaze_won") && kamikaze_won) {
        desc = "Chúc mừng chiến sỹ anh dũng! Bạn đã hy sinh thân mình bảo vệ Tổ quốc, lao thẳng phi thuyền vào tiêu diệt Siêu Tàu Sân Bay địch, làm nên chiến công hiển hách lừng lẫy năm châu, chấn động địa cầu tại Điện Biên Phủ!\n\nThời gian hoàn thành: " + PlayedString;
    }
    draw_text_ext_transformed(640, 370, desc, 22, 600, 1.3, 1.3, 0);
    
    // Controls
    draw_set_color(make_color_rgb(180, 190, 185));
    draw_text(640, 520, "Nhấn 'ENTER' để về Menu chọn màn");
    draw_text(640, 560, "Nhấn 'R' để chơi lại màn này");
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
} else if (alive) {
    // Low HP pulsing vignette danger warning overlay
    if (hp <= 2 && !won && (!variable_instance_exists(id, "kamikaze_mode") || !kamikaze_mode)) {
        var danger_pulse = 0.15 + sin(current_time * 0.008) * 0.1;
        draw_set_color(c_red);
        draw_set_alpha(danger_pulse);
        // Draw vignette borders
        draw_rectangle(0, 0, 1280, 20, false); // top
        draw_rectangle(0, 700, 1280, 720, false); // bottom
        draw_rectangle(0, 20, 20, 700, false); // left
        draw_rectangle(1260, 20, 1280, 700, false); // right
        draw_set_alpha(1.0);
    }

    // ----------------------------------------------------
    // KAMIKAZE SACRIFICE OVERLAY GUI
    // ----------------------------------------------------
    if (variable_instance_exists(id, "kamikaze_mode") && kamikaze_mode) {
        // If actively charging, skip drawing the warning text/bars to keep the cinematic view pristine!
        if (variable_instance_exists(id, "kamikaze_charging") && kamikaze_charging) {
            // Only draw hearts in HUD
            var heart_x = 30;
            var heart_y = 30;
            var target_w = 40;
            var scale = target_w / sprite_get_width(sHp);
            var spacing = target_w + 10;
            for (var i = 0; i < max_hp; i++) {
                if (i < hp) {
                    draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_white, 1.0);
                } else {
                    draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_black, 0.4);
                }
            }
            exit; // Exit Draw GUI immediately to keep the rest of the screen blank
        }

        // 1. Transparent dark background overlay (in the middle area)
        draw_set_color(c_black);
        draw_set_alpha(0.6);
        draw_rectangle(0, 110, 1280, 610, false);
        
        // 2. Cinematic Top & Bottom black letterbox bars
        draw_set_color(c_black);
        draw_set_alpha(0.85);
        draw_rectangle(0, 0, 1280, 110, false);
        draw_rectangle(0, 610, 1280, 720, false);
        
        // High-end separating border lines for the letterbox
        draw_set_color(make_color_rgb(180, 20, 20)); // crimson red
        draw_line_width(0, 110, 1280, 110, 3);
        draw_line_width(0, 610, 1280, 610, 3);
        
        // 3. Setup draw parameters for text
        draw_set_alpha(1.0);
        draw_set_font(fnt_vietnamese);
        
        // 4. Draw Danger Warning Alert Box if monologue is fully completed
        if (variable_instance_exists(id, "monologue_completed") && monologue_completed) {
            var pulse_color = make_color_rgb(180 + sin(current_time * 0.015) * 35, 15, 15);
            
            // Glowing background plate
            draw_set_color(pulse_color);
            draw_set_alpha(0.85);
            draw_rectangle(220, 140, 1060, 390, false);
            
            // Double yellow/orange borders
            draw_set_alpha(1.0);
            draw_set_color(c_yellow);
            draw_rectangle(220, 140, 1060, 390, true);
            draw_rectangle(222, 142, 1058, 388, true);
            
            // Alert contents
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            draw_set_color(c_black);
            draw_text_ext_transformed(640 + 2, 185 + 2, "⚠️ CẢNH BÁO: MÁY BAY HẾT SẠCH ĐẠN DƯỢC! ⚠️", 24, 800, 1.4, 1.4, 0);
            draw_set_color(c_yellow);
            draw_text_ext_transformed(640, 185, "⚠️ CẢNH BÁO: MÁY BAY HẾT SẠCH ĐẠN DƯỢC! ⚠️", 24, 800, 1.4, 1.4, 0);
            
            draw_set_color(c_white);
            draw_text_ext_transformed(640, 265, "ẤN 'ENTER' ĐỂ ANH DŨNG HY SINH VÌ TỔ QUỐC,\nLAO THẲNG PHI THUYỀN TIÊU DIỆT SIÊU TÀU SÂN BAY ĐỊCH!", 26, 800, 1.25, 1.25, 0);
            
            draw_set_color(c_lime);
            var pulse_scale = 1.0 + sin(current_time * 0.02) * 0.04;
            draw_text_ext_transformed(640, 345, "[ ĐỘNG CƠ CẢM TỬ ĐÃ SẴN SÀNG - CHỈ CHỜ LỆNH ENTER ]", 24, 800, 0.95 * pulse_scale, 0.95 * pulse_scale, 0);
        } else {
            // Draw a high-tech tactical HUD overlay on the upper middle screen before the climactic sacrifice
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var warning_pulse = 0.6 + abs(sin(current_time * 0.007)) * 0.4;
            draw_set_color(c_black);
            draw_text_ext_transformed(640 + 2, 250 + 2, "► ĐANG TRUYỀN TIN TỪ PHÒNG LÁI ◄", 24, 1100, 1.8, 1.8, 0);
            draw_set_color(make_color_rgb(255, 140, 0)); // orange glow
            draw_set_alpha(warning_pulse);
            draw_text_ext_transformed(640, 250, "► ĐANG TRUYỀN TIN TỪ PHÒNG LÁI ◄", 24, 1100, 1.8, 1.8, 0);
            
            draw_set_alpha(1.0);
            draw_set_color(c_white);
            draw_text_ext_transformed(640, 320, "Nhịp tim phi công ổn định... Sẵn sàng cống hiến vì Tổ quốc...", 24, 1100, 1.0, 1.0, 0);
        }
        
        // 5. Draw the beautiful Radio Dialogue Terminal Box (at the bottom)
        var box_x1 = 120;
        var box_y1 = 430;
        var box_x2 = 1160;
        var box_y2 = 590;
        
        // Background card
        draw_set_color(make_color_rgb(12, 16, 22));
        draw_set_alpha(0.92);
        draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);
        
        // Double glowing boundaries
        draw_set_alpha(1.0);
        draw_set_color(make_color_rgb(160, 30, 30)); // Dark red outer border
        draw_rectangle(box_x1, box_y1, box_x2, box_y2, true);
        draw_set_color(make_color_rgb(220, 190, 80)); // Gold inner border
        draw_rectangle(box_x1 + 2, box_y1 + 2, box_x2 - 2, box_y2 - 2, true);
        
        // LED Indicator (flashing red)
        var led_alpha = 0.4 + abs(sin(current_time * 0.01)) * 0.6;
        draw_set_color(c_red);
        draw_set_alpha(led_alpha);
        draw_circle(box_x1 + 30, box_y1 + 22, 6, false);
        draw_set_alpha(1.0);
        
        // Terminal Signal Header Text
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(255, 90, 90));
        draw_text_transformed(box_x1 + 45, box_y1 + 22, "● TRUYỀN TIN KHẨN CẤP / PHI CÔNG QUYẾT TỬ", 0.85, 0.85, 0);
        
        // Animated Green Soundwave Visualizer
        var wave_x = box_x2 - 100;
        var wave_y = box_y1 + 22;
        for (var w = 0; w < 8; w++) {
            var bar_h = 4 + sin(current_time * 0.02 + w) * 10 + random_range(-2, 2);
            bar_h = clamp(bar_h, 2, 20);
            draw_set_color(c_lime);
            draw_rectangle(wave_x + w * 8, wave_y - bar_h/2, wave_x + w * 8 + 5, wave_y + bar_h/2, false);
        }
        
        // 6. Draw current monologue typewriter string
        var draw_str = string_copy(monologue_texts[monologue_index], 1, floor(monologue_char_count));
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        // Behind Shadow
        draw_set_color(c_black);
        draw_text_ext(box_x1 + 30 + 2, box_y1 + 45 + 2, draw_str, 24, 960);
        // Main front text (soft retro paper white)
        draw_set_color(make_color_rgb(245, 240, 220));
        draw_text_ext(box_x1 + 30, box_y1 + 45, draw_str, 24, 960);
        
        // 7. Advance Interaction Prompt
        var blink = (floor(current_time / 250) % 2 == 0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        
        var current_text = monologue_texts[monologue_index];
        var text_len = string_length(current_text);
        
        if (monologue_char_count < text_len) {
            if (blink) {
                draw_set_color(c_gray);
                draw_text_transformed(box_x2 - 30, box_y2 - 12, "Ấn SPACE để xem nhanh >>", 0.75, 0.75, 0);
            }
        } else {
            if (monologue_index < array_length(monologue_texts) - 1) {
                if (blink) {
                    draw_set_color(c_yellow);
                    draw_text_transformed(box_x2 - 30, box_y2 - 12, "Ấn SPACE hoặc ENTER để tiếp tục ➔", 0.8, 0.8, 0);
                }
            } else {
                if (blink) {
                    draw_set_color(c_orange);
                    draw_text_transformed(box_x2 - 30, box_y2 - 12, "[ Độc thoại hoàn tất - SẴN SÀNG QUYẾT TỬ ]", 0.8, 0.8, 0);
                }
            }
        }
        
        // Reset settings
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        
        // Draw Hearts at top-left
        var heart_x = 30;
        var heart_y = 30;
        var target_w = 40;
        var scale = target_w / sprite_get_width(sHp);
        var spacing = target_w + 10;
        for (var i = 0; i < max_hp; i++) {
            if (i < hp) {
                draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_white, 1.0);
            } else {
                draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_black, 0.4);
            }
        }
        exit; // Bypass other standard drawing
    }

    // Draw wave announcement banner
    if (wave_announcement_timer > 0) {
        var alpha = min(1.0, wave_announcement_timer / 30);
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Transparent dark band across the screen
        draw_set_color(c_black);
        draw_set_alpha(0.6 * alpha);
        draw_rectangle(0, 250, 1280, 430, false);
        
        // Wave title text with soft shadow
        draw_set_alpha(alpha);
        var scale = 1.0 + sin(current_time * 0.015) * 0.04;
        
        var banner_title = "LƯỢT 2: QUYẾT CHIẾN BOSS RỒNG!";
        var banner_sub = "MÀN CHẮN BẢO VỆ ĐÃ KÍCH HOẠT - DIỆT HỘ TỐNG TRƯỚC!";
        var text_color = c_red;
        
        if (level_wave == 3) {
            banner_title = "LƯỢT 3: TÀU SÂN BAY CHIẾN HẠM CUỐI CÙNG!";
            banner_sub = "TIÊU DIỆT TÀU SÂN BAY ĐỊCH BẢO VỆ BẦU TRỜI ĐIỆN BIÊN PHỦ!";
            text_color = make_color_rgb(255, 140, 0); // Orange
        }
        
        draw_set_color(c_black);
        draw_text_ext_transformed(640 + 2, 300 + 2, banner_title, 24, 1100, 2.3 * scale, 2.3 * scale, 0);
        draw_set_color(text_color);
        draw_text_ext_transformed(640, 300, banner_title, 24, 1100, 2.3 * scale, 2.3 * scale, 0);
        
        draw_set_color(c_yellow);
        draw_text_ext_transformed(640, 380, banner_sub, 24, 1200, 1.1, 1.1, 0);
        
        // Reset draw settings
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_valign(fa_top); // default standard
    }

    // ----------------------------------------------------
    // WAVE TRANSITION COUNTDOWN TACTICAL RADIO TRANSMISSION GUI
    // ----------------------------------------------------
    if (variable_instance_exists(id, "wave_countdown") && wave_countdown > 0) {
        draw_set_font(fnt_vietnamese);
        
        // 1. Draw top countdown banner
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var secs = ceil(wave_countdown / 60);
        var pulse_scale = 1.0 + sin(current_time * 0.015) * 0.04;
        
        draw_set_color(c_black);
        draw_text_ext_transformed(640 + 2, 80 + 2, "CHUẨN BỊ CHIẾN ĐẤU LƯỢT " + string(next_wave) + " - ĐANG TRUYỀN TIN VÔ TUYẾN...", 24, 1100, 1.2 * pulse_scale, 1.2 * pulse_scale, 0);
        draw_set_color(c_yellow);
        draw_text_ext_transformed(640, 80, "CHUẨN BỊ CHIẾN ĐẤU LƯỢT " + string(next_wave) + " - ĐANG TRUYỀN TIN VÔ TUYẾN...", 24, 1100, 1.2 * pulse_scale, 1.2 * pulse_scale, 0);
        
        // 2. Select military radio dialogue text based on wave_dialog_index
        var wave_msg = "";
        var sender_title = "● TRUYỀN TIN MẶT ĐẤT / CHỈ HUY TRUNG ĐOÀN";
        var is_pilot = false;
        
        var d_index = 0;
        if (variable_instance_exists(id, "wave_dialog_index") && wave_dialog_index >= 0) {
            d_index = wave_dialog_index;
        }
        
        if (next_wave == 2) {
            if (d_index == 0) {
                wave_msg = "Báo cáo Chỉ huy: Đợt tiêm kích phòng thủ vòng ngoài của địch đã bị phi đội ta xóa sổ hoàn toàn!";
                sender_title = "● PHI CÔNG CHÍNH / KHÔNG QUÂN ĐIỆN BIÊN";
                is_pilot = true;
            } else {
                wave_msg = "Chỉ huy: Làm tốt lắm chiến sỹ! Cảnh giác, phi đội tiêm kích chủ lực cận vệ của địch đang cất cánh đánh chặn!";
                sender_title = "● BỘ CHỈ HUY MẶT ĐẤT / TRUNG ĐOÀN TRƯỞNG";
                is_pilot = false;
            }
        } else if (next_wave == 3) {
            if (d_index == 0) {
                wave_msg = "Chỉ huy: Toàn đội chú ý! Siêu chiến hạm bay Tàu Sân Bay cuối cùng của địch đã lọt vào bầu trời Điện Biên Phủ!";
                sender_title = "● BỘ CHỈ HUY MẶT ĐẤT / TRUNG ĐOÀN TRƯỞNG";
                is_pilot = false;
            } else {
                wave_msg = "Chỉ huy: Trận chiến sinh tử quyết định vận mệnh chiến dịch bắt đầu! Hãy chiến đấu dũng cảm, quyết giữ vững bầu trời!";
                sender_title = "● BỘ CHỈ HUY MẶT ĐẤT / TRUNG ĐOÀN TRƯỞNG";
                is_pilot = false;
            }
        }
        
        // 3. Draw Tactical Comms Box (at the bottom)
        var box_x1 = 120;
        var box_y1 = 430;
        var box_x2 = 1160;
        var box_y2 = 590;
        
        // Background card
        draw_set_color(make_color_rgb(12, 16, 22));
        draw_set_alpha(0.92);
        draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);
        
        // Double army green boundaries
        draw_set_alpha(1.0);
        draw_set_color(make_color_rgb(20, 120, 50)); // Army green outer border
        draw_rectangle(box_x1, box_y1, box_x2, box_y2, true);
        draw_set_color(make_color_rgb(220, 190, 80)); // Gold inner border
        draw_rectangle(box_x1 + 2, box_y1 + 2, box_x2 - 2, box_y2 - 2, true);
        
        // LED Indicator (flashing green)
        var led_alpha = 0.4 + abs(sin(current_time * 0.01)) * 0.6;
        draw_set_color(c_lime);
        draw_set_alpha(led_alpha);
        draw_circle(box_x1 + 30, box_y1 + 22, 6, false);
        draw_set_alpha(1.0);
        
        // Terminal Signal Header Text
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(is_pilot ? make_color_rgb(255, 180, 80) : make_color_rgb(100, 255, 100));
        draw_text_transformed(box_x1 + 45, box_y1 + 22, sender_title, 0.85, 0.85, 0);
        
        // Animated soundwave visualizer
        var wave_x = box_x2 - 100;
        var wave_y = box_y1 + 22;
        for (var w = 0; w < 8; w++) {
            var bar_h = 4 + sin(current_time * 0.02 + w) * 10 + random_range(-2, 2);
            bar_h = clamp(bar_h, 2, 20);
            draw_set_color(c_lime);
            draw_rectangle(wave_x + w * 8, wave_y - bar_h/2, wave_x + w * 8 + 5, wave_y + bar_h/2, false);
        }
        
        // 4. Draw wave dialogue message
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        // Shadow
        draw_set_color(c_black);
        draw_text_ext(box_x1 + 30 + 2, box_y1 + 45 + 2, wave_msg, 24, 960);
        // Main front text (soft paper white)
        draw_set_color(make_color_rgb(245, 240, 220));
        draw_text_ext(box_x1 + 30, box_y1 + 45, wave_msg, 24, 960);
        
        // 5. Transmission status blinking prompt (Interactive advance hint)
        var blink = (floor(current_time / 250) % 2 == 0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        if (blink) {
            draw_set_color(c_yellow);
            draw_text_transformed(box_x2 - 30, box_y2 - 12, "Ấn SPACE hoặc ENTER để tiếp tục ➔", 0.8, 0.8, 0);
        }
        
        // Reset settings
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_valign(fa_top);
        draw_set_halign(fa_left);
    }

    // Draw 5 Hearts at top-left
    var heart_x = 30;
    var heart_y = 30;
    var target_w = 40; // Target width in pixels
    var scale = target_w / sprite_get_width(sHp);
    var spacing = target_w + 10; // Spacing includes width and gap
    
    for (var i = 0; i < max_hp; i++) {
        if (i < hp) {
            // Draw full heart
            draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_white, 1.0);
        } else {
            // Draw empty heart (silhouette)
            draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_black, 0.4);
        }
    }
} else {
    // 1. Dark overlay background
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, 1280, 720, false);
    
    // 2. Game Over Text
    draw_set_alpha(1.0);
    draw_set_font(global.Font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Red title with soft shadow
    draw_set_color(c_black);
    draw_text(640 + 2, 300 + 2, "GAME OVER");
    draw_set_color(make_color_rgb(240, 60, 60));
    draw_text(640, 300, "GAME OVER");
    
    // Instructions
    draw_set_color(c_white);
    draw_text(640, 370, "Nhấn 'R' để chơi lại");
    
    draw_set_color(make_color_rgb(180, 190, 185));
    draw_text(640, 410, "Nhấn 'ESC' để quay lại Menu chọn màn");
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

// 8. Draw Cinematic Crash Flash Overlay on top of everything
if (variable_instance_exists(id, "crash_flash") && crash_flash > 0) {
    draw_set_color(c_white);
    draw_set_alpha(crash_flash / 35);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
