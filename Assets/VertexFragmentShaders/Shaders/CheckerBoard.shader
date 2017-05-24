Shader "Custom/CheckerBoard" {
	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float _Density;

			struct vInput {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct fInput {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			fInput vert(vInput input) {
				fInput output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				output.uv = input.uv * _Time.y;
				return output;
			}

			fixed4 frag(fInput input) : SV_TARGET {
				// Input uvs are from 0 to _Density
				// Divide them by two, we obtain something like 0, 0.5, 1, ..., _Density / 2
				float2 col = floor(input.uv) / 2;
				// Add these together and take only fractional part, we have 0 or 0.5
				// Multiply by 2, we obtain 0 or 1
				float checker = frac(col.x + col.y) * 2;
				return checker;
			}

			ENDCG
		}
	}
}
