Shader "ShaderSketches/MetaXx2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    float2 rotate(float2 st, float angle)
    {
        st -= 0.5;
        st = mul(float2x2(cos(angle), -sin(angle),
                          sin(angle),  cos(angle)), st);
        st += 0.5;
        return st;
    }

    float2 move(float2 st, float offset)
    {
        float t = _Time.y;
        return st + float2(sin(offset + t),
                           sin(offset + t * 3)) * 0.3;
    }

    float circle(float2 st) { return -0.1 + distance(0.5, st); }

    float meta_xx(float2 st)
    {
        float d = circle(move(st, 0)) *
                  circle(move(st, 4)) *
                  circle(move(st, 8));
        
        float ft = frac(_Time.y * 2);
        float a = smoothstep(0.6, 0.8, ft) *
             (1 - smoothstep(0.8, 1.0, ft));
        
        return step(lerp(0.25, 1, a), abs(sin(d * 150)));
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        i.uv = abs(0.5 - rotate(i.uv, _Time.y * 2));

        return lerp(float4(0.16, 0.80, 0.80, 1),
                    float4(0.16, 0.07, 0.31, 1),
                    meta_xx(i.uv));
    }

    ENDCG

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            ENDCG
        }
    }
}
