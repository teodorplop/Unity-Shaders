// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/CustomImageEffect" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
		_DisplacementTexture("Displacement Texture", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0, 0.1)) = 0
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
			sampler2D _DisplacementTexture;
			float _Magnitude;

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
				fixed2 displacement = tex2D(_DisplacementTexture, i.uv).xy;
				displacement = ((displacement * 2) - 1) * _Magnitude;
				displacement *= _SinTime.z;

				fixed4 texColor = tex2D(_MainTex, i.uv + displacement);

				return texColor;
			}
			ENDCG
		}
	}
}
