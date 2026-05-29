/// @description Draw Mass select

if mouse_check_button(mb_left){
	
	draw_set_color(c_white);
	draw_rectangle(X1,Y1,X2,Y2,1)
	draw_set_alpha(.25);
	draw_rectangle(X1,Y1,X2,Y2,0)
	draw_set_alpha(1);
}