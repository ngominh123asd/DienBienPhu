/// @description Init

MaxHp = 2; //Max HP
CurHp = 2; //Hp
Power = 1; //Att pow
Spd = .25; //Spd
NearestEnemy = noone;

DestX = x; //goto spot
DestY = y;

CanAttack = 1; //If can attack

// Scale
UnitScale = 1;

if sprite_index == sEn_Slime {
	UnitScale = 0.16;
}
else if sprite_index == sEn_Wolf {
	UnitScale = 0.16;
}
else if sprite_index == sEn_Bear {
	UnitScale = 0.08;
}
else if sprite_index == sEn_Dragon {
	UnitScale = 0.22;
}
else if sprite_index == sEn_DragonFire {
	UnitScale = 0.22;
}

image_xscale = UnitScale;
image_yscale = UnitScale;
image_xscale = UnitScale;
image_yscale = UnitScale;
//Unique
AttackDist = 3; //Distance to attack from
ExpDropped = 5;
AttackDelay = room_speed / 2;
UnhurtDelay = room_speed / 2;