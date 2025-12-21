if (ds_map_exists(musicDetails, room))
{
    var _map = musicDetails[? room];
    
    if (music.regular != _map.music)
    {
        if (musicInst != noone)
        {
            fmod_studio_event_instance_stop(musicInst, FMOD_STUDIO_STOP_MODE.ALLOWFADEOUT);
            fmod_studio_event_instance_release(musicInst);
            musicInst = noone;
        }
        
        if (_map.music != noone)
        {
            music.regular = _map.music;
            musicInst = FMODcreate_event(_map.music);
            fmod_studio_event_instance_start(musicInst);
        }
    }
    
    if (music.ambience != _map.ambience)
    {
        if (ambienceInst != noone)
        {
            fmod_studio_event_instance_stop(ambienceInst, FMOD_STUDIO_STOP_MODE.ALLOWFADEOUT);
            fmod_studio_event_instance_release(ambienceInst);
            ambienceInst = noone;
        }
        
        if (_map.ambience != noone)
        {
            music.ambience = _map.ambience;
            ambienceInst = FMODcreate_event(_map.ambience);
            fmod_studio_event_instance_start(ambienceInst);
        }
    }
    
    if (music.secret != _map.secret)
    {
        if (secretInst != noone)
        {
            fmod_studio_event_instance_stop(secretInst, FMOD_STUDIO_STOP_MODE.ALLOWFADEOUT);
            fmod_studio_event_instance_release(secretInst);
            secretInst = noone;
        }
        
        if (_map.secret != noone)
        {
            music.secret = _map.secret;
            secretInst = FMODcreate_event(_map.secret);
            fmod_studio_event_instance_start(secretInst);
        }
    }
    
    func = _map.func;
}

fmod_studio_event_instance_set_paused(escapeInst, isSecret);

if (musicInst != noone)
    fmod_studio_event_instance_set_paused(musicInst, isSecret || FMODevent_isplaying(escapeInst));

if (ambienceInst != noone)
    fmod_studio_event_instance_set_paused(ambienceInst, isSecret || FMODevent_isplaying(ambienceInst));

if (secretInst != noone)
    fmod_studio_event_instance_set_paused(secretInst, !isSecret);
