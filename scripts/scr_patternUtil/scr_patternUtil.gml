global.patternColors = shader_get_sampler_index(shd_pattern, "tex_setColors");
global.patternUVs = shader_get_uniform(shd_pattern, "tex_colorsUV");
global.patternTexel = shader_get_uniform(shd_pattern, "tex_height");

function pattern_draw(_spr, _index, _x, _y, _xscale, _yscale, _rot, _col, _alpha, _patSpr = global.patternSpr, _patCol = spr_playerPatColors)
{
    if (_patSpr != -1)
    {
        var _surf = surface_create(sprite_get_width(_spr), sprite_get_height(_spr));
        surface_set_target(_surf);
        draw_clear_alpha(c_black, 0);
        shader_set(shd_pattern);
		// _patCol is unused, but was probably planned to be used here
        var q = sprite_get_texture(spr_playerPatColors, 0);
        var p = sprite_get_uvs(spr_playerPatColors, 0);
        var s = texture_get_texel_height(q);
        texture_set_stage(global.patternColors, q);
        shader_set_uniform_f(global.patternUVs, p[0], p[1], p[2], p[3]);
        shader_set_uniform_f(global.patternTexel, s);
        draw_sprite_ext(_spr, _index, sprite_get_xoffset(_spr), sprite_get_yoffset(_spr), 1, 1, _rot * _xscale, c_white, 1);
        shader_reset();
        gpu_set_blendmode(bm_min);
        pal_swap_set(obj_player.spr_palette, obj_player.palIndex, false);
        draw_sprite_tiled_ext(_patSpr, 0, 0, 0, _xscale, 1, c_white, 1);
        shader_reset();
        gpu_set_blendmode(bm_normal);
        surface_reset_target();
        draw_surface_ext(_surf, _x - (sprite_get_xoffset(_spr) * _xscale), _y - (sprite_get_yoffset(_spr) * _yscale), _xscale, _yscale, 0, _col, _alpha);
        surface_free(_surf);
    }
}
