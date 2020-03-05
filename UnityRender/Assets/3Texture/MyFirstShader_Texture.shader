﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/MF_Texture"
{
	Properties{
	 /*cg变量 面板名称  类型    对应类型默认值*/
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("MainTex", 2D) = "black" {}
	}

	SubShader{

		Pass{
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"
			
			float4		_Tint;
			sampler2D	_MainTex;
			float4		_MainTex_ST;

			struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct Interpolators{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolators MyVertexProgram (VertexData v){
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;//先不转换空间
				//i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				return tex2D(_MainTex, i.uv) * _Tint;
			}

			ENDCG
		}
	}
}