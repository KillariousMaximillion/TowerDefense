// Project: TowerDefense 
// Created: 21-11-17

#include "TerrainGenerator.agc"

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "TowerDefense" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

// game initializers
global terrainWidth as integer = 1024  // resolution width of terrain
Init1DSeeds()
CreatePerlinNoise1DArray(terrainWidth)

// game loop
do
    if GetRawKeyPressed(90) // Z key
      Init1DSeeds()
      CreatePerlinNoise1DArray(terrainWidth)
    endif
	DrawNoiseArray1D()
    Print( ScreenFPS() )
    Sync()
loop

function DrawNoiseArray1D()
	for i = 0 to terrainWidth
		DrawLine(i, 768/2, i, (768-(perlinNoise1D[i]*768))/2, 255, 255, 0)
	next i
endfunction