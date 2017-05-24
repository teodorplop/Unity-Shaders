Shader "Custom/SurfSkyColor" {
	SubShader {
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Custom noambient
		#pragma target 3.0

		half4 LightingCustom(SurfaceOutput s, half3 lightDir, half atten) {
			// No lighting
			half4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		struct Input {
			float3 worldRefl;
		};

		void surf (Input input, inout SurfaceOutput output) {
			half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, input.worldRefl);
			half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

			output.Albedo = skyColor;
			output.Alpha = 1;
		}
		ENDCG
	}
}
