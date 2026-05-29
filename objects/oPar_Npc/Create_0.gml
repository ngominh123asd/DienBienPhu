/// @description Init

sprite_index = choose(sFr_Villager0, sFr_Villager1, sFr_Villager2, sFr_Villager3);

DestX = x;
DestY = y;

// Fix scale dân làng
UnitScale = 0.105;
image_xscale = UnitScale;
image_yscale = UnitScale;

//Stats
Name = scrGetName();
Level = 1;
Experience = 0;
MaxHp = irandom_range(3, 5);
CurHp = MaxHp;
Power = irandom_range(1, 3);
Luck = irandom_range(1, 3);
Fort = irandom_range(1, 3);
// Villager action timer
DoingAction = false;
ActionTimer = irandom_range(room_speed * 2, room_speed * 5);
ActionFrame = 0;

image_speed = 0;
image_index = 0;