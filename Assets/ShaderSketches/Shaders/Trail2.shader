Shader "ShaderSketches/Trail2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    #define PI 3.14159265359

    float rand(float2 st)
    {
        return frac(sin(dot(st, float2(12.9898, 78.233))) * 43758.5453);
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

    float trail(float2 st, float n)
    {
        float stxn =  st.x * n;
        stxn *= sin(st.y);

        float size = sin(st.y + _Time.y * 1.3 + rand(floor(stxn) * 0.5)) * 1.42;

        st = frac(stxn);
        st = step(size, st) * step(size, 1.0 - st);

        return st.x * st.y;
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        i.uv = rotate(i.uv, PI / 4);

        float l1 = trail(i.uv, 45);
        float l2 = trail(i.uv, 20);
        float l3 = step(2, l1 + l2);

        return float4(l1, l3, l2, 1) / 1.2;
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
