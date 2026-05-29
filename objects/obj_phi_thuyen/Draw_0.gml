/// @description Draw Spaceship with Immunity Flashing

if (alive) {
    if (is_immune) {
        // Blink/flash every 100ms
        if (floor(current_time / 100) % 2 == 0) {
            draw_self();
        }
    } else {
        draw_self();
    }
}
