/// @description Control

#region Die

if CurHp <= 0 {
	instance_destroy();	
}

#endregion


#region Find target

if instance_exists(oPar_PlayerUnit) {
	NearestEnemy = instance_nearest(x, y, oPar_PlayerUnit);
	if (NearestEnemy == noone) exit;
}
else {
	exit;
}

#endregion


#region Player melee hurtbox

// Hurtbox nhỏ hơn cho boss B52.
// Lính phải áp sát thân/cánh máy bay mới đánh trúng.
var hit = collision_rectangle(
	x - 35,
	y - 25,
	x + 35,
	y + 30,
	oAtt_PlayerMelee,
	false,
	true
);
if hit != noone {
	CurHp -= hit.Power;
	instance_destroy(hit);
}

#endregion


#region Attack animation

var Attacking = (sprite_index == sEn_DragonFire);

if Attacking {
	
	image_speed = 1;
	
	// Giữ scale khi đổi sprite attack
	UnitScale = 0.22;
	image_xscale = UnitScale;
	image_yscale = UnitScale;
	
	// Bắn 1 lần trong animation, không phụ thuộc frame 6-11 nữa
	if !HasFired {
		
		var Dir = point_direction(x, y, NearestEnemy.x, NearestEnemy.y);
		
		// Tạo đạn gần mũi máy bay / bụng máy bay
		var Att = instance_create_layer(
			x + lengthdir_x(32, Dir),
			y + lengthdir_y(32, Dir),
			"Instances",
			oAtt_DragonFire
		);
		
		Att.Power = Power;
		Att.direction = Dir;
		Att.speed = 2;
		Att.image_angle = Dir;
		
		HasFired = true;
	}
	
	exit;
}

#endregion


#region Attack check

if instance_exists(NearestEnemy) {
	
	// Nếu player ở gần boss thì attack
	if distance_to_object(NearestEnemy) < AttackDist {
		
		if CanAttack {
			event_user(0);
			audio_play_sound(sndDragonfire, 10, 0);
			exit;
		}
	}
}

#endregion


#region Stay in place

// Boss B52 đứng yên, không tự bay sang chỗ khác
image_speed = 1;

// Giữ scale ổn định
UnitScale = 0.22;
image_xscale = UnitScale;
image_yscale = UnitScale;

#endregion