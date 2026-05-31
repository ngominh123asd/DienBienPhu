/// @description Init Bomb / Artillery Shell
target_x = x;
target_y = y;
start_x = x;
start_y = y;

is_artillery = false; // Set to true for arcing artillery shells
t = 0;
max_t = 45; // Shell flight duration (45 frames = 0.75s)

// Visual properties
image_xscale = 1.5;
image_yscale = 1.5;
image_angle = 180; // Default falling downwards
depth = -y - 500;

bomb_type = 0; // 0: Q (Air Bomb), 1: W (Flak), 2: E (Katyusha), 3: R (TNT)
