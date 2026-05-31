/// @description Frontline Training Camp
event_inherited();

Name = "Trại Huấn Luyện";
MaxHp = 150; // Tanky frontline operations base
CurHp = MaxHp;
SpawnDelay = room_speed * 5; // Trains one soldier/archer/mage every 5 seconds!
image_speed = 0;

image_xscale = 0.022;
image_yscale = 0.022;

// Blend with rich emerald green to signify training/spawning
image_blend = make_color_rgb(100, 255, 120);

spawn_cycle = 0; // Cycles: 0 = Soldier, 1 = Archer, 2 = Mage
alarm[2] = SpawnDelay;
