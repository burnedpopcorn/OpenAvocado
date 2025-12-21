randomize();
onlineID = irandom_range(0, 1000000);
notifs = ds_list_create();
connections = ds_list_create();

enum ServerCommands
{
	RecieveNotif = 0,
	AddPlayer = 1,
	ServerClosed = 2,
	
	SyncParticles = 3,
	SyncAfterImages = 4,
	Unknown1 = 5, // idk, not currently implimented
	SyncMusic = 6,
	Unknown2 = 7, // idk, not currently implimented
	
	RefreshConnections = 8,
}

network_send_packetServ = function(_buff, _size)
{
    if (global.client == noone)
    {
        var i = ds_list_size(connections);
        
        while (i--)
            network_send_packet(connections[| i], _buff, _size);
    }
    
    if (global.server == noone)
        network_send_packet(global.client, _buff, _size);
};

create_notifAsync = function(_text, _col)
{
    var p = 
    {
        type: ServerCommands.RecieveNotif,
        text: _text,
        color: _col,
        alpha: 1,
        gotime: 90
    };
    var buff = buffer_create(32, buffer_grow, 1);
    buffer_write(buff, buffer_string, json_stringify(p));
    network_send_packetServ(buff, buffer_tell(buff));
    buffer_delete(buff);
    ds_list_add(notifs, p);
};

playerInRoom = 0;
