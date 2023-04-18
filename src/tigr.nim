##  TIGR - TIny GRaphics Library - v3.0
##         ^^   ^^
##
##  rawr.
##
## This is free and unencumbered software released into the public domain.
##
## Our intent is that anyone is free to copy and use this software,
## for any purpose, in any form, and by any means.
##
## The authors dedicate any and all copyright interest in the software
## to the public domain, at their own expense for the betterment of mankind.
##
## The software is provided "as is", without any kind of warranty, including
## any implied warranty. If it breaks, you get to keep both pieces.
##

##  Compiler configuration.
#{.warning[CStringConv]:off.}
when defined(windows):
  {.passL: "-s -lopengl32 -lgdi32".}
elif defined(macosx):
  {.passL: "-framework OpenGL -framework Cocoa".}
else:
  {.passL: "-s -lGLU -lGL -lX11".}
from strutils import replace
const tigrDir = currentSourcePath.replace("\\", "/")[0..^9]
{.compile: "tigr/tigr.c", passC: "-I" & tigrDir.}
const vim = "tigr/tigr.h"

##  Bitmaps ----------------------------------------------------------------
type
  tcint = cint
  tcuint = cuint
  tcfloat = cfloat
##  This struct contains one pixel.
type
  TPixel* {.importc: "TPixel", header: vim, bycopy.} = object
    r* {.importc: "r".}: byte
    g* {.importc: "g".}: byte
    b* {.importc: "b".}: byte
    a* {.importc: "a".}: byte

##  Window flags.
const
  TIGR_FIXED* = 0
  TIGR_AUTO* = 1
  TIGR_2X* = 2
  TIGR_3X* = 4
  TIGR_4X* = 8
  TIGR_RETINA* = 16
  TIGR_NOCURSOR* = 32
  TIGR_FULLSCREEN* = 64

##  A Tigr bitmap.
type
  Tigr* {.importc: "Tigr", header: vim, bycopy.} = object
    w* {.importc: "w".}: tcint
    h* {.importc: "h".}: tcint
    ##  width/height (unscaled)
    cx* {.importc: "cx".}: tcint
    cy* {.importc: "cy".}: tcint
    cw* {.importc: "cw".}: tcint
    ch* {.importc: "ch".}: tcint
    ##  clip rect
    pix* {.importc: "pix".}: ptr TPixel
    ##  pixel data
    handle* {.importc: "handle".}: pointer
    ##  OS window handle, NULL for off-screen bitmaps.
    blitMode* {.importc: "blitMode".}: tcint
    ##  Target bitmap blit mode

##  Creates a new empty window with a given bitmap size.
##
##  Title is UTF-8.
##
##  In TIGR_FIXED mode, the window is made as large as possible to contain an integer-scaled
##  version of the bitmap while still fitting on the screen. Resizing the window will adapt
##  the scale in integer steps to fit the bitmap.
##
##  In TIGR_AUTO mode, the initial window size is set to the bitmap size times the pixel
##  scale. Resizing the window will resize the bitmap using the specified scale.
##  For example, in forced 2X mode, the window will be twice as wide (and high) as the bitmap.
##
##  Turning on TIGR_RETINA mode will request full backing resolution on OSX, meaning that
##  the effective window size might be integer scaled to a larger size. In TIGR_AUTO mode,
##  this means that the Tigr bitmap will change size if the window is moved between
##  retina and non-retina screens.
##
proc window*(w: tcint; h: tcint; title: cstring; flags: tcint): ptr Tigr {.cdecl, importc: "tigrWindow", header: vim.}

##  Creates an empty off-screen bitmap.
proc bitmap*(w: tcint; h: tcint): ptr Tigr {.cdecl, importc: "tigrBitmap", header: vim.}

##  Deletes a window/bitmap.
proc free*(bmp: ptr Tigr) {.cdecl, importc: "tigrFree", header: vim.}

##  Returns non-zero if the user requested to close a window.
proc closed*(bmp: ptr Tigr): tcint {.cdecl, importc: "tigrClosed", header: vim.}

##  Displays a window's contents on-screen and updates input.
proc update*(bmp: ptr Tigr) {.cdecl, importc: "tigrUpdate", header: vim.}

##  Called before doing direct OpenGL calls and before tigrUpdate.
##  Returns non-zero if OpenGL is available.
proc beginOpenGL*(bmp: ptr Tigr): tcint {.cdecl, importc: "tigrBeginOpenGL", header: vim.}

##  Sets post shader for a window.
##  This replaces the built-in post-FX shader.
proc setPostShader*(bmp: ptr Tigr; code: cstring; size: tcint) {.cdecl, importc: "tigrSetPostShader", header: vim.}

