/// @description Step Control

if (won) {
    speed = 0;
    
    // Victory keys
    if (keyboard_check_pressed(vk_enter)) {
        room_goto(rmTitle);
    }
    if (keyboard_check_pressed(ord("R"))) {
        room_restart();
    }
    exit;
}

if (!alive) {
    speed = 0;
    
    // Game Over keys
    if (keyboard_check_pressed(ord("R"))) {
        room_restart();
    }
    if (keyboard_check_pressed(vk_escape)) {
        room_goto(rmTitle);
    }
    exit;
}

// ----------------------------------------------------
// KAMIKAZE SACRIFICE CONTROL
// ----------------------------------------------------
if (variable_instance_exists(id, "kamikaze_mode") && kamikaze_mode) {
    speed = 0;
    
    // 1. One-time screen cleanup of projectiles when cinematic triggers
    if (variable_instance_exists(id, "kamikaze_cleaned") && !kamikaze_cleaned) {
        kamizer_cleaned = true; // wait, let's keep it robust
        kamikaze_cleaned = true;
        with (obj_lazer) { instance_destroy(); }
        with (obj_lazer_ke_dich) { instance_destroy(); }
        with (obj_missile_ke_dich) { instance_destroy(); }
    }
    
    // Keep inside screen boundaries
    x = clamp(x, 40, room_width - 40);
    y = clamp(y, 100, room_height - 60);
    
    if (variable_instance_exists(id, "kamikaze_charging") && kamikaze_charging) {
        y -= 3; // Slow, dramatic vertical charge (buffed down from 12 for high emotional weight)
        image_angle = 180; // Keep plane pointing straight UP
        
        // Find carrier boss
        var boss = instance_nearest(x, y, obj_tau_san_bay);
        if (instance_exists(boss)) {
            // 2. AUTOMATIC CINEMATIC ALIGNMENT (Slide horizontally to hit boss dead center)
            x += (boss.x - x) * 0.15;
            
            if (distance_to_object(boss) < 70 || y <= boss.y + 130) {
                // MASSIVE COLLISION!
                audio_play_sound(sndDragonfireHit, 10, 0);
                
                // Hide player's plane immediately (disintegrated!)
                kamikaze_exploded = true;
                
                // Chain 25 massive explosions around the collision spot
                for (var i = 0; i < 25; i++) {
                    var ex = boss.x + random_range(-200, 200);
                    var ey = boss.y + random_range(-200, 200);
                    instance_create_layer(ex, ey, "Instances", oFx_DeadPlayer);
                }
                
                // Destroy the carrier boss
                with (boss) {
                    instance_destroy();
                }
                
                // Trigger cinematic victory
                won = true;
                kamikaze_won = true;
                kamikaze_mode = false;
                kamikaze_charging = false;
            }
        } else {
            // Fallback if boss was already destroyed somehow
            won = true;
        }
    } else {
        // Wait for player to press Enter to initiate sacrifice
        if (keyboard_check_pressed(vk_enter)) {
            kamikaze_charging = true;
            audio_play_sound(sndConvert, 10, 0); // Play massive windup/siren sound
        }
    }
    exit; // Bypass normal flight/combat control
}

// Increment timer while active
if (alive && !won) {
    time_played += 1;
    
    if (wave_announcement_timer > 0) {
        wave_announcement_timer -= 1;
    }
    
    // Decrement wave transition countdown
    if (wave_countdown > 0) {
        wave_countdown -= 1;
        if (wave_countdown == 0) {
            // Transition is complete! Actually spawn the next wave!
            level_wave = next_wave;
            wave_announcement_timer = (level_wave == 2) ? 150 : 180;
            
            if (level_wave == 2) {
                // Spawn Turn 2 enemies (middle boss, 2 side normal planes)
                instance_create_depth(128, 160, depth, obj_ke_dich);
                instance_create_depth(416, 160, depth, obj_ke_dich);
                instance_create_depth(736, 160, depth, obj_ke_dich);
            } else if (level_wave == 3) {
                // Spawn Turn 3 Giant Carrier Boss at top center
                instance_create_depth(room_width / 2, 120, depth, obj_tau_san_bay);
            }
            
            audio_play_sound(sndLevelUp, 10, 0);
            wave_countdown = -1; // reset countdown state
        }
    }
    
    // Check if we need to start a countdown to the next wave
    if (instance_number(obj_ke_dich) == 0 && instance_number(obj_tau_san_bay) == 0 && wave_countdown == -1) {
        if (level_wave == 1) {
            wave_countdown = 300; // 5 seconds countdown (300 frames at 60fps)
            next_wave = 2;
        } else if (level_wave == 2) {
            wave_countdown = 300; // 5 seconds countdown (300 frames at 60fps)
            next_wave = 3;
        } else if (level_wave == 3) {
            // Victory if all waves cleared
            won = true;
        }
    }
}

// Vertical movement
if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
    y -= 7; // standard speed is 7 (buffed from 5)
}
else if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
    y += 7; // standard speed is 7 (buffed from 5)
}

// Keep inside screen boundaries
x = clamp(x, 40, room_width - 40);
y = clamp(y, 100, room_height - 60);

// ----------------------------------------------------
// AUTOFIRE WEAPON CONTROL (Hỗ trợ giữ phím Bắn liên tục)
// ----------------------------------------------------
if (shoot_cooldown > 0) {
    shoot_cooldown -= 1;
}

if (keyboard_check(vk_space) && shoot_cooldown <= 0) {
    shoot_cooldown = 10; // Firing rate: every 10 frames (6 rounds/sec)
    event_perform(ev_keypress, vk_space); // programmatically trigger Space keypress event
}