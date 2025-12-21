image_speed = 0.35;
target = obj_player;
depth = target.depth + 1;
destroy = false;
photoSurf = noone;
image_angle = choose(0, 15, 12, 5, 350, 348, 355);
photoIndex = irandom_range(0, sprite_get_number(spr_tauntEffectBackground) - 1);
