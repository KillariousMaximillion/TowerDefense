// Project: TowerDefense 
// Created: 21-11-17

#include "TerrainGenerator.agc"

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "TowerDefense" )
SetWindowSize( 600, 600, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 600,600 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

// game initializers
terrainWidth as integer = 600  // resolution width of terrain
terrainHeight as integer = 600 // resolution height of terrain
terrainBias as float = 0.75  // greater then 2.0 = smoother, lower then 2.0 = rougher

//Init1DSeeds(terrainWidth)
//CreatePerlinNoise1DArray(terrainWidth, terrainBias)
Init2DSeeds(terrainWidth, terrainHeight)
CreatePerlinNoise2DArray(terrainWidth, terrainWidth, terrainBias)

//CreateRenderImage(100, terrainWidth, terrainHeight, 0, 0)

//global terrain as integer
//terrain = CreateObjectPlane(600,600)
//RotateObjectGlobalX(terrain,90) 

// create a directional light (to make the scene look better)
CreatePointLight(1,-1,-1,1,40,255,255,255)

// position and orientate the camera
SetCameraPosition(1,0,100,-250)
SetCameraLookAt(1,0,0,0,0)

memblock = CreateMemblock(160)

//Now we need to fill it with mesh data
SetMemblockInt(memblock,0,3) //3 vertices
SetMemblockInt(memblock,4,3) //3 indices, not necissary for simple triangle, but we do it here for completeness
SetMemblockint(memblock,8,3) //Our mesh has 3 attributes, position, normal, color
Setmemblockint(memblock,12,28) //number of bytes each vertext takes up. x,y,z,nx,ny,nz,color * 4
SetMemblockInt(memblock,16,64) //offset to vertex data
SetMemblockInt(memblock,20,148) //offset to index data

//Attribute information, I'm combining all bytes into a single int.  
//   Little endiness means order is string length, normal flag, component count, data type (data will
//   be written to the MemBlock in reverse order).
SetMemBlockInt(memblock,24,0x0C000300) //float, 3 components, no normalizing, position
SetMemblockString(memblock,28,"position") 
SetMemblockInt(memblock,40,0x08000300) //same as position, but for normals
SetMemblockString(memblock,44,"normal")
SetMemblockInt(memblock,52,0x08010401) //For color we have byte, 4 components, normalize data
SetMemblockString(memblock,56,"color")

//Now we can enter vertex data

Vertex as float[8] = [5.0,-5.0,0.0,-5.0,-5.0,0.0,0.0,5.0,0.0]
Color as integer[2] = [0xFFFF0000,0xFF00FF00,0xFF0000FF]

for i = 0 to 2
        SetMemblockFloat(memblock,64+i*28,Vertex[i*3]) //x
        SetMemblockFloat(memblock,68+i*28,Vertex[i*3+1]) //y
        SetMemblockFloat(memblock,72+i*28,Vertex[i*3+2]) //z
        SetMemblockFloat(memblock,76+i*28,0.0) //nx
        SetMemblockFloat(memblock,80+i*28,0.0) //ny
        SetMemblockFloat(memblock,84+i*28,-1.0) //nz
        SetMemblockInt(memblock,88+i*28,Color[i]) //color
next
 // Now the index data
 SetMemblockInt(memblock,148,0)
 SetMemblockInt(memblock,152,2)
 SetMemblockInt(memblock,156,1)
        
//Now to create the object
triangle = CreateObjectFromMeshMemblock(memblock)

// game loop
do
    if GetRawKeyPressed(90) // Z key
//      Init1DSeeds(terrainWidth)
//      CreatePerlinNoise1DArray(terrainWidth, terrainBias)
 		Init2DSeeds(terrainWidth, terrainHeight)
 		CreatePerlinNoise2DArray(terrainWidth, terrainWidth, terrainBias)
    endif
//	DrawNoiseArray1D(terrainWidth)
	//SetRenderToImage (100,0) 
	//DrawNoiseArray2D(terrainWidth, terrainHeight)
	//SaveImage(100,"test.png")
	//CreateObjectFromHeightMap( 345, "test.png", 600, 600, 600, 2, 1 )
	//SetRenderToScreen () 
	//CreateSprite(345) 
	
	//RotateObjectGlobalX(terrain,1)
	
	
 //   Print( ScreenFPS() )
    Sync()
loop

	
//~	top as integer = 10
//~ countInc as integer = 10
//~	for x = 125 to 256
//~    	CreateText(countInc, Str(x) + " : " + Str(perlinNoise1D[x]))
//~     SetTextSize(countInc,25)
//~	    SetTextPosition(countInc, 10, top)
//~	    inc countInc
//~	    inc top, 20
//~	next x