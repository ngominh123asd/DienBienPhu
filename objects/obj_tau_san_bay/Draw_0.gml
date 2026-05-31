/// @description Draw Boss Sprite & Premium HUD Health Bar

// 1. Draw Carrier Sprite pointing DOWN (180 degrees)
var blend = c_white;
if (shield_hit_timer > 0) {
    blend = c_red; // Flash red when hit
}

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 180, blend, image_alpha);

// 2. Draw Fire Carpet warning indicator on Phase 2
if (phase == 2 && carpet_warning > 0) {
    draw_set_color(c_red);
    draw_set_alpha(0.15 + sin(current_time * 0.05) * 0.05);
    // Draw a thick warning column down the screen
    draw_rectangle(carpet_target_x - 80, y + 40, carpet_target_x + 80, room_height, false);
    
    // Draw warning borders
    draw_set_alpha(0.4);
    draw_line_width(carpet_target_x - 80, y + 40, carpet_target_x - 80, room_height, 2);
    draw_line_width(carpet_target_x + 80, y + 40, carpet_target_x + 80, room_height, 2);
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

// ----------------------------------------------------
// PREMIUM BOSS HEALTH BAR
// ----------------------------------------------------
if (life > 0) {
    var bar_w = 600;
    var bar_h = 16;
    var bar_x = (room_width / 2) - (bar_w / 2);
    var bar_y = 45;
    
    // Calculate health ratio
    var ratio = life / max_life;
    
    // 1. Draw outer black container border
    draw_set_color(c_black);
    draw_rectangle(bar_x - 2, bar_y - 2, bar_x + bar_w + 2, bar_y + bar_h + 2, false);
    
    // 2. Draw red background (lost health)
    draw_set_color(make_color_rgb(80, 20, 20));
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    
    // 3. Draw pulsing bright health fill (current health)
    var fill_color = make_color_rgb(46, 204, 113); // Phase 1: Sleek Emerald Green (Stable armor)
    if (phase == 2) {
        // Phase 2: Pulsing Fiery Lava Red (Hull breach / Dangerous fire hazard)
        var pulse_val = floor(30 + sin(current_time * 0.03) * 30);
        fill_color = make_color_rgb(255, pulse_val, 0);
    }
    draw_set_color(fill_color);
    draw_rectangle(bar_x, bar_y, bar_x + (bar_w * ratio), bar_y + bar_h, false);
    
    // 4. Draw vertical tick marker at exactly 50% (Phase 2 transition threshold)
    draw_set_color(c_yellow);
    draw_line_width(bar_x + bar_w / 2, bar_y - 2, bar_x + bar_w / 2, bar_y + bar_h + 2, 2);
    draw_set_color(c_white);
    draw_circle(bar_x + bar_w / 2, bar_y - 2, 2, false);
    draw_circle(bar_x + bar_w / 2, bar_y + bar_h + 2, 2, false);
    
    // 5. Draw shiny highlight overlay inside health bar
    draw_set_color(c_white);
    draw_set_alpha(0.15);
    draw_rectangle(bar_x, bar_y, bar_x + (bar_w * ratio), bar_y + (bar_h / 2), false);
    draw_set_alpha(1.0);
    
    // 6. Draw gold border for premium aesthetic
    draw_set_color(c_yellow);
    draw_rectangle(bar_x - 2, bar_y - 2, bar_x + bar_w + 2, bar_y + bar_h + 2, true);
    
    // 6. Draw Boss Name and Phase Label
    draw_set_font(fnt_vietnamese);
    draw_set_halign(fa_center);
    
    var boss_name = "SIÊU BẢO HẠM TÀU SÂN BAY CHIẾN CHIẾN DIỄN BÀN";
    var boss_sub = "PHASE 1: DIỆT TIÊM KÍCH HỘ TỐNG";
    if (phase == 2) {
        boss_name = "SIÊU CHIẾN HẠM B-52: KÍCH HOẠT HỎA LỰC HỦY DIỆT";
        boss_sub = "PHASE 2: TRÁNH BÃI LỬA KHẨN CẤP!";
    }
    
    // Draw shadowed text
    draw_set_color(c_black);
    draw_text_transformed(room_width / 2 + 1, bar_y - 30 + 1, boss_name, 0.9, 0.9, 0);
    draw_set_color(c_white);
    draw_text_transformed(room_width / 2, bar_y - 30, boss_name, 0.9, 0.9, 0);
    
    draw_set_color(c_black);
    draw_text_transformed(room_width / 2 + 1, bar_y + bar_h + 8 + 1, boss_sub, 0.7, 0.7, 0);
    draw_set_color(c_yellow);
    draw_text_transformed(room_width / 2, bar_y + bar_h + 8, boss_sub, 0.7, 0.7, 0);
    
    // Reset standard alignments
    draw_set_halign(fa_left);
}
