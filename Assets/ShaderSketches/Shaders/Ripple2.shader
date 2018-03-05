Shader "ShaderSketches/Ripple2"
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

    float ripple(float2 st, float t)
    {
        float d = length(0.5 - st);
        float outer = step(d, lerp(0.20, 0.45, t));
        float inner = step(d, lerp(0.15, 0.50, t));

        return saturate(outer - inner);
    }

    float ripples(float2 st)
    {
        float n = 5;
        float2 ist = floor(st * n);
        float2 fst = frac(st * n);

        float x = (ist.x + ist.y) / n * 0.8;
        float t = frac(x + _Time.y + rand(ist) * 0.7);

        return ripple(fst, t) * (1 - t);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float t = _Time.y;
        i.uv *= 1.0 + 0.1 * sin(i.uv.x * 5.0 + t) + 0.1 * sin(i.uv.y * 3.0 + t);
        i.uv *= 1.0 + 0.3 * length(i.uv);
        i.uv += t * 0.2;

        return lerp(float4(0.12, 0.06, 0.04, 1),
                    float4(0.74, 0.16, 0.00, 1),
                    ripples(i.uv));
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
