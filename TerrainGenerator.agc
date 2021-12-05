// File: TerrainGenerator.agc
// Created: 21-11-21

global noiseSeed1D as float[1]
global perlinNoise1D as float[1]

global noiseSeed2D as float[1]
global perlinNoise2D as float[1]

function Init1DSeeds(width as integer)
	noiseSeed1D.length = width
	for i = 0 to width
    	noiseSeed1D[i] = random()/65535.0  // 65535.0 is max rand value so all numbers will generate 0.0 to 1.0 float values
    next i
endfunction

function Init2DSeeds(width as integer, height as integer)
	noiseSeed2D.length = width * height
	for i = 0 to (width * height)
    	noiseSeed2D[i] = random()/65535.0  // 65535.0 is max rand value so all numbers will generate 0.0 to 1.0 float values
    next i
endfunction
	
function CreatePerlinNoise1DArray(width as integer, bias as float)
	perlinNoise1D.length = width
	
	// number of times count is divisible by two
	octives as integer 
	octives = Floor(log(width)/log(2))
	
	for w = 0 to width
		noise as float = 0.0
		scale as float = 1.0
		scaleAccum as float = 0.0
		for o = 0 to octives
			pitch = Round(width >> o)
			tmppitch# = pitch
			tmpw# = w
			
			sample1 as integer 
			sample1 = (w / pitch) * pitch
			tmpsample1# = sample1
			
			sample2 as integer 
			sample2 = Mod((sample1 + pitch), width)
				
			blend as float
			blend = (tmpw# - tmpsample1#) / tmppitch#
			
			sample as float
			sample = (1.0 - blend) * noiseSeed1D[sample1] + blend * noiseSeed1D[sample2]

			noise = noise + (sample * scale)
			scaleAccum = scaleAccum + scale
			scale = scale / bias
		next o
		perlinNoise1D[w] = noise / scaleAccum
	next w
endfunction

function CreatePerlinNoise2DArray(width as integer, height as integer, bias as float)
	perlinNoise2D.length = width * height
	
	// number of times count is divisible by two
	octives as integer 
	octives = Floor(log(width)/log(2))

	for w = 0 to width //- 1
		for h = 0 to height //- 1
			noise as float = 0.0
			scale as float = 1.0
			scaleAccum as float = 0.0
			for o = 0 to octives
				pitch = width >> o
				
				sampleX1 as integer 
				sampleX1 = (w / pitch) * pitch
				sampleY1 as integer 
				sampleY1 = (h / pitch) * pitch
				
				sampleX2 as integer 
				sampleX2 = Mod((sampleX1 + pitch), width)
				sampleY2 as integer 
				sampleY2 = Mod((sampleY1 + pitch), width)
					
				blendX as float
				blendX = (w - sampleX1) / pitch
				blendY as float
				blendY = (h - sampleY1) / pitch
							
				sampleT as float
				sampleT = (1.0 - blendX) * noiseSeed2D[sampleY1 * (width-1) + sampleX1] + blendX * noiseSeed2D[sampleY1 * (width-1) + sampleX2]
				sampleB as float
				sampleB = (1.0 - blendX) * noiseSeed2D[sampleY2 * (width-1) + sampleX1] + blendX * noiseSeed2D[sampleY2 * (width-1) + sampleX2]
	
				noise = noise + ((blendY * (sampleB - sampleT) + sampleT) * scale)
				scaleAccum = scaleAccum + scale
				scale = scale / bias
			next o
			perlinNoise2D[h * (width-1) + w] = noise / scaleAccum
		next h
	next w
endfunction

function DrawNoiseArray1D(width as integer)
	for w = 0 to width
		DrawLine(w, 768/2, w, (768-(perlinNoise1D[w]*768))/2, 255, 255, 0)
	next w
endfunction

// this function will build a grayscale height map will not be used for this app
function DrawNoiseArray2D(width as integer, height as integer)
	for w = 0 to width - 1
		for h = 0 to height - 1		
			pixel_bw as integer
			pixel_bw = Round(perlinNoise2D[h * (width-1) + w] * 12.0)
			
			testimg1 as integer 		
			testimg2 as integer 

			select pixel_bw
				case 0:
					testimg1 = MakeColor(0, 0, 0, 255)
					testimg2 = MakeColor(0, 0, 0, 255)
				endcase
				case 1:
					testimg1 = MakeColor(0, 0, 0, 63.75)
					testimg2 = MakeColor(169, 169, 169, 63.75)
				endcase
				case 2:
					testimg1 = MakeColor(0, 0, 0, 127.5)
					testimg2 = MakeColor(169, 169, 169, 127.5)
				endcase
				case 3:
					testimg1 = MakeColor(0, 0, 0, 191.25)
					testimg2 = MakeColor(169, 169, 169, 191.25)
				endcase
				case 4:
					testimg1 = MakeColor(0, 0, 0, 255)
					testimg2 = MakeColor(169, 169, 169, 255)
				endcase
				
				case 5:
					testimg1 = MakeColor(169, 169, 169, 63.75)
					testimg2 = MakeColor(128, 128, 128, 63.75)
				endcase
				case 6:
					testimg1 = MakeColor(169, 169, 169, 127.5)
					testimg2 = MakeColor(128, 128, 128, 127.5)
				endcase
				case 7:
					testimg1 = MakeColor(169, 169, 169, 191.25)
					testimg2 = MakeColor(169, 169, 169, 191.25)
				endcase
				case 8:
					testimg1 = MakeColor(169, 169, 169, 255)
					testimg2 = MakeColor(128, 128, 128, 255)
				endcase
				
				case 9:
					testimg1 = MakeColor(128, 128, 128, 63.75)
					testimg2 = MakeColor(255, 255, 255, 63.75)
				endcase
				case 10:
					testimg1 = MakeColor(128, 128, 128, 127.5)
					testimg2 = MakeColor(255, 255, 255, 127.5)
				endcase
				case 11:
					testimg1 = MakeColor(128, 128, 128, 191.25)
					testimg2 = MakeColor(255, 255, 255, 191.25)
				endcase
				case 12:
					testimg1 = MakeColor(128, 128, 128, 255)
					testimg2 = MakeColor(255, 255, 255, 255)
				endcase
			endselect
			
			DrawLine(w, height - h, w, height - h, testimg1, testimg2 )
		next h
	next w
endfunction


// the following functions create the rendered terrain
type terrainPlaneSegment
	id as integer // plane
	slope as float
endtype
global terrainPlaneSegments as terrainPlaneSegment[terrainSplitArrayLength]

type objColor
	r as integer
	g as integer
	b as integer
	a as integer
endtype
global colors as objColor[2]

function createTerrain(xlength as integer, zlength as integer)//, ylength as integer)
	// convert max height(altitude) of a point to float for calculations
	//ylength# = ylength
	
	//colors[1].r = 0
	//colors[1].g = 0
	//colors[1].b = 255
	//colors[1].a = 255
	//colors[2].r = 255
	//colors[2].g = 0
	//colors[2].b = 0
	//colors[2].a = 255
	
	// clear the terrain plane's before making new ones
	for seg = 0 to terrainSplitArrayLength
		DeleteObject(terrainPlaneSegments[seg].id)
	next
	
	
	tmpPoints as integer[4]
	segment as integer = 0
//	alt as integer = 0
	for x = 0 to xlength-10 step terrainSplit
		//if alt = 0
		//	alt = 1
		//else
		//	alt = 0
		//endif
		for z = 0 to zlength step terrainSplit
			//if x >= 49 and x <= 50 and z >= 49 and z <= 50
				tmpPoints[0] = slopeTerrain(perlinNoise2D[x * (xlength) + z] * 12)
				tmpPoints[1] = slopeTerrain(perlinNoise2D[(x + terrainSplit) * (xlength) + z] * 12)
				tmpPoints[2] = slopeTerrain(perlinNoise2D[x * (xlength) + (z + terrainSplit)] * 12)
				tmpPoints[3] = slopeTerrain(perlinNoise2D[(x + terrainSplit) * (xlength) + (z + terrainSplit)] * 12)
				
				terrainPlaneSegments[segment].id = CreateObjectplane(terrainSplit,terrainSplit)
				SetObjectPosition(terrainPlaneSegments[segment].id, 
								 x - (xlength / 2) + (terrainSplit / 2), 
								 0, 
								 terrainSplit - (z - (zlength / 2) + (terrainSplit / 2)))
				RotateObjectLocalX(terrainPlaneSegments[segment].id, 90)
				
				// this can be removed in final version no need to render bottom face
				//SetObjectCullMode(terrainPlaneSegments[segment].id, 0)
				
				meshmemblock = CreateMemblockFromObjectMesh(terrainPlaneSegments[segment].id,1)
					
				// top side
				// poly 1 - top left - vertex 0 
				SetMeshMemblockVertexPosition(meshmemblock,0,
					GetMeshMemblockVertexX(meshmemblock,0),
					GetMeshMemblockVertexY(meshmemblock,0),
					GetMeshMemblockVertexZ(meshmemblock,0)-tmpPoints[0])
				// poly 1 - bottom left - vertex 1
				SetMeshMemblockVertexPosition(meshmemblock,1,
					GetMeshMemblockVertexX(meshmemblock,1),
					GetMeshMemblockVertexY(meshmemblock,1),
					GetMeshMemblockVertexZ(meshmemblock,1)-tmpPoints[2])
				// poly 1 - top right - vertex 2
				SetMeshMemblockVertexPosition(meshmemblock,2,
					GetMeshMemblockVertexX(meshmemblock,2),
					GetMeshMemblockVertexY(meshmemblock,2),
					GetMeshMemblockVertexZ(meshmemblock,2)-tmpPoints[1])
				// poly 2 - top right - vertex 3 
				SetMeshMemblockVertexPosition(meshmemblock,3,
					GetMeshMemblockVertexX(meshmemblock,3),
					GetMeshMemblockVertexY(meshmemblock,3),
					GetMeshMemblockVertexZ(meshmemblock,3)-tmpPoints[1])	
				// poly 2 - bottom left - vertex 5
				SetMeshMemblockVertexPosition(meshmemblock,4,
					GetMeshMemblockVertexX(meshmemblock,4),
					GetMeshMemblockVertexY(meshmemblock,4),
					GetMeshMemblockVertexZ(meshmemblock,4)-tmpPoints[2])	
				// poly 2 - bottom right - vertex 6
				SetMeshMemblockVertexPosition(meshmemblock,5,
					GetMeshMemblockVertexX(meshmemblock,5),
					GetMeshMemblockVertexY(meshmemblock,5),
					GetMeshMemblockVertexZ(meshmemblock,5)-tmpPoints[3])	
				
//~				// these are verticies on back side of plane (unused)
//~				// poly 3 - top right - vertex 7
//~				SetMeshMemblockVertexPosition(meshmemblock,6,
//~					GetMeshMemblockVertexX(meshmemblock,6),
//~					GetMeshMemblockVertexY(meshmemblock,6),
//~					GetMeshMemblockVertexZ(meshmemblock,6)-tmpPoints[1])	
//~				// poly 3 - bottom right - vertex 8	
//~				SetMeshMemblockVertexPosition(meshmemblock,7,
//~					GetMeshMemblockVertexX(meshmemblock,7),
//~					GetMeshMemblockVertexY(meshmemblock,7),
//~					GetMeshMemblockVertexZ(meshmemblock,7)-tmpPoints[3])
//~				// poly 3 - top left - vertex 9	
//~				SetMeshMemblockVertexPosition(meshmemblock,8,
//~					GetMeshMemblockVertexX(meshmemblock,8),
//~					GetMeshMemblockVertexY(meshmemblock,8),
//~					GetMeshMemblockVertexZ(meshmemblock,8)-tmpPoints[0])
//~				// poly 4 - top left - vertex 10	
//~				SetMeshMemblockVertexPosition(meshmemblock,9,
//~					GetMeshMemblockVertexX(meshmemblock,9),
//~					GetMeshMemblockVertexY(meshmemblock,9),
//~					GetMeshMemblockVertexZ(meshmemblock,9)-tmpPoints[0])
//~				// poly 4 - bottom right - vertex 11
//~				SetMeshMemblockVertexPosition(meshmemblock,10,
//~					GetMeshMemblockVertexX(meshmemblock,10),
//~					GetMeshMemblockVertexY(meshmemblock,10),
//~					GetMeshMemblockVertexZ(meshmemblock,10)-tmpPoints[3])
//~				// poly 4 - bottom left - vertex 12
//~				SetMeshMemblockVertexPosition(meshmemblock,11,
//~					GetMeshMemblockVertexX(meshmemblock,11),
//~					GetMeshMemblockVertexY(meshmemblock,11),
//~					GetMeshMemblockVertexZ(meshmemblock,11)-tmpPoints[2])
				
				// transform original plane
				SetObjectMeshFromMemblock(terrainPlaneSegments[segment].id, 1, meshmemblock)	
				
				setObjectImage(terrainPlaneSegments[segment].id, image0001, 0)
				
				//SetObjectColor( terrainPlaneSegments[segment].id, 0, 255, 0, 255 )
				//if alt = 0
				//	SetObjectColor( terrainPlaneSegments[segment].id, colors[1].r, colors[1].g, colors[1].b, colors[1].a )
				//	alt = 1
				//else
				//	SetObjectColor( terrainPlaneSegments[segment].id, colors[2].r, colors[2].g, colors[2].b, colors[2].a )
				//	alt = 0
				//endif
				
				segment = segment + 1
			//endif
		next z
	next x
endfunction

function slopeTerrain(value as integer)
	retval as integer = 0
			select value
				case 0:
					retval = 1
				endcase
				case 1:
					retval = 2
				endcase
				case 2:
					retval = 3
				endcase
				case 3:
					retval = 4
				endcase
				case 4:
					retval = 5
				endcase
				
				case 5:
					retval = 6
				endcase
				case 6:
					retval = 7
				endcase
				case 7:
					retval = 8
				endcase
				case 8:
					retval = 9
				endcase
				
				case 9:
					retval = 10
				endcase
				case 10:
					retval = 11
				endcase
				case 11:
					retval = 12
				endcase
				case 12:
					retval = 13
				endcase
			endselect
endfunction retval