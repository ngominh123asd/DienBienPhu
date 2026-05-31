/// @description AI Behavior & Multi-phase Combat Controls

// Check if player exists
if (!instance_exists(obj_phi_thuyen)) {
    hspeed = 0;
    exit;
}

// Stop if game is won or player is dead
if (obj_phi_thuyen.won || !obj_phi_thuyen.alive) {
    hspeed = 0;
    exit;
}

// ----------------------------------------------------
// CINEMATIC KAMIKAZE TRIGGER
// ----------------------------------------------------
if (life <= 2) {
    hspeed = 0;
    vspeed = 0;
    
    // Activate Kamikaze cinematic state on player plane
    if (variable_instance_exists(obj_phi_thuyen, "kamikaze_mode")) {
        obj_phi_thuyen.kamikaze_mode = true;
    }
    
    // Stop all attacks
    exit;
}

// Lower flashing timer
if (shield_hit_timer > 0) {
    shield_hit_timer -= 1;
}

// ----------------------------------------------------
// MULTI-PHASE MOVEMENT
// ----------------------------------------------------
// Boundary check (boss is 300px wide, so keep it centered)
if (x <= 160) {
    hspeed = abs(hspeed);
}
if (x >= room_width - 160) {
    hspeed = -abs(hspeed);
}

// Phase definition
if (life > 50) {
    phase = 1;
    // Set standard Phase 1 speed
    if (abs(hspeed) != 2.0) {
        hspeed = sign(hspeed) * 2.0;
    }
} else {
    phase = 2;
    // Faster, erratic movement in Phase 2
    if (abs(hspeed) != 3.5) {
        hspeed = sign(hspeed) * 3.5;
    }
}

// ----------------------------------------------------
// PHASE 1: CARRIER COMBAT (Plane Spawns & Lasers)
// ----------------------------------------------------
if (phase == 1) {
    // 1. Spawning escort fighter jets from decks
    spawn_cooldown -= 1;
    if (spawn_cooldown <= 0) {
        spawn_cooldown = 240; // 4 seconds
        
        // Spawn 2 flanking escorts
        var e1 = instance_create_depth(x - 90, y + 20, depth - 1, obj_ke_dich);
        if (instance_exists(e1)) {
            e1.hspeed = -3; // flies left initially
        }
        var e2 = instance_create_depth(x + 90, y + 20, depth - 1, obj_ke_dich);
        if (instance_exists(e2)) {
            e2.hspeed = 3;  // flies right initially
        }
        
        // Play launch sound
        audio_play_sound(sndShootFireball, 10, 0);
    }
    
    // 2. 3-way normal laser spread
    shoot_cooldown -= 1;
    if (shoot_cooldown <= 0) {
        shoot_cooldown = 60; // 1 second
        
        var dirs = [255, 270, 285];
        for (var i = 0; i < 3; i++) {
            var b = instance_create_depth(x, y + 40, depth - 1, obj_lazer_ke_dich);
            if (instance_exists(b)) {
                b.speed = 4.0;
                b.direction = dirs[i];
                b.image_angle = dirs[i] - 90;
            }
        }
        audio_play_sound(sndShootArrow, 8, 0);
    }
}

// ----------------------------------------------------
// PHASE 2: BATTLESHIP COMBAT (Carpet Fire & Homing Missiles)
// ----------------------------------------------------
if (phase == 2) {
    // 1. Hyper 5-way laser spray
    shoot_cooldown -= 1;
    if (shoot_cooldown <= 0) {
        shoot_cooldown = 40; // 0.66 seconds
        
        var dirs = [240, 255, 270, 285, 300];
        for (var i = 0; i < 5; i++) {
            var b = instance_create_depth(x, y + 40, depth - 1, obj_lazer_ke_dich);
            if (instance_exists(b)) {
                b.speed = 5.0;
                b.direction = dirs[i];
                b.image_angle = dirs[i] - 90;
                b.image_blend = c_orange; // visual fire enhancement
            }
        }
        audio_play_sound(sndShootArrow, 8, 0);
    }
    
    // 2. Double homing missile launch
    missile_cooldown -= 1;
    if (missile_cooldown <= 0) {
        missile_cooldown = 110; // 1.8 seconds
        
        var m1 = instance_create_depth(x - 50, y + 20, depth - 1, obj_missile_ke_dich);
        if (instance_exists(m1)) {
            m1.speed = 3.8;
            m1.direction = 250;
        }
        var m2 = instance_create_depth(x + 50, y + 20, depth - 1, obj_missile_ke_dich);
        if (instance_exists(m2)) {
            m2.speed = 3.8;
            m2.direction = 290;
        }
        audio_play_sound(sndShootFireball, 9, 0);
    }
    
    // 3. Fire Carpet column blast (Dragon skill adapted)
    carpet_cooldown -= 1;
    if (carpet_cooldown <= 0 && carpet_warning <= 0) {
        carpet_warning = 75; // 1.25 seconds warning
        carpet_target_x = obj_phi_thuyen.x;
        
        audio_play_sound(sndShootFireball, 10, 0);
    }
    
    if (carpet_warning > 0) {
        carpet_warning -= 1;
        if (carpet_warning == 0) {
            carpet_cooldown = 220; // 3.6 seconds delay before next carpet blast
            audio_play_sound(sndDragonfire, 10, 0);
            
            for (var i = 0; i < 8; i++) {
                var bx = carpet_target_x + random_range(-80, 80);
                var by = y + 40 - random_range(0, 120);
                
                var f = instance_create_depth(bx, by, depth - 1, obj_lazer_ke_dich);
                if (instance_exists(f)) {
                    f.speed = 7.0;
                    f.direction = 270; // straight down
                    f.image_blend = c_red;
                    f.image_xscale = 1.6;
                    f.image_yscale = 1.6;
                }
            }
        }
    }
}
