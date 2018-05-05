Shader "ShaderSketches/MetaXx3"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white"{}
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    #include "Common.cginc"

    float2 rotate(float2 st, float angle)
    {
        st -= 0.5;
        st = mul(float2x2(cos(angle), -sin(angle),
                          sin(angle),  cos(angle)), st);
        st += 0.5;
        return st;
    }

    float2 move(float2 st, float offset)
    {
        float t = _Time.y;
        return st + float2(sin(offset + t),
                           sin(offset + t * 3)) * 0.57;
    }

    float hex(float2 st)
    {
        float r = 0.005;
        st = abs(st);
        return max(st.x - r, max(st.x + st.y * 0.57735, st.y * 1.1547) - r);
    }

    float circle(float2 st) { return -0.1 + distance(0.5, st); }

    float meta_xx(float2 st)
    {
        float d = hex(move(st, 0)) *
                  circle(move(st, 4)) *
                  circle(move(st, 8));
        
        float ft = frac(_Time.y * 2);
        float a = smoothstep(0.5, 0.75, ft) *
             (1 - smoothstep(0.75, 1.0, ft));
        
        return step(lerp(0.25, 1, a), abs(sin(d * 15)));
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float2 st = abs(0.5 - rotate(i.uv, _Time.y * 2));
        float vinette = 1.2 - length(0.5 - i.uv);

        return lerp(float4(0.89, 0.98, 0.04, 1),
                    float4(0.29, 0.31, 0.01, 1),
                    meta_xx(st)) * vinette;
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
