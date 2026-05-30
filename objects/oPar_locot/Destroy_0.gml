/// @description Drop Exp and Hp

// Drop EXP
for (var a = 0; a < ExpDropped; a ++){
	instance_create_layer(x+irandom_range(-3,3),y+irandom_range(-3,3),"Instances",oExp);	
}

// 20% chance to drop 1 HP item
if (irandom(99) < 20) {
    instance_create_layer(x+irandom_range(-3,3),y+irandom_range(-3,3),"Instances",oHp);
}
