Shader "Custom/NormalsColor" {
	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct vInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct fInput {
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
			};

			fInput vert(vInput input) {
				fInput output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				output.normal = UnityObjectToWorldNormal(input.normal);
				return output;
			}

			fixed4 frag(fInput input) : SV_TARGET {
				fixed4 col = 0;
				col.rgb = input.normal * 0.5 + 0.5;
				return col;
			}

			ENDCG
		}
	}
}
