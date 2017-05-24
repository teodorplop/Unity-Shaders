Shader "Custom/SurfTesselation" {
	Properties {
		_Tesselation("Tesselation", Range(1, 32)) = 4
		_MainTex("Main Texture", 2D) = "white" {}
		_Occlusion("Occlusion", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
	}
	SubShader {
		Tags {
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows tessellate:tessFixed vertex:disp nolightmap
		#pragma target 3.0

		float _Tesselation;
		sampler2D _MainTex;
		sampler2D _Occlusion;
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Occlusion;
			float2 uv_NormalMap;
			float3 worldRefl;

			INTERNAL_DATA
		};

		void disp(inout appdata_tan v) {
			
		}

		float4 tessFixed() {
			return _Tesselation;
		}

		void surf (Input input, inout SurfaceOutputStandard output) {
			output.Normal = UnpackNormal(tex2D(_NormalMap, input.uv_NormalMap));

			float3 worldRefl = WorldReflectionVector(input, output.Normal);

			half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
			half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

			output.Albedo = skyColor * tex2D(_MainTex, input.uv_MainTex) * tex2D(_Occlusion, input.uv_Occlusion);
		}
		ENDCG
	}
}
