# Package
version       = "1.0"
author        = "Angluca"
description   = "TIGR is a tiny cross-platform graphics library, providing a unified API for Windows, macOS, Linux, iOS and Android."
license       = "MIT"
srcDir        = "src"
installExt = @["nim","c","h"]

# Dependencies
requires "nim >= 0.20.0"
taskRequires "test", "opengl"

task test, "Runs the test suite":
  exec "nim c -r tests/tester.nim"
  exec "nim c -r examples/headless/headless.nim"
  exec "nim c -r examples/hello/hello.nim"
  exec "nim c -r examples/clip/clip.nim"
  exec "nim c -r examples/shader/shader.nim"
  exec "nim c -r examples/opengl/oglc.nim"
  exec "nim c -r examples/flags/flags.nim"
  withDir "examples/demo/":
    exec "nim c -r demo.nim"
