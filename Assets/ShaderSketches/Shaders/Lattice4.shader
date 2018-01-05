Shader "ShaderSketches/Lattice4"
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
        float3x3 mat = float3x3(cos(angle), -sin(angle), 0,
                                sin(angle), cos(angle), 0,
                                0, 0, 1);
        st -= 0.5;
        st = mul(mat, float3(st, 1));
        st += 0.5;
        return st;
    }

    float shape(float2 st, float n, float odd)
    {
        float it = floor(_Time.y);
        float ft = frac(_Time.y);
        float t = it + smoothstep(0.3, 0.8, ft);

        st = rotate(st, PI / 4 * t * lerp(1, -1, odd));
        st = st * 2 - 1;

        float a = atan2(st.x, st.y) + PI;
        float r = PI * 2 / n;
        float d = cos(floor(0.5 + a / r) * r - a) * length(st);

        return step(0.5, abs(sin(0.7 -t * 7 + 3.0 * d)));
    }
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float2 st = i.uv * 6;
        return shape(frac(st), 4, floor(st.y) % 2);
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
