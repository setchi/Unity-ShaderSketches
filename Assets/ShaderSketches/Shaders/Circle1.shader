Shader "ShaderSketches/Circle1"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    float3 hue_to_rgb(float h)
    {
        h = frac(h) * 6 - 2;
        return saturate(float3(abs(h - 1) - 1, 2 - abs(h),
                        2 - abs(h - 2)));
    }

    float circle(float2 uv, float size)
    {
        return step(0, size) * (1 - smoothstep(0, size, length(0.5 - uv)));
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float n = 13;
        float freq = 7 * length(0.5 - (floor(i.uv * n) + 0.5) / n);
        float t = sin(-_Time.y * 2 + freq) * 0.5;
        
        i.uv -= 0.5;
        i.uv *= t;
        i.uv += 0.5;
        
        float a = circle(frac(i.uv * n), t);
        return a * float4(hue_to_rgb(0.23 + freq * 0.16), 1);
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
