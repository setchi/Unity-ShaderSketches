Shader "ShaderSketches/Hex1"
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
        float d1 = hex(p1, r);
        float d2 = hex(p2, r);
        
        return min(d1, d2);
    }
            
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float a = length(min(mod(-_Time.y + length(0.5 - i.uv), 3.0) - 1.0, 1.0));
        float h = hex_grid(i.uv) * a;

        return float4(0.2, 1, 0.2, 1) * (1 - step(0.15, abs(sin(h * 50))));
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
