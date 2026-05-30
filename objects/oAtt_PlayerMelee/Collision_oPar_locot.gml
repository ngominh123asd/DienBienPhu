/// @description Hit locot

//If not hurt
if other.image_blend = c_white{
	other.CurHp -= Power; //Minus hp
	other.image_blend = global.HurtCol; //Change to hurt
	other.alarm[1] = other.UnhurtDelay; //Set hurt alarm
	
	audio_play_sound(sndMeleeHit,10,0);
}
