/// @description Hit enemy

//If not hurt
if other.image_blend = c_white{
	other.CurHp -= Power; //Minus hp
	other.image_blend = c_red; //Change to hurt
	other.alarm[1] = other.UnhurtDelay; //Set hurt alarm
	
}

instance_destroy();