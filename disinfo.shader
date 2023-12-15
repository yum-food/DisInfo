Shader "yum_food/disinfo"
{
  Properties
  {
    _Font("Font", 2D) = "black" {}
  }
  SubShader
  {
    Pass {
      Tags {
        "RenderType"="Opaque"
        "Queue"="AlphaTest+499"
        "LightMode" = "ForwardBase"
      }
      Blend SrcAlpha OneMinusSrcAlpha
      Cull Back
      ZTest LEqual

      CGPROGRAM
      #pragma target 5.0

      #pragma multi_compile _ VERTEXLIGHT_ON

      #pragma vertex vert
      #pragma fragment frag

      #define FORWARD_BASE_PASS

      #include "disinfo_lighting.cginc"
      ENDCG
    }
    Pass {
      Tags {
        "RenderType" = "Opaque"
        "LightMode" = "ForwardAdd"
        "Queue"="AlphaTest+499"
      }
      Blend One One
      Cull Back
      ZTest LEqual

      CGPROGRAM
      #pragma target 5.0

      #pragma multi_compile_fwdadd

      #pragma vertex vert
      #pragma fragment frag

      #include "disinfo_lighting.cginc"
      ENDCG
    }
  }
  //CustomEditor "TaSTTShaderGUI"
}
