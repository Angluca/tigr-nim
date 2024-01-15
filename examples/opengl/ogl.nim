import tigr
import opengl
# nimble install opengl

var
  win1 = window(320, 240, "ogl #1", 0)
  win2 = window(320, 240, "ogl #2", 0)
while not win1.isNil or not win2.isNil:
  if not win1.isNil:
    win1.clear(RGB(0x80, 0x90, 0xa0))
    win1.print(tfont, 80, 110, RGB(0xff, 0xff, 0xff),
              "nim code -------------- #1.")
    win1.update()
    if win1.closed()!=0 or win1.keyDown(TK_ESCAPE)!=0:
      win1.free()
      win1 = nil
  if not win2.isNil:
    if win2.beginOpenGL()!=0:
      glClearColor(1.0, 0.0, 1.0, 10.0);
      glClear(GL_COLOR_BUFFER_BIT);
    win2.clear(RGBA(0x00, 0x00, 0x00, 0x00))
    win2.print(tfont, 80, 110, RGB(0xff, 0xff, 0xff),
              "nim code -------------- #2.")
    win2.update()
    if win2.closed()!=0 or win2.keyDown(TK_ESCAPE)!=0:
      win2.free()
      win2 = nil
if not win1.isNil():
  win1.free()
if not win2.isNil():
  win2.free()
