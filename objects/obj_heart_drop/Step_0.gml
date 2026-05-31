// Move and drift bounce
y += sin(current_time * 0.04 + bounce_offset) * 0.25;

// ----------------------------------------------------
// MAGNETIC PULL (Hút Tim)
// ----------------------------------------------------
if (instance_exists(obj_phi_thuyen)) {
    var dist = distance_to_object(obj_phi_thuyen);
    if (dist < 220) {
        // Stop default forces and pull towards player
        vspeed = 0;
        hspeed = 0;
        
        var dir = point_direction(x, y, obj_phi_thuyen.x, obj_phi_thuyen.y);
        x += lengthdir_x(12, dir);
        y += lengthdir_y(12, dir);
        
        // Skip normal boundary checks
        exit;
    }
}

// Horizontal screen bounce
if (x <= 30) {
    hspeed = abs(hspeed);
}
if (x >= room_width - 30) {
    hspeed = -abs(hspeed);
}

// Destroy when offscreen
if (y > room_height + 50) {
    instance_destroy();
}
