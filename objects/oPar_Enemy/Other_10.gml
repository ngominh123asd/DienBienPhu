/// @description Attack

//set dir of attack
var Dir = point_direction(x,y,NearestEnemy.x,NearestEnemy.y)

//create attack object
var Att = instance_create_layer(x+lengthdir_x(AttackDist,Dir),y+lengthdir_y(AttackDist,Dir),"Instances",oAtt_EnemyMelee);
Att.Power = Power;

CanAttack = 0; //If can attack
alarm[0] = AttackDelay;