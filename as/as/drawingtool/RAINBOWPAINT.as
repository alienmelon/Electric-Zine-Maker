/*
Rainbow Paint is a tool that lets you draw gradient lines
it's an extended version of the default drawing (pen) tool
you can customize the gradient, and choose colors
you can choose between linear or radial gradients
this is a very simple tool
*/

//str_tool = "RAINBOW PAINT";

//RAINBOW PAINT (GRADIENT BRUSH)
//create arrays
//populate acording to length of color (alpha and ratio for each)
//increment ratios accurately (evenly spread chosen colors)
var arr_rainbowColor: Array = new Array(0xFF0000, 0x0000FF, 0x00FF00, 0xFFFF00, 0x0000FF, 0xFFFF00);// !!!MENU ITEM
//this array draws from the above color array and sets that as a color transform value for the tabs in the UI
var arr_rainbowColorTransform:Array = new Array(new ColorTransform(), new ColorTransform(), new ColorTransform(), new ColorTransform(), new ColorTransform(), new ColorTransform());
//populate based on color array
var arr_rainbowAlphas: Array = new Array();
var arr_rainbowRatios: Array = new Array();
//!!!MENU ITEM
var rainbowGradientType = GradientType.RADIAL; //GradientType.LINEAR or GradientType.RADIAL
var rainbowSpreadMethod = SpreadMethod.REPEAT; //SpreadMethod.PAD	SpreadMethod.REFLECT	SpreadMethod.REPEAT
var rainbowInterpolationMethod = InterpolationMethod.LINEAR_RGB; //InterpolationMethod.LINEAR_RGB	InterpolationMethod.RGB
var num_rainbowGradientWidth:Number = mc_draw.width;
var num_rainbowGradientHeight:Number = mc_draw.height;
var num_rainbowGradientX:Number = 0;//make min 0, and max the max width of stage
var num_rainbowGradientY:Number = 0;//make min 0, and max the max height of stage
/*focalPointRatio:Number (default = 0) — A number that controls the location of the focal point of the gradient. (stretch)
The value 0 means the focal point is in the center. 
The value 1 means the focal point is at one border of the gradient circle. 
The value -1 means that the focal point is at the other border of the gradient circle. 
Values less than -1 or greater than 1 are rounded to -1 or 1. 
The following image shows a gradient with a focalPointRatio of -0.75: */
var num_rainbowGradientOffset:Number = 0;//extra value that tweaks the focal point
//var num_rainbowFocalPointRatio:Number = 0; //from -100 - 100, convert to decimal, 0 = center
////////////RAINBOW LINES UI STRINGS////////////
//currently selected color tab (check against)
var str_currRainbowColor:String = "1";
/////////////////////////////

//init the colors (setup)
//call this before starting
function rainbowPaint_initColors(){
	//populate based on color array
	var l: int = arr_rainbowColor.length;
	//reset first
	arr_rainbowAlphas = [];
	arr_rainbowRatios = [];
	//
	for (var i: int = 0; i < l; i++) {
		arr_rainbowAlphas.push(pen_alpha);//1 is default
		arr_rainbowRatios.push((0xFF / l) * i + 1);
	}
}

//ON MOUSE DOWN/MOVE
//draw_rainbowPaint(event.localX, event.localY);
function draw_rainbowPaint(_mouseX:Number, _mouseY:Number){
	//
	penSprite.graphics.lineStyle(num_pen_size);
	//
	var gradientBoxMatrix: Matrix = new Matrix();
	gradientBoxMatrix.createGradientBox(num_rainbowGradientWidth, num_rainbowGradientHeight, num_rainbowGradientOffset, num_rainbowGradientX, num_rainbowGradientY);
	//
	penSprite.graphics.lineGradientStyle(
		rainbowGradientType,
		arr_rainbowColor,
		arr_rainbowAlphas,
		arr_rainbowRatios,
		gradientBoxMatrix,
		rainbowSpreadMethod,
		rainbowInterpolationMethod,
		num_rainbowGradientOffset
	);
	//draw it, send to bitmap, clear after
	//TODO: (if you want the alpha mode not to have the texture, then don't clear canvas right after drawing.
	//clear only on mouse up.)
	penSprite.graphics.moveTo(num_prevMouseX, num_prevMouseY);
	penSprite.graphics.lineTo(_mouseX, _mouseY);
	canvasBitmapData.draw(penSprite);
	penSprite.graphics.clear();
	num_prevMouseX = _mouseX;
	num_prevMouseY = _mouseY;
}