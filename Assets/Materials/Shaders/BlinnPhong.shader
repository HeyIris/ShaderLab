//Blinn-Phong光照模型下，逐顶点光照和逐像素光照有差异。
//Blinn-Phong光照模型比Phong模型的高光范围大。

Shader "Custom/BlinnPhong" {
	Properties {
		_Diffuse("Diffuse", Color) = (1.0,1.0,1.0,1.0)
		_Specular("Specular", Color) = (1.0,1.0,1.0,1.0)
		_Gloss("Gloss", Range(8.0, 256.0)) = 20.0
	}
	SubShader {
		pass{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			half _Gloss;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v){
				v2f o;
				//顶点坐标从模型空间转换到剪裁空间
				o.pos = UnityObjectToClipPos(v.vertex);
				//顶点法线从模型空间转换到世界空间
				//o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				//顶点从模型空间转换到世界空间
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET{
				//环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				//顶点法线从模型空间转换到世界空间
				fixed3 worldNormal = normalize(i.worldNormal);
				//获取世界空间的光照方向
				//fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));
				//计算漫反射光照
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
				
				//计算视线方向
				//fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				//计算h方向
				fixed3 halfDir = normalize(worldLight + viewDir);
				//计算高光反射光照
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal,halfDir)), _Gloss);

				//环境光加漫反射光照
				fixed3 color = ambient + diffuse + specular;

				return fixed4(color, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Specular"
}
