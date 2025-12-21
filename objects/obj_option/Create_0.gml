buffer = 0;
menus = [];
currentmenu = 0;
selected = 0;
move = 0;
backgrounds = [];
changingBind = false;
keyScroll = 0;

#region Backgrounds
var addBackground = function(_menus = [], _index, _alpha = 0)
{
    var q = 
    {
        menu: _menus,
        index: _index,
        alpha: _alpha
    };
    array_push(backgrounds, q);
};

// ints correspond to the Menu enum below
// but they weren't implimented as enums, so i'll keep them as ints
addBackground([0], 0, 1);
addBackground([1], 1);
addBackground([2, 10], 2);
addBackground([3], 3);
addBackground([4, 5, 6, 7, 8, 9], 4);
#endregion

BGX = wave(-32, 32, 5, 0);
BGY = 0;
depth = obj_pause.depth - 1;
screamSnd = FMODcreate_event("event:/Sfx/UI/Pause/slider");
fmod_studio_event_instance_start(screamSnd);
fmod_studio_event_instance_set_paused(screamSnd, true);

// Indents mean they are submenus of the menu above it
enum Menus 
{
	// Menus
	Main = 0,
	Audio = 1,
	Video = 2,
		Window = 3,
	
	Controls = 4,
		CTRLKeyboard = 5,
			CTRLSubKeyboard = 6,
		CTRLGamePad = 7,
			CTRLSubGamePad = 8,
			DeadZones = 9,
			
	Game = 10,
	
	// Alignments
	AnchorMainMenu = 11,
	AnchorNormalMenu = 12,
	AnchorInputMenu = 13,
	
	// Toggle Types
	OptionText = 14,
	OptionToggle = 15,
	OptionSlider = 16,
	OptionInputRemap = 17
}

#region Menu Functions
addPause_icon = function(_index) constructor
{
    index = _index;
    alpha = 0;
};

goto_menu = function(_menu)
{
    for (var i = 0; i < array_length(menus); i++)
    {
        var m = menus[i];
        
        if (m.menuid == _menu)
            currentmenu = i;
    }
    
    show_debug_message(currentmenu);
    selected = 0;
};

create_menu = function(_menu, _anchor, _ypad, _backfunc)
{
    var _opt = 
    {
        menuid: _menu,
        anchor: _anchor,
        ypad: _ypad,
        options: [],
        backfunc: _backfunc
    };
    return _opt;
};

add_option_press = function(_ParentMenu, _name, _func, _icon = noone)
{
    var q = 
    {
        name: _name,
        func: _func,
        type: Menus.OptionText,
        selecting: false,
        icon: _icon
    };
    array_push(_ParentMenu.options, q);
    return q;
};

add_option_ext = function(_ParentMenu, _type, _name, _func, _val, _max, _toggle = ["option_off", "option_on"])
{
    var q = 
    {
        specialNumber: 0,
        name: _name,
        func: _func,
        val: _val,
        toggle: _toggle,
        type: _type,
        max: _max,
        moving: false,
        selecting: false
    };
    array_push(_ParentMenu.options, q);
    return q;
};

add_option_key = function(_ParentMenu, _icoIndex, _func, _key = "Inputs_Player1_leftKey")
{
    var q = 
    {
        type: Menus.OptionInputRemap,
        iconIndex: _icoIndex,
        key: _key,
        func: _func,
        selecting: false
    };
    array_push(_ParentMenu.options, q);
    return q;
};
#endregion

#region Main Options Page
var category = create_menu(Menus.Main, Menus.AnchorMainMenu, 48, function()
{
    obj_pause.delay = 2;
    instance_destroy();
});

add_option_press(category, "option_audio", function()
{
    goto_menu(Menus.Audio);
}, 
new addPause_icon(4));

add_option_press(category, "option_video", function()
{
    goto_menu(Menus.Video);
}, 
new addPause_icon(5));

add_option_press(category, "option_game", function()
{
    goto_menu(Menus.Game);
}, 
new addPause_icon(6));

