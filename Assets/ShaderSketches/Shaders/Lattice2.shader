Shader "ShaderSketches/Lattice2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    #define PI 3.14159265359

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
        float freq = 2.5 * length(0.5 - (floor(st * n) + 0.5) / n);
        float t = sin(-_Time.y * 2 + freq) * 0.5;
        return box(frac(st * n), t);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        i.uv = rotate(i.uv, PI / 4);

        return float4(lattice(i.uv, 7.5),
                      lattice(i.uv, 15),
                      lattice(i.uv, 30),
                      1);
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
