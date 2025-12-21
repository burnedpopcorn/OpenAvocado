var _et = async_load[? "event_type"];

if (_et == "gamepad discovered")
{
    var _padIndx = async_load[? "pad_index"];
    
    if (global.gamepadConnected == false)
    {
        global.gamepadConnected = true;
        global.gamepadCurrent = _padIndx;
        show_debug_message($"Gamepad at slot {_padIndx} has been Found!");
    }
}
else if (_et == "gamepad lost")
{
    var _padIndx = async_load[? "pad_index"];
    
    if (global.gamepadConnected == true)
    {
        global.gamepadConnected = false;
        global.gamepadCurrent = noone;
        show_debug_message($"Gamepad at slot {_padIndx} has disconnected.");
    }
}
