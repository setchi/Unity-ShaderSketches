Shader "ShaderSketches/Trail1"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    #define PI 3.14159265359

    float rand(float2 uv)
    {
        return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
    }

    float2 rotate(float2 st, float angle)
    {
        float2x2 mat = float2x2(cos(angle), -sin(angle),
                                sin(angle), cos(angle));
        st -= 0.5;
        st = mul(mat, st);
        st += 0.5;
        return st;
    }

    float box(float2 st, float t)
    {
        st = rotate(st, t * 2.05 * PI / 4);
        float size = t * 1.42;
        st = step(size, st) * step(size, 1.0 - st);
        return st.x * st.y;
    }

    float lattice(float2 st, float n)
    {
        float size = sin(st.y + _Time.y * 1.3 + rand(floor(st * n).x * 0.5));
        return box(frac(st * n), size);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        i.uv = rotate(i.uv, PI / 4);

        float l1 = lattice(i.uv, 45);
        float l2 = lattice(i.uv, 20);
        
        return float4(l1, 1.2, l2, 1) / 1.2;
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
