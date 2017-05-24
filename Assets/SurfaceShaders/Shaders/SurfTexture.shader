Shader "Custom/SurfTexture" {
	Properties {
		_MainTex("Main Texture", 2D) = "white" {}
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
		};

		void surf(Input input, inout SurfaceOutputStandard output) {
			output.Albedo = tex2D(_MainTex, input.uv_MainTex);
			output.Alpha = 1;
		}
		ENDCG
	}
}
