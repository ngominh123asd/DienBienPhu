/// @description Friendly Bunker logic

// Prevent movement and lock position
DestX = x;
DestY = y;
depth = -y;

// Automatic lock-on and target firing
if (instance_exists(oPar_Enemy)) {
    var target = instance_nearest(x, y, oPar_Enemy);
    if (point_distance(x, y, target.x, target.y) <= 180) { // Defense range
        if (CanAttack) {
            var dir = point_direction(x, y, target.x, target.y);
            
            // Create a blue laser project towards enemies
            var bullet = instance_create_layer(x, y, "Instances", oAtt_PlayerArrow);
            if (bullet != noone) {
                bullet.Power = Power;
                bullet.direction = dir;
                bullet.speed = 5;
                bullet.image_angle = dir;
                bullet.sprite_index = spr_lazer; // Blue laser
                bullet.image_blend = c_aqua;
            }
            
            CanAttack = 0;
            alarm[0] = AttackDelay;
        }
    }
}
