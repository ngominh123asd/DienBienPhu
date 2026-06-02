/// @description Draw Spaceship with Immunity Flashing

if (variable_instance_exists(id, "state") && state == "shop") exit;

if (alive) {
    // Hide plane sprite if it has disintegrated in kamikaze collision
    if (variable_instance_exists(id, "kamikaze_exploded") && kamikaze_exploded) {
        // Draw nothing
    } else {
        // 1. Draw rocket exhaust engine trails (underneath the plane)
        var flame_scale = 0.85 + sin(current_time * 0.05) * 0.15;
        gpu_set_blendmode(bm_add);
        
        if (variable_instance_exists(id, "kamikaze_charging") && kamikaze_charging) {
            // ROARING COMET FIRE TRAIL during charge
            var fire_size = 1.8 + random_range(-0.25, 0.25);
            for (var i = 5; i > 0; i--) {
                var size_mult = (1.0 - i * 0.16);
                draw_sprite_ext(sEn_DragonFire, 0, trail_x[i], trail_y[i] + 15, fire_size * size_mult, fire_size * size_mult, 180, c_orange, 0.8 - i * 0.13);
                draw_sprite_ext(sEn_DragonFire, 0, trail_x[i], trail_y[i] + 15, fire_size * size_mult * 0.6, fire_size * size_mult * 0.6, 180, c_yellow, 0.9 - i * 0.15);
            }
        } else {
            // STANDARD ENGINE GLOW & FLAME
            draw_sprite_ext(sEn_DragonFire, 0, x, y + 25, 0.6 * flame_scale, 0.6 * flame_scale, 180, c_yellow, 0.85);
            for (var i = 3; i > 0; i--) {
                var size_mult = (1.0 - i * 0.25);
                draw_sprite_ext(sEn_DragonFire, 0, trail_x[i], trail_y[i] + 25, 0.45 * size_mult, 0.45 * size_mult, 180, c_orange, 0.6 - i * 0.18);
            }
        }
        
        gpu_set_blendmode(bm_normal);
        
        // 2. Draw plane sprite with flashing if immune
        if (is_immune) {
            // Blink/flash every 100ms
            if (floor(current_time / 100) % 2 == 0) {
                draw_self();
            }
        } else {
            draw_self();
        }
    }
}
