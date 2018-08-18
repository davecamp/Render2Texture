# Render2Texture
A render to texture solution for the BlitzMax language


# NOTES For D3D9 Users
For d3d9 render-textures to persist during the device lost and reset state caused by alt-tab it was required to modify the d3d9graphics.bmx file to make way for texture management functionality.
The modified d3d9graphics.bmx file is supplied here and will need to be used in place of the original one at *BlitzMax_InstallFolder*/mod/brl.mod/dxgraphics.mod/
Don't forget to backup the original!
Hit 'Build modules' in the standard MaxIDE 'Program' menu, or alternatively 'Rebuild all modules', to re-build the dxgraphics module and any of its dependencies.

# Very important for folks that use threading in BlitzMax
RenderImages should only be used from a single render thread. The render thread, when using render images for d3d9, needs to be the same thread as the gui thread. In BlitzMax the gui thread would usually be the main thread.

If you don't use different threads for the gui and rendering then all should be ok.
If you don't use threading then the above doesn't apply.

# ALL Graphics Drivers
Make sure to use DestroyRenderImage. There is a reference held for each renderimage in a TList that needs to be removed. Relying on the garbage collector won't work to release them.

# D3D11 build issues
if you get an error 'srs.d3d11max2d' interface not found when building on Windows OSs:
You'll need Windows7 on newer for Direct3D11 support. You can download the srs.mod moodule from 'https://github.com/davecamp/srs.mod'
