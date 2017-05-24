Shader "Custom/SurfCheckerBoard" {
	Properties {
		_MainTex("Main Texture", 2D) = "white" {}
	}
	SubShader {
		Tags {
			"RenderType"="Opaque"
		}
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
			float2 uv_MainTex;
		};

		void surf(Input input, inout SurfaceOutput output) {
			float2 uv = floor(input.uv_MainTex * _Time) / 2;
			float checker = frac(uv.x + uv.y) * 2;
			output.Albedo = checker;
		}
		ENDCG
	}
}
