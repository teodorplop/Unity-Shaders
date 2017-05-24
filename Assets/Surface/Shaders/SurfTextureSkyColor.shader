Shader "Custom/SurfTextureSkyColor" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
	}
	SubShader {
		Tags {
			"RenderType"="Opaque"
		}

		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input input, inout SurfaceOutputStandard output) {
			half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, input.worldRefl);
			half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

			output.Albedo = skyColor * tex2D(_MainTex, input.uv_MainTex);
		}
		ENDCG
	}
}
