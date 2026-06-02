/// @description Free dynamically loaded sprites

if (variable_instance_exists(id, "shop_sprite") && sprite_exists(shop_sprite)) {
    sprite_delete(shop_sprite);
}

if (variable_instance_exists(id, "part_sprites") && is_array(part_sprites)) {
    for (var i = 0; i < array_length(part_sprites); i++) {
        if (sprite_exists(part_sprites[i])) {
            sprite_delete(part_sprites[i]);
        }
    }
}
