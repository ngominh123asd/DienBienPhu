/// @description Skill E (Anh Hùng)

if (!variable_instance_exists(self, "IsHero") || !IsHero) exit;

if (HeroName == "Phan Đình Giót") {
    // Check cooldown
    if (skill_cooldowns[2] > 0) exit;
    
    // E - Ý Chí Thép: Hồi máu CurHp = min(MaxHp, CurHp + floor(MaxHp * 0.5)).
    // Phát hiệu ứng spark ef_spark cho đồng minh xung quanh dưới tầm 200px.
    
    CurHp = min(MaxHp, CurHp + floor(MaxHp * 0.5));
    
    with (oPar_PlayerUnit) {
        if (point_distance(x, y, other.x, other.y) <= 200) {
            effect_create_above(ef_spark, x, y, 0.6, c_orange);
        }
    }
    
    skill_cooldowns[2] = skill_max_cooldowns[2];
    
    // Notification
    var txt = instance_create_layer(x, y, "Instances", oFx_ConvertText);
    if (txt != noone) {
        txt.Parent = id;
        txt.Text = "Ý CHÍ THÉP!";
    }
} 
else if (HeroName == "Bế Văn Đàn") {
    // Check cooldown
    if (skill_cooldowns[2] > 0) exit;
    
    // E - Lá Chắn: Đặt biến đếm shield_timer = 360 (6 giây).
    // Trong Step, giảm sát thương nhận vào 50% cho đồng minh đứng gần dưới tầm 200px.
    
    shield_timer = 360;
    
    skill_cooldowns[2] = skill_max_cooldowns[2];
    
    // Notification
    var txt = instance_create_layer(x, y, "Instances", oFx_ConvertText);
    if (txt != noone) {
        txt.Parent = id;
        txt.Text = "LÁ CHẮN!";
    }
}
