import tigr

var iquit = 600
var screen = tigr.window(320, 240, "Hello", 0)
let fontImage = loadImage("ch.png")
let font = loadFont(fontImage, TCP_UTF32)
while screen.closed() == 0 and
  screen.keyDown(TK_ESCAPE) == 0 and
  iquit > 0:
  screen.clear(tigr.RGB(0x80, 0x90, 0xa0))
  screen.print(tfont, 40, 96, tigr.RGB(0xff, 0xff, 0xff), "Hello the world! %d" , iquit);
  screen.print(font, 40, 110, tigr.RGB(0xff, 0xff, 0xff), r"你好, 让我试试//效果如何哈!!!" , iquit);
  screen.print(font, 40, 120, tigr.RGB(0xff, 0xff, 0xff), r"abcdefg hijklmnopqrstuvwxyzABCDEFG HIJKLMNOPQRSTUVWXYZ" , iquit);
  screen.print(font, 40, 130, tigr.RGB(0xff, 0xff, 0xff), r",./\!@#$%^&*(){}[]-=_+?!!" , iquit);
  # c: tigrUpdate,tigrRGB ... == nim: tigr.update, tigr.RGB ...
  update(screen) # == screen.update() == tigr.update(screen)
  iquit.dec
