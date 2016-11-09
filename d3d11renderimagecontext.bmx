
Strict

Import "renderimagecontextinterface.bmx"
Import "d3d11renderimage.bmx"

Type TD3D11RenderImageContext Extends TRenderImageContext
	Field _gc:TD3D11Graphics
	Field _d3ddev:ID3D11Device
	Field _d3ddevcon:ID3D11DeviceContext
	Field _backbuffer:ID3D11RenderTargetView
	Field _viewport:D3D11_VIEWPORT
	Field _matrixbuffer:ID3D11Buffer

	Field _renderimages:TList

	Method Delete()
		ReleaseNow()
	EndMethod

	Method ReleaseNow()
		If _renderimages
			For Local ri:TD3D11RenderImage = EachIn _renderimages
				ri.DestroyRenderImage()
			Next
		EndIf

		_renderimages = Null
		_viewport = Null
		_gc = Null

		If _backbuffer
			_backbuffer.release_
			_backbuffer = Null
		EndIf
		If _matrixbuffer
			_matrixbuffer.release_
			_matrixbuffer = Null
		EndIf
		If _d3ddevcon
			_d3ddevcon.release_
			_d3ddevcon = Null
		EndIf
		If _d3ddev
			_d3ddev.release_
			_d3ddev = Null
		EndIf
	EndMethod

	Method Create:TD3D11RenderimageContext(context:TGraphics)
		_gc = TD3D11Graphics(context)

		_d3ddev = _gc.GetDirect3DDevice()
		_d3ddev.AddRef()

		_d3ddevcon = _gc.GetDirect3DDeviceContext()
		_d3ddevcon.AddRef()		

		_d3ddevcon.OMGetRenderTargets(1, Varptr _backbuffer, Null)	
		_d3ddevcon.VSGetConstantBuffers(0, 1, Varptr _matrixbuffer)

		_viewport = New D3D11_VIEWPORT
		Local vpCount:Int = 1

		_d3ddevcon.RSGetViewports(vpCount, _viewport)
		_renderimages = New TList

		Return Self
	EndMethod
	
	Method Destroy()
		ReleaseNow()
	EndMethod
		
	Method CreateRenderImage:TRenderImage(width:Int, height:Int)
		Local renderimage:TD3D11RenderImage = New TD3D11RenderImage.CreateRenderImage(width,height)
		renderimage.Init(_d3ddev, _d3ddevcon)

		_renderimages.AddLast(renderimage)

		Return renderimage
	EndMethod
	
	Method GraphicsContext:TGraphics()
		Return _gc
	EndMethod

	Method SetRenderImage(renderimage:TRenderimage)
		If Not renderimage
			_d3ddevcon.RSSetViewports(1,_viewport)
			
			_d3ddevcon.OMSetRenderTargets(1, Varptr _backbuffer, Null)
			_d3ddevcon.VSSetConstantBuffers(0, 1, Varptr _matrixbuffer)
		Else
			renderimage.SetRenderImage()
		EndIf
	EndMethod
EndType
