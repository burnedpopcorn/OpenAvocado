global.songCurInf = {};
musicDetails = ds_map_create();
music = 
{
    regular: "",
    secret: "",
    ambience: ""
};

musicInst = noone;
secretInst = noone;
ambienceInst = noone;
isSecret = false;
lock = false;
panicStart = false;
playingSecret = false;
func = noone;
monolith = FMODcreate_event("event:/Music/General/monolith");
escapeInst = FMODcreate_event("event:/Music/General/escape");
pillar = 0;
voices = 0;
savedMusicPosition = 0;
musicPos = 0;
currentMusic = "";
pauseMusic = false;

#region Music Functions
stop_music = function()
{
    if (musicInst != noone)
    {
        fmod_studio_event_instance_stop(musicInst, FMOD_STUDIO_STOP_MODE.ALLOWFADEOUT);
        fmod_studio_event_instance_release(musicInst);
    }
    
    if (secretInst != noone)
    {
        fmod_studio_event_instance_stop(secretInst, FMOD_STUDIO_STOP_MODE.ALLOWFADEOUT);
        fmod_studio_event_instance_release(secretInst);
    }
    
    if (ambienceInst != noone)
    {
        fmod_studio_event_instance_stop(ambienceInst, FMOD_STUDIO_STOP_MODE.ALLOWFADEOUT);
        fmod_studio_event_instance_release(ambienceInst);
    }
    
    musicInst = noone;
    secretInst = noone;
    ambienceInst = noone;
    music = 
    {
        regular: "",
        secret: "",
        ambience: ""
    };
    savedMusicPosition = 0;
    isSecret = false;
};

add_music = function(_music, _secret, _ambience, _func = function() { }) constructor
{
    music = _music;
    secret = _secret;
    ambience = _ambience;
    func = _func;
};
#endregion

ds_map_add(musicDetails, test_1, new add_music("event:/Music/W1/entrance", "event:/Music/W1/Monolith Mangrove/mangrovesecret", noone));
ds_map_add(musicDetails, mangrove_1, new add_music("event:/Music/W1/Monolith Mangrove/mangrove", "event:/Music/W1/Monolith Mangrove/mangrovesecret", "event:/Ambience/mangrove", function()
{
    var _s = 0;
    
    if (room == mangrove_9 || room == mangrove_10 || room == mangrove_11)
        _s = 1;
    
    fmod_studio_event_instance_set_parameter_by_name(musicInst, "state", _s);
}));
ds_map_add(musicDetails, hotel_entrance, new add_music("event:/Music/W1/hub", noone, noone));
ds_map_add(musicDetails, hotel_reception, new add_music("event:/Music/W1/hub", noone, noone));
ds_map_add(musicDetails, city_1, new add_music("event:/Music/W1/Shell City/city", noone, noone));
ds_map_add(musicDetails, beer_1, new add_music("event:/Music/W1/Wasted Shores/shores", noone, noone));
