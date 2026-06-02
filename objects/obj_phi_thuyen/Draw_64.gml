/// @description Draw Hearts GUI & Game Over

if (won) {
    // 1. Dark overlay background
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, 1280, 720, false);
    
    // 2. Victory Text
    draw_set_alpha(1.0);
    draw_set_font(fnt_vietnamese);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Glowing gold/yellow victory title with soft shadow
    draw_set_color(c_black);
    draw_text_ext_transformed(640 + 2, 200 + 2, "VICTORY!", 24, 600, 3, 3, 0);
    draw_set_color(c_yellow);
    draw_text_ext_transformed(640, 200, "VICTORY!", 24, 600, 3, 3, 0);
    
    // Tactical historical flavor text
    draw_set_color(c_white);
    var Minutes = floor(time_played / 60 / 60);
    var Seconds = floor(time_played / 60) - (Minutes * 60);
    if (Minutes < 10) { Minutes = "0" + string(Minutes); }
    if (Seconds < 10) { Seconds = "0" + string(Seconds); }
    var PlayedString = string(Minutes) + ":" + string(Seconds);
    
    var desc = "Chúc mừng! Bạn đã xuất sắc tiêu diệt toàn bộ máy bay tiêm kích địch bảo vệ vùng trời chiến dịch Điện Biên Phủ.\n\nThời gian hoàn thành: " + PlayedString;
    if (variable_instance_exists(id, "kamikaze_won") && kamikaze_won) {
        desc = "Chúc mừng chiến sỹ anh dũng! Bạn đã hy sinh thân mình bảo vệ Tổ quốc, lao thẳng phi thuyền vào tiêu diệt Siêu Tàu Sân Bay địch, làm nên chiến công hiển hách lừng lẫy năm châu, chấn động địa cầu tại Điện Biên Phủ!\n\nThời gian hoàn thành: " + PlayedString;
    }
    draw_text_ext_transformed(640, 370, desc, 22, 600, 1.3, 1.3, 0);
    
    // Controls
    draw_set_color(make_color_rgb(180, 190, 185));
    draw_text(640, 520, "Nhấn 'ENTER' để về Menu chọn màn");
    draw_text(640, 560, "Nhấn 'R' để chơi lại màn này");
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
} else if (alive) {
    if (state == "shop") {
        // --- DRAW SHOP ---
        if (shop_sprite != -1) {
            draw_sprite_stretched(shop_sprite, 0, 0, 0, 1280, 720);
        } else {
            draw_set_color(make_color_rgb(15, 20, 25));
            draw_rectangle(0, 0, 1280, 720, false);
        }
        
        // Semi-transparent black overlay
        draw_set_color(c_black);
        draw_set_alpha(0.35); // Reduced dark overlay to make background details shine
        draw_rectangle(0, 0, 1280, 720, false);
        draw_set_alpha(1.0);
        
        // Shop borders & titles
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        var pulse = 1.0 + sin(current_time * 0.005) * 0.02;
        draw_set_color(c_black);
        draw_text_ext_transformed(485 + 2, 50 + 2, "XƯỞNG CƠ KHÍ KHÔNG QUÂN ĐIỆN BIÊN PHỦ", 24, 1100, 1.8 * pulse, 1.8 * pulse, 0);
        draw_set_color(make_color_rgb(255, 215, 0)); // Gold
        draw_text_ext_transformed(485, 50, "XƯỞNG CƠ KHÍ KHÔNG QUÂN ĐIỆN BIÊN PHỦ", 24, 1100, 1.8 * pulse, 1.8 * pulse, 0);
        
        // Mouse coordinates for GUI
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);
        var mouse_pressed = mouse_check_button_pressed(mb_left);
        
        // Spacing coordinates for the 4 wooden trays in shop.jpg:
        // Tray 1 center: 225
        // Tray 2 center: 425
        // Tray 3 center: 625
        // Tray 4 center: 825
        // Center y: 490
        var tray_y = 490;
        var centers = [225, 425, 625, 825];
        
        // Select item on click
        if (mouse_pressed && !quiz_open) {
            for (var i = 0; i < array_length(item_names); i++) {
                var cx = centers[i];
                if (mx >= cx - 60 && mx <= cx + 60 && my >= tray_y - 70 && my <= tray_y + 70) {
                    selected_item = i;
                    audio_play_sound(sndBoop, 5, 0); // Play select sound
                }
            }
        }
        
        // Draw the item sprites inside the wooden trays
        for (var i = 0; i < array_length(item_names); i++) {
            var cx = centers[i];
            
            // Draw part image in the tray
            var img = part_sprites[i];
            
            // Check if hovered
            var is_hovered = (mx >= cx - 60 && mx <= cx + 60 && my >= tray_y - 70 && my <= tray_y + 70);
            
            if (img != -1) {
                var img_w = sprite_get_width(img);
                var img_h = sprite_get_height(img);
                var img_scale = min(90 / img_w, 90 / img_h);
                
                // Draw normal or slightly transparent if not selected/hovered
                var draw_alpha = (selected_item == i || is_hovered) ? 1.0 : 0.65;
                // If selected or hovered, add a glowing highlight behind it
                if (selected_item == i || is_hovered) {
                    draw_set_color(c_white);
                    draw_set_alpha(selected_item == i ? 0.18 : 0.08);
                    draw_circle(cx, tray_y, 45, false);
                    draw_set_alpha(1.0);
                }
                
                // Centered thanks to Create_0.gml setting the offset
                draw_sprite_ext(img, 0, cx, tray_y, img_scale, img_scale, 0, c_white, draw_alpha);
            }
            
            // Draw a small glowing selector rectangle around the selected tray, or a subtle one for hovered
            if (selected_item == i) {
                draw_set_color(make_color_rgb(255, 215, 0)); // Gold
                draw_rectangle(cx - 62, tray_y - 72, cx + 62, tray_y + 72, true);
                draw_rectangle(cx - 61, tray_y - 71, cx + 61, tray_y + 71, true);
            } else if (is_hovered) {
                draw_set_color(make_color_rgb(200, 200, 200)); // Silver/gray
                draw_rectangle(cx - 62, tray_y - 72, cx + 62, tray_y + 72, true);
            }
            
            // Draw a small price label below the tray (on the table front)
            draw_set_font(fnt_vietnamese);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_yellow);
            draw_text_transformed(cx, tray_y + 65, string(item_costs[i]) + " vang", 1.0, 1.0, 0);
        }
        
        // Draw Gold inside the designated Gold Bar box at (650, 640)
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(255, 230, 100)); // Bright golden text
        draw_text_transformed(650, 640, string(gold), 1.0, 1.0, 0);
        
        // Draw Detail Panel for the selected item on the right side
        var px1 = 900;
        var py1 = 140;
        var px2 = 1250;
        var py2 = 510;
        
        // Panel Background
        draw_set_color(make_color_rgb(15, 25, 20)); // Dark military green
        draw_set_alpha(0.88);
        draw_rectangle(px1, py1, px2, py2, false);
        
        // Gold/Yellow borders
        draw_set_alpha(1.0);
        draw_set_color(make_color_rgb(220, 180, 50)); // Gold
        draw_rectangle(px1, py1, px2, py2, true);
        draw_rectangle(px1 + 2, py1 + 2, px2 - 2, py2 - 2, true);
        
        // LED status header text
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(120, 255, 120));
        draw_text_transformed((px1 + px2)/2, py1 + 20, "THONG TIN THIET BI NANG CAP", 1.0, 1.0, 0);
        
        // Line break
        draw_set_color(make_color_rgb(80, 100, 85));
        draw_line_width(px1 + 15, py1 + 40, px2 - 15, py1 + 40, 2);
        
        if (selected_item >= 0 && selected_item < array_length(item_names)) {
            var i = selected_item;
            
            // Name
            draw_set_color(c_white);
            draw_text_ext_transformed((px1 + px2)/2, py1 + 65, item_names[i], 18, (px2 - px1) - 20, 1.0, 1.0, 0);
            
            // Image centered and scaled
            var img = part_sprites[i];
            if (img != -1) {
                var img_w = sprite_get_width(img);
                var img_h = sprite_get_height(img);
                var img_scale = min(110 / img_w, 110 / img_h);
                draw_sprite_ext(img, 0, (px1 + px2)/2, py1 + 145, img_scale, img_scale, 0, c_white, 1.0);
            }
            
            // Level / Ownership Status
            var status_str = "";
            var is_maxed = (item_levels[i] >= item_max_levels[i]);
            if (i == 0) {
                status_str = wrench_purchased ? "MAY BAY DA DUOC SUA CHUA" : "DANG HONG - CAN SUA CHUA KHAN CAP";
            } else {
                if (item_max_levels[i] == 1) {
                    status_str = (item_levels[i] > 0) ? "DA SO HUU TRONG TRAN" : "CHUA SO HUU";
                } else {
                    status_str = "Cap do: " + string(item_levels[i]) + "/" + string(item_max_levels[i]);
                }
            }
            
            if (i == 0 && wrench_purchased) draw_set_color(c_lime);
            else if (i == 0 && !wrench_purchased) draw_set_color(c_red);
            else if (item_levels[i] > 0) draw_set_color(c_lime);
            else draw_set_color(c_yellow);
            
            draw_text_transformed((px1 + px2)/2, py1 + 225, status_str, 1.0, 1.0, 0);
            
            // Description text
            draw_set_color(make_color_rgb(190, 210, 190));
            draw_text_ext_transformed((px1 + px2)/2, py1 + 280, item_descs[i], 16, (px2 - px1) - 40, 1.0, 1.0, 0);
            
            // --- BUY AND REFUND BUTTONS ---
            // Buy Button
            var can_buy = (gold >= item_costs[i] && !is_maxed);
            if (i == 0) {
                can_buy = (gold >= item_costs[i] && !wrench_purchased);
            }
            
            var btn_y = py1 + 330;
            var btn_w = 150;
            var btn_h = 42;
            
            // Buy Button: left side
            var bx1_1 = px1 + 20;
            var by1_1 = btn_y - btn_h/2;
            var bx2_1 = bx1_1 + btn_w;
            var by2_1 = by1_1 + btn_h;
            var is_buy_hover = (mx >= bx1_1 && mx <= bx2_1 && my >= by1_1 && my <= by2_1);
            
            // Refund Button: right side
            var bx1_2 = px2 - 20 - btn_w;
            var by1_2 = btn_y - btn_h/2;
            var bx2_2 = bx1_2 + btn_w;
            var by2_2 = by1_2 + btn_h;
            var is_ref_hover = (mx >= bx1_2 && mx <= bx2_2 && my >= by1_2 && my <= by2_2);
            
            // Render Buy Button
            if (i != 0 && is_maxed) {
                draw_set_color(c_dkgray);
                draw_rectangle(bx1_1, by1_1, bx2_1, by2_1, false);
                draw_set_color(c_gray);
                draw_text_transformed((bx1_1 + bx2_1)/2, btn_y, "DA MAX", 1.0, 1.0, 0);
            } else if (i == 0 && wrench_purchased) {
                draw_set_color(make_color_rgb(0, 80, 0));
                draw_rectangle(bx1_1, by1_1, bx2_1, by2_1, false);
                draw_set_color(c_lime);
                draw_text_transformed((bx1_1 + bx2_1)/2, btn_y, "DA HOAN TAT", 1.0, 1.0, 0);
            } else {
                if (can_buy) {
                    if (is_buy_hover) {
                        draw_set_color(make_color_rgb(0, 220, 60)); // Bright green
                    } else {
                        draw_set_color(make_color_rgb(0, 140, 30)); // Green
                    }
                    draw_rectangle(bx1_1, by1_1, bx2_1, by2_1, false);
                    draw_set_color(c_white);
                    draw_text_transformed((bx1_1 + bx2_1)/2, btn_y, "MUA (" + string(item_costs[i]) + " vang)", 1.0, 1.0, 0);
                    
                    if (is_buy_hover && mouse_pressed && !quiz_open) {
                        gold -= item_costs[i];
                        session_purchases[i] += 1;
                        audio_play_sound(sndLevelUp, 10, 0);
                        
                        if (i == 0) {
                            wrench_purchased = true;
                            hp = max_hp;
                        } else {
                            item_levels[i] += 1;
                            if (i == 1) has_rocket = true;
                            else if (i == 2) shield_charges = 3;
                            else if (i == 3) { has_autofire = true; autofire_active = true; }
                        }
                    }
                } else {
                    draw_set_color(c_maroon);
                    draw_rectangle(bx1_1, by1_1, bx2_1, by2_1, false);
                    draw_set_color(c_gray);
                    draw_text_transformed((bx1_1 + bx2_1)/2, btn_y, "K.DU VANG", 1.0, 1.0, 0);
                }
            }
            
            // Render Refund Button (Nút Hoàn tiền / Trả lại)
            var can_refund = (session_purchases[i] > 0);
            if (can_refund) {
                if (is_ref_hover) {
                    draw_set_color(make_color_rgb(255, 80, 80)); // Light red
                } else {
                    draw_set_color(make_color_rgb(180, 30, 30)); // Dark red
                }
                draw_rectangle(bx1_2, by1_2, bx2_2, by2_2, false);
                draw_set_color(c_white);
                draw_text_transformed((bx1_2 + bx2_2)/2, btn_y, "TRA LAI (+" + string(item_costs[i]) + " V)", 1.0, 1.0, 0);
                
                if (is_ref_hover && mouse_pressed && !quiz_open) {
                    gold += item_costs[i];
                    session_purchases[i] -= 1;
                    audio_play_sound(sndDie, 10, 0); // refund play sound
                    
                    if (i == 0) {
                        wrench_purchased = false;
                        hp = hp_before_shop; // Restore HP
                    } else {
                        item_levels[i] = max(0, item_levels[i] - 1);
                        if (item_levels[i] == 0) {
                            if (i == 1) has_rocket = false;
                            else if (i == 2) shield_charges = shield_charges_before_shop; // Restore previous shield charges
                            else if (i == 3) { has_autofire = false; autofire_active = false; }
                        }
                    }
                }
            } else {
                draw_set_color(make_color_rgb(40, 40, 40));
                draw_rectangle(bx1_2, by1_2, bx2_2, by2_2, false);
                draw_set_color(c_gray);
                draw_text_transformed((bx1_2 + bx2_2)/2, btn_y, "TRA LAI", 1.0, 1.0, 0);
            }
        }
        
        // --- DRAW CONTINUE BUTTON ON THE RIGHT SIDE ---
        var cbx1 = 900;
        var cby1 = 530;
        var cbx2 = 1250;
        var cby2 = 590;
        
        var is_cont_hover = (mx >= cbx1 && mx <= cbx2 && my >= cby1 && my <= cby2);
        
        if (!wrench_purchased) {
            // Disabled Continue button
            draw_set_color(make_color_rgb(60, 20, 20));
            draw_rectangle(cbx1, cby1, cbx2, cby2, false);
            draw_set_color(make_color_rgb(180, 80, 80));
            draw_rectangle(cbx1, cby1, cbx2, cby2, true);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(make_color_rgb(180, 80, 80));
            draw_text_ext_transformed((cbx1 + cbx2)/2, (cby1 + cby2)/2, "CAN SUA MAY BAY DE TIEP TUC", 20, (cbx2 - cbx1) - 20, 1.0, 1.0, 0);
            
            var warning_blink = (floor(current_time / 600) % 2 == 0);
            if (warning_blink) {
                draw_set_color(c_red);
                draw_text_transformed(485, 200, "BAT BUOC MUA CO LE DE SUA MAY BAY TRUOC KHI CAT CANH!", 1.0, 1.0, 0);
            }
        } else {
            // Enabled Continue button
            if (is_cont_hover) {
                draw_set_color(make_color_rgb(255, 215, 0)); // Gold border glow
                draw_rectangle(cbx1 - 2, cby1 - 2, cbx2 + 2, cby2 + 2, false);
                draw_set_color(make_color_rgb(0, 130, 230)); // Bright blue
            } else {
                draw_set_color(make_color_rgb(0, 80, 160)); // Dark blue
            }
            draw_rectangle(cbx1, cby1, cbx2, cby2, false);
            draw_set_color(c_white);
            draw_rectangle(cbx1, cby1, cbx2, cby2, true);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_ext_transformed((cbx1 + cbx2)/2, (cby1 + cby2)/2, "XUAT KICH (TIEP TUC)", 20, (cbx2 - cbx1) - 20, 1.0, 1.0, 0);
            
            if (is_cont_hover && mouse_pressed && !quiz_open) {
                audio_play_sound(sndClickBut, 10, 0);
                
                // Play storytelling narrative and video if this is Turn 1 of Level 2
                if (room == rmGame2 && level_wave == 1) {
                    state = "story";
                    story_dialog_index = 0;
                    story_char_count = 0;
                } else {
                    // Exit shop, enter reentry state normally
                    state = "reenter";
                    x = room_width / 2;
                    y = room_height + 100;
                }
            }
        }
        
        // --- DRAW DECRYPTION QUIZ BUTTON ON THE RIGHT SIDE ---
        var dbx1 = 900;
        var dby1 = 610;
        var dbx2 = 1250;
        var dby2 = 670;
        
        var is_db_hover = (mx >= dbx1 && mx <= dbx2 && my >= dby1 && my <= dby2);
        
        // Check if all questions are completed
        var all_completed = true;
        for (var q = 0; q < 5; q++) {
            if (quiz_questions_status[q] != 1) {
                all_completed = false;
                break;
            }
        }
        
        if (all_completed) {
            // Glow green if all completed
            if (is_db_hover) {
                draw_set_color(make_color_rgb(50, 220, 100)); // Glowing green
                draw_rectangle(dbx1 - 2, dby1 - 2, dbx2 + 2, dby2 + 2, false);
                draw_set_color(make_color_rgb(10, 80, 30));
            } else {
                draw_set_color(make_color_rgb(20, 120, 50));
            }
            draw_rectangle(dbx1, dby1, dbx2, dby2, false);
            draw_set_color(c_white);
            draw_rectangle(dbx1, dby1, dbx2, dby2, true);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_ext_transformed((dbx1 + dbx2)/2, (dby1 + dby2)/2, "GIẢI MÃ TÌNH BÁO [HOÀN THÀNH]", 20, (dbx2 - dbx1) - 20, 1.0, 1.0, 0);
        } else {
            // Glow yellow/gold if incomplete
            if (is_db_hover) {
                draw_set_color(make_color_rgb(255, 215, 0)); // Gold border glow
                draw_rectangle(dbx1 - 2, dby1 - 2, dbx2 + 2, dby2 + 2, false);
                draw_set_color(make_color_rgb(120, 80, 10));
            } else {
                draw_set_color(make_color_rgb(80, 50, 5));
            }
            draw_rectangle(dbx1, dby1, dbx2, dby2, false);
            draw_set_color(c_white);
            draw_rectangle(dbx1, dby1, dbx2, dby2, true);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_ext_transformed((dbx1 + dbx2)/2, (dby1 + dby2)/2, "GIẢI MÃ TÌNH BÁO (+60 VÀNG)", 20, (dbx2 - dbx1) - 20, 1.0, 1.0, 0);
        }
        
        if (is_db_hover && mouse_pressed && !quiz_open) {
            audio_play_sound(sndClickBut, 10, 0);
            quiz_open = true;
            quiz_current_question = -1;
        }

        // --- DRAW AND HANDLE QUIZ OVERLAY MODAL ---
        if (quiz_open) {
            // Dark glass overlay
            draw_set_color(c_black);
            draw_set_alpha(0.85);
            draw_rectangle(0, 0, 1280, 720, false);
            draw_set_alpha(1.0);
            
            // Dialog Box
            var box_x = 240; 
            var box_y = 100; 
            var box_w = 800; 
            var box_h = 520;
            
            draw_set_color(make_color_rgb(15, 25, 20)); // Dark military green-gray
            draw_set_alpha(0.95);
            draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, false);
            draw_set_alpha(1.0);
            
            // Glowing border (flashing gold)
            var border_pulse = 0.5 + sin(current_time * 0.01) * 0.5;
            draw_set_color(merge_color(make_color_rgb(180, 150, 50), c_yellow, border_pulse * 0.2));
            draw_rectangle(box_x - 1, box_y - 1, box_x + box_w + 1, box_y + box_h + 1, true);
            draw_rectangle(box_x - 2, box_y - 2, box_x + box_w + 2, box_y + box_h + 2, true);
            
            draw_set_font(fnt_vietnamese);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            if (quiz_current_question == -1) {
                // --- TẦNG 1: DANH SÁCH BÁO CÁO TÌNH BÁO ---
                draw_set_color(c_yellow);
                draw_text_transformed(box_x + box_w/2, box_y + 40, "★ HỒ SƠ TÌNH BÁO: ĐIỆN BIÊN PHỦ TRÊN KHÔNG ★", 1.0, 1.0, 0);
                
                draw_set_color(c_white);
                draw_text_transformed(box_x + box_w/2, box_y + 75, "Giải mã các tài liệu mật về chiến dịch 12 ngày đêm lịch sử để nhận kinh phí chi viện.", 1.0, 1.0, 0);
                
                for (var i = 0; i < 5; i++) {
                    var btn_w = 700;
                    var btn_h = 50;
                    var btn_x = box_x + (box_w - btn_w) / 2;
                    var btn_y = box_y + 115 + i * 65;
                    
                    var hover = (mx >= btn_x && mx <= btn_x + btn_w && my >= btn_y && my <= btn_y + btn_h);
                    
                    if (hover) {
                        draw_set_color(make_color_rgb(30, 45, 35));
                    } else {
                        draw_set_color(make_color_rgb(12, 20, 15));
                    }
                    draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
                    
                    var is_solved = (quiz_questions_status[i] == 1);
                    var border_col = is_solved ? make_color_rgb(50, 220, 100) : make_color_rgb(180, 150, 50);
                    draw_set_color(border_col);
                    draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, true);
                    
                    // Draw title
                    draw_set_color(c_white);
                    draw_set_halign(fa_left);
                    draw_text_transformed(btn_x + 25, btn_y + btn_h/2, "Báo cáo mật số " + string(i + 1), 1.0, 1.0, 0);
                    
                    // Draw status
                    var status_text = "";
                    var status_col = c_yellow;
                    if (is_solved) {
                        status_text = "✓ ĐÃ GIẢI MÃ (+" + string(quiz_reward_value) + " V)";
                        status_col = make_color_rgb(50, 220, 100);
                    } else {
                        status_text = "○ CHƯA GIẢI MÃ";
                        status_col = c_yellow;
                    }
                    
                    draw_set_color(status_col);
                    draw_set_halign(fa_right);
                    draw_text_transformed(btn_x + btn_w - 25, btn_y + btn_h/2, status_text, 1.0, 1.0, 0);
                    
                    if (hover && mouse_pressed) {
                        audio_play_sound(sndClickBut, 10, 0);
                        quiz_current_question = i;
                    }
                }
                
                // Draw Close button
                var close_w = 180;
                var close_h = 45;
                var close_x = box_x + (box_w - close_w) / 2;
                var close_y = box_y + box_h - 60;
                var close_hover = (mx >= close_x && mx <= close_x + close_w && my >= close_y && my <= close_y + close_h);
                
                if (close_hover) {
                    draw_set_color(make_color_rgb(120, 40, 40));
                } else {
                    draw_set_color(make_color_rgb(60, 20, 20));
                }
                draw_rectangle(close_x, close_y, close_x + close_w, close_y + close_h, false);
                draw_set_color(c_white);
                draw_rectangle(close_x, close_y, close_x + close_w, close_y + close_h, true);
                
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text_transformed(close_x + close_w/2, close_y + close_h/2, "ĐÓNG HỒ SƠ", 1.0, 1.0, 0);
                
                if (close_hover && mouse_pressed) {
                    audio_play_sound(sndClickBut, 10, 0);
                    quiz_open = false;
                }
            } 
            else {
                // --- TẦNG 2: MÀN HÌNH CÂU HỎI TRẮC NGHIỆM CHI TIẾT ---
                var q_data = quiz_questions[quiz_current_question];
                var is_solved = (quiz_questions_status[quiz_current_question] == 1);
                
                draw_set_color(c_yellow);
                draw_text_transformed(box_x + box_w/2, box_y + 40, "★ GIẢI MÃ BÁO CÁO THỨ " + string(quiz_current_question + 1) + " ★", 1.0, 1.0, 0);
                
                // Question Text
                draw_set_color(c_white);
                draw_set_halign(fa_center);
                draw_text_ext_transformed(box_x + box_w/2, box_y + 90, q_data.q, 25, 720, 1.0, 1.0, 0);
                
                // If solved, show a notice
                if (is_solved) {
                    draw_set_color(make_color_rgb(50, 220, 100));
                    draw_text_transformed(box_x + box_w/2, box_y + 160, "✓ THƯ MẬT ĐÃ GIẢI MÃ THÀNH CÔNG - NHẬN ĐƯỢC " + string(quiz_reward_value) + " VÀNG", 1.0, 1.0, 0);
                } else {
                    draw_set_color(c_orange);
                    draw_text_transformed(box_x + box_w/2, box_y + 160, "HÃY CHỌN PHƯƠNG ÁN ĐÚNG ĐỂ GIẢI MÃ MẬT LỆNH", 1.0, 1.0, 0);
                }
                
                // 4 options in 2x2 grid
                for (var i = 0; i < 4; i++) {
                    var opt_w = 340;
                    var opt_h = 75;
                    var opt_x = box_x + 40 + (i % 2) * 380;
                    var opt_y = box_y + 200 + floor(i / 2) * 105;
                    
                    var hover = (mx >= opt_x && mx <= opt_x + opt_w && my >= opt_y && my <= opt_y + opt_h);
                    
                    if (hover && !is_solved) {
                        draw_set_color(make_color_rgb(40, 60, 80));
                    } else {
                        draw_set_color(make_color_rgb(15, 20, 25));
                    }
                    draw_rectangle(opt_x, opt_y, opt_x + opt_w, opt_y + opt_h, false);
                    
                    var border_col = make_color_rgb(180, 150, 50);
                    if (is_solved && i == q_data.correct) {
                        border_col = make_color_rgb(50, 220, 100);
                    }
                    draw_set_color(border_col);
                    draw_rectangle(opt_x, opt_y, opt_x + opt_w, opt_y + opt_h, true);
                    
                    draw_set_color(c_white);
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_text_ext_transformed(opt_x + opt_w/2, opt_y + opt_h/2, q_data.a[i], 18, 320, 1.0, 1.0, 0);
                    
                    if (hover && mouse_pressed && !is_solved) {
                        if (i == q_data.correct) {
                            audio_play_sound(sndLevelUp, 10, 0);
                            quiz_questions_status[quiz_current_question] = 1;
                            gold += quiz_reward_value;
                            quiz_current_question = -1; // Return to list
                        } else {
                            audio_play_sound(sndDie, 10, 0);
                        }
                    }
                }
                
                // Back button
                var back_w = 180;
                var back_h = 45;
                var back_x = box_x + (box_w - back_w) / 2;
                var back_y = box_y + box_h - 60;
                var back_hover = (mx >= back_x && mx <= back_x + back_w && my >= back_y && my <= back_y + back_h);
                
                if (back_hover) {
                    draw_set_color(make_color_rgb(80, 80, 80));
                } else {
                    draw_set_color(make_color_rgb(40, 40, 40));
                }
                draw_rectangle(back_x, back_y, back_x + back_w, back_y + back_h, false);
                draw_set_color(c_white);
                draw_rectangle(back_x, back_y, back_x + back_w, back_y + back_h, true);
                
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text_transformed(back_x + back_w/2, back_y + back_h/2, "QUAY LẠI", 1.0, 1.0, 0);
                
                if (back_hover && mouse_pressed) {
                    audio_play_sound(sndClickBut, 10, 0);
                    quiz_current_question = -1;
                }
            }
        }
        
    } else if (state == "story") {
        // --- DRAW STORYTELLING CINEMATIC ---
        // 1. Dark overlay background with a subtle red glowing pulse representing fire/bombs
        var pulse_red = 15 + sin(current_time * 0.003) * 10;
        draw_set_color(make_color_rgb(pulse_red, 0, 0));
        draw_set_alpha(1.0);
        draw_rectangle(0, 0, 1280, 720, false);
        
        // 2. Cinematic top & bottom black bars
        draw_set_color(c_black);
        draw_rectangle(0, 0, 1280, 110, false);
        draw_rectangle(0, 610, 1280, 720, false);
        
        // separating border lines
        draw_set_color(make_color_rgb(180, 20, 20)); // crimson red
        draw_line_width(0, 110, 1280, 110, 3);
        draw_line_width(0, 610, 1280, 610, 3);
        
        // 3. Draw Title at top
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        var pulse = 1.0 + sin(current_time * 0.008) * 0.02;
        draw_set_color(c_black);
        draw_text_ext_transformed(640 + 2, 55 + 2, "★ ĐÊM 22/12: KÝ ỨC ĐAU THƯƠNG & Ý CHÍ SẮT ĐÁ ★", 24, 1100, 1.4 * pulse, 1.4 * pulse, 0);
        draw_set_color(make_color_rgb(255, 60, 60)); // Glowing red
        draw_text_ext_transformed(640, 55, "★ ĐÊM 22/12: KÝ ỨC ĐAU THƯƠNG & Ý CHÍ SẮT ĐÁ ★", 24, 1100, 1.4 * pulse, 1.4 * pulse, 0);
        
        // 4. Draw Narrative Dialogue Box in the center/bottom
        var box_x1 = 120;
        var box_y1 = 200;
        var box_x2 = 1160;
        var box_y2 = 560;
        
        // Box background
        draw_set_color(make_color_rgb(12, 10, 10));
        draw_set_alpha(0.85);
        draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);
        
        // Border
        draw_set_alpha(1.0);
        draw_set_color(make_color_rgb(160, 30, 30));
        draw_rectangle(box_x1, box_y1, box_x2, box_y2, true);
        draw_set_color(make_color_rgb(220, 190, 80)); // Gold inner border
        draw_rectangle(box_x1 + 2, box_y1 + 2, box_x2 - 2, box_y2 - 2, true);
        
        // 5. Draw narrative typewriter text
        var draw_str = string_copy(story_texts[story_dialog_index], 1, floor(story_char_count));
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        // Shadow
        draw_set_color(c_black);
        draw_text_ext(box_x1 + 40 + 2, box_y1 + 40 + 2, draw_str, 28, 960);
        // Main text
        draw_set_color(make_color_rgb(245, 240, 220)); // Soft retro white
        draw_text_ext(box_x1 + 40, box_y1 + 40, draw_str, 28, 960);
        
        // 6. Interaction prompt
        var blink = (floor(current_time / 250) % 2 == 0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        
        var current_text = story_texts[story_dialog_index];
        var text_len = string_length(current_text);
        
        if (story_char_count < text_len) {
            if (blink) {
                draw_set_color(c_gray);
                draw_text(box_x2 - 40, box_y2 - 20, "Ấn SPACE để xem nhanh >>");
            }
        } else {
            if (blink) {
                draw_set_color(c_yellow);
                if (story_dialog_index < array_length(story_texts) - 1) {
                    draw_text(box_x2 - 40, box_y2 - 20, "Ấn SPACE hoặc ENTER để tiếp tục ->");
                } else {
                    draw_text(box_x2 - 40, box_y2 - 20, "Ấn SPACE hoặc ENTER để XUẤT KÍCH [BẮT ĐẦU PHÁT VIDEO] ->");
                }
            }
        }
        
        // Reset settings
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_valign(fa_top);
        draw_set_halign(fa_left);
        
    } else if (state == "video") {
        // --- DRAW VIDEO ---
        // Semi-transparent or black background overlay to hide normal gameplay
        draw_set_color(c_black);
        draw_set_alpha(1.0);
        draw_rectangle(0, 0, 1280, 720, false);
        
        var results = video_draw();
        var status = results[0];
        if (status == 0) {
            // Draw video surface stretched to cover GUI size 1280x720
            draw_surface_stretched(results[1], 0, 0, 1280, 720);
        }
        
        // Small debug info at top-left
        draw_set_color(c_white);
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text_transformed(20, 20, "Status: " + string(status) + " | Started: " + string(video_started) + " | Frame: " + string(video_frame_count), 0.65, 0.65, 0);
        
        // Draw a skip prompt at the bottom right corner
        draw_set_alpha(0.65);
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_white);
        
        var blink = (floor(current_time / 500) % 2 == 0);
        if (blink) {
            draw_text_transformed(1250, 700, "Nhấn Space hoặc Enter để bỏ qua >>", 0.75, 0.75, 0);
        } else {
            draw_text_transformed(1250, 700, "Nhấn Space hoặc Enter để bỏ qua >>", 0.75, 0.75, 0);
        }
        draw_set_alpha(1.0);
        
    } else {
        // --- DRAW REGULAR GAMEPLAY UI ---
        // Low HP pulsing vignette danger warning overlay
        if (hp <= 2 && !won && (!variable_instance_exists(id, "kamikaze_mode") || !kamikaze_mode)) {
            var danger_pulse = 0.15 + sin(current_time * 0.008) * 0.1;
            draw_set_color(c_red);
            draw_set_alpha(danger_pulse);
            // Draw vignette borders
            draw_rectangle(0, 0, 1280, 20, false); // top
            draw_rectangle(0, 700, 1280, 720, false); // bottom
            draw_rectangle(0, 20, 20, 700, false); // left
            draw_rectangle(1260, 20, 1280, 700, false); // right
            draw_set_alpha(1.0);
        }

        // ----------------------------------------------------
        // KAMIKAZE SACRIFICE OVERLAY GUI
        // ----------------------------------------------------
        if (variable_instance_exists(id, "kamikaze_mode") && kamikaze_mode) {
            // If actively charging, skip drawing the warning text/bars to keep the cinematic view pristine!
            if (variable_instance_exists(id, "kamikaze_charging") && kamikaze_charging) {
                // Only draw hearts in HUD
                var heart_x = 30;
                var heart_y = 30;
                var target_w = 40;
                var scale = target_w / sprite_get_width(sHp);
                var spacing = target_w + 10;
                for (var i = 0; i < max_hp; i++) {
                    if (i < hp) {
                        draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_white, 1.0);
                    } else {
                        draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_black, 0.4);
                    }
                }
                exit; // Exit Draw GUI immediately to keep the rest of the screen blank
            }

            // 1. Transparent dark background overlay (in the middle area)
            draw_set_color(c_black);
            draw_set_alpha(0.6);
            draw_rectangle(0, 110, 1280, 610, false);
            
            // 2. Cinematic Top & Bottom black letterbox bars
            draw_set_color(c_black);
            draw_set_alpha(0.85);
            draw_rectangle(0, 0, 1280, 110, false);
            draw_rectangle(0, 610, 1280, 720, false);
            
            // High-end separating border lines for the letterbox
            draw_set_color(make_color_rgb(180, 20, 20)); // crimson red
            draw_line_width(0, 110, 1280, 110, 3);
            draw_line_width(0, 610, 1280, 610, 3);
            
            // 3. Setup draw parameters for text
            draw_set_alpha(1.0);
            draw_set_font(fnt_vietnamese);
            
            // 4. Draw Danger Warning Alert Box if monologue is fully completed
            if (variable_instance_exists(id, "monologue_completed") && monologue_completed) {
                var pulse_color = make_color_rgb(180 + sin(current_time * 0.015) * 35, 15, 15);
                
                // Glowing background plate
                draw_set_color(pulse_color);
                draw_set_alpha(0.85);
                draw_rectangle(220, 140, 1060, 390, false);
                
                // Double yellow/orange borders
                draw_set_alpha(1.0);
                draw_set_color(c_yellow);
                draw_rectangle(220, 140, 1060, 390, true);
                draw_rectangle(222, 142, 1058, 388, true);
                
                // Alert contents
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                
                draw_set_color(c_black);
                draw_text_ext_transformed(640 + 2, 185 + 2, "⚠️ CẢNH BÁO: MÁY BAY HẾT SẠCH ĐẠN DƯỢC! ⚠️", 24, 800, 1.4, 1.4, 0);
                draw_set_color(c_yellow);
                draw_text_ext_transformed(640, 185, "⚠️ CẢNH BÁO: MÁY BAY HẾT SẠCH ĐẠN DƯỢC! ⚠️", 24, 800, 1.4, 1.4, 0);
                
                draw_set_color(c_white);
                draw_text_ext_transformed(640, 265, "ẤN 'ENTER' ĐỂ ANH DŨNG HY SINH VÌ TỔ QUỐC,\nLAO THẲNG PHI THUYỀN TIÊU DIỆT SIÊU TÀU SÂN BAY ĐỊCH!", 26, 800, 1.25, 1.25, 0);
                
                draw_set_color(c_lime);
                var pulse_scale = 1.0 + sin(current_time * 0.02) * 0.04;
                draw_text_ext_transformed(640, 345, "[ ĐỘNG CƠ CẢM TỬ ĐÃ SẴN SÀNG - CHỈ CHỜ LỆNH ENTER ]", 24, 800, 0.95 * pulse_scale, 0.95 * pulse_scale, 0);
            } else {
                // Draw a high-tech tactical HUD overlay on the upper middle screen before the climactic sacrifice
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                
                var warning_pulse = 0.6 + abs(sin(current_time * 0.007)) * 0.4;
                draw_set_color(c_black);
                draw_text_ext_transformed(640 + 2, 250 + 2, ">> ĐANG TRUYỀN TIN TỪ PHÒNG LÁI <<", 24, 1100, 1.5, 1.5, 0);
                draw_set_color(make_color_rgb(255, 140, 0)); // orange glow
                draw_set_alpha(warning_pulse);
                draw_text_ext_transformed(640, 250, ">> ĐANG TRUYỀN TIN TỪ PHÒNG LÁI <<", 24, 1100, 1.5, 1.5, 0);
                
                draw_set_alpha(1.0);
                draw_set_color(c_white);
                draw_text_ext_transformed(640, 320, "Nhịp tim phi công ổn định... Sẵn sàng cống hiến vì Tổ quốc...", 24, 1100, 1.0, 1.0, 0);
            }
            
            // 5. Draw the beautiful Radio Dialogue Terminal Box (at the bottom)
            var box_x1 = 120;
            var box_y1 = 430;
            var box_x2 = 1160;
            var box_y2 = 590;
            
            // Background card
            draw_set_color(make_color_rgb(12, 16, 22));
            draw_set_alpha(0.92);
            draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);
            
            // Double glowing boundaries
            draw_set_alpha(1.0);
            draw_set_color(make_color_rgb(160, 30, 30)); // Dark red outer border
            draw_rectangle(box_x1, box_y1, box_x2, box_y2, true);
            draw_set_color(make_color_rgb(220, 190, 80)); // Gold inner border
            draw_rectangle(box_x1 + 2, box_y1 + 2, box_x2 - 2, box_y2 - 2, true);
            
            // LED Indicator (flashing red)
            var led_alpha = 0.4 + abs(sin(current_time * 0.01)) * 0.6;
            draw_set_color(c_red);
            draw_set_alpha(led_alpha);
            draw_circle(box_x1 + 30, box_y1 + 22, 6, false);
            draw_set_alpha(1.0);
            
            // Terminal Signal Header Text
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_set_color(make_color_rgb(255, 90, 90));
            draw_text(box_x1 + 45, box_y1 + 22, "● TRUYỀN TIN KHẨN CẤP / VŨ XUÂN THIỀU");
            
            // Animated Green Soundwave Visualizer
            var wave_x = box_x2 - 100;
            var wave_y = box_y1 + 22;
            for (var w = 0; w < 8; w++) {
                var bar_h = 4 + sin(current_time * 0.02 + w) * 10 + random_range(-2, 2);
                bar_h = clamp(bar_h, 2, 20);
                draw_set_color(c_lime);
                draw_rectangle(wave_x + w * 8, wave_y - bar_h/2, wave_x + w * 8 + 5, wave_y + bar_h/2, false);
            }
            
            // 6. Draw current monologue typewriter string
            var draw_str = string_copy(monologue_texts[monologue_index], 1, floor(monologue_char_count));
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            
            // Behind Shadow
            draw_set_color(c_black);
            draw_text_ext(box_x1 + 30 + 2, box_y1 + 45 + 2, draw_str, 24, 960);
            // Main front text (soft retro paper white)
            draw_set_color(make_color_rgb(245, 240, 220));
            draw_text_ext(box_x1 + 30, box_y1 + 45, draw_str, 24, 960);
            
            // 7. Advance Interaction Prompt
            var blink = (floor(current_time / 250) % 2 == 0);
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            
            var current_text = monologue_texts[monologue_index];
            var text_len = string_length(current_text);
            
            if (monologue_char_count < text_len) {
                if (blink) {
                    draw_set_color(c_gray);
                    draw_text(box_x2 - 30, box_y2 - 12, "Ấn SPACE để xem nhanh >>");
                }
            } else {
                if (monologue_index < array_length(monologue_texts) - 1) {
                    if (blink) {
                        draw_set_color(c_yellow);
                        draw_text(box_x2 - 30, box_y2 - 12, "Ấn SPACE hoặc ENTER để tiếp tục ->");
                    }
                } else {
                    if (blink) {
                        draw_set_color(c_orange);
                        draw_text(box_x2 - 30, box_y2 - 12, "[ Độc thoại hoàn tất - SẴN SÀNG QUYẾT TỬ ]");
                    }
                }
            }
            
            // Reset settings
            draw_set_alpha(1.0);
            draw_set_color(c_white);
            
            // Draw Hearts at top-left
            var heart_x = 30;
            var heart_y = 30;
            var target_w = 40;
            var scale = target_w / sprite_get_width(sHp);
            var spacing = target_w + 10;
            for (var i = 0; i < max_hp; i++) {
                if (i < hp) {
                    draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_white, 1.0);
                } else {
                    draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_black, 0.4);
                }
            }
            exit; // Bypass other standard drawing
        }

        // Draw wave announcement banner
        if (wave_announcement_timer > 0) {
            var alpha = min(1.0, wave_announcement_timer / 30);
            draw_set_font(fnt_vietnamese);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            // Transparent dark band across the screen
            draw_set_color(c_black);
            draw_set_alpha(0.6 * alpha);
            draw_rectangle(0, 250, 1280, 430, false);
            
            // Wave title text with soft shadow
            draw_set_alpha(alpha);
            var scale = 1.0 + sin(current_time * 0.015) * 0.04;
            
            var banner_title = "LƯỢT 2: QUYẾT CHIẾN BOSS RỒNG!";
            var banner_sub = "MÀN CHẮN BẢO VỆ ĐÃ KÍCH HOẠT - DIỆT HỘ TỐNG TRƯỚC!";
            var text_color = c_red;
            
            if (level_wave == 3) {
                banner_title = "LƯỢT 3: TÀU SÂN BAY CHIẾN HẠM CUỐI CÙNG!";
                banner_sub = "TIÊU DIỆT TÀU SÂN BAY ĐỊCH BẢO VỆ BẦU TRỜI ĐIỆN BIÊN PHỦ!";
                text_color = make_color_rgb(255, 140, 0); // Orange
            }
            
            draw_set_color(c_black);
            draw_text_ext_transformed(640 + 2, 300 + 2, banner_title, 24, 1100, 2.3 * scale, 2.3 * scale, 0);
            draw_set_color(text_color);
            draw_text_ext_transformed(640, 300, banner_title, 24, 1100, 2.3 * scale, 2.3 * scale, 0);
            
            draw_set_color(c_yellow);
            draw_text_ext_transformed(640, 380, banner_sub, 24, 1200, 1.1, 1.1, 0);
            
            // Reset draw settings
            draw_set_alpha(1.0);
            draw_set_color(c_white);
            draw_set_valign(fa_top); // default standard
        }

        // ----------------------------------------------------
        // WAVE TRANSITION COUNTDOWN TACTICAL RADIO TRANSMISSION GUI
        // ----------------------------------------------------
        if (variable_instance_exists(id, "wave_countdown") && wave_countdown > 0) {
            draw_set_font(fnt_vietnamese);
            
            // 1. Draw top countdown banner
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var secs = ceil(wave_countdown / 60);
            var pulse_scale = 1.0 + sin(current_time * 0.015) * 0.04;
            
            draw_set_color(c_black);
            draw_text_ext_transformed(640 + 2, 80 + 2, "CHUẨN BỊ CHIẾN ĐẤU LƯỢT " + string(next_wave) + " - ĐANG TRUYỀN TIN VÔ TUYẾN...", 24, 1100, 1.2 * pulse_scale, 1.2 * pulse_scale, 0);
            draw_set_color(c_yellow);
            draw_text_ext_transformed(640, 80, "CHUẨN BỊ CHIẾN ĐẤU LƯỢT " + string(next_wave) + " - ĐANG TRUYỀN TIN VÔ TUYẾN...", 24, 1100, 1.2 * pulse_scale, 1.2 * pulse_scale, 0);
            
            // 2. Select military radio dialogue text based on wave_dialog_index
            var wave_msg = "";
            var sender_title = "● TRUYỀN TIN MẶT ĐẤT / CHỈ HUY TRUNG ĐOÀN";
            var is_pilot = false;
            
            var d_index = 0;
            if (variable_instance_exists(id, "wave_dialog_index") && wave_dialog_index >= 0) {
                d_index = wave_dialog_index;
            }
            
            if (next_wave == 2) {
                if (d_index == 0) {
                    wave_msg = "Báo cáo Chỉ huy: Đợt tiêm kích phòng thủ vòng ngoài của địch đã bị phi đội ta xóa sổ hoàn toàn!";
                    sender_title = "● PHI CÔNG CHÍNH / KHÔNG QUÂN ĐIỆN BIÊN";
                    is_pilot = true;
                } else {
                    wave_msg = "Chỉ huy: Làm tốt lắm chiến sỹ! Cảnh giác, phi đội tiêm kích chủ lực cận vệ của địch đang cất cánh đánh chặn!";
                    sender_title = "● BỘ CHỈ HUY MẶT ĐẤT / TRUNG ĐOÀN TRƯỞNG";
                    is_pilot = false;
                }
            } else if (next_wave == 3) {
                if (d_index == 0) {
                    wave_msg = "Chỉ huy: Toàn đội chú ý! Siêu chiến hạm bay Tàu Sân Bay cuối cùng của địch đã lọt vào bầu trời Điện Biên Phủ!";
                    sender_title = "● BỘ CHỈ HUY MẶT ĐẤT / TRUNG ĐOÀN TRƯỞNG";
                    is_pilot = false;
                } else {
                    wave_msg = "Chỉ huy: Trận chiến sinh tử quyết định vận mệnh chiến dịch bắt đầu! Hãy chiến đấu dũng cảm, quyết giữ vững bầu trời!";
                    sender_title = "● BỘ CHỈ HUY MẶT ĐẤT / TRUNG ĐOÀN TRƯỞNG";
                    is_pilot = false;
                }
            }
            
            // 3. Draw Tactical Comms Box (at the bottom)
            var box_x1 = 120;
            var box_y1 = 430;
            var box_x2 = 1160;
            var box_y2 = 590;
            
            // Background card
            draw_set_color(make_color_rgb(12, 16, 22));
            draw_set_alpha(0.92);
            draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);
            
            // Double army green boundaries
            draw_set_alpha(1.0);
            draw_set_color(make_color_rgb(20, 120, 50)); // Army green outer border
            draw_rectangle(box_x1, box_y1, box_x2, box_y2, true);
            draw_set_color(make_color_rgb(220, 190, 80)); // Gold inner border
            draw_rectangle(box_x1 + 2, box_y1 + 2, box_x2 - 2, box_y2 - 2, true);
            
            // LED Indicator (flashing green)
            var led_alpha = 0.4 + abs(sin(current_time * 0.01)) * 0.6;
            draw_set_color(c_lime);
            draw_set_alpha(led_alpha);
            draw_circle(box_x1 + 30, box_y1 + 22, 6, false);
            draw_set_alpha(1.0);
            
            // Terminal Signal Header Text
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_set_color(is_pilot ? make_color_rgb(255, 180, 80) : make_color_rgb(100, 255, 100));
            draw_text(box_x1 + 45, box_y1 + 22, sender_title);
            
            // Animated soundwave visualizer
            var wave_x = box_x2 - 100;
            var wave_y = box_y1 + 22;
            for (var w = 0; w < 8; w++) {
                var bar_h = 4 + sin(current_time * 0.02 + w) * 10 + random_range(-2, 2);
                bar_h = clamp(bar_h, 2, 20);
                draw_set_color(c_lime);
                draw_rectangle(wave_x + w * 8, wave_y - bar_h/2, wave_x + w * 8 + 5, wave_y + bar_h/2, false);
            }
            
            // 4. Draw wave dialogue message
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            // Shadow
            draw_set_color(c_black);
            draw_text_ext(box_x1 + 30 + 2, box_y1 + 45 + 2, wave_msg, 24, 960);
            // Main front text (soft paper white)
            draw_set_color(make_color_rgb(245, 240, 220));
            draw_text_ext(box_x1 + 30, box_y1 + 45, wave_msg, 24, 960);
            
            // 5. Blinking prompt
            var blink = (floor(current_time / 250) % 2 == 0);
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            if (blink) {
                draw_set_color(c_yellow);
                draw_text(box_x2 - 30, box_y2 - 12, "Ấn SPACE hoặc ENTER để tiếp tục ->");
            }
            
            // Reset settings
            draw_set_alpha(1.0);
            draw_set_color(c_white);
            draw_set_valign(fa_top);
            draw_set_halign(fa_left);
        }

        // Draw 5 Hearts at top-left
        var heart_x = 30;
        var heart_y = 30;
        var target_w = 40; // Target width in pixels
        var scale = target_w / sprite_get_width(sHp);
        var spacing = target_w + 10; // Spacing includes width and gap
        
        for (var i = 0; i < max_hp; i++) {
            if (i < hp) {
                // Draw full heart
                draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_white, 1.0);
            } else {
                // Draw empty heart (silhouette)
                draw_sprite_ext(sHp, 0, heart_x + i * spacing, heart_y, scale, scale, 0, c_black, 0.4);
            }
        }
        
        // Draw Gold Currency Indicator
        draw_set_font(fnt_vietnamese);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text(heart_x, heart_y + 45, "🪙 " + string(gold) + " vàng");
        
        // Draw Shield Charges Indicator
        if (variable_instance_exists(id, "shield_charges") && shield_charges > 0) {
            draw_set_color(c_aqua);
            draw_text(heart_x, heart_y + 80, "🛡️ Khiên bảo vệ: ");
            for (var s = 0; s < shield_charges; s++) {
                draw_sprite_ext(sHp, 0, heart_x + 150 + s * spacing, heart_y + 80, scale, scale, 0, c_aqua, 1.0);
            }
        }
        
        // Draw Autofire Status Indicator
        if (variable_instance_exists(id, "has_autofire") && has_autofire) {
            draw_set_halign(fa_right);
            draw_set_color(autofire_active ? c_lime : c_gray);
            draw_text(1250, heart_y + 12, "ĐẠI BÁC LIÊN THANH: " + (autofire_active ? "TỰ ĐỘNG [BẬT]" : "CƠ TAY [TẮT]") + " (Nhấn E)");
        }
        
        // Reset settings
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
} else {
    // 1. Dark overlay background
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, 1280, 720, false);
    
    // 2. Game Over Text
    draw_set_alpha(1.0);
    draw_set_font(global.Font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Red title with soft shadow
    draw_set_color(c_black);
    draw_text(640 + 2, 300 + 2, "GAME OVER");
    draw_set_color(make_color_rgb(240, 60, 60));
    draw_text(640, 300, "GAME OVER");
    
    // Instructions
    draw_set_color(c_white);
    draw_text(640, 370, "Nhấn 'R' để chơi lại");
    
    draw_set_color(make_color_rgb(180, 190, 185));
    draw_text(640, 410, "Nhấn 'ESC' để quay lại Menu chọn màn");
    
    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

// 8. Draw Cinematic Crash Flash Overlay on top of everything
if (variable_instance_exists(id, "crash_flash") && crash_flash > 0) {
    draw_set_color(c_white);
    draw_set_alpha(crash_flash / 35);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
