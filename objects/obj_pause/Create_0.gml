depth = obj_screensizer.depth + 200;
active = false;
graphBorderSize = 2;
graphBack = { alpha: 0, x: 0, y: 0 };
screenSprite = noone;
pauseMusic = FMODcreate_event("event:/Music/General/pause");
vinylSND = FMODcreate_event("event:/Sfx/vinyl");
selected = 0;
options = [];
disc = {};
disc.side = 0;
disc.index = 0;
disc.xscale = 1;
disc.rotation = 0;
disc.facing = 1;

#region Pause Funcs
function doPause()
{
    FMODsetPauseAll(true);
    
    if (sprite_exists(screenSprite))
        sprite_delete(screenSprite);
    
    screenSprite = sprite_create_from_surface(obj_screensizer.gameSurface, 0, 0, obj_screensizer.displayWidth, obj_screensizer.displayHeight, false, false, 0, 0);
    active = true;
    instance_deactivate_all(true);
    instance_activate_object(obj_inputController);
    instance_activate_object(obj_screensizer);
    instance_activate_object(obj_fmod);
    instance_activate_object(obj_shell);
    instance_activate_object(obj_rpc);
    instance_activate_object(obj_savesystem);
    fmod_studio_event_instance_start(pauseMusic);
    fmod_studio_event_instance_set_paused(pauseMusic, false);
    fmod_studio_event_instance_start(vinylSND);
    fmod_studio_event_instance_set_paused(vinylSND, false);
    graphBack.alpha = 0;
    selected = 0;
    disc.side = choose(0, 0, 1);
    disc.index = disc.side;
}

function doUnpause()
{
    instance_activate_all();
    FMODsetPauseAll(false);
    fmod_studio_event_instance_stop(pauseMusic, FMOD_STUDIO_STOP_MODE.ALLOWFADEOUT);
    fmod_studio_event_instance_stop(vinylSND, FMOD_STUDIO_STOP_MODE.ALLOWFADEOUT);
    
    with (obj_music)
    {
        fmod_studio_event_instance_set_paused(escapeInst, isSecret);
        fmod_studio_event_instance_set_paused(musicInst, isSecret || FMODevent_isplaying(escapeInst));
        fmod_studio_event_instance_set_paused(secretInst, !isSecret);
    }
    
    active = false;
}
#endregion
#region Pause Options
var _resume = 
{
    option: "pause_resume",
    
    func: function()
    {
        with (obj_pause)
            doUnpause();
    }
};
var _restart = 
{
    option: "pause_restart",
    
    func: function()
    {
        with (obj_pause)
        {
            doUnpause();
            
            with (obj_music)
            {
                stop_music();
                
                if (FMODevent_isplaying(escapeInst))
                    fmod_studio_event_instance_stop(escapeInst, FMOD_STUDIO_STOP_MODE.IMMEDIATE);
            }
            
            with (obj_player)
            {
                generalReset();
                door = "A";
                movespeed = 0;
                vsp = 0;
                hsp = 0;
                state = states.enterdoor;
            }
            
            room_goto(global.resetRoom);
        }
    }
};
var _option = 
{
    option: "pause_options",
    
    func: function()
    {
        FMODevent_oneshot("event:/Sfx/UI/Pause/menuselect");
        instance_create_depth(0, 0, obj_pause.depth - 150, obj_option);
    }
};
var _exitlevel = 
{
    option: "pause_exit",
    
    func: function()
    {
        with (obj_pause)
        {
            doUnpause();
            
            with (obj_player)
            {
                generalReset();
                movespeed = 0;
                vsp = 0;
                hsp = 0;
                state = states.enterdoor;
            }
            
            room_goto(avocadoMenu);
            global.level = noone;
            global.resetRoom = noone;
        }
    }
};
#endregion
array_push(options, _resume);
array_push(options, _option);
array_push(options, _restart);
array_push(options, _exitlevel);
