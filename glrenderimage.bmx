
Strict

Import "renderimageinterface.bmx"

Type TGLRenderImageFrame Extends TGLImageFrame
	Field _fbo:Int
	
	Method Delete()
		glDeleteFramebuffers 1, Varptr _fbo
	EndMethod
	
	Method CreateRenderTarget:TGLRenderImageFrame(width, height)
		Local prevFBO:Int
		Local prevTexture:Int
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, Varptr prevFBO)
		glGetIntegerv(GL_TEXTURE_2D,Varptr prevTexture)
		
		glGenTextures 1, Varptr name
		glBindTexture GL_TEXTURE_2D,name
		glTexImage2D GL_TEXTURE_2D,0,GL_RGBA8,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,Null

		glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE
		glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE
		glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR
		glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR

		glGenFramebuffers(1,Varptr _fbo)
		glBindFramebuffer GL_FRAMEBUFFER,_fbo

		glBindTexture GL_TEXTURE_2D,name
		glFramebufferTexture2D GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,name,0

		' set and clear to a default colour
		glClearColor 0, 0, 0, 0
		glClear(GL_COLOR_BUFFER_BIT)

		uscale = 1.0 / width
		vscale = 1.0 / height

		glBindTexture GL_TEXTURE_2D,prevTexture
		glBindFramebuffer GL_FRAMEBUFFER,prevFBO

		Return Self
	EndMethod
EndType

Type TGLRenderImage Extends TRenderImage
	Field _matrix:Float[]

	Method CreateRenderImage:TGLRenderImage(width:Int ,height:Int)
		Self.width = width		' TImage.width
		Self.height = height	' TImage.height

		Return Self
	EndMethod
	
	Method Init()
		frames = New TGLRenderImageFrame[1]
		frames[0] = New TGLRenderImageFrame.CreateRenderTarget(width, height)
	EndMethod

	Method Frame:TImageFrame(index=0)
		Return frames[0]
	EndMethod
	
	Method SetRenderImage()
		glBindFrameBuffer GL_FRAMEBUFFER, TGLRenderImageFrame(frames[0])._fbo

		glMatrixMode GL_PROJECTION
		glLoadIdentity
		glOrtho 0,width,0,height,-1,1
		glMatrixMode GL_MODELVIEW
	
		glViewport 0,0,width,height 
	EndMethod
EndType





