/*
COLOR FACTORY itself is primarily UI, so everything is in _DRAWING_UI.as
the UI gives you access (and ability to customize) various effects to apply to the canvas
these effects are largely based on older Flash experiments that used to be popular,
and kind of defined the experimental Flash aesthetic (prelude to processing community experiments)
most of these effects where like code-memes. everyone had their own take at re-creating them.
some of these are captured in the COLOR FACTORY
see COLOR.as...
*/

//str_tool = "COLOR FACTORY"

//COLOR FACTORY VARS
var num_color_factory_dialogue:Number = 0; //current dialogue from the color factory
var num_color_factory_shuffle_ARROWS:Number = 0; //stepping up/down arr_color_factory_shuffle_valsWH for the shuffle Tile size field
var str_color_factory_MIRROR_TYPE:String = "0"; //currently selected mirror mode: 0, 1, 2, 3, or RANDOM
//
var color_factory_window = mc_color_factory.mc_settings;
//values related to color factory (clips and numbers)
var arr_color_factory_shuffle_valsWH:Array = new Array([5, 7], [7, 10], [15, 21], [27, 39], [46, 65]);
//
var arr_color_factory_allFields:Array = new Array(color_factory_window.btn_asciiart_save, color_factory_window.btn_asciiart_clipboard, color_factory_window.txt_perlin_baseX, color_factory_window.txt_perlin_baseY, color_factory_window.txt_perlin_numOctaves, color_factory_window.txt_perlin_randomSeed, color_factory_window.txt_perlin_stitch, color_factory_window.txt_perlin_fractalNoise, color_factory_window.txt_perlin_channelOptions, color_factory_window.txt_perlin_grayScale, color_factory_window.txt_perlin_scale, color_factory_window.txt_perlin_RANDOM, color_factory_window.txt_perlin_tip, color_factory_window.txt_mirror, color_factory_window.btn_mirror_01, color_factory_window.btn_mirror_02, color_factory_window.btn_mirror_03, color_factory_window.btn_mirror_04, color_factory_window.btn_mirror_05, color_factory_window.btn_asciiart,  color_factory_window.txt_asciiart, color_factory_window.txt_shuffle_spacing, color_factory_window.txt_shuffle_spacing_x, color_factory_window.txt_shuffle_spacing_y, color_factory_window.txt_shuffle_size, color_factory_window.txt_shuffle_RANDOM, color_factory_window.btn_shuffle, color_factory_window.btn_pixelblast, color_factory_window.txt_pixelblast, color_factory_window.txt_colorTransform_redMultiplier, color_factory_window.txt_colorTransform_redOffset, color_factory_window.txt_colorTransform_greenMultiplier, color_factory_window.txt_colorTransform_greenOffset, color_factory_window.txt_colorTransform_blueMultiplier, color_factory_window.txt_colorTransform_blueOffset, color_factory_window.txt_colorTransform_alphaMultiplier, color_factory_window.txt_colorTransform_alphaOffset, color_factory_window.txt_colorTransform_RANDOM, color_factory_window.txt_colorTransform_instructions, color_factory_window.txt_rgbshift_RED, color_factory_window.txt_rgbshift_GREEN, color_factory_window.txt_rgbshift_BLUE, color_factory_window.txt_rgbshift_RANDOM, color_factory_window.txt_rgbshift_RED_X, color_factory_window.txt_rgbshift_RED_Y, color_factory_window.txt_rgbshift_GREEN_X, color_factory_window.txt_rgbshift_GREEN_Y, color_factory_window.txt_rgbshift_BLUE_X, color_factory_window.txt_rgbshift_BLUE_Y, color_factory_window.txt_convolution_MATRIX, color_factory_window.txt_convolution_MULTIPLIER, color_factory_window.txt_convolution_RANDOM, color_factory_window.txt_colorMatrix_RANDOM, color_factory_window.txt_colorMatrix_INSTRUCTIONS, color_factory_window.txt_colorMatrix_ALPHA, color_factory_window.txt_colorMatrix_BLUE, color_factory_window.txt_colorMatrix_GREEN, color_factory_window.txt_colorMatrix_RED, color_factory_window.txt_blurX, color_factory_window.txt_blurY, color_factory_window.txt_blurX_input, color_factory_window.txt_blurY_input);
//color matrix input fields
var arr_color_factory_colorMatrixInputFields:Array = new Array(color_factory_window.txt_colorMatrix_RED_01, color_factory_window.txt_colorMatrix_RED_02, color_factory_window.txt_colorMatrix_RED_03, color_factory_window.txt_colorMatrix_RED_04, color_factory_window.txt_colorMatrix_RED_05, color_factory_window.txt_colorMatrix_GREEN_01, color_factory_window.txt_colorMatrix_GREEN_02, color_factory_window.txt_colorMatrix_GREEN_03, color_factory_window.txt_colorMatrix_GREEN_04, color_factory_window.txt_colorMatrix_GREEN_05, color_factory_window.txt_colorMatrix_BLUE_01, color_factory_window.txt_colorMatrix_BLUE_02, color_factory_window.txt_colorMatrix_BLUE_03, color_factory_window.txt_colorMatrix_BLUE_04, color_factory_window.txt_colorMatrix_BLUE_05, color_factory_window.txt_colorMatrix_ALPHA_01, color_factory_window.txt_colorMatrix_ALPHA_02, color_factory_window.txt_colorMatrix_ALPHA_03, color_factory_window.txt_colorMatrix_ALPHA_04, color_factory_window.txt_colorMatrix_ALPHA_05);
//convolution filter input and arrows
var arr_color_factory_convolution_ARROWS:Array = new Array(color_factory_window.btn_convolution_matrix_01_UP, color_factory_window.btn_convolution_matrix_01_DOWN, color_factory_window.btn_convolution_matrix_02_UP, color_factory_window.btn_convolution_matrix_02_DOWN, color_factory_window.btn_convolution_matrix_03_UP, color_factory_window.btn_convolution_matrix_03_DOWN, color_factory_window.btn_convolution_matrix_04_UP, color_factory_window.btn_convolution_matrix_04_DOWN, color_factory_window.btn_convolution_matrix_05_UP, color_factory_window.btn_convolution_matrix_05_DOWN, color_factory_window.btn_convolution_matrix_06_UP, color_factory_window.btn_convolution_matrix_06_DOWN, color_factory_window.btn_convolution_matrix_07_UP, color_factory_window.btn_convolution_matrix_07_DOWN, color_factory_window.btn_convolution_matrix_08_UP, color_factory_window.btn_convolution_matrix_08_DOWN, color_factory_window.btn_convolution_matrix_09_UP, color_factory_window.btn_convolution_matrix_09_DOWN, color_factory_window.btn_convolution_multiplyer_01_UP, color_factory_window.btn_convolution_multiplyer_01_DOWN);
var arr_color_factory_convolution_INPUTS:Array = new Array(color_factory_window.txt_convolution_matrix_01, color_factory_window.txt_convolution_matrix_02, color_factory_window.txt_convolution_matrix_03, color_factory_window.txt_convolution_matrix_04, color_factory_window.txt_convolution_matrix_05, color_factory_window.txt_convolution_matrix_06, color_factory_window.txt_convolution_matrix_07, color_factory_window.txt_convolution_matrix_08, color_factory_window.txt_convolution_matrix_09, color_factory_window.txt_convolution_multiplyer_01);
//rgb color shifting
var arr_color_factory_RGBshift_ARROWS:Array = new Array(color_factory_window.btn_rgbshift_RED_X_INPUT_UP, color_factory_window.btn_rgbshift_RED_X_INPUT_DOWN, color_factory_window.btn_rgbshift_RED_Y_INPUT_UP, color_factory_window.btn_rgbshift_RED_Y_INPUT_DOWN, color_factory_window.btn_rgbshift_GREEN_X_INPUT_UP, color_factory_window.btn_rgbshift_GREEN_X_INPUT_DOWN, color_factory_window.btn_rgbshift_GREEN_Y_INPUT_UP, color_factory_window.btn_rgbshift_GREEN_Y_INPUT_DOWN, color_factory_window.btn_rgbshift_BLUE_X_INPUT_UP, color_factory_window.btn_rgbshift_BLUE_X_INPUT_DOWN, color_factory_window.btn_rgbshift_BLUE_Y_INPUT_UP, color_factory_window.btn_rgbshift_BLUE_Y_INPUT_UP_DOWN);
var arr_color_factory_RGBshift_INPUTS:Array = new Array(color_factory_window.txt_rgbshift_RED_X_INPUT, color_factory_window.txt_rgbshift_RED_Y_INPUT, color_factory_window.txt_rgbshift_GREEN_X_INPUT, color_factory_window.txt_rgbshift_GREEN_Y_INPUT, color_factory_window.txt_rgbshift_BLUE_X_INPUT, color_factory_window.txt_rgbshift_BLUE_Y_INPUT);
//color transform inputs
var arr_color_factory_ColorTransform_INPUTS:Array = new Array(color_factory_window.txt_colorTransform_redMultiplier_INPUT, color_factory_window.txt_colorTransform_redOffset_INPUT, color_factory_window.txt_colorTransform_greenMultiplier_INPUT, color_factory_window.txt_colorTransform_greenOffset_INPUT, color_factory_window.txt_colorTransform_blueMultiplier_INPUT, color_factory_window.txt_colorTransform_blueOffset_INPUT, color_factory_window.txt_colorTransform_alphaMultiplier_INPUT, color_factory_window.txt_colorTransform_alphaOffset_INPUT);
//shuffle inputes (shuffle bitmap)
var arr_color_factory_Shuffle_INPUTS:Array = new Array(color_factory_window.txt_shuffle_spacing_x_INPUT, color_factory_window.txt_shuffle_spacing_y_INPUT, color_factory_window.txt_shuffle_size_rows_INPUT, color_factory_window.txt_shuffle_size_cols_INPUT);
var arr_color_factory_Shuffle_ARROWS:Array = new Array(color_factory_window.txt_shuffle_spacing_INPUT_UP, color_factory_window.txt_shuffle_spacing_INPUT_DOWN, color_factory_window.txt_shuffle_size_INPUT_UP, color_factory_window.txt_shuffle_size_INPUT_DOWN);
//perlin noise texture
var arr_color_factory_PerinTexture_INPUTS:Array = new Array(color_factory_window.txt_perlin_baseX_INPUT, color_factory_window.txt_perlin_baseY_INPUT, color_factory_window.txt_perlin_numOctavesINPUT, color_factory_window.txt_perlin_randomSeed_INPUT, color_factory_window.txt_perlin_channelOptions_INPUT, color_factory_window.txt_perlin_scale_INPUT);
//perlin noise bools
var arr_color_factory_PerlinTexture_BOOLS:Array = new Array(color_factory_window.txt_perlin_fractalNoise_INPUT, color_factory_window.txt_perlin_stitch_INPUT, color_factory_window.txt_perlin_grayScale_INPUT);
//fuzzy fields (all)
var arr_color_factory_fuzzyFields:Array = new Array(color_factory_window.txt_fuzzy_speed_INPUT, color_factory_window.txt_fuzzy_segment_INPUT, color_factory_window.txt_fuzzy_length_INPUT, color_factory_window.txt_fuzzy_fuzziness_INPUT, color_factory_window.txt_fuzzy_random_INPUT, color_factory_window.txt_fuzzy_unruly_INPUT, color_factory_window.txt_fuzzy_badhair_INPUT, color_factory_window.txt_fuzzy_how, color_factory_window.btn_grow, color_factory_window.btn_reset_hair, color_factory_window.txt_fuzzy_speed, color_factory_window.txt_fuzzy_segment, color_factory_window.txt_fuzzy_length, color_factory_window.txt_fuzzy_unruly, color_factory_window.txt_fuzzy_badhair, color_factory_window.txt_fuzzy_RANDOM, color_factory_window.txt_fuzzy_fuzziness, color_factory_window.txt_fuzzy_random);
var arr_color_factory_fuzzy_BOOLS:Array = new Array(color_factory_window.txt_fuzzy_unruly_INPUT, color_factory_window.txt_fuzzy_badhair_INPUT);
var arr_color_factory_fuzzy_INPUTS:Array = new Array(color_factory_window.txt_fuzzy_speed_INPUT, color_factory_window.txt_fuzzy_segment_INPUT, color_factory_window.txt_fuzzy_length_INPUT, color_factory_window.txt_fuzzy_fuzziness_INPUT, color_factory_window.txt_fuzzy_random_INPUT);
/////////////////////////////

