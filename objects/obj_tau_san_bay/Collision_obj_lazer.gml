/// @description Collision with Player Laser

// Reduce life
life -= 1;

// Destroy the laser bullet that hit us
instance_destroy(other);

// Trigger visual flash
shield_hit_timer = 8;

// Play hit sound
audio_play_sound(sndMeleeHit, 10, 0);

// Check if entering Kamikaze mode
if (life <= 2) {
    life = 2; // lock health at 2 so it doesn't die from other bullets
    
    // Stop all movement immediately
    hspeed = 0;
    vspeed = 0;
    
    if (instance_exists(obj_phi_thuyen)) {
        obj_phi_thuyen.kamikaze_mode = true;
    }
}
