// Check if this is the middle boss and side enemies are still alive
if (sprite_index == sEn_Dragon) {
    var side_alive = 0;
    with (obj_ke_dich) {
        if (sprite_index != sEn_Dragon) {
            side_alive++;
        }
    }
    
    if (side_alive > 0) {
        // Destroy the laser bullet
        instance_destroy(other);
        
        // Play deflect/shield sound
        audio_play_sound(sndBoop, 10, 0);
        
        // Trigger visual flash
        shield_hit_timer = 10;
        
        exit;
    }
}

// Reduce life
life = life - 1;

// Destroy the laser bullet that hit us
instance_destroy(other);

// Play hit sound
audio_play_sound(sndMeleeHit, 10, 0);

// Check if dead
if (life <= 0) {
    audio_play_sound(sndDie, 10, 0);
    instance_create_layer(x, y, "Instances", oFx_DeadPlayer);
    
    // Spawn power-up or heart drop if it is a side enemy, otherwise heal player on Boss 2 defeat
    if (sprite_index != sEn_Dragon) {
        var chance = random(100);
        if (chance < 35) {
            instance_create_depth(x, y, depth, obj_powerup);
        } else if (chance < 70) {
            instance_create_depth(x, y, depth, obj_heart_drop);
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
    
    instance_destroy();
}