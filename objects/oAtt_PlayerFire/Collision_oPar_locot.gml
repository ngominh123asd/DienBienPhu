/// @description Hit locot

// Shield block check
if (variable_instance_exists(other, "ShieldActive") && other.ShieldActive) {
	instance_destroy();
	exit;
}

//If not hurt
if other.image_blend == c_white {
	other.CurHp -= Power; //Minus hp
	other.image_blend = global.HurtCol; //Change to hurt
	other.alarm[1] = other.UnhurtDelay; //Set hurt alarm
	other.Aggroed = true; // Lô cốt bị khiêu khích
	
	audio_play_sound(sndFireball,10,0);
}
instance_destroy();
