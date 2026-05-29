/// @description DrawHP

draw_self();

// Chỉ hiện HP khi rê chuột vào hoặc khi gần player
var ShowHp = position_meeting(mouse_x, mouse_y, self);

if instance_exists(NearestEnemy) {
	if distance_to_object(NearestEnemy) < 24 {
		ShowHp = true;
	}
}

// HP draw moved to Draw_64.gml