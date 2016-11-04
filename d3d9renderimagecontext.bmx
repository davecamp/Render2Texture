
Strict

Import "renderimagecontextinterface.bmx"
Import "d3d9renderimage.bmx"

Type TD3D9RenderImageContext Extends TRenderImageContext
	Field _d3ddev:IDirect3DDevice9
	Field _backbuffer:IDirect3DSurface9
	Field _matrix:Float[]

	Method Create:TD3D9RenderimageContext(context:TGraphics)
		Local gc:TD3D9Graphics = TD3D9Graphics(context)

		_d3ddev = gc.GetDirect3DDevice()
		_d3ddev.GetRenderTarget(0, _backbuffer)
		
		Local desc:D3DSURFACE_DESC = New D3DSURFACE_DESC
		_backbuffer.GetDesc(desc)

		_matrix = [	2.0/desc.width, 0.0, 0.0, 0.0,..
					0.0, -2.0/desc.height, 0.0, 0.0,..
					0.0, 0.0, 1.0, 0.0,..
					-1-(1.0/desc.width), 1+(1.0/desc.height), 1.0, 1.0 ]

		Return Self
	EndMethod
	
	Method CreateRenderImage:TRenderImage(width:Int, height:Int)
		Local renderimage:TD3D9RenderImage = New TD3D9RenderImage.CreateRenderImage(width,height)
		renderimage.Init(_d3ddev)

		Return renderimage
	EndMethod

	Method SetRenderImage(renderimage:TRenderimage)
		If Not renderimage
			_d3ddev.SetRenderTarget(0, _backbuffer)	
			_d3ddev.SetTransform D3DTS_PROJECTION,_matrix
		Else
			renderimage.SetRenderImage()
		EndIf
	EndMethod
EndType
