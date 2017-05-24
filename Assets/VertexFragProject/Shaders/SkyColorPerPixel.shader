Shader "Custom/SkyColorPerPixel" {
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
				float3 worldPos : TEXCOORD0;
				float3 normal : TEXCOORD1;
			};

			fInput vert(vInput input) {
				fInput output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				output.worldPos = mul(unity_ObjectToWorld, input.vertex).xyz;
				output.normal = UnityObjectToWorldNormal(input.normal);

				return output;
			}

			fixed4 frag(fInput input) : SV_TARGET {
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(input.worldPos));
				half3 reflection = reflect(-worldViewDir, input.normal);

				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflection);
				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

				fixed4 col = 0;
				col.rgb = skyColor;
				return col;
			}

			ENDCG
		}
	}
}