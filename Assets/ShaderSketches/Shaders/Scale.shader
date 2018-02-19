Shader "ShaderSketches/Scale"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    float box(float2 st, float2 size)
    {
        size = 0.5 - size * 0.5;
        st = step(size, st) * step(size, 1.0 - st);
        return st.x * st.y;
    }

    float3x3 scale(float2 scale)
    {
        return float3x3(scale.x, 0, 0,
                        0, scale.y, 0,
                        0, 0, 1);
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float2 st = i.uv;
        float t = _Time.y;
        
        st -= 0.5;
        st = mul(scale(sin(t) + 1), float3(st, 1));
        st += 0.5;
        
        return box(st, 0.2);
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
