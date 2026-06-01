/// @description Skill W (Anh Hùng)

if (!variable_instance_exists(self, "IsHero") || !IsHero) exit;

if (HeroName == "Phan Đình Giót") {
    // Check cooldown
    if (skill_cooldowns[1] > 0) exit;
    
    // W - Xung Phong: Lướt tới chuột (khoảng cách tối đa 150px). Đặt DestX = x, DestY = y.
    // Gây sát thương Power * 2.5 lên tất cả oPar_Enemy trong tầm 80px lân cận, tạo hiệu ứng vòng tròn ef_ring.
    
    var dir = point_direction(x, y, mouse_x, mouse_y);
    var dist = min(150, point_distance(x, y, mouse_x, mouse_y));
    
    var tx = x + lengthdir_x(dist, dir);
    var ty = y + lengthdir_y(dist, dir);
    
    // Check collision along the way
    if (!place_meeting(tx, ty, oPar_Collidable)) {
        x = tx;
        y = ty;
    } else {
        // Move as far as possible
        for (var d = dist; d > 0; d -= 10) {
            var temp_x = x + lengthdir_x(d, dir);
            var temp_y = y + lengthdir_y(d, dir);
            if (!place_meeting(temp_x, temp_y, oPar_Collidable)) {
                x = temp_x;
                y = temp_y;
                break;
            }
        }
    }
    
    DestX = x;
    DestY = y;
    
    // Apply Damage to enemies
    with (oPar_Enemy) {
        if (point_distance(x, y, other.x, other.y) <= 80) {
            CurHp -= other.Power * 2.5;
            image_blend = global.HurtCol;
            alarm[1] = UnhurtDelay;
            effect_create_above(ef_smoke, x, y, 0.4, c_red);
        }
    }
    
    // Also damage bunkers (oPar_locot / obj_locot_boss) in range!
    with (oPar_locot) {
        if (point_distance(x, y, other.x, other.y) <= 80) {
            CurHp -= other.Power * 2.5;
            image_blend = global.HurtCol;
            alarm[1] = UnhurtDelay;
        }
    }
    with (obj_locot_boss) {
        if (point_distance(x, y, other.x, other.y) <= 80) {
            CurHp -= other.Power * 2.5;
            image_blend = global.HurtCol;
            alarm[1] = UnhurtDelay;
        }
    }
    
    effect_create_above(ef_ring, x, y, 0.8, c_red);
    
    skill_cooldowns[1] = skill_max_cooldowns[1];
    
    // Notification
    var txt = instance_create_layer(x, y, "Instances", oFx_ConvertText);
    if (txt != noone) {
        txt.Parent = id;
        txt.Text = "XUNG PHONG!";
    }
} 
else if (HeroName == "Bế Văn Đàn") {
    // Check cooldown
    if (skill_cooldowns[1] > 0) exit;
    
    // W - Giá Súng: Đặt biến đếm vanguard_timer = 480 (8 giây).
    // Đứng im, tăng thủ, tăng range bắn (AttackDist) handled dynamically in Step.
    
    vanguard_timer = 480;
    
    // Stop immediately
    DestX = x;
    DestY = y;
    
    skill_cooldowns[1] = skill_max_cooldowns[1];
    
    // Notification
    var txt = instance_create_layer(x, y, "Instances", oFx_ConvertText);
    if (txt != noone) {
        txt.Parent = id;
        txt.Text = "GIÁ SÚNG!";
    }
}
