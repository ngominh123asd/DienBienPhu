/// @description Control

MouseOver = position_meeting(mouse_x, mouse_y, self);
LClick = mouse_check_button_pressed(mb_left);
RClick = mouse_check_button_pressed(mb_right);
Cancel = keyboard_check_pressed(vk_escape);
NextLevelExp = round((Level + 1.33) * 3); //Next level xp

#region Die

if CurHp <= 0 {
	
	instance_create_layer(x, y, "Instances", oFx_DeadPlayer); //Body
	var DeathText = instance_create_layer(x, y, "Instances", oFx_DeathText); //Text
	DeathText.Text = string(Name) + " Died.";
	
	audio_play_sound(sndDie, 10, 0); //Sound
	instance_destroy();	
}

#endregion


#region Select/Deselect/ Set Dest

//Select unit
if LClick && MouseOver {
	Selected = 1;
}
//Unselect
else if (LClick && !MouseOver) || Cancel {
	Selected = 0;
}

//Controls if selected
if Selected {
	// Logic moved to oCont_Room for smart formations
}

#endregion


#region Fight

if instance_exists(oPar_Enemy) {
	
	//Get nearest enemy
	NearestEnemy = instance_nearest(x, y, oPar_Enemy);
	
	// Only auto-aggro (chase) if not currently ordered to move by the user
	if distance_to_point(DestX, DestY) <= 5 {
		if distance_to_object(NearestEnemy) < 24 {
			DestX = NearestEnemy.x;
			DestY = NearestEnemy.y;
		}
	}
	
	//Attack when in range
	if distance_to_object(NearestEnemy) < AttackDist {
		
		//Attack if can
		if CanAttack {
			event_user(0);
		}
		
		// Only stop moving and exit if the unit is NOT currently ordered to move by the user
		if distance_to_point(DestX, DestY) <= 5 {
			exit;
		}
	}
}

#endregion

#endregion

#endregion

#endregion


#region Move

//Move to point
if distance_to_point(DestX, DestY) > 5 {
	
	mp_potential_step_object(DestX, DestY, Spd, oPar_Collidable); //Move
	image_speed = 1; //Animate
}
else {
	
	//Don't animate
	image_speed = 0;
	image_index = 0;
}

#endregion


#region Convert Villagers

if distance_to_object(oFr_Villager) < 5 {
	
	//If right click and near villager
	if RClick && instance_place(mouse_x, mouse_y, oFr_Villager) {
		
		//Declare villager
		var Inst = instance_place(mouse_x, mouse_y, oFr_Villager);
		
		//With villager
		with (Inst) {
			
			var UnitClass = irandom(3);
			audio_play_sound(sndConvert, 10, 0);
			
			switch(UnitClass) {
				
				#region Soldier
				case 0:
				case 1: {
					
					var NewUnit = instance_create_layer(x, y, "Instances", oFr_Soldier);
					
					if sprite_index == sFr_Villager0 || sprite_index == sFr_Villager1 {
						NewUnit.SprRight = sFr_Soldier01;
						NewUnit.SprLeft  = sFr_Soldier01_left;
					}
					else {
						NewUnit.SprRight = sFr_Soldier23;
						NewUnit.SprLeft  = sFr_Soldier23_left;
					}
					
					NewUnit.sprite_index = NewUnit.SprRight;
					
					break;
				}
				#endregion
				
				
				#region Archer
				case 2: {
					
					var NewUnit = instance_create_layer(x, y, "Instances", oFr_Archer);
					
					var spr_pick = irandom(1);
					
					if spr_pick == 0 {
						NewUnit.SprRight = sFr_Archer01;
						NewUnit.SprLeft  = sFr_Archer01_left;
					}
					else {
						NewUnit.SprRight = sFr_Archer23;
						NewUnit.SprLeft  = sFr_Archer23_left;
					}
					
					NewUnit.sprite_index = NewUnit.SprRight;
					
					break;
				}
				#endregion
				
				
				#region Mage
				case 3: {
					
					var NewUnit = instance_create_layer(x, y, "Instances", oFr_Mage);
					
					var spr_pick = irandom(1);
					
					if spr_pick == 0 {
						NewUnit.SprRight = sFr_Mage01;
						NewUnit.SprLeft  = sFr_Mage01_left;
					}
					else {
						NewUnit.SprRight = sFr_Mage23;
						NewUnit.SprLeft  = sFr_Mage23_left;
					}
					
					NewUnit.sprite_index = NewUnit.SprRight;
					
					break;
				}
				#endregion
			}	
			
			//Set stats to villager
			NewUnit.Name = Name;
			NewUnit.Level = Level;
			NewUnit.Experience = Experience;
			NewUnit.MaxHp = MaxHp;
			NewUnit.CurHp = CurHp;
			NewUnit.Power = Power;
			NewUnit.Luck = Luck;
			NewUnit.Fort = Fort;
			
			instance_destroy();
		}
		
		//Show funny text, set parent
		var ShowText = instance_create_layer(x, y, "Instances", oFx_ConvertText);
		ShowText.Parent = NewUnit;
	}
}

