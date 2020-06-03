//CODE FOR THE SMOOSHER
//must set mousedown to true/false when running
/*
smoosher_parent.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
smoosher_parent.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
smoosher_parent.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
*/

//var bool_isMouseDown: Boolean; //mouse presses for tool's that require multiple events (smoosher, etc...)

var smoosher_parent: DisplayObjectContainer;
var smoosher_bitmapObject: BitmapData;
var smoosher_displacementFilter: DisplacementMapFilter;
var smoosher_brushObject: Sprite;
var smoosher_currentMousePos: Point = new Point();
var smoosher_lastMousePos: Point = new Point();

//updated values from text input
var smoosher_displacementAmount: Number = 50;
var smoosher_blurAmount: Number = 25;
var num_smoosher_brushSize:Number = 20;
var bool_smoosher_blur:Boolean = true;

var bool_smoosher_startedSmooshing:Boolean = false; //if you have started drawing on the canvas

var smoosher_rect: Sprite = new Sprite();//rectangle that's drawn

var smoosher_bmpDisplay: Bitmap;
var smoosher_bitmapDisplacer: BitmapData;

function setup_smoosher(bitmapToDistort: BitmapData, debug: Boolean = false) {
	
	setup_smoosherBitmaps();
	
	smoosher_bitmapObject = bitmapToDistort;
	smoosher_parent = mc_draw;
	
	//update bitmap values with the canvas here
	smoosher_bmpDisplay = bitmap_canvasDemo;//canvasBitmap;
	smoosher_bitmapObject = bitmapData_canvasDemo;//canvasBitmapData;
	
	init_smoosher();
	
}

function setup_smoosherBitmaps(){
	//
	trace("setup_smoosherBitmaps()");
	//
	try{
		mc_draw.removeChild(bitmap_canvasDemo);
		bitmapData_canvasDemo.dispose();
	}catch(e:Error){
		//null
	};
	//set it up now...
	bitmap_canvasDemo = new Bitmap(canvasBitmapData, "auto", true);
	//draw it
	bitmapData_canvasDemo = new BitmapData(mc_draw.width, mc_draw.height, false, 0x000000);
	bitmapData_canvasDemo.draw(bitmap_canvasDemo);
	bitmap_canvasDemo.bitmapData = bitmapData_canvasDemo;
	//
	mc_draw.addChild(bitmap_canvasDemo);
}

function init_smoosher(){
	//init smoosher here
	smoosher_bitmapDisplacer = new BitmapData(mc_draw.width, mc_draw.height, true, 0x7F7F7F);
	//init and setup
	smoosher_initDisplacementMap();
	smoosher_initBrush();
	//
	smoosher_bitmapDisplacer.draw(smoosher_createTransparentRect());
}

function restart_smoosher(){
	smoosher_bmpDisplay.filters = [];
	smoosher_initBrush();
}

//completely resets the smoosher and elimiminates any children
function destory_smoosher() {
	//
	try{
		
		bitmapData_canvasDemo.dispose();
		
		smoosher_bmpDisplay.filters = [];
		smoosher_brushObject.filters = [];
		
		smoosher_displacementFilter = null;
		smoosher_bitmapDisplacer.dispose();
		
		smoosher_brushObject.graphics.clear();
		smoosher_rect.graphics.clear();
		
		mc_draw.removeChild(bitmap_canvasDemo);
		bitmapData_canvasDemo.dispose();
		
	}catch(e:Error){
		//null reference
		trace("destory_smoosher: " + e);
	}
	
	//init_smoosher();
}

//smoosher setup and running
function smoosher_createTransparentRect(alpha: Number = 1){
	smoosher_rect = new Sprite();
	smoosher_rect.graphics.beginFill(0x7F7F7F, alpha);
	smoosher_rect.graphics.drawRect(smoosher_bitmapDisplacer.rect.x, smoosher_bitmapDisplacer.rect.y, smoosher_bitmapDisplacer.rect.width, smoosher_bitmapDisplacer.rect.height);
	smoosher_rect.cacheAsBitmap = true;
	return smoosher_rect;
}

