surface_reset_target();
draw_clear(c_black);
gpu_set_blendenable(false);
draw_sprite_tiled(spr_letterbox, 0, 0, 0);
draw_rectangle_color(-1, -1, obj_screensizer.displayWidth + 1, obj_screensizer.displayHeight + 1, c_black, c_black, c_black, c_black, false);
draw_surface_stretched(gameSurface, 0 + ((obj_screensizer.displayWidth / 2) * (1 - size)), 0 + ((obj_screensizer.displayHeight / 2) * (1 - size)), obj_screensizer.displayWidth * size, obj_screensizer.displayHeight * size);
gpu_set_blendenable(true);
gameframe_draw();
var devWindow = [];
array_push(devWindow, "POWERED BY AVOCADO ENGINE");
array_push(devWindow, "PROPERTY OF THE SALTSHAKERS");
array_push(devWindow, "exe");
array_push(devWindow, date_datetime_string(date_current_datetime()));
draw_set_font(font_caption);
draw_set_halign(fa_left);
draw_set_alpha(0.35);
draw_set_color(c_black);
var _width = 0;
var _height = 0;

for (var i = 0; i < array_length(devWindow); i++)
{
    if (string_width(devWindow[i]) > _width)
        _width = string_width(devWindow[i]);
    
    _height += string_height(devWindow[i]);
}

var _x = x;
var _y = y;
draw_set_alpha(1);
draw_set_color(c_white);
