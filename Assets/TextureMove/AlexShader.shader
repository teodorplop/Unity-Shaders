// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/AlexShader" {
	Properties {
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
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
				displace.x = _Time;
				displace.y = 0;

				fixed4 col = tex2D(_MainTex, i.texcoord + displace * 10);
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
