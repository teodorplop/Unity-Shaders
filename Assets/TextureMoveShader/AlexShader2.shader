// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/AlexShader2" {
	Properties {
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Displacement ("Displacement", Float) = 0
		_Speed ("Speed", Float) = 1
	}
	
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		ZWrite Off Lighting Off Cull Off Fog { Mode Off } Blend SrcAlpha OneMinusSrcAlpha
		LOD 110
		
		Pass {
			CGPROGRAM
			#pragma vertex vert_vct
			#pragma fragment frag_mult 
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _Displacement;
			float _Speed;

			struct vin_vct {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f_vct {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			v2f_vct vert_vct(vin_vct v) {
				v2f_vct o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			fixed4 frag_mult(v2f_vct i) : COLOR {
				fixed2 displace;
				displace.x = _Displacement;
				displace.y = 0;

				fixed2 coord = i.texcoord + displace * _Speed;
				coord.x = fmod(coord.x, 1);
				coord.y = fmod(coord.y, 1);

				fixed4 col = tex2D(_MainTex, coord);
				return col;
			}
			
			ENDCG
		}
	}
 
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		ZWrite Off Blend SrcAlpha OneMinusSrcAlpha Cull Off Fog { Mode Off }
		LOD 100

		BindChannels {
			Bind "Vertex", vertex
			Bind "TexCoord", texcoord
			Bind "Color", color
		}

		Pass {
			Lighting Off
			SetTexture [_MainTex] { combine texture * primary }
		}
	}
}
