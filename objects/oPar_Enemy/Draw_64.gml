/// @description Draw HP to GUI
if (!instance_exists(oCamera)) exit;

var ShowHp = position_meeting(mouse_x, mouse_y, self);

if instance_exists(NearestEnemy) {
	if distance_to_object(NearestEnemy) < 24 {
		ShowHp = true;
	}
}

if ShowHp {
    var cx = oCamera.x;
    var cy = oCamera.y;
    var cw = oCamera.CamInitW * oCamera.ZoomFactor;
    var ch = oCamera.CamInitH * oCamera.ZoomFactor;

    var gw = 1280; // display_get_gui_width()
    var gh = 720;  // display_get_gui_height()

    var gui_x = ((x - cx) / cw) * gw + (gw / 2);
    var gui_y = ((bbox_bottom - 1 - cy) / ch) * gh + (gh / 2);

    draw_set_font(fnt_vietnamese);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);

	// HP sát chân địch shadow
	draw_set_color(c_black);
	draw_text(gui_x + 2, gui_y + 2, string(CurHp) + "/" + string(MaxHp));
	
	// HP sát chân địch
	draw_set_color(c_red);
	draw_text(gui_x, gui_y, string(CurHp) + "/" + string(MaxHp));

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}
