int _ScreenAspect;

float2 screen_aspect(float2 uv)
{
    if (_ScreenAspect != 1)
        return uv;

    uv.x -= 0.5;
    uv.x *= _ScreenParams.x / _ScreenParams.y;
    uv.x += 0.5;
    return uv;
}
