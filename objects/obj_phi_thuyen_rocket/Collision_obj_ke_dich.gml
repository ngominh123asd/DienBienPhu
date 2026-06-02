/// @description Hit enemy plane

if (instance_exists(other)) {
    // Deal high damage to enemy
    other.life -= 4;
    
    // Trigger visual flash
    other.shield_hit_timer = 10;
    
    // Play explosion sound
    audio_play_sound(sndDragonfireHit, 10, 0);
    
    // Spawn explosion visual FX
    instance_create_layer(x, y, "Instances", oFx_DeadPlayer);
    
    // Check if dead
    if (other.life <= 0) {
        audio_play_sound(sndDie, 10, 0);
        
        // Spawn power-up or heart drop if it is a side enemy, otherwise heal player on Boss 2 defeat
        if (other.sprite_index != sEn_Dragon) {
            var chance = random(100);
            if (chance < 35) {
                instance_create_depth(other.x, other.y, other.depth, obj_powerup);
            } else if (chance < 70) {
                instance_create_depth(other.x, other.y, other.depth, obj_heart_drop);
            }
        } else {
            // Reward 4 hearts to player when Boss 2 is defeated!
            if (instance_exists(obj_phi_thuyen)) {
                with (obj_phi_thuyen) {
                    hp = min(hp + 4, max_hp);
                    audio_play_sound(sndGetHp, 10, 0);
                }
            }
        }
        
        instance_destroy(other);
    }
}

// Destroy rocket itself
instance_destroy();
