/// @description Boss Init
event_inherited();

// HP
MaxHp = 200;
CurHp = 200;

// Chặn Parent tự động đổi HP theo thời gian
UpgradedTo100 = true;
UpgradedTo150 = true;

// Combat properties
AttackDelay = room_speed * 0.5; // Kỹ năng 3: Liên thanh (thay vì 2 giây như lô cốt thường)
RapidAttackTimer = AttackDelay;
Power = 5; 

// Kỹ năng 1: Khiên chắn (Shield)
ShieldActive = false;
ShieldCooldown = room_speed * 10;
ShieldDuration = room_speed * 3;
ShieldTimer = room_speed * 2; // Kích hoạt sớm lần đầu để dễ nhìn thấy

// Phan Văn Giót event
DisabledFirepower = false; 
PhanVanGiotTriggered = false;

// Kỹ năng 2: Bắn chùm (Spread Fire)
SpreadCooldown = room_speed * 4;
SpreadTimer = SpreadCooldown;

// Tự quản lý sinh lính thay cho parent
BossSpawnTimer = SpawnDelay;
alarm[2] = -1; // Vô hiệu hóa báo thức sinh lính của parent

// Đổi kích thước Boss cho vừa vặn hơn với map
image_xscale = 0.08; 
image_yscale = 0.08;

