Shader "ShaderSketches/TransformTriangle"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    float2 transform_uv(float2 uv, float2 radius)
    {
        float distance = length(0.5 - uv);
        float distortion = 1 - smoothstep(radius * 10, radius, distance);
        return uv + (0.5 - uv) * distortion;
    }

    float2 tri_uv(float2 uv)
    {
        float sx = uv.x - uv.y / 2;
        float sxf = frac(sx);
        float offs = step(frac(1 - uv.y), sxf);
        return float2(floor(sx) * 2 + sxf + offs, uv.y);
    }

    float tri(float2 uv)
    {
        float sp = 1.2 + 3.3 * floor(tri_uv(uv));
        return max(0, sin(sp * _Time.y));
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float radius = (1 + sin(_Time.y)) * 0.05 + 0.05;
        float2 uv = transform_uv(i.uv, radius);
        return tri(uv * 7);
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
