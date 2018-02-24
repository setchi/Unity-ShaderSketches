Shader "ShaderSketches/Star1"
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
        float r = 0.6 + 0.3 * sin(a * 8 + t * 2);
        float g = 0.6 + 0.3 * sin(a * 5 + t * 3);
        return float4(r, g, 1, 1);
    }

    float star(float2 p)
    {
        p -= 0.5;
        p *= 2;
        
        float a = atan2(p.y, p.x) + _Time.y / 3.0;
        float l = pow(length(p), 0.8) * 1.7;
        float d = l - 0.5 + cos(a * 5.0) * 0.1;
        return 1 - step(d, sin(d * 70 + _Time.y * 30));
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        return lerp(palette(length(i.uv)), 0, star(i.uv));
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
