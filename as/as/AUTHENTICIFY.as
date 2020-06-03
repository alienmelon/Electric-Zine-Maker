
//Floyd, stucki, false floyd...
//TODO: THESE HAVE BEEN REMOVED FOR FIXING

function dither_floyd(_bitmapData:BitmapData, num_amnt:Number, grayscale:Boolean){

}

function dither_falseFloyd(_bitmapData:BitmapData, num_amnt:Number, grayscale:Boolean){

}

function dither_stucki(_bitmapData:BitmapData, num_amnt:Number, grayscale:Boolean){

}

function dither_noDither(_bitmapData:BitmapData, num_amnt:Number, grayscale:Boolean){

}

//DESATURATE AT A LEVEL

function desaturate_dither(bitmapData:BitmapData, level:Number){
	
	
}

///MONOCRHOME IMAGE
//myBitmapData.draw(sendToGray(myBitmapData.width, myBitmapData.height, myBitmapImage));
function sendToGray(w: int, h: int, drawItem): Bitmap {
	var myBitmapData: BitmapData = new BitmapData(w, h);
	myBitmapData.draw(drawItem);

	var bmp: Bitmap = new Bitmap(setGrayScale(myBitmapData));

	return bmp;
}

function setGrayScale(obj: BitmapData): BitmapData {
	
	var rLum: Number = 0.2225;
	var gLum: Number = 0.7169;
	var bLum: Number = 0.0606;

	var matrix: Array = [rLum, gLum, bLum, 0, 0,
		rLum, gLum, bLum, 0, 0,
		rLum, gLum, bLum, 0, 0,
		0, 0, 0, 1, 0
	];

	var filter: ColorMatrixFilter = new ColorMatrixFilter(matrix);
	obj.applyFilter(obj, new Rectangle(0, 0, obj.width, obj.height), new Point(0, 0), filter);

	return obj;
};

//pixelate an image
function filt_pixelate(bmData:BitmapData, bm:Bitmap, blockSize:Number)
{
	var bitmap:Bitmap = new Bitmap( bmData );
	bitmap.smoothing = true;
	//
	var bmd_pixeldiv:BitmapData = new BitmapData(bmData.width/blockSize, bmData.height/blockSize);
	var matrix:Matrix = new Matrix();
	matrix.scale(1/blockSize, 1/blockSize);
	bmd_pixeldiv.draw(bitmap, matrix);
	//  Avoid "bitmap.smoothing = true" here to keep it bmd_pixel
	matrix.invert();  // opposite effect from before
	bmData.draw( bmd_pixeldiv, matrix, null, null, null, false);
	//
	bmd_pixeldiv.dispose();  //  always dispose BitmapData no longer needed
	//
}

//input bitmapData that should be monochromed
function monochrome(bmd: BitmapData): void {
	var bmd_copy: BitmapData = bmd.clone();
	// source pixels will be compared with this value
	var level: uint = 0xFFAAAAAA;
	//
	var rect: Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);
	// The point within the current BitmapData instance that corresponds to the upper-left corner of the source rectangle.
	var dest: Point = new Point();
	//
	bmd.threshold(bmd_copy, rect, dest, ">", level, 0xFFFFFFFF, 0xFFFFFFFF);
	bmd.threshold(bmd_copy, rect, dest, "<=", level, 0xFF000000, 0xFFFFFFFF);
	bmd_copy.dispose();
}

//FIRST HALFTONE, makes image larger to set to halftone, smaller turns it into grayscale with interesting block patterns, good for playing with values and getting a b&w glitch type effect
//Draws a halftone version of a bitmap onto a sprite.
//draw_large_halftone(BitmapData, Bitmap, 1, 0x000000, false, 1, false);

