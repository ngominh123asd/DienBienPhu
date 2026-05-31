/// @description Draw text

if ShowText{
	
	draw_set_alpha(.5);
	draw_set_color(c_dkgray);
	draw_rectangle(0,0,1280,720,0);
	draw_set_alpha(1);
	
	draw_set_halign(fa_center);
	draw_set_color(c_white);
	draw_set_valign(fa_middle);
		draw_set_font(fnt_vietnamese);
	draw_text_ext_transformed(640,360,string(Text),24,600,2,2,0);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	
	if keyboard_check_pressed(vk_enter){
		
		instance_destroy();	
	}
}
