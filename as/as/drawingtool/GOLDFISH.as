/*
a distortion effect for the canvas that simulates water (splashing in water)
there are some modes, and settings available in the UI, to adjust the water
a "water effect" over a drawing is as old as javascript
early javascript experiments (and i mean EARLY, like web 1.0) would try this all the time
it's a code-meme, was completely pointless, but popular all the same
the Flash community would make these too... this is adapted from some of the experiments that where on wonderfl
*/

//str_tool = "GOLDFISH";

//GOLDFISH (FLUID DYNAMICS)
var num_water_bufferScale: Number = .3; //menu item: distance, displays as full number but is decimal
var int_water_rippleSize: int = 5; //20; //menu item: ripple size, is a whole number
var str_water_drawType: String = "draw"; //menu item: splash, draw -- splash = animated, draw captures each stroke and saves on up
var bool_water_rain:Boolean = false; //menu item: toggle rainmode or not
//water bitmaps
var bitmap_water_sample: Bitmap;
var bitmapData_water_defData: BitmapData;
var bitmapData_water_buffer2: BitmapData;
var bitmapData_water_buffer1: BitmapData;
//draw areas
var rect_water_drawRect: Rectangle;
var rect_water_fullRect: Rectangle;
//filters
var matrix_water: Matrix;
var cf_water_convoFilter: ConvolutionFilter;
var df_water_filter: DisplacementMapFilter;
var ct_water_colorTransform: ColorTransform;
/////////////////////////////

//these two events handle the water animation
//depending on if the mouse is down or not
//if "splash" is set then it animates freely
function event_runWaterAnimation(event: Event): void {
	
	if (bool_isMouseDown) {
		water_manageBitmapDraw();
	}
	
}

//depending on the draw type
//save to canvas and reset, or do nothing and keep running
function event_drawWater_MOVE(event: MouseEvent): void {
	
	if (bool_isMouseDown) {
		water_updateDrawRect();
	}
	
}

//for MOUSE_UP in the default draw event
//save it here and push to bitmapdata depending on draw type
function event_water_MOUSEUP(){
	if(str_water_drawType == "draw"){
		//
		save_waterDraw(canvasBitmapData);
		//
	}else{
		//if str_water_drawType == "splash"
		//don't save to canvas, keep animating on mouse up...
	}
}

function water_switchBuffers(): void {
	var _local_1: BitmapData;
	_local_1 = bitmapData_water_buffer1;
	bitmapData_water_buffer1 = bitmapData_water_buffer2;
	bitmapData_water_buffer2 = _local_1;
}

function water_manageBitmapDraw() {
	var _local_2: BitmapData = bitmapData_water_buffer2.clone();
	bitmapData_water_buffer2.applyFilter(bitmapData_water_buffer1, rect_water_fullRect, new Point(), cf_water_convoFilter);
	bitmapData_water_buffer2.draw(_local_2, null, null, BlendMode.SUBTRACT, null, false);
	bitmapData_water_defData.draw(bitmapData_water_buffer2, matrix_water, ct_water_colorTransform, null, null, true);
	df_water_filter.mapBitmap = bitmapData_water_defData;
	bitmap_water_sample.filters = [df_water_filter];
	_local_2.dispose();
	water_switchBuffers();
}


function water_updateDrawRect() {
	var _local_2: int = int(((int_water_rippleSize / 2) * -1));
	
	//menu option: make it rain, or normal splashes
	if(!bool_water_rain){
		//default
		rect_water_drawRect.x = ((_local_2 + bitmap_water_sample.mouseX) * num_water_bufferScale);
		rect_water_drawRect.y = ((_local_2 + bitmap_water_sample.mouseY) * num_water_bufferScale);
	}else{
		//rain
		rect_water_drawRect.x = Math.random()*((_local_2 + bitmap_water_sample.mouseX) * num_water_bufferScale);
		rect_water_drawRect.y = Math.random()*((_local_2 + bitmap_water_sample.mouseY) * num_water_bufferScale);
	}
	
	//
	rect_water_drawRect.width = (rect_water_drawRect.height = (int_water_rippleSize * num_water_bufferScale));
	bitmapData_water_buffer1.fillRect(rect_water_drawRect, 0xFF);
}

