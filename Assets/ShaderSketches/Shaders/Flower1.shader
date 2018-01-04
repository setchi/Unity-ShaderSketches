Shader "ShaderSketches/Flower1"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    #define PI 3.14159265359

    float rand(float2 uv)
    {
        return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
    }

    float3 hue_to_rgb(float h)
    {
        h = frac(h) * 6 - 2;
        return saturate(float3(abs(h - 1) - 1, 2 - abs(h),
                        2 - abs(h - 2)));
    }

    float frequency(float2 st, float n)
    {
        return 3.5 * length(0.5 - (floor(st * n) + 0.5) / n);
    }

    float wave(float freq)
    {
        return (1 + sin(-_Time.y * 1.5 + freq)) * 0.5;
    }

    float circle(float2 st, float size)
    {
        return step(length(0.5 - st), size);
    }

    float2 rotate(float2 st, float angle)
    {
        float3x3 mat = float3x3(cos(angle), -sin(angle), 0,
                                sin(angle), cos(angle), 0,
                                0, 0, 1);
        st -= 0.5;
        st = mul(mat, float3(st, 1));
        st += 0.5;
        return st;
    }

    float4 flower(float2 uv, float n)
    {
        float2 st = frac(uv * n);
        st = rotate(st, _Time.y / 2);
        st = 0.5 - st;
        
        float size = wave(frequency(uv, n)) * 0.8;
        
        float r = length(st) * 2;
        float a = atan2(st.y, st.x);
        float f = (abs(cos(a * 6)) + 0.4) * pow(size, 3) * 1.4;

        float4 color = 0;

        float petal = 1 - smoothstep(f, f + 0.02, r);
        color = lerp(color, float4(hue_to_rgb(rand(floor(uv * n) / n)), 1), petal);

        float cap = circle(st + 0.5, pow(size, 2) * 0.15);
        return lerp(color, float4(0.99, 0.78, 0, 1), cap);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        float2 st = rotate(i.uv, 0.25 * PI);

        float size = wave(frequency(st, 10));
        float4 color = circle(frac(st * 20), 0.35 * size) * 0.15;

        float4 fcolor = flower(st, 5);
        return lerp(color, fcolor, fcolor.w);
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
