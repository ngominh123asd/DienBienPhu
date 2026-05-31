/// @description Draw heart aligned with collision mask
var base_scale = 0.07;
var pulse = sin(current_time * 0.012) * 0.005;
var final_scale = base_scale + pulse;

draw_sprite_ext(sprite_index, 0, x, y, final_scale, final_scale, 0, c_white, 1.0);
