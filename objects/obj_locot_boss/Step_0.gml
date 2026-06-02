/// @description Boss Logic

// Luôn khóa chức năng bắn mặc định của parent (do tầm bắn quá ngắn và ta tự xử lý hỏa lực ở dưới)
CanAttack = 0;

// 1. Logic Phan Văn Giót
if (CurHp <= 180 && !PhanVanGiotTriggered && CurHp > 0) {
    if (VideoState == 0 && !VideoFinished) {
        VideoState = 1; // Start fade out
        // Pause all units
        instance_deactivate_object(oPar_PlayerUnit);
        instance_deactivate_object(oPar_Enemy);
        VideoPausedEntities = true;
        
        // Mute/Fade out music (1500ms = 1.5s)
        audio_sound_gain(bgmGameRoom, 0, 1500);
    }
}

// State Machine cho Video
if (VideoState > 0) {
    if (VideoState == 1) {
        // Fading out
        VideoAlpha += 0.02;
        if (VideoAlpha >= 1) {
            VideoAlpha = 1;
            VideoState = 2; // Play video
            VideoPlaying = true;
            video_open("0531.mp4");
        }
    } 
    else if (VideoState == 2 && VideoPlaying) {
        var pos = video_get_position();
        var dur = video_get_duration();
        if (video_get_status() == video_status_closed || (pos > 0 && dur > 0 && pos >= dur - 100)) {
            video_close();
            VideoPlaying = false;
            VideoState = 3; // Fade in
            // Unmute/Fade in music
            audio_sound_gain(bgmGameRoom, 1, 1500);
        }
    }
    else if (VideoState == 3) {
        // Fading in
        VideoAlpha -= 0.02;
        if (VideoAlpha <= 0) {
            VideoAlpha = 0;
            VideoState = 0; // Finished
            VideoFinished = true;
            
            // Khôi phục lại các units đã bị đóng băng
            if (VideoPausedEntities) {
                instance_activate_object(oPar_PlayerUnit);
                instance_activate_object(oPar_Enemy);
                VideoPausedEntities = false;
            }
            
            // Sinh ra Phan Văn Giót
            PhanVanGiotTriggered = true;
            var Giot = instance_create_layer(x + (sprite_width/2), y + sprite_height + 50, "Instances", obj_phan_van_giot);
            Giot.TargetBoss = id;
            Giot.DestX = x + (sprite_width/2);
            Giot.DestY = y + (sprite_height/2);
        }
    }
    
    // Ngừng chạy logic của Boss trong lúc chuyển cảnh / chiếu video
    exit;
}

// Thực thi logic của Parent (xử lý chết, HP)
event_inherited();

// Tự xử lý sinh lính thay vì dùng parent alarm
BossSpawnTimer--;
if (BossSpawnTimer <= 0) {
    for (var i = 0; i < 3; i++) { // Boss sinh 3 lính
        var EnemyType = irandom(2);
        var CenterX = x + (sprite_width / 2);
        var SpawnX = CenterX + irandom_range(-50, 50);
        var SpawnY = y + sprite_height + irandom_range(10, 40); // Sinh lính ở dưới chân boss

        effect_create_above(ef_smoke, SpawnX, SpawnY, 0, c_gray);
        effect_create_above(ef_flare, SpawnX, SpawnY, 0, c_orange);

        switch (EnemyType) {
            case 0: instance_create_layer(SpawnX, SpawnY, "Instances", oEn_Slime); break;
            case 1: instance_create_layer(SpawnX, SpawnY, "Instances", oEn_Wolf); break;
            case 2: instance_create_layer(SpawnX, SpawnY, "Instances", oEn_Bear); break;
        }
    }
    BossSpawnTimer = SpawnDelay;
}

// Nếu máu dưới 0, ngừng hết
if (CurHp <= 0) exit;

// 2. Logic Khiên chắn
if (ShieldActive) {
    ShieldTimer--;
    if (ShieldTimer <= 0) {
        ShieldActive = false;
        ShieldTimer = ShieldCooldown;
    }
} else {
    ShieldTimer--;
    if (ShieldTimer <= 0) {
        ShieldActive = true;
        ShieldTimer = ShieldDuration;
    }
}

// 3. Logic Bắn chùm (Spread Fire) & Liên thanh (Rapid Fire)
if (!DisabledFirepower && instance_exists(oPar_PlayerUnit)) {
    var CenterX = x + (sprite_width / 2);
    var CenterY = y + (sprite_height / 2);
    
    // Cập nhật biến instance NearestEnemy (xóa 'var') để Draw_64 lấy đúng mục tiêu
    NearestEnemy = instance_nearest(CenterX, CenterY, oPar_PlayerUnit);
    var dist = point_distance(CenterX, CenterY, NearestEnemy.x, NearestEnemy.y);
    
    // Timer giảm liên tục dù có trong tầm ngắm hay không
    RapidAttackTimer--;
    SpreadTimer--;
    
    // Tầm bắn boss: 100 (Trùng khớp đúng với bán kính vòng khiên màu xanh)
    if (dist <= 100) {
        var Dir = point_direction(CenterX, CenterY, NearestEnemy.x, NearestEnemy.y);
        
        // Liên thanh (Rapid Fire)
        if (RapidAttackTimer <= 0) {
            var Att = instance_create_layer(
                CenterX + lengthdir_x(40, Dir),
                CenterY + lengthdir_y(40, Dir),
                "Instances", oAtt_DragonFire
            );
            Att.Power = Power;
            Att.direction = Dir;
            Att.speed = 5;
            Att.image_angle = Att.direction;
            Att.sprite_index = spr_lazer_ke_dich;
            Att.image_xscale = 0.6;
            Att.image_yscale = 0.6;
            
            RapidAttackTimer = AttackDelay;
            image_speed = 1;
            image_index = 0;
        }
        
        // Bắn chùm (Spread Fire)
        if (SpreadTimer <= 0) {
            for(var i = -1; i <= 1; i++) {
                var Att = instance_create_layer(
                    CenterX + lengthdir_x(40, Dir),
                    CenterY + lengthdir_y(40, Dir),
                    "Instances", oAtt_DragonFire
                );
                Att.Power = Power;
                Att.direction = Dir + (i * 15);
                Att.speed = 4;
                Att.image_angle = Att.direction;
                Att.sprite_index = spr_lazer_ke_dich;
                Att.image_xscale = 0.6;
                Att.image_yscale = 0.6;
            }
            
            SpreadTimer = SpreadCooldown;
            image_speed = 1;
            image_index = 0;
        }
    }
}
