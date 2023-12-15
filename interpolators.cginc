#ifndef __INTERPOLATORS_INC__
#define __INTERPOLATORS_INC__

struct appdata
{
  float4 position : POSITION;
  float2 uv : TEXCOORD0;
  float3 normal : NORMAL;
};

struct v2f
{
  float4 position : SV_POSITION;
  float2 uv : TEXCOORD0;
  float3 normal : TEXCOORD1;
  float4 worldPos : TEXCOORD2;

  #if defined(VERTEXLIGHT_ON)
  float3 vertexLightColor : TEXCOORD3;
  #endif
};

#endif  // __INTERPOLATORS_INC__

