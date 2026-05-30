/// @description Init

Selected = 0; //If selected
DestX = x; //Dest to go to xy
DestY = y;
Spd = 0.325;

MouseOver = 0; //If mouse is on unit
CanAttack = 1; //If can attack

image_speed = 0;

//Stats
Name = scrGetName();
Level = 1;
Experience = 0;

MaxHp = irandom_range(3, 5);
CurHp = MaxHp;
Power = irandom_range(1, 2);
Luck = irandom_range(1, 3);
Fort = irandom_range(1, 3);

//Unique
AttackDist = 8; //Distance to attack from
AttackDelay = room_speed / 2;
UnhurtDelay = room_speed / 2;