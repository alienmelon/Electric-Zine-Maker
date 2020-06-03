/*
(LOOK AT LITERALLY EVERYTHING I MADE AND COLLECTED -- ALL THE NOTES, esp GLITCHMAP)
[Threshold / Monochrome] (no values -- was kurt kobain lactose intollerant? 
[desaturate_dither] (values -- anarchist literature
[Halftones] (values -- better quality anarchist literature
[Tiny Halftones]
[Floyd] (all the floyds with values -- images sourced from netscape navigator
[FalseFloyd]
[Stucki]
[Pixel Art] (with values of size of pixel -- instant pixel art
[ReduceColors -- toCGA, etc...] -- adjust some colors reduce channels...



[Ascii Art] (values)

AFTER HALFTONES MAKE A PIXELATE ONE WHERE U SET SIZE OF PIXELS!!! SEE GOGOFISH!!!

[FalseFloyd]
[Dither] //ALL THE ONES FROM GOGOFISH (FLOYDTEST)
[Purely for demo purposes (no dither)]
[Stucki]
[Displace the Pixels]
[Pixelate (from gogofish)]

reduce colors
*/

/*
window opens:
add authenticity??
to your zine!!
select an authenticify effect
*/

/*
TODO: ALLOW FOR EFFECT STACKING
*/

//values for authenticity
//PUNK AESTHETIC
//(Desaturate Dither)
var auth_num_desaturate:Number = 2;
var auth_bool_desaturate:Boolean = false;
//NETSCAPE NAVIGATOR
//(Floyd)
var auth_num_floyd:Number = 2;
var auth_bool_floyd:Boolean = false;
//(Dither)
var auth_num_dither:Number = 2;
var auth_bool_dither:Boolean = false;
//(Stucki)
var auth_num_stucki:Number = 2;
var auth_bool_stucki:Boolean = false;
//BAD PRINTSHOP
//(Bad Halfotnes)
var auth_num_badHalftone_pointRadius:Number = 1;
var auth_num_badHalftone_pointMultiplier:Number = 1;
var auth_col_badHalftone = 0xFFFFFF;
var auth_bool_badHalftone_invert:Boolean = false;
var auth_bool_badHalftone_grayscale:Boolean = false;
//(Good Halftones)
var auth_num_goodHalftone_sample:Number = 4;
var auth_num_goodHalftone_brushsize:Number = 3;
//Nice Things (Instant Pixel Art)
var auth_num_pixelSize:Number = 5;
//Color Management (Reduce Colors)
var auth_num_reduceColor:Number = 2;
var auth_bool_reduceColor:Boolean = false;

//Authenticity UI specific

//UI SPECIFIC
function auth_reduceColors(){
	authentic_resetBitmap();
	reduceColors(bitmapData_canvasDemo, auth_num_reduceColor, auth_bool_reduceColor, false);
}

function auth_pixelArt(){
	authentic_resetBitmap();
	filt_pixelate(bitmapData_canvasDemo, bitmap_canvasDemo, auth_num_pixelSize);
}

function auth_goodHalftone(){
	authentic_resetBitmap();
	draw_default_halftone(bitmapData_canvasDemo, bitmap_canvasDemo, auth_num_goodHalftone_sample, auth_num_goodHalftone_brushsize);
}

function auth_badHalftone(){
	authentic_resetBitmap();
	draw_large_halftone(bitmapData_canvasDemo, bitmap_canvasDemo, auth_num_badHalftone_pointRadius, auth_col_badHalftone, auth_bool_badHalftone_invert, auth_num_badHalftone_pointMultiplier, auth_bool_badHalftone_grayscale, true);
}

function auth_floyd(){
	authentic_resetBitmap();
	dither_floyd(bitmapData_canvasDemo, auth_num_floyd, auth_bool_floyd);
}

function auth_dither(){
	authentic_resetBitmap();
	dither_noDither(bitmapData_canvasDemo, auth_num_dither, auth_bool_dither);
}

function auth_stucki(){
	authentic_resetBitmap();
	dither_stucki(bitmapData_canvasDemo, auth_num_stucki, auth_bool_stucki);
}

function auth_desaturate(){
	authentic_resetBitmap();
	desaturate_dither(bitmapData_canvasDemo, auth_num_desaturate);
}