
Strict
Framework Brl.StandardIO
Import brl.pngloader
Import "renderimage.bmx"

SetGraphicsDriver D3D9Max2DDriver()
Local gc:TGraphics = Graphics(800, 600)

Local pixmap:TPixmap = LoadPixmap("bmax1.png")
Local rt:TRenderImage = CreateRenderImageFromPixmap(gc, pixmap)

SetClsColor 40, 80, 160

' verify rendering
SetRenderImage(rt)
DrawText(pixmap.width + "," + pixmap.height, 0, 0)

While Not KeyDown(KEY_ESCAPE)	
	' switch back to render to the original backbuffer
	SetRenderImage(Null)
	Cls
	SetColor 255,255,255
	DrawImage(rt,MouseX(),MouseY())
	
	DrawText "Render 2 texture: " + GetGraphicsDriver().ToString(), 0, 0
	
	Flip
Wend
End

