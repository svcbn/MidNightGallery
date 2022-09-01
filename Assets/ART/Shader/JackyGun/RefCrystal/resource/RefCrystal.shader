
// Shader : JackyGun's RefCrystal Shader
// Copyright(c) <2020> <JackyGun twitter@konchannyan>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and / or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions :
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Shader "JackyGun/RefCrystal"
{
	Properties
	{
		_CameraRate("CameraRate", Range(0.0, 1.0)) = 0.0

		_IOR("IOR (屈折率)", Float) = 1.5
		_Color("Color", Color) = (0.4, 0.6, 0.7, 1.0)
		_Opacity("Opacity (不透明度)", Range(0.0, 1.0)) = 0.0
		_Alpha("Alpha", Range(0.0, 1.0)) = 1.0

		_RateFresnel("RateFresnel", Float) = 0.076
		_FixedR("FixedR (反射方向取り入れ)", Range(0.0, 1.0)) = 0
		_FixedO("FixedO (屈折方向取り入れ)", Range(0.0, 1.0)) = 0

		_Tex0("Tex0", 2D) = "white" {}
		_Tex1("Tex1", 2D) = "white" {}
		_Tex2("Tex2", 2D) = "white" {}
		_Tex3("Tex3", 2D) = "white" {}
		_Tex4("Tex4", 2D) = "white" {}
		_Tex5("Tex5", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "Queue"="Transparent-1" }

		Pass
		{
			Cull Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#include "UnityCG.cginc"

			#pragma vertex mainVS
			#pragma fragment mainFS

			float _CameraRate;

			float _IOR;
			float4 _Color;
			float _Opacity;
			float _Alpha;

			float _RateFresnel;
			float _FixedR;
			float _FixedO;

			sampler2D _Tex0;
			sampler2D _Tex1;
			sampler2D _Tex2;
			sampler2D _Tex3;
			sampler2D _Tex4;
			sampler2D _Tex5;

			struct VS_IN
			{
				float4 pos : POSITION;
			};

			struct VS_OUT
			{
				float4 vertex : SV_POSITION;
				float4 wpos : WORLD_POSITION;
				float4 mpos : MODEL_POSITION;
			};

			struct FS_OUT
			{
				float4 color	: SV_Target;
				float depth : SV_Depth;
			};

			VS_OUT mainVS(VS_IN In)
			{
				VS_OUT Out;
				Out.vertex = UnityObjectToClipPos(In.pos);
				Out.wpos = mul(unity_ObjectToWorld, In.pos);
				Out.mpos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
				return Out;
			}

			float2 P2UVfloat2(float2 p)
			{
				return (p + 1) / 2;
			}

			float4 SampleP1(float3 i)
			{
				i = mul((float3x3)unity_WorldToObject, i);

				float4 refColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, i, 0);
				refColor = float4(DecodeHDR(refColor, unity_SpecCube0_HDR).rgb, 1);

				float4 cColor = 0;

				if (abs(i.x) >= abs(i.y) && abs(i.x) >= abs(i.z)) {
					if (i.x > 0) {
						cColor = tex2D(_Tex1, P2UVfloat2(float2(-i.z, +i.y) / abs(i.x)));
					}
					else {
						cColor = tex2D(_Tex3, P2UVfloat2(float2(+i.z, +i.y) / abs(i.x)));
					}
				}
				else if (abs(i.y) >= abs(i.z)) {
					if (i.y > 0) {
						cColor = tex2D(_Tex5, P2UVfloat2(float2(+i.x, -i.z) / abs(i.y)));
					}
					else {
						cColor = tex2D(_Tex4, P2UVfloat2(float2(+i.x, +i.z) / abs(i.y)));
					}
				}
				else {
					if (i.z > 0) {
						cColor = tex2D(_Tex0, P2UVfloat2(float2(+i.x, +i.y) / abs(i.z)));
					}
					else {
						cColor = tex2D(_Tex2, P2UVfloat2(float2(-i.x, +i.y) / abs(i.z)));
					}
				}

				if (!any(cColor)) return refColor;

				return lerp(refColor, cColor, _CameraRate);
			}

			float FresnelApprox(float3 i, float3 n, float IOR)
			{
				float r = ((1 - (1 / IOR)) * (1 - (1 / IOR))) / ((1 + (1 / IOR)) * (1 + (1 / IOR)));
				return r + (1 - r) * pow(1 - dot(i, n), 5.0);
			}

			bool HitSphere(float3 s_pos, float s_rad, float3 v_pos, float3 v_vec, bool first, out float3 hit_pos, out float hit_dis, out float3 hit_normal)
			{
				float3 d = normalize(v_vec);
				float a = length(d) * length(d);
				float3 s = v_pos - s_pos;
				float b = 2 * dot(s, d);
				float c = length(s) * length(s) - s_rad * s_rad;
				float D = b * b - 4 * a * c;
				if (D < 0) {
					return false;
				}
				float t0 = (-b - sqrt(D)) / (2 * a);
				float t1 = (-b + sqrt(D)) / (2 * a);
				float tmin = min(t0, t1);
				float tmax = max(t0, t1);
				float t = first ? tmin : tmax;
				if (first && tmin < 0) {
					return false;
				}
				hit_pos = v_pos + t * d;
				hit_normal = normalize(hit_pos - s_pos);
				hit_dis = distance(v_pos, hit_pos);
				return true;
			}

			FS_OUT mainFS(VS_OUT i)
			{
				float radius = length(unity_ObjectToWorld[0].xyz) * 0.5f;

				FS_OUT Out;
				Out.color = 0;
				Out.depth = 1;

				float3 EyePos = _WorldSpaceCameraPos;
				float3 v = normalize(i.wpos.xyz - EyePos);
				float3 p = i.wpos.xyz;
				float3 mpos = i.mpos.xyz;
				float3 hit_pos = 0;
				float hit_dis = 0;
				float3 hit_normal = 0;
				float3 ipos[3];
				float3 ivec[3];
				float3 opos[3];
				float3 ovec[3];
				float3 ni[3];
				float3 no[3];

				float ior[3];
				ior[0] = _IOR * 0.997f;
				ior[1] = _IOR * 1.000f;
				ior[2] = _IOR * 1.003f;
				
				bool isHitS;
				isHitS = HitSphere(mpos, radius, p, v, true, hit_pos, hit_dis, hit_normal);

				if (isHitS) {
					
					ni[0] = hit_normal;
					ni[1] = hit_normal;
					ni[2] = hit_normal;
	
					ipos[0] = hit_pos;
					ipos[1] = hit_pos;
					ipos[2] = hit_pos;

					ivec[0] = normalize(refract(v, ni[0], 1 / ior[0]));
					ivec[1] = normalize(refract(v, ni[1], 1 / ior[1]));
					ivec[2] = normalize(refract(v, ni[2], 1 / ior[2]));

					HitSphere(mpos, radius, ipos[0], ivec[0], false, hit_pos, hit_dis, hit_normal);

					no[0] = hit_normal;
					opos[0] = hit_pos;
					
					HitSphere(mpos, radius, ipos[1], ivec[1], false, hit_pos, hit_dis, hit_normal);

					no[1] = hit_normal;
					opos[1] = hit_pos;
					
					HitSphere(mpos, radius, ipos[2], ivec[2], false, hit_pos, hit_dis, hit_normal);

					no[2] = hit_normal;
					opos[2] = hit_pos;
					
					ovec[0] = refract(ivec[0], -no[0], ior[0]);
					ovec[1] = refract(ivec[1], -no[1], ior[1]);
					ovec[2] = refract(ivec[2], -no[2], ior[2]);

					float4 iCol[3];
					iCol[0] = SampleP1(reflect(v, ni[0]));
					iCol[1] = SampleP1(reflect(v, ni[1]));
					iCol[2] = SampleP1(reflect(v, ni[2]));
					float4 oCol[3];
					oCol[0] = SampleP1(opos[0] - mpos + ovec[0]);
					oCol[1] = SampleP1(opos[1] - mpos + ovec[1]);
					oCol[2] = SampleP1(opos[2] - mpos + ovec[2]);
					
					float fresnel[3];
					fresnel[0] = FresnelApprox(normalize(v), normalize(ni[0]), ior[0]);
					fresnel[1] = FresnelApprox(normalize(v), normalize(ni[1]), ior[1]);
					fresnel[2] = FresnelApprox(normalize(v), normalize(ni[2]), ior[2]);
					fresnel[0] *= _RateFresnel;
					fresnel[1] *= _RateFresnel;
					fresnel[2] *= _RateFresnel;
					
					fresnel[0] = saturate(fresnel[0]);
					fresnel[1] = saturate(fresnel[1]);
					fresnel[2] = saturate(fresnel[2]);

					float4 iColFinal = float4(iCol[0].r, iCol[1].g, iCol[2].b, 1);
					float4 oColFinal = float4(oCol[0].r, oCol[1].g, oCol[2].b, 1);
					oColFinal = lerp(oColFinal, _Color, _Opacity);
					float4 fCol = float4(
						lerp(iColFinal.r, oColFinal.r, fresnel[0]), 
						lerp(iColFinal.g, oColFinal.g, fresnel[1]), 
						lerp(iColFinal.b, oColFinal.b, fresnel[2]),
						1 
					);
				
					float4 Col = fCol;
					Col = lerp(Col, iColFinal, _FixedR);
					Col = lerp(Col, oColFinal, _FixedO);
	
					float4 sv_depth = mul(UNITY_MATRIX_VP, float4(ipos[0], 1));
					float h_depth = sv_depth.z / sv_depth.w;

					Out.color = float4(Col.rgb, _Alpha);
					Out.depth = h_depth;
				}
				else {
					discard;
				}
				
				return Out;
			}
			ENDCG
		}
	}
}
