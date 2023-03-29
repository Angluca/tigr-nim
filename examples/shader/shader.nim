import tigr

const fxShader: cstring = """
  void fxShader(out vec4 color, in vec2 uv) {
     vec2 tex_size = vec2(textureSize(image, 0));
     vec4 c = texture(image, (floor(uv * tex_size) + 0.5 * sin(parameters.x)) / tex_size);
     color = c;
  }
"""

var screen = window(320, 240, "Shady", 0)
screen.setPostShader(fxShader, fxShader.len - 1);
var
  duration = 1.0f
  phase = 0.0f
  iquit = 500
  p: float
while screen.closed() == 0 and
  screen.keyDown(TK_ESCAPE) == 0 and
  iquit > 0:
  phase += tigr.time()
  while phase > duration:
    phase -= duration
  p = 6.28 * phase / duration
  screen.setPostFX(p, 0, 0, 0)
  screen.clear(RGB(0x80, 0x90, 0xa0))
  screen.print(tfont, 120, 110, RGB(0xff, 0xff, 0xff), ("Shady business: " & $iquit).cstring)
  screen.update()
  iquit.dec

screen.free()
