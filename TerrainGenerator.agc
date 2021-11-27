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

	for w = 0 to width - 1
		for h = 0 to height - 1
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