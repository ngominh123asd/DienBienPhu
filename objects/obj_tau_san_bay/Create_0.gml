/// @description Initialize Aircraft Carrier Boss
life = 100;
max_life = 100;
phase = 1;
shield_hit_timer = 0;

// Giant scale adjustments (since 2048x2048 is massive)
// 0.16 scale is approx 330x330 pixels, perfect boss size
my_scale = 0.16;
image_xscale = my_scale;
image_yscale = my_scale;

// Initial horizontal movement
hspeed = 2.0;

// Attack timers (in frames)
spawn_cooldown = 180;    // Spawn 2 escort planes every 3 seconds in Phase 1
shoot_cooldown = 45;     // 3-way laser spray every 0.75 seconds
missile_cooldown = 120;  // Homing missile every 2 seconds in Phase 2
carpet_cooldown = 200;   // Carpet fire attack in Phase 2
carpet_warning = 0;
carpet_target_x = 0;
