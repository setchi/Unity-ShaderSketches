Shader "ShaderSketches/Lattice5"
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
        float size = t * 1.42;
        st = step(size, st) * step(size, 1.0 - st);
        return st.x * st.y;
    }

    float lattice(float2 st, float n)
    {
        float2 ist = floor(st * n);
        float2 fst = frac(st * n);
        float x = (ist.x + ist.y) / n * 0.8;
        float size = (1 + sin(x + _Time.y + rand(ist) * 0.7)) * 0.5;

        return box(fst, size) * size * 3;
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        i.uv = rotate(i.uv, -PI / 4);

        float l1 = lattice(i.uv, 8);
        float l2 = lattice(i.uv, 16);
        
        return l1 + l2;
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
