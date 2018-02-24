Shader "ShaderSketches/Star2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"
    
    float rand(float2 st)
    {
        return frac(sin(dot(st, float2(12.9898, 78.233))) * 43758.5453);
    }

    float star(float2 st, float offset)
    {
        st -= 0.5;
        st *= 2;
        float a = atan2(st.y, st.x) + _Time.y * 0.3 + rand(offset) * 40;
        float l = pow(length(st), 0.8);
        float d = l - 0.5 + cos(a * 5.0) * 0.08;
        float star = step(0, d);
        return 1 - star;
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float t = _Time.y * 0.5;

        float2 st = i.uv;
        st += float2(cos(t), sin(t)) * 0.2;

        float n = 3;
        float2 p1 = st * n;
        float2 p2 = st * n + 0.5;

        float d1 = star(frac(p1), floor(p1));
        float d2 = star(frac(p2), floor(p2));

        float4 color = lerp(1, float4(0.74, 0.125, 0.44, 1), d2 + d1);
        color *= 1.7 - length(0.5 - i.uv);

        return color;
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
