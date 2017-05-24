// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SingleColor" {
	Properties {
		_Color("Color", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			fixed4 _Color;

			struct vInput {
				float4 vertex : POSITION;
			};

			struct fInput {
				float4 vertex : SV_POSITION;
			};

			fInput vert(vInput input) {
				fInput output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				return output;
			}

			fixed4 frag(fInput input) : SV_TARGET {
				return _Color;
			}

			ENDCG
		}
	}
}
