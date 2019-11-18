#include "Lighting.glsl";
#include "PBRUtils02.glsl"

attribute vec4 a_Position;

#ifdef GPU_INSTANCE
	attribute mat4 a_MvpMatrix;
#else
	uniform mat4 u_MvpMatrix;
#endif


#if defined(DIFFUSEMAP)||defined(METALLICGLOSSTEXTURE)||defined(NORMALTEXTURE)||defined(EMISSIONTEXTURE)||defined(OCCLUSIONTEXTURE)||defined(PARALLAXTEXTURE)
	attribute vec2 a_Texcoord0;
	varying vec2 v_Texcoord0;
#endif

#if defined(LIGHTMAP)&&defined(UV1)
	attribute vec2 a_Texcoord1;
#endif

#ifdef LIGHTMAP
	uniform vec4 u_LightmapScaleOffset;
	varying vec2 v_LightMapUV;
#endif

#if defined(INDIRECTLIGHT)&&defined(LOWPLAT)
	uniform vec4 u_SHAr;
	uniform vec4 u_SHAg;
	uniform vec4 u_SHAb;
	uniform vec4 u_SHBr;
	uniform vec4 u_SHBg;
	uniform vec4 u_SHBb;
	uniform vec4 u_SHC;
	varying vec3 v_ambientDiffuse;
#endif

#ifdef BONE
	const int c_MaxBoneCount = 24;
	attribute vec4 a_BoneIndices;
	attribute vec4 a_BoneWeights;
	uniform mat4 u_Bones[c_MaxBoneCount];
#endif

#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(NORMALMAP)||defined(PARALLAXMAP)
	attribute vec3 a_Normal;
	varying vec3 v_Normal; 
#endif

uniform vec3 u_CameraPos;
varying vec3 v_eyeVec;

#if (defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&(defined(NORMALMAP)||defined(PARALLAXMAP))
	attribute vec4 a_Tangent0;
	varying vec3 v_Tangent;
	varying vec3 v_Binormal;
#endif

#ifdef GPU_INSTANCE
	attribute mat4 a_WorldMat;
#else
	uniform mat4 u_WorldMat;
#endif

varying vec3 v_PositionWorld;

varying float v_posViewZ;
#ifdef RECEIVESHADOW
  #ifdef SHADOWMAP_PSSM1 
  varying vec4 v_lightMVPPos;
  uniform mat4 u_lightShadowVP[4];
  #endif
#endif

#ifdef TILINGOFFSET
	uniform vec4 u_TilingOffset;
#endif

void main_castShadow()
{
	vec4 position;
	#ifdef BONE
		mat4 skinTransform = u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
		skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
		skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
		skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
		position=skinTransform*a_Position;
	#else
		position=a_Position;
	#endif
	#ifdef GPU_INSTANCE
		gl_Position = a_MvpMatrix * position;
	#else
		gl_Position = u_MvpMatrix * position;
	#endif
	
	//TODO没考虑UV动画呢
	#if defined(DIFFUSEMAP)&&defined(ALPHATEST)
		v_Texcoord0=a_Texcoord0;
	#endif
	gl_Position=remapGLPositionZ(gl_Position);
	v_posViewZ = gl_Position.z;
}

void main_normal()
{
	vec4 position;
	#ifdef BONE
		mat4 skinTransform = u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
		skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
		skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
		skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
		position=skinTransform*a_Position;
	#else
		position=a_Position;
	#endif
	#ifdef GPU_INSTANCE
		gl_Position = a_MvpMatrix * position;
	#else
		gl_Position = u_MvpMatrix * position;
	#endif
	mat4 worldMat;
	#ifdef GPU_INSTANCE
		worldMat = a_WorldMat;
	#else
		worldMat = u_WorldMat;
	#endif
	v_PositionWorld=(worldMat*position).xyz;
	v_eyeVec =LayaNormalizePerVertexNormal(v_PositionWorld - u_CameraPos);
	#if defined(DIFFUSEMAP)||((defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&(defined(SPECULARMAP)||defined(NORMALMAP)))
		#ifdef TILINGOFFSET
			v_Texcoord0=TransformUV(a_Texcoord0,u_TilingOffset);
		#else
			v_Texcoord0=a_Texcoord0;
		#endif
	#endif

	#ifdef LIGHTMAP
		#ifdef SCALEOFFSETLIGHTINGMAPUV
			#ifdef UV1
				v_LightMapUV=vec2(a_Texcoord1.x,1.0-a_Texcoord1.y)*u_LightmapScaleOffset.xy+u_LightmapScaleOffset.zw;
			#else
				v_LightMapUV=vec2(a_Texcoord0.x,1.0-a_Texcoord0.y)*u_LightmapScaleOffset.xy+u_LightmapScaleOffset.zw;
			#endif 
			v_LightMapUV.y=1.0-v_LightMapUV.y;
		#else
			#ifdef UV1
				v_LightMapUV=a_Texcoord1;
			#else
				v_LightMapUV=a_Texcoord0;
			#endif 
		#endif 
	#endif

	#if (defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))||(defined(NORMALMAP)||defined(PARALLAXMAP))||(defined(INDIRECTLIGHT)&&defined(LOWPLAT))
		mat3 worldInvMat;
		#ifdef BONE
			worldInvMat=inverse(mat3(worldMat*skinTransform));
		#else
			worldInvMat=inverse(mat3(worldMat));
		#endif  
			v_Normal=a_Normal*worldInvMat;
		#if (defined(NORMALMAP)||defined(PARALLAXMAP))
			v_Tangent=a_Tangent0.xyz*worldInvMat;
			v_Binormal=cross(v_Normal,v_Tangent)*a_Tangent0.w;
		#endif
	#endif
	//缺高差图TODO

	#if defined(INDIRECTLIGHT)&&defined(LOWPLAT)
		v_ambientDiffuse = LayaVertexGI(v_Normal);
	#endif


}
void main()
{
	#ifdef CASTSHADOW
		main_castShadow();
	#else
		main_normal();
	#endif

	gl_Position = u_MvpMatrix * a_Position;
	gl_Position=remapGLPositionZ(gl_Position);
}