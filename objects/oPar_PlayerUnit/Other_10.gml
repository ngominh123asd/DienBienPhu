/// @description Attack

if !instance_exists(NearestEnemy) {
	exit;
}

// hướng đánh về enemy
var Dir = point_direction(x, y, NearestEnemy.x, NearestEnemy.y);

// tạo hitbox đánh
var Att = instance_create_layer(
	x + lengthdir_x(10, Dir),
	y + lengthdir_y(10, Dir),
	"Instances",
	oAtt_PlayerMelee
);

Att.Power = Power;

// Hitbox to hơn để đánh trúng boss B52
Att.image_xscale = 3;
Att.image_yscale = 3;

// Cho hitbox nằm đúng hướng
Att.direction = Dir;
Att.image_angle = Dir;

CanAttack = 0;
alarm[0] = AttackDelay;