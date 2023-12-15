## DisInfo: a simple information display library for hlsl

This contains HLSL library code to render text based information. This is
something I struggle with so I thought it would be nice to have a simple
abstraction.

Core APIs:
```
// uv: uv coordinates
// box_bounds: the left, right, top, and bottom bounds of the box,
// respectively. Bottom-left is (0,0) and top-right is (1, 1).
// res: the number of columns (width) and rows (height) in the box.
// pos [OUT]: the x, y coordinates of the box.
// box_uv [OUT]: the location we're rendering at, expressed in the box's UV
//     coordinates.
// Returns true iff the UV is pointing within box_bounds.
bool getBoxLoc(float2 uv, float4 box_bounds, int2 res, out int2 pos, out float2 box_uv);

// c: char to render
// pos: x,y coordinates of slot to render in
// res: the resolution of the box.
// box_uv: the UV coordinates of the box we're rendering at, on [0, 1].
float4 renderInBox(char c, int2 pos, int2 res, float2 box_uv);

// Remap a UV onto a smaller domain.
bool remapUVSmaller(float2 uv, float4 bounds, out float2 uvr);

// Remaps a UV onto a larger domain.
bool remapUVBigger(float2 uv, float4 bounds, out float2 uvr);
```

### TODO

1. Line wrapping + "string" interface. Strings could be a vector of chars.
   Maybe use macros to make them look more like strings.

