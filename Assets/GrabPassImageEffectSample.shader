Shader "ImageEffect/GrabPassImageEffectSample"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"
            #pragma vertex vert_img
            #pragma fragment frag

            sampler2D _MainTex;

            fixed4 frag(v2f_img input) : SV_Target
            {
                float4 color = tex2D(_MainTex, input.uv);
                color.rgb = 1 - color.rgb;

                return color;
            }

            ENDCG
        }

        GrabPass
        {
            // NOTE:
            // You can define name of grabbed texture.
            // If you not, it will be named "_GrabTexture".

            "_GrabTex"
        }

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"
            #pragma vertex vert_img_grb
            #pragma fragment frag

            // NOTE:
            // v2f_img_grb & vert_img_grab are copied from UnityCG.cginc.v2f_img & vert_img.

            struct v2f_img_grb
            {
                float4 pos : SV_POSITION;
                half2  uv  : TEXCOORD0;
                half2  uvg : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f_img_grb vert_img_grb(appdata_img v)
            {
                v2f_img_grb o;

                UNITY_INITIALIZE_OUTPUT(v2f_img_grb, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv  = v.texcoord;
                o.uvg = ComputeGrabScreenPos(o.pos);
    
                return o;
            }

            sampler2D _MainTex;
            sampler2D _GrabTex;

            fixed4 frag(v2f_img_grb input) : SV_Target
            {
                float4 mainColor = tex2D(_MainTex, input.uv);
                float4 grabColor = tex2D(_GrabTex, input.uvg);

                return input.uv.x < 0.5 ? mainColor : grabColor;
            }

            ENDCG
        }
    }
}