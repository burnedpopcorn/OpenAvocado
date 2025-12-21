np_setpresence_more("", "What's Shakin, Bacon?", false);
var _details = "Playing the Game";
var _state = "";

if (global.level != noone)
{
    switch (global.level)
    {
        case "forest":
            _details = "Monolith Mangrove";
            _state = calculateTime(global.level_timer);
            break;
        
        case "gutter":
            _details = "John Gutter 2";
            _state = calculateTime(global.level_timer);
            break;
    }
}

np_setpresence(_details, _state, "", "");
alarm[1] = 5;
