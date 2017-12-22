Shader "ShaderSketches/Rotate"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"

    #define PI 3.14159265359

    float box(float2 st, float2 size)
    {
        size = 0.5 - size * 0.5;
        float2 uv = smoothstep(size, size + 0.001, st);
        uv *= smoothstep(size, size + 0.001, 1.0 - st);
        return uv.x * uv.y;
    }

    float3x3 rotate(float angle)
    {
        return float3x3(cos(angle), -sin(angle), 0,
                        sin(angle), cos(angle), 0,
                        0, 0, 1);
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        float2 st = i.uv;
        float t = _Time.y;
        
        st -= 0.5;
        st = mul(rotate(sin(t) * PI), float3(st, 1));
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
