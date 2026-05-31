/// @description Draw Bomb and ground impact indicator
// 1. Draw a warning indicator at the landing zone for visual feedback
var draw_col = c_red;
var draw_rad = 140;
var alpha_mult = 1.0;

if (is_artillery) {
    draw_col = c_yellow;
    draw_rad = 35;
} else {
    if (bomb_type == 0) {
        draw_col = c_red;
        draw_rad = 140;
    } else if (bomb_type == 1) {
        draw_col = c_aqua;
        draw_rad = 50;
    } else if (bomb_type == 2) {
        draw_col = c_lime;
        draw_rad = 75;
    } else if (bomb_type == 3) {
        draw_col = make_color_rgb(180, 0, 200); // Purple
        draw_rad = 200;
        alpha_mult = 1.5; // Make R TNT more visible
    }
}

draw_set_color(draw_col);
draw_set_alpha(0.12 * alpha_mult);
draw_circle(target_x, target_y, draw_rad, false);
draw_set_alpha(0.35 * alpha_mult);
draw_circle(target_x, target_y, draw_rad, true);

// Reset drawing settings
draw_set_color(c_white);
draw_set_alpha(1.0);

// 2. Draw bomb/shell sprite itself
draw_self();