##  Sets post-FX properties for a window.
##
##  The built-in post-FX shader uses the following parameters:
##  p1: hblur - use bilinear filtering along the x-axis (pixels)
##  p2: vblur - use bilinear filtering along the y-axis (pixels)
##  p3: scanlines - CRT scanlines effect (0-1)
##  p4: contrast - contrast boost (1 = no change, 2 = 2X contrast, etc)
proc setPostFX*(bmp: ptr Tigr; p1: tcfloat; p2: tcfloat; p3: tcfloat; p4: tcfloat) {.cdecl, importc: "tigrSetPostFX", header: vim.}

##  Drawing ----------------------------------------------------------------
##  Helper for reading pixels.
##  For high performance, just access bmp->pix directly.
proc get*(bmp: ptr Tigr; x: tcint; y: tcint): TPixel {.cdecl, importc: "tigrGet", header: vim.}

##  Plots a pixel.
##  Clips and blends.
##  For high performance, just access bmp->pix directly.
proc plot*(bmp: ptr Tigr; x: tcint; y: tcint; pix: TPixel) {.cdecl, importc: "tigrPlot", header: vim.}

##  Clears a bitmap to a color.
##  No blending, no clipping.
proc clear*(bmp: ptr Tigr; color: TPixel) {.cdecl, importc: "tigrClear", header: vim.}

##  Fills a rectangular area.
##  No blending, no clipping.
proc fill*(bmp: ptr Tigr; x: tcint; y: tcint; w: tcint; h: tcint; color: TPixel) {.cdecl, importc: "tigrFill", header: vim.}

##  Draws a line.
##  Start pixel is drawn, end pixel is not.
##  Clips and blends.
proc line*(bmp: ptr Tigr; x0: tcint; y0: tcint; x1: tcint; y1: tcint; color: TPixel) {.cdecl, importc: "tigrLine", header: vim.}

##  Draws an empty rectangle.
##  Drawing a 1x1 rectangle yields the same result as calling tigrPlot.
##  Clips and blends.
proc rect*(bmp: ptr Tigr; x: tcint; y: tcint; w: tcint; h: tcint; color: TPixel) {.cdecl, importc: "tigrRect", header: vim.}

##  Fills a rectangle.
##  Fills the inside of the specified rectangular area.
##  Calling tigrRect followed by tigrFillRect using the same arguments
##  causes no overdrawing.
##  Clips and blends.
proc fillRect*(bmp: ptr Tigr; x: tcint; y: tcint; w: tcint; h: tcint; color: TPixel) {.cdecl, importc: "tigrFillRect", header: vim.}

##  Draws a circle.
##  Drawing a zero radius circle yields the same result as calling tigrPlot.
##  Drawing a circle with radius one draws a circle three pixels wide.
##  Clips and blends.
proc circle*(bmp: ptr Tigr; x: tcint; y: tcint; r: tcint; color: TPixel) {.cdecl, importc: "tigrCircle", header: vim.}

##  Fills a circle.
##  Fills the inside of the specified circle.
##  Calling tigrCircle followed by tigrFillCircle using the same arguments
##  causes no overdrawing.
##  Filling a circle with zero radius has no effect.
##  Clips and blends.
proc fillCircle*(bmp: ptr Tigr; x: tcint; y: tcint; r: tcint; color: TPixel) {.cdecl, importc: "tigrFillCircle", header: vim.}

##  Sets clip rect.
##  Set to (0, 0, -1, -1) to reset clipping to full bitmap.
proc clip*(bmp: ptr Tigr; cx: tcint; cy: tcint; cw: tcint; ch: tcint) {.cdecl, importc: "tigrClip", header: vim.}

##  Copies bitmap data.
##  dx/dy = dest co-ordinates
##  sx/sy = source co-ordinates
##  w/h   = width/height
##
##  RGBAdest = RGBAsrc
##  Clips, does not blend.
proc blit*(dest: ptr Tigr; src: ptr Tigr; dx: tcint; dy: tcint; sx: tcint; sy: tcint; w: tcint; h: tcint) {.cdecl, importc: "tigrBlit", header: vim.}

