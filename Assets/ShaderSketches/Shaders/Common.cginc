int _UseScreenAspectRatio;

float2 screen_aspect(float2 uv)
{
    if (_UseScreenAspectRatio == 0)
        return uv;

    uv.x -= 0.5;
    uv.x *= _ScreenParams.x / _ScreenParams.y;
    uv.x += 0.5;
    return uv;
}