function draw_large_halftone(bmpSource: BitmapData, bmp:Bitmap, pointRadius: int, fgColor: uint, isReversed: Boolean, pointMultiplier: Number, isAlreadyGrayscale: Boolean, restrainSize:Boolean = true) {
	
	var s:Sprite = new Sprite();
	this.addChild(s);

	if (bmpSource == null || s == null) return;

	if (pointRadius <= 0) pointRadius = 5;
	else pointRadius = int(Math.abs(pointRadius));
	if (pointMultiplier <= 0) pointMultiplier = 1;
	else pointMultiplier = Math.abs(pointMultiplier);

	// ==========================================

	var pointRadiusHalf: Number = int(pointRadius / 2);

	var ratio: Number = pointRadius / 256 / 2 * (pointMultiplier * 1.25);
	var ptX: int, ptY: int;
	var thisPx: int, lastPx: int;

	ptY = pointRadiusHalf;

	for (var y: int = 0; y < bmpSource.height; y += 2) {
		// even row:
		ptX = pointRadiusHalf;
		for (var x0: int = 0; x0 < bmpSource.width - 1; x0++) {
			var sca0: int = getBlackLevel(bmpSource.getPixel(x0, y), isReversed, isAlreadyGrayscale);

			var rad0: Number = sca0 * ratio;
			s.graphics.beginFill(fgColor, 1);
			s.graphics.drawCircle(ptX, ptY, rad0);
			s.graphics.endFill();

			ptX += pointRadius;
		}

		// odd row:
		if (y + 1 == bmpSource.height) continue;

		ptX = pointRadius;
		thisPx = getBlackLevel(bmpSource.getPixel(0, y + 1), isReversed, isAlreadyGrayscale);
		for (var x1: int = 1; x1 < bmpSource.width - 1; x1++) {
			lastPx = thisPx;
			thisPx = getBlackLevel(bmpSource.getPixel(x1, y + 1), isReversed, isAlreadyGrayscale);
			var sca1: int = (thisPx + lastPx) / 2;

			var rad1: Number = sca1 * ratio;
			s.graphics.beginFill(fgColor, 1);
			s.graphics.drawCircle(ptX, ptY + pointRadius, rad1);
			s.graphics.endFill();

			ptX += pointRadius;
		}
		ptY += pointRadius * 2;
	}
	
	//trace("ADD AN OPTION TO RESTRAIN THE SIZE");
	if(restrainSize){
		s.width = bmpSource.width;
		s.height = bmpSource.height;
	};
	
	var matrix:Matrix = s.transform.matrix;
	
	bmp.bitmapData.draw(s, matrix, null, null, null, true);
	
	s.graphics.clear();
	this.removeChild(s);
}

function getBlackLevel(v: uint, isReversed: Boolean, isAlreadyGrayscale: Boolean): int {
	if (isAlreadyGrayscale) {
		if (!isReversed) return 255 - (v & 0xff);
		else return (v & 0xff);
	}
	var red: Number = v >> 16;
	var green: Number = v >> 8 & 0xff;
	var blue: Number = v & 0xff;

	if (!isReversed) return 255 - int((red + green + blue) / 3);
	else return int((red + green + blue) / 3);
};

function draw_default_halftone(bmData:BitmapData, bmp:Bitmap, sampleSize:int, brushSize:int) {

	//values
	var pixelsTall: uint = bmData.height;
	var pixelsWide: uint = bmData.width;
	var rect: Rectangle = new Rectangle(0, 0, sampleSize, sampleSize);
	var totalBytesToScan: uint = pixelsWide * pixelsTall;
	var position: uint = 0;
	var offset: Number = sampleSize * 0.5;
	var averageColor: uint;
	var pixels: Vector.<uint>;
	var darks: Number;
	var scale: Number;
	
	var halftone: Shape = new Shape();

	while (position <= totalBytesToScan) {
		pixels = bmData.getVector(rect);
		averageColor = grayScaleAverage(pixels);
		darks = brightness(averageColor);
		if (darks > 0) {
			halftone.graphics.beginFill(averageColor, 1);
			scale = (255 - darks) / 255;
			halftone.graphics.drawCircle(rect.x + offset, rect.y + offset, scale * brushSize);
		}
		if (rect.x >= pixelsWide) {
			rect.x = 0;
			rect.y += sampleSize;
		} else {
			rect.x += sampleSize;
		}
		position += sampleSize * sampleSize;
	}

	function brightness(color: uint): int {
		var R: uint = color >> 16 & 0xff;
		var G: uint = color >> 8 & 0xff;
		var B: uint = color & 0xff;
		return int(0.2126 * R + 0.7152 * G + 0.0722 * B);
	}

	function rgbAverage(pixels: Vector.<uint> ): uint {
		var color: uint;
		var pixelLength: int = pixels.length;
		var averageR: uint = 0;
		var averageG: uint = 0;
		var averageB: uint = 0;
		while (--pixelLength >= 0) {
			color = pixels[pixelLength];
			averageR += color >> 16 & 0xFF;
			averageG += color >> 8 & 0xFF;
			averageB += color & 0xFF;
		}
		averageR /= pixels.length;
		averageG /= pixels.length;
		averageB /= pixels.length;
		color = averageR << 16 | averageG << 8 | averageB;
		return color;
	}

	function grayScaleAverage(pixels: Vector.<uint> ): uint {
		var color: uint;
		var pixelLength: int = pixels.length;
		var averageR: uint;
		var averageG: uint;
		var averageB: uint;
		while (--pixelLength >= 0) {
			color = pixels[pixelLength];
			averageR += color >> 16 & 0xFF;
			averageG += color >> 8 & 0xFF;
			averageB += color & 0xFF;
		}
		averageR /= pixels.length;
		averageG /= pixels.length;
		averageB /= pixels.length;
		var luma: int = averageR * 0.3 + averageG * 0.59 + averageB * 0.11;
		color = luma << 16 | luma << 8 | luma;
		return color;
	};
	
	//update bitmaps and clear sprites
	this.addChild(halftone);
	
	var matrix:Matrix = halftone.transform.matrix;
	
	bmp.bitmapData.draw(halftone, matrix, null, null, null, true);
	
	halftone.graphics.clear();
	this.removeChild(halftone);
	
};

