/// @description Draw bunker & selection indicator
draw_self();

if (Selected) {
    draw_set_color(c_aqua);
    draw_set_alpha(0.4);
    draw_ellipse(bbox_left - 2, bbox_bottom - 4, bbox_right + 2, bbox_bottom + 4, true);
    draw_set_alpha(1.0);
}
