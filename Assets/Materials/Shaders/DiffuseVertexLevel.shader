Shader "Custom/DiffuseVertexLevel" {
	Properties {
		_Diffuse("Diffuse", Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader {
		pass{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};

			v2f vert(a2v v){
				v2f o;
				//顶点坐标从模型空间转换到剪裁空间
				o.pos = UnityObjectToClipPos(v.vertex);
				
				//环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//顶点法线从模型空间转换到世界空间
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				//获取世界空间的光照方向
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				//计算漫反射光照
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
				//环境光加漫反射光照
				o.color = ambient + diffuse;

				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET{
				return fixed4(i.color, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
