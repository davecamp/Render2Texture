Strict

Import "renderimageinterface.bmx"

Private
Global _d3ddev:IDirect3DDevice9
Public

Type TD3D9RenderImageFrame Extends TD3D9ImageFrame
	Field _surface:IDirect3DSurface9
	
	Method Delete()
		If _surface _surface.Release_
		If _texture _texture.Release_
	EndMethod
	
	Method CreateRenderTarget:TD3D9RenderImageFrame( d3ddev:IDirect3DDevice9, width,height )
		d3dDev.CreateTexture(width,height,1,D3DUSAGE_RENDERTARGET,D3DFMT_A8R8G8B8,D3DPOOL_DEFAULT,_texture,Null)
		
		If _texture
			_texture.GetSurfaceLevel 0, _surface
		EndIf
		
		_magfilter = D3DTFG_LINEAR
		_minfilter = D3DTFG_LINEAR
		_mipfilter = D3DTFG_LINEAR

		_uscale = 1.0 / width
		_vscale = 1.0 / height
		
		Return Self
	EndMethod
EndType

Type TD3D9RenderImage Extends TRenderImage
	Field _d3ddev:IDirect3DDevice9
	Field _matrix:Float[]

	Method CreateRenderImage:TD3D9RenderImage(width:Int ,height:Int)
		Self.width=width	' TImage.width
		Self.height=height	' TImage.height
	
		_matrix = [	2.0/width, 0.0, 0.0, 0.0,..
					0.0, -2.0/height, 0.0, 0.0,..
					0.0, 0.0, 1.0, 0.0,..
					-1-(1.0/width), 1+(1.0/height), 1.0, 1.0 ]

		Return Self
	EndMethod
	
	Method Init(d3ddev:IDirect3DDevice9)
		_d3ddev = d3ddev

		frames=New TD3D9RenderImageFrame[1]
		frames[0] = New TD3D9RenderImageFrame.CreateRenderTarget(d3ddev, width, height)
	EndMethod

	Method Frame:TImageFrame(index=0)
		Return frames[0]
	EndMethod
	
	Method SetRenderImage()
		_d3ddev.SetRenderTarget 0, TD3D9RenderImageFrame(frames[0])._surface
		_d3ddev.SetTransform D3DTS_PROJECTION,_matrix
	EndMethod
EndType





