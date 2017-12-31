Shader "ShaderSketches/Triangle3"
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

    float tri(float2 st, float size)
    {
        float2 fst = frac(st);
        return step(size, fst.x + fst.y);
    }

    float swirl(float2 st)
    {
        float phi = atan2(st.y, st.x);
        return sin(length(st) * 10 + phi - _Time.y * 4) * 0.5 + 0.5;
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float2 st = i.uv + float2(i.uv.y * 0.5 - 0.25, 0);
        float sw = swirl(floor((st) * 13) / 13 - 0.5);
        
        return lerp(float4(hue_to_rgb(sw * 0.4 + 0.8), 1),
                    float4(0, 0, 0, 1),
                    tri(frac(st * 13), sw));
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
