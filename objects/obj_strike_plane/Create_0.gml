/// @description Init Air Strike Plane
speed = 14;
direction = 0;      // Flying to the right
image_angle = 270;  // Rotate to face right

target_x = x;
target_y = y;

bombs_dropped = 0;
bomb_timer = 0;
bomb_interval = 9;  // Frame interval between bomb drops
max_bombs = 5;

depth = -9999;      // Fly above everything in the room

// Scale the plane nicely
image_xscale = 0.5;
image_yscale = 0.5;