add_option_press(category, "option_controls", function()
{
    goto_menu(Menus.Controls);
}, 
new addPause_icon(7));

array_push(menus, category);
#endregion

#region Audio Menu
var AUDIO = create_menu(Menus.Audio, Menus.AnchorNormalMenu, 48, function()
{
    goto_menu(Menus.Main);
    add_saveVariable("General", "Music", global.MusicVolume);
    add_saveVariable("General", "Master", global.MasterVolume);
    add_saveVariable("General", "Sfx", global.SfxVolume);
    add_saveVariable("General", "Unfocus Mute", global.unfocus_mute);
});

add_option_press(AUDIO, "option_back", function()
{
    goto_menu(Menus.Main);
    add_saveVariable("General", "Music", global.MusicVolume);
    add_saveVariable("General", "Master", global.MasterVolume);
    add_saveVariable("General", "Sfx", global.SfxVolume);
    add_saveVariable("General", "Unfocus Mute", global.unfocus_mute);
});

add_option_ext(AUDIO, Menus.OptionSlider, "option_audio_master", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.MasterVolume = q.val / 100;
    q.val = global.MasterVolume * 100;
}, global.MasterVolume * 100, 100);

add_option_ext(AUDIO, Menus.OptionSlider, "option_audio_music", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.MusicVolume = q.val / 100;
    q.val = global.MusicVolume * 100;
}, global.MusicVolume * 100, 100);

add_option_ext(AUDIO, Menus.OptionSlider, "option_audio_ambiance", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.AmbianceVolume = q.val / 100;
    q.val = global.AmbianceVolume * 100;
}, global.AmbianceVolume * 100, 100);

add_option_ext(AUDIO, Menus.OptionSlider, "option_audio_sfx", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.SfxVolume = q.val / 100;
    q.val = global.SfxVolume * 100;
}, global.SfxVolume * 100, 100);

add_option_ext(AUDIO, Menus.OptionToggle, "option_audio_unfocus", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.unfocus_mute = q.val;
    q.val = global.unfocus_mute;
}, global.unfocus_mute, 1);
#endregion
#region Video Menu
var VIDEO = create_menu(Menus.Video, Menus.AnchorNormalMenu, 48, function()
{
    goto_menu(Menus.Main);
    add_saveVariable("Visual", "showHud", global.hide_hud);
    add_saveVariable("General", "Vsync", global.vsync);
    add_saveVariable("General", "Windowsize", global.windowSize);
    add_saveVariable("General", "texFilter", global.texFilter);
});

add_option_press(VIDEO, "option_back", function()
{
    goto_menu(Menus.Main);
    add_saveVariable("Visual", "showHud", global.hide_hud);
    add_saveVariable("General", "Vsync", global.vsync);
    add_saveVariable("General", "Windowsize", global.windowSize);
    add_saveVariable("General", "texFilter", global.texFilter);
});

add_option_press(VIDEO, "option_video_window_mode", function()
{
    goto_menu(Menus.Window);
});

add_option_ext(VIDEO, Menus.OptionToggle, "option_video_resolution", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    var res = 
	[
		[480, 270], 
		[960, 540], 
		[1024, 576], 
		[1280, 720], 
		[1600, 900], 
		[1920, 1080]
	];
    window_set_size(res[q.val][0], res[q.val][1]);
    window_center();
    global.windowSize = q.val;
    q.val = global.windowSize;
}, global.windowSize, 5, 
[
	"480 X 270", 
	"960 X 540", 
	"1024 X 576", 
	"1280 X 720", 
	"1600 X 900", 
	"1920 X 1080"
]);

add_option_ext(VIDEO, Menus.OptionToggle, "option_video_vsync", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.vsync = q.val;
    display_reset(0, global.vsync);
    q.val = global.vsync;
}, global.vsync, 1);

add_option_ext(VIDEO, Menus.OptionToggle, "option_video_filtering", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.texFilter = q.val;
    gpu_set_texfilter(global.texFilter);
    q.val = global.texFilter;
}, global.texFilter, 1);

