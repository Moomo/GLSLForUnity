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
		}
		SubShader {
			Pass {

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
				// バーテックスシェーダー
				#ifdef VERTEX
				//UV
				varying vec4 uv;
				//Main
				void main() {
					//UVの取得
					uv = gl_MultiTexCoord0;
					// 座標変換
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				}
				#endif

				// フラッグメントシェーダー
				#ifdef FRAGMENT
				//UV
				varying vec4 uv;
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
					}
				}
				#endif

				ENDGLSL
			}
		}
		//FallBack "Diffuse"
	}
