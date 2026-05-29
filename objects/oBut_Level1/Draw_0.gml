/// @description Premium Tactical Draw

if (!variable_instance_exists(id, "hover_val")) {
	hover_val = 0;
}

var target_hover = (image_index == 1) ? 1.0 : 0.0;
hover_val = lerp(hover_val, target_hover, 0.15);

var x1 = bbox_left;
var y1 = bbox_top;
var x2 = bbox_right;
var y2 = bbox_bottom;

// 1. Base Panel (Dark tactical gunmetal green-gray)
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(20, 24, 22));
draw_roundrect_ext(x1, y1, x2, y2, 6, 6, false);

// 2. Inner Amber Glow on Hover
draw_set_color(make_color_rgb(255, 160, 50));
draw_set_alpha(hover_val * 0.15);
draw_roundrect_ext(x1 - 1, y1 - 1, x2 + 1, y2 + 1, 6, 6, false);

// 3. Subtle Border
draw_set_color(merge_color(make_color_rgb(60, 72, 66), make_color_rgb(255, 160, 50), hover_val));
draw_set_alpha(0.45 + hover_val * 0.4);
draw_roundrect_ext(x1, y1, x2, y2, 6, 6, true);

// 4. Tactical Corner Brackets (Stencil style)
var b_len = 8;
var b_dist = 2 + (hover_val * 2); // Slides outward smoothly on hover
var bx1 = x1 - b_dist;
var by1 = y1 - b_dist;
var bx2 = x2 + b_dist;
var by2 = y2 + b_dist;

draw_set_color(merge_color(make_color_rgb(85, 100, 90), make_color_rgb(255, 180, 60), hover_val));
draw_set_alpha(0.6 + hover_val * 0.4);

// Draw lines
draw_line_width(bx1, by1, bx1 + b_len, by1, 1.5);
draw_line_width(bx1, by1, bx1, by1 + b_len, 1.5);
draw_line_width(bx2, by1, bx2 - b_len, by1, 1.5);
draw_line_width(bx2, by1, bx2, by1 + b_len, 1.5);
draw_line_width(bx1, by2, bx1 + b_len, by2, 1.5);
draw_line_width(bx1, by2, bx1, by2 - b_len, 1.5);
draw_line_width(bx2, by2, bx2 - b_len, by2, 1.5);
draw_line_width(bx2, by2, bx2, by2 - b_len, 1.5);

// 5. Centered Text with Soft Depth Shadow
var tx = (x1 + x2) / 2;
var ty = (y1 + y2) / 2;

draw_set_font(global.Font);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_text(tx + 1, ty + 1, button_text); // shadow

var text_color = merge_color(make_color_rgb(205, 215, 210), make_color_rgb(255, 210, 100), hover_val);
draw_set_color(text_color);
draw_set_alpha(1.0);
draw_text(tx, ty, button_text);

draw_set_alpha(1.0);
draw_set_color(c_white);
