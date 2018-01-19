Shader "GLSL/SandboxShader"
{
	SubShader
	{
		Tags { "Queue" = "Transparent" }
		Pass
		{
			//最初のパスは背面のみレンダリング。つまり内側。
			Cull Off

			//アルファブレンディングを使う
			Blend SrcAlpha OneMinusSrcAlpha
			
			GLSLPROGRAM
			#include "UnityCG.glslinc"
			
			#ifdef VERTEX
            //フラグメントシェーダーに渡すUV
			varying vec4 uv;

			void main()
			{
			    //頂点を設定
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				//uvを設定
				uv = gl_MultiTexCoord0;
			}
			#endif

			#ifdef FRAGMENT

            //フラグメントシェーダーから渡ってきたUV
			varying vec4 uv;
			
			//解像度
			vec2 resolution = vec2(_ScreenParams.x, _ScreenParams.y);
			
			float time = _Time.y;
			
			#define PI 3.14159265359
			#define T (time / .99)

			vec3 hsv2rgb(vec3 c)
			{
				vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 4.0);
				vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
			}


			void main()
			{

				vec2 position = uv.xy * 2 -1 ;

				float color = 1.0;
				color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
				color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
				color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
				color *= sin( time / 10.0 ) * 0.5;

				vec3 finishColor = vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75) ;
				if(length(finishColor) <= 0.8)
				{
					discard;
				}
				gl_FragColor = vec4(finishColor , 1.0 );
			}
			#endif

			ENDGLSL

		}
	}
}
