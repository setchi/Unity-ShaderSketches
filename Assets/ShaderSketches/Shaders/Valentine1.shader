Shader "ShaderSketches/Valentine1"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    float4 palette(float a)
    {
        float t = _Time.y * 0.5;
        float g = 0.6 + 0.3 * sin(a * 8 + t * 2);
        float b = 0.6 + 0.3 * sin(a * 5 + t * 3);
        return float4(1, g, b, 1);
    }

    // http://enjoymath.pomb.org/?p=15
    float heart(float2 st)
    {
        st = (st - float2(0.5, 0.38)) * float2(2.1, 2.8);

        float a = st.x;
        float b = st.y - sqrt(abs(st.x));
        return a * a + b * b;
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float t = _Time.y;

        float2 st = i.uv;
        st.y += -t * 0.3 + (1 + sin(st * 2 + t)) * 0.1;
        float2 fst = frac(st);

        float2 offset = float2(t * 0.5, sin(t * 1.3) * 0.6);
        float2 p = offset + st * 5;

        float2 ip = floor(p);
        float2 fp = frac(p);

        float d1 = heart(fp);
        float d2 = heart(fst);
        
        float h1 = step(d1, abs(sin(d1 * 6)));
        float h2 = step(d2, abs(sin(d2 * 8 - t * 2)));

        float4 color = 1;
        color = lerp(color, palette(length(ip)), h1);
        color = lerp(color, palette(length(fst)), h2);
        
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
