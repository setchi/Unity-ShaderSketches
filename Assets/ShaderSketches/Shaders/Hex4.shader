Shader "ShaderSketches/Hex4"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"
    
    float2 mod(float2 a, float2 b) { return a - b * floor(a / b); }

    float hex(float2 p, float2 r)
    {
        p = abs(p);
        return max(p.x - r.y, max(p.x + p.y * 0.57735, p.y * 1.1547) - r.x);
    }

    float hex_grid(float2 st)
    {
        st.x += 0.02;
        
        float2 g = float2(0.692, 0.4) * 0.5;
        float r = 0.005;
        
        float2 p1 = mod(st, g) - g * 0.5;
        float2 p2 = mod(st + g * 0.5, g) - g * 0.5;
        
        return min(hex(p1, r), hex(p2, r));
    }

    float wave(float2 st)
    {
        float pos = st.y + st.x;
        return (1 + sin(-_Time.y * 3 + pos * 4)) * 0.4;
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float4 color = 0;
        float w = wave(i.uv);

        i.uv.xy += _Time.x;

        float h1 = abs(0.4 + sin(hex_grid(i.uv) * 40) * w);
        h1 = step(h1, 0.1);
        color = lerp(color, float4(1, 0, 1, 1), h1);

        float h2 = abs(0.3 + sin(hex_grid(i.uv) * 40) * w);
        h2 = step(h2, 0.1);
        color = lerp(color, float4(0, 0, 1, 1), h2);

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
