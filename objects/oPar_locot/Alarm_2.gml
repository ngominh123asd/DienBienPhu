/// @description Spawn Enemy

// Chọn ngẫu nhiên loại enemy (0: Slime, 1: Wolf, 2: Bear)
var EnemyType = irandom(2);
var SpawnX = x + irandom_range(-15, 15);
var SpawnY = y + irandom_range(-15, 15);

// Hiệu ứng khi spawn lính
effect_create_above(ef_smoke, SpawnX, SpawnY, 0, c_gray);
effect_create_above(ef_flare, SpawnX, SpawnY, 0, c_orange);

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
}

// Tiếp tục spawn
alarm[2] = SpawnDelay;
