// Wave-like floating motion
bounce_timer += 0.05;
y += sin(bounce_timer) * 0.25;

// ----------------------------------------------------
// MAGNETIC PULL (Hút Nâng Cấp)
// ----------------------------------------------------
if (instance_exists(obj_phi_thuyen)) {
    var dist = distance_to_object(obj_phi_thuyen);
    if (dist < 220) {
        vspeed = 0;
        hspeed = 0;
        
        var dir = point_direction(x, y, obj_phi_thuyen.x, obj_phi_thuyen.y);
        x += lengthdir_x(12, dir);
        y += lengthdir_y(12, dir);
        
        exit;
    }
}

// Bounce off horizontal screen edges
if (x < 30) {
    x = 30;
    hspeed = abs(hspeed);
}
if (x > room_width - 30) {
    x = room_width - 30;
    hspeed = -abs(hspeed);
}

// Clean up if it falls off screen
if (y > room_height + 50) {
    instance_destroy();
}
