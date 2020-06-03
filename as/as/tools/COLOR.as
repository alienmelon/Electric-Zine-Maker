//set and remove color transforms
function set_colorTransform(clip:MovieClip, arrVals:Array){
	clip.transform.colorTransform = new ColorTransform(arrVals[0], arrVals[1], arrVals[2], arrVals[3], arrVals[4], arrVals[5], arrVals[6], arrVals[7]);
};
function reset_colorTransform(clip:MovieClip){
	trace("reset_colorTransform: " + clip.name);
	clip.transform.colorTransform = new ColorTransform();
};

//color matrix
function applyColorMatrix(child: DisplayObject, _redMatrix:Array, _greenMatrix:Array, _blueMatrix:Array, _alphaMatrix:Array){//
	//
	var matrix: Array = new Array();
	matrix = matrix.concat(_redMatrix); // red
	matrix = matrix.concat(_greenMatrix); // green
	matrix = matrix.concat(_blueMatrix); // blue
	matrix = matrix.concat(_alphaMatrix); // alpha
	//
	var filter: ColorMatrixFilter = new ColorMatrixFilter(matrix);
	var filters: Array = new Array();
	filters.push(filter);
	child.filters = filters;
}

//convolution filter (bevel, blur, sharpen, etc...)
function applyConvolutionFilter(child: DisplayObject, matrix: Array, divisor:Number = 9, matrixX:Number = 3, matrixY:Number = 3){
	//matrixX and matrixY are the grid (3x3 grid is default)
	//divisor is multiplier
	var filter: BitmapFilter = new ConvolutionFilter(matrixX, matrixY, matrix, divisor);
	var filters: Array = new Array();
	filters.push(filter);
	child.filters = filters;
}

