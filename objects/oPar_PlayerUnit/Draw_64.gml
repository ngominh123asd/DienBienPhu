/// @description Draw to GUI

#region Draw Stats
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
	draw_text(20,170,"XP: " + string(Experience) + "/" + string(NextLevelExp)); //Experience
	
	draw_text(20,220,"Power: " + string(Power)); //Power
	draw_text(20,250,"Fortitude: " + string(Fort)); //Fort
	draw_text(20,280,"Luck: " + string(Luck)); //Luck
}

#endregion
