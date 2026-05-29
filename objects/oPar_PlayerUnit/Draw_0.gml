/// @description Draw

#region Draw selected icon
var zoom = 1;
if instance_exists(oCamera) zoom = oCamera.ZoomFactor;

if Selected {
	draw_sprite_ext(sSelected,0,x,y, zoom, zoom, 0, c_white, 1);
}
#endregion

draw_self();