/// @description Hit final carrier boss

if (instance_exists(other)) {
    // Deal high damage
    other.life -= 4;
    
    // Play explosion sound
    audio_play_sound(sndDragonfireHit, 10, 0);
    
    // Spawn explosion visual FX
    instance_create_layer(x, y, "Instances", oFx_DeadPlayer);
    
    // Trigger visual flash
    other.shield_hit_timer = 8;
    
    // Check if entering Kamikaze mode
    if (other.life <= 2) {
        other.life = 2; // lock health
        other.hspeed = 0;
        other.vspeed = 0;
        if (instance_exists(obj_phi_thuyen)) {
            obj_phi_thuyen.kamikaze_mode = true;
        }
    }
}

// Destroy rocket itself
instance_destroy();
