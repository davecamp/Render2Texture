
Strict

Import SDL.SDLGraphics
Import sdl.gl2sdlmax2d
Import pub.glew
Import "renderimageinterface.bmx"

Type TGL2SDLRenderImageFrame Extends TGLImageFrame
	Field _fbo:Int
	
	Method Delete()
		DeleteFramebuffer
	EndMethod
	
	Method DeleteFramebuffer()
		If _fbo
			glDeleteFramebuffers(1, Varptr _fbo)
			_fbo = -1 '???
		EndIf
	EndMethod
	
	Method CreateRenderTarget:TGL2SDLRenderImageFrame(width, height, UseImageFiltering:Int, pixmap:TPixmap)
		If pixmap pixmap = ConvertPixmap(pixmap, PF_RGBA)
		
		glDisable(GL_SCISSOR_TEST)

		glGenTextures(1, Varptr name)
		glBindTexture(GL_TEXTURE_2D, name)
		If pixmap
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixmap.pixels)
		Else
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
		EndIf

		If UseImageFiltering
			glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR
			glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR
		Else
			glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST
			glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST
		EndIf
		
		glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE
		glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE
		
		glGenFramebuffers(1,Varptr _fbo)
		glBindFramebuffer GL_FRAMEBUFFER,_fbo

		glBindTexture GL_TEXTURE_2D,name
		glFramebufferTexture2D GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,name,0

		If Not pixmap
			' set and clear to a default colour
			glClearColor 0, 0, 0, 0
			glClear(GL_COLOR_BUFFER_BIT)
		EndIf

		uscale = 1.0 / width
		vscale = 1.0 / height

		Return Self
	EndMethod
	
	Method DestroyRenderTarget()
		DeleteFramebuffer()
	EndMethod
	
	Method ToPixmap:TPixmap(width:Int, height:Int)
		Local prevTexture:Int
		Local prevFBO:Int
		
		glGetIntegerv(GL_TEXTURE_BINDING_2D,Varptr prevTexture)
		glBindTexture(GL_TEXTURE_2D,name)

		Local pixmap:TPixmap = CreatePixmap(width, height, PF_RGBA8888)		
		glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixmap.pixels)
		
		glBindTexture(GL_TEXTURE_2D,prevTexture)
				
		Return pixmap
	EndMethod
EndType

Type TGL2SDLRenderImage Extends TRenderImage
	'Field _matrix:Float[16]
	Field _matrix:TMatrix
	Field _driver:TGL2Max2DDriver

	Method CreateRenderImage:TGL2SDLRenderImage(width:Int, height:Int)
		Self.width = width	' TImage.width
		Self.height = height	' TImage.height

		Return Self
	EndMethod
	
	Method DestroyRenderImage()
		TGL2SDLRenderImageFrame(frames[0]).DestroyRenderTarget()
	EndMethod
	
	Method Init(max2d:TMax2DGraphics, UseImageFiltering:Int, pixmap:TPixmap)
		_driver = TGL2Max2DDriver(max2d._driver)
		_matrix = New TMatrix
	
		'_matrix.SetOrthographic( 0, width, 0, height, -1, 1 )
		_matrix.SetOrthographic( 0, width, height, 0, -1, 1 )
	
		Local prevFBO:Int
		Local prevTexture:Int
		Local prevScissorTest:Int

		glGetIntegerv(GL_FRAMEBUFFER_BINDING, Varptr prevFBO)
		glGetIntegerv(GL_TEXTURE_BINDING_2D,Varptr prevTexture)
		glGetIntegerv(GL_SCISSOR_TEST, Varptr prevScissorTest)
		
		frames = New TGL2SDLRenderImageFrame[1]
		frames[0] = New TGL2SDLRenderImageFrame.CreateRenderTarget(width, height, UseImageFiltering, pixmap)
		
		If prevScissorTest glEnable(GL_SCISSOR_TEST)
		glBindTexture GL_TEXTURE_2D,prevTexture
		glBindFramebuffer GL_FRAMEBUFFER,prevFBO
	EndMethod

	Method Frame:TImageFrame(index=0)
		Return frames[0]
	EndMethod
	
	Method SetRenderImage()
		glBindFrameBuffer(GL_FRAMEBUFFER, TGL2SDLRenderImageFrame(frames[0])._fbo)
		_driver.u_pmatrix = _matrix
		glViewport 0,0,width,height 
	EndMethod
	
	Method ToPixmap:TPixmap()
		Return TGL2SDLRenderImageFrame(frames[0]).ToPixmap(width, height)
	EndMethod
	
	Method SetViewport(x:Int, y:Int, width:Int, height)
		If x = 0 And y = 0 And width = Self.width And height = Self.height
			glDisable GL_SCISSOR_TEST
		Else
			glEnable GL_SCISSOR_TEST
			glScissor x, y, width, height
		EndIf
	EndMethod
EndType