//setting and refreshing filters, and drawing to bitmap
//all else is in UI because it's entirely UI related

function color_factory_resetAllFilters(bool_clearTemp:Boolean = false){
	//
	mc_draw.filters = [];
	reset_colorTransform(mc_draw);
	bool_isMouseDown = false;
	//clear fuzzy
	deleteFuzzy();
	//clear temp bitmaps from the temp bitmap array
	//only done if you save the image -- so it doesn't full reset
	//all other cases use color_factory_resetTempBitmaps
	if(bool_clearTemp){
		arr_savedBitmaps = [];
	};
};

function color_factory_resetTempBitmaps(bool_clear:Boolean = true){
	//reset demo bitmap to saved version before modidying it
	//only if bool_resetBitmap is true, else don't mess with the array
	try{
		//pass it a value and only set back to ending one
		//if constantly refresh then it loses the source when you are paging up and down the values
		//may want to loop through...
		//this is similar to undo levels
		update_bitmaps_from(arr_savedBitmaps[arr_savedBitmaps.length-1], bitmapData_canvasDemo, bitmap_canvasDemo);
		if(bool_clear){
			arr_savedBitmaps = [];
		};
		//
	}catch(e:Error){
		trace("color_factory_resetAllFilters: Invalid BitmapData");
	}
}

