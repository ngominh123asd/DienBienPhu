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

// 1.5. Sidequest & Historical Challenge (Q, W, E, R locks & debuffs)
sidequest_open = false;
sidequest_current_question = -1; // -1 for main selection, 0-3 for Q,W,E,R challenges

skill_q_unlocked = false;
skill_w_unlocked = false;
skill_e_unlocked = false;
skill_r_unlocked = false;

question_status = [-1, -1, -1, -1]; // -1: Not started, 0: Failed (Got debuff, can retry), 1: Cleared (Unlocked)

// Debuff penalty system
debuff_active = false;
debuff_timer = 0;
debuff_type = ""; // "radar_jam", "mud_slow", "ammo_shortage", "enemy_rage"

// Historical questions struct array
sidequest_questions = [
    {
        q: "Ai là Tổng Tư lệnh kiêm Bí thư Đảng ủy chỉ huy chiến dịch Điện Biên Phủ?",
        a: ["A. Tướng Văn Tiến Dũng", "B. Đại tướng Võ Nguyên Giáp", "C. Tướng Nguyễn Chí Thanh", "D. Tướng Hoàng Văn Thái"],
        correct: 1
    },
    {
        q: "Người anh hùng nào đã lấy thân mình lấp lỗ châu mai trong trận Him Lam?",
        a: ["A. Phan Đình Giót", "B. Tô Vĩnh Diện", "C. Bế Văn Đàn", "D. Trần Can"],
        correct: 0
    },
    {
        q: "Ai là người anh hùng đã dũng cảm lấy thân mình chèn bánh pháo để cứu pháo?",
        a: ["A. Bế Văn Đàn", "B. Phan Đình Giót", "C. Tô Vĩnh Diện", "D. La Văn Cầu"],
        correct: 2
    },
    {
        q: "Quả bộc phá 930kg nổ tại đồi A1 vào đêm ngày nào để mở đường cho ta tổng tiến công?",
        a: ["A. Đêm 06/05/1954", "B. Đêm 07/05/1954", "C. Đêm 05/05/1954", "D. Đêm 01/05/1954"],
        correct: 0
    }
];


// Salvo queues
katyusha_queue = [];

// 2. Camera screen shake
screen_shake = 0;

// 3. Dynamic Weather & Monsoon Mud System
weather_timer = 0;
weather_state = 0; // 0: Sunny, 1: Rainy (Monsoon Mud), 2: Stormy (Thunderstorm)
weather_duration = 1800; // 30 seconds at 60 FPS

// Lightning state machine
lightning_active = false;
lightning_alpha = 0;

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