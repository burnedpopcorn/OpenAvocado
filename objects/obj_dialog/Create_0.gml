dialogStuff = [];
currentDialog = 0;
active = false;

addDialog = function(_icon, _text, _func = function() { })
{
    var q = 
    {
        portrait: _icon,
        text: _text,
        func: _func
    };
    array_push(dialogStuff, q);
};

textVisual = "";
textLetter = 1;
canProgress = false;
