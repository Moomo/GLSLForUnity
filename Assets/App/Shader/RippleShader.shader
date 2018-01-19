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
					// gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
					gl_Position = ftransform();
					// 頂点情報ワールド空間に変換して入れておく
					// glVertexWorld = _Object2World * gl_Vertex;
				}
			#endif

			#ifdef FRAGMENT
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
