/// @description Draw Plane & Ground Shadow
// 1. Draw a soft, realistic ground shadow at target_y to convey height
draw_sprite_ext(Sprite2, 0, x, target_y, 0.45, 0.45, image_angle, c_black, 0.25);

// 2. Draw the actual plane flying high above with a bold red tint for our military forces
draw_sprite_ext(Sprite2, 0, x, y, image_xscale, image_yscale, image_angle, make_color_rgb(255, 60, 60), 1.0);

// 3. Draw a glowing Vietnamese Gold Star (★) in the center of our military aircraft
draw_set_color(c_yellow);
draw_set_font(fnt_vietnamese);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(x, y, "★", 1.8, 1.8, 0);

// Reset drawing configurations
draw_set_color(c_white);
draw_set_alpha(1.0);
