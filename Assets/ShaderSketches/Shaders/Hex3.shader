Shader "ShaderSketches/Hex3"
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

    float swirl(float2 st)
    {
        float phi = atan2(st.y, st.x);
        return sin(length(st) * 8 + phi - _Time.y * 4) * 0.5 + 0.5;
    }
            
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float sw = swirl(i.uv - 0.5);
        sw = smoothstep(0, 0.33, sw) - smoothstep(0.66, 1, sw);

        float stepped_sw = step(0.5, sw);
        sw = lerp(2, 3.505, stepped_sw);
        
        float hwave = abs(sin(hex_grid(i.uv) * 30 * sw + _Time.y * 2 * sw));
        float stepped_hwave = step(hwave, 0.5);
        
        return lerp(float4(0, 1, 0, 1),
                    float4(0, 1, 1, 1),
                    stepped_sw) * stepped_hwave;
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
