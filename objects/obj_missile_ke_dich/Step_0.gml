// Homing tracking logic
if (instance_exists(obj_phi_thuyen)) {
    var target_dir = point_direction(x, y, obj_phi_thuyen.x, obj_phi_thuyen.y);
    var diff = angle_difference(target_dir, direction);
    direction += clamp(diff, -1.8, 1.8); // Smooth homing turn speed
}

// Align fireball sprite with travel direction
image_angle = direction - 90;

// Destroy if it goes off screen boundaries
if (y > room_height + 50 || x < -50 || x > room_width + 50 || y < -100) {
    instance_destroy();
}
