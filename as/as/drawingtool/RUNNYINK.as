//the RUNNY INK tool
//ink expands as you draw, with color combinations depending on color choices
//convolution is repeatedly applied to pixels
//this draws on a bitmap (bitmap_tool) that's placed over the canvas, when drawing is done it's drawn to the canvas then reset
//str_tool = "RUNNY INK"
//

//RUNNY INK//
var num_runnyInkSize:Number = 20;
var num_runnyInkAlpha:Number = 50;
//convolution filter for RUNNY INK
var runnyInk_CF_clamp: Boolean = true;
var runnyInk_CF_clampColor: Number = 0x000000;
var runnyInk_CF_clampAlpha: Number = 1;
var runnyInk_CF_bias: Number = -1;
var runnyInk_CF_preserveAlpha: Boolean = false;
var runnyInk_CF_matrixCols: Number = 3;
var runnyInk_CF_matrixRows: Number = 3;
var runnyInk_CF_matrix: Array = [1, 1, 1,
								1, 1, 1,
								2, 1, 1
										];
var runnyInk_convolutionFilter: ConvolutionFilter = new ConvolutionFilter(runnyInk_CF_matrixCols, runnyInk_CF_matrixRows, runnyInk_CF_matrix, runnyInk_CF_matrix.length, runnyInk_CF_bias, runnyInk_CF_preserveAlpha, runnyInk_CF_clamp, runnyInk_CF_clampColor, runnyInk_CF_clampAlpha);
//var runnyInk_convolutionFilter:ConvolutionFilter = new ConvolutionFilter(3, 3, [1, 1, 1, 1, 1, 1, 1, 1, 1]);


//completely delete
function delete_runnyInk(){
	//clear all
	//bitmap, remove...
	try{
		bitmapdata_tool.dispose();
	}catch(e:Error){
		trace("delete_runnyInk: bitmapdata_tool.dispose error");
	}
	//
	try{
		mc_draw.removeChild(bitmap_tool);
	}catch(e:Error){
		trace("delete_runnyInk: removeChild(bitmap_tool) error");
	}
}

//setup or reset...
function setup_runyInk(){
	//call first, in case...
	delete_runnyInk();
	//setup...
	bitmapdata_tool = new BitmapData(mc_draw.width, mc_draw.height, true, 0xffffff);
	bitmap_tool = new Bitmap(bitmapdata_tool, "auto", false);
	//add
	mc_draw.addChild(bitmap_tool);
	//update clamp color
}

//usage: in mouse MOVE draw_runnyInk(event.localX, event.localY);
function draw_runnyInk(event_localX:Number, event_localY:Number): void {
	
	var mp: Matrix = new Matrix();
	mp.tx = event_localX;
	mp.ty = event_localY;
	
	var col = hex_to_ARGB(selected_color , num_runnyInkAlpha);
	
	for (var i:uint = 0; i < 100; i++) {
		var x_:uint = event_localX + Math.random() * num_runnyInkSize - (num_runnyInkSize/2);
		var y_:uint = event_localY + Math.random() * num_runnyInkSize - (num_runnyInkSize/2);
		bitmapdata_tool.setPixel32(x_, y_, col);
	}
	
	bitmapdata_tool.applyFilter(bitmapdata_tool, bitmapdata_tool.rect, new Point(0, 0), runnyInk_convolutionFilter);
	//bitmapdata_tool.applyFilter(bitmapdata_tool, bitmapdata_tool.rect, new Point(0, 0), perlinChalk_BF);
}