// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Nebula/Neon Topography Chromatic"
{
	Properties
	{
		[NoScaleOffset][SingleLineTexture]_Lines("Lines", 2D) = "white" {}
		[HDR][Gamma][NoScaleOffset][SingleLineTexture]_Noise("Noise", 2D) = "black" {}
		[NoScaleOffset][SingleLineTexture]_Metallic("Metallic", 2D) = "white" {}
		[NoScaleOffset][SingleLineTexture]_Roughness("Roughness", 2D) = "white" {}
		[ToggleUI]_AlbidoTexture("Albido Texture", Range( 0 , 1)) = 0
		_AlbedoColor("Albedo Color", Color) = (0.254717,0.254717,0.254717,0)
		[ToggleUI]_MetallicTexture("Metallic Texture", Range( 0 , 1)) = 0
		_MetallicIntensity("Metallic Intensity", Range( 0 , 1)) = 1
		[ToggleUI]_RoughnessTexture("Roughness Texture", Range( 0 , 1)) = 0
		_RoughnessIntensity("Roughness Intensity", Range( 0 , 1)) = 0.5
		_EmissionIntensity("Emission Intensity", Range( 0 , 5)) = 2
		_ColorGradientIntensity("Color Gradient Intensity", Range( 0 , 1)) = 0.06212735
		_AnimationSpeed("Animation Speed", Range( 0 , 10)) = 1
		_LineDensity("Line Density", Range( 0 , 5)) = 2
		_LineColorScale("Line Color Scale", Range( 0 , 0.2)) = 0.18
		_RainbowAnimationsSpeed("Rainbow Animations Speed", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _AlbidoTexture;
		uniform float4 _AlbedoColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Noise);
		uniform float4 _Noise_ST;
		SamplerState sampler_Noise;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Lines);
		uniform float _LineDensity;
		uniform float _AnimationSpeed;
		SamplerState sampler_Lines;
		uniform float _LineColorScale;
		uniform float _RainbowAnimationsSpeed;
		uniform float _ColorGradientIntensity;
		uniform float _EmissionIntensity;
		uniform float _MetallicTexture;
		uniform float _MetallicIntensity;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Metallic);
		SamplerState sampler_Metallic;
		uniform float _RoughnessTexture;
		uniform float _RoughnessIntensity;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Roughness);
		SamplerState sampler_Roughness;


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1));
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1));
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float layeredBlendVar136 = _AlbidoTexture;
			float4 layeredBlend136 = ( lerp( _AlbedoColor,SAMPLE_TEXTURE2D( _Noise, sampler_Noise, uv_Noise ) , layeredBlendVar136 ) );
			o.Albedo = layeredBlend136.rgb;
			float temp_output_132_0 = ( _AnimationSpeed / 500.0 );
			float mulTime122 = _Time.y * temp_output_132_0;
			float2 panner34 = ( mulTime122 * float2( 0.1,0 ) + float2( 0.5,0 ));
			Gradient gradient169 = NewGradient( 0, 3, 2, float4( 0.4150943, 0.4150943, 0.4150943, 0.002944991 ), float4( 0.5566038, 0.5566038, 0.5566038, 0.4911726 ), float4( 0.6886792, 0.6886792, 0.6886792, 1 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float AnimationSpeed124 = temp_output_132_0;
			float mulTime125 = _Time.y * AnimationSpeed124;
			float2 panner77 = ( mulTime125 * float2( 0.56,1.2 ) + float2( 0,0 ));
			float2 uv_TexCoord83 = i.uv_texcoord + panner77;
			float mulTime127 = _Time.y * ( AnimationSpeed124 / 10.0 );
			float2 panner91 = ( mulTime127 * float2( -0.85,-0.5 ) + float2( 0,0 ));
			float2 uv_TexCoord90 = i.uv_texcoord * float2( 2,2 ) + panner91;
			Gradient gradient195 = NewGradient( 0, 7, 2, float4( 1, 0, 0.08445263, 0.005889982 ), float4( 1, 0.9880785, 0, 0.1353018 ), float4( 0.03796029, 1, 0, 0.320592 ), float4( 0, 1, 0.742964, 0.4705882 ), float4( 0.1098039, 0.6525705, 0.8823529, 0.6470588 ), float4( 0.08220863, 0, 1, 0.8352941 ), float4( 0.8894367, 0, 1, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float mulTime210 = _Time.y * 0.005;
			float2 panner211 = ( mulTime210 * float2( 0.1,0 ) + float2( 0.5,0 ));
			float4 temp_output_209_0 = ( float4( panner211, 0.0 , 0.0 ) + SampleGradient( gradient169, ( SAMPLE_TEXTURE2D( _Noise, sampler_Noise, uv_TexCoord83 ) + SAMPLE_TEXTURE2D( _Noise, sampler_Noise, uv_TexCoord90 ) ).r ) );
			float mulTime187 = _Time.y * 0.1;
			float2 panner180 = ( mulTime187 * float2( -5,-1.2 ) + float2( 0,0 ));
			float2 uv_TexCoord178 = i.uv_texcoord + panner180;
			float mulTime214 = _Time.y * ( _RainbowAnimationsSpeed / 10.0 );
			float2 panner181 = ( mulTime214 * float2( -0.25,2 ) + float2( 0,0 ));
			float2 uv_TexCoord182 = i.uv_texcoord + panner181;
			o.Emission = ( ( ( SAMPLE_TEXTURE2D( _Lines, sampler_Lines, ( _LineDensity * ( float4( panner34, 0.0 , 0.0 ) + SampleGradient( gradient169, ( SAMPLE_TEXTURE2D( _Noise, sampler_Noise, uv_TexCoord83 ) + SAMPLE_TEXTURE2D( _Noise, sampler_Noise, uv_TexCoord90 ) ).r ) ) ).rg ) * 0.1 ) * saturate( SampleGradient( gradient195, CalculateContrast(1.0,( ( SAMPLE_TEXTURE2D( _Noise, sampler_Noise, ( ( temp_output_209_0 * _LineColorScale ) * float4( uv_TexCoord178, 0.0 , 0.0 ) ).rg ) * SAMPLE_TEXTURE2D( _Noise, sampler_Noise, uv_TexCoord182 ) ) / ( 1.0 - _ColorGradientIntensity ) )).r ) ) ) * ( _EmissionIntensity * 10.0 ) ).rgb;
			float4 temp_cast_10 = (_MetallicIntensity).xxxx;
			float2 uv_Metallic144 = i.uv_texcoord;
			float layeredBlendVar139 = _MetallicTexture;
			float4 layeredBlend139 = ( lerp( temp_cast_10,SAMPLE_TEXTURE2D( _Metallic, sampler_Metallic, uv_Metallic144 ) , layeredBlendVar139 ) );
			o.Metallic = layeredBlend139.r;
			float4 temp_cast_12 = (_RoughnessIntensity).xxxx;
			float2 uv_Roughness146 = i.uv_texcoord;
			float layeredBlendVar140 = _RoughnessTexture;
			float4 layeredBlend140 = ( lerp( temp_cast_12,SAMPLE_TEXTURE2D( _Roughness, sampler_Roughness, uv_Roughness146 ) , layeredBlendVar140 ) );
			o.Smoothness = layeredBlend140.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
1325;73;1181;998;2466.261;145.1761;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;123;-1156.655,-1172.44;Inherit;False;Property;_AnimationSpeed;Animation Speed;12;0;Create;True;0;0;0;False;0;False;1;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;132;-854.6203,-1160.359;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;500;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-702.9463,-1162.826;Inherit;False;AnimationSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-2640.946,-572.8259;Inherit;False;124;AnimationSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;128;-2315.946,-463.8259;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;127;-2156.946,-445.8259;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;167;-2263.32,-1178.523;Inherit;True;Property;_Noise;Noise;1;4;[HDR];[Gamma];[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;None;a11caa5cdbb8dea4aba5df602f85c5e7;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleTimeNode;125;-2179.946,-630.8259;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;77;-1954.069,-766.4442;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.56,1.2;False;1;FLOAT;0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;91;-1916.758,-511.8009;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.85,-0.5;False;1;FLOAT;0.001;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-1998.237,-1173.746;Inherit;False;Noies;-1;True;1;0;SAMPLER2D;_Sampler0158;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-1628.646,-641.2618;Inherit;False;158;Noies;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;-1683.405,-540.3675;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-1759.046,-762.0813;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;161;-1650.03,-954.9056;Inherit;False;158;Noies;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;74;-1429.247,-930.7704;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;e07fd66f150f4884082115f9b378347c;e07fd66f150f4884082115f9b378347c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;92;-1426.877,-608.4792;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;e07fd66f150f4884082115f9b378347c;e07fd66f150f4884082115f9b378347c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;210;-1256.982,-287.6396;Inherit;False;1;0;FLOAT;0.005;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-1043.49,-837.5338;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientNode;169;-958.4595,-959.8054;Inherit;False;0;3;2;0.4150943,0.4150943,0.4150943,0.002944991;0.5566038,0.5566038,0.5566038,0.4911726;0.6886792,0.6886792,0.6886792,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-2991.476,605.1413;Inherit;False;Property;_RainbowAnimationsSpeed;Rainbow Animations Speed;15;0;Create;True;0;0;0;False;0;False;0;0.42;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;187;-2527.868,438.0887;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;213;-2683.476,613.1413;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;168;-691.4595,-712.8054;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;211;-943.6722,-331.4965;Inherit;False;3;0;FLOAT2;0.5,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-1828.139,340.0215;Inherit;False;Property;_LineColorScale;Line Color Scale;14;0;Create;True;0;0;0;False;0;False;0.18;0.0658;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;214;-2378.476,651.1413;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;209;-404.1196,-384.3006;Inherit;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;180;-2249.034,403.383;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-5,-1.2;False;1;FLOAT;0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-1538.477,116.7877;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;178;-1946.515,63.43567;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;181;-2023.219,608.2933;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.25,2;False;1;FLOAT;0.015;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;184;-1800.496,259.9222;Inherit;False;158;Noies;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-1295.859,186.239;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-1735.483,-124.8795;Inherit;False;158;Noies;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;182;-1538.495,621.2821;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;122;-720.2873,-1058.996;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;177;-979.967,-39.17984;Inherit;True;Property;_TextureSample8;Texture Sample 8;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;183;-946.0843,197.8597;Inherit;True;Property;_TextureSample9;Texture Sample 9;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;176;-621.6538,240.1585;Inherit;False;Property;_ColorGradientIntensity;Color Gradient Intensity;11;0;Create;True;0;0;0;False;0;False;0.06212735;0.96;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;194;-321.0922,209.0586;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;34;-459.3161,-916.1311;Inherit;False;3;0;FLOAT2;0.5,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-559.9191,-30.15017;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;192;-146.3937,11.2602;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-329.0394,-1002.268;Inherit;False;Property;_LineDensity;Line Density;13;0;Create;True;0;0;0;False;0;False;2;1.61;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-181.1328,-750.0385;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;32;-212.2982,-1279.044;Inherit;True;Property;_Lines;Lines;0;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;f00bb6d35ed23d149be6d2e928027f39;f00bb6d35ed23d149be6d2e928027f39;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleContrastOpNode;199;86.3261,-80.47175;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientNode;195;107.6396,-254.3678;Inherit;False;0;7;2;1,0,0.08445263,0.005889982;1,0.9880785,0,0.1353018;0.03796029,1,0,0.320592;0,1,0.742964,0.4705882;0.1098039,0.6525705,0.8823529,0.6470588;0.08220863,0,1,0.8352941;0.8894367,0,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;8.673072,-928.3258;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;196;322.5756,-117.5054;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;594.79,-588.2314;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;232.7889,-999.6092;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;150;768.2299,-142.868;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;145;1083.481,738.2526;Inherit;True;Property;_Roughness;Roughness;3;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;104;934.9879,196.1512;Inherit;False;Property;_EmissionIntensity;Emission Intensity;10;0;Create;True;0;0;0;False;0;False;2;2.7;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;143;1084.277,473.8004;Inherit;True;Property;_Metallic;Metallic;2;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;166;1464.938,-583.0486;Inherit;False;158;Noies;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;776.3487,-624.8014;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;142;1976.724,598.9634;Inherit;False;Property;_RoughnessTexture;Roughness Texture;8;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;135;1663.541,-456.9546;Inherit;True;Property;_TextureSample5;Texture Sample 5;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;144;1317.723,474.1921;Inherit;True;Property;_TextureSample6;Texture Sample 6;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;146;1316.927,738.6443;Inherit;True;Property;_TextureSample7;Texture Sample 7;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;110;1476.737,-185.0005;Inherit;False;Property;_AlbedoColor;Albedo Color;5;0;Create;True;0;0;0;False;0;False;0.254717,0.254717,0.254717,0;0.2547165,0.2547165,0.2547165,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;109;1751.851,804.9221;Inherit;False;Property;_RoughnessIntensity;Roughness Intensity;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;1750.651,700.9223;Inherit;False;Property;_MetallicIntensity;Metallic Intensity;7;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;1173.413,-356.6545;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;137;1712.109,-235.4593;Inherit;False;Property;_AlbidoTexture;Albido Texture;4;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;1260.557,226.5849;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;1975.423,420.8633;Inherit;False;Property;_MetallicTexture;Metallic Texture;6;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;139;2291.327,416.9633;Inherit;False;6;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LayeredBlendNode;140;2292.623,587.2634;Inherit;False;6;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;1467.104,3.024642;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-1341.955,430.2329;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-1119.735,528.8616;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LayeredBlendNode;136;2046.208,-192.5596;Inherit;False;6;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2561.4,-31.3;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;.Nebula/Neon Topography Chromatic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;132;0;123;0
WireConnection;124;0;132;0
WireConnection;128;0;126;0
WireConnection;127;0;128;0
WireConnection;125;0;126;0
WireConnection;77;1;125;0
WireConnection;91;1;127;0
WireConnection;158;0;167;0
WireConnection;90;1;91;0
WireConnection;83;1;77;0
WireConnection;74;0;161;0
WireConnection;74;1;83;0
WireConnection;92;0;162;0
WireConnection;92;1;90;0
WireConnection;170;0;74;0
WireConnection;170;1;92;0
WireConnection;213;0;212;0
WireConnection;168;0;169;0
WireConnection;168;1;170;0
WireConnection;211;1;210;0
WireConnection;214;0;213;0
WireConnection;209;0;211;0
WireConnection;209;1;168;0
WireConnection;180;1;187;0
WireConnection;205;0;209;0
WireConnection;205;1;208;0
WireConnection;178;1;180;0
WireConnection;181;1;214;0
WireConnection;203;0;205;0
WireConnection;203;1;178;0
WireConnection;182;1;181;0
WireConnection;122;0;132;0
WireConnection;177;0;98;0
WireConnection;177;1;203;0
WireConnection;183;0;184;0
WireConnection;183;1;182;0
WireConnection;194;0;176;0
WireConnection;34;1;122;0
WireConnection;185;0;177;0
WireConnection;185;1;183;0
WireConnection;192;0;185;0
WireConnection;192;1;194;0
WireConnection;63;0;34;0
WireConnection;63;1;168;0
WireConnection;199;1;192;0
WireConnection;71;0;133;0
WireConnection;71;1;63;0
WireConnection;196;0;195;0
WireConnection;196;1;199;0
WireConnection;62;0;32;0
WireConnection;62;1;71;0
WireConnection;150;0;196;0
WireConnection;72;0;62;0
WireConnection;72;1;73;0
WireConnection;135;0;166;0
WireConnection;144;0;143;0
WireConnection;146;0;145;0
WireConnection;101;0;72;0
WireConnection;101;1;150;0
WireConnection;179;0;104;0
WireConnection;139;0;141;0
WireConnection;139;1;108;0
WireConnection;139;2;144;0
WireConnection;140;0;142;0
WireConnection;140;1;109;0
WireConnection;140;2;146;0
WireConnection;103;0;101;0
WireConnection;103;1;179;0
WireConnection;206;0;209;0
WireConnection;206;1;208;0
WireConnection;204;0;206;0
WireConnection;204;1;182;0
WireConnection;136;0;137;0
WireConnection;136;1;110;0
WireConnection;136;2;135;0
WireConnection;0;0;136;0
WireConnection;0;2;103;0
WireConnection;0;3;139;0
WireConnection;0;4;140;0
ASEEND*/
//CHKSM=BA09FB20F898459FE455920E4B6C1C12A356244E