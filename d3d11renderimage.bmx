Strict

Import srs.d3d11max2d
Import "renderimageinterface.bmx"

Global _d3ddev:ID3D11Device

Type TD3D11RenderImageFrame Extends TD3D11ImageFrame
	Method Delete()
		ReleaseNow()
	EndMethod
	
	Method ReleaseNow()
		If _tex2D
			_tex2D.release_
			_tex2D = Null
		EndIf
		If _srv
			_srv.release_
			_srv = Null
		EndIf
		If _rtv
			_rtv.release_
			_rtv = Null
		EndIf
	EndMethod
	
	Method CreateRenderTarget:TD3D11RenderImageFrame( d3ddev:ID3D11Device, width, height )
		'create texture
		Local desc:D3D11_TEXTURE2D_DESC = New D3D11_TEXTURE2D_DESC
		desc.Width = width
		desc.Height = height
		desc.MipLevels = 1
		desc.ArraySize = 1
		desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM
		desc.SampleDesc_Count = 1
		desc.SampleDesc_Quality = 0
		desc.Usage = D3D11_USAGE_DEFAULT
		desc.BindFlags = D3D11_BIND_SHADER_RESOURCE | D3D11_BIND_RENDER_TARGET

		If d3ddev.CreateTexture2D(desc,Null,_tex2D) < 0
			WriteStdout("Cannot create texture~n")
			Return
		EndIf
		
		'Setup for shader
		Local srdesc:D3D11_SHADER_RESOURCE_VIEW_DESC = New D3D11_SHADER_RESOURCE_VIEW_DESC

		srdesc.Format = desc.Format
		srdesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D
		srdesc.Texture_MostDetailedMip = 0
		srdesc.Texture_MipLevels = 1
				
		If d3ddev.CreateShaderResourceView(_tex2D,srdesc,_srv)<0
			WriteStdout "Cannot create ShaderResourceView for TImage texture~n"
			Return
		EndIf
		
		If d3ddev.CreateRenderTargetView(_tex2D,Null,_rtv)<0
			WriteStdout "Cannot use texture as a Render Texture~n"
			Return
		EndIf

		_uscale = 1.0 / width
		_vscale = 1.0 / height

		Return Self
	EndMethod
	
	Method DestroyRenderTarget()
		ReleaseNow()
	EndMethod
EndType

Type TD3D11RenderImage Extends TRenderImage
	Field _d3ddevcon:ID3D11DeviceContext
	Field _matrixbuffer:ID3D11Buffer
	Field _matrix:Float[16]
	Field _viewport:D3D11_VIEWPORT
	
	Method Delete()
		If _matrixbuffer
			_matrixbuffer.release_
			_matrixbuffer = Null
		EndIf
	EndMethod

	Method CreateRenderImage:TD3D11RenderImage(width:Int ,height:Int)
		Self.width=width	' TImage.width
		Self.height=height	' TImage.height

		_matrix = [ 2.0/width,0.0,0.0,-1-(1.0/width),..
					0.0,-2.0/height,0.0,1-(1.0/height),..
					0.0,0.0,1.0,0.0,..
					0.0,0.0,0.0,1.0]

		_viewport = New D3D11_VIEWPORT
		_viewport.Width = width
		_viewport.Height = height
		_viewport.MaxDepth = 1.0

		Return Self
	EndMethod
	
	Method DestroyRenderImage()
		TD3D11RenderImageFrame(frames[0]).DestroyRenderTarget()
	EndMethod

	Method Init(d3ddev:ID3D11Device, d3ddevcon:ID3D11DeviceContext)
		_d3ddevcon = d3ddevcon

		Local desc:D3D11_BUFFER_DESC = New D3D11_BUFFER_DESC
		desc.ByteWidth = SizeOf(_matrix)
		desc.Usage = D3D11_USAGE_DEFAULT
		desc.BindFlags = D3D11_BIND_CONSTANT_BUFFER

		Local data:D3D11_SUBRESOURCE_DATA = New D3D11_SUBRESOURCE_DATA
		data.pSysMem = _matrix

		If d3ddev.CreateBuffer(desc, data, _matrixbuffer) < 0 Throw "TD3D11RenderImage:Init cannot create matrix buffer"

		frames=New TD3D11RenderImageFrame[1]
		frames[0] = New TD3D11RenderImageFrame.CreateRenderTarget(d3ddev, width, height)

		' clear
		_d3ddevcon.ClearRenderTargetView(TD3D11RenderImageFrame(frames[0])._rtv, [0.0, 0.0, 0.0, 0.0])
	EndMethod

	Method Frame:TImageFrame(index=0)
		Return frames[0]
	EndMethod

	Method SetRenderImage()
		_d3ddevcon.RSSetViewports(1,_viewport)
		_d3ddevcon.OMSetRenderTargets(1, Varptr TD3D11RenderImageFrame(frames[0])._rtv, Null)
		_d3ddevcon.VSSetConstantBuffers(0, 1, Varptr _matrixbuffer)
	EndMethod
EndType