#endregion


#region Level Up

if Experience > NextLevelExp {
	
	Level++;
	Experience = 0;
	MaxHp += choose(1, 3);
	CurHp = MaxHp;
	Power += choose(0, 1);
	Luck += choose(0, 0, 1);
	Fort += choose(0, 1, 1);
	
	var LvlUp = instance_create_layer(x, y, "Instances", oFx_LevelUp);
	LvlUp.Parent = self;
	
	audio_play_sound(sndLevelUp, 10, 0);
}

#endregion


#region Sprite Left/Right
#region Sprite Left/Right

// Fix scale riêng cho dân làng
if object_index == oFr_Villager {
	
	UnitScale = 0.25;
	
	if x > xprevious {
		image_xscale = UnitScale;
	}
	else if x < xprevious {
		image_xscale = -UnitScale;
	}
	else {
		if image_xscale < 0 {
			image_xscale = -UnitScale;
		}
		else {
			image_xscale = UnitScale;
		}
	}
	
	image_yscale = UnitScale;
}



// Archer: lật trái/phải nhưng vẫn giữ đúng sprite 01 hoặc 23
if object_index == oFr_Archer {
	
	if !variable_instance_exists(id, "SprRight") {
		
		if sprite_index == sFr_Archer23 || sprite_index == sFr_Archer23_left {
			SprRight = sFr_Archer23;
			SprLeft  = sFr_Archer23_left;
		}
		else {
			SprRight = sFr_Archer01;
			SprLeft  = sFr_Archer01_left;
		}
	}
	
	if x > xprevious {
		sprite_index = SprRight;
	}
	else if x < xprevious {
		sprite_index = SprLeft;
	}
}


// Mage: lật trái/phải nhưng vẫn giữ đúng sprite 01 hoặc 23
if object_index == oFr_Mage {
	
	if !variable_instance_exists(id, "SprRight") {
		
		if sprite_index == sFr_Mage23 || sprite_index == sFr_Mage23_left {
			SprRight = sFr_Mage23;
			SprLeft  = sFr_Mage23_left;
		}
		else {
			SprRight = sFr_Mage01;
			SprLeft  = sFr_Mage01_left;
		}
	}
	
	if x > xprevious {
		sprite_index = SprRight;
	}
	else if x < xprevious {
		sprite_index = SprLeft;
	}
}


// Soldier: lật trái/phải nhưng vẫn giữ đúng sprite 01 hoặc 23
if object_index == oFr_Soldier {
	
	if !variable_instance_exists(id, "SprRight") {
		
		if sprite_index == sFr_Soldier23 || sprite_index == sFr_Soldier23_left {
			SprRight = sFr_Soldier23;
			SprLeft  = sFr_Soldier23_left;
		}
		else {
			SprRight = sFr_Soldier01;
			SprLeft  = sFr_Soldier01_left;
		}
	}
	
	if x > xprevious {
		sprite_index = SprRight;
	}
	else if x < xprevious {
		sprite_index = SprLeft;
	}
}

#endregion


#region Separation

// Tach cac unit ra de khong dinh vao nhau, nhung khong bi day vao vat can
var sep_dist = 3;
var sep_force = 0.03;

with (oPar_PlayerUnit) {
	
	if id != other.id {
		
		var d = point_distance(x, y, other.x, other.y);
		
		if d > 0 && d < sep_dist {
			
			// Huong day unit nay ra xa unit dang chay code
			var dir = point_direction(other.x, other.y, x, y);
			
			var move_x = lengthdir_x(sep_force, dir);
			var move_y = lengthdir_y(sep_force, dir);
			
			// Chi day truc X neu khong va vao vat can
			if !place_meeting(x + move_x, y, oPar_Collidable) {
				x += move_x;
			}
			
			// Chi day truc Y neu khong va vao vat can
			if !place_meeting(x, y + move_y, oPar_Collidable) {
				y += move_y;
			}
		}
	}
}

#endregion