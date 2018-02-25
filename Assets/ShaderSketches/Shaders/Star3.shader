Shader "ShaderSketches/Star3"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    #define PI 3.14159265359

    float2x2 inverse(float2x2 mat)
    {
        return float2x2(mat._22, -mat._12,
                        -mat._21, mat._11);
    }

    float2x2 rotate(float angle)
    {
        return float2x2(cos(angle), -sin(angle),
                        sin(angle), cos(angle));
    }

    float2 rs(float2 st, float angle, float scale)
    {
        float2x2 mat = rotate(angle);

        st -= 0.5;
        st = mul(mat, st) * scale;
        st += 0.5;

        return st;
    }

    float2 irs(float2 st, float angle, float scale)
    {
        float2x2 mat = inverse(rotate(angle));

        st -= 0.5;
        st = mul(mat, st) / scale;
        st += 0.5;

        return st;
    }

    float star(float2 st, float size)
    {
        st -= 0.5;
        st /= size;

        float a = atan2(st.y, st.x) + _Time.y * 0.3;
        float l = pow(length(st), 0.8);
        float d = l - 0.5 + cos(a * 5.0) * 0.08;

        return 1 - smoothstep(0, 0.1, d);
    }

    float halftone(float2 st)
    {
        float n = 51;
        float angle = -_Time.y * PI * 0.05;
        float scale = 0.025 + (1 + sin(_Time.y * 0.6)) * 0.5 * 0.975;

        st = rs(st, angle, scale);

        float2 ist = floor(st * n);
        float2 fst = frac(st * n);
        
        st = irs((ist + 0.5) / n, angle, scale);
        
        float tone = star(st, 0.7);
        return star(fst, 0.2 + tone * 0.65);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        return lerp(float4(0.13, 0.13, 0.13, 1),
                    float4(0.98, 0.93, 0.24, 1),
                    halftone(i.uv));
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
