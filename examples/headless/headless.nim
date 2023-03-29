import tigr

var bmp = tigr.bitmap(320, 240);
bmp.clear(RGB(0x80, 0x90, 0xa0))
bmp.print(tfont, 120, 110, RGB(0xff, 0xff, 0xff), "Hello, world.")
echo "is_save = ", saveImage("headless.png", bmp) != 0
bmp.free()
