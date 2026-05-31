/// @description Init

X1 = mouse_x;
Y1 = mouse_y;
X2 = mouse_x;
Y2 = mouse_y;

depth = -y;
CanClick = 0;
Dragging = 0;
alarm[0] = 1;

TimePlayed = 0;

// ================= DIEN BIEN PHU MECHANICS =================
// 1. Air Strike & Tactical Skills (Q, W, E, R keys)
bomb_cooldown = 0;
bomb_max_cooldown = 3600; // 1 minute (3600 frames)

w_cooldown = 0;
w_max_cooldown = 1800; // 30 seconds (1800 frames)

e_cooldown = 0;
e_max_cooldown = 2700; // 45 seconds (2700 frames)

r_cooldown = 0;
r_max_cooldown = 5400; // 90 seconds (5400 frames)

targeting_active = false; // Legacy (for Q aiming)
targeting_mode = 0; // 0: None, 1: Q, 2: W, 3: E, 4: R

// Salvo queues
katyusha_queue = [];

// 2. Camera screen shake
screen_shake = 0;

// 3. Dynamic Weather & Monsoon Mud System
weather_timer = 0;
weather_state = 0; // 0: Sunny, 1: Rainy (Monsoon Mud)
weather_duration = 1800; // 30 seconds at 60 FPS

// Initialize screen-space rain streaks
rain_drops = [];
for (var i = 0; i < 80; i++) {
    array_push(rain_drops, {
        x: irandom(1280),
        y: irandom(720),
        len: irandom_range(15, 30),
        spd: irandom_range(12, 18)
    });
}