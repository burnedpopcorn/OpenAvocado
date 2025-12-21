function approach(arg0, arg1, arg2)
{
    if (arg0 < arg1)
        return min(arg0 + arg2, arg1);
    else
        return max(arg0 - arg2, arg1);
}

function getTime(_minutes = 1, _seconds = 30)
{
    return (_minutes * 60 * 60) + (_seconds * 60);
}

function wrap(arg0, arg1, arg2)
{
    var value = floor(arg0);
    var _min = floor(min(arg1, arg2));
    var _max = floor(max(arg1, arg2));
    var range = (_max - _min) + 1;
    return ((((value - _min) % range) + range) % range) + _min;
}

function wave(arg0, arg1, arg2, arg3)
{
    var a4 = (arg1 - arg0) * 0.5;
    return arg0 + a4 + (sin((((current_time * 0.001) + (arg2 * arg3)) / arg2) * (2 * pi)) * a4);
}

function chance(arg0)
{
    return arg0 > random(1);
}
