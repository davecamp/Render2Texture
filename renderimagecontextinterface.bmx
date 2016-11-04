
Strict

Import "renderimageinterface.bmx"

Type TRenderimageContext
	Method Create:TRenderimageContext(context:TGraphics) Abstract
	Method CreateRenderImage:TRenderImage(width:Int, height:Int) Abstract
	Method SetRenderImage(renderimage:TRenderImage) Abstract
EndType
