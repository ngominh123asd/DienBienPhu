/// @description Trajectory and Detonation logic
var exploded = false;

if (bomb_type == 2) {
    // E: Katyusha Rocket - flies diagonally along direction
    if (point_distance(x, y, target_x, target_y) <= speed) {
        x = target_x;
        y = target_y;
        exploded = true;
    }
} else if (is_artillery) {
    // Legacy arcing shell path
    t++;
    var pct = t / max_t;
    var prev_x = x;
    var prev_y = y;
    x = lerp(start_x, target_x, pct);
    y = lerp(start_y, target_y, pct) - sin(pct * 3.14159) * 150;
    image_angle = point_direction(prev_x, prev_y, x, y) - 90;
    
    if (t >= max_t) {
        x = target_x;
        y = target_y;
        exploded = true;
    }
} else {
    // Q, W, R: Straight downward falling bomb / flak / TNT bundle
    y += vspeed;
    image_angle = 180;
    
    if (y >= target_y) {
        y = target_y;
        exploded = true;
    }
}

// Detonation Sequence
if (exploded) {
    // 1. Determine tactical statistics based on skill type
    var shake = 18;
    var damage = 30;
    var radius = 140;
    var detonate_sound = sndDragonfireHit;
    var debris_count = 4;
    
    if (bomb_type == 1) {
        // W: AA Flak shell
        shake = 3;
        damage = 10;
        radius = 50;
        detonate_sound = sndBoop;
        debris_count = 1;
    } 
    else if (bomb_type == 2) {
        // E: Katyusha rocket
        shake = 5;
        damage = 18;
        radius = 75;
        detonate_sound = sndDragonfireHit;
        debris_count = 2;
    } 
    else if (bomb_type == 3) {
        // R: Giant A1 TNT Charge
        shake = 32;
        damage = 150;
        radius = 200;
        detonate_sound = sndDragonfireHit;
        debris_count = 12;
    }
    
    // 2. Screen Shake
    if (instance_exists(oCont_Room)) {
        oCont_Room.screen_shake = shake;
    }
    
    // 3. Play sound
    audio_play_sound(detonate_sound, 10, false);
    
    // 4. Apply Splash Damage
    with (oPar_Enemy) {
        if (point_distance(x, y, other.x, other.y) <= radius) {
            CurHp -= damage;
            image_blend = global.HurtCol;
            alarm[1] = UnhurtDelay;
        }
    }
    
    with (oPar_locot) {
        if (point_distance(x, y, other.x, other.y) <= radius) {
            CurHp -= damage;
            image_blend = global.HurtCol;
            alarm[1] = UnhurtDelay;
        }
    }
    
    // 5. Spawn spectacular dust/debris cloud (DeadPlayer bones particle effects)
    for (var i = 0; i < debris_count; i++) {
        var rx = x + irandom_range(-radius * 0.25, radius * 0.25);
        var ry = y + irandom_range(-radius * 0.25, radius * 0.25);
        instance_create_layer(rx, ry, "Instances", oFx_DeadPlayer);
    }
    
    // 6. Clean up
    instance_destroy();
}
