import tigr

# Lazy write nim func bind gl header, So run c code :)
{.emit: """
#include <stdlib.h>
#ifdef _WIN32
#include <winsock2.h>
#include <GL/gl.h>
#elif defined __linux__
#include <GL/gl.h>
#else
#define GL_SILENCE_DEPRECATION
#include <OpenGL/gl3.h>
#endif

NIM_EXTERNC
void test(){
    glClearColor(1, 0, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
}
""".}
proc test() {.importc:"$1".}

var
  win1 = window(320, 240, "ogl #1", 0)
  win2 = tigr.window(320, 240, "ogl #2", 0)
while not win1.isNil or not win2.isNil:
  if not win1.isNil:
    win1.clear(RGB(0x80, 0x90, 0xa0))
    win1.print(tfont, 120, 110, RGB(0xff, 0xff, 0xff),
              "nimcc code -------------- #1.")
    win1.update()
    if win1.closed() != 0 or win1.keyDown(TK_ESCAPE) != 0:
      win1.free()
      win1 = nil
  if not win2.isNil:
    if win2.beginOpenGL() != 0:
      test() # glfn: I'm Here !!
    win2.clear(RGBA(0x00, 0x00, 0x00, 0x00))
    win2.print(tfont, 120, 110, RGB(0xff, 0xff, 0xff),
              "nimcc code -------------- #2.")
    win2.update()
    if win2.closed() != 0 or win2.keyDown(TK_ESCAPE) != 0:
      win2.free()
      win2 = nil
if not win1.isNil():
  win1.free()
if not win2.isNil():
  win2.free()
