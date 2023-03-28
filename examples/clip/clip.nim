import tigr

var
  screen = tigrWindow(320, 240, "Clip", 0)
  c0 = tigrRGB(0x32, 0x32, 0x32)
  c1 = tigrRGB(0xff, 0xff, 0xff)
  c2 = tigrRGB(0x64, 0xc8, 0x64)
  c3 = tigrRGBA(0x64, 0x64, 0xc8, 0x96)
  cx, cy, w, d: cint
  iquit = 200

while tigrClosed(screen) == 0 and
  tigrKeyDown(screen, TK_ESCAPE) == 0 and
  iquit > 0:
  screen.tigrClear(c0)
  cx = screen.w div 2; cy = (screen.h / 2).cint # div:int, /:float
  w = 100; d = 50

  tigrClip(screen, cx - d, cy - d, w, w)
  tigrFill(screen, cx - d, cy - d, w, w, c1)

  screen.tigrRect(cx - w, cy - w, w, w, c2)
  screen.tigrFillRect(cx - w, cy - w, w, w, c3)

  screen.tigrCircle(cx + d, cy - d, d, c2)
  screen.tigrFillCircle(cx + d, cy - d, d, c3)
  let msg = "Half a thought is also a thought, " & $iquit
  let
    tw = tigrTextWidth(tfont, msg)
    th = tigrTextHeight(tfont, msg)
  screen.tigrPrint(tfont, cx - tw div 2, cy + d - th div 2, c1, msg)
  screen.tigrUpdate()
  iquit.dec

tigrFree(screen)

