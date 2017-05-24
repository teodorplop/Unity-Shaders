Shader "Custom/SurfNormalsColor" {
	SubShader {
		Tags {
			"RenderType" = "Opaque"
		}

		// Level of Detail
		// VertexLit kind of shaders = 100
		// Decal, Reflective VertexLit = 150
		// Diffuse = 200
		// Diffuse Detail, Reflective Bumped Unlit, Reflective Bumped VertexLit = 250
		// Bumped, Specular = 300
		// Bumped Specular = 400
		// Parallax = 500
		// Parallax Specular = 600
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Custom
		#pragma target 3.0

		half4 LightingCustom(SurfaceOutput s, half3 lightDir, half atten) {
			half4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		struct Input {
			float3 worldNormal;
		};

		void surf(Input input, inout SurfaceOutput output) {
			output.Albedo = input.worldNormal * 0.5 + 0.5;
			output.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
