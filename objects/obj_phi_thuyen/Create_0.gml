image_angle=180

hp = 7;
max_hp = 7;
alive = true;

is_immune = false;

won = false;
time_played = 0;

bullet_upgrade = false;
level_wave = 1;
wave_announcement_timer = 0;

kamikaze_mode = false;
kamikaze_charging = false;
kamikaze_ready = false;
kamikaze_won = false;
wave_countdown = -1;
next_wave = 1;
shoot_cooldown = 0;
kamikaze_cleaned = false; // flag to clean projectiles once
kamikaze_exploded = false; // flag to hide sprite on impact
