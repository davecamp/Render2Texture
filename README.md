# Render2Texture
A render to texture solution for the BlitzMax language

This a currently a work in progress.

# NOTES
For d3d9 render-textures to persist during the device lost and reset state caused by alt-tab it was required to modify the d3d9graphics.bmx file to make way for texture management functionality.
The modified d3d9graphics.bmx file is supplied here and will need to be used in place of the original one at *BlitzMax_InstallFolder*/mod/brl.mod/dxgraphics.mod/
Don't forget to backup the original!