/// @description Train friendly reinforcements cyclically
if (CurHp > 0) {
    var sx = x + irandom_range(-25, 25);
    var sy = y + irandom_range(-25, 25);
    
    // Emerald green flare effect on recruitment completion!
    effect_create_above(ef_flare, sx, sy, 0, c_green);
    
    var unit_obj = oFr_Soldier;
    if (spawn_cycle == 1) unit_obj = oFr_Archer;
    else if (spawn_cycle == 2) unit_obj = oFr_Mage;
    
    // Advance to next cycle
    spawn_cycle = (spawn_cycle + 1) % 3;
    
    var unit = instance_create_layer(sx, sy, "Instances", unit_obj);
    if (unit != noone) {
        // Automatically rally them forward to advance on the enemy base!
        unit.DestX = sx + 120;
        unit.DestY = sy;
    }
    
    alarm[2] = SpawnDelay;
}
