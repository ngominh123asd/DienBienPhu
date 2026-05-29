/// @description Step Control

if (won) {
    speed = 0;
    
    // Victory keys
    if (keyboard_check_pressed(vk_enter)) {
        room_goto(rmTitle);
    }
    if (keyboard_check_pressed(ord("R"))) {
        room_restart();
    }
    exit;
}

if (!alive) {
    speed = 0;
    
    // Game Over keys
    if (keyboard_check_pressed(ord("R"))) {
        room_restart();
    }
    if (keyboard_check_pressed(vk_escape)) {
        room_goto(rmTitle);
    }
    exit;
}

// Increment timer while active
if (alive && !won) {
    time_played += 1;
    if (instance_number(obj_ke_dich) == 0) {
        won = true;
    }
}

// Vertical movement
if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
    y -= 5; // standard speed is 5
}
else if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
    y += 5;
}

// Keep inside screen boundaries
x = clamp(x, 40, room_width - 40);
y = clamp(y, 100, room_height - 60);