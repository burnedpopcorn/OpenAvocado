if (!ds_list_empty(collectVis))
{
    for (var i = 0; i < ds_list_size(collectVis); i++)
    {
        var q = collectVis[| i];
        
        with (q)
            draw_sprite_ext(sprite_index, 4, x, y, 1, 1, 0, c_white, 1);
    }
}

with (kettle)
{
    draw_sprite(spr_kettleScore, 0, kx, ky);
    draw_set_font(global.kettleFont);
    draw_set_halign(fa_center);
    draw_text(kx + 16, ky - 4, global.collect);
    var rankindex = 0;
    
    if (global.collect >= global.Srank)
        rankindex = 4;
    else if (global.collect >= global.Arank)
        rankindex = 3;
    else if (global.collect >= global.Brank)
        rankindex = 2;
    else if (global.collect >= global.Crank)
        rankindex = 1;
    
    if (previousRank != rankindex)
    {
        previousRank = rankindex;
        rankScale = 2;
    }
    
    var rankX = x + (sin(current_time * 0.001) * 2);
    var rankY = y + (cos(current_time * 0.001) * 2);
    draw_sprite(spr_kettleCloud1, cloudIndex, rankX + 121, mean(rankY, ky) - 54);
    draw_sprite(spr_kettleCloud2, cloudIndex, rankX + 154, rankY - 46);
    draw_sprite(spr_kettleCloud3, cloudIndex, rankX + 160, rankY);
    draw_sprite_ext(spr_hudRanks, rankindex, rankX + 160, rankY, rankScale, rankScale, 0, c_white, 1);
    var perc = 0;
    
    switch (rankindex)
    {
        case 5:
            perc = 1;
            break;
        
        case 4:
            perc = 0;
            break;
        
        case 3:
            perc = (global.collect - global.Arank) / (global.Srank - global.Arank);
            break;
        
        case 2:
            perc = (global.collect - global.Brank) / (global.Arank - global.Brank);
            break;
        
        case 1:
            perc = (global.collect - global.Crank) / (global.Brank - global.Crank);
            break;
        
        default:
            perc = global.collect / global.Crank;
            break;
    }
    
    var amt = sprite_get_height(spr_hudRanksFill) * perc;
    var top = sprite_get_height(spr_hudRanksFill) - amt;
    var xo = sprite_get_xoffset(spr_hudRanksFill);
    var yo = sprite_get_yoffset(spr_hudRanksFill);
    draw_sprite_part_ext(spr_hudRanksFill, rankindex, 0, top, sprite_get_width(spr_hudRanksFill), sprite_get_height(spr_hudRanksFill) - top, (rankX + 160) - xo, (rankY - yo) + top, rankScale, rankScale, c_white, 1);
}

with (tv)
{
    if (sprite_index != spr_tv_turnon)
        draw_sprite(spr_tv_bg, 0, x, y);
    
    pal_swap_set(obj_player.spr_palette, obj_player.palIndex, false);
    draw_sprite(sprite_index, image_index, x, y);
    shader_reset();
    pattern_draw(sprite_index, image_index, x, y, 1, 1, 0, c_white, 1, global.patternSpr, spr_playerPatColors);
    
    if (state == states.move)
        draw_sprite(spr_tv_switch, switchindex, x, y);
    
    draw_set_font(font_caption);
}

draw_set_font(global.smallfont);
draw_set_color(c_white);
draw_set_halign(fa_right);
var _xx = obj_screensizer.displayWidth - 32;
var _yy = obj_screensizer.displayHeight - 32;
global.save_timer++;

if (global.level != noone)
    global.level_timer++;

draw_text(_xx, _yy, calculateTime(global.save_timer));
draw_text(_xx, _yy - 16, calculateTime(global.level_timer));

if (global.debug)
{
    if (obj_player.x < 0 || obj_player.x > room_width || obj_player.y < 0 || obj_player.y > room_height)
    {
        var _x = obj_player.x - camera_get_view_x(view_camera[0]);
        _x = clamp(_x, 32, obj_screensizer.displayWidth - 32);
        var _y = obj_player.y - camera_get_view_y(view_camera[0]);
        _y = clamp(_y, 32, obj_screensizer.displayHeight - 32);
        draw_sprite(obj_player.sprite_index, obj_player.image_index, _x, _y);
    }
    
    draw_set_font(global.bigfont);
    draw_set_halign(fa_left);
    var _vars = [];
    array_push(_vars, $"X: {obj_player.x}");
    array_push(_vars, $"Y: {obj_player.y}");
    array_push(_vars, $"VSP: {floor(obj_player.vsp)}");
    array_push(_vars, $"HSP: {floor(obj_player.hsp)}");
    
    if (instance_exists(obj_server))
    {
        array_push(_vars, ds_list_size(obj_server.connections));
        array_push(_vars, instance_number(obj_onlinePlayer));
    }
    
    for (var i = 0; i < array_length(_vars); i++)
        draw_text(32, 100 + (32 * i), _vars[i]);
}
