Shader "ShaderSketches/Noise1"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"
    
    float2 random2(float2 st)
    {
        st = float2(dot(st, float2(127.1, 311.7)),
                    dot(st, float2(269.5, 183.3)));
        
        return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
    }

    float cell_noise(float2 st)
    {
        st *= 3;

        float2 ist = floor(st);
        float2 fst = frac(st);

        float distance = 5;

        for (int y = -1; y <= 1; y++)
        for (int x = -1; x <= 1; x++)
        {
            float2 neighbor = float2(x, y);
            float2 p = 0.5 + 0.5 * sin(_Time.y + 6.2831 * random2(ist + neighbor));

            float2 diff = neighbor + p - fst;
            distance = min(distance, length(diff));
        }

        return distance * 0.5;
    }

    float2 pattern(float2 st)
    {
        return float2(cell_noise(st), cell_noise(st + 1));
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float2 st = i.uv;
        float2 c = pattern(st + pattern(st));
        return float4(c, 0.5, 1);
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
