global.rooms = [];

for (var i = 0; room_exists(i); i++)
    global.rooms[i] = room_get_name(i);

function meta_ranktest()
{
    return 
    {
        description: "tests a rank of your choice",
        arguments: ["rank"],
        suggestions: [["D", "C", "B", "A", "S", "P"]]
    };
}

function sh_ranktest(args)
{
    switch (args[1])
    {
        case "D":
        default:
            global.collect = 0;
            break;
        
        case "C":
            global.collect = global.Crank;
            break;
        
        case "B":
            global.collect = global.Brank;
            break;
        
        case "A":
            global.collect = global.Arank;
            break;
        
        case "S":
            global.collect = global.Srank;
            break;
        
        case "P":
            global.collect = global.Srank;
            global.escape.party = true;
            break;
    }
}

function meta_escape()
{
    return 
    {
        arguments: ["bool", "minutes", "seconds"],
        suggestions: [["true", "false"]],
        description: "enables escape sequence"
    };
}

function sh_escape(args)
{
    args[2] = real(args[2]);
    args[3] = real(args[3]);
    
    if (args[1] == "true")
        global.escape.active = true;
    else if (args[1] == "false")
        global.escape.active = false;
    else if (!is_bool(args[1]))
        global.escape.active = !global.escape.active;
    
    global.escape.timer = (args[2] * 60 * 60) + (args[3] * 60);
    
    if (global.escape.active)
    {
        instance_create_depth(x, y, -4, obj_goodmourning);
        instance_create_depth(x, y, -300, obj_whiteflash);
        obj_camera.camera.zoom = 2;
    }
}

function meta_goto_room()
{
    return 
    {
        arguments: ["room", "door"],
        suggestions: [global.rooms, ["A", "B", "C", "D", "E", "S"]],
        description: "teleports player into specified room."
    };
}

function sh_goto_room(args)
{
    with (obj_player)
    {
        targetRoom = asset_get_index(args[1]);
        door = args[2];
        hallway = false;
        
        with (instance_create_depth(x, y, 0, obj_fadeout))
            targetRoom = other.targetRoom;
    }
}

function meta_toggle_collisions()
{
    return 
    {
        arguments: ["bool"],
        suggestions: [["true", "false"]],
        description: "toggles collisions"
    };
}

function sh_toggle_collisions(args)
{
    if (args[1] == "true")
        global.showcollisions = true;
    else if (args[1] == "false")
        global.showcollisions = false;
    else if (!is_bool(args[1]))
        global.showcollisions = !global.showcollisions;
}

function meta_toggle_debug()
{
    return 
    {
        arguments: ["bool"],
        suggestions: [["true", "false"]],
        description: "toggles debugging mode"
    };
}

function sh_toggle_debug(args)
{
    if (args[1] == "true")
        global.debug = true;
    else if (args[1] == "false")
        global.debug = false;
    else if (!is_bool(args[1]))
        global.debug = !global.debug;
}
