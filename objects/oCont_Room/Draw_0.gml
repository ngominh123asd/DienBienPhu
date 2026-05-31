/// @description Draw Mass select & Dien Bien Phu Targets

if mouse_check_button(mb_left) && !targeting_active {
	
	draw_set_color(c_white);
	draw_rectangle(X1,Y1,X2,Y2,1)
	draw_set_alpha(.25);
	draw_rectangle(X1,Y1,X2,Y2,0)
	draw_set_alpha(1);
}

// 1. Draw pulsing target reticle based on active targeting_mode
if (targeting_active && targeting_mode > 0) {
    var pulse = 0.5 + sin(current_time * 0.008) * 0.25;
    
    var col = c_red;
    var rad = 140;
    var label = "CHỈ ĐỊNH KHÔNG KÍCH (Q)";
    
    if (targeting_mode == 1) {
        col = c_red;
        rad = 140;
        label = "CHỈ ĐỊNH KHÔNG KÍCH (Q)";
    } else if (targeting_mode == 2) {
        col = c_aqua;
        rad = 90;
        label = "DỰNG LÔ CỐT CHIẾN HÀO (W)";
    } else if (targeting_mode == 3) {
        col = c_lime;
        rad = 130;
        label = "HẠ TRẠI HUẤN LUYỆN (E)";
    } else if (targeting_mode == 4) {
        col = make_color_rgb(180, 0, 200); // Purple/magenta
        rad = 200;
        label = "HẠ BỆ CAO XẠ 37MM (R)";
    }
    
    draw_set_color(col);
    draw_set_alpha(0.18 + pulse * 0.05);
    draw_circle(mouse_x, mouse_y, rad, false);
    
    draw_set_alpha(pulse + 0.35);
    draw_circle(mouse_x, mouse_y, rad, true);
    draw_circle(mouse_x, mouse_y, rad - 2, true);
    
    // Draw crosshair lines inside the reticle
    draw_line_width(mouse_x - 20, mouse_y, mouse_x + 20, mouse_y, 2);
    draw_line_width(mouse_x, mouse_y - 20, mouse_x, mouse_y + 20, 2);
    
    draw_set_font(fnt_vietnamese);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_color(c_black);
    draw_text_transformed(mouse_x + 1, mouse_y - (rad + 24), label, 0.75, 0.75, 0);
    draw_set_color(col);
    draw_text_transformed(mouse_x, mouse_y - (rad + 25), label, 0.75, 0.75, 0);
}

// Reset draw settings
draw_set_alpha(1.0);
draw_set_color(c_white);