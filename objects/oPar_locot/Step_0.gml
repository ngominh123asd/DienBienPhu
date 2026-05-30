/// @description Control

#region Die

if CurHp <= 0 {
	instance_destroy();
}

#endregion


#region Find Target & Attack

if instance_exists(oPar_PlayerUnit) {
	
	// Tìm player unit gần nhất
	NearestEnemy = instance_nearest(x, y, oPar_PlayerUnit);
	
	// Tấn công khi trong tầm bắn
	if distance_to_object(NearestEnemy) < 40 {
		
		if CanAttack {
			
			// Hướng bắn về target
			var Dir = point_direction(x, y, NearestEnemy.x, NearestEnemy.y);
			
			// Chạy animation bắn
			image_speed = 1;
			
			// Tạo hitbox đạn
			var Att = instance_create_layer(
				x + lengthdir_x(10, Dir),
				y + lengthdir_y(10, Dir),
				"Instances",
				oAtt_EnemyMelee
			);
			Att.Power = Power;
			
			// Cooldown
			CanAttack = 0;
			alarm[0] = AttackDelay;
		}
	}
	else {
		// Idle khi không có target
		image_speed = 0;
		image_index = 0;
	}
}
else {
	// Không có player unit nào, idle
	image_speed = 0;
	image_index = 0;
}

#endregion


#region Depth

depth = -y;

#endregion
