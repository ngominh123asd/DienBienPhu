/// @description Vẽ Lô cốt và hiệu ứng
event_inherited();

if (CurHp > 0) {
    var CenterX = x + (sprite_width / 2);
    var CenterY = y + (sprite_height / 2);

    if (ShieldActive) {
        // Vẽ vòng khiên bảo vệ
        draw_set_alpha(0.3);
        draw_set_color(c_aqua);
        draw_circle(CenterX, CenterY, 100, false);
        
        // Viền khiên
        draw_set_alpha(0.8);
        draw_circle(CenterX, CenterY, 100, true);
        
        // Reset color
        draw_set_alpha(1);
        draw_set_color(c_white);
    }

    if (DisabledFirepower) {
        // Đánh dấu lỗ châu mai bị lấp
        draw_set_color(c_red);
        draw_circle(CenterX, CenterY - 25, 8, false);
        draw_set_color(c_white);
    }
}
