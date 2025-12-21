pal_swap_init_system(shd_pal_swapper);
depth = 0;
image_speed = 0.35;
scr_collision_init();
grav = 0.5;

if (!variable_global_exists("saveroom"))
{
    global.saveroom = ds_list_create();
    global.escaperoom = ds_list_create();
    global.followers = ds_list_create();
    global.collect = 0;
    global.secretCount = 0;
    global.patternSpr = spr_playerPat_threads;
    global.escape = 
    {
        active: false,
        timer: 7200,
        party: false
    };
    global.level_timer = 0;
    global.save_timer = 0;
    global.debug = false;
    global.level = noone;
}

spr_palette = spr_playerPal;
palIndex = 1;
jumpstop = false;
door = "A";

enum states 
{
	// Player States
	normal = 0,
	crouch = 1,
	jump = 2,
	mach2 = 3,
	mach3 = 4,
	machslide = 5,
	machturn = 6,
	hitwall = 7,
	
	// Enemy States
	turn = 8,
	move = 9,
	hit = 10,
	stun = 11,
	
	// Back to Player States
	superjumpprep = 12,
	superjump = 13,
	freefallland = 14,
	taunt = 15,
	tumble = 16,
	climbwall = 17,
	groundpoundstart = 18,
	groundpound = 19,
	enterdoor = 20,
	walkfront = 21,
	grab = 22,// single enemy state why
	hauling = 23,
	finishingblow = 24,
	thrown = 25,// single enemy state why
	uppercut = 26,
	hurt = 27,
	ladder = 28,
	buzzsaw = 29,
	Parry = 30,
	surfing = 31,
	diveboard = 32,
}
state = states.normal;

movespeed = 0;
xscale = 1;
xs = 1;
ys = 1;
chargeeffect = noone;

buffers = {};
buffers.step = 0;
buffers.bigdashcloud = 0;
buffers.idle = 180;
buffers.afterimageMach = 0;
buffers.afterimageBlur = 0;
buffers.dashcloud = 0;
buffers.crazyothereffect = 0;

jumpBuffer = false;
slapBuffer = false;
flash = false;
rainbow = 0;
super = false;

soundsOk = FMODcreate_event("event:/Sfx/Player/yeag");
soundsLaugh = FMODcreate_event("event:/Sfx/Player/yay");
soundsMach = FMODcreate_event("event:/Sfx/Player/mach");
soundsSuperjump = FMODcreate_event("event:/Sfx/Player/superjump");
soundsRoll = FMODcreate_event("event:/Sfx/Player/tumble");
soundsGroundpound = FMODcreate_event("event:/Sfx/Player/groundpound");
soundGrab = FMODcreate_event("event:/Sfx/Player/dash");

hitstun = {};
hitstun.x = x;
hitstun.y = y;
hitstun.time = 0;
hitstun.is = false;

hallway = false;
hallwayDirection = xscale;
instakill = false;
SjumpVsp = 0;
wallspeed = 0;
tauntVars = 
{
    sprite_index: sprite_index,
    image_index: image_index,
    state: state,
    vsp: vsp,
    hsp: hsp,
    movespeed: movespeed,
    image_speed: image_speed
};
tauntTimer = 0;
freefallsmash = noone;
crouchslip = 0;
wallgrab = 0;
enemyID = noone;
i_frame = 0;
coyote_time = 0;
mach4mode = false;
movespeedSurfing = 0;

diveboardSaved = {};
diveboardSaved.movespeed = movespeed;
diveboardSaved.state = state;
diveboardSaved.sprite_index = sprite_index;
diveboardSaved.image_index = image_index;
diveboardSaved.y = y;

get_input();
