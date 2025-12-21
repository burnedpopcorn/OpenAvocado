if (ds_list_find_index(global.saveroom, id) == -1)
{
    ds_list_add(global.saveroom, id);
    global.level_timer = 0;
    
    with (obj_player)
    {
        state = noone;
        x = obj_doorA.x;
        y = -200;
        sprite_index = spr_player_spinout;
        image_speed = 0.35;
        vsp = 10;
        grounded = false;
        other.alarm[0] = 100;
    }
}
else
    instance_destroy();
