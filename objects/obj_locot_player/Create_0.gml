/// @description Init Friendly Bunker
event_inherited();

Name = "Lô cốt Chiến hào";
MaxHp = 100;
CurHp = MaxHp;
Power = 3;
AttackDelay = room_speed * 1.5;
SpawnDelay = room_speed * 6; // Spawns friendly soldiers every 6 seconds!
CanAttack = 1;
image_speed = 0;
image_index = 0;

// Scale to fit aesthetic
image_xscale = 0.12;
image_yscale = 0.12;

// Blend to nice cyan blue to denote friendly unit
image_blend = make_color_rgb(100, 180, 255);

alarm[0] = AttackDelay;
alarm[2] = SpawnDelay;
