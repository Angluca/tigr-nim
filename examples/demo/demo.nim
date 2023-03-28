import tigr, math, system/ansi_c

var
  playerx = 160f
  playery = 200'f
  playerxs, playerys: float
  standing = true
  remaining: float
  backdrop, screen: ptr Tigr

proc Update(dt: float) =
  if remaining > 0:
    remaining -= dt

  # Read the keyboard and move the player.
  if standing and (tigrKeyDown(screen, TK_SPACE) != 0):
    playerys -= 200
  if screen.tigrKeyDown(TK_LEFT)!=0 or tigrKeyHeld(screen, 'A'.ord)!=0:
    playerxs -= 10
  if screen.tigrKeyDown(TK_RIGHT)!=0 or tigrKeyHeld(screen, 'D'.ord)!=0:
    playerxs += 10

  var oldx = playerx; var oldy = playery

  # Apply simply physics.
  playerxs *= exp(-10f * dt)
  playerys *= exp(-2f * dt)
  playerys += dt * 200f
  playerx += dt * playerxs
  playery += dt * playerys

  # Apply collision
  if playerx.int < 8:
    playerx = 8f; playerxs = 0f

  if playerx.int > screen.w - 8:
    playerx = screen.w.float - 8
    playerxs = 0

  # Apply playfield collision and stepping.
  var
    dx = (playerx - oldx) / 10
    dy = (playery - oldy) / 10
  standing = false
  for i in 0..<10:
    var p = tigrGet(backdrop, oldx.cint, oldy.cint - 1)
    if p.r == 0 and p.g == 0 and p.b == 0:
      oldy -= 1
    p = tigrGet(backdrop, oldx.cint, oldy.cint)
    if p.r == 0 and p.g == 0 and p.b == 0 and playerys > 0:
      standing = true
      playerys = 0
      dy = 0
    oldx += dx
    oldy += dy

  playerx = oldx
  playery = oldy

proc main() =
  # Load out sprite
  let squinkle = tigrLoadImage("squinkle.png")
  if squinkle.isNil: tigrError(nil, "Cant load squinkle.png")

  # Load some UTF8 text
  let greeting = cast[cstring](tigrReadFile("greeting.txt", nil))
  if greeting.isNil: tigrError(nil, "Cant load greeting.txt")

  # Make a window and an off-screen backdrop
  screen = tigrWindow(320, 240, greeting, TIGR_2X)
  backdrop = tigrBitmap(screen.w, screen.h)

  # Fill in the background
  tigrClear(backdrop, tigrRGB(80, 180, 255))
  tigrFill(backdrop, 0, 200, 320, 40, tigrRGB(60, 120, 60))
  tigrFill(backdrop, 0, 200, 320, 3, tigrRGB(0, 0, 0))
  tigrLine(backdrop, 0, 201, 320, 201, tigrRGB(0xff, 0xff, 0xff))

  # Enable post fx
  screen.tigrSetPostFX(1, 1, 1, 2f)

  # Maintain a list of characters entered.
  var chars: array[16, char]
  c_memset(chars[0].addr, '_'.cint, 16)
  var
    dt: float
    x, y, b: cint
    prevx, prevy, prev: cint

  # Repeat till they close the window.
  while tigrClosed(screen) == 0 and
  tigrKeyDown(screen, TK_ESCAPE) == 0:
    # Update game
    dt = tigrTime()
    Update(dt)

    # Read the mouse and draw when pressed.
    screen.tigrMouse(x.addr, y.addr, b.addr)
    if (b and 1) > 0:
      if prev != 0:
        tigrLine(backdrop, prevx, prevy, x, y, tigrRGB(0, 0, 0))
      prevx = x; prevy = y; prev = 1
    else: prev = 0

    # Composite the backdrop and sprite onto the screen.
    screen.tigrBlit(backdrop, 0, 0, 0, 0, backdrop.w, backdrop.h)
    screen.tigrBlitAlpha(squinkle, playerx.cint - squinkle.w div 2, playery.cint - squinkle.h, 0, 0, squinkle.w, squinkle.h, 1.0f)
    screen.tigrPrint(tfont, 10, 10, tigrRGBA(0xc0, 0xd0, 0xff, 0xc0), greeting)
    screen.tigrPrint(tfont, 10, 222, tigrRGBA(0xff, 0xff, 0xff, 0xff), "A D + SPACE")

    #Grab any chars and add them to our buffer.
    while true:
      let c = screen.tigrReadChar()
      if c == 0: break
      for n in 1..<16:
        chars[n - 1] = chars[n]
      chars[15] = c.chr

    # Print out the character buffer too.
    var
      tmp {.global.} : array[100, char]
      p = cast[cstring](tmp[0].addr)
    for n in 0..<16:
      p = tigrEncodeUTF8(p, chars[n].cint)
    screen.tigrPrint(tfont, 160, 222, tigrRGB(0xff, 0xff, 0xff), "Chars: %s", tmp[0].addr)
    zeroMem(tmp[0].addr, tmp.sizeof)

    # Update the window
    screen.tigrUpdate()

  tigrFree(squinkle)
  tigrFree(backdrop)
  tigrFree(screen)

try:
  main()
except CatchableError as e:
  echo "Error: ", e.repr
finally:
  echo "Exit game"

