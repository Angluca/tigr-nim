import tigr

template makeDemoWindow(w, h, flags: cint): ptr Tigr =
  tigrWindow(w, h, "flag tester", flags)

proc drawDemoWindow(win: ptr Tigr) =
  let lineColor {.global.} = tigrRGB(100, 100, 100)
  win.tigrLine(0, 0, win.w - 1, win.h - 1, lineColor)
  win.tigrLine(0, win.h - 1, win.w - 1, 0, lineColor)
  tigrLine(win, 0, 0, win.w, win.h, tigrRGB(200, 10, 10))
  tigrPrint(win, tfont, 5, 5, tigrRGB(20, 200, 0), "%dx%d", win.w, win.h)

type Toggle = tuple
  text: cstring
  checked: cint
  value: cint
  key: cint
  color: TPixel
template mkTg(text: string, b, v: int, k: char, p:TPixel): Toggle =
  (text.cstring,b.cint, v.cint, k.cint, p)

proc drawToggle(bmp: ptr Tigr, toggle: ptr Toggle, x, y, stride: cint) =
  var
    height = tigrTextHeight(tfont, toggle.text)
    width = tigrTextWidth(tfont, toggle.text)

    yOffset = stride div 2
    xOffset = width div -2

  tigrPrint(bmp, tfont, x + xOffset, y + yOffset, toggle.color, toggle.text)

  yOffset += (if toggle.checked != 0: height else: height div 3)
  var lineColor = toggle.color
  lineColor.a = 240
  bmp.tigrLine(x + xOffset, y + yOffset, x + xOffset + width, y + yOffset, lineColor)

# main
var
  flags = 0.cint
  initialW, initialH: cint = 400
  win = makeDemoWindow(initialW, initialH, flags)
  white = tigrRGB(0xff, 0xff, 0xff)
  yellow = tigrRGB(0xff, 0xff, 0)
  black = tigrRGB(0, 0, 0)
  toggles = [
    mkTg("Key(A)", 0, TIGR_AUTO, 'A', white),
    mkTg("Key(R)ETINA", 0, TIGR_RETINA, 'R', white),
    mkTg("Key(F)ULLSCREEN", 0, TIGR_FULLSCREEN, 'F', white),
    mkTg("Key(2)X", 0, TIGR_2X, '2', yellow),
    mkTg("Key(3)X", 0, TIGR_3X, '3', yellow),
    mkTg("Key(4)X", 0, TIGR_4X, '4', yellow),
    mkTg("Key(N)OCURSOR", 0, TIGR_NOCURSOR, 'N', white),
  ]

while tigrClosed(win) == 0 and
  tigrKeyDown(win, TK_ESCAPE) == 0:
  win.tigrClear(black)

  win.drawDemoWindow()
  var
    numToggles = toggles.sizeof div toggles[0].sizeof
    stepY = win.h div numToggles.cint
    toggleY: cint
    toggleX = win.w div 2
  block:
    var newFlags: cint
    for i in 0..<numToggles:
      let toggle = toggles[i].addr
      if win.tigrKeyDown(toggle.key) != 0:
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
      win.tigrFree()
      win = makeDemoWindow(w, h, flags)

  win.tigrUpdate()

win.tigrFree()
