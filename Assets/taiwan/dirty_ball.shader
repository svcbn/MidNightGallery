// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:1,olmd:1,culm:1,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:3,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:327,x:33126,y:32582,varname:node_327,prsc:2|diff-37-RGB,emission-37-RGB,clip-7228-OUT,voffset-9892-OUT;n:type:ShaderForge.SFN_Tex2d,id:37,x:32077,y:32540,ptovrint:False,ptlb:Main_tex,ptin:_Main_tex,varname:_Main_tex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-628-OUT;n:type:ShaderForge.SFN_Fresnel,id:8410,x:32227,y:32966,varname:node_8410,prsc:2|EXP-9895-OUT;n:type:ShaderForge.SFN_OneMinus,id:1494,x:32403,y:32937,varname:node_1494,prsc:2|IN-8410-OUT;n:type:ShaderForge.SFN_Slider,id:9895,x:31717,y:32971,ptovrint:False,ptlb:node_9895,ptin:_node_9895,varname:_node_9895,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:3;n:type:ShaderForge.SFN_RemapRange,id:7228,x:32601,y:32860,varname:node_7228,prsc:2,frmn:0,frmx:1,tomn:-2,tomx:1|IN-1494-OUT;n:type:ShaderForge.SFN_Tex2d,id:6095,x:32035,y:32784,ptovrint:False,ptlb:depth,ptin:_depth,varname:_depth,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-628-OUT;n:type:ShaderForge.SFN_NormalVector,id:4835,x:32043,y:33193,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:9892,x:32674,y:33063,varname:node_9892,prsc:2|A-1345-OUT,B-1666-OUT,C-5018-OUT;n:type:ShaderForge.SFN_Negate,id:1345,x:32227,y:33170,varname:node_1345,prsc:2|IN-4835-OUT;n:type:ShaderForge.SFN_OneMinus,id:1666,x:32194,y:32784,varname:node_1666,prsc:2|IN-6095-R;n:type:ShaderForge.SFN_Slider,id:5018,x:32401,y:33221,ptovrint:False,ptlb:depth_v,ptin:_depth_v,varname:_depth_v,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.25,max:1;n:type:ShaderForge.SFN_Slider,id:900,x:32797,y:33154,ptovrint:False,ptlb:tes,ptin:_tes,varname:_tes,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:5;n:type:ShaderForge.SFN_TexCoord,id:2503,x:31606,y:32567,varname:node_2503,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_OneMinus,id:4701,x:31746,y:32626,varname:node_4701,prsc:2|IN-2503-U;n:type:ShaderForge.SFN_Append,id:628,x:31907,y:32568,varname:node_628,prsc:2|A-4701-OUT,B-2503-V;proporder:37-9895-6095-5018-900;pass:END;sub:END;*/

Shader "Custom/dirty_ball" {
    Properties {
        _Main_tex ("Main_tex", 2D) = "white" {}
        _node_9895 ("node_9895", Range(0, 3)) = 0
        _depth ("depth", 2D) = "black" {}
        _depth_v ("depth_v", Range(0, 1)) = 0.25
        _tes ("tes", Range(0, 5)) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Front
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            // Dithering function, to use with scene UVs (screen pixel coords)
            // 4x4 Bayer matrix, based on https://en.wikipedia.org/wiki/Ordered_dithering
            float BinaryDither4x4( float value, float2 sceneUVs ) {
                float4x4 mtx = float4x4(
                    float4( 1,  9,  3, 11 )/17.0,
                    float4( 13, 5, 15,  7 )/17.0,
                    float4( 4, 12,  2, 10 )/17.0,
                    float4( 16, 8, 14,  6 )/17.0
                );
                float2 px = floor(_ScreenParams.xy * sceneUVs);
                int xSmp = fmod(px.x,4);
                int ySmp = fmod(px.y,4);
                float4 xVec = 1-saturate(abs(float4(0,1,2,3) - xSmp));
                float4 yVec = 1-saturate(abs(float4(0,1,2,3) - ySmp));
                float4 pxMult = float4( dot(mtx[0],yVec), dot(mtx[1],yVec), dot(mtx[2],yVec), dot(mtx[3],yVec) );
                return round(value + dot(pxMult, xVec));
            }
            uniform sampler2D _Main_tex; uniform float4 _Main_tex_ST;
            uniform float _node_9895;
            uniform sampler2D _depth; uniform float4 _depth_ST;
            uniform float _depth_v;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 projPos : TEXCOORD3;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(-v.normal);
                float2 node_628 = float2((1.0 - o.uv0.r),o.uv0.g);
                float4 _depth_var = tex2Dlod(_depth,float4(TRANSFORM_TEX(node_628, _depth),0.0,0));
                v.vertex.xyz += ((-1*v.normal)*(1.0 - _depth_var.r)*_depth_v);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                clip( BinaryDither4x4(((1.0 - pow(1.0-max(0,dot(normalDirection, viewDirection)),_node_9895))*3.0+-2.0) - 1.5, sceneUVs) );
////// Lighting:
////// Emissive:
                float2 node_628 = float2((1.0 - i.uv0.r),i.uv0.g);
                float4 _Main_tex_var = tex2D(_Main_tex,TRANSFORM_TEX(node_628, _Main_tex));
                float3 emissive = _Main_tex_var.rgb;
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            // Dithering function, to use with scene UVs (screen pixel coords)
            // 4x4 Bayer matrix, based on https://en.wikipedia.org/wiki/Ordered_dithering
            float BinaryDither4x4( float value, float2 sceneUVs ) {
                float4x4 mtx = float4x4(
                    float4( 1,  9,  3, 11 )/17.0,
                    float4( 13, 5, 15,  7 )/17.0,
                    float4( 4, 12,  2, 10 )/17.0,
                    float4( 16, 8, 14,  6 )/17.0
                );
                float2 px = floor(_ScreenParams.xy * sceneUVs);
                int xSmp = fmod(px.x,4);
                int ySmp = fmod(px.y,4);
                float4 xVec = 1-saturate(abs(float4(0,1,2,3) - xSmp));
                float4 yVec = 1-saturate(abs(float4(0,1,2,3) - ySmp));
                float4 pxMult = float4( dot(mtx[0],yVec), dot(mtx[1],yVec), dot(mtx[2],yVec), dot(mtx[3],yVec) );
                return round(value + dot(pxMult, xVec));
            }
            uniform float _node_9895;
            uniform sampler2D _depth; uniform float4 _depth_ST;
            uniform float _depth_v;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
                float3 normalDir : TEXCOORD3;
                float4 projPos : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(-v.normal);
                float2 node_628 = float2((1.0 - o.uv0.r),o.uv0.g);
                float4 _depth_var = tex2Dlod(_depth,float4(TRANSFORM_TEX(node_628, _depth),0.0,0));
                v.vertex.xyz += ((-1*v.normal)*(1.0 - _depth_var.r)*_depth_v);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                clip( BinaryDither4x4(((1.0 - pow(1.0-max(0,dot(normalDirection, viewDirection)),_node_9895))*3.0+-2.0) - 1.5, sceneUVs) );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
