
Strict

Import "renderimagecontextinterface.bmx"
Import "d3d11renderimage.bmx"

Type TD3D11RenderImageContext Extends TRenderImageContext
	Field _d3ddev:ID3D11Device
	Field _d3ddevcon:ID3D11DeviceContext
	Field _backbuffer:ID3D11RenderTargetView
	
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

		Return Self
	EndMethod
	
	Method CreateRenderImage:TRenderImage(width:Int, height:Int)
		Local renderimage:TD3D11RenderImage = New TD3D11RenderImage.CreateRenderImage(width,height)
		renderimage.Init(_d3ddev, _d3ddevcon)

		Return renderimage
	EndMethod

	Method SetRenderImage(renderimage:TRenderimage)
		If Not renderimage
			Local vp:D3D11_VIEWPORT = New D3D11_VIEWPORT
			vp.Width = GraphicsWidth()
			vp.Height = GraphicsHeight()
			vp.MinDepth = 0.0
			vp.MaxDepth = 1.0
			vp.TopLeftX = 0.0
			vp.TopLeftY = 0.0
			_d3ddevcon.RSSetViewports(1,vp)
			
			_d3ddevcon.OMSetRenderTargets(1, Varptr _backbuffer, Null)
			_d3ddevcon.VSSetConstantBuffers(0, 1, Varptr _matrixbuffer)
		Else
			renderimage.SetRenderImage()
		EndIf
	EndMethod
EndType
