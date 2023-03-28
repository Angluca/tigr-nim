import tigr
var screen = tigrWindow(320, 240, "Hello", 0)
var iquit = 200
while tigrClosed(screen) == 0 and
  tigrKeyDown(screen, TK_ESCAPE) == 0 and
  iquit > 0:
  screen.tigrClear(tigrRGB(0x80, 0x90, 0xa0))
  screen.tigrPrint(tfont, 120, 110, tigrRGB(0xff, 0xff, 0xff), "Test tigr: " & $iquit);
  screen.tigrUpdate()
  iquit.dec
