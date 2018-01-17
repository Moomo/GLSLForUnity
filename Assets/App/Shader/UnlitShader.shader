Shader "Custom/GLSL Shader"
{
	SubShader
	{
		Pass
		{
			GLSLPROGRAM
			#include "UnityCG.glslinc"
			
			#ifdef VERTEX
			// バーテックスシェーダーからフラッグメントシェーダーに渡す値を入れる
	        varying vec4 glVertexWorld;
	        varying vec3 surfaceNormal;
				void main()
				{
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
							// 頂点情報ワールド空間に変換して入れておく
	        	// glVertexWorld = _Object2World * gl_Vertex;
				}
			#endif

			#ifdef FRAGMENT
				// uniform vec4 _ScreenParams;
				// uniform vec4 _Time;

				vec2 resolution = vec2(_ScreenParams.x, _ScreenParams.y);
				float time = _Time.x;

				// ここから
				const int num_x = 5;
				const int num_y = 5;
				float w = resolution.x;
				float h = resolution.y;

				vec4 draw_ball(int i, int j)
				{
					float t = time;
					float x = w / 2.0 * (1.0 + cos(1.5 * t + float(3 * i + 4 * j)));
					float y = h / 2.0 * (1.0 + sin(2.3 * t + float(3 * i + 4 * j)));
					float size = 3.0 - 2.0 * sin(t);
					vec2 pos = vec2(x, y);
					float dist = length(gl_FragCoord.xy - pos);
					float intensity = pow(size / dist, 2.0);
					vec4 color = vec4(0.0);
					color.r = 0.5 + cos(t * float(i));
					color.g = 0.5 + sin(t * float(j));
					color.b = 0.5 + sin(float(j));
					return color * intensity;
				}

				void main()
				{
					vec4 color = vec4(0.0);
					for (int i = 0; i < num_x; ++ i)
					{
						for (int j = 0; j < num_y; ++ j)
						{
							color += draw_ball(i, j);
						}
					}
					gl_FragColor = color;
				}
			#endif
			
			ENDGLSL
			
		}
	}
}