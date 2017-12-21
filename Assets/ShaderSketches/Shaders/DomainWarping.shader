Shader "ShaderSketches/DomainWarping"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"

    float random(float2 st)
    {
        return frac(sin(dot(st.xy, float2(12.9898, 78.233))) * 43758.5453123);
    }

    float noise(float2 st)
    {
        float2 i = floor(st);
        float2 f = frac(st);

        // Four corners in 2D of a tile
        float a = random(i);
        float b = random(i + float2(1.0, 0.0));
        float c = random(i + float2(0.0, 1.0));
        float d = random(i + float2(1.0, 1.0));

        float2 u = f * f * (3.0 - 2.0 * f);

        return lerp(a, b, u.x) +
                   (c - a)* u.y * (1.0 - u.x) +
                   (d - b) * u.x * u.y;
    }

    float fbm(float2 st)
    {
        float v = 0.0;
        float a = 0.5;
        float2 shift = 100.0;

        float2x2 rotate = float2x2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));

        for (int i = 0; i < 7; ++i)
        {
            v += a * noise(st);
            st = mul(rotate, st) * 2.0 + shift;
            a *= 0.5;
        }
        return v;
    }
    
    // Domain Warping
    // http://www.iquilezles.org/www/articles/warp/warp.htm
    float4 frag_domain_warping(v2f_img i) : SV_Target
    {
        float t = _Time.y;
        float2 st = i.uv;

        float2 q = 0;
        q.x = fbm(st + 0.00 * t);
        q.y = fbm(st + 1);

        float2 r = 0;
        r.x = fbm(st + 2.0 * q + float2(1.7, 9.2) + 0.15 * t);
        r.y = fbm(st + 2.0 * q + float2(8.3, 2.8) + 0.126 * t);

        float f = fbm(st + r);
        float3 color = 0.0;
        
        color = lerp(float3(0.1, 0.62, 0.67),
                     float3(0.67, 0.67, 0.5),
                     saturate(f * f * 4.0));

        color = lerp(color,
                     float3(0, 0, 0.16),
                     saturate(length(q)));

        color = lerp(color,
                     float3(0.07, 1, 0.07),
                     saturate(length(r.x)));

        return float4((f * f * f + 0.6 * f * f + 0.5 * f) * color, 1.0);
    }
    
    ENDCG

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_domain_warping
            ENDCG
        }
    }
}
