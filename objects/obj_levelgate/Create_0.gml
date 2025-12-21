image_speed = 0;
depth = 30;
gateinfo = ds_list_create();

function create_gate_layer(_sprite, _index, _bgx, _bgy, _hsp, _vsp, _parallax = false)
{
    var q = 
    {
        sprite_index: _sprite,
        image_index: _index,
        bgx: _bgx,
        bgy: _bgy,
        hsp: _hsp,
        vsp: _vsp,
        parallax: _parallax
    };
    ds_list_add(gateinfo, q);
    return q;
}

create_gate_layer(spr_gate_entranceBG, 0, 0, 0, 0, 0);
create_gate_layer(spr_gate_entranceBG, 1, 0, 0, 0.35, 0);
create_gate_layer(spr_gate_entranceBG, 2, 0, 0, 0.25, 0);
bgalpha = 1;
visibleradius = 250;
textalpha = 0;
drawing = 0;
