Shader "Custom/SimpleShader"{
	Properties{
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader{
		pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				fixed3 color : COLOR0;
			};

			fixed4 _Color;

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.normal * 0.5;
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET{
				return (fixed4(i.color,1.0) + _Color * 0.5);
			}

			ENDCG
		}
	}
	Fallback "VertexLit"
}