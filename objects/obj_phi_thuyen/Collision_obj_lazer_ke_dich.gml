/// @description Hit by Enemy Laser

if (alive) {
    // If immune, ignore the hit (but destroy the laser bullet)
    if (is_immune) {
        instance_destroy(other);
        exit;
    }
    
    // Deduct HP
    hp -= 1;
    
    // Destroy enemy laser
    instance_destroy(other);
    
    // Play damage sound
    audio_play_sound(sndDragonfireHit, 10, 0);
    
    // Trigger immunity (1 second)
    is_immune = true;
    alarm[1] = room_speed;
    
    // Check if dead
    if (hp <= 0) {
        alive = false;
        speed = 0; // Stop built-in movement
        
        // Spawn explosion and play death sound
        audio_play_sound(sndDie, 10, 0);
        instance_create_layer(x, y, "Instances", oFx_DeadPlayer);
    }
}
