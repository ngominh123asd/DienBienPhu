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
    draw_text_ext_transformed(640, 370, desc, 24, 450, 1.5, 1.5, 0);
    
    // Controls
    draw_set_color(make_color_rgb(180, 190, 185));
    draw_text(640, 520, "Nhấn 'ENTER' để về Menu chọn màn");
    draw_text(640, 560, "Nhấn 'R' để chơi lại màn này");
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
} else if (alive) {
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
