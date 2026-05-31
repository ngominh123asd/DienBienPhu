/// @description Control Air Strike Plane movement and dropping bombs
if (x >= target_x - 150) {
    if (bombs_dropped < max_bombs) {
        bomb_timer++;
        if (bomb_timer >= bomb_interval) {
            // Spawn bomb falling from the plane
            var b = instance_create_layer(x, y, "Instances", obj_air_bomb);
            if (b != noone) {
                b.target_x = x;
                b.target_y = target_y + irandom_range(-25, 25);
                b.vspeed = 7.5; // Fast downward drop
            }
            
            bombs_dropped++;
            bomb_timer = 0;
        }
    }
}

// Destroy once far off-screen to conserve memory
if (x > room_width + 250) {
    instance_destroy();
}

// Generate beautiful exhaust smoke trail behind the aircraft
if (irandom(1) == 0) {
    effect_create_above(ef_smoke, x - 30, y + irandom_range(-5, 5), 0, c_ltgray);
}
