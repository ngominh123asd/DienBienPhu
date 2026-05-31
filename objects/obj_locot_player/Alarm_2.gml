/// @description Spawn friendly soldiers
if (CurHp > 0) {
    for (var i = 0; i < 2; i++) {
        var sx = x + irandom_range(-20, 20);
        var sy = y + irandom_range(-20, 20);
        effect_create_above(ef_smoke, sx, sy, 0, c_white);
        
        var unit = instance_create_layer(sx, sy, "Instances", oFr_Soldier);
        if (unit != noone) {
            // Rally them forward to advance towards enemy positions
            unit.DestX = sx + 80;
            unit.DestY = sy;
        }
    }
    alarm[2] = SpawnDelay;
}