##  Same as tigrBlit, but alpha blends the source bitmap with the
##  target using per pixel alpha and the specified global alpha.
##
##  Ablend = Asrc * alpha
##  RGBdest = RGBsrc * Ablend + RGBdest * (1 - Ablend)
##
##  Blit mode == TIGR_KEEP_ALPHA:
##  Adest = Adest
##
##  Blit mode == TIGR_BLEND_ALPHA:
##  Adest = Asrc * Ablend + Adest * (1 - Ablend)
##  Clips and blends.
proc blitAlpha*(dest: ptr Tigr; src: ptr Tigr; dx: tcint; dy: tcint; sx: tcint; sy: tcint; w: tcint; h: tcint; alpha: tcfloat) {.cdecl, importc: "tigrBlitAlpha", header: vim.}
##  Same as tigrBlit, but tcints the source bitmap with a color
##  and alpha blends the resulting source with the destination.
##
##  Rblend = Rsrc * Rtcint
##  Gblend = Gsrc * Gtcint
##  Bblend = Bsrc * Btcint
##  Ablend = Asrc * Atcint
##
##  RGBdest = RGBblend * Ablend + RGBdest * (1 - Ablend)
##
##  Blit mode == TIGR_KEEP_ALPHA:
##  Adest = Adest
##
##  Blit mode == TIGR_BLEND_ALPHA:
##  Adest = Ablend * Ablend + Adest * (1 - Ablend)
##  Clips and blends.
proc blittcint*(dest: ptr Tigr; src: ptr Tigr; dx: tcint; dy: tcint; sx: tcint; sy: tcint; w: tcint; h: tcint; tcint: TPixel) {.cdecl, importc: "tigrBlittcint", header: vim.}
type
  TIGRBlitMode* {.size: sizeof(tcint).} = enum
    TIGR_KEEP_ALPHA = 0,    ##  Keep destination alpha value
    TIGR_BLEND_ALPHA = 1     ##  Blend destination alpha (default)


##  Set destination bitmap blend mode for blit operations.
proc blitMode*(dest: ptr Tigr; mode: tcint) {.cdecl, importc: "tigrBlitMode", header: vim.}

##  Helper for making colors.
proc RGB*(r: byte; g: byte; b: byte): TPixel {.inline, cdecl, importc: "tigrRGB".}

##  Helper for making colors.
proc RGBA*(r: byte; g: byte; b: byte; a: byte): TPixel {.inline, cdecl, importc: "tigrRGBA".}

##  Font printing ----------------------------------------------------------
type
  TigrGlyph* {.importc: "TigrGlyph", header: vim, bycopy.} = object
    code* {.importc: "code".}: tcint
    x* {.importc: "x".}: tcint
    y* {.importc: "y".}: tcint
    w* {.importc: "w".}: tcint
    h* {.importc: "h".}: tcint

  TigrFont* {.importc: "TigrFont", header: vim, bycopy.} = object
    bitmap* {.importc: "bitmap".}: ptr Tigr
    numGlyphs* {.importc: "numGlyphs".}: tcint
    glyphs* {.importc: "glyphs".}: ptr TigrGlyph

##  Loads a font. The font bitmap should contain all characters
##  for the given codepage, excluding the first 32 control codes.
##  Supported codepages:
##      0    - Regular 7-bit ASCII
##      1252 - Windows 1252
proc loadFont*(bitmap: ptr Tigr; codepage: tcint): ptr TigrFont {.cdecl,
    importc: "tigrLoadFont", header: vim.}

##  Frees a font.
proc freeFont*(font: ptr TigrFont) {.cdecl, importc: "tigrFreeFont", header: vim.}

##  Prints UTF-8 text onto a bitmap.
##  NOTE:
##   This uses the target bitmap blit mode.
##   See tigrBlittcint for details.
proc print*(dest: ptr Tigr; font: ptr TigrFont; x: tcint; y: tcint; color: TPixel; text: cstring) {.varargs, cdecl, importc: "tigrPrint", header: vim.}

##  Returns the width/height of a string.
proc textWidth*(font: ptr TigrFont; text: cstring): tcint {.cdecl,
    importc: "tigrTextWidth", header: vim.}

proc textHeight*(font: ptr TigrFont; text: cstring): tcint {.cdecl,
    importc: "tigrTextHeight", header: vim.}

##  The built-in font.
var tfont* {.header: vim.}: ptr TigrFont

##  User Input -------------------------------------------------------------
##  Key scancodes. For letters/numbers, use ASCII ('A'-'Z' and '0'-'9').
type
  TKey* {.size: sizeof(tcint).} = enum
    TK_PAD0 = 128, TK_PAD1, TK_PAD2, TK_PAD3, TK_PAD4, TK_PAD5, TK_PAD6,
    TK_PAD7, TK_PAD8, TK_PAD9, TK_PADMUL, TK_PADADD, TK_PADENTER, TK_PADSUB,
    TK_PADDOT, TK_PADDIV, TK_F1, TK_F2, TK_F3, TK_F4, TK_F5, TK_F6, TK_F7,
    TK_F8, TK_F9, TK_F10, TK_F11, TK_F12, TK_BACKSPACE, TK_TAB, TK_RETURN,
    TK_SHIFT, TK_CONTROL, TK_ALT, TK_PAUSE, TK_CAPSLOCK, TK_ESCAPE, TK_SPACE,
    TK_PAGEUP, TK_PAGEDN, TK_END, TK_HOME, TK_LEFT, TK_UP, TK_RIGHT, TK_DOWN,
    TK_INSERT, TK_DELETE, TK_LWIN, TK_RWIN, TK_NUMLOCK, TK_SCROLL, TK_LSHIFT,
    TK_RSHIFT, TK_LCONTROL, TK_RCONTROL, TK_LALT, TK_RALT, TK_SEMICOLON,
    TK_EQUALS, TK_COMMA, TK_MINUS, TK_DOT, TK_SLASH, TK_BACKTICK, TK_LSQUARE,
    TK_BACKSLASH, TK_RSQUARE, TK_TICK


