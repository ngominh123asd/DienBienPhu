/// @description Init

image_index = irandom(image_number-1);
alarm[0] = room_speed;

speed = 0.05;
direction = irandom(359);

CanMove = 0;

// Hardcoded scale to make the 640x640 sprite reasonable (e.g. ~10x10 pixels)
image_xscale = 0.015;
image_yscale = 0.015;