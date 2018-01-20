Shader "GLSL/ElectricBoard" {
	Properties {
		// Inspectorから入力される値
		_MainTex("Base (RGB)" , 2D) = "white" {}
			_ResolutionX("ResolutionX", float) = 50.0
			_ResolutionY("ResolutionY", float) = 50.0
			_Pitch("Pitch", float) = 0.01
			_AddColorRatio ("Add Color Ratio Range", Range (0.0,1.0)) = 0.0
			_FlickLineWidth("Flick Width",float) = 0.001
			_FlickLineNum("Flick Line Num",int) =5
			_FlickLinePitch("Flick Line Pitch",float) =0.01
			// Inspectorから入力される値
			_MaterialColor ("Color", Color) = (1,1,1,1)
			_Sspec ("Specular Color", Color) = (1,1,1,1)
			_Mgls ("Specular Index", Float) = 5
		}
		SubShader {
			Pass {
				Tags { "LightMode" = "ForwardBase" }
				//裏も描画
				Cull Off

				//GLSLを使う宣言
				GLSLPROGRAM
				#include "UnityCG.glslinc"
				//プロパティから受け取る
				uniform sampler2D _MainTex;
				//横の解像度
				uniform float _ResolutionX;
				//縦の解像度
				uniform float _ResolutionY;
				//ドットの間の幅
				uniform float _Pitch;
				//加算する色の比率
				uniform float _AddColorRatio;
				//画面のちらつきの幅
				uniform float _FlickLineWidth;
				//画面のちらつき線の本数
				uniform float _FlickLineNum;
				//画面のちらつき線の間隔
				uniform float _FlickLinePitch;
				// 入射光の色
				uniform vec4 _LightColor0;
				//マテリアルの色
				uniform vec4 _MaterialColor;
				//光の色
				uniform vec4 _Sspec;
				//フォン係数(鏡面反射指数)
				uniform float _Mgls;
				// バーテックスシェーダー
				#ifdef VERTEX
				// バーテックスシェーダーからフラッグメントシェーダーに渡す値を入れる
				varying vec4 glVertexWorld;
				varying vec3 surfaceNormal;
				//UV
				varying vec4 uv;
				//Main
				void main() {
					// 面法線
					surfaceNormal = normalize((unity_ObjectToWorld * vec4(gl_Normal, 0.0)).xyz);
					// 頂点情報ワールド空間に変換して入れておく
					glVertexWorld = unity_ObjectToWorld * gl_Vertex;
					//UVの取得
					uv = gl_MultiTexCoord0;
					// 座標変換
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				}
				#endif

				// フラッグメントシェーダー
				#ifdef FRAGMENT
				// バーテックスシェーダーからフラッグメントシェーダーに渡す値を入れる
				varying vec4 glVertexWorld;
				varying vec3 surfaceNormal;
				//UV
				varying vec4 uv;

				//光の計算を返す
				vec4 lc()
				{
					// 鏡面成分
					// 入射光ベクトル
					vec3 L = normalize(_WorldSpaceLightPos0.xyz);
					// 視点方向ベクトル
					vec3 V = normalize((vec4(_WorldSpaceCameraPos, 1.0) - glVertexWorld).xyz);
					// Cspec = (V・R)^Mgls * Sspec * Mspec
					vec3 specularReflection = pow(max(0.0, dot(reflect(-L, surfaceNormal), V)), _Mgls) * _LightColor0.xyz * _Sspec.xyz;
					// 拡散成分
					// Cdiff = (N・L)Sdiff * Mdiff
					vec3 diffuseReflection = max(0.0, dot(surfaceNormal, L)) * _LightColor0.xyz * _MaterialColor.xyz;
					// 環境成分
					// Camb = Gamb * Mamb　
					vec3 ambientLight = gl_LightModel.ambient.xyz * vec3(_MaterialColor);
					// 色を出力
					return	vec4(diffuseReflection + specularReflection , 1.0);
				}
				//Main
				void main() {
					float resolutionX = 1.0/_ResolutionX;
					float resolutionY = 1.0/_ResolutionY;
					vec2 resolution = vec2(resolutionX, resolutionY);
					vec2 uvMod = mod(vec2(uv), vec2(resolution));
					float flickSin = sin(_Time.y);
					float resolutionAverage = (_ResolutionX + _ResolutionY) / 2;
					vec2 colorUv = floor(vec2(uv) * resolutionAverage) / resolutionAverage;
					vec4 tex = texture2D(_MainTex, colorUv);
					if(uvMod.x<= _Pitch || uvMod.y <= _Pitch)
					{
						gl_FragColor = vec4(0);
					}
					else
					{
						tex += tex * _AddColorRatio;
						gl_FragColor = tex;
						for(int i = 0; i < _FlickLineNum; i++)
						{
							float flickPitch = _FlickLinePitch * i;
							float flickRangeMin =  flickSin + flickPitch;
							float flickRangeMax = flickRangeMin + _FlickLineWidth;
							if(flickRangeMin <= uv.y && flickRangeMax >= uv.y)
							{
								gl_FragColor += tex;
							}
						}
						//光の情報を乗算
						gl_FragColor *= lc();
					}
				}
				#endif

				ENDGLSL
			}
		}
		//FallBack "Diffuse"
	}
