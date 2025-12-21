global.language = "english";
global.langMapWord = ds_map_create();
global.langMapArt = ds_map_create();

function lang_init()
{
    var _generalPath = "lang/";
    var _textFile = $"{_generalPath}/{global.language}/text.txt";
    var _json = json_parse(loadString(_textFile));
    var _jsonNames = variable_struct_get_names(_json);
    
    for (var i = 0; i < array_length(_jsonNames); i++)
        ds_map_add(global.langMapWord, _jsonNames[i], variable_struct_get(_json, _jsonNames[i]));
    
    _textFile = $"{_generalPath}/{global.language}/art.txt";
    _json = json_parse(loadString(_textFile));
    _jsonNames = variable_struct_get_names(_json);
    
    for (var i = 0; i < array_length(_jsonNames); i++)
    {
        var q = variable_struct_get(_json, _jsonNames[i]);
        var _spritePath = $"{_generalPath}/{global.language}/{q.path}";
        ds_map_add(global.langMapArt, _jsonNames[i], sprite_add_gif(_spritePath, q.xorigin, q.yorigin));
    }
}

function lang_get_phrase(arg0)
{
    if (ds_map_exists(global.langMapWord, arg0))
        return global.langMapWord[? arg0];
    else
        return arg0;
}

function lang_get_asset(arg0)
{
    if (ds_map_exists(global.langMapArt, arg0))
        return global.langMapArt[? arg0];
    else
        return -1;
}
