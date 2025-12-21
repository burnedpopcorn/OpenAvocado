if (other.state != states.surfing)
{
    other.state = states.surfing;
    other.sprite_index = spr_player_surfing;
    scr_transfotip("[wave][U][D] Surf");
    other.movespeedSurfing = other.vsp;
}
