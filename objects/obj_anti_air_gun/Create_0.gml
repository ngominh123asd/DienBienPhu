/// @description 37mm AA Flak Gun
event_inherited();

Name = "Cao xạ 37mm";
MaxHp = 60;
CurHp = MaxHp;
Power = 12; // Splash damage deals 12 HP per shell
AttackDelay = room_speed * 1.5; // Fires flak shell every 1.5 seconds!
CanAttack = 1;

// Scale to compact size
image_xscale = 0.08;
image_yscale = 0.08;

// Blend with bronze/copper color to look like metal heavy weaponry
image_blend = make_color_rgb(220, 120, 20);

alarm[0] = AttackDelay;
