function scr_player_surfing()
{
    get_input();
    
    if (sprite_index == spr_player_surfing)
    {
        vsp = movespeedSurfing;
        hsp = movespeed * xscale;
        movespeed = approach(movespeed, 15, 1);
        sprite_index = spr_player_surfing;
        image_speed = 0.35;
        
        if (!place_meeting(x, y, obj_beer))
        {
            movespeed = abs(movespeed);
            state = states.mach2;
            sprite_index = spr_player_longjump;
            image_index = 0;
            jumpstop = true;
            create_particleDebri(spr_surfback, 0, x, y, xscale, -1);
            movespeedSurfing = 0;
        }
        
        if (place_meeting(x + hsp, y, obj_solid) && !place_meeting(x + hsp, y, obj_slope))
            movespeed = -15;
        
        if (grounded)
            movespeedSurfing = -10;
        
        if (key_down)
            movespeedSurfing = lerp(movespeedSurfing, 10, 0.1);
        else if (key_up)
            movespeedSurfing = lerp(movespeedSurfing, -10, 0.1);
        else
            movespeedSurfing = lerp(movespeedSurfing, 0, 0.05);
        
        buffers.afterimageBlur = approach(buffers.afterimageBlur, 0, 1);
        
        if (buffers.afterimageBlur == 0)
        {
            buffers.afterimageBlur = 3;
            create_blur_effect(sprite_index, image_index, x, y, xscale);
        }
        
        buffers.dashcloud--;
        
        if (buffers.dashcloud <= 0)
        {
            buffers.dashcloud = 12;
            create_particleStatic(spr_dashcloud1, x, y, xscale, 1);
        }
    }
    else if (sprite_index == spr_player_spinout)
    {
        hsp = movespeed * xscale;
        movespeed = -4;
    }
}
