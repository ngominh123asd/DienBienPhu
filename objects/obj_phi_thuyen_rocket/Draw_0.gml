/// @description Draw rocket with engine flame

// 1. Draw rocket exhaust engine flame
var flame_scale = 0.5 + sin(current_time * 0.05) * 0.1;
gpu_set_blendmode(bm_add);
draw_sprite_ext(sEn_DragonFire, 0, x - lengthdir_x(10, direction), y - lengthdir_y(10, direction), 0.45 * flame_scale, 0.45 * flame_scale, direction + 180, c_yellow, 0.95);
gpu_set_blendmode(bm_normal);

// 2. Draw rocket body (oriented with direction)
draw_sprite_ext(sFx_Arrow, 0, x, y, 1.3, 1.3, direction - 90, c_red, 1.0);
// Draw small tip highlighting
draw_sprite_ext(sFx_Arrow, 0, x, y, 0.7, 0.7, direction - 90, c_yellow, 0.9);
