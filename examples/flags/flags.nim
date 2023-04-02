import tigr

template makeDemoWindow(w, h, flags: int): ptr Tigr =
  window(w, h, "flag tester", flags)

proc drawDemoWindow(win: ptr Tigr) =
  let lineColor {.global.} = RGB(100, 100, 100)
  win.line(0, 0, win.w - 1, win.h - 1, lineColor)
  win.line(0, win.h - 1, win.w - 1, 0, lineColor)
  line(win, 0, 0, win.w, win.h, RGB(200, 10, 10))
  print(win, tfont, 5, 5, RGB(20, 200, 0), "%dx%d", win.w, win.h)

var aaaa:int = 100.cint
type Toggle = tuple
  text: cstring
  checked: int
  value: int
  key: int
  color: TPixel
template mkTg(text: string, b, v: int, k: char, p:TPixel): Toggle =
  (text.cstring,b, v, k.ord, p)

proc drawToggle(bmp: ptr Tigr, toggle: ptr Toggle, x, y, stride: int) =
  var
    height = textHeight(tfont, toggle.text)
    width = textWidth(tfont, toggle.text)

    yOffset = stride div 2
    xOffset = width div -2

  print(bmp, tfont, x + xOffset, y + yOffset, toggle.color, toggle.text)

  yOffset += (if toggle.checked: height else: height div 3)
  var lineColor = toggle.color
  lineColor.a = 240
  bmp.line(x + xOffset, y + yOffset, x + xOffset + width, y + yOffset, lineColor)

# main
var
  flags = 0
  initialW, initialH = 400
  win = makeDemoWindow(initialW, initialH, flags)
  white = RGB(0xff, 0xff, 0xff)
  yellow = RGB(0xff, 0xff, 0)
  black = tigr.RGB(0, 0, 0)
  toggles = [
    mkTg("Key(A)", 0, TIGR_AUTO, 'A', white),
    mkTg("Key(R)ETINA", 0, TIGR_RETINA, 'R', white),
    mkTg("Key(F)ULLSCREEN", 0, TIGR_FULLSCREEN, 'F', white),
    mkTg("Key(2)X", 0, TIGR_2X, '2', yellow),
    mkTg("Key(3)X", 0, TIGR_3X, '3', yellow),
    mkTg("Key(4)X", 0, TIGR_4X, '4', yellow),
    mkTg("Key(N)OCURSOR", 0, TIGR_NOCURSOR, 'N', white),
  ]

while closed(win) == 0 and
  keyDown(win, TK_ESCAPE) == 0:
  win.clear(black)

  win.drawDemoWindow()
  var
    numToggles = toggles.sizeof div toggles[0].sizeof
    stepY = win.h div numToggles
    toggleY = 0
    toggleX = win.w div 2
  block:
    var newFlags = 0
    for i in 0..<numToggles:
      let toggle = toggles[i].addr
      if win.keyDown(toggle.key):
        toggle.checked = toggle.checked xor 1

      newFlags += toggle.checked * toggle.value
      win.drawToggle(toggle, toggleX, toggleY, stepY)
      toggleY += stepY

    if flags != newFlags:
      let
        modeFlags = TIGR_AUTO or TIGR_RETINA
        modeChange = (flags and modeFlags) != (newFlags and modeFlags)
        w = if modeChange: initialW else: win.w
        h = if modeChange: initialH else: win.h
      flags = newFlags
      win.free()
      win = makeDemoWindow(w, h, flags)

  win.update()

win.free()
