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

// 1.5. RESTRICTED SIDEQUEST SYSTEM: 3 Chapters based on actual Điện Biên Phủ campaign
sidequest_open = false;
sidequest_current_chapter = -1; // -1: Chapter List, 0: Chapter 1, 1: Chapter 2, 2: Chapter 3
sidequest_current_question = -1; // -1: Inside Chapter Menu, 0-2: Question Index

// Tracks question state for 3 chapters, 3 questions each
// -1: Unsolved, 0: Failed (Got debuff), 1: Cleared
chapter_questions_status = [
    [-1, -1, -1], // Chapter 1 (Phase 1)
    [-1, -1, -1], // Chapter 2 (Phase 2)
    [-1, -1, -1]  // Chapter 3 (Phase 3)
];

// Unlocks & Hero focused variables
skill_q_unlocked = false;
skill_w_unlocked = false;
skill_e_unlocked = false;
skill_r_unlocked = false;

focused_hero = noone; // Currently active/selected hero (tab target)

chapter_upgrade_power = false; // Chapter 2 Upgrade (+50% Power)
chapter_upgrade_stats = false; // Chapter 3 Upgrade (+80% MaxHP, +50% Spd, +50% AttackSpeed)
invincible_timer = 0;          // Invincibility buff frame counter (5s = 300 frames)

// Debuff penalty system
debuff_active = false;
debuff_timer = 0;
debuff_type = ""; // "radar_jam", "mud_slow", "ammo_shortage", "enemy_rage"

