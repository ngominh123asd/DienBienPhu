if (!alive) exit;
if (variable_instance_exists(id, "kamikaze_mode") && kamikaze_mode) exit;

if (variable_instance_exists(id, "bullet_upgrade") && bullet_upgrade) {
    // Shoot 3 lasers! One straight, two diagonal
    var l1 = instance_create_depth(x, y, depth, obj_lazer);
    if (instance_exists(l1)) {
        l1.direction = 90;
        l1.image_angle = 90;
    }
    
    var l2 = instance_create_depth(x - 30, y, depth, obj_lazer);
    if (instance_exists(l2)) {
        l2.direction = 100;
        l2.image_angle = 100;
    }
    
    var l3 = instance_create_depth(x + 30, y, depth, obj_lazer);
    if (instance_exists(l3)) {
        l3.direction = 80;
        l3.image_angle = 80;
    }
    
    // Play enhanced shoot sound
    audio_play_sound(sndShootFireball, 8, 0);
} else {
    // Standard double lasers
    instance_create_depth(x+40,y,depth,obj_lazer);
    instance_create_depth(x-40,y,depth,obj_lazer);
    
    // Play standard shoot sound
    audio_play_sound(sndShootArrow, 8, 0);
}
