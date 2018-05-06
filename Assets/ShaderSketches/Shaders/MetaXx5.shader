Shader "ShaderSketches/MetaXx5"
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
                           sin(offset + t * 3)) * 0.56;
    }

    float star(float2 st)
    {
        st = (st - 0.5) / 0.7;

        float a = atan2(st.y, st.x) + _Time.y;
        float l = pow(length(st), 0.8);
        return l - 0.5 + cos(a * 5.0) * 0.08;
    }

    float4 meta_xx(float2 st)
    {
        st = abs(0.5 - rotate(st, -_Time.y * 3));

        float d = star(move(st, 0)) *
                  star(move(st, 2)) *
                  star(move(st, 4));
        
        float ft = frac(_Time.y * 3);
        float a = smoothstep(0.6, 0.8, ft) *
             (1 - smoothstep(0.8, 1.0, ft));
        
        float n = 100 - a * 95;
        d *= n;
        float id = floor(d) / n * 5;
        float th = lerp(0.25, 1.1, a);

        return float4(lerp(float3(0.16, 0.80, 0.80),
                           float3(0.16, 0.07, 0.31),
                           id),
                      smoothstep(th - 0.05, th, abs(sin(d))));
    }

    float4 frag(v2f_img i) : SV_Target
    {
        i.uv = screen_aspect(i.uv);

        float4 xx = meta_xx(i.uv);
        float4 shadow = lerp(0.1,
                             float4(0.92, 0.97, 0.99, 1),
                             meta_xx(i.uv + 0.01).w);
        
        return lerp(float4(xx.xyz, 1), shadow, xx.w);
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
