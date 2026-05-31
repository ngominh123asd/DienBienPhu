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

// Monologue for pilot's sacrifice
monologue_texts = [
    "Báo cáo Chỉ huy Trung đoàn... Phi thuyền của tôi đã cạn sạch đạn dược hoàn toàn...",
    "Động cơ bên trái đang bốc cháy dữ dội... Máy bay mất kiểm soát, không thể quay về căn cứ...",
    "Phía dưới kia... là Điện Biên Phủ thân yêu... là đồng bào, đồng chí đang kề vai sát cánh chiến đấu...",
    "Và phía sau tôi... là quê hương yêu dấu, là bố mẹ, là người vợ trẻ hiền hậu đang ngóng trông tin thắng trận...",
    "Bố mẹ ơi, vợ con ơi... Con xin lỗi... Lần này con phải lỗi hẹn bữa cơm chiều mất rồi...",
    "Nhưng nếu sự hy sinh này có thể dẹp tan Siêu chiến hạm địch, giành lại bầu trời tự do cho Tổ quốc...",
    "Thì con xin nguyện dâng hiến cả tính mạng và xương máu này! Quyết tử cho Tổ quốc quyết sinh!",
    "Vĩnh biệt quê hương yêu dấu! Hãy chiến đấu và chiến thắng! Điện Biên Phủ muôn năm!!!"
];
monologue_index = 0;
monologue_char_count = 0;
monologue_char_speed = 0.45; // chars per frame
monologue_completed = false;

// Juicy Juice VFX / Screen Shake State
screen_shake = 0;
crash_flash = 0;

// Initialize position queue for rocket exhaust flames
for (var i = 0; i < 6; i++) {
    trail_x[i] = x;
    trail_y[i] = y;
}

// Wave dialogue controller variable
wave_dialog_index = -1;

