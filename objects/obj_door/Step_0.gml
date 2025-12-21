if (obj_player.state == states.enterdoor && !instance_exists(obj_fadeout) && obj_player.x == (x + (sprite_width / 2)))
    instance_create_depth(x, y, 0, obj_fadeout);
