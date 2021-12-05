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

SetShadowMappingMode(2)
SetShadowRange(-1)
SetShadowBias(0.0001)

SetSunActive(1)
SetSunColor(255, 200, 200)
//SetSunDirection(-0.785398, -0.785398, 0.90) 
SetSunDirection(-0.45, -0.45, 0.90) 

// game initializers
#constant terrainWidth = 100  // resolution width of terrain
#constant terrainDepth = 100  // resolution depth(into screen) of terrain
//#constant terrainHeight = 100 // resolutions height of terrain
#constant terrainSplit = 5 // the split of terrain in segmented planes

// TODO: this arraay is to big for 100x100 make smaller 
#constant terrainSplitArrayLength = 360000//14440 //(terrainWidth / terrainSplit) * (terrainHeight / terrainSplit)
terrainBias as float = 0.75  // greater then 2.0 = smoother, lower then 2.0 = rougher

#constant PI = 3.1415926535897

//Init1DSeeds(terrainWidth)
//CreatePerlinNoise1DArray(terrainWidth, terrainBias)
Init2DSeeds(terrainWidth, terrainDepth)
CreatePerlinNoise2DArray(terrainWidth, terrainDepth, terrainBias)

//water plane
terrain = CreateObjectPlane(95,105)
RotateObjectGlobalX(terrain,90) 
SetObjectPosition(terrain, -2.5, 5.5, 2.5)
SetObjectColor( terrain, 0, 0, 255, 255)

// create a directional light (to make the scene look better)
//CreatePointLight(1,-1,-1,1,40,255,255,255)

// position and orientate the camera
camera as integer = 1
panAngle# = 0
cameraDistance# = 50
cameraElevation# = 20
cameraX# = cameraDistance# * sin(cameraElevation#) * sin(panAngle#)
cameraY# = cameraDistance# * cos(cameraElevation#)
cameraZ# = cameraDistance# * sin(cameraElevation#) * cos(panAngle#) 
cameraLAX# = 0
cameraLAY# = 0
cameraLAZ# = 0

//SetCameraPosition(camera,cameraX#,cameraY#,cameraZ#)
SetCameraPosition(camera,0,100,-50)
SetCameraRotation(camera,30,0,0)

global pStr as string
global pStr2 as string
global pStr3 as string

global image0001 as integer
image0001=loadImage("grass2.png")

// game loop
createTerrain(terrainWidth, terrainDepth)//, terrainHeight)
do
    if GetRawKeyPressed(90) // Z key
//      Init1DSeeds(terrainWidth)
//      CreatePerlinNoise1DArray(terrainWidth, terrainBias)
 		Init2DSeeds(terrainWidth, terrainDepth)
 		CreatePerlinNoise2DArray(terrainWidth, terrainDepth, terrainBias)
 		createTerrain(terrainWidth, terrainDepth)//, terrainHeight)
    endif
    
    
//	DrawNoiseArray1D(terrainWidth)
	//SetRenderToImage (100,0) 
	//DrawNoiseArray2D(terrainWidth, terrainHeight)
	//SaveImage(100,"test.png")
	//CreateObjectFromHeightMap( 345, "test.png", 600, 600, 600, 2, 1 )
	//SetRenderToScreen () 
	//CreateSprite(345) 
	
	//RotateObjectGlobalX(terrain,1)
	
	
// camera pan
   	// FacingAngle# = GetObjectAngleY(box)+panAngle#
   	// newCameraX# = ((sin(FacingAngle#)*(180/PI)))
	// newCameraZ# = -((cos(FacingAngle#)*(180/PI)))
	// newCameraY# = (GetObjectY(box)/10)+2.8
//~    if GetRawKeyState(69) > 0 // pan the camera to the right
//~		panAngle# = panAngle# + 2
//~		if panAngle# > 360 
//~			panAngle# = panAngle# - 360 
//~		elseif panAngle# < 0 
//~			panAngle# = 360 - panAngle# 	  
//~		endif
//~		cameraX# = cameraDistance# * sin(cameraElevation#) * sin(panAngle#)
//~		cameraY# = cameraDistance# * cos(cameraElevation#)
//~		cameraZ# = cameraDistance# * sin(cameraElevation#) * cos(panAngle#)        
//~		SetCameraPosition(camera,cameraX#,cameraY#,cameraZ#)
//~	//	SetCameraLookAt(camera, 0, 0, 0, 0)
//~	elseif GetRawKeyState(81) > 0 // pan the camera to the left
//~		panAngle# = panAngle# - 2
//~		if panAngle# > 360 
//~			panAngle# = panAngle# - 360 
//~		elseif panAngle# < 0 
//~			panAngle# = 360 - panAngle# 	  
//~		endif
//~		cameraX# = cameraDistance# * sin(cameraElevation#) * sin(panAngle#)
//~		cameraY# = cameraDistance# * cos(cameraElevation#)
//~		cameraZ# = cameraDistance# * sin(cameraElevation#) * cos(panAngle#)     
//~		SetCameraPosition(camera,cameraX#,cameraY#,cameraZ#)
//~	//	SetCameraLookAt(camera, 0, 0, 0, 0)	
//~	endif			
	
	if GetRawKeyState(87) > 0  // w key forward
		cameraX# = GetCameraX(camera)
		cameraY# = GetCameraY(camera) 
		cameraZ# = GetCameraZ(camera) + 1
		SetCameraPosition(camera, cameraX#, cameraY#, cameraZ#)
	endif
	if GetRawKeyState(83) > 0 // s key backward
		cameraX# = GetCameraX(camera)
		cameraY# = GetCameraY(camera) 
		cameraZ# = GetCameraZ(camera) - 1
		SetCameraPosition(camera, cameraX#, cameraY#, cameraZ#)
	endif
	if GetRawKeyState(65) > 0 // a key left
		cameraX# = GetCameraX(camera) - 1
		cameraY# = GetCameraY(camera)
		cameraZ# = GetCameraZ(camera) 
		SetCameraPosition(camera, cameraX#, cameraY#, cameraZ#)
	endif
	if GetRawKeyState(68) > 0 // d key right
		cameraX# = GetCameraX(camera) + 1
		cameraY# = GetCameraY(camera)
		cameraZ# = GetCameraZ(camera) 
		SetCameraPosition(camera, cameraX#, cameraY#, cameraZ#)
	endif
	if GetRawKeyState(82) > 0 // r key up
		cameraX# = GetCameraX(camera) 
		cameraY# = GetCameraY(camera) + 1
		cameraZ# = GetCameraZ(camera) 
		SetCameraPosition(camera, cameraX#, cameraY#, cameraZ#)
	endif
	if GetRawKeyState(70) > 0 // f key down
		cameraX# = GetCameraX(camera) 
		cameraY# = GetCameraY(camera) - 1
		cameraZ# = GetCameraZ(camera) 
		SetCameraPosition(camera, cameraX#, cameraY#, cameraZ#)
	endif
	
//	Print ( pStr3 + pStr + pStr2 + Str(GetCameraX(camera)) + Str(GetCameraY(camera)) + Str(GetCameraZ(camera)))
 //   Print( ScreenFPS() )
    Sync()
loop
	
// example to dump text to screen
//~	top as integer = 10
//~ countInc as integer = 10
//~	for x = 125 to 256
//~    	CreateText(countInc, Str(x) + " : " + Str(perlinNoise1D[x]))
//~     SetTextSize(countInc,25)
//~	    SetTextPosition(countInc, 10, top)
//~	    inc countInc
//~	    inc top, 20
//~	next x