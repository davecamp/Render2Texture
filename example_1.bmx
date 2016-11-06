
Strict

Import "renderimage.bmx"

SetGraphicsDriver D3D9Max2DDriver()
Local gc:TGraphics = Graphics(800, 600, 32)
Local rt:TRenderImage = CreateRenderImage(gc, 300, 150)

SetClsColor 40, 80, 160

' render into the texture
SetRenderImage(rt)

Cls
For Local i :Int = 0 To 100
	SetColor Rand(0,255), Rand(0,255), Rand(0,255)
	DrawText("Hey", Rand(0, rt.width-50), Rand(0, rt.height-20))
Next

While Not KeyDown(KEY_ESCAPE)	
	' switch back to render to the original backbuffer
	SetRenderImage(Null)
	Cls
	SetColor 255,255,255
	
	DrawImage(rt),MouseX(),MouseY()
	DrawText "Render 2 texture: " + GetGraphicsDriver().ToString(), 0, 0
	Flip
Wend
End

