/// @description Init

image_index = irandom(image_number-1);
alarm[0] = room_speed;

speed = 0.05;
direction = irandom(359);

CanMove = 0;

// Scale down the sprite so it fits perfectly in the room (e.g., 24x24 pixels)
var target_size = 24;
image_xscale = target_size / sprite_get_width(sprite_index);
image_yscale = target_size / sprite_get_height(sprite_index);