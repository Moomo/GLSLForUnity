Shader "GLSL/SandboxShader02"
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

			void main()
			{
				vec2 p =  uv.xy;
				p.x *= resolution.x/resolution.y;
				vec3 col = vec3(0);


				for (int i = 0; i < 40; i++) {
					float a = time*0.2+float(i)*0.1;
					vec2 c = vec2(sin(a*0.2)*cos(0.1*time),cos(a*10.5)*sin(time*1.0));
					float d = 0.1/(0.000+50.0*abs(length(p.xy)-1.0/(1.0-mod(sin(time),0.1)+0.1*float(i))));
					col += vec3(1,0.3,0)*d;
				}
				gl_FragColor = vec4(col, 1.0);
			}
			#endif

			ENDGLSL

		}
	}
}
