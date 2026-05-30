/// @description Init

// HP
MaxHp = 50;
CurHp = 50;

// Combat
Power = 2;
CanAttack = 1;
NearestEnemy = noone;
Aggroed = false; // Chỉ tấn công khi bị tấn công trước

// Timers
AttackDelay = room_speed * 2;    // Bắn mỗi 2 giây
SpawnDelay = room_speed * 5;     // Spawn lính mỗi 5 giây
UnhurtDelay = room_speed / 2;    // Thời gian bất tử sau bị đánh

// EXP
ExpDropped = 15;

// Scale (sprite 250x250 -> ~25px)
UnitScale = 0.1;
image_xscale = UnitScale;
image_yscale = UnitScale;

// Idle
image_speed = 0;
image_index = 0;

// Bắt đầu spawn lính
alarm[2] = SpawnDelay;
