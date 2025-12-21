ready = false;
alarm[0] = room_speed * 5;

#macro DISCORD_APP_ID "1428526839164436480"

if (!np_initdiscord(DISCORD_APP_ID, true, "0"))
    show_error("NekoPresence init fail.", true);
