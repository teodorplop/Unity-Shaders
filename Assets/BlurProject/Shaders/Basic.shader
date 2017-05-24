// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Basic" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
		_SecondaryTex("Secondary Texture", 2D) = "white" {}
		_Slider("Slider", Range(0, 1)) = 0
	}

	SubShader {
		Tags {
			"Queue" = "Transparent"
		}

		Pass {
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _SecondaryTex;
			float _Slider;

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				fixed4 col = (tex2D(_MainTex, i.uv * 2) * (1 - _Slider) + tex2D(_SecondaryTex, i.uv * 2) * _Slider) * float4(i.uv.r, i.uv.g, 0, 1);
				fixed luminance = 0.3 * col.r + 0.59 * col.g + 0.11 * col.b;
				//col = fixed4(luminance, luminance, luminance, col.a);

				return col;
			}
			ENDCG
		}
	}
}
