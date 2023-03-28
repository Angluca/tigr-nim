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
  win1 = tigrWindow(320, 240, "ogl #1", 0)
  win2 = tigrWindow(320, 240, "ogl #2", 0)
while not win1.isNil or not win2.isNil:
  if not win1.isNil:
    tigrClear(win1, tigrRGB(0x80, 0x90, 0xa0))
    tigrPrint(win1, tfont, 120, 110, tigrRGB(0xff, 0xff, 0xff),
              "nimcc code -------------- #1.")
    tigrUpdate(win1)
    if tigrClosed(win1) != 0 or tigrKeyDown(win1, TK_ESCAPE) != 0:
      tigrFree(win1)
      win1 = nil
  if not win2.isNil:
    if tigrBeginOpenGL(win2) != 0:
      test() # glfn: I'm Here !!
    tigrClear(win2, tigrRGBA(0x00, 0x00, 0x00, 0x00))
    tigrPrint(win2, tfont, 120, 110, tigrRGB(0xff, 0xff, 0xff),
              "nimcc code -------------- #2.")
    tigrUpdate(win2)
    if tigrClosed(win2) != 0 or tigrKeyDown(win2, TK_ESCAPE) != 0:
      tigrFree(win2)
      win2 = nil
if not isNil(win1):
  tigrFree(win1)
if not isNil(win2):
  tigrFree(win2)
