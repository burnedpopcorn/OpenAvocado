if (!ds_list_empty(afterimages))
{
    for (var i = 0; i < ds_list_size(afterimages); i++)
    {
        var q = afterimages[| i];
        
        with (q)
        {
            var _shd = false;
            var _blend = c_white;
            
            switch (type)
            {
                case AfterImage.Mach3:
                    _blend = image_blend;
                    gpu_set_blendmode(bm_add);
                    break;
                
                case AfterImage.Blur:
                    pal_swap_set(obj_player.spr_palette, obj_player.palIndex, false);
                    _blend = image_blend;
                    _shd = true;
                    break;
                
                case AfterImage.BuzzSaw:
                    var _col2 = #305078;//light blue
                    var _col = #112948;//dark blue
                    var col = 
					[
						color_get_red(_col) / 255, 
						color_get_green(_col) / 255, 
						color_get_blue(_col) / 255
					];
                    var col2 = 
					[
						color_get_red(_col2) / 255, 
						color_get_green(_col2) / 255, 
						color_get_blue(_col2) / 255
					];
					
                    shader_set(shd_fullshade);
                    shader_set_uniform_f_array(other.uniformLight, [col[0], col[1], col[2]]);
                    shader_set_uniform_f_array(other.uniformDark, [col2[0], col2[1], col2[2]]);
                    gpu_set_blendmode(bm_add);
                    _shd = true;
                    break;
                
                case AfterImage.UNUSED1:
                    break;
                
                case AfterImage.UNUSED2:
                    break;
            }
            
            draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1, 0, _blend, image_alpha * alpha);
            
            if (_shd)
                shader_reset();
            
            gpu_set_blendmode(bm_normal);
        }
    }
}
