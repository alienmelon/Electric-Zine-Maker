/*
the perlin brush tool
gradient mask of a perlin texture
makes a radial brush, then draw the texture
the brush is generated with draw_texture(event.localX, event.localY);
texture is set up using bitmapdata_texture (the perlin texture) and bitmapdata_tool (the tool/mask) with makeRadialBrush
*/

//str_tool = "PERLIN BRUSH"

//PERLIN BRUSH values
//numbers
var num_perlinBrush_baseX:Number = 80;
var num_perlinBrush_baseY:Number = 80;
var num_perlinBrush_seed:Number = 50;
var num_perlinBrush_octaves:Number = 10;
var num_perlinBrush_channelOptions:Number = 7;
//bools
var bool_perlinBrush_fractalNoise:Boolean = false;
var bool_perlinBrush_stitch:Boolean = false;
var bool_perlinBrush_grayScale:Boolean = false;

//UI BOOLS
//draw a randomly generated one, everytime mouse_up
var bool_perlinBrush_drawRandom:Boolean = false;
//drawing noise or perlin
var bool_perlinBrush_drawNoise:Boolean = false;


function perlin_randomValues(){
	//random values
	num_perlinBrush_channelOptions = Math_randomRange(1, 7);
	num_perlinBrush_baseX = Math.floor(Math.random() * 100);
	num_perlinBrush_baseY = Math.floor(Math.random() * 100);
	num_perlinBrush_octaves = Math.floor(Math.random() * 10);
	num_perlinBrush_seed = Math.floor(Math.random() * 100);
		
	//random stitch
	if(Math.random()*100 > 50){
		bool_perlinBrush_stitch = true;
	}else{
		bool_perlinBrush_stitch = false;
	}
	//random fractal noise
	if(Math.random()*100 > 50){
		bool_perlinBrush_fractalNoise = true;
	}else{
		bool_perlinBrush_fractalNoise = false;
	}
	//grayscale
	if(Math.random()*100 > 50){
		bool_perlinBrush_grayScale = true;
	}else{
		bool_perlinBrush_grayScale = false;
	}
	//update UI (incase of draw random)
	perlin_updateUI();
}

function perlin_generateBitmapData(){
	//either "perlin" or "noise"
	//perlin
	//bool_perlinBrush_drawNoise = should it be noise or not
	//draw random
	if(bool_perlinBrush_drawRandom && !bool_perlinBrush_drawNoise){
		perlin_randomValues();
	};
	//default = 7
	var channels: uint = num_perlinBrush_channelOptions;
	//values (set them)
	var baseX:Number = num_perlinBrush_baseX;
	var baseY:Number = num_perlinBrush_baseY;
	var numOctaves:Number = num_perlinBrush_octaves;
	var seed: Number = num_perlinBrush_seed;
	var bool_stitch:Boolean = bool_perlinBrush_stitch;
	var bool_fractalNoise:Boolean = bool_perlinBrush_fractalNoise;
	var bool_grayscale:Boolean = bool_perlinBrush_grayScale;
	//
	if(!bool_perlinBrush_drawNoise){
		bitmapdata_texture = new BitmapData(mc_draw.width, mc_draw.height, false, 0x00FF0000);
		bitmapdata_texture.perlinNoise(baseX, baseY, numOctaves, seed, bool_stitch, bool_fractalNoise, channels, bool_grayscale, null);
	}else{
		bitmapdata_texture = new BitmapData(mc_draw.width, mc_draw.height, false, 0xff000000); 
		bitmapdata_texture.noise(500, 0, 255, channels, false);
	}
}

function reset_perlinBrush(){
	delete_perlinBrush();
	delete_perlin();
	//reset
	setup_perlin();
}

function delete_perlinBrush():void{
	//
	try{
		bitmapdata_tool.dispose();
	}catch(e:Error){
		trace("delete_perlinBrush: bitmapdata_tool.dispose(); error");
	}
}

function delete_perlin():void{
	//
	delete_perlinBrush();
	//delete bitmaps too
	try{
		bitmapdata_texture.dispose();
	}catch(e:Error){
		trace("delete_perlin: bitmapdata_texture.dispose(); error");
	}
}

function setup_perlin(){
	perlin_generateBitmapData();
	makeRadialBrush();
}