//call this to start the water (setup)...
function init_water(canvasBD:BitmapData){

	bitmap_water_sample = new Bitmap(canvasBD);
	mc_draw.addChild(bitmap_water_sample);

	bitmapData_water_buffer1 = new BitmapData((bitmap_water_sample.width * num_water_bufferScale), (bitmap_water_sample.height * num_water_bufferScale), false, 0);
	bitmapData_water_buffer2 = new BitmapData(bitmapData_water_buffer1.width, bitmapData_water_buffer1.height, false, 0);
	bitmapData_water_defData = new BitmapData(bitmap_water_sample.width, bitmap_water_sample.height, false, 0x7F7F7F);
	rect_water_fullRect = new Rectangle(0, 0, bitmapData_water_buffer1.width, bitmapData_water_buffer1.height);
	rect_water_drawRect = new Rectangle();
	df_water_filter = new DisplacementMapFilter(bitmapData_water_buffer1, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE, 50, 50, DisplacementMapFilterMode.WRAP);
	bitmap_water_sample.filters = [df_water_filter];
	
	cf_water_convoFilter = new ConvolutionFilter(3, 3, [0.5, 1, 0.5, 1, 0, 1, 0.5, 1, 0.5], 3);
	ct_water_colorTransform = new ColorTransform(1, 1, 1, 1, 0, 128, 128);
	matrix_water = new Matrix((this.bitmapData_water_defData.width / bitmapData_water_buffer1.width), 0, 0, (bitmapData_water_defData.height / bitmapData_water_buffer1.height));
	
	stage.addEventListener(Event.ENTER_FRAME, event_runWaterAnimation);
	stage.addEventListener(MouseEvent.MOUSE_MOVE, event_drawWater_MOVE);
	
	water_manageBitmapDraw();//update only once for first run

}

function clear_water(){
	
	/*all bitmaps used:
	var bitmap_water_sample: Bitmap;
	var bitmapData_water_defData: BitmapData;
	var bitmapData_water_buffer2: BitmapData;
	var bitmapData_water_buffer1: BitmapData;*/
	
	try{
		bitmapData_water_buffer1.dispose();
		bitmapData_water_buffer2.dispose();
		bitmapData_water_defData.dispose();
	}catch(e:Error){
		//null
	}
	
	try{
		bitmap_water_sample.filters = [];
	}catch(e:Error){
		//null
	}
	
	try{
		mc_draw.removeChild(bitmap_water_sample);
	}catch(e:Error){
		//null
	}
	
	try{
		
		bitmap_water_sample = null;
		
		rect_water_fullRect = null;
		rect_water_drawRect = null;
		df_water_filter = null;
		df_water_filter = null;
		cf_water_convoFilter = null;
		ct_water_colorTransform = null;
		matrix_water = null;
		
	}catch(e:Error){
		//null
	}
	
	stage.removeEventListener(Event.ENTER_FRAME, event_runWaterAnimation);
	stage.removeEventListener(MouseEvent.MOUSE_MOVE, event_drawWater_MOVE);
}

//reset water for when you update draw values
//or restart the tool
function reset_water(){
	clear_water();
	init_water(canvasBitmap.bitmapData);
}

//special undo for water
//for "splash" must check difference and set only for major changes to the bitmap...
function water_updateUndo(){
	//only push default undo if "draw" mode is selected
	//else check for major changes and push only if bitmap is different
	if(str_water_drawType == "draw"){
		//
		update_after_draw();//push water state undo ON_DOWN
		//
	}else if(Math.ceil(getBitmapDifference(arr_undo[arr_undo.length-1], canvasBitmap.bitmapData))){
		//splash mode (update undo based on similarity)
		//true, update undo
		update_after_draw();
	}
}


//save the current splash and push it to canvas
//reset all and start it up again (used when drawType is "draw")
function save_waterDraw(canvasBD:BitmapData){
	//
	//do not update undo here, it will flood with unchanged bitmaps
	//save and start again...
	save_transform_to_canvas(canvasBD, true);
	clear_water();
	init_water(canvasBD);
}
//

/*
usage:
(SEE _DRAWING.as)

MOUSE_UP:
	event_water_MOUSEUP();
	
MOUSE_DOWN: TODO: FIX THIS (THIS IS A QUICK HACK/FIX)
	//update undo and draw rectangle
	try{
		water_updateUndo();
		water_updateDrawRect();
	}catch(e:Error){
		//TODO: FIX THIS
		//if you import a zine, then open the drawing tool (0 undos)
		//and undo, then SPLASH mode, it will generate bug...
		//see if this happens to other tools with 0 undo stack
		trace("Error: undo is null, reset first...");
		update_after_draw();
		save_waterDraw(canvasBitmapData);
	}
*/