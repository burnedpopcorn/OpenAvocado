draw_set_color(c_white);
draw_sprite_tiled_ext(spr_optionsBG, 0, BGX, BGY, 1, 1, c_white, 1);

for (var i = 0; i < array_length(backgrounds); i++)
{
    draw_sprite_tiled_ext(spr_optionsBG, backgrounds[i].index, BGX, BGY, 1, 1, c_white, backgrounds[i].alpha);
    
    if (backgrounds[i].menu != [Menus.Main])
    {
        var _alpha = 0;
        
        for (var q = 0; q < array_length(backgrounds[i].menu); q++)
        {
            if (currentmenu == backgrounds[i].menu[q])
                _alpha = 1;
        }
        
        backgrounds[i].alpha = approach(backgrounds[i].alpha, _alpha, 0.1);
    }
    else
        backgrounds[i].alpha = 1;
}

var m = menus[currentmenu];
var opt = m.options;
var _length = array_length(opt);

switch (m.anchor)
{
    case Menus.AnchorMainMenu:
        var xx = obj_screensizer.displayWidth / 2;
        var yy = (obj_screensizer.displayHeight / 2) - ((m.ypad * _length) / 2);
        
        for (var i = 0; i < _length; i++)
        {
            var q = opt[i];
            var _col = (selected == i) ? c_white : c_gray;
            draw_set_font(global.bigfont);
            draw_set_color(_col);
            draw_set_halign(fa_center);
            draw_textEX(xx, yy + (m.ypad * i), lang_get_phrase(q.name));
            
            if (is_struct(q.icon))
            {
                draw_set_alpha(q.icon.alpha);
                draw_sprite(spr_pauseicons, q.icon.index, floor((xx + irandom_range(-1, 1)) - (string_width(lang_get_phrase(q.name)) / 2) - 50), floor(yy + (m.ypad * i) + irandom_range(-1, 1)));
                draw_set_alpha(1);
                q.icon.alpha = approach(q.icon.alpha, selected == i, 0.1);
            }
        }
        
        break;
    
    case Menus.AnchorNormalMenu:
        var xx = obj_screensizer.displayWidth / 5;
        var yy = (obj_screensizer.displayHeight / 2) - ((m.ypad * _length) / 2);
        
        for (var i = 0; i < _length; i++)
        {
            draw_set_font(global.bigfont);
            var _col = (selected == i) ? c_white : c_gray;
            draw_set_color(_col);
            var q = opt[i];
            
            switch (q.type)
            {
                case Menus.OptionText:
                    draw_set_halign(fa_left);
                    draw_textEX(xx, yy + (m.ypad * i), lang_get_phrase(q.name));
                    break;
                
                case Menus.OptionToggle:
                    draw_set_halign(fa_left);
                    draw_textEX(xx, yy + (m.ypad * i), lang_get_phrase(q.name));
                    draw_set_halign(fa_right);
                    draw_textEX(obj_screensizer.displayWidth - xx, yy + (m.ypad * i), lang_get_phrase(q.toggle[q.val]));
                    break;
                
                case Menus.OptionSlider:
                    if (selected != i && q.moving)
                        q.moving = false;
                    
                    draw_set_halign(fa_left);
                    draw_textEX(xx, yy + (m.ypad * i), lang_get_phrase(q.name));
                    draw_set_halign(fa_right);
                    draw_sprite(spr_slider, 0, obj_screensizer.displayWidth - xx - 150, yy + (m.ypad * i));
                    draw_sprite((currentmenu != 1) ? spr_slidericon2 : spr_slidericon, q.moving, (obj_screensizer.displayWidth - xx - 150) + (200 * (q.val / 100)), yy + (m.ypad * i) + 12);
                    break;
            }
        }
        
        break;
    
    case Menus.AnchorInputMenu:
        draw_set_halign(fa_left);
        draw_sprite(spr_tutorialkey, 0, 56, (obj_screensizer.displayHeight - 192) + 2);
        draw_set_color(c_black);
        draw_set_font(global.npcfont);
        draw_set_halign(fa_left);
        draw_text(59, obj_screensizer.displayHeight - 192 - 6, "F1");
        draw_set_color(c_white);
        draw_set_font(global.creditsfont);
        draw_textEX(64, obj_screensizer.displayHeight - 128, lang_get_phrase("option_add_bind"));
        draw_text(128, obj_screensizer.displayHeight - 192, lang_get_phrase("option_reset_binds"));
        draw_textEX(64, obj_screensizer.displayHeight - 64, lang_get_phrase("option_clear_binds"));
        
        for (var i = 0; i < _length; i++)
        {
            draw_set_font(global.bigfont);
            var _col = (selected == i) ? c_white : c_gray;
            draw_set_color(_col);
            var q = opt[i];
            
            switch (q.type)
            {
                case Menus.OptionText:
                    var xx = obj_screensizer.displayWidth / 5;
                    var yy = 16 + m.ypad;
                    draw_set_halign(fa_left);
                    draw_textEX(xx, yy + (m.ypad * i), lang_get_phrase(q.name));
                    break;
                
                case Menus.OptionInputRemap:
                    var xx = (obj_screensizer.displayWidth / 2) - 16;
                    var yy = (16 + m.ypad) - keyScroll;
                    draw_set_color(_col);
                    keyScroll = lerp(keyScroll, 48 * (selected - 1), 0.02);
                    
                    if (!is_string(q.iconIndex))
                        draw_sprite_ext(spr_controlicons, q.iconIndex, xx, yy + (m.ypad * i), 1, 1, 0, _col, 1);
                    else
                    {
                        draw_set_font(global.bigfont);
                        draw_set_halign(fa_left);
                        draw_textEX(xx - 16, yy + (m.ypad * i), q.iconIndex);
                    }
                    
                    draw_set_halign(fa_right);
                    
					// again WHY
					#region Input shit AGAIN
                    for (var p = 0; p < array_length(variable_struct_get(global.inputMap, q.key)); p++)
                    {
                        if (currentmenu == 6)
                        {
                            switch (array_get(variable_struct_get(global.inputMap, q.key), p))
                            {
                                case vk_left:
                                    draw_sprite(spr_tutorialkeyspecial, 6, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case vk_down:
                                    draw_sprite(spr_tutorialkeyspecial, 4, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case vk_up:
                                    draw_sprite(spr_tutorialkeyspecial, 3, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case vk_right:
                                    draw_sprite(spr_tutorialkeyspecial, 5, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case vk_space:
                                    draw_sprite(spr_tutorialkeyspecial, 2, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case vk_control:
                                    draw_sprite(spr_tutorialkeyspecial, 1, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case vk_escape:
                                    draw_sprite(spr_tutorialkeyspecial, 7, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case vk_shift:
                                    draw_sprite(spr_tutorialkeyspecial, 0, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                default:
                                    draw_sprite(spr_tutorialkey, 0, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    draw_set_color(c_black);
                                    draw_set_font(global.npcfont);
                                    draw_set_halign(fa_left);
                                    draw_text(obj_screensizer.displayWidth - 64 - (42 * p), (yy + (m.ypad * i)) - 6, chr(array_get(variable_struct_get(global.inputMap, q.key), p)));
                                    break;
                            }
                        }
                        
                        if (currentmenu == 8)
                        {
                            switch (array_get(variable_struct_get(global.inputMap, q.key), p))
                            {
                                case gp_face1:
                                    draw_sprite(global.buttonSpr, 0, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_face2:
                                    draw_sprite(global.buttonSpr, 1, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_face3:
                                    draw_sprite(global.buttonSpr, 2, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_face4:
                                    draw_sprite(global.buttonSpr, 3, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_shoulderl:
                                    draw_sprite(global.buttonSpr, 4, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_shoulderr:
                                    draw_sprite(global.buttonSpr, 5, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_shoulderrb:
                                    draw_sprite(global.buttonSpr, 6, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_shoulderlb:
                                    draw_sprite(global.buttonSpr, 7, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_stickl:
                                    draw_sprite(global.buttonSpr, 8, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_stickr:
                                    draw_sprite(global.buttonSpr, 9, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_padu:
                                    draw_sprite(global.buttonSpr, 10, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_padr:
                                    draw_sprite(global.buttonSpr, 11, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_padd:
                                    draw_sprite(global.buttonSpr, 12, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_padl:
                                    draw_sprite(global.buttonSpr, 13, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_start:
                                    draw_sprite(global.buttonSpr, 14, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case gp_select:
                                    draw_sprite(global.buttonSpr, 15, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case "joyLL":
                                    draw_sprite(global.joystickSpr, 0, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case "joyLR":
                                    draw_sprite(global.joystickSpr, 1, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case "joyLU":
                                    draw_sprite(global.joystickSpr, 2, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case "joyLD":
                                    draw_sprite(global.joystickSpr, 3, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case "joyRL":
                                    draw_sprite(global.joystickSpr, 4, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case "joyRR":
                                    draw_sprite(global.joystickSpr, 5, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case "joyRU":
                                    draw_sprite(global.joystickSpr, 6, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                                
                                case "joyRD":
                                    draw_sprite(global.joystickSpr, 7, obj_screensizer.displayWidth - 64 - (42 * p) - 8, yy + (m.ypad * i) + 2);
                                    break;
                            }
                        }
                    }
                    #endregion
					
                    break;
            }
        }
        
        break;
}

draw_set_color(c_white);

if (changingBind)
{
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_rectangle(0, 0, obj_screensizer.displayWidth, obj_screensizer.displayHeight, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(global.bigfont);
    draw_set_halign(fa_center);
    draw_textEX(obj_screensizer.displayWidth / 2, obj_screensizer.displayHeight / 2, "PRESS ANY KEY");
}
