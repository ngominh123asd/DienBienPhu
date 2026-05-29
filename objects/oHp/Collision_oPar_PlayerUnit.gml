/// @description Give Exp

if other.CurHp < other.MaxHp{
	
	audio_play_sound(sndGetHp,10,0);
	other.CurHp ++;
	instance_destroy();
}
