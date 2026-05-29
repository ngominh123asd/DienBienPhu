/// @description Attack

//set dir of attack
var Dir = point_direction(x,y,NearestEnemy.x,NearestEnemy.y)
var StartDist = 4;

//create attack object
var Att = instance_create_layer(x+lengthdir_x(StartDist,Dir),y+lengthdir_y(StartDist,Dir),"Instances",oAtt_PlayerFire);
Att.Power = Power;
Att.direction = Dir;
Att.speed = 1;
Att.image_angle = Att.direction;

CanAttack = 0; //If can attack
alarm[0] = AttackDelay;