
Strict

Import "renderimagecontextinterface.bmx"
Import "d3d11renderimage.bmx"

Type TD3D11RenderImageContext Extends TRenderImageContext
	Field _d3ddev:ID3D11Device
	Field _d3ddevcon:ID3D11DeviceContext
	Field _backbuffer:ID3D11RenderTargetView
	Field _viewport:D3D11_VIEWPORT
	Field _matrixbuffer:ID3D11Buffer
	
	Method Delete()
		If _backbuffer _backbuffer.Release_
	EndMethod
	
	Method Create:TD3D11RenderimageContext(context:TGraphics)
		Local gc:TD3D11Graphics = TD3D11Graphics(context)

		_d3ddev = gc.GetDirect3DDevice()
		_d3ddevcon = gc.GetDirect3DDeviceContext()
		
		_d3ddevcon.OMGetRenderTargets(1, Varptr _backbuffer, Null)		
		_d3ddevcon.VSGetConstantBuffers(0, 1, Varptr _matrixbuffer)

		_viewport = New D3D11_VIEWPORT
		Local vpCount:Int = 1
		_d3ddevcon.RSGetViewports(vpCount, _viewport)

		Return Self
	EndMethod
	
	Method CreateRenderImage:TRenderImage(width:Int, height:Int)
		Local renderimage:TD3D11RenderImage = New TD3D11RenderImage.CreateRenderImage(width,height)
		renderimage.Init(_d3ddev, _d3ddevcon)

		Return renderimage
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
