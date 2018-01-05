Shader "ShaderSketches/Isoline1"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"
    
    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);
        
        float2 st = i.uv;
        float x = 2 * st.y + sin(_Time.y * 5);
        float distort = sin(_Time.y * 10) * 0.1 *
                        sin(5 * x) * (- (x - 1) * (x - 1) + 1);
        
        st.x += distort;

        float t = -_Time.y * 10;
        return float4(abs(sin(t + 40.0 * length(0.5 - st + distort * 0.1))),
                      abs(sin(t + 40.0 * length(0.5 - st - distort * 0.15))),
                      abs(sin(t + 40.0 * length(0.5 - st + distort * 0.2))),
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