//RGB shifting
//bitmap is the source bitmap that's added to the clip (must be nested in clip)
//clip is the source movieclip (like mc_draw)
function RGBshift(bitmap:Bitmap, clip:MovieClip, xR:Number = 5, yR:Number = 0, xG:Number = 10, yG:Number = 0, xB:Number = 15, yB:Number = 0) {
	//setup temp bitmaps and bitmapdata
	var r:Bitmap;
	var g:Bitmap;
	var b:Bitmap;
	var _tempBmpData: BitmapData = new BitmapData(clip.width, clip.height, true, 0);
	//drawing...
	r = new Bitmap(_tempBmpData.clone());
	_tempBmpData.draw(clip);//draw temp bmp for first time
	//clone from temp
	r.bitmapData.copyChannel(_tempBmpData, _tempBmpData.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
	g = new Bitmap(r.bitmapData.clone());
	b = new Bitmap(r.bitmapData.clone());
	//set channels (only red green or blue)
	r.bitmapData.copyChannel(_tempBmpData, _tempBmpData.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.RED);
	g.bitmapData.copyChannel(_tempBmpData, _tempBmpData.rect, new Point(), BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
	b.bitmapData.copyChannel(_tempBmpData, _tempBmpData.rect, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
	//set blend modes for fading over image
	r.blendMode = BlendMode.NORMAL;
	g.blendMode = BlendMode.SCREEN;
	b.blendMode = BlendMode.SCREEN;
	
	//add to adjust the random values
	clip.addChild(r);
	clip.addChild(g);
	clip.addChild(b);
	
	//set random values here
	r.x = xR;
	g.x = xG;
	b.x = xB;
	r.y = yR;
	g.y = yG;
	b.y = yB;
	
	//update source bitmap with new values
	//update, copy, and set
	_tempBmpData.draw(clip, null, null, null, null, false);
	bitmap.bitmapData.draw(_tempBmpData, null, null, null, null, false);
	_tempBmpData.dispose();
	//delete and remove everything
	clip.removeChild(r);
	clip.removeChild(g);
	clip.removeChild(b);
	//
	//return bitmap.bitmapData;
};


//blendmodes over a clip
//used in the blend and displacer-izer

//blend modes (universal)
function blendMode_normal(clip:MovieClip){
	clip.blendMode = BlendMode.NORMAL;
	clip.cacheAsBitmap = false;
}
function blendMode_alpha(clip:MovieClip){
	clip.blendMode = BlendMode.ALPHA;
	clip.cacheAsBitmap = false;
}
function blendMode_add(clip:MovieClip){
	clip.blendMode = BlendMode.ADD;
	clip.cacheAsBitmap = true;
};
function blendMode_darken(clip:MovieClip){
	clip.blendMode = BlendMode.DARKEN;
	clip.cacheAsBitmap = true;
}
function blendMode_difference(clip:MovieClip){
	clip.blendMode = BlendMode.DIFFERENCE;
	clip.cacheAsBitmap = true;
}
function blendMode_hardlight(clip:MovieClip){
	clip.blendMode = BlendMode.HARDLIGHT;
	clip.cacheAsBitmap = true;
}
function blendMode_invert(clip:MovieClip){
	clip.blendMode = BlendMode.INVERT;
	clip.cacheAsBitmap = true;
}
function blendMode_lighten(clip:MovieClip){
	clip.blendMode = BlendMode.LIGHTEN;
	clip.cacheAsBitmap = true;
}
function blendMode_multiply(clip:MovieClip){
	clip.blendMode = BlendMode.MULTIPLY;
	clip.cacheAsBitmap = true;
}
function blendMode_overlay(clip:MovieClip){
	clip.blendMode = BlendMode.OVERLAY;
	clip.cacheAsBitmap = true;
}
function blendMode_screen(clip:MovieClip){
	clip.blendMode = BlendMode.SCREEN;
	clip.cacheAsBitmap = true;
}
function blendMode_subtract(clip:MovieClip){
	clip.blendMode = BlendMode.SUBTRACT;
	clip.cacheAsBitmap = true;
}

//filters
function setBlur(clip:MovieClip, numX:Number, numY:Number, numQuality:Number = 1){
	var myBlur:BlurFilter = new BlurFilter();
	myBlur.quality = numQuality;
	myBlur.blurX = numX;
	myBlur.blurY = numY;
	clip.filters = [myBlur];
}

//TOAST EFFECT (burning as you paint)
function sharpenBitmap(bd:BitmapData, num_burnAmnt:Number, bool_outline:Boolean = false, bool_negative:Boolean = false, bool_grayscale:Boolean = false){

	//creates the outlines
	var outlines: BitmapData = bd.clone();
	outlines.applyFilter(outlines, outlines.rect, new Point, sharpen());
	outlines.applyFilter(outlines, outlines.rect, new Point, contrast(num_burnAmnt)); //100
	
	//part of the UI
	//toggle effects for drawing
	if(bool_outline){
		outlines.applyFilter(outlines, outlines.rect, new Point, outline(80));
	}
	if(bool_negative){
		outlines.applyFilter(outlines, outlines.rect, new Point, negative);
	}
	if(bool_grayscale){
		outlines.applyFilter(outlines, outlines.rect, new Point, grayscale);
	}

	//draws the outlines into the bd
	bd.draw(outlines);

	outlines.dispose();
}

//SKETCH EFFECT
function sketch(bd: BitmapData): void {

	// desaturation + brightness + contrast 
	bd.applyFilter(bd, bd.rect, new Point, grayscale); //remove grayscale for a lightening effect
	bd.applyFilter(bd, bd.rect, new Point, brightness(25));
	bd.applyFilter(bd, bd.rect, new Point, contrast(20));
	bd.applyFilter(bd, bd.rect, new Point, brightness(35));

	//creates the outlines
	var outlines: BitmapData = bd.clone();	
	outlines.applyFilter(outlines, outlines.rect, new Point, outline(80));
	outlines.applyFilter(outlines, outlines.rect, new Point, negative);
	outlines.applyFilter(outlines, outlines.rect, new Point, grayscale);

	//draws the outlines into the bd
	bd.draw(outlines, new Matrix(1, 0, 0, 1), new ColorTransform(1, 1, 1, .75), BlendMode.MULTIPLY);

	//creates some additionnal noise
	var noise: BitmapData = bd.clone();
	noise.noise(0, 0, 255, 7, true);

	//draws the extra noise
	bd.draw(noise, new Matrix(1, 0, 0, 1), new ColorTransform(1, 1, 1, 0.15), BlendMode.ADD);

	//clone again and then applyFilter and then draw to...
	//dispose at very end...
	outlines = bd.clone();
	//final contrast pass
	outlines.applyFilter(outlines, outlines.rect, new Point, contrast(50));
	
	bd.draw(outlines);
	//bd.filter = [];
	
	outlines.dispose();

}

//color adjustment (for the sketch filter)
function sharpen(){
	return new ConvolutionFilter(3,3,new Array(0,-1,0,-1,7,-1,0,-1,0),3);
}

function outline(value: Number = 80): ConvolutionFilter {
	var q: Number = value / 4;
	return new ConvolutionFilter(3, 3, [
		0, q, 0,
		q, -value, q,
		0, q, 0
	], 10);
}
function get negative(): ColorMatrixFilter {
	return new ColorMatrixFilter([-1, 0, 0, 0, 0xFF,
		0, -1, 0, 0, 0xFF,
		0, 0, -1, 0, 0xFF,
		0, 0, 0, 1, 0
	]);
}
function get grayscale(): ColorMatrixFilter {
	return new ColorMatrixFilter([
		.3086, .6094, .0820, 0, 0,
		.3086, .6094, .0820, 0, 0,
		.3086, .6094, .0820, 0, 0,
		0, 0, 0, 1, 0
	]);
}
function brightness(value: Number): ColorMatrixFilter {
	return new ColorMatrixFilter([
		1, 0, 0, 0, value,
		0, 1, 0, 0, value,
		0, 0, 1, 0, value,
		0, 0, 0, 1, 0
	]);
}
function contrast(value: Number): ColorMatrixFilter {
	var a: Number = (value * 0.01 + 1)
	var b: Number = 0x80 * (1 - a);
	return new ColorMatrixFilter([
		a, 0, 0, 0, b,
		0, a, 0, 0, b,
		0, 0, a, 0, b,
		0, 0, 0, 1, 0
	]);
}