shield_hit_timer = 0;
firecarpet_cooldown = 0;
firecarpet_warning_timer = 0;
firecarpet_target_x = 0;
image_angle = 0
alarm[0]=60

life=5
max_life=5

// Initialize horizontal movement
hspeed = 3;

// If this is the middle instance, change its sprite to sEn_Dragon
my_scale = 1.0;
if (x > 300 && x < 600) {
    // Only become boss if this is Turn 2!
    var is_boss_spawn = false;
    if (instance_exists(obj_phi_thuyen)) {
        if (obj_phi_thuyen.level_wave == 2) {
            is_boss_spawn = true;
        }
    }
    
    if (is_boss_spawn) {
        sprite_index = sEn_Dragon;
        image_angle = 0; // Stand/fly upright
        image_speed = 0.2; // Smooth wing animation speed
        life = 100; // Set Dragon boss HP to 100 (equal to Boss 3)
        max_life = 100; // Set Dragon boss Max HP to 100
        my_scale = 0.75; // Scale the dragon to 75% so it is a massive, epic central boss!
        image_xscale = my_scale;
        image_yscale = my_scale;
        
        // Skill cooldowns (in frames)
        missile_cooldown = 180; // 3 seconds
        spread_cooldown = 120;  // 2 seconds
        
        // Fire carpet skill cooldowns (in frames)
        firecarpet_cooldown = 200; // start with 200 frames delay
        firecarpet_warning_timer = 0;
        firecarpet_target_x = 0;
    }
}