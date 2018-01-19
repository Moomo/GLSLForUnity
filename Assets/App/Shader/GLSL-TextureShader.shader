Shader "GLSL/Texture" {
	Properties {
		// Inspectorから入力される値
		_MainTex("Base (RGB)" , 2D) = "white" {}
		}
		SubShader {
			Pass {
				Cull Off

				GLSLPROGRAM
				#include "UnityCG.glslinc"
				uniform sampler2D _MainTex;
				vec4 textureCoordinates;
				// バーテックスシェーダー
				#ifdef VERTEX
				void main() {
					textureCoordinates = gl_MultiTexCoord0;
					// 座標変換
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				}
				#endif

				// フラッグメントシェーダー
				#ifdef FRAGMENT
				void main() {
					gl_FragColor =
					texture2D(_MainTex, vec2(textureCoordinates));
				}
				#endif

				ENDGLSL
			}
		}
		//FallBack "Diffuse"
	}
