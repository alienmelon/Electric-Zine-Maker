/*
Pattern Spray lets you draw in a miny canvas (canvasBitmapData_drawSpray) and then "sprays" that onto the main canvas
you can control some settings (like remove random rotation and size)
this is a very simple tool, drawing is separate from the pen tool (Pattern Spray specific)
*/

//str_tool = "PATTERNSPRAY"
//PATTERN SPRAY
var penSprite_drawSpray: Sprite = new Sprite();
//bitmapdata for mini-canvas for draw spray
var canvasBitmap_drawSpray: Bitmap;
var canvasBitmapData_drawSpray: BitmapData = new BitmapData(mc_draw_spray.width, mc_draw_spray.height, true, 0);
canvasBitmap_drawSpray = new Bitmap(canvasBitmapData_drawSpray, "auto", true);
//UPDATE WITH SIZE AND COLOR LATER
penSprite_drawSpray.graphics.lineStyle(2, pen_color, pen_alpha);
//add to draw spray mini-canvas
mc_patternspray_outline.addChild(canvasBitmap_drawSpray);
mc_draw_spray.addChild(penSprite_drawSpray);
//if spray pattern should have random rotation or size
var bool_sprayPattern_rotation: Boolean = true;
var bool_sprayPattern_size: Boolean = true;

//DRAWING on the mini-canvas
function mouseDown_sprayPattern(e: MouseEvent) {
	//
	penSprite_drawSpray.graphics.moveTo(e.localX, e.localY);
	//
	mc_draw_spray.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove_sprayPattern);
	mc_draw_spray.addEventListener(MouseEvent.MOUSE_UP, mouseUp_sprayPattern);
};

function mouseMove_sprayPattern(e: MouseEvent) {
	//
	penSprite_drawSpray.graphics.lineTo(e.localX, e.localY);
	//
};
function mouseUp_sprayPattern(e: MouseEvent) {
	//
	canvasBitmapData_drawSpray.draw(penSprite_drawSpray, null, null, null, null, true);
	//
	mc_draw_spray.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove_sprayPattern);
	mc_draw_spray.removeEventListener(MouseEvent.MOUSE_UP, mouseUp_sprayPattern);
	//reset
	reset_pen_sprayPattern();
};

//actually placing the pattern on the default canvas
//usage: on mouse MOVE call, draw_sprayPattern(event.localX, event.localY);
function draw_sprayPattern(x: Number, y: Number) {
	//
	var _scale = Math_randomRange_dec(0.01, 1);
	var _rotate = Math_randomRange_dec(1, 360);
	//
	var bmd: BitmapData = new BitmapData(mc_draw_spray.width, mc_draw_spray.height, true, 0);
	//edit can be the contents of the clip too, but swapped to bitmap for performance (remove lines on up)
	bmd.draw(canvasBitmapData_drawSpray, null, null, null, null, true); //mc_draw_spray);
	var mat: Matrix = new Matrix();
	//rotation and size
	if (bool_sprayPattern_size) {
		mat.scale(_scale, _scale);
	};
	if (bool_sprayPattern_rotation) {
		mat.rotate(_rotate);
	};
	//place center mouse position (width/height/2)
	//this is placed differently if rotation is enabled
	if(!bool_sprayPattern_rotation){
		mat.translate((x - mc_draw_spray.width/2), (y -  mc_draw_spray.height/2));
	}else{
		mat.translate((x - mc_draw_spray.width/4), (y -  mc_draw_spray.height/4));
	}
	
	canvasBitmapData.draw(bmd, mat, null, null, null, true);//canvas bitmap can never be transparent because of fill issue
	
	bmd.dispose();
};

//clear the mini-canvas (reseting)
function clear_sprayPatternCanvas() {
	//reset_pen_sprayPattern();
	//clear pen and re-set it
	penSprite_drawSpray.graphics.clear();
	//
	//clear and re-set them
	canvasBitmapData_drawSpray.dispose();
	canvasBitmapData_drawSpray = new BitmapData(mc_draw_spray.width, mc_draw_spray.height, true, 0);
	canvasBitmap_drawSpray = new Bitmap(canvasBitmapData_drawSpray, "auto", true);
	//
	penSprite_drawSpray.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);
	//
	try {
		mc_draw_spray.removeChild(canvasBitmap_drawSpray);
		mc_draw_spray.removeChild(penSprite_drawSpray);
	} catch (e: Error) {
		trace("event_undo: error in remove");
	}

	try {
		mc_draw_spray.addChild(canvasBitmap_drawSpray);
		mc_draw_spray.addChild(penSprite_drawSpray);
	} catch (e: Error) {
		trace("event_undo: error in add");
	}
};

//clear pen for spray pattern's mini-canvas
function reset_pen_sprayPattern() {
	penSprite_drawSpray.graphics.clear();
	mc_draw_spray.removeChild(penSprite_drawSpray);
	penSprite_drawSpray.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);
	mc_draw_spray.addChild(penSprite_drawSpray);
};