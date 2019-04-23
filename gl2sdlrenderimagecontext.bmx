
Strict

Import "renderimagecontextinterface.bmx"
Import "gl2sdlrenderimage.bmx"

Global glewIsInit:Int

Type TGL2SDLRenderImageContext Extends TRenderImageContext
	Field _max2d:TMax2DGraphics
	Field _gc:TGraphics
	Field _backbuffer:Int
	Field _width:Int
	Field _height:Int
	Field _renderimages:TList
	
	Field _matrix:TMatrix

	Method Delete()
		Destroy()
	EndMethod

	Method Destroy()
		_max2d = Null
		_gc = Null

		If _renderimages
			For Local ri:TGL2SDLRenderImage = EachIn _renderimages
				ri.DestroyRenderImage()
			Next
		EndIf
	EndMethod

	Method Create:TGL2SDLRenderimageContext(max2d:TMax2DGraphics)
		If Not glewIsInit
			glewInit
			glewIsInit = True
		EndIf

		_renderimages = New TList
		_max2d = max2d
		_gc = max2d._graphics
		
		_width = GraphicsWidth()
		_height = GraphicsHeight()

		' get the backbuffer - usually 0
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, Varptr _backbuffer)
		
		'glGetFloatv(GL_PROJECTION_MATRIX, _matrix)
		Local driver:TGL2Max2DDriver = TGL2Max2DDriver(_max2d._driver)
		_matrix = driver.u_pmatrix
		
		Return Self
	EndMethod

	Method GraphicsContext:TGraphics()
		Return _gc
	EndMethod

	Method CreateRenderImage:TRenderImage(width:Int, height:Int, UseImageFiltering:Int)
		Local renderimage:TGL2SDLRenderImage = New TGL2SDLRenderImage.CreateRenderImage(width, height)
		renderimage.Init(_max2d, UseImageFiltering, Null)
		Return  renderimage
	EndMethod
	
	Method CreateRenderImageFromPixmap:TRenderImage(pixmap:TPixmap, UseImageFiltering:Int)
		Local renderimage:TGL2SDLRenderImage = New TGL2SDLRenderImage.CreateRenderImage(pixmap.width, pixmap.height)
		renderimage.Init(_max2d,UseImageFiltering, pixmap)
		Return  renderimage
	EndMethod
	
	Method DestroyRenderImage(renderImage:TRenderImage)
		renderImage.DestroyRenderImage()
		_renderImages.Remove(renderImage)
	EndMethod

	Method SetRenderImage(renderimage:TRenderimage)
		Local driver:TGL2Max2DDriver = TGL2Max2DDriver(_max2d._driver)
		driver.Flush()
			
		If Not renderimage
			glBindFramebuffer(GL_FRAMEBUFFER,_backbuffer)
		
			TGL2Max2DDriver(_max2d._driver).u_pmatrix = _matrix
			
			glViewport(0,0,_width,_height)
		Else
			renderimage.SetRenderImage()
		EndIf
	EndMethod
	
	Method CreatePixmapFromRenderImage:TPixmap(renderImage:TRenderImage)
		Return TGL2SDLRenderImage(renderImage).ToPixmap()
	EndMethod
EndType
