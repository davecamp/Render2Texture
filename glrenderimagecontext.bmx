
Strict

Import "renderimagecontextinterface.bmx"
Import "glrenderimage.bmx"

Global glewIsInit:Int

Type TGLRenderImageContext Extends TRenderImageContext
	Field _gc:TGLGraphics
	Field _backbuffer:Int
	Field _width:Int
	Field _height:Int
	Field _renderimages:TList

	Method Delete()
		Destroy()
	EndMethod

	Method Destroy()
		_gc = Null
		If _renderimages
			For Local ri:TGLRenderImage = EachIn _renderimages
				ri.DestroyRenderImage()
			Next
		EndIf
	EndMethod

	Method Create:TGLRenderimageContext(context:TGraphics)
		If Not glewIsInit
			glewInit
			glewIsInit = True
		EndIf

		_renderimages = New TList
		_gc = TGLGraphics(context)
		_width = GraphicsWidth()
		_height = GraphicsHeight()

		' get the backbuffer - usually 0
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, Varptr _backbuffer)
		Return Self
	EndMethod

	Method GraphicsContext:TGraphics()
		Return _gc
	EndMethod

	Method CreateRenderImage:TRenderImage(width:Int, height:Int)
		Local renderimage:TGLRenderImage = New TGLRenderImage.CreateRenderImage(width, height)
		renderimage.Init()
		Return  renderimage
	EndMethod
	
	Method DestroyRenderImage(renderImage:TRenderImage)
		renderImage.DestroyRenderImage()
		_renderImages.Remove(renderImage)
	EndMethod

	Method SetRenderImage(renderimage:TRenderimage)
		If Not renderimage
			glBindFramebuffer GL_FRAMEBUFFER,_backbuffer
		
			glMatrixMode GL_PROJECTION
			glLoadIdentity
			glOrtho 0,_width,_height,0,-1,1
			
			glMatrixMode GL_MODELVIEW
			glLoadIdentity
			glViewport 0,0,_width,_height 
		Else
			renderimage.SetRenderImage()
		EndIf
	EndMethod
EndType
