/// @description Fade out
if Fade{
	Alpha -= 0.01;	
	if Alpha <= 0{
		instance_destroy();	
	}
}
