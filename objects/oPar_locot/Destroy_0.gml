/// @description Drop Exp and Hp

// Drop EXP
for (var a = 0; a < ExpDropped; a ++){
	instance_create_layer(x+irandom_range(-3,3),y+irandom_range(-3,3),"Instances",oExp);	
}

// 50% chance to drop 1-3 HP items
if (irandom(1) == 0) {
    var hp_amount = irandom_range(1, 3);
    for (var a = 0; a < hp_amount; a++) {
        instance_create_layer(x+irandom_range(-3,3),y+irandom_range(-3,3),"Instances",oHp);
    }
}
