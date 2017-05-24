Shader "Custom/LowPolyWater" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
		_Amplitude("Amplitude", Float) = 0.01
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			static const float PI = 3.1415926;

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Amplitude;

			v2f vert(appdata v) {
				float comp1 = sin(2 * PI * _Time.y + v.vertex.x * 16) * _Amplitude;
				float comp2 = sin(2 * PI * _Time.y + v.vertex.z * v.vertex.x * 8) * _Amplitude;
				v.vertex.y = comp1 + comp2;

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.normal = float3(0, 0, 0);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}

			[maxvertexcount(3)]
			void geom(triangle v2f input[3], inout TriangleStream<v2f> OutputStream) {
				v2f aux;

				float3 normal = normalize(cross(input[1].worldPos - input[0].worldPos, input[2].worldPos - input[0].worldPos));
				for (int i = 0; i < 3; ++i) {
					aux.vertex = input[i].vertex;
					aux.normal = normal;
					aux.uv = input[i].uv;
					aux.worldPos = input[i].worldPos;
					OutputStream.Append(aux);
				}
			}

			fixed4 frag(v2f i) : SV_TARGET {
				fixed4 col = tex2D(_MainTex, i.uv);

				float3 lightDir = float3(0.5, 1, 0);
				float nDotL = dot(i.normal, normalize(lightDir));

				return fixed4(0.6, 0.65, 0.9, 1) * nDotL;
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
