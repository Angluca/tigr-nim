import tigr

var screen = tigr.window(320, 240, "Hello", 0)
var iquit = 200
while screen.closed() == 0 and
  screen.keyDown(TK_ESCAPE) == 0 and
  iquit > 0:
  screen.clear(tigr.RGB(0x80, 0x90, 0xa0))
  screen.print(tfont, 120, 110, tigr.RGB(0xff, 0xff, 0xff), "Hello the world! %d" , iquit);
  # c: tigrUpdate,tigrRGB ... == nim: tigr.update, tigr.RGB ...
  update(screen) # == screen.update() == tigr.update(screen)
  iquit.dec
