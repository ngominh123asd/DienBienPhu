/// @description Draw to GUI
if (!instance_exists(oCamera)) exit;

draw_set_font(fnt_vietnamese);

var msg = string(Text);
var tx = x + TextOffsetX;
var ty = y + TextOffsetY;

var cx = oCamera.x;
var cy = oCamera.y;
var cw = oCamera.CamInitW * oCamera.ZoomFactor;
var ch = oCamera.CamInitH * oCamera.ZoomFactor;

var gw = 1280; // display_get_gui_width()
var gh = 720;  // display_get_gui_height()

var gui_x = ((tx - cx) / cw) * gw + (gw / 2);
var gui_y = ((ty - cy) / ch) * gh + (gh / 2);

draw_set_alpha(Alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

draw_set_color(c_black);
draw_text(gui_x + 2, gui_y + 2, msg);

draw_set_color(c_white);
draw_text(gui_x, gui_y, msg);

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
