Shader "ShaderSketches/Rotate"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    #define PI 3.14159265359

    float box(float2 st, float2 size)
    {
        size = 0.5 - size * 0.5;
        st = step(size, st) * step(size, 1.0 - st);
        return st.x * st.y;
    }

    float2x2 rotate(float angle)
    {
        return float2x2(cos(angle), -sin(angle),
                        sin(angle), cos(angle));
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float2 st = i.uv;
        float t = _Time.y;
        
        st -= 0.5;
        st = mul(rotate(sin(t) * PI), st);
        st += 0.5;
        
        return box(st, 0.4);
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
