/// @description Hit enemy

//If not hurt
if other.image_blend = c_white{
	other.CurHp -= Power; //Minus hp
	other.image_blend = global.HurtCol; //Change to hurt
	other.alarm[1] = other.UnhurtDelay; //Set hurt alarm
	
}

audio_play_sound(sndArrowHit,10,0);

instance_destroy();