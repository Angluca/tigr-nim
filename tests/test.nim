import tigr

var a:int = 100
var b:float = 22.22
var c = "string"
var d:array[3,char] = ['a', 'b', 'c']
let p = cast[cstring](d.addr)
assert c == "string".cstring
assert p == "abc".cstring

echo d
proc test(a:cint, b:cfloat, c:cstring, d:cstring):cint =
  echo "-- test: ", b, a, c, d, " --"
  100.cint
a = test(a,b,c,p)

var screen = window(320, 240, "Hello", 0)
var iquit = 200
while screen.closed() == 0 and
  keyDown(screen, TK_ESCAPE) == 0 and
  iquit > 0:
  screen.clear(RGB(0x80, 0x90, 0xa0))
  let str = ("Test tigr: " & $iquit).cstring
  screen.print(tfont, 120, 110, tigr.RGB(0xff, 0xff, 0xff), str);
  screen.update()
  iquit.dec
