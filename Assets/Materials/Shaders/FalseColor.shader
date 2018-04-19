Shader "Custom/FalseColor" {
	Properties {
		_Color("Color", Color) = (0.5,0.5,0.5,1.0)
	}
	SubShader {
		pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f{
				float4 pos : SV_POSITION;
				fixed4 color : COLOR0;
			};

			fixed4 _Color;

			v2f vert(appdata_full v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				// 法线方向
				// o.color = fixed4(v.normal * 0.5, 0.0) + _Color;

				// 切线方向
				// o.color = fixed4(v.tangent * 0.5) + _Color;
				
				// 副切线方向
				// fixed3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
				// o.color = fixed4(binormal * 0.5, 0.0) + _Color;

				// 第一组纹理坐标
				// o.color = fixed4(v.texcoord.xy, 0.0, 1.0);

				// 第二组纹理坐标
				// o.color = fixed4(v.texcoord1.xy, 0.0, 1.0);

				// 第一组纹理坐标的小数部分
				// o.color = frac(v.texcoord);
				// if(any(saturate(v.texcoord) - v.texcoord)){
				// 	o.color.b = 0.5;
				// }
				// o.color.a = 1.0;

				// 第二组纹理坐标的小数部分
				// o.color = frac(v.texcoord1);
				// if(any(saturate(v.texcoord1) - v.texcoord1)){
				// 	o.color.b = 0.5;
				// }
				// o.color.a = 1.0;
				
				// 顶点颜色
				o.color = v.color;
				
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET{
				return i.color;
			}

			ENDCG
		}
	}
	FallBack "VertexLit"
}
