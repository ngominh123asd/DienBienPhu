// Draw a beautiful pulsing, rotating gold star power-up with neon green/aqua outer glow!
var pulse = sin(current_time * 0.008) * 0.15 + 0.85; // pulses between 0.70 and 1.00
var rot = current_time * 0.05;

// Outer soft neon green/gold glow
draw_set_alpha(0.3 * pulse);
draw_circle_color(x, y, 22, c_lime, c_yellow, false);

// Outer rotating light ring
draw_set_alpha(0.5 * pulse);
draw_circle_color(x, y, 14, c_yellow, c_white, true);

// Inner core
draw_set_alpha(0.9);
draw_circle_color(x, y, 8, c_white, c_yellow, false);

// Rotating golden-neon cross spikes
for (var i = 0; i < 4; i++) {
    var angle = rot + i * 90;
    var px1 = x + lengthdir_x(4, angle);
    var py1 = y + lengthdir_y(4, angle);
    var px2 = x + lengthdir_x(18 * pulse, angle);
    var py2 = y + lengthdir_y(18 * pulse, angle);
    draw_line_width_color(px1, py1, px2, py2, 3, c_white, c_yellow);
}

// Reset alpha
draw_set_alpha(1.0);
