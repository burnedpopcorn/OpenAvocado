menus = [];
currentmenu = 0;
selected = 1;
move = 0;
menu = 0;

#region Select Online/Offline
array_push(menus, []);
var _onl = 
[
	{ index: 8, alpha: 0 }, 
	"ONLINE RACE", function() 
	{
	    currentmenu = 1;
	    selected = 0;
	}
];
var _off = 
[
	{ index: 6, alpha: 0 }, 
	"OFFLINE", function()
	{
	    obj_player.state = states.normal;
	    room_goto(avocadoMenu);
	}
];
array_push(menus[0], _onl);
array_push(menus[0], _off);
#endregion
#region Create/Join Server
array_push(menus, []);
var _create = 
[
	noone, "CREATE SERVER", function()
	{
	    menu = 2;
	    creating = true;
	    keyboard_string = "";
	    textInput = "2222";
	}
];
var _join = 
[
	noone, "JOIN SERVER", function()
	{
	    menu = 1;
	    creating = false;
	    keyboard_string = "";
	    textInput = "";
	}
];
array_push(menus[1], _create);
array_push(menus[1], _join);
#endregion

bgx = 0;
textInput = "";
creating = false;
connectIP = "";
connectPort = "";
global.server = noone;
global.client = noone;
global.serverStats = [];
global.playercount = 0;
global.connected = false;
obj_player.state = -999;
