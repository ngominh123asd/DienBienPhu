/// @description Draw to GUI

if MouseOver{

	//Draw black rect
	draw_set_color(c_black);
	draw_rectangle(10,390,200,700,0)
	
	//Draw grey rect
	draw_set_alpha(0.5); //Set alpha to 50% opaque
	draw_set_color(c_dkgray);
	draw_rectangle(15,395,195,695,0);
	
	draw_set_alpha(1); //Reset alpha
	
	//Draw Stats
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text(100,400,"Stats");
	draw_set_halign(fa_left);
	
	draw_text(20,440,"Name: " + string(Name)); //Name
	draw_text(20,470,"HP: " + string(CurHp) + "/" + string(MaxHp));
	
	draw_text(20,520,"Level: " + string(Level)); //Level
	draw_text(20,550,"XP: " + string(Experience)); //Experience
	
	draw_text(20,600,"Power: " + string(Power)); //Power
	draw_text(20,630,"Fortitude: " + string(Fort)); //Fort
	draw_text(20,660,"Luck: " + string(Luck)); //Luck
}

// Draw the "Right click!" prompt
if (!instance_exists(oCamera)) exit;

var NearPlayer = instance_nearest(x,y,oPar_PlayerUnit);

if (NearPlayer != noone && distance_to_object(NearPlayer) < 5) {
	//Prompt to click
	if position_meeting(mouse_x,mouse_y,self){
		
        var cx = oCamera.x;
        var cy = oCamera.y;
        var cw = oCamera.CamInitW * oCamera.ZoomFactor;
        var ch = oCamera.CamInitH * oCamera.ZoomFactor;

        var gw = 1280; // display_get_gui_width()
        var gh = 720;  // display_get_gui_height()

        var gui_x = ((x - cx) / cw) * gw + (gw / 2);
        var gui_y = ((y - 5 - cy) / ch) * gh + (gh / 2);

        draw_set_font(fnt_vietnamese);
		draw_set_halign(fa_center);

		draw_set_color(c_black);
		draw_text(gui_x + 2, gui_y + 2, "Right click!");

		draw_set_color(c_white);
		draw_text(gui_x, gui_y, "Right click!");	

		draw_set_halign(fa_left);
	}
}