/// @description Stay with parent

if instance_exists(Parent){
	
	depth = -y - 1;
	x = Parent.x;
	y = Parent.y;
}else{
	
	instance_destroy();	
}