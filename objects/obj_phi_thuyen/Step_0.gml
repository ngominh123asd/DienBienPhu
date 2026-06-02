/// @description Step Control

// ----------------------------------------------------
// CAMERA SCREEN SHAKE DECAY & APPLICATION (Runs under all states)
// ----------------------------------------------------
if (screen_shake > 0) {
    screen_shake -= 0.8; // decay
    if (screen_shake < 0) screen_shake = 0;
    
    if (!view_enabled) {
        view_enabled = true;
        view_visible[0] = true;
        camera_set_view_size(view_camera[0], 800, 600); // Lock view size to 800x600 to prevent zoom issues!
    }
    
    var shake_x = random_range(-screen_shake, screen_shake);
    var shake_y = random_range(-screen_shake, screen_shake);
    camera_set_view_pos(view_camera[0], shake_x, shake_y);
} else {
    if (view_enabled) {
        camera_set_view_pos(view_camera[0], 0, 0);
    }
}

// Decay crash flash overlay frames
if (crash_flash > 0) {
    crash_flash -= 1;
}

// ----------------------------------------------------
// UPDATE JUICY ROCKET ENGINE TRAILS
// ----------------------------------------------------
if (alive && !kamikaze_exploded) {
    for (var i = 5; i > 0; i--) {
        trail_x[i] = trail_x[i-1];
        trail_y[i] = trail_y[i-1];
    }
    trail_x[0] = x;
    trail_y[0] = y;
}

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
// STATE MACHINE FOR SHOP & WITHDRAWAL
// ----------------------------------------------------
if (variable_instance_exists(id, "state")) {
    if (state == "withdraw") {
        speed = 0;
        y -= 8; // fly off screen
        
        // Trail update during withdraw
        for (var i = 5; i > 0; i--) {
            trail_x[i] = trail_x[i-1];
            trail_y[i] = trail_y[i-1];
        }
        trail_x[0] = x;
        trail_y[0] = y;
        
        if (y < -80) {
            state = "shop";
            gold += 120; // Earn 120 gold at the end of each turn
            wrench_purchased = false; // Reset wrench purchased state for this shop session
            session_purchases = [0, 0, 0, 0];
            selected_item = 0;
            hp_before_shop = hp;
            shield_charges_before_shop = shield_charges;
        }
        exit;
    }
    
    if (state == "shop") {
        speed = 0;
        // Keep trail matching position
        for (var i = 0; i < 6; i++) {
            trail_x[i] = x;
            trail_y[i] = y;
        }
        exit;
    }
    
    if (state == "story") {
        speed = 0;
        // Keep trail matching position
        for (var i = 0; i < 6; i++) {
            trail_x[i] = x;
            trail_y[i] = y;
        }
        
        var current_text = story_texts[story_dialog_index];
        var text_len = string_length(current_text);
        
        // Typewriter effect ticker
        if (story_char_count < text_len) {
            var prev_char_count = story_char_count;
            story_char_count += story_char_speed;
            if (story_char_count > text_len) story_char_count = text_len;
            
            // Radio typing sound every few characters
            if (floor(story_char_count) != floor(prev_char_count) && floor(story_char_count) % 3 == 0) {
                var snd = audio_play_sound(sndClick, 1, 0);
                audio_sound_pitch(snd, random_range(0.8, 1.15));
                audio_sound_gain(snd, 0.25, 0);
            }
        }
        
        var press_space = keyboard_check_pressed(vk_space);
        var press_enter = keyboard_check_pressed(vk_enter);
        
        if (press_space || press_enter) {
            if (story_char_count < text_len) {
                // Skip the typewriter and show entire page immediately
                story_char_count = text_len;
                audio_play_sound(sndClickBut, 3, 0);
            } else {
                if (story_dialog_index < array_length(story_texts) - 1) {
                    // Advance to next page of the story
                    story_dialog_index += 1;
                    story_char_count = 0;
                    audio_play_sound(sndBoop, 5, 0);
                } else {
                    // End storytelling, start video
                    state = "video";
                    video_frame_count = 0;
                    video_started = false;
                    audio_pause_all();
                    
                    var video_path = "hoang.mp4";
                    if (file_exists(working_directory + "hoang.mp4")) {
                        video_path = working_directory + "hoang.mp4";
                    }
                    video_open(video_path);
                }
            }
        }
        exit;
    }
    
    if (state == "video") {
        speed = 0;
        // Keep trail matching position
        for (var i = 0; i < 6; i++) {
            trail_x[i] = x;
            trail_y[i] = y;
        }
        
        var status = video_get_status();
        var skip_pressed = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
        
        // Update started state once playback actually starts (status 0 = playing)
        if (status == 0) {
            video_started = true;
        }
        
        // Check if video has ended
        var duration = video_get_duration();
        var pos = video_get_position();
        
        var is_finished = false;
        if (video_started) {
            if (status == 2) is_finished = true;
            if (status == 1 && pos >= duration - 200 && duration > 0) is_finished = true;
        }
        
        video_frame_count++;
        
        // Fallback: if video fails to open or get started after 300 frames (5 seconds)
        if (video_frame_count > 300 && !video_started) {
            is_finished = true;
        }
        
        if (is_finished || skip_pressed) {
            video_close();
            audio_resume_all();
            state = "reenter";
            x = room_width / 2;
            y = room_height + 100;
        }
        exit;
    }
    
    if (state == "reenter") {
        speed = 0;
        y -= 8; // fly back onto screen
        
        // Trail update during reentry
        for (var i = 5; i > 0; i--) {
            trail_x[i] = trail_x[i-1];
            trail_y[i] = trail_y[i-1];
        }
        trail_x[0] = x;
        trail_y[0] = y;
        
        if (y <= 512) {
            y = 512;
            state = "play";
            
            // Start next wave countdown & dialogue!
            wave_countdown = 300;
            next_wave = level_wave + 1;
            wave_dialog_index = 0;
        }
        exit;
    }
}

