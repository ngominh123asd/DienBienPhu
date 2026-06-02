/// @description Hit by Enemy Laser

if (alive) {
    // If immune, ignore the hit (but destroy the laser bullet)
    if (is_immune) {
        instance_destroy(other);
        exit;
    }
    
    // Check if we have shield charges
    if (variable_instance_exists(id, "shield_charges") && shield_charges > 0) {
        shield_charges -= 1;
        instance_destroy(other);
        
        // Play special shield deflect sound
        audio_play_sound(sndBoop, 10, 0);
        
        // Trigger small temporary immunity to prevent rapid bullet depletion
        is_immune = true;
        alarm[1] = room_speed * 0.4;
        exit;
    }
    
    // Deduct HP (steel roll reduces damage taken to 0.5 hearts)
    var dmg = 1;
    if (variable_instance_exists(id, "has_steel_roll") && has_steel_roll) {
        dmg = 0.5;
    }
    hp -= dmg;
    
    // Trigger screen shake
    screen_shake = 12;
    
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
