/// @description Drop Exp and Hp

// Drop EXP
for (var a = 0; a < ExpDropped; a ++){
	instance_create_layer(x+irandom_range(-1,1),y+irandom_range(-1,1),"Instances",oExp);	
}

// 10% chance to drop 1 HP item
if (irandom(99) < 10) {
    instance_create_layer(x+irandom_range(-2,2),y+irandom_range(-2,2),"Instances",oHp);
}