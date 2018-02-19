Shader "ShaderSketches/Cherry1"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    float rand(float2 st)
    {
        return frac(sin(dot(st, float2(12.9898, 78.233))) * 43758.5453);
    }

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

    float4 draw_cherry(float2 st, float size)
    {
        st = rotate(st, _Time.y);
        st = 0.5 - st;
        size *= 0.2;
        
        float r = length(st);
        float a = atan2(st.y, st.x);
        float f1 = (abs(cos(a * 2.5)) + 0.4) * size * 1.4;
        float f2 = (abs(sin(a * 2.5)) + 1.1) * size * 1.4;

        float petal = 1 - (step(f1, r) || step(f2, r));
        float4 color = petal * lerp(float4(1, 0.3, 1, 1), 1, r / size * 0.5);

        float cap = step(length(0.5 - (st + 0.5)), size * 0.3);
        return lerp(color, float4(0.99, 0.78, 0, 1), cap);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        float2 st = i.uv;
        
        // sky
        float4 color = lerp(0.8, float4(0, 0.4, 1, 1), i.uv.y);
        
        // circle
        float size_offset = rand(floor(st * 10)) * 5;
        float circle = step(length(0.5 - frac(st * 10)),
                            (1 + sin(size_offset + -_Time.y * 3)) * 0.2);
        color = lerp(color, 1, circle * 0.2);
        
        // cherry
        float cherry_size = 0.4 + 0.9 * rand(floor(st * 4));
        float4 cherry = draw_cherry(frac(st * 4), cherry_size);
        color = lerp(color, cherry, cherry.w);

        return color;
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
