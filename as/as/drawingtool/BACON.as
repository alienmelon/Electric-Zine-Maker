/*
the bacon tool draws 4 lines next to eachother like a stripe pattern
similar to the pen tool, but with 4 different lines to manage and a separate UI that manages color
some settings exist to change the lines or make them more jaggedy
default pen valies, size and alpha, apply to it

color selection for tools like bacon, that use independent UI's to set color are still a work in progress
and anything that sets their colors is a quick hack to just get it done...
*/

//str_tool = "BACON"

//BACON TOOL//
var baconPenSprite_line1:Sprite = new Sprite();
var baconPenSprite_line2:Sprite = new Sprite();
var baconPenSprite_line3:Sprite = new Sprite();
var baconPenSprite_line4:Sprite = new Sprite();
//
var ct_baconCol1:ColorTransform = new ColorTransform();
var ct_baconCol2:ColorTransform = new ColorTransform();
var ct_baconCol3:ColorTransform = new ColorTransform();
var ct_baconCol4:ColorTransform = new ColorTransform();
//
var baconPen_color1:int = 0xFF3300;
var baconPen_color2:int = 0xFFEBEB;
var baconPen_color3:int = 0xCC3300;
var baconPen_color4:int = 0xFFCCCC;
//
var str_currPenColor:String = "1";//currently selected (check against)
//
var arr_baconPenSprites:Array = new Array(baconPenSprite_line1, baconPenSprite_line2, baconPenSprite_line3, baconPenSprite_line4);
//bacon tool offset values
var num_bacon_x_MIN:Number = 0;
var num_bacon_x_MAX:Number = 0;
var num_bacon_y_MIN:Number = 0;
var num_bacon_y_MAX:Number = 0;
////////////////////////

function returnBaconColor(num_i:Number){
	var arr:Array = new Array(baconPen_color1, baconPen_color2, baconPen_color3, baconPen_color4);
	//
	return arr[num_i];
}

function set_bacon() {
	//set bacon lines to current mouse (mouse down, first place)
	for (var i: Number = 0; i < arr_baconPenSprites.length; ++i) {
		var pens = arr_baconPenSprites[i];
		//move to and line to +size * array item
		pens.graphics.moveTo(mouseX, mouseY);
	}
}

//usage: mouse MOVE draw_bacon(event.localX, event.localY);
function draw_bacon(event_localX:Number, event_localY:Number) {
	if (bool_isMouseDown) {
		//draw all lines
		for (var i: Number = 0; i < arr_baconPenSprites.length; ++i) {
			var pens = arr_baconPenSprites[i];
			var col: int = returnBaconColor(i);
			//
			var num_xOffset:Number = Math_randomRange_dec(num_bacon_x_MIN, num_bacon_x_MAX);
			var num_yOffset:Number = Math_randomRange_dec(num_bacon_y_MIN, num_bacon_y_MAX);
			//setup
			pens.graphics.lineStyle(num_pen_size, col, pen_alpha);
			//
			var numX: Number = num_pen_size * i;
			var numY: Number = num_pen_size * i;
			//move to and line to +size * array item
			pens.graphics.moveTo(num_prevMouseX + numX, num_prevMouseY);

			//TODO: THESE HAVE VALUES YOU CAN ADD TO TO OFFSET
			//event.localY + Math.random()*100 !! MATH RANDOM IS FOR FRIED EFFECT
			//event.localY + Math_randomRange_dec(-100, 100) !! FUZZY STRING EFFECT
			pens.graphics.lineTo(event_localX + numX + num_xOffset, event_localY + num_yOffset); //(minus Y is adjustable -- adjust value offset for ALL of these)
			//

			canvasBitmapData.draw(pens);
			//clear for restart
			pens.graphics.clear();
			//
		}
	};
}