function color_factory_refreshColorMatrix(){
	color_factory_resetAllFilters();
	applyColorMatrix(mc_draw, [color_factory_window.txt_colorMatrix_RED_01.text, color_factory_window.txt_colorMatrix_RED_02.text, color_factory_window.txt_colorMatrix_RED_03.text, color_factory_window.txt_colorMatrix_RED_04.text, color_factory_window.txt_colorMatrix_RED_05.text], [color_factory_window.txt_colorMatrix_GREEN_01.text, color_factory_window.txt_colorMatrix_GREEN_02.text, color_factory_window.txt_colorMatrix_GREEN_03.text, color_factory_window.txt_colorMatrix_GREEN_04.text, color_factory_window.txt_colorMatrix_GREEN_05.text], [color_factory_window.txt_colorMatrix_BLUE_01.text, color_factory_window.txt_colorMatrix_BLUE_02.text, color_factory_window.txt_colorMatrix_BLUE_03.text, color_factory_window.txt_colorMatrix_BLUE_04.text, color_factory_window.txt_colorMatrix_BLUE_05.text], [color_factory_window.txt_colorMatrix_ALPHA_01.text, color_factory_window.txt_colorMatrix_ALPHA_02.text, color_factory_window.txt_colorMatrix_ALPHA_03.text, color_factory_window.txt_colorMatrix_ALPHA_04.text, color_factory_window.txt_colorMatrix_ALPHA_05.text]);
}

