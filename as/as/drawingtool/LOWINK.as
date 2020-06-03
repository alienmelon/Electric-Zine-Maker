/*
LOW INK is a line tool that reduces the line size as you draw (like runing out of ink)
there are a few settings to adjust the mode
default = running out of ink and then stops
random = random line sizes as you draw
pulse = like a hearbeat
wave = like default but then increases when you run out, then reduces as you reach maximum...
the tool lets you adjust the fade-rate, which is how fast the line animates
and minimum size + maximum (starting) size
*/

//str_tool = "LOW INK"
//LOW INK VALUES//
var str_lowInk_type: String = "default"; //"default"; "random" "pulse" "wave"
var num_lowInk_fadeRate: Number = 5;
var bool_lowInk_waveToggle: Boolean = false; //toggle for the wave (direction)

function lowInk_setValues(){
	if (num_pen_size_defaultMax <= 0) {
		num_pen_size_defaultMax = 2;
	}
	if (num_pen_size_MIN <= 0) {
		num_pen_size_MIN = 0;
	}
	if (num_pen_size_MIN >= num_pen_size_defaultMax) {
		num_pen_size_MIN = num_pen_size_defaultMax - 5;
	}
	if (num_pen_size_defaultMax <= num_pen_size_MIN) {
		num_pen_size_defaultMax = num_pen_size_MIN + 5;
	}
	num_pen_size_MAX = num_pen_size_defaultMax;
	
	//convert to decimal
	//this pulls directly from the UI and converts it...
	//if not then conversion piles up. this should idealy be done another way...
	var num_convert = Number(mc_setting_lowink.txt_fadeRate.text);
	num_lowInk_fadeRate = convert_to_decimal(num_convert);
	
	//reset everything
	lowInk_resetValues();
	//
	/*trace("num_pen_size_MIN: " + num_pen_size_MIN);
	trace("num_pen_size_MAX: " + num_pen_size_MAX);
	trace("num_lowInk_fadeRate: " + num_lowInk_fadeRate);*/
}

function lowInk_resetValues(){
	num_pen_size_MAX = num_pen_size_defaultMax;
	bool_lowInk_waveToggle = false; //set this to default too else it breaks
}

//TODO: THIS IS NOT NECESSARY, REMOVE IT AFTER UPDATE
function lowInk_resetUp(){
	num_pen_size_MAX = num_pen_size_defaultMax;
}

/*
usage: in mouse MOVE
lowInk_drawInk(event.localX, event.localY);
canvasBitmapData.draw(penSprite);
penSprite.graphics.clear();
*/
function lowInk_drawInk(event_localX:Number, event_localY:Number){
	//normal mode
	if (num_pen_size_MAX > num_pen_size_MIN && str_lowInk_type == "default") {
		num_pen_size_MAX -= num_lowInk_fadeRate;
	}
	//pulse (like a heartbeat)
	if (num_pen_size_MAX > num_pen_size_MIN && str_lowInk_type == "pulse") {
		//
		num_pen_size_MAX -= num_lowInk_fadeRate;
		//set back
		if (num_pen_size_MAX <= num_pen_size_MIN) {
			num_pen_size_MAX = num_pen_size_defaultMax;
		}
	}
	//wave (up and down)
	if (str_lowInk_type == "wave") {
		//increment and decrement (toggle direction if lower or greater)
		if (num_pen_size_MAX >= num_pen_size_MIN && !bool_lowInk_waveToggle) {
			//
			num_pen_size_MAX -= num_lowInk_fadeRate;
			//
			if (num_pen_size_MAX <= num_pen_size_MIN) {
				bool_lowInk_waveToggle = !bool_lowInk_waveToggle;
			}
			//
		}
		if (num_pen_size_MAX < num_pen_size_defaultMax && bool_lowInk_waveToggle) {
			//
			num_pen_size_MAX += num_lowInk_fadeRate;
			//
			if (num_pen_size_MAX >= num_pen_size_defaultMax) {
				bool_lowInk_waveToggle = !bool_lowInk_waveToggle;
			}
			//
		}
	}
	//random ink
	if (str_lowInk_type == "random") {
		num_pen_size_MAX = Math_randomRange_dec(num_pen_size_MIN, num_pen_size_defaultMax);
	}
	//NORMAL MODE (if it reaches 0 then set alpha to 0)
	//alpha is set to linestyle so it trails off
	penSprite.graphics.lineStyle(num_pen_size_MAX, pen_color, num_pen_size_MAX);
	//move and place line
	penSprite.graphics.moveTo(num_prevMouseX, num_prevMouseY);
	penSprite.graphics.lineTo(event_localX, event_localY);
	//draw to canvas and then clear
	canvasBitmapData.draw(penSprite); //, penSprite.transform.matrix);
	penSprite.graphics.clear();
}