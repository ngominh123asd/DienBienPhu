/// @description Draw to GUI

if MouseOver{

	//Draw black rect
	draw_set_color(c_black);
	draw_rectangle(10,10,200,320,0)
	
	//Draw grey rect
	draw_set_alpha(0.5); //Set alpha to 50% opaque
	draw_set_color(c_dkgray);
	draw_rectangle(15,15,195,315,0);
	
	draw_set_alpha(1); //Reset alpha
	
	//Draw Stats
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text(100,20,"Stats");
	draw_set_halign(fa_left);
	
	draw_text(20,60,"Name: " + string(Name)); //Name
	draw_text(20,90,"HP: " + string(CurHp) + "/" + string(MaxHp));
	
	draw_text(20,140,"Level: " + string(Level)); //Level
	draw_text(20,170,"XP: " + string(Experience)); //Experience
	
	draw_text(20,220,"Power: " + string(Power)); //Power
	draw_text(20,250,"Fortitude: " + string(Fort)); //Fort
	draw_text(20,280,"Luck: " + string(Luck)); //Luck
}

// Draw the "Right click!" prompt
if (!instance_exists(oCamera)) exit;

var NearPlayer = instance_nearest(x,y,oPar_PlayerUnit);

if distance_to_object(NearPlayer) < 5{
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