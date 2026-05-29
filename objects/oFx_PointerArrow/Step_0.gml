/// @description Destroy

if instance_exists(oPar_PlayerUnit){
	
	if oPar_PlayerUnit.Selected{
		
		instance_destroy();	
	}
}