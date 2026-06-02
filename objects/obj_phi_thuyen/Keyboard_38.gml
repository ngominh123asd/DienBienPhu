if (!alive) { speed = 0; exit; }
if (variable_instance_exists(id, "state") && state != "play") { speed = 0; exit; }
speed = variable_instance_exists(id, "move_speed") ? move_speed : 7;
direction = 90;