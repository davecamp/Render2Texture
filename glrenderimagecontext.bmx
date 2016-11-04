
Strict

Import "renderimagecontextinterface.bmx"
Import "glrenderimage.bmx"

Global glewIsInit:Int

Type TGLRenderImageContext Extends TRenderImageContext
	'Field _d3ddev:IDirect3DDevice9
	Field _backbuffer:Int
	Field _width:Int
	Field _height:Int

	Method Create:TGLRenderimageContext(context:TGraphics)
		If Not glewIsInit
			glewInit
			glewIsInit = True
		EndIf

		_width = GraphicsWidth()
		_height = GraphicsHeight()
		
		' get the backbuffer - usually 0
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, Varptr _backbuffer)
		Return Self
	EndMethod
	
	Method CreateRenderImage:TRenderImage(width:Int, height:Int)
		Local renderimage:TGLRenderImage = New TGLRenderImage.CreateRenderImage(width, height)
		renderimage.Init()
		Return  renderimage
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
