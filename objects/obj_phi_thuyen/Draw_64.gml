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

        // 1. Transparent red/black warning background
        draw_set_color(c_black);
        draw_set_alpha(0.65);
        draw_rectangle(0, 0, 1280, 720, false);
        
        // 2. High-hazard alert container bar
        draw_set_color(make_color_rgb(180, 0, 0));
        draw_set_alpha(0.85);
        draw_rectangle(0, 200, 1280, 520, false);
        
        // 3. Alarm pulsing title
        draw_set_alpha(1.0);
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        var pulse = 1.0 + sin(current_time * 0.015) * 0.06;
        
        // Alarm title shadow and text
        draw_set_color(c_black);
        draw_text_ext_transformed(640 + 3, 260 + 3, "CẢNH BÁO: MÁY BAY QUÂN TA ĐÃ HẾT SẠCH ĐẠN!", 24, 1100, 2.0 * pulse, 2.0 * pulse, 0);
        draw_set_color(c_yellow);
        draw_text_ext_transformed(640, 260, "CẢNH BÁO: MÁY BAY QUÂN TA ĐÃ HẾT SẠCH ĐẠN!", 24, 1100, 2.0 * pulse, 2.0 * pulse, 0);
        
        // Sacrifice command
        draw_set_color(c_white);
        draw_text_ext_transformed(640, 360, "ẤN 'ENTER' ĐỂ ANH DŨNG HY SINH VÌ TỔ QUỐC,\nLAO THẲNG VÀO TIÊU DIỆT TÀU SÂN BAY ĐỊCH!", 28, 1100, 1.25, 1.25, 0);
        
        if (variable_instance_exists(id, "kamikaze_charging") && kamikaze_charging) {
            draw_set_color(c_lime);
            draw_text_ext_transformed(640, 460, "ĐANG LAO VÀO MỤC TIÊU... ĐỒNG QUY VU TẬN...!!!", 24, 1100, 1.3, 1.3, 0);
        } else {
            draw_set_color(c_orange);
            draw_text_ext_transformed(640, 460, "[ BẤT TỬ - PHI CÔNG ĐÃ SẴN SÀNG, CHỈ CHỜ BẠN ẤN ENTER ĐỂ CẤT CÁNH CÚ ĐÂM QUYẾT ĐỊNH ]", 24, 1100, 0.9, 0.9, 0);
        }
        
        // Reset settings
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        
        // Draw 5 Hearts at top-left even during banner
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
    // WAVE TRANSITION COUNTDOWN GUI
    // ----------------------------------------------------
    if (variable_instance_exists(id, "wave_countdown") && wave_countdown > 0) {
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        var secs = ceil(wave_countdown / 60);
        var scale = 1.0 + sin(current_time * 0.015) * 0.05;
        
        // Semi-transparent dark background card
        draw_set_color(c_black);
        draw_set_alpha(0.65);
        draw_rectangle(340, 260, 940, 460, false);
        
        // Gold card border
        draw_set_color(c_yellow);
        draw_rectangle(340, 260, 940, 460, true);
        
        // Preparation Title
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_text_transformed(640, 310, "CHUẨN BỊ CHIẾN ĐẤU LƯỢT " + string(next_wave), 1.2, 1.2, 0);
        
        // Countdown text
        draw_set_color(c_yellow);
        draw_text_transformed(640, 380, "LƯỢT TIẾP THEO SAU: " + string(secs) + " GIÂY", scale, scale, 0);
        
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
