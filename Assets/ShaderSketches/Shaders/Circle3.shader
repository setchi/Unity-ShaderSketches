Shader "ShaderSketches/Circle3"
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
        st -= 0.5;
        st = mul(float2x2(cos(angle), -sin(angle),
                          sin(angle), cos(angle)), st);
        st += 0.5;
        return st;
    }

    float4 hue_to_rgb(float h)
    {
        h = frac(h) * 6 - 2;
        return saturate(float4(abs(h - 1) - 1, 2 - abs(h),
                        2 - abs(h - 2), 1));
    }

    float circle(float2 st, float size)
    {
        return step(length(0.5 - st), size);
    }
    
    float wave(float2 st)
    {
        float pos = st.y + st.x;
        float a = (1 + sin(_Time.y * 2 + pos * 3.5)) * 0.5;
        return smoothstep(0.3, 1, a);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float x = 2 * i.uv.y + sin(_Time.y * 1.5);
        float distort = sin(_Time.y * 3) * 0.13 *
                        sin(5 * x) * (- (x - 1) * (x - 1) + 1);
        i.uv.x += distort;

        float4 color = 0.2;
        for (int j = 0; j < 6; j++)
        {
            float2 st = rotate(i.uv, j * PI / 3);
            st.y += 0.15;
            float c = circle(st, 0.28) * wave(st);
            color += hue_to_rgb(0.1 + j * PI) * c;
        }
        
        return color * 0.4;
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
