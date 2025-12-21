if (hitstun.is == false)
{
    event_inherited();
    
    switch (state)
    {
        case states.stun:
            scr_enemy_stun();
            break;
        
        case states.hit:
            scr_enemy_hit();
            break;
        
        case states.turn:
            scr_enemy_turn();
            break;
        
        case states.move:
            attackTimer--;
            image_speed = 0.35;
            hsp = movespeed * xscale;
            movespeed = 4;
            
            if (buffers.step <= 0)
            {
                buffers.step = 45;
                create_particleStatic(spr_cloudeffect, x, y + 42, 1, 1);
            }
            
            buffers.step--;
            sprite_index = spr_move;
            
            if (place_meeting(x + xscale, y, obj_solid) || place_meeting(x + xscale, y, obj_hallway))
            {
                image_speed = 0.35;
                vsp = -4;
                xscale *= -1;
            }
            
            break;
        
        case states.grab:
            scr_enemy_grabbed();
            break;
        
        case states.thrown:
            scr_enemy_thrown();
            break;
        
        case states.uppercut:
            if (sprite_index == spr_gnome_attackstart)
            {
                hsp = 0;
                movespeed = 0;
                vsp = 0;
                
                if (animation_end())
                {
                    sprite_index = spr_gnome_attack;
                    image_index = 0;
                    movespeed = 8;
                    
                    if (obj_player.x != x)
                        xscale = sign(obj_player.x - x);
                }
            }
            else
            {
                afterimageBlur = approach(afterimageBlur, 0, 1);
                
                if (afterimageBlur == 0)
                {
                    afterimageBlur = 3;
                    create_buzzsawAfterimage(sprite_index, image_index, x, y, xscale);
                }
                
                hsp = movespeed * xscale;
                sprite_index = spr_gnome_attack;
                image_speed = 0.5;
                
                if (animation_end())
                {
                    state = states.move;
                    attackTimer = random_range(60, 150);
                }
            }
            
            break;
    }
    
    if (attackTimer <= 0)
    {
        attackTimer = 60;
        state = states.uppercut;
        sprite_index = spr_gnome_attackstart;
        image_index = 0;
    }
    
    hitbox = state == states.uppercut && sprite_index == spr_gnome_attack;
    
    if (hitbox == true)
    {
        if (!instance_exists(hitboxInst))
        {
            hitboxInst = instance_create_depth(x, y, depth, obj_forkbox);
            
            with (hitboxInst)
                enemy_inst = other;
        }
    }
    else if (instance_exists(hitboxInst))
    {
        instance_destroy(hitboxInst);
        hitboxInst = noone;
    }
}
else if (hitstun.time >= 0)
{
    image_speed = 0;
    x = hitstun.x + irandom_range(-5, 5);
    y = hitstun.y + irandom_range(-5, 5);
    hitstun.time--;
}
else
{
    x = hitstun.x;
    y = hitstun.y;
    hitstun.is = false;
}