/////REDUCE COLORS
//reduceColors(myBitmapData, 4, false, true);
//toCGA(myBitmapData, true, true);
function reduceColors(img: BitmapData, number: int = 16, grayScale: Boolean = false, affectAlpha: Boolean = false): void {
	var i: int;
	var j: int = 0;

	var val: int = 0;


	var total: int = 255;
	number -= 2;
	if (number <= 0) number = 1;
	if (number >= 255) number = 254;

	var step: Number = total / number;
	var offset: Number = (total - (total / (number + 1))) / total;
	var values: Array = [];
	for (i = 0; i < total; i++) {

		if (i >= (j * step * offset)) {
			j++;
		}
		values.push(Math.floor((Math.ceil(j * step) - step)));

	}
	var a: int;
	var r: int;
	var g: int;
	var b: int;
	var c: int;

	var iw: int = img.width;
	var ih: int = img.height;

	img.lock();

	if (affectAlpha) {
		// GRAYSCALE WITH ALPHA AFFECTED
		if (grayScale) {
			for (i = 0; i < iw; i++) {
				for (j = 0; j < ih; j++) {

					val = img.getPixel32(i, j);

					a = values[ (val >>> 24) - 1];
					r = values[ (val >>> 16 & 0xFF) - 1];
					g = values[(val >>> 8 & 0xFF) - 1];
					b = values[(val & 0xFF) - 1];
					c = Math.ceil(((r + g + b) / 3));
					img.setPixel32(i, j, (a << 24 | c << 16 | c << 8 | c));

				}
			}

		} else {

			// COLORS WITH ALPHA AFFECTED
			for (i = 0; i < iw; i++) {
				for (j = 0; j < ih; j++) {

					val = img.getPixel32(i, j);

					a = values[ (val >>> 24) - 1];
					r = values[ (val >>> 16 & 0xFF) - 1];
					g = values[(val >>> 8 & 0xFF) - 1];
					b = values[(val & 0xFF) - 1];

					img.setPixel32(i, j, (a << 24 | r << 16 | g << 8 | b));

				}
			}
		}

	} else {

		// GRAYSCALE WITH ALPHA NOT AFFECTED
		if (grayScale) {
			for (i = 0; i < iw; i++) {
				for (j = 0; j < ih; j++) {

					val = img.getPixel32(i, j);

					r = values[ (val >>> 16 & 0xFF) - 1];
					g = values[(val >>> 8 & 0xFF) - 1];
					b = values[(val & 0xFF) - 1];
					c = Math.ceil(((r + g + b) / 3));
					img.setPixel32(i, j, ((val >>> 24) << 24 | c << 16 | c << 8 | c));

				}
			}

		} else {

			// COLORS WITH ALPHA NOT AFFECTED
			for (i = 0; i < iw; i++) {
				for (j = 0; j < ih; j++) {

					val = img.getPixel32(i, j);

					r = values[ (val >>> 16 & 0xFF) - 1];
					g = values[(val >>> 8 & 0xFF) - 1];
					b = values[(val & 0xFF) - 1];

					img.setPixel32(i, j, ((val >>> 24) << 24 | r << 16 | g << 8 | b));

				}
			}
		}
	}
	img.unlock();

}
//
function toCGA(bmpd: BitmapData, grayscale: Boolean = false, alpha: Boolean = false): void {
	reduceColors(bmpd, 0, grayscale, alpha);
}
function toEGA(bmpd: BitmapData, grayscale: Boolean = false, alpha: Boolean = false): void {
	reduceColors(bmpd, 4, grayscale, alpha);
}
function toHAM(bmpd: BitmapData, grayscale: Boolean = false, alpha: Boolean = false): void {
	reduceColors(bmpd, 6, grayscale, alpha);
}
function toVGA(bmpd: BitmapData, grayscale: Boolean = false, alpha: Boolean = false): void {
	reduceColors(bmpd, 8, grayscale, alpha);
}
function toSVGA(bmpd: BitmapData, grayscale: Boolean = false, alpha: Boolean = false): void {
	reduceColors(bmpd, 16, grayscale, alpha);
}

