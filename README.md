# Unity_GrabPassSamples

Smallest ``GrabPass`` samples are included.

<table>
<tr><th>GrabPassShader</th><th>GrabPassImageEffect</th></tr>
<tr>
<td>
<img src="https://github.com/XJINE/Unity_GrabPassSamples/blob/master/Screenshots/GrabPassShaderSample.jpg" width="100%" height="auto" />
</td>
<td>
<img src="https://github.com/XJINE/Unity_GrabPassSamples/blob/master/Screenshots/GrabPassImageEffectSample.jpg" width="100%" height="auto" />
</td>
</tr>
</table>

Following code is one of these.

```shader
// NOTE:
// Call after almost objects are rendered.

Tags
{
    "Queue" = "Transparent"
}

GrabPass
{
    "_GrabTex"
}

Pass
{
    CGPROGRAM

    #pragma vertex   vert
    #pragma fragment frag
    #include "UnityCG.cginc"

    struct v2f
    {
        float4 vertex : SV_POSITION;
        float2 uv     : TEXCOORD0;
        float4 uvg    : TEXCOORD1;
    };

    sampler2D _GrabTex;
    sampler2D _MainTex;
    float4    _MainTex_ST;
    
    v2f vert (appdata_base v)
    {
        v2f o;

        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv     = TRANSFORM_TEX(v.texcoord, _MainTex);
        o.uvg    = ComputeGrabScreenPos(o.vertex);

        return o;
    }
    
    fixed4 frag (v2f i) : SV_Target
    {
        float4 mainColor = tex2D(_MainTex, i.uv);

        // NOTE:
        // Following patterns are same.

        float4 grabColor = tex2Dproj(_GrabTex, i.uvg);
               grabColor = tex2D(_GrabTex, i.uvg.xy / i.uvg.w);

        return mainColor * 0.5 + grabColor * 0.5;
    }

    ENDCG
}
```