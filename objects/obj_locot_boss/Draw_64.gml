/// @description Draw HP manually to bypass cache bug

// --- VIDEO DRAWING & FADE ---
if (variable_instance_exists(id, "VideoState") && VideoState > 0) {
    // Draw fade to black
    if (VideoAlpha > 0) {
        draw_set_alpha(VideoAlpha);
        draw_set_color(c_black);
        draw_rectangle(0, 0, 1280, 720, false);
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }
    
    // Draw Video if playing
    if (VideoPlaying) {
        var _video_data = video_draw();
        var _video_status = _video_data[0];
        
        // 0 means video surface is ready
        if (_video_status == 0) {
            var _video_surf = _video_data[1];
            if (surface_exists(_video_surf)) {
                draw_surface_stretched(_video_surf, 0, 0, 1280, 720);
            }
        }
    }
}
// ----------------------
// Hide HP bar and other GUI elements while video is active
if (variable_instance_exists(id, "VideoState") && VideoState > 0) {
    exit;
}
// ----------------------

if (CurHp <= 0) exit;
if (!instance_exists(oCamera)) exit;

var ShowHp = position_meeting(mouse_x, mouse_y, self);

if instance_exists(NearestEnemy) {
	if distance_to_object(NearestEnemy) < 60 {
		ShowHp = true;
	}
}

if ShowHp {
    var cx = oCamera.x;
    var cy = oCamera.y;
    var cw = oCamera.CamInitW * oCamera.ZoomFactor;
    var ch = oCamera.CamInitH * oCamera.ZoomFactor;

    var gw = 1280;
    var gh = 720;

    var CenterX = x + (sprite_width / 2);
    var gui_x = ((CenterX - cx) / cw) * gw + (gw / 2);
    // Tính toán vẽ ở dưới cùng của sprite boss
    var gui_y = ((y + sprite_height - 1 - cy) / ch) * gh + (gh / 2) + 20; // Dịch xuống 1 chút

    // Kích thước thanh máu Boss
    var bar_w = 200; // Chiều dài thanh máu
    var bar_h = 16;  // Độ dày thanh máu
    var hp_percent = CurHp / MaxHp;

    var bar_left = gui_x - (bar_w / 2);
    var bar_top = gui_y;
    var bar_right = gui_x + (bar_w / 2);
    var bar_bottom = gui_y + bar_h;

    // Vẽ nền thanh máu (màu đen)
    draw_set_color(c_black);
    draw_rectangle(bar_left, bar_top, bar_right, bar_bottom, false);

    // Vẽ lượng máu còn lại (màu đỏ)
    if (hp_percent > 0) {
        draw_set_color(c_red);
        draw_rectangle(bar_left, bar_top, bar_left + (bar_w * hp_percent), bar_bottom, false);
    }

    // Vẽ viền thanh máu (màu trắng)
    draw_set_color(c_white);
    draw_rectangle(bar_left, bar_top, bar_right, bar_bottom, true);

    // Vẽ text hiển thị số lượng máu ở chính giữa thanh máu
    draw_set_font(fnt_vietnamese);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    // Shadow text
    draw_set_color(c_black);
    draw_text(gui_x + 1, bar_top + 1, string(CurHp) + "/" + string(MaxHp));
    
    // Main text
    draw_set_color(c_white);
    draw_text(gui_x, bar_top, string(CurHp) + "/" + string(MaxHp));

    // Reset lại thiết lập chữ
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
