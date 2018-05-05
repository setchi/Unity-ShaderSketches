Shader "ShaderSketches/MetaXx4"
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

    float circle(float2 st) { return -0.1 + distance(0.5, st); }

    float3 hue_to_rgb(float h)
    {
        h = frac(h) * 6 - 2;
        return saturate(float3(abs(h - 1) - 1, 2 - abs(h),
                        2 - abs(h - 2)));
    }

    float4 meta_xx(float2 st)
    {
        st = abs(0.5 - rotate(st, -_Time.y * 3));

        float d = circle(move(st, 0)) *
                  circle(move(st, 2)) *
                  circle(move(st, 4));
        
        float ft = frac(_Time.y * 3);
        float a = smoothstep(0.6, 0.8, ft) *
             (1 - smoothstep(0.8, 1.0, ft));
        
        float n = 100 - a * 95;
        d *= n;
        float id = floor(d) / n * 10;
        float th = lerp(0.25, 1.1, a);

        return float4(0.3 + hue_to_rgb(id) * 0.7,
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
