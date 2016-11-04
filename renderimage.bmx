
Strict

Import "glrenderimagecontext.bmx"

?win32
Import "d3d9renderimagecontext.bmx"
Import "d3d11renderimagecontext.bmx"
?

Global _ric:TRenderImageContext

Function CreateRenderImageContext:TRenderImageContext(gc:TGraphics)
	Local max2d:TMax2DGraphics = TMax2DGraphics(gc)
	
	' sanity check
	?debug
	Assert max2d <> Null
	?

	?win32
	If TD3D9Graphics(max2d._graphics) Return New TD3D9RenderImageContext.Create(max2d._graphics)
	If TD3D11Graphics(max2d._graphics) Return New TD3D11RenderImageContext.Create(max2d._graphics)
	?
	If TGLGraphics(max2d._graphics) Return New TGLRenderImageContext.Create(max2d._graphics)
	
	Return Null
EndFunction

Function CreateRenderImage:TRenderImage(gc:TGraphics, width:Int, height:Int)
	If Not _ric _ric = CreateRenderImageContext(gc)
	Return _ric.CreateRenderImage(width, height)
EndFunction

Function SetRenderImage(renderimage:TRenderImage)
	' sanity check
	?debug
	Assert _ric <> Null, "No TRenderImage instances have been created"
	?

	_ric.SetRenderImage(renderimage)
EndFunction

