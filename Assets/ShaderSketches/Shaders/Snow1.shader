Shader "ShaderSketches/Snow1"
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
        float2x2 mat = float2x2(cos(angle), -sin(angle),
                                sin(angle), cos(angle));
        st -= 0.5;
        st = mul(mat, st);
        st += 0.5;
        return st;
    }

    float wave(float2 st, float n)
    {
        st = floor(st * n) / n;
        float pos = st.y + st.x;
        return (1 + sin(-_Time.y * 5 + pos * 5)) * 0.5;
    }

    float snow(float2 st, float size)
    {
        st = rotate(st, _Time.x * 10);
        st = 0.5 - st;
        float r = length(st) * 2;
        float a = atan2(st.y, st.x);
        float f = abs(cos(a * 12) * sin(a * 3)) * size;
        return 1 - smoothstep(f, f + 0.02, r);
    }

    float circle(float2 st, float size)
    {
        return step(length(0.5 - st), size);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float s = snow(frac(i.uv * 3), 0.8 * wave(i.uv, 3));
        float c = circle(frac(i.uv * 10), 0.45 * wave(i.uv, 10));

        return float4(0.1, 0.13, 0.5, 1) * c + s;
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
