/// @description Skill Q (Anh Hùng)

if (!variable_instance_exists(self, "IsHero") || !IsHero) exit;

if (HeroName == "Phan Đình Giót") {
    // Check cooldown
    if (skill_cooldowns[0] > 0) exit;
    
    // Q - Bom Xăng: Ném bom xăng tại mouse_x, mouse_y.
    // Tạo oAtt_PlayerFire với tỷ lệ phóng đại image_xscale = 4, image_yscale = 4, sát thương Power * 1.5.
    // Tạo hiệu ứng khói/lửa ef_smoke & ef_ring. Kích hoạt cooldown.
    
    var tx = mouse_x;
    var ty = mouse_y;
    
    var fire = instance_create_layer(tx, ty, "Instances", oAtt_PlayerFire);
    if (fire != noone) {
        fire.Power = Power * 1.5;
        fire.image_xscale = 4;
        fire.image_yscale = 4;
    }
    
    effect_create_above(ef_smoke, tx, ty, 1.2, c_gray);
    effect_create_above(ef_ring, tx, ty, 1.0, c_orange);
    
    skill_cooldowns[0] = skill_max_cooldowns[0];
    
    // Notification
    var txt = instance_create_layer(x, y, "Instances", oFx_ConvertText);
    if (txt != noone) {
        txt.Parent = id;
        txt.Text = "BOM XĂNG!";
    }
} 
else if (HeroName == "Bế Văn Đàn") {
    // Check cooldown
    if (skill_cooldowns[0] > 0) exit;
    
    // Q - Mưa Tên Lửa: Bắn loạt 5 mũi tên lửa hình nón (Góc chênh lệch -30, -15, 0, 15, 30 độ) hướng về chuột
    // bằng cách tạo các đối tượng oAtt_PlayerFire bay với tốc độ 8, sát thương Power * 1.2.
    
    var mouse_dir = point_direction(x, y, mouse_x, mouse_y);
    var angles = [-30, -15, 0, 15, 30];
    for (var i = 0; i < 5; i++) {
        var angle = mouse_dir + angles[i];
        var proj = instance_create_layer(x, y, "Instances", oAtt_PlayerFire);
        if (proj != noone) {
            proj.Power = Power * 1.2;
            proj.direction = angle;
            proj.speed = 8;
            proj.image_angle = angle;
            proj.alarm[0] = 60; // Travel range (1 second at 60fps)
        }
    }
    
    skill_cooldowns[0] = skill_max_cooldowns[0];
    
    // Notification
    var txt = instance_create_layer(x, y, "Instances", oFx_ConvertText);
    if (txt != noone) {
        txt.Parent = id;
        txt.Text = "MƯA TÊN LỬA!";
    }
}
