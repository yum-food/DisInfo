#ifndef DISINFO_LIGHTING
#define DISINFO_LIGHTING

#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"

#include "interpolators.cginc"
#include "disinfo.cginc"

void getVertexLightColor(inout v2f i)
{
  #if defined(VERTEXLIGHT_ON)
  i.vertexLightColor = Shade4PointLights(
    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
    unity_LightColor[0].rgb,
    unity_LightColor[1].rgb,
    unity_LightColor[2].rgb,
    unity_LightColor[3].rgb,
    unity_4LightAtten0, i.worldPos, i.normal
  );
  #endif
}

v2f vert(appdata v)
{
  v2f o;
  o.position = UnityObjectToClipPos(v.position);
  o.worldPos = mul(unity_ObjectToWorld, v.position);
  o.normal = UnityObjectToWorldNormal(v.normal);

  o.uv = v.uv;
  getVertexLightColor(o);

  return o;
}

fixed4 frag(v2f i) : SV_Target
{
  float2 uv = i.uv;
  int2 cell_pos;
  float2 cell_uv;
  if (!getBoxLoc(uv, 0.1, 0.9, /*res=*/int2(4,4), cell_pos, cell_uv)) {
    return float4(0, 0, 0, 1);
  }
  float2 duv = float2(ddx(i.uv.x), ddy(i.uv.y)) / 4;
  float4 font_color = renderInBox(67, cell_uv, duv);

  return font_color;
}

#endif  // DISINFO_LIGHTING