// ----------------------------------------------------
// ROCKET & AUTOFIRE SKILL CONTROLS
// ----------------------------------------------------
// Rocket cooldown decay
if (variable_instance_exists(id, "rocket_cooldown") && rocket_cooldown > 0) {
    rocket_cooldown -= 1;
}

// Press Q to launch homing rocket
if (state == "play" && variable_instance_exists(id, "has_rocket") && has_rocket) {
    if (keyboard_check_pressed(ord("Q")) && rocket_cooldown <= 0) {
        rocket_cooldown = 120; // 2 seconds cooldown (120 frames at 60fps)
        audio_play_sound(sndDragonfire, 8, 0); // Play launch sound
        
        // Spawn homing rocket from player's position
        instance_create_depth(x, y - 20, depth - 1, obj_phi_thuyen_rocket);
    }
}

// Press E to toggle autofire (if has_autofire is owned)
if (state == "play" && variable_instance_exists(id, "has_autofire") && has_autofire) {
    if (keyboard_check_pressed(ord("E"))) {
        autofire_active = !autofire_active;
        audio_play_sound(sndClick, 8, 0);
    }
}

// ----------------------------------------------------
// KAMIKAZE SACRIFICE CONTROL
// ----------------------------------------------------
if (variable_instance_exists(id, "kamikaze_mode") && kamikaze_mode) {
    speed = 0;
    
    // 1. One-time screen cleanup of projectiles when cinematic triggers
    if (variable_instance_exists(id, "kamikaze_cleaned") && !kamikaze_cleaned) {
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
                
                // Screen shake and white flash
                screen_shake = 45;
                crash_flash = 35;
                
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
        // Monologue progression controls
        var current_text = monologue_texts[monologue_index];
        var text_len = string_length(current_text);
        
        // 1. Typewriter letter ticker
        if (monologue_char_count < text_len) {
            var prev_char_count = monologue_char_count;
            monologue_char_count += monologue_char_speed;
            if (monologue_char_count > text_len) monologue_char_count = text_len;
            
            // Radio typing sound every few characters
            if (floor(monologue_char_count) != floor(prev_char_count) && floor(monologue_char_count) % 3 == 0) {
                var snd = audio_play_sound(sndClick, 1, 0);
                audio_sound_pitch(snd, random_range(0.9, 1.25));
                audio_sound_gain(snd, 0.35, 0);
            }
        }
        
        // 2. Mark complete when the last line is fully rendered
        if (monologue_index == array_length(monologue_texts) - 1 && monologue_char_count >= text_len) {
            monologue_completed = true;
        }
        
        // 3. User interaction (Space to skip typing or proceed, Enter to proceed or sacrifice)
        var press_space = keyboard_check_pressed(vk_space);
        var press_enter = keyboard_check_pressed(vk_enter);
        
        if (press_space || press_enter) {
            if (monologue_char_count < text_len) {
                // Skip the typewriter and show entire page immediately
                monologue_char_count = text_len;
                audio_play_sound(sndClickBut, 3, 0);
            } else {
                if (monologue_index < array_length(monologue_texts) - 1) {
                    // Advance to next page of the monologue
                    monologue_index += 1;
                    monologue_char_count = 0;
                    audio_play_sound(sndBoop, 5, 0);
                } else if (monologue_completed && press_enter) {
                    // Final sacrifice action!
                    kamikaze_charging = true;
                    audio_play_sound(sndConvert, 10, 0); // Play siren / charging sound
                }
            }
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
        if (variable_instance_exists(id, "wave_dialog_index") && wave_dialog_index >= 0) {
            // Dialogue is active: Pause the countdown timer!
            // Advance dialogue page with Space or Enter
            if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
                wave_dialog_index += 1;
                audio_play_sound(sndBoop, 5, 0); // Beep sound
                
                if (wave_dialog_index >= 2) {
                    // All pages read! Start wave immediately on next frame!
                    wave_dialog_index = -1;
                    wave_countdown = 1;
                }
            }
        } else {
            wave_countdown -= 1;
        }
        
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
    
    // Check if we need to start a countdown to the next wave (Modified for Shop system)
    if (state == "play" && instance_number(obj_ke_dich) == 0 && instance_number(obj_tau_san_bay) == 0 && wave_countdown == -1) {
        if (level_wave == 1 || level_wave == 2) {
            state = "withdraw";
        } else if (level_wave == 3) {
            // Victory if all waves cleared
            won = true;
        }
    }
}

// Vertical movement
if (state == "play") {
    var spd = variable_instance_exists(id, "move_speed") ? move_speed : 7;
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        y -= spd;
    }
    else if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        y += spd;
    }
}

// Keep inside screen boundaries
x = clamp(x, 40, room_width - 40);
y = clamp(y, 100, room_height - 60);

// ----------------------------------------------------
// AUTOFIRE WEAPON CONTROL
// ----------------------------------------------------
if (shoot_cooldown > 0) {
    shoot_cooldown -= 1;
}

if (state == "play") {
    var cd_val = variable_instance_exists(id, "shoot_cooldown_val") ? shoot_cooldown_val : 10;
    var fire_pressed = keyboard_check(vk_space) || (variable_instance_exists(id, "autofire_active") && autofire_active);
    
    if (fire_pressed && shoot_cooldown <= 0) {
        shoot_cooldown = cd_val;
        event_perform(ev_keypress, vk_space); // programmatically trigger Space keypress event
    }
}