draw_set_font(global.smallfont);

if (!ds_list_empty(notifs))
{
    for (var i = 0; i < ds_list_size(notifs); i++)
    {
        draw_set_color(notifs[| i].color);
        draw_set_alpha(notifs[| i].alpha);
        draw_set_halign(fa_left);
        draw_text(16, obj_screensizer.displayHeight - 32 - (42 * i), string_lower(notifs[| i].text));
        draw_set_color(c_white);
        draw_set_alpha(1);
        notifs[| i].gotime--;
        notifs[| i].alpha = notifs[| i].gotime / 30;
        
        if (notifs[| i].gotime <= 0)
            ds_list_delete(notifs, i);
    }
}
