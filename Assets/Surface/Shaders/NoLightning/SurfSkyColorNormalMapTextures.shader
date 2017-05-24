Shader "Custom/SurfSkyColorNormalMapTextures" {
	Properties {
		_MainTex("Main Texture", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
	}
	SubShader {
		CGPROGRAM
		#pragma surface surf Custom noambient

		half4 LightingCustom(SurfaceOutput s, half3 lightDir, half atten) {
			// No lighting
			half4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		sampler2D _MainTex;
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 worldRefl; INTERNAL_DATA
		};

		void surf(Input input, inout SurfaceOutput output) {
			output.Normal = UnpackNormal(tex2D(_NormalMap, input.uv_NormalMap));

			half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, WorldReflectionVector(input, output.Normal));
			half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

			output.Albedo = tex2D(_MainTex, input.uv_MainTex) * skyColor;
		}
		ENDCG
	}
}
