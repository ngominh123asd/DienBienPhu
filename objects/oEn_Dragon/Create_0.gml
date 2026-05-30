/// @description Init

// Inherit the parent event
event_inherited();

MaxHp = 500;
CurHp = 500;
Power = 2;

// Scale B52
UnitScale = 0.22;
image_xscale = UnitScale;
image_yscale = UnitScale;

// Boss B52 đánh xa
AttackDist = 140;
ExpDropped = 200;
AttackDelay = room_speed * 2;
UnhurtDelay = room_speed / 2;

// B52 không cần chạy sát player
Spd = 0.08;

// biến để chống bắn quá nhiều trong cùng 1 animation
HasFired = false;