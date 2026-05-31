// Draw the default sprite
draw_self();

// If this is the central dragon boss in Level 2
if (sprite_index == sEn_Dragon) {
    // Count side enemies
    var side_alive = 0;
    with (obj_ke_dich) {
        if (sprite_index != sEn_Dragon) {
            side_alive++;
        }
    }
    
    // Draw pulsing neon shield if side enemies are still alive
    if (side_alive > 0) {
        // Beautiful pulsing effect using a sine wave
        var pulse = sin(current_time * 0.005) * 0.12 + 0.88; // pulses between 0.76 and 1.00
        var base_radius = 130;
        
        // Dynamic flare effect if recently hit
        if (shield_hit_timer > 0) {
            var hit_ratio = shield_hit_timer / 10;
            var hit_radius = base_radius * (1.0 + 0.15 * hit_ratio);
            
            // Draw a bright, high-alpha flare circle
            draw_set_alpha(0.5 * hit_ratio);
            draw_circle_color(x, y, hit_radius, c_white, c_aqua, false);
            
            draw_set_alpha(0.8 * hit_ratio);
            draw_circle_color(x, y, hit_radius, c_aqua, c_blue, true);
        }
        
        // 1. Inner soft glow
        draw_set_alpha(0.18 * pulse);
        draw_circle_color(x, y, base_radius - 5, c_blue, c_aqua, false);
        
        // 2. Middle neon shield wall
        draw_set_alpha(0.3 * pulse);
        draw_circle_color(x, y, base_radius, c_aqua, c_blue, false);
        
        // 3. Thick glowing outer borders
        draw_set_alpha(0.7 * pulse);
        draw_circle_color(x, y, base_radius, c_aqua, c_aqua, true);
        draw_circle_color(x, y, base_radius - 2, c_blue, c_aqua, true);
        draw_circle_color(x, y, base_radius + 2, c_aqua, c_blue, true);
        
        // 4. Subtle micro-arcs / ticks on the shield for tech-details
        draw_set_alpha(0.8 * pulse);
        var segments = 8;
        for (var i = 0; i < segments; i++) {
            var angle = i * (360 / segments) + current_time * 0.02;
            var tx1 = x + lengthdir_x(base_radius - 6, angle);
            var ty1 = y + lengthdir_y(base_radius - 6, angle);
            var tx2 = x + lengthdir_x(base_radius + 6, angle);
            var ty2 = y + lengthdir_y(base_radius + 6, angle);
            draw_line_color(tx1, ty1, tx2, ty2, c_white, c_aqua);
        }
        
        // Reset drawing settings
        draw_set_alpha(1.0);
    }
    
    // Draw red-carpet danger warning zone!
    if (firecarpet_warning_timer > 0) {
        var warning_alpha = (sin(current_time * 0.03) * 0.25 + 0.5) * (firecarpet_warning_timer / 90);
        var col_w = 140;
        
        // Draw transparent red column
        draw_set_alpha(warning_alpha * 0.25);
        draw_rectangle_color(firecarpet_target_x - col_w/2, 0, firecarpet_target_x + col_w/2, room_height, c_red, c_red, c_red, c_red, false);
        
        // Draw thicker red boundary borders
        draw_set_alpha(warning_alpha * 0.6);
        draw_line_width_color(firecarpet_target_x - col_w/2, 0, firecarpet_target_x - col_w/2, room_height, 2, c_red, c_red);
        draw_line_width_color(firecarpet_target_x + col_w/2, 0, firecarpet_target_x + col_w/2, room_height, 2, c_red, c_red);
        
        // Draw flashing warning texts
        draw_set_halign(fa_center);
        draw_text_color(firecarpet_target_x, room_height/2 - 100, "WARNING: TARGET ACQUIRED", c_yellow, c_yellow, c_red, c_red, warning_alpha);
        draw_text_color(firecarpet_target_x, room_height/2 - 80, "!!! DANGER: FIRE CARPET INCOMING !!!", c_white, c_white, c_red, c_red, warning_alpha);
        draw_set_halign(fa_left); // reset
        
        draw_set_alpha(1.0); // reset
    }
    
    // ----------------------------------------------------
    // PREMIUM DRAGON BOSS HEALTH BAR
    // ----------------------------------------------------
    if (life > 0) {
        var bar_w = 600;
        var bar_h = 16;
        var bar_x = (room_width / 2) - (bar_w / 2);
        var bar_y = 45;
        
        var ratio = life / max_life;
        
        // 1. Draw outer black container border
        draw_set_color(c_black);
        draw_rectangle(bar_x - 2, bar_y - 2, bar_x + bar_w + 2, bar_y + bar_h + 2, false);
        
        // 2. Draw red background (lost health)
        draw_set_color(make_color_rgb(80, 20, 20));
        draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
        
        // 3. Draw pulsing bright fire-red/orange health fill
        var pulse_val = floor(200 + sin(current_time * 0.02) * 55);
        var fill_color = make_color_rgb(pulse_val, 100, 10);
        draw_set_color(fill_color);
        draw_rectangle(bar_x, bar_y, bar_x + (bar_w * ratio), bar_y + bar_h, false);
        
        // 4. Draw shiny highlight overlay inside health bar
        draw_set_color(c_white);
        draw_set_alpha(0.15);
        draw_rectangle(bar_x, bar_y, bar_x + (bar_w * ratio), bar_y + (bar_h / 2), false);
        draw_set_alpha(1.0);
        
        // 5. Draw gold border for premium aesthetic
        draw_set_color(c_yellow);
        draw_rectangle(bar_x - 2, bar_y - 2, bar_x + bar_w + 2, bar_y + bar_h + 2, true);
        
        // 6. Draw Boss Name and Phase Label
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_center);
        
        var boss_name = "SIÊU THÚ: HỎA LONG MA THẦN";
        var boss_sub = "BOSS LƯỢT 2 - TIÊU DIỆT ĐỂ NHẬN PHẦN THƯỞNG HỒI 4 TIM!";
        if (side_alive > 0) {
            boss_sub = "CẢNH BÁO: MÀN CHẮN BẢO VỆ ĐANG KÍCH HOẠT - DIỆT TIÊM KÍCH HỘ TỐNG TRƯỚC!";
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
}