##  Returns mouse input for a window.
proc mouse*(bmp: ptr Tigr; x: ptr int; y: ptr int; buttons: ptr int) {.cdecl, importc: "tigrMouse", header: vim.}

type
  TigrTouchPoint* {.importc: "TigrTouchPoint", header: vim, bycopy.} = object
    x* {.importc: "x".}: tcint
    y* {.importc: "y".}: tcint

##  Reads touch input for a window.
##  Returns number of touch points read.
proc touch*(bmp: ptr Tigr; points: ptr TigrTouchPoint; maxPoints: tcint): tcint {.cdecl, importc: "tigrTouch", header: vim.}

##  Reads the keyboard for a window.
##  Returns non-zero if a key is pressed/held.
##  tigrKeyDown tests for the initial press, tigrKeyHeld repeats each frame.
proc keyDown*(bmp: ptr Tigr; key: tcint): tcint {.cdecl, importc: "tigrKeyDown", header: vim.}

proc keyHeld*(bmp: ptr Tigr; key: tcint): tcint {.cdecl, importc: "tigrKeyHeld", header: vim.}

##  Reads character input for a window.
##  Returns the Unicode value of the last key pressed, or 0 if none.
proc readChar*(bmp: ptr Tigr): tcint {.cdecl, importc: "tigrReadChar", header: vim.}

##  Show / hide virtual keyboard.
##  (Only available on iOS / Android)
proc showKeyboard*(show: tcint) {.cdecl, importc: "tigrShowKeyboard", header: vim.}

##  Bitmap I/O -------------------------------------------------------------
##  Loads a PNG, from either a file or memory. (fileName is UTF-8)
##  On error, returns NULL and sets errno.
proc loadImage*(fileName: cstring): ptr Tigr {.cdecl, importc: "tigrLoadImage", header: vim.}

proc loadImageMem*(data: pointer; length: tcint): ptr Tigr {.cdecl,
    importc: "tigrLoadImageMem", header: vim.}

##  Saves a PNG to a file. (fileName is UTF-8)
##  On error, returns zero and sets errno.
proc saveImage*(fileName: cstring; bmp: ptr Tigr): tcint {.cdecl,
    importc: "tigrSaveImage", header: vim.}

##  Helpers ----------------------------------------------------------------
##  Returns the amount of time elapsed since tigrTime was last called,
##  or zero on the first call.
proc time*(): tcfloat {.cdecl, importc: "tigrTime", header: vim.}

##  Displays an error message and quits. (UTF-8)
##  'bmp' can be NULL.
proc error*(bmp: ptr Tigr; message: cstring) {.varargs, cdecl,
    importc: "tigrError", header: vim.}

##  Reads an entire file into memory. (fileName is UTF-8)
##  Free it yourself after with 'free'.
##  On error, returns NULL and sets errno.
##  TIGR will automatically append a NUL terminator byte
##  to the end (not included in the length)
proc readFile*(fileName: cstring; length: ptr int): cstring {.cdecl, importc: "tigrReadFile", header: vim.}

##  Decompresses DEFLATEd zip/zlib data into a buffer.
##  Returns non-zero on success.
proc inflate*(`out`: pointer; outlen: tcuint; `in`: pointer; inlen: tcuint): tcint {.cdecl, importc: "tigrInflate", header: vim.}

##  Decodes a single UTF8 codepoint and returns the next pointer.
proc decodeUTF8*(text: cstring; cp: ptr int): cstring {.cdecl,
    importc: "tigrDecodeUTF8", header: vim.}

##  Encodes a single UTF8 codepoint and returns the next pointer.
proc encodeUTF8*(text: cstring; cp: tcint): cstring {.cdecl, importc: "tigrEncodeUTF8", header: vim.}

# converts
converter n2tcui*(n: SomeNumber|char|enum): tcuint = n.cuint
converter n2tci*(n: SomeNumber|char|enum): tcint = n.cint
converter n2tcf*(n: int): tcfloat = n.cfloat


