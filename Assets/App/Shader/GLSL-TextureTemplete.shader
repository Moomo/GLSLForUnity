Shader "GLSL/TextureTemplete" {
	Properties {
		// Inspectorから入力される値
		_MainTex("Base (RGB)" , 2D) = "white" {}
		}
		SubShader {
			Pass {
				//GLSLを使う宣言
				GLSLPROGRAM
				#include "UnityCG.glslinc"
				//プロパティから受け取る
				uniform sampler2D _MainTex;
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
					//テクスチャーの色を取得
					vec4 tex = texture2D(_MainTex,vec2(uv));
					//色を設定
					gl_FragColor = tex;
				}
				#endif

				ENDGLSL
			}
		}
		//FallBack "Diffuse"
	}
