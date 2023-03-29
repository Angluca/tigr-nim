import tigr

var screen = window(320, 240, "Hello", 0)
var iquit = 200
while screen.closed() == 0 and
  keyDown(screen, TK_ESCAPE) == 0 and
  iquit > 0:
  screen.clear(RGB(0x80, 0x90, 0xa0))
  screen.print(tfont, 120, 110, tigr.RGB(0xff, 0xff, 0xff), "Test tigr: " & $iquit);
  #update(screen) # OK
  #tigr.update(screen) It's OK too, function in tigr.nim
  screen.update()
  iquit.dec
