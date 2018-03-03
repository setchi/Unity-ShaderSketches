Shader "ShaderSketches/Ripple1"
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
        float c = length(0.5 - st);
        float outer = step(c, lerp(0.2, 0.45, t));
        float inner = step(c, 0.15 + t * 0.35);

        return saturate(outer - inner);
    }

    float ripples(float2 st)
    {
        float n = 2.5;
        float2 ist = floor(st * n);
        float2 fst = frac(st * n);

        float x = (ist.x + ist.y) / n * 0.8;
        float t = frac(x + _Time.y + rand(ist) * 0.35);

        return ripple(fst, t) * (1 - t);
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        i.uv += _Time.y * 0.2;

        return lerp(float4(0.03, 0.03, 0.13, 1),
                    float4(0.25, 0.20, 0.89, 1),
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
