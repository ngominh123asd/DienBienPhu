/// @description Move back and forth

// Turn around when reaching screen boundaries
if (x <= 40) {
    hspeed = abs(hspeed); // Move right
}
if (x >= room_width - 40) {
    hspeed = -abs(hspeed); // Move left
}

// Flip sprite to face movement direction if it is the dragon
if (sprite_index == sEn_Dragon) {
    if (hspeed > 0) {
        image_xscale = -my_scale; // Face right
    } else {
        image_xscale = my_scale;  // Face left
    }
    
    // 1. Homing Fireball Missile Skill (Every 3 seconds / 180 frames)
    missile_cooldown -= 1;
    if (missile_cooldown <= 0) {
        missile_cooldown = 180; // Reset
        
        // Spawn homing fireball missile
        var m = instance_create_depth(x, y + 30, depth - 1, obj_missile_ke_dich);
        if (instance_exists(m)) {
            m.speed = 3.5;
            m.direction = 270; // Start heading down
        }
    }
    
    // 2. 3-way Spread Lasers Skill (Every 2 seconds / 120 frames)
    spread_cooldown -= 1;
    if (spread_cooldown <= 0) {
        spread_cooldown = 120; // Reset
        
        // Shoot 3 lasers spread across down-left, straight-down, and down-right directions
        var dirs = [250, 270, 290];
        for (var i = 0; i < 3; i++) {
            var b = instance_create_depth(x, y + 30, depth - 1, obj_lazer_ke_dich);
            if (instance_exists(b)) {
                b.speed = 4.5;
                b.direction = dirs[i];
                b.image_angle = dirs[i] - 90; // Align laser sprite with direction
            }
        }
    }
}
