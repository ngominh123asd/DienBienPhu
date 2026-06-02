/// @description Control

#region Die

if CurHp <= 0 {
	instance_destroy();	
}

#endregion


#region Move

if instance_exists(oPar_PlayerUnit) {
	
	//Get nearest enemy
	NearestEnemy = instance_nearest(x, y, oPar_PlayerUnit);
	if (NearestEnemy == noone) exit;
	
	//Set target
	if distance_to_object(NearestEnemy) < 24 {
		DestX = NearestEnemy.x;
		DestY = NearestEnemy.y;
	}
	
	//Attack when in range
	if distance_to_object(NearestEnemy) < AttackDist {
		
		//Attack if can
		if CanAttack {
			event_user(0);
			exit;
		}
	}
}


//Idle
if irandom(room_speed * 2) == 1 {
	
	var Dist = 8; //Dist to idle
	
	//Pick random spot
	DestX = x + irandom_range(-Dist, Dist);
	DestY = y + irandom_range(-Dist, Dist);
	
	//Don't idle into solids
	if collision_circle(DestX, DestY, 3, oPar_Collidable, 0, 1) {
		DestX = x;
		DestY = y;
	}
}
else {
	
	//If still far from spot, move
	if distance_to_point(DestX, DestY) > 2 {
		mp_potential_step_object(DestX, DestY, Spd, oPar_Collidable);
		image_speed = 1;
	}
	else {
		image_speed = 0;	
		image_index = 0;
	}
}


//Direction + Scale
if !variable_instance_exists(id, "UnitScale") {
	UnitScale = 1;
}

// Scale riêng cho enemy
if sprite_index == sEn_Slime {
	UnitScale = 0.16;
}
else if sprite_index == sEn_Wolf {
	UnitScale = 0.16;
}
else if sprite_index == sEn_Bear {
	UnitScale = 0.06;
}
else {
	UnitScale = 1;
}

if direction < 90 || direction > 270 {
	image_xscale = UnitScale;
}
else {
	image_xscale = -UnitScale;
}

image_yscale = UnitScale;
#endregion