if (!instance_exists(obj_option))
{
    if (active)
    {
        draw_sprite(screenSprite, 0, 0, 0);
        draw_set_alpha(graphBack.alpha);
        draw_sprite_tiled(spr_pauseGraph, 0, graphBack.x, graphBack.y);
        draw_sprite_ext(spr_disc, disc.index, obj_screensizer.displayWidth - 50, obj_screensizer.displayHeight - 100, abs(disc.xscale), 1, disc.rotation, c_white, graphBack.alpha / 0.55);
        draw_set_alpha(1);
        var xx = obj_screensizer.displayWidth / 2;
        var yy = (obj_screensizer.displayHeight / 2) - (48 * (array_length(options) / 2));
        
        for (var i = 0; i < array_length(options); i++)
        {
            var q = options[i];
            
            if (is_struct(q))
            {
                draw_set_font(global.bigfont);
                draw_set_color((selected == i) ? c_white : c_gray);
                draw_set_halign(fa_center);
                draw_textEX(xx, yy + (48 * i), lang_get_phrase(q.option));
            }
        }
    }
    
    draw_sprite_ext(spr_pauseBorder, 0, obj_screensizer.displayWidth / 2, obj_screensizer.displayHeight / 2, graphBorderSize, graphBorderSize, 0, c_white, 1);
    graphBorderSize = lerp(graphBorderSize, active ? 1 : 2, 0.15);
    
    if (active)
    {
        draw_set_font(global.smallfont);
        draw_set_color(c_white);
        draw_set_halign(fa_right);
        var xx = obj_screensizer.displayWidth - 32;
        var yy = obj_screensizer.displayHeight - 32;
        draw_text(xx, yy, calculateTime(global.save_timer));
        draw_text(xx, yy - 16, calculateTime(global.level_timer));
    }
}
