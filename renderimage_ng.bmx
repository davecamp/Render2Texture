
Strict

Import "gl2sdlrenderimagecontext.bmx"

Private
Global _ric:TRenderImageContext
Public

Function CreateRenderImageContext:TRenderImageContext(gc:TGraphics)
	Local max2d:TMax2DGraphics = TMax2DGraphics(gc)

	' sanity check
	Assert max2d <> Null
	If TSDLGraphics(max2d._graphics) Return New TGL2SDLRenderImageContext.Create(max2d)

	Return Null
EndFunction

Function CreateRenderImage:TRenderImage(gc:TGraphics, width:Int, height:Int, UseLinearFlitering:Int = True)
	Local max2d:TMax2DGraphics = TMax2DGraphics(gc)
	If Not max2d Return ' only supports Max2D
	
	If _ric And _ric.GraphicsContext() <> max2d._graphics
		_ric.Destroy()
		_ric = Null
	EndIf
	
	If Not _ric	
		_ric = CreateRenderImageContext(gc)
	EndIf
	
	'sanity check
	?debug
	Assert _ric <> Null, "The code for the current TGraphics instance doesn't exist yet for rendering to a texture, feel free to write one."
	?

	Return _ric.CreateRenderImage(width, height, UseLinearFlitering)
EndFunction

Function DestroyRenderImage(renderImage:TRenderImage)
	' sanity check
	?debug
	Assert _ric <> Null, "No TRenderImage instances have been created"
	?

	_ric.DestroyRenderImage(renderImage)
EndFunction

Function SetRenderImage(renderimage:TRenderImage)
	' sanity check
	?debug
	Assert _ric <> Null, "No TRenderImage instances have been created"
	?

	_ric.SetRenderImage(renderimage)
EndFunction

Function CreatePixmapFromRenderImage:TPixmap(renderimage:TRenderImage)
	' sanity check
	?debug
	Assert _ric <> Null, "No TRenderImage instances have been created"
	?

	Return _ric.CreatePixmapFromRenderImage(renderimage)
EndFunction

Function SetRenderImageViewport(renderimage:TRenderimage, x:Int, y:Int, width:Int, height:Int)
	' sanity check
	?debug
	Assert _ric <> Null, "No TRenderImage instances have been created"
	?

	renderimage.SetViewport(x, y, width, height)
EndFunction

Function CreateRenderImageFromPixmap:TRenderImage(gc:TGraphics, Pixmap:TPixmap, UseLinearFlitering:Int = True)
	Local max2d:TMax2DGraphics = TMax2DGraphics(gc)
	If Not max2d Return ' only supports Max2D
	
	If _ric And _ric.GraphicsContext() <> max2d._graphics
		_ric.Destroy()
		_ric = Null
	EndIf
	
	If Not _ric	_ric = CreateRenderImageContext(gc)
	
	'sanity check
	?debug
	Assert _ric <> Null, "The code for the current TGraphics instance doesn't exist yet for rendering to a texture, feel free to write one."
	Assert Pixmap <> Null, "Invalid pixmap"
	Assert Pixmap.Width <> 0 And Pixmap.Height <> 0, "Invalid pixmap"
	?

	Return _ric.CreateRenderImageFromPixmap(Pixmap, UseLinearFlitering)
EndFunction