add_option_ext(VIDEO, Menus.OptionToggle, "option_video_hide_hud", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.hide_hud = q.val;
    q.val = global.hide_hud;
}, global.hide_hud, 1);
#endregion
#region Game Menu
var GAME = create_menu(Menus.Game, Menus.AnchorNormalMenu, 48, function()
{
    goto_menu(Menus.Main);
});

add_option_press(GAME, "option_back", function()
{
    goto_menu(Menus.Main);
});
#endregion
#region Controls Menu

#region Main Control Menu
var controlsMain = create_menu(Menus.Controls, Menus.AnchorNormalMenu, 48, function()
{
    goto_menu(Menus.Main);
});

add_option_press(controlsMain, "option_back", function()
{
    goto_menu(Menus.Main);
});

add_option_press(controlsMain, "option_controls_keyboard", function()
{
    goto_menu(Menus.CTRLKeyboard);
});

add_option_press(controlsMain, "option_controls_controller", function()
{
    goto_menu(Menus.CTRLGamePad);
});

add_option_press(controlsMain, "option_controls_reset_config", function()
{
    reset_input();
    var _s = scr_transfotip(lang_get_phrase("option_controls_config_reset_tip"));
    _s.depth = depth - 1;
});
#endregion
#region Keyboard Main Menu
var controlsKeyMain = create_menu(Menus.CTRLKeyboard, Menus.AnchorNormalMenu, 48, function()
{
    goto_menu(Menus.Controls);
    add_saveVariable("General", "dirSuper", global.dirSuper);
    add_saveVariable("General", "dirGround", global.dirGround);
});

add_option_press(controlsKeyMain, "option_back", function()
{
    goto_menu(Menus.Controls);
    add_saveVariable("General", "dirSuper", global.dirSuper);
    add_saveVariable("General", "dirGround", global.dirGround);
});

add_option_press(controlsKeyMain, "option_controls_bindings", function()
{
    goto_menu(Menus.CTRLSubKeyboard);
});

add_option_ext(controlsKeyMain, Menus.OptionToggle, "option_controls_controller_dir_superjump", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.dirSuper = q.val;
    q.val = global.dirSuper;
}, global.dirSuper, 1);

add_option_ext(controlsKeyMain, Menus.OptionToggle, "option_controls_controller_dir_groundpound", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.dirGround = q.val;
    q.val = global.dirGround;
}, global.dirGround, 1);
#endregion
#region GamePad Main Menu
var controlsPadMain = create_menu(Menus.CTRLGamePad, Menus.AnchorNormalMenu, 48, function()
{
    goto_menu(Menus.Controls);
});

add_option_press(controlsPadMain, "option_back", function()
{
    goto_menu(Menus.Controls);
});

add_option_press(controlsPadMain, "option_controls_bindings", function()
{
    goto_menu(Menus.CTRLSubGamePad);
});

add_option_press(controlsPadMain, "option_controls_deadzones", function()
{
    goto_menu(Menus.DeadZones);
});
#endregion
#region Controls (Keyboard)
var controlsKey = create_menu(Menus.CTRLSubKeyboard, Menus.AnchorInputMenu, 64, function()
{
    goto_menu(Menus.CTRLKeyboard);
});

add_option_press(controlsKey, "option_back", function()
{
    goto_menu(Menus.CTRLKeyboard);
    var json = json_stringify(global.inputMap, true);
    var _file = file_text_open_write(working_directory + "input.dat");
    file_text_write_string(_file, json);
    file_text_close(_file);
    var _s = scr_transfotip(lang_get_phrase("option_controls_config_save_tip"));
    _s.depth = depth - 1;
});

