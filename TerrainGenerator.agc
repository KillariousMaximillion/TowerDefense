// File: TerrainGenerator.agc
// Created: 21-11-21

//global outputSize = 1024
global noiseSeed1D as float[1024]
global perlinNoise1D as float[1024]

function Init1DSeeds()
	for i = 0 to 1024
    	noiseSeed1D[i] = random()/65535.0  // 65535.0 is max rand value so all numbers will generate 0.0 to 1.0 float values
    next i
endfunction
	
function CreatePerlinNoise1DArray(count as integer, octives as integer)
	top as integer = 10
	countInc as integer = 100
	
	
	for i = 0 to count
		noise as float = 0.0
		scale as float = 1.0
		scaleAccum as float = 0.0
		for j = 0 to octives
			pitch = Round(count >> j)
			tmppitch# = pitch
			tmpi# = i
			tmpcount# = count
			
			sample1 as integer 
			sample1 = (i / pitch) * pitch
			tmpsample1# = sample1
			
			sample2 as integer 
			sample2 = Mod((sample1 + pitch), count)
				
			blend as float
			blend = (tmpi# - tmpsample1#) / tmppitch#
			//blend# = blend
//~			if i > 400
//~			CreateText(countInc, "pitch:"+Str(pitch))
//~         SetTextSize(countInc,10)
//~	        SetTextPosition(countInc, 10, top)
//~	        inc countInc
//~	        inc top, 10
//~	        CreateText(countInc, "sample1:"+Str(sample1))
//~         SetTextSize(countInc,10)
//~	        SetTextPosition(countInc, 10, top)
//~         inc countInc
//~         inc top, 10
//~	        CreateText(countInc, "sample2:"+Str(sample2))
//~         SetTextSize(countInc,10)
//~	        SetTextPosition(countInc, 10, top)
//~	        inc countInc
//~	        inc top, 10
//~	        CreateText(countInc, "blend:"+Str(blend))
//~         SetTextSize(countInc,10)
//~			SetTextPosition(countInc, 10, top)
//~			inc countInc
//~			inc top, 10
//~			endif
			
			sample as float
			sample = (1.0 - blend) * noiseSeed1D[sample1] + blend * noiseSeed1D[sample2]
			//tmpsample# = sample
			noise = noise + (sample * scale)
			scaleAccum = scaleAccum + scale
			scale = scale / 2.0
		next j
		perlinNoise1D[i] = noise / scaleAccum
	next i
	
	
//~	top as integer = 10
//~    countInc as integer = 10
//~	for x = 125 to 256
//~    	CreateText(countInc, Str(x) + " : " + Str(perlinNoise1D[x]))
//~        SetTextSize(countInc,25)
//~	    SetTextPosition(countInc, 10, top)
//~	    inc countInc
//~	    inc top, 20
//~	next x
endfunction