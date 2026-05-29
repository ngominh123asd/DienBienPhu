/// @description Text follow NPC

if (instance_exists(Parent)) {
    x = Parent.x;
    y = Parent.y;
}

life_timer -= 1;

if (life_timer <= 0) {
    instance_destroy();
}