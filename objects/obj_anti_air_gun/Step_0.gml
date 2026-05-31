/// @description Lock-on and fire flak shells
DestX = x;
DestY = y;
depth = -y;

// Lock-on and fire flak at nearest enemy
if (instance_exists(oPar_Enemy)) {
    var target = instance_nearest(x, y, oPar_Enemy);
    if (point_distance(x, y, target.x, target.y) <= 300) { // Large anti-air range
        if (CanAttack) {
            // Predict and target enemy position with slight variance
            var tx = target.x + irandom_range(-15, 15);
            var ty = target.y + irandom_range(-15, 15);
            
            // Spawn flak projectile descending from above
            var flak = instance_create_layer(tx, ty - 250, "Instances", obj_air_bomb);
            if (flak != noone) {
                flak.bomb_type = 1; // Flak shell
                flak.target_x = tx;
                flak.target_y = ty;
                flak.vspeed = 9;
                flak.depth = -ty - 200;
            }
            
            // Trigger flak cannon pop/boop sound
            audio_play_sound(sndBoop, 8, false);
            
            CanAttack = 0;
            alarm[0] = AttackDelay;
        }
    }
}