function color_factory_refreshConvolution(){
	color_factory_resetAllFilters();
	applyConvolutionFilter(mc_draw, [color_factory_window.txt_convolution_matrix_01.text, color_factory_window.txt_convolution_matrix_02.text, color_factory_window.txt_convolution_matrix_03.text, color_factory_window.txt_convolution_matrix_04.text, color_factory_window.txt_convolution_matrix_05.text, color_factory_window.txt_convolution_matrix_06.text, color_factory_window.txt_convolution_matrix_07.text, color_factory_window.txt_convolution_matrix_08.text, color_factory_window.txt_convolution_matrix_09.text], color_factory_window.txt_convolution_multiplyer_01.text);
}

function color_factory_refreshColorTransform(){
	color_factory_resetAllFilters();
	set_colorTransform(mc_draw, [color_factory_window.txt_colorTransform_redMultiplier_INPUT.text, color_factory_window.txt_colorTransform_greenMultiplier_INPUT.text, color_factory_window.txt_colorTransform_blueMultiplier_INPUT.text, color_factory_window.txt_colorTransform_alphaMultiplier_INPUT.text, color_factory_window.txt_colorTransform_redOffset_INPUT.text, color_factory_window.txt_colorTransform_greenOffset_INPUT.text, color_factory_window.txt_colorTransform_blueOffset_INPUT.text, color_factory_window.txt_colorTransform_alphaOffset_INPUT.text]);
}

