import fl.motion.AdjustColor;
import flash.filters.ColorMatrixFilter;

//CHANGING COLOR OF STAGE
var stage_fade_transform = new ColorTransform();
var num_fade_stage = 0;

var arr_stage_colors: Array = new Array(0x000000, 0xFF9AFF, 0xF2CAFF, 0x55F2FF, 0x6766FF, 0xFF4E43, 0xFF9400, 0x39C3FF);
var stage_curr_color = 0xFF9AFF;
var stage_new_color;

//COLOR HIGHLIGHTS OF SELECTED OBJECTS
var color_filter_selected: AdjustColor = new AdjustColor();
var color_matrix_selected: ColorMatrixFilter;
var arr_color_matrix_selected: Array = [];
//
function fade_hex(hex, hex2, ratio) {
	var r = hex >> 16;
	var g = hex >> 8 & 0xFF;
	var b = hex & 0xFF;
	r += ((hex2 >> 16) - r) * ratio;
	g += ((hex2 >> 8 & 0xFF) - g) * ratio;
	b += ((hex2 & 0xFF) - b) * ratio;
	return (r << 16 | g << 8 | b);
}
//

function event_fadeStage(event: Event) {
	//
	num_fade_stage += .05;
	//stage_fade_transform.color = fadeHex(startHex, endHex, num_fade);
	//test.transform.colorTransform = stage_fade_transform;
	//trace(num_fade_stage);
	//
	stage.color = fade_hex(stage_curr_color, stage_new_color, num_fade_stage);
	//
	if (num_fade_stage >= 1) {
		stage_curr_color = stage_new_color;
		stage.removeEventListener(Event.ENTER_FRAME, event_fadeStage);
	};
};

function fade_stage() {
	num_fade_stage = 0;
	stage_new_color = rand_array(arr_stage_colors);
	//
	stage.removeEventListener(Event.ENTER_FRAME, event_fadeStage);
	stage.addEventListener(Event.ENTER_FRAME, event_fadeStage);
};

//COLOR FOR SELECTING/DESELECTING TOOLS
function selectedColor(clip){
	color_filter_selected = new AdjustColor();
	color_filter_selected.hue = 180;
	color_filter_selected.saturation = 100;
	color_filter_selected.brightness = -50;
	color_filter_selected.contrast = 12;
	arr_color_matrix_selected = color_filter_selected.CalculateFinalFlatArray();
	color_matrix_selected = new ColorMatrixFilter(arr_color_matrix_selected);
	clip.filters = [color_matrix_selected];
	//trace("selectedColor on: " + clip.name);
};

//clear
function deselectColor(clip){
	clip.filters = [];
};

function deselectAll(arr:Array){
	for(var i:Number = 0; i < arr.length; ++i){
		deselectColor(arr[i]);
	};
};