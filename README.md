# TIGR - TIny GRaphics library

![](https://github.com/erkkah/tigr/blob/master/tigr.png)

Copy [erkkah/tigr](https://github.com/erkkah/tigr)  
Use it with nim language :)

TIGR is a tiny cross-platform graphics library,
providing a unified API for Windows, macOS, Linux, iOS and Android.

TIGR's core is a simple framebuffer library.
On top of that, we provide a few helpers for the common tasks that 2D programs generally need:

 - Bitmap-backed windows.
 - Direct access to bitmaps, no locking.
 - Basic drawing helpers (plot, line, blitter).
 - Text output using bitmap fonts.
 - Mouse, touch and keyboard input.
 - PNG loading and saving.
 - Easy pixel shader access.

TIGR is designed to be small and independent.
The 'hello world' example is less than 100kB:

| *Platform* | *Size* |
| --- | --- |
| windows x86_64 | 48k |
| linux x86_64 | 43k |
| macOS arm64 | 90k |
| macOS x86_64 | 74k |

There are no additional libraries to include; everything is baked right into your program.

TIGR is free to copy with no restrictions; see [tigr.nim](tigr.nim).

## How do I program with TIGR?

Here's an example Hello World program. For more information, just read [tigr.nim](tigr.nim) to see the APIs available.

```nim
import tigr

var screen = tigrWindow(320, 240, "Hello", 0)
while tigrClosed(screen) == 0:
  screen.tigrClear(tigrRGB(0x80, 0x90, 0xa0))
  screen.tigrPrint(tfont, 120, 110, tigrRGB(0xff, 0xff, 0xff), "Hello the world!");
  #screen.tigrUpdate() # OOP call it's OK
  tigrUpdate(screen)
```

## How to use TIGR
```bash
# first install and test
nimble install tigr
nimble test
```
### Desktop (Windows, macOS, Linux)
  ...
### Android

Due to the complex lifecycle and packaging of Android apps
(there is no such thing as a single source file Android app),
a tiny wrapper around TIGR is needed. Still - the TIGR API stays the same!

To keep TIGR as tiny and focused as it is, the Android wrapper lives in a separate repo.

To get started on Android, head over to the [TIMOGR](https://github.com/erkkah/timogr) repo and continue there.

### iOS

On iOS, TIGR is implemented as an app delegate, which can be used in your app with just a few lines of code.

Building an iOS app usually requires quite a bit of tinkering in Xcode just to get up and running. To get up and running **fast**, there is an iOS starter project with a completely commandline-based tool chain, and VS Code configurations for debugging.

To get started on iOS, head over to the [TIMOGRiOS](https://github.com/erkkah/timogrios) repo and continue there.

> NOTE: TIGR is included in TIMOGR and TIMOGRiOS, there is no need to install TIGR separately.

## Fonts and shaders

### Custom fonts

TIGR comes with a built-in bitmap font, accessed by the `tfont` variable. Custom fonts can be loaded from bitmaps using `tigrLoadFont`. A font bitmap contains rows of characters separated by same-colored borders. TIGR assumes that the borders use the same color as the top-left pixel in the bitmap. Each character is assumed to be drawn in white on a transparent background to make tinting work.

Use the [tigrfont](https://github.com/erkkah/tigrfont) tool to create your own bitmap fonts from TTF or BDF font files.

### Custom pixel shaders

TIGR uses a built-in pixel shader that provides a couple of stock effects as controlled by `tigrSetPostFX`.
These stock effects can be replaced by calling `tigrSetPostShader` with a custom shader.
The custom shader is in the form of a shader function: `void fxShader(out vec4 color, in vec2 uv)` and has access to the four parameters from `tigrSetPostFX` as a `uniform vec4` called `parameters`.

See the [shader example](examples/shader/shader.nim) for more details.

## Known issues
  ...