function smoosher_initDisplacementMap(): void {
	//clear first
	try{
		//smoosher_displacementFilter = null;
	}catch(e:Error){
		trace("smoosher_initDisplacementMap error: " + e);
	}
	//now start
	//smoosher_displacementAmount = 50; //SIZE: 50
	smoosher_displacementFilter = new DisplacementMapFilter();
	//smoosher_displacementFilter.quality = BitmapFilterQuality.HIGH;
	smoosher_displacementFilter.mapBitmap = smoosher_bitmapDisplacer;
	smoosher_displacementFilter.mapPoint = new Point(-smoosher_bmpDisplay.x, -smoosher_bmpDisplay.y);
	smoosher_displacementFilter.componentX = BitmapDataChannel.RED;
	smoosher_displacementFilter.componentY = BitmapDataChannel.GREEN;
	smoosher_displacementFilter.scaleX = smoosher_displacementAmount;
	smoosher_displacementFilter.scaleY = smoosher_displacementAmount;
	smoosher_displacementFilter.mode = DisplacementMapFilterMode.COLOR;
}

function smoosher_initBrush(): void {
	//clear old before initiating a new one
	try{
		smoosher_brushObject.filters = [];
		smoosher_brushObject.graphics.clear();
	}catch(e:Error){
		trace("smoosher_initBrush: " + e);
	}
	//
	//
	smoosher_brushObject = new Sprite();
	var colorTrans: ColorTransform = new ColorTransform();
	smoosher_brushObject.graphics.beginFill(colorTrans.color, .3);
	smoosher_brushObject.graphics.drawCircle(0, 0, num_smoosher_brushSize);
	//set blur here (toggle) ??
	if(bool_smoosher_blur){
		smoosher_brushObject.filters = [new BlurFilter(smoosher_blurAmount, smoosher_blurAmount, 1.5)];
	}else{
		smoosher_brushObject.filters = [];
	}
	smoosher_brushObject.cacheAsBitmap = true;
}

function smoosher_changeBrushColor(redAmount: Number, greenAmount: Number): Sprite {
	var colorTrans: ColorTransform = new ColorTransform(1, 1, 1, 1, redAmount, greenAmount, 255);
	smoosher_brushObject.transform.colorTransform = colorTrans;
	return smoosher_brushObject;
}

function smoosher_calculateBrushColor(): void {
	
	var dist: Number = 0;
	var redAmount: Number;
	var greenAmount: Number;
	
	var intensity:Number = 15; //intensity of motion

	if (smoosher_lastMousePos.x > smoosher_currentMousePos.x) {
		//is moving right
		dist = smoosher_lastMousePos.x - smoosher_currentMousePos.x;
		if (127 + (dist * intensity) >= 255)
			redAmount = 255;
		else
			redAmount = 127 + (dist * intensity)

	} else if (smoosher_lastMousePos.x < smoosher_currentMousePos.x) {
		//is moving left
		dist = smoosher_currentMousePos.x - smoosher_lastMousePos.x;
		if (127 + (dist * intensity) >= 255)
			redAmount = 10;
		else
			redAmount = 127 - (dist * intensity)
	}

	if (smoosher_lastMousePos.y > smoosher_currentMousePos.y) {
		//is moving up
		dist = smoosher_lastMousePos.y - smoosher_currentMousePos.y;
		if (127 + (dist * intensity) >= 255)
			greenAmount = 255;
		else
			greenAmount = 127 + (dist * intensity)

	} else if (smoosher_lastMousePos.y < smoosher_currentMousePos.y) {
		//is moving down
		dist = smoosher_currentMousePos.y - smoosher_lastMousePos.y;
		if (127 + (dist * intensity) >= 255)
			greenAmount = 10;
		else
			greenAmount = 127 - (dist * intensity)
	}
	
	smoosher_changeBrushColor(redAmount, greenAmount);
}

//set in MOUSE_MOVE function
function event_runSmoosher(e_localX:Number, e_localY:Number){
	//enter frame constant refresh
	smoosher_displacementFilter.mapBitmap = smoosher_bitmapDisplacer;
	smoosher_bmpDisplay.filters = [smoosher_displacementFilter];
	smoosher_displacementFilter.mapPoint = new Point(-smoosher_bmpDisplay.x, -smoosher_bmpDisplay.y);
	//
	smoosher_lastMousePos = smoosher_currentMousePos;
	smoosher_currentMousePos = new Point(e_localX, e_localY);
	//move up and down motions
	smoosher_calculateBrushColor();
	//update
	if (bool_isMouseDown) {
		var matrix: Matrix = smoosher_brushObject.transform.matrix;
		matrix.identity();
		matrix.translate(e_localX, e_localY);
		smoosher_bitmapDisplacer.draw(smoosher_brushObject, matrix, smoosher_brushObject.transform.colorTransform, BlendMode.NORMAL, null, true);
		//show the run button
		bool_smoosher_startedSmooshing = true;
		mc_smooshzone.btn_smoosh_run.visible = bool_smoosher_startedSmooshing;
	}

}