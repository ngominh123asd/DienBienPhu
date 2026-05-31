/// @description Draw Spaceship with Immunity Flashing

if (alive) {
    // Hide plane sprite if it has disintegrated in kamikaze collision
    if (variable_instance_exists(id, "kamikaze_exploded") && kamikaze_exploded) {
        // Draw nothing
    } else {
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