// Historical database of 3 Chapters
sidequest_chapters = [
    {
        name: "CHƯƠNG I: ĐỢT TIẾN CÔNG THỨ NHẤT",
        sub: "Tiêu diệt cứ điểm Him Lam - Độc Lập - Bản Kéo (13/03 - 17/03/1954)",
        reward_txt: "Mở khóa R: Không Kích, T: Phòng Không & Chi viện Tướng Phan Đình Giót",
        questions: [
            {
                q: "Đợt tiến công thứ nhất của quân ta vào tập đoàn cứ điểm Điện Biên Phủ bắt đầu vào ngày nào?",
                a: ["A. Ngày 13/03/1954", "B. Ngày 11/03/1954", "C. Ngày 15/03/1954", "D. Ngày 07/05/1954"],
                correct: 0
            },
            {
                q: "Trận mở màn chiến dịch Điện Biên Phủ, quân ta đã tiêu diệt trung tâm đề kháng nào của địch?",
                a: ["A. Cứ điểm Bản Kéo", "B. Cứ điểm Him Lam", "C. Phân khu Nam (Hồng Cúm)", "D. Cứ điểm Đồi A1"],
                correct: 1
            },
            {
                q: "Người anh hùng nào đã lấy thân mình lấp lỗ châu mai trong trận mở màn Him Lam?",
                a: ["A. Tô Vĩnh Diện", "B. Bế Văn Đàn", "C. Phan Đình Giót", "D. Trần Can"],
                correct: 2
            }
        ]
    },
    {
        name: "CHƯƠNG II: ĐỢT TIẾN CÔNG THỨ HAI",
        sub: "Tiến công đồi phía Đông & giằng co ác liệt đồi A1 (30/03 - 30/04/1954)",
        reward_txt: "Mở khóa Y: Hỏa Tiễn & Chi viện Tướng Bế Văn Đàn + Tăng 50% Công Lính",
        questions: [
            {
                q: "Đợt tiến công thứ hai bắt đầu vào thời gian nào và tập trung vào phân khu trọng điểm nào?",
                a: ["A. Ngày 30/03/1954 - Các đồi phía Đông", "B. Ngày 13/03/1954 - Cứ điểm Him Lam", "C. Ngày 01/05/1954 - Cứ điểm đồi A1", "D. Ngày 07/05/1954 - Hầm De Castries"],
                correct: 0
            },
            {
                q: "Trận chiến cứ điểm nào giằng co ác liệt và kéo dài nhất trong đợt tiến công thứ hai?",
                a: ["A. Cứ điểm Đồi D1", "B. Cứ điểm Đồi C1", "C. Cứ điểm Đồi A1", "D. Cứ điểm Đồi E1"],
                correct: 2
            },
            {
                q: "Người chiến sĩ anh hùng nào đã dũng cảm lấy vai làm giá súng tại Mường Pồn?",
                a: ["A. La Văn Cầu", "B. Bế Văn Đàn", "C. Tô Vĩnh Diện", "D. Phan Đình Giót"],
                correct: 1
            }
        ]
    },
    {
        name: "CHƯƠNG III: ĐỢT TỔNG CÔNG KÍCH BÊN TA",
        sub: "Tổng tiến công đồi A1 bằng bộc phá 930kg, bắt sống tướng De Castries (01/05 - 07/05/1954)",
        reward_txt: "Mở khóa U: Bộc Phá & Đội Quân Cuồng Nộ (+80% HP, +50% Tốc, Bất Tử 5s)",
        questions: [
            {
                q: "Để quyết định tiêu diệt đồi A1, quân ta đã cho nổ quả bộc phá nặng bao nhiêu kg và vào đêm nào?",
                a: ["A. 930 kg - Đêm 06/05/1954", "B. 500 kg - Đêm 05/05/1954", "C. 1000 kg - Đêm 07/05/1954", "D. 200 kg - Đêm 01/05/1954"],
                correct: 0
            },
            {
                q: "Lá cờ Quyết chiến Quyết thắng của quân ta tung bay trên nóc hầm tướng De Castries vào ngày nào?",
                a: ["A. Ngày 07/05/1954", "B. Ngày 19/05/1954", "C. Ngày 02/09/1945", "D. Ngày 30/04/1975"],
                correct: 0
            },
            {
                q: "Tên tướng chỉ huy quân thực dân Pháp tại Điện Biên Phủ bị quân ta bắt sống là ai?",
                a: ["A. Tướng Navarre", "B. Tướng De Castries (Đờ Cát)", "C. Tướng Cogny", "D. Tướng Salan"],
                correct: 1
            }
        ]
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

// ================= LOCATION ZONE SYSTEM =================
// Defines map zones with bounds, names, and story text
loc_zones = [
    {
        x1: 30, y1: 60, x2: 280, y2: 480,
        name: "CỤM CỨ ĐIỂM HIM LAM",
        story: "Ngày 13/03/1954, quân ta nổ súng mở màn chiến dịch. Trung đoàn 141 và 209 đồng loạt tấn công cứ điểm Him Lam. Anh hùng Phan Đình Giót đã lấy thân mình lấp lỗ châu mai, mở đường cho đồng đội xông lên tiêu diệt cứ điểm."
    },
    {
        x1: 400, y1: 300, x2: 850, y2: 600,
        name: "SÂN BAY MƯỜNG THANH",
        story: "Sân bay Mường Thanh là huyết mạch tiếp tế duy nhất của quân Pháp tại Điện Biên Phủ. Quân ta đào hào vây lấn, pháo binh bắn phá liên tục khiến sân bay tê liệt hoàn toàn, cắt đứt đường tiếp viện của địch."
    },
    {
        x1: 700, y1: 60, x2: 1100, y2: 250,
        name: "TẬP ĐOÀN CỨ ĐIỂM",
        story: "Tập đoàn cứ điểm Điện Biên Phủ gồm 49 cứ điểm liên hoàn, chia thành 8 cụm, do tướng De Castries chỉ huy với hơn 16.000 quân. Thực dân Pháp coi đây là \"pháo đài bất khả xâm phạm\" ở Đông Dương."
    }
];

// Zone popup animation state
loc_zone_current = -1;     // Index of current zone (-1 = none)
loc_zone_prev = -1;        // Previous zone to detect transitions
loc_zone_alpha = 0;        // Popup fade alpha (0 to 1)
loc_zone_timer = 0;        // How long popup has been showing
loc_zone_show_duration = 360; // Show for 6 seconds (360 frames)
loc_zone_visited = [false, false, false]; // Track if already visited