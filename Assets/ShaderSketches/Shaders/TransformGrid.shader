Shader "ShaderSketches/TransformGrid"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"

    float2 transform_uv(float2 uv, float2 radius)
    {
        float distance = length(0.5 - uv);
        float distortion = 1 - smoothstep(radius * 10, radius, distance);
        return uv + (0.5 - uv) * distortion;
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        float radius = (1 + sin(_Time.y)) * 0.05 + 0.05;
        float2 uv = transform_uv(i.uv, radius);

        float2 fst = frac(uv * 7);
        float4 grid = lerp(float4(0, 0, 0, 1),
                           float4(1, 1, 1, 1),
                           step(0.9, fst.x) + step(0.9, fst.y));
        return grid;
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
