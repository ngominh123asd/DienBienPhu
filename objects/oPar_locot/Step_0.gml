/// @description Step Control

// Time-based HP Upgrades
if (instance_exists(oCont_Room)) {
    var playtime = oCont_Room.TimePlayed;
    
    // Upgrade to 100 HP at 2 minutes (7200 frames)
    if (playtime >= 7200 && !UpgradedTo100) {
        UpgradedTo100 = true;
        MaxHp = 100;
        CurHp += 50;
    }
    
    // Upgrade to 150 HP at 4 minutes (14400 frames)
    if (playtime >= 14400 && !UpgradedTo150) {
        UpgradedTo150 = true;
        MaxHp = 150;
        CurHp += 50;
    }
}

#region Die

if CurHp <= 0 {
	// Chỉ rơi đồ 1 lần khi mới chết
	if (image_index != 8) {
		var drop_dir = 270; // Default direction down
		var player = instance_nearest(x, y, oPar_PlayerUnit);
		if (player != noone) {
			drop_dir = point_direction(x, y, player.x, player.y);
		}
		var drop_dist = 60; // Distance to spawn outside the locot mask
		var base_x = x + lengthdir_x(drop_dist, drop_dir);
		var base_y = y + lengthdir_y(drop_dist, drop_dir);

		// Drop EXP
		for (var a = 0; a < ExpDropped; a ++){
			instance_create_layer(base_x + irandom_range(-15,15), base_y + irandom_range(-15,15), "Instances", oExp);	
		}

		// 20% chance to drop 1 HP item
		if (irandom(99) < 20) {
			instance_create_layer(base_x + irandom_range(-15,15), base_y + irandom_range(-15,15), "Instances", oHp);
		}
		
		// Stop alarms
		alarm[0] = -1;
		alarm[1] = -1;
		alarm[2] = -1;
		
		// Set frame phá hủy
		image_speed = 0;
		image_index = 8;
	}
	
	// Khóa depth và exit không làm gì nữa
	depth = -y + 10; // Đẩy xuống dưới một chút
	exit;
}

#endregion


#region Find Target & Attack

if instance_exists(oPar_PlayerUnit) {
	
	// Tìm player unit gần nhất
	NearestEnemy = instance_nearest(x, y, oPar_PlayerUnit);
	
	// Tấn công khi trong tầm bắn (đo chính xác bằng điểm giữa thay vì bounding box)
	if point_distance(x, y, NearestEnemy.x, NearestEnemy.y) <= 60 {
		
		if CanAttack {
			
			// Hướng bắn về target
			var Dir = point_direction(x, y, NearestEnemy.x, NearestEnemy.y);
			
			// Chạy animation bắn từ frame đầu tiên
			image_speed = 1;
			image_index = 0;
			
			// Tạo đạn bay (dùng đạn rồng nhưng đổi hình ảnh thành tia sáng/đạn)
			var Att = instance_create_layer(
				x + lengthdir_x(10, Dir),
				y + lengthdir_y(10, Dir),
				"Instances",
				oAtt_DragonFire
			);
			Att.Power = Power;
			Att.direction = Dir;
			Att.speed = 4; // Tốc độ đạn bay
			Att.image_angle = Dir;
			Att.sprite_index = spr_lazer_ke_dich; // Đổi hình ảnh
			Att.image_xscale = 0.6;
			Att.image_yscale = 0.6;
			
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

#region Animation Loop Control

// Nếu lô cốt còn sống và animation đang chạy
if (CurHp > 0 && image_speed > 0) {
	// Dừng animation sau khi chạy xong 1 lượt (tới frame 7)
	if (image_index >= 7.5) {
		image_index = 0;
		image_speed = 0;
	}
}

#endregion
