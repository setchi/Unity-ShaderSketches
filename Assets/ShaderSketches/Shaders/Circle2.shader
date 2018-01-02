Shader "ShaderSketches/Circle2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    float circle(float2 st, float size)
    {
        return step(length(0.5 - st), size);
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float2 st = i.uv;
        float x = 2 * st.y + sin(_Time.y * 5);
        float distort = sin(_Time.y * 10) * 0.1 *
                        sin(5 * x) * (- (x - 1) * (x - 1) + 1);
        st.x += distort;

        return float4(circle(st - float2(0, distort) * 0.3, 0.3),
                      circle(st + float2(0, distort) * 0.3, 0.3),
                      circle(st + float2(distort, 0) * 0.3, 0.3),
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