add_option_key(controlsKey, 0, function() { }, "Inputs_Player1_upKey");
add_option_key(controlsKey, 1, function() { }, "Inputs_Player1_downKey");
add_option_key(controlsKey, 3, function() { }, "Inputs_Player1_leftKey");
add_option_key(controlsKey, 2, function() { }, "Inputs_Player1_rightKey");
add_option_key(controlsKey, 4, function() { }, "Inputs_Player1_jumpKey");
add_option_key(controlsKey, 5, function() { }, "Inputs_Player1_slapKey");
add_option_key(controlsKey, 6, function() { }, "Inputs_Player1_attackKey");
add_option_key(controlsKey, 7, function() { }, "Inputs_Player1_tauntKey");
add_option_key(controlsKey, 8, function() { }, "Inputs_Player1_startKey");
add_option_key(controlsKey, 9, function() { }, "Inputs_Player1_superjumpKey");
add_option_key(controlsKey, 10, function() { }, "Inputs_Player1_groundpoundKey");
add_option_key(controlsKey, "MENU LEFT", function() { }, "Inputs_Player1_menu_leftKey");
add_option_key(controlsKey, "MENU RIGHT", function() { }, "Inputs_Player1_menu_rightKey");
add_option_key(controlsKey, "MENU UP", function() { }, "Inputs_Player1_menu_upKey");
add_option_key(controlsKey, "MENU DOWN", function() { }, "Inputs_Player1_menu_downKey");
add_option_key(controlsKey, "MENU CONFIRM", function() { }, "Inputs_Player1_menu_confirmKey");
add_option_key(controlsKey, "MENU BACK", function() { }, "Inputs_Player1_menu_backKey");
add_option_key(controlsKey, "MENU CLEAR", function() { }, "Inputs_Player1_menu_clearKey");
#endregion
#region Controls (GamePad)
var controlsPad = create_menu(Menus.CTRLSubGamePad, Menus.AnchorInputMenu, 55, function()
{
    goto_menu(Menus.CTRLGamePad);
});

add_option_press(controlsPad, "option_back", function()
{
    goto_menu(Menus.CTRLGamePad);
    var json = json_stringify(global.inputMap, true);
    var _file = file_text_open_write(working_directory + "input.dat");
    file_text_write_string(_file, json);
    file_text_close(_file);
    var _s = scr_transfotip(lang_get_phrase("option_controls_config_save_tip"));
    _s.depth = depth - 1;
});

add_option_key(controlsPad, 0, function() { }, "Inputs_Player1_upPad");
add_option_key(controlsPad, 1, function() { }, "Inputs_Player1_downPad");
add_option_key(controlsPad, 3, function() { }, "Inputs_Player1_leftPad");
add_option_key(controlsPad, 2, function() { }, "Inputs_Player1_rightPad");
add_option_key(controlsPad, 4, function() { }, "Inputs_Player1_jumpPad");
add_option_key(controlsPad, 5, function() { }, "Inputs_Player1_slapPad");
add_option_key(controlsPad, 6, function() { }, "Inputs_Player1_attackPad");
add_option_key(controlsPad, 7, function() { }, "Inputs_Player1_tauntPad");
add_option_key(controlsPad, 8, function() { }, "Inputs_Player1_startPad");
add_option_key(controlsPad, 9, function() { }, "Inputs_Player1_superjumpPad");
add_option_key(controlsPad, 10, function() { }, "Inputs_Player1_groundpoundPad");
add_option_key(controlsPad, "MENU LEFT", function() { }, "Inputs_Player1_menu_leftPad");
add_option_key(controlsPad, "MENU RIGHT", function() { }, "Inputs_Player1_menu_rightPad");
add_option_key(controlsPad, "MENU UP", function() { }, "Inputs_Player1_menu_upPad");
add_option_key(controlsPad, "MENU DOWN", function() { }, "Inputs_Player1_menu_downPad");
add_option_key(controlsPad, "MENU CONFIRM", function() { }, "Inputs_Player1_menu_confirmPad");
add_option_key(controlsPad, "MENU BACK", function() { }, "Inputs_Player1_menu_backPad");
add_option_key(controlsPad, "MENU CLEAR", function() { }, "Inputs_Player1_menu_clearPad");
#endregion
#region DeadZones
var DEADZONES = create_menu(Menus.DeadZones, Menus.AnchorNormalMenu, 55, function()
{
    goto_menu(Menus.CTRLGamePad);
    add_saveVariable("Deadzones", "general", global.gamepadDeadzones.general);
    add_saveVariable("Deadzones", "horiz", global.gamepadDeadzones.horizontal);
    add_saveVariable("Deadzones", "verti", global.gamepadDeadzones.vertical);
    add_saveVariable("Deadzones", "press", global.gamepadDeadzones.press);
});

