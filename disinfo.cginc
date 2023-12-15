#ifndef __DISINFO_INC
#define __DISINFO_INC

/*
 * A small font rendering library.
 *
 * Sample usage:
 *
 * fixed4 frag(v2f i) : SV_Target
 * {
 *   float2 uv = i.uv;
 *   int2 cell_pos;
 *   float2 cell_uv;
 *   float2 res = int2(4, 4);
 *   if (!getBoxLoc(uv, 0.1, 0.9, res, cell_pos, cell_uv)) {
 *     return float4(0, 0, 0, 1);
 *   }
 *   float2 duv = float2(ddx(i.uv.x), ddy(i.uv.y)) / 4;
 *   float4 font_color = renderInBox(67, cell_uv, duv);
 * 
 *   return font_color;
 * }
 */

// `_Font` should be an 8x16 (8 rows, 16 columns) grid of monospace ASCII
// glyphs.
Texture2D _Font;
float4 _Font_TexelSize;
SamplerState linear_clamp_sampler;

// Returns false if `uv` does not fall within `bounds`.
bool remapUVSmaller(float2 uv, float2 bottom_left, float2 top_right,
    out float2 uvr) {
  if (!(uv.x > bottom_left.x && uv.x < top_right.x &&
      uv.y > bottom_left.y && uv.y < top_right.y)) {
    return false;
  }

  uvr = uv - bottom_left;
  uvr = uvr / (top_right - bottom_left);

  return true;
}

// bounds: the left/right/top/bottom bounds of the inner UV region,
//     respectively.
// Always returns true.
bool remapUVBigger(float2 uv, float2 bottom_left, float2 top_right,
    out float2 uvr) {
  uvr = uv * (top_right - bottom_left) + bottom_left;

  return true;
}

bool getBoxLoc(float2 uv, float2 bottom_left, float2 top_right,
    int2 res, out int2 cell_pos, out float2 cell_uv)
{
  float2 box_uv;
  if (!remapUVSmaller(uv, bottom_left, top_right, box_uv)) {
    return false;
  }

  // The integer index of the cell pointed to by `uv`, on the interval
  // [0, res.x - 1] * [0, res.y - 1]
  cell_pos = fmod(floor(box_uv * res), res);

  float2 box_sz = 1.0 / float2(res);
  float2 cell_bot_left = cell_pos * box_sz;
  float2 cell_top_right = (cell_pos + 1) * box_sz;
  if (!remapUVSmaller(box_uv, cell_bot_left, cell_top_right, cell_uv)) {
    // This should never happen Clueless
    return false;
  }

  return true;
}

// `c` is a character encoded as ASCII.
// `duv` is float2(ddx(i.uv.x), ddy(i.uv.y)), where `i.uv` is the UV of the
//    object we're rendering on.
float4 renderInBox(int c, float2 cell_uv, float2 duv)
{
  int2 bitmap_res = int2(16, 8);
  int letter_idx = c;
  int2 letter_pos = int2(
      bitmap_res.x - (letter_idx % bitmap_res.x),
      letter_idx / bitmap_res.x);
  letter_pos.x = bitmap_res.x - letter_pos.x;
  letter_pos.y = (bitmap_res.y - 1) - letter_pos.y;
  float2 letter_box_sz = 1.0 / float2(bitmap_res);
  float2 letter_bot_left = letter_pos * letter_box_sz;
  float2 letter_top_right = (letter_pos + 1) * letter_box_sz;
  float2 letter_uv;
  remapUVBigger(cell_uv, letter_bot_left, letter_top_right, letter_uv);

  float4 font_color = _Font.SampleGrad(linear_clamp_sampler, letter_uv, duv.x, duv.y);
  return font_color;
}

#endif  // __DISINFO_INC

