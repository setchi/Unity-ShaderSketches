Shader "ShaderSketches/Hex2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"
    
    float2 mod(float2 a, float2 b) { return a - b * floor(a / b); }

    float hex(float2 st, float2 r)
    {
        st = abs(st);
        return max(st.x - r.y, max(st.x + st.y * 0.57735, st.y * 1.1547) - r.x);
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

    float swirl(float2 st)
    {
        float phi = atan2(st.y, st.x);
        return sin(length(st) * 8 + phi - _Time.y * 4) * 0.5 + 0.5;
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float sw = swirl(i.uv - 0.5);
        float h = abs(0.5 + sin(hex_grid(i.uv) * 40 * sw));

        return 1 - float4(0, 1, 1, 1) * step(h, 0.12);
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
