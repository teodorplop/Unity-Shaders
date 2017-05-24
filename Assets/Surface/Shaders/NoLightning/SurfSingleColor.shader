Shader "Custom/SurfSingleColor" {
	Properties {
		_Color("Color", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Tags {
			"Queue" = "Transparent"
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
		//LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Custom alpha noambient
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Color;

		half4 LightingCustom(SurfaceOutput s, half3 lightDir, half atten) {
			half4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		struct Input {
			float3 worldPos;
		};

		void surf (Input input, inout SurfaceOutput output) {
			output.Albedo = _Color.rgb;
			output.Alpha = _Color.a;
		}
		ENDCG
	}
}
