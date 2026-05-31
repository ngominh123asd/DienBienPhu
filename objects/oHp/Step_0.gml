/// @description Move

if CanMove{
	if instance_exists(oPar_PlayerUnit){
	
		var NearInst = instance_nearest(x,y,oPar_PlayerUnit);
		var Dist = point_distance(x,y,NearInst.x,NearInst.y);
		var Dir = point_direction(x,y,NearInst.x,NearInst.y);
	
		if NearInst.CurHp < NearInst.MaxHp{
			if Dist < 12{
	
				x += lengthdir_x((Dist * .05),Dir) 
				y += lengthdir_y((Dist * .05),Dir) 
			}
		}
	}
}

// Force the scale every frame to bypass IDE cache
image_xscale = 0.015;
image_yscale = 0.015;