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

// Shop / Upgrades State variables
state = "play"; // States: "play", "withdraw", "shop", "reenter"
gold = 50; // Starting gold
wrench_purchased = false; // Must purchase wrench each shop visit to continue
has_rocket = false; // Q to launch homing rocket
has_autofire = false; // Auto firing support
autofire_active = false; // Is auto fire enabled
has_steel_roll = false; // Takes 0.5 hearts damage instead of 1
shield_charges = 0; // Blocks up to 3 hits
move_speed = 7; // Upgradable speed (replaces hardcoded 7)
shoot_cooldown_val = 10; // Firing rate cooldown (reduced by fast loader)
rocket_cooldown = 0; // Cooldown between rocket shots
session_purchases = [0, 0, 0, 0]; // Tracks current session purchases for refunding
selected_item = 0; // Currently selected item (0 = Wrench by default)
hp_before_shop = hp;
shield_charges_before_shop = 0;

// Load shop sprites programmatically
shop_sprite = -1;
part_sprites = array_create(4, -1);

if (file_exists("shop.jpg")) {
    shop_sprite = sprite_add("shop.jpg", 1, false, false, 0, 0);
} else if (file_exists(working_directory + "shop.jpg")) {
    shop_sprite = sprite_add(working_directory + "shop.jpg", 1, false, false, 0, 0);
}

for (var i = 0; i < 4; i++) {
    var fn = "part_0" + string(i+1) + ".png";
    var spr = -1;
    if (file_exists(fn)) {
        spr = sprite_add(fn, 1, false, false, 0, 0);
    } else if (file_exists(working_directory + fn)) {
        spr = sprite_add(working_directory + fn, 1, false, false, 0, 0);
    }
    part_sprites[i] = spr;
    if (spr != -1) {
        sprite_set_offset(spr, sprite_get_width(spr) / 2, sprite_get_height(spr) / 2);
    }
}


// Item specifications
item_names = [
    "Cờ Lê Sửa Chữa",
    "Tên Lửa Tầm Nhiệt",
    "Khiên Năng Lượng",
    "Đại Bác Liên Thanh"
];

item_descs = [
    "Sửa chữa khẩn cấp! Hồi phục đầy máu để cất cánh tiếp tục trận đấu.",
    "Tuyệt chiêu: Nhấn Q để phóng tên lửa tầm nhiệt truy đuổi kẻ địch.",
    "Tạo lá chắn từ trường chặn hoàn toàn 3 đòn sát thương.",
    "Hệ thống bắn tự động: Nhấn E để BẬT/TẮT tự động xả đạn la-ze."
];

item_costs = [100, 80, 60, 50];
item_levels = [0, 0, 0, 0];
item_max_levels = [99, 1, 1, 1]; // Max levels for each item

// Campaign quiz system (GIẢI MÃ TÌNH BÁO)
quiz_open = false;
quiz_current_question = -1; // -1: Question Menu list, 0-4: Question Index
quiz_questions_status = [-1, -1, -1, -1, -1]; // -1: Unsolved, 1: Solved
quiz_reward_value = 60; // 60 gold reward per correct answer

quiz_questions = [
    {
        q: "Chiến dịch Điện Biên Phủ trên không diễn ra vào thời gian nào?",
        a: ["A. Từ 18/12 đến 30/12/1972", "B. Từ 12/12 đến 24/12/1972", "C. Từ 18/12 đến 30/12/1954", "D. Từ 30/04 đến 07/05/1975"],
        correct: 0
    },
    {
        q: "Loại máy bay ném bom chiến lược nào của đế quốc Mỹ được sử dụng chủ lực trong chiến dịch này?",
        a: ["A. Pháo đài bay B-52", "B. Tiêm kích F-4 Phantom", "C. Máy bay trinh sát SR-71", "D. Cường kích A-7 Corsair"],
        correct: 0
    },
    {
        q: "Người phi công vũ trụ anh hùng nào là người đầu tiên bắn rơi siêu máy bay B-52 bằng MiG-21?",
        a: ["A. Anh hùng Phạm Tuân", "B. Anh hùng Nguyễn Văn Cốc", "C. Anh hùng Vũ Xuân Thiều", "D. Anh hùng Bùi Thanh Liêm"],
        correct: 0
    },
    {
        q: "Anh hùng phi công Vũ Xuân Thiều đã lập chiến công bắn hạ siêu máy bay B-52 như thế nào?",
        a: ["A. Phóng tên lửa tầm nhiệt rồi quay về", "B. Dũng cảm lao thẳng máy bay của mình vào tiêu diệt địch", "C. Dùng pháo la-ze của phi thuyền la-ze", "D. Gọi pháo phòng không mặt đất chi viện"],
        correct: 1
    },
    {
        q: "Quân và dân ta đã bắn rơi bao nhiêu máy bay ném bom chiến lược B-52 trong 12 ngày đêm lịch sử?",
        a: ["A. 34 chiếc B-52", "B. 12 chiếc B-52", "C. 81 chiếc B-52", "D. 50 chiếc B-52"],
        correct: 0
    }
];


