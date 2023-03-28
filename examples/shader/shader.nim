import tigr

const fxShader: cstring = """
  void fxShader(out vec4 color, in vec2 uv) {
     vec2 tex_size = vec2(textureSize(image, 0));
     vec4 c = texture(image, (floor(uv * tex_size) + 0.5 * sin(parameters.x)) / tex_size);
     color = c;
  }
"""

var screen = tigrWindow(320, 240, "Shady", 0)
screen.tigrSetPostShader(fxShader, fxShader.len - 1);
var
  duration = 1.0f
  phase = 0.0f
  iquit = 500
  p: float
while tigrClosed(screen) == 0 and
  tigrKeyDown(screen, TK_ESCAPE) == 0 and
  iquit > 0:
  phase += tigrTime()
  while phase > duration:
    phase -= duration
  p = 6.28 * phase / duration
  screen.tigrSetPostFX(p, 0, 0, 0)
  screen.tigrClear(tigrRGB(0x80, 0x90, 0xa0))
  screen.tigrPrint(tfont, 120, 110, tigrRGB(0xff, 0xff, 0xff), "Shady business: " & $iquit)
  screen.tigrUpdate()
  iquit.dec

screen.tigrFree()
