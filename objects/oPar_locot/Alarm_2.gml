/// @description Spawn Enemy

// Chọn ngẫu nhiên loại enemy
var EnemyType = irandom(3);
var SpawnX = x + irandom_range(-15, 15);
var SpawnY = y + irandom_range(-15, 15);

switch (EnemyType) {
	case 0:
		instance_create_layer(SpawnX, SpawnY, "Instances", oEn_Slime);
		break;
	case 1:
		instance_create_layer(SpawnX, SpawnY, "Instances", oEn_Wolf);
		break;
	case 2:
		instance_create_layer(SpawnX, SpawnY, "Instances", oEn_Bear);
		break;
	case 3:
		instance_create_layer(SpawnX, SpawnY, "Instances", oEn_Dragon);
		break;
}

// Tiếp tục spawn
alarm[2] = SpawnDelay;
