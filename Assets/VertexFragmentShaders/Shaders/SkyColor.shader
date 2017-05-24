Shader "Custom/SkyColor" {
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
				half3 reflection : TEXCOORD0;
			};

			fInput vert(vInput input) {
				fInput output;
				output.vertex = UnityObjectToClipPos(input.vertex);

				// This is equivalent with UNITY_MATRIX_M * input.vertex
				float3 worldPos = mul(unity_ObjectToWorld, input.vertex).xyz;
				// Returns direction from current vertex towards the camera
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				float3 worldNormal = UnityObjectToWorldNormal(input.normal);

				output.reflection = reflect(-worldViewDir, worldNormal);

				return output;
			}

			fixed4 frag(fInput input) : SV_TARGET {
				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, input.reflection);
				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

				fixed4 col = 0;
				col.rgb = skyColor;
				return col;
			}

			ENDCG
		}
	}
}