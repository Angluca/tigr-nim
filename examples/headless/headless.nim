import tigr

var bmp = tigrBitmap(320, 240);
bmp.tigrClear(tigrRGB(0x80, 0x90, 0xa0))
bmp.tigrPrint(tfont, 120, 110, tigrRGB(0xff, 0xff, 0xff), "Hello, world.")
echo "is_save = ", tigrSaveImage("headless.png", bmp) != 0
bmp.tigrFree()
