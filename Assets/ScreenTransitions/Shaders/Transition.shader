// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Transition" {
	Properties {
		_MainTex("Main Texture", 2D) = "white" {}
		_ScreenColor("Screen Color", Color) = (0, 0, 0, 1)
		_TransitionTex("Transition Texture", 2D) = "white" {}
		_Progress("Progress", Range(0, 1)) = 0
		[MaterialToggle] _Distort("Distort", Float) = 0
		_Fade("Fade", Range(0, 1)) = 0
	}

	SubShader {
		Tags {
			"RenderType" = "Opaque"
		}

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			float2 _MainTex_TexelSize;
			fixed4 _ScreenColor;
			sampler2D _TransitionTex;
			float _Progress;
			float _Distort;
			float _Fade;

			struct vInput {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
			};

			struct fInput {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
			};

			fInput vert(vInput input) {
				fInput output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				output.uv = input.uv;
				output.uv1 = input.uv;

				#if UNITY_UV_STARTS_AT_TOP
				// differences between dx and opengl
				if (_MainTex_TexelSize.y < 0) {
					output.uv1.y = 1 - output.uv1.y;
				}
				#endif

				return output;
			}

			fixed4 frag(fInput input) : SV_TARGET {
				fixed4 transitionColor = tex2D(_TransitionTex, input.uv1);

				fixed2 direction = float2(0, 0);
				if (_Distort) {
					direction = normalize(float2((transitionColor.b - 0.5) * 2, (transitionColor.g - 0.5) * 2));
				}

				fixed4 col = tex2D(_MainTex, input.uv + _Progress * direction);

				if (transitionColor.b < _Progress) {
					return lerp(col, _ScreenColor, _Fade);
				}
				return col;
			}
			ENDCG
		}
	}
}
