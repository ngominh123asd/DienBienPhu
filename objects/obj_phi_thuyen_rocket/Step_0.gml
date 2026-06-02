/// @description Homing movement towards nearest enemy

// Decrement life timer
life_timer -= 1;
if (life_timer <= 0) {
    instance_destroy();
    exit;
}

// Find nearest target (either obj_ke_dich or obj_tau_san_bay)
var enemy = instance_nearest(x, y, obj_ke_dich);
var boss = instance_nearest(x, y, obj_tau_san_bay);

var target = noone;
if (instance_exists(enemy) && instance_exists(boss)) {
    if (distance_to_object(enemy) < distance_to_object(boss)) {
        target = enemy;
    } else {
        target = boss;
    }
} else if (instance_exists(enemy)) {
    target = enemy;
} else if (instance_exists(boss)) {
    target = boss;
}

// Adjust steering towards target
if (instance_exists(target)) {
    var target_dir = point_direction(x, y, target.x, target.y);
    var diff = angle_difference(target_dir, direction);
    direction += clamp(diff, -5.5, 5.5); // turn speed
}

image_angle = direction;

// Bound check
if (y < -100 || y > room_height + 100 || x < -100 || x > room_width + 100) {
    instance_destroy();
}
