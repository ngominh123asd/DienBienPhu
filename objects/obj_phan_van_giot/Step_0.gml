if (!instance_exists(TargetBoss)) {
    instance_destroy();
    exit;
}

if (!Jumped) {
    if (distance_to_point(DestX, DestY) > Spd) {
        move_towards_point(DestX, DestY, Spd);
        // Lật mặt
        if (hspeed > 0) sprite_index = sFr_Soldier01;
        else if (hspeed < 0) sprite_index = sFr_Soldier01_left;
    } else {
        speed = 0;
        Jumped = true;
        // Bay lên lấp lỗ châu mai
        y -= 25;
        image_speed = 0;
        image_index = 0;
        
        // Vô hiệu hóa boss
        TargetBoss.DisabledFirepower = true;
        
        // Hiệu ứng chữ
        var fx = instance_create_layer(x, y - 40, "Instances", oFx_ConvertText);
        fx.Text = "Phan Văn Giót lấp lỗ châu mai!";
        fx.image_blend = c_red;
        fx.life_timer = room_speed * 4;
    }
}
