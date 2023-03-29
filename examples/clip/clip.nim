import tigr

var
  screen = window(320, 240, "Clip", 0)
  c0 = RGB(0x32, 0x32, 0x32)
  c1 = RGB(0xff, 0xff, 0xff)
  c2 = tigr.RGB(0x64, 0xc8, 0x64)
  c3 = tigr.RGBA(0x64, 0x64, 0xc8, 0x96)
  cx, cy, w, d: cint
  iquit = 200

while screen.closed() == 0 and
  screen.keyDown(TK_ESCAPE) == 0 and
  iquit > 0:
  screen.clear(c0)
  cx = screen.w div 2; cy = (screen.h / 2).cint # div:int, /:float
  w = 100; d = 50

  screen.clip(cx - d, cy - d, w, w)
  screen.fill(cx - d, cy - d, w, w, c1)

  screen.rect(cx - w, cy - w, w, w, c2)
  screen.fillRect(cx - w, cy - w, w, w, c3)

  screen.circle(cx + d, cy - d, d, c2)
  screen.fillCircle(cx + d, cy - d, d, c3)
  let
    msg = ("Half a thought is also a thought, " & $iquit).cstring
    tw = tfont.textWidth(msg)
    th = tfont.textHeight(msg)
  screen.print(tfont, cx - tw div 2, cy + d - th div 2, c1, msg)
  screen.update()
  iquit.dec

screen.free()