add_option_press(DEADZONES, "option_back", function()
{
    goto_menu(Menus.CTRLGamePad);
    add_saveVariable("Deadzones", "general", global.gamepadDeadzones.general);
    add_saveVariable("Deadzones", "horiz", global.gamepadDeadzones.horizontal);
    add_saveVariable("Deadzones", "verti", global.gamepadDeadzones.vertical);
    add_saveVariable("Deadzones", "press", global.gamepadDeadzones.press);
});

add_option_ext(DEADZONES, Menus.OptionSlider, "option_controls_controller_deadzone_general", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.gamepadDeadzones.general = q.val / 100;
    q.val = global.gamepadDeadzones.general * 100;
}, global.gamepadDeadzones.general * 100, 100);

add_option_ext(DEADZONES, Menus.OptionSlider, "option_controls_controller_deadzone_horiz", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.gamepadDeadzones.horizontal = q.val / 100;
    q.val = global.gamepadDeadzones.horizontal * 100;
}, global.gamepadDeadzones.horizontal * 100, 100);

add_option_ext(DEADZONES, Menus.OptionSlider, "option_controls_controller_deadzone_vert", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.gamepadDeadzones.vertical = q.val / 100;
    q.val = global.gamepadDeadzones.vertical * 100;
}, global.gamepadDeadzones.vertical * 100, 100);

add_option_ext(DEADZONES, Menus.OptionSlider, "option_controls_controller_deadzone_press", function()
{
    var m = menus[currentmenu];
    var opt = m.options;
    var q = opt[selected];
    global.gamepadDeadzones.press = q.val / 100;
    q.val = global.gamepadDeadzones.press * 100;
}, global.gamepadDeadzones.press * 100, 100);
#endregion

#endregion
#region Window Menu (Video SubMenu)
var windowMode = create_menu(Menus.Window, Menus.AnchorNormalMenu, 48, function()
{
    goto_menu(Menus.Video);
});

add_option_press(windowMode, "option_back", function()
{
    goto_menu(Menus.Video);
    add_saveVariable("General", "Fullscreen", global.Fullscreen);
});

add_option_press(windowMode, "option_video_window_mode_windowed", function()
{
    goto_menu(Menus.Video);
    window_set_fullscreen(false);
    window_enable_borderless_fullscreen(false);
    global.Fullscreen = 0;
    add_saveVariable("General", "Fullscreen", global.Fullscreen);
});

add_option_press(windowMode, "option_video_window_mode_fullscreen", function()
{
    goto_menu(Menus.Video);
    window_enable_borderless_fullscreen(false);
    window_set_fullscreen(true);
    global.Fullscreen = 1;
    add_saveVariable("General", "Fullscreen", global.Fullscreen);
});

add_option_press(windowMode, "option_video_window_mode_borderless", function()
{
    goto_menu(Menus.Video);
    
    if (window_get_fullscreen())
        window_set_fullscreen(false);
    
    window_enable_borderless_fullscreen(true);
    window_set_fullscreen(true);
    global.Fullscreen = 2;
    add_saveVariable("General", "Fullscreen", global.Fullscreen);
});
#endregion
#region Apply Menus
array_push(menus, AUDIO);
array_push(menus, VIDEO);
array_push(menus, GAME);
array_push(menus, controlsMain);
array_push(menus, controlsKeyMain);
array_push(menus, controlsKey);
array_push(menus, controlsPadMain);
array_push(menus, controlsPad);
array_push(menus, DEADZONES);
array_push(menus, windowMode);
#endregion