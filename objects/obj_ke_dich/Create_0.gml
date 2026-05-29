image_angle = 270
alarm[0]=60

life=5

// Initialize horizontal movement
hspeed = 3;

// If this is the middle instance, change its sprite to sEn_Dragon
my_scale = 1.0;
if (x > 300 && x < 600) {
    sprite_index = sEn_Dragon;
    image_angle = 0; // Stand/fly upright
    image_speed = 0.2; // Smooth wing animation speed
    life = 8; // Extra health for the middle dragon boss!
    my_scale = 0.75; // Scale the dragon to 75% so it is a massive, epic central boss!
    image_xscale = my_scale;
    image_yscale = my_scale;
    
    // Skill cooldowns (in frames)
    missile_cooldown = 180; // 3 seconds
    spread_cooldown = 120;  // 2 seconds
}