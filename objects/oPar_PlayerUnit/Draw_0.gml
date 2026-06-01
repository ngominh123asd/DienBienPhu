/// @description Draw

#region Draw selected icon
var zoom = 1;
if instance_exists(oCamera) zoom = oCamera.ZoomFactor;

if Selected {
	draw_sprite_ext(sSelected,0,x,y, zoom, zoom, 0, c_white, 1);
}
#endregion

// 1.5. Draw Golden pulsing Invincibility aura
if (instance_exists(oCont_Room) && oCont_Room.invincible_timer > 0) {
    var pulse = 0.5 + sin(current_time * 0.015) * 0.3;
    draw_set_color(c_yellow);
    draw_set_alpha(0.25 + pulse * 0.15);
    draw_circle(x, y, 16 + pulse * 4, false);
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_set_alpha(0.6 + pulse * 0.3);
    draw_circle(x, y, 16 + pulse * 4, true);
}

// 1.6. Draw Archer protective dome shield (Bế Văn Đàn)
if (variable_instance_exists(self, "IsHero") && IsHero && HeroName == "Bế Văn Đàn" && shield_timer > 0) {
    var pulse = 0.5 + sin(current_time * 0.01) * 0.2;
    draw_set_color(c_blue);
    draw_set_alpha(0.12 + pulse * 0.04);
    draw_circle(x, y, 200, false);
    draw_set_color(c_aqua);
    draw_set_alpha(0.5 + pulse * 0.2);
    draw_circle(x, y, 200, true);
}

// 1.7. Draw Soldier battle cry aura (Phan Đình Giót)
if (variable_instance_exists(self, "IsHero") && IsHero && HeroName == "Phan Đình Giót" && skill_cooldowns[2] > 240) {
    var pulse = 0.5 + sin(current_time * 0.02) * 0.2;
    draw_set_color(c_red);
    draw_set_alpha(0.1 + pulse * 0.03);
    draw_circle(x, y, 200, false);
    draw_set_color(c_orange);
    draw_set_alpha(0.4 + pulse * 0.2);
    draw_circle(x, y, 200, true);
}

// 1.8. Draw Permanent Hero magic halo under feet
if (variable_instance_exists(self, "IsHero") && IsHero) {
    var base_color = (HeroName == "Phan Đình Giót") ? make_color_rgb(255, 100, 0) : make_color_rgb(0, 220, 255);
    var pulse = 0.5 + sin(current_time * 0.008) * 0.3;
    
    // Draw magic floor aura
    draw_set_color(base_color);
    draw_set_alpha(0.12 + pulse * 0.08);
    draw_circle(x, y + 4, 18 + pulse * 3, false);
    
    draw_set_alpha(0.6 + pulse * 0.25);
    draw_circle(x, y + 4, 18 + pulse * 3, true);
    draw_circle(x, y + 4, 12 + pulse * 1.5, true);
    
    // Draw rotating spikes/spokes inside the halo
    for (var d = 0; d < 360; d += 90) {
        var angle = d + (current_time * 0.04);
        var x1 = x + lengthdir_x(8 + pulse, angle);
        var y1 = y + 4 + lengthdir_y(8 + pulse, angle);
        var x2 = x + lengthdir_x(16 + pulse * 2, angle);
        var y2 = y + 4 + lengthdir_y(16 + pulse * 2, angle);
        draw_line_width(x1, y1, x2, y2, 2);
    }
}

// Reset draw settings
draw_set_alpha(1.0);
draw_set_color(c_white);

draw_self();