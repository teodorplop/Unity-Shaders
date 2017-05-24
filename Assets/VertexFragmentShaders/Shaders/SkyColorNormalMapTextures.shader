Shader "Custom/SkyColorNormalMapTextures" {
	Properties {
		_MainTex("Main Texture", 2D) = "white" {}
		_OcclusionMap("Occlusion", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
	}
	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _OcclusionMap;
			sampler2D _NormalMap;

			struct vInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct fInput {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;

				float3x3 space : TEXCOORD2;
			};

			fInput vert(vInput input) {
				fInput output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				output.worldPos = mul(unity_ObjectToWorld, input.vertex).xyz;
				output.uv = input.uv;

				float3 normal = UnityObjectToWorldNormal(input.normal);
				float3 tangent = UnityObjectToWorldDir(input.tangent.xyz);
				float3 bitangent = cross(normal, tangent);
				output.space = transpose(float3x3(tangent, bitangent, normal));

				return output;
			}

			fixed4 frag(fInput input) : SV_TARGET {
				float3 normal = UnpackNormal(tex2D(_NormalMap, input.uv));
				normal = normalize(mul(input.space, normal));

				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(input.worldPos));
				half3 reflection = reflect(-worldViewDir, normal);

				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflection);
				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

				fixed4 col = 0;
				col.rgb = skyColor;
				return tex2D(_MainTex, input.uv) * tex2D(_OcclusionMap, input.uv) * col;
			}

			ENDCG
		}
	}
}