function color_factory_refreshRGBshift(){
	//
	color_factory_resetTempBitmaps(false);
	RGBshift(bitmap_canvasDemo, mc_draw, color_factory_window.txt_rgbshift_RED_X_INPUT.text, color_factory_window.txt_rgbshift_RED_Y_INPUT.text, color_factory_window.txt_rgbshift_GREEN_X_INPUT.text, color_factory_window.txt_rgbshift_GREEN_Y_INPUT.text, color_factory_window.txt_rgbshift_BLUE_X_INPUT.text, color_factory_window.txt_rgbshift_BLUE_Y_INPUT.text);
}

function color_factory_refreshPixelBlast(){
	//
	pixelblast(bitmapData_canvasDemo);
	//
}

function color_factory_refreshShuffle(){
	//call but without clearing or refreshing
	shuffle_bitmap(bitmap_canvasDemo, mc_draw, color_factory_window.txt_shuffle_spacing_x_INPUT.text, color_factory_window.txt_shuffle_spacing_y_INPUT.text, color_factory_window.txt_shuffle_size_rows_INPUT.text, color_factory_window.txt_shuffle_size_cols_INPUT.text);
	//
}

function color_factory_refreshASCII(){
	drawAsciiToBitmap(bitmap_canvasDemo, bitmapData_canvasDemo);
}

function color_factory_refreshMirror(str_type:String = "RANDOM"){
	//
	if(str_type == "RANDOM"){
		bitmapMirror(bitmapData_canvasDemo, Math_randomRange(0, 3));
	}else{
		bitmapMirror(bitmapData_canvasDemo, Number(str_type));
	}
}

function color_factory_refreshPerlin(){
	//
	color_factory_resetTempBitmaps(false);
	//
	//convert string to boolean
	var stitch:Boolean = (color_factory_window.txt_perlin_stitch_INPUT.text == "true") ? true : false;
	var fractalNoise:Boolean = (color_factory_window.txt_perlin_fractalNoise_INPUT.text == "true") ? true : false;
	var grayScale:Boolean = (color_factory_window.txt_perlin_grayScale_INPUT.text == "true") ? true : false;	
	//
	perlin_texture(bitmap_canvasDemo, color_factory_window.txt_perlin_scale_INPUT.text, 1, color_factory_window.txt_perlin_baseX_INPUT.text, color_factory_window.txt_perlin_baseY_INPUT.text, color_factory_window.txt_perlin_numOctavesINPUT.text, color_factory_window.txt_perlin_randomSeed_INPUT.text, stitch, fractalNoise, color_factory_window.txt_perlin_channelOptions_INPUT.text, grayScale, color_factory_window.txt_perlin_scale_INPUT.text);
}

function color_factory_refreshFuzzy(){
	//set bools here
	
	//reset here maybe
	
	//set
	nextFuzzy(bitmapData_canvasDemo, bitmap_canvasDemo);
}