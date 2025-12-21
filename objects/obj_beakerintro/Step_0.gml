image_alpha = approach(image_alpha, 0, 0.05);

if (obj_player.state == noone)
{
    if (start)
    {
        with (obj_player)
        {
            hsp = 0;
            movespeed = 0;
            vsp += 0.5;
            
            if (sprite_index == spr_player_spinout)
            {
                buffers.afterimageBlur = approach(buffers.afterimageBlur, 0, 1);
                
                if (buffers.afterimageBlur == 0)
                {
                    buffers.afterimageBlur = 4;
                    create_blur_effect(sprite_index, image_index, x, y, xscale);
                }
            }
            
            if (grounded && sprite_index == spr_player_spinout)
            {
                FMODevent_oneshot("event:/Sfx/Player/slam", x, y);
                sprite_index = spr_player_beakerintro;
                image_index = 0;
                image_speed = 0.35;
                shake_camera(15);
            }
            
            if (animation_end() && sprite_index == spr_player_beakerintro)
            {
                instance_destroy(other);
                state = states.normal;
                obj_camera.state = states.normal;
                sprite_index = spr_player_idle;
                image_index = 0;
            }
        }
    }
    else
    {
        obj_player.vsp = 0;
        obj_player.hsp = 0;
    }
}
