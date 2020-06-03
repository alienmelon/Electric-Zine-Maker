/*
shared bitmap information
the actual canvas bitmap
various shared bitmaps for tools (edit in a separate bitmap, then set to main canvas)
saving and setting bitmap functions (shared)
textures for drawing (draw gradients over a mask for tools like toast or perlin brush)
*/

//save drawing to this
var canvasBitmap: Bitmap;
var canvasBitmapData: BitmapData = new BitmapData(mc_draw.width, mc_draw.height, false);
//clone of the canvas (used for various tools, save a copy, use tool, then save or revert to oritinal canvas)
var bitmapData_canvasDemo:BitmapData;// = new BitmapData(mc_draw.width, mc_draw.height, false, 0);
var bitmap_canvasDemo:Bitmap;// = new Bitmap(bitmapdata_copy, "auto", true);
//temp for when the demo bitmaps are in use
//used in the Color Factory during RGB shift or in other instances when both bitmaps are unusable
var tempBitmapData:BitmapData;
//any saved bitmap gets cloned to here, this is constantly emptied (while using a tool -- see color factory)
var arr_savedBitmaps:Array = new Array();

//bitmaps and bitmap data (shared) for tools... airbrush, etc...
var bitmapdata_tool:BitmapData;// = new BitmapData(canvasBitmapData.width, canvasBitmapData.height, true, selected_color);
var bitmap_tool: Bitmap;// = new Bitmap(bitmapdata_tool, PixelSnapping.ALWAYS, true);
var bitmapdata_texture:BitmapData;//textures like perlin noise and noise

//create the bitmap for saving the drawing
//try catch for main window, if no main window then make new one
try {
	//populate from main window
	canvasBitmap = new Bitmap(stage_parent[curr_bitmap_data], "auto", false);
	canvasBitmapData = stage_parent[curr_bitmap_data];
	//
} catch (e: Error) {
	//parent is null, make new
	canvasBitmap = new Bitmap(canvasBitmapData, "auto", false);
	//
};


/////CANVAS UPDATES (STATES)/////

function parent_save_zineToDesktop(){
	try{
		stage_parent.save_zineToDesktop(false);
	}catch(e:Error){
		trace("null parent, cannot save");
	}
}

function save_art_to_parent() {
	//trace("save to parent, send it bitmap data as you draw, and then on close");
	//stage_parent.canvasBitmap.bitmapData = canvasBitmapData;
	stage_parent[curr_bitmap].bitmapData = canvasBitmapData;
	stage_parent[curr_bitmap_data] = canvasBitmapData;
	//
	stage_parent.update_page_previews(stage_parent[curr_bitmap], stage_parent[curr_bitmap_data]);
	//save UI settings to parent
	/*stage_parent.arr_currFontList = arr_currFontList;
	stage_parent.num_currFontList = num_currFontList;
	stage_parent.currFont = currFont;*/
};

function update_after_draw() {
	//updates the canvases, icons, and undo state
	//
	canvasBitmap.bitmapData = canvasBitmapData;
	//update
	arr_undo.push(canvasBitmapData.clone());
	arr_redo = [];
	//iconBmp.bitmapData = canvasBitmapData;
	//
	//SEND TO PARENT
	try {
		save_art_to_parent();
	} catch (e: Error) {
		trace("save_art_to_parent() error: no parent");
	}
};

/////CANVAS MANAGMENT///
//updating, creating, and drawing to (transform drawing)

function paste_bitmap(){
	update_after_draw();
	writeBitmapFromClipboard(canvasBitmap.bitmapData, mc_draw.width, mc_draw.height);
}

//create a canvas demo bitmap (for demoing effects before applying to canvas)
function create_canvasDemo(){
	bitmap_canvasDemo = new Bitmap(canvasBitmapData, "auto", true);
	bitmapData_canvasDemo = new BitmapData(mc_draw.width, mc_draw.height, false, 0x000000);
	bitmapData_canvasDemo.draw(bitmap_canvasDemo);
	bitmap_canvasDemo.bitmapData = bitmapData_canvasDemo;
	mc_draw.addChild(bitmap_canvasDemo);
}
//destroy the demo canvas
function clear_canvasDemo(){
	mc_draw.removeChild(bitmap_canvasDemo);
	bitmapData_canvasDemo.dispose();
}

//update canvas bitmap with any transforms or filters (used for smoosher and others BEFORE removing filter)
function save_transform_to_canvas(bitmapToDrawTo:BitmapData, bool_includeTransform:Boolean = false){
	//
	//update_after_draw();
	/*bmd.draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:flash.geom:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false):void
Draws the source display object onto the bitmap image, using the Flash runtime vector renderer.*/
	//
	try{
		var bmd: BitmapData = new BitmapData(mc_draw.width, mc_draw.height, false, 0);
		//set what type
		//if color transformation was applied save that
		if(!bool_includeTransform){
			bmd.draw(mc_draw, null, null, null, null, false);
		}else{
			//bmd.draw(mc_draw, mc_draw.transform.matrix, mc_draw.transform.colorTransform, null, null, false);
			bmd.draw(mc_draw, null, mc_draw.transform.colorTransform, null, null, false);
		};
		//draw to source, then remove when done...
		bitmapToDrawTo.draw(bmd, null, null, null, null, false);
		bmd.dispose();
		//
	}catch(e:Error){
		trace("save_transform_to_canvas() error: " + e);
	}
}

function update_canvas_with(bitmapToDrawFrom:BitmapData){
	canvasBitmapData.draw(bitmapToDrawFrom, null, null, null, null, false);
	canvasBitmap.bitmapData = canvasBitmapData;
}

//call to update a target bitmap (used for reseting from arrays)
function update_bitmaps_from(bitmapToDrawFrom:BitmapData, targetBitmapData:BitmapData, targetBitmap:Bitmap){
	targetBitmapData.draw(bitmapToDrawFrom, null, null, null, null, false);
	targetBitmap.bitmapData = targetBitmapData;
}

/////BITMAP CHECKING////

//compare the percentage difference between two bitmaps
//detect if a bitmap has changed
//this is used for undos where state is constantly updated (mouse_move)
//and changes must be significant enough to push to undo
//
//usage: if(Math.ceil(getBitmapDifference(arr_undo[arr_undo.length-1], canvasBitmap.bitmapData)))
function getBitmapDifference(bitmapData1:BitmapData, bitmapData2:BitmapData):Number 
{
    var bmpDataDif:BitmapData = bitmapData1.compare(bitmapData2) as BitmapData;
    if(!bmpDataDif)
        return 0;
    var differentPixelCount:int = 0;

    var pixelVector:Vector.<uint> =  bmpDataDif.getVector(bmpDataDif.rect);
    var pixelCount:int = pixelVector.length;

    for (var i:int = 0; i < pixelCount; i++) 
    {
        if (pixelVector[i] != 0)
            differentPixelCount ++;
    }

    return (differentPixelCount / pixelCount)*100;
}

/////BITMAP DRAWING & TEXTURES////
//shared bitmap drawing, like textures and masks

//OTHER TYPES OF PENS//
//was perlin_makeBrush
//used for the perlin brush and toast brush
function makeRadialBrush(){
	//make the brush...
	// draw an alphaChannel (radial gradient)
	var diameter: Number = num_pen_size * 2;
	//var pixNum: int; = size * size;
	var pixNum:int = diameter * diameter;
	var xp: int
	var yp: int;

	var dx: int, dy: int;
	var ratio: Number = 255 / num_pen_size;
	var a: int;
	
	bitmapdata_tool = new BitmapData(diameter, diameter, true, 0x00000000);

	bitmapdata_tool.lock();
	for (var i:Number = 0; i < pixNum; i++) {
		xp = i % diameter;
		yp = i / diameter;
		dx = xp - num_pen_size;
		dy = yp - num_pen_size;
		a = int(255 - Math.min(255, Math.sqrt(dx * dx + dy * dy) * ratio));
		bitmapdata_tool.setPixel32(xp, yp, a << 24);
	}
	bitmapdata_tool.unlock();
};
//Draw a generated texture to the canvas
//Used for perlin noise and toast
function draw_texture(event_localX:Number, event_localY:Number): void {
	// draw the gradient onto the canvas using the alphaChannel (bitmapdata_tool);
	var xp = event_localX - num_pen_size;
	var yp = event_localY - num_pen_size;
	var diameter: Number = num_pen_size * 2;
	//
	canvasBitmapData.copyPixels(bitmapdata_texture,
		new Rectangle(xp, yp, diameter, diameter),
		new Point(xp, yp), bitmapdata_tool, new Point(0, 0), true);
	//
}

//DRAWING TO CANVAS FROM VARIOUS TOOLS//

//place the text field on the screen (draw to canvas)
function draw_textField() {
	//trace(canvas_textField.transform.matrix);
	var bool_quality:Boolean;
	//if rotated adjust the quality
	//rotated text loses quality if set to false
	//this is a hack, text needs to be re-worked (TODO)
	if(num_currFont_rotation!=0){
		bool_quality = true;
	}else{
		bool_quality = false;
	};
	//must pass entire draw region otherwise you get cut off
	var bmd: BitmapData = new BitmapData(mc_draw.width + stage.stageWidth, mc_draw.height + stage.stageHeight, true, 0);
	bmd.draw(canvas_textField_container, null, null, null, null, bool_quality);
	//
	var mat: Matrix = new Matrix();//canvas_textField.transform.matrix;
	//rotation and size
	//mat.scale(canvas_textField.scaleX, canvas_textField.scaleY);
	mat.rotate(degreesToRadians(num_currFont_rotation));//canvas_textField.rotation);
	//place
	mat.translate(canvas_textField_container.x, canvas_textField_container.y);
	//mat.scale(mc_draw.scaleX, mc_draw.scaleY);
	
	canvasBitmapData.draw(bmd, mat, null, null, null, bool_quality);
	bmd.dispose();
};

//draw imported image into the canvas
function draw_import_fill(){
	//
	update_after_draw();
	//
	//loader_importImage is in FILEREFERENCE.as, it's set after image is loaded so width height can be read
	try{
		var bmd: BitmapData = new BitmapData(loader_importImage.width, loader_importImage.height, true, 0);
		bmd.draw(clip_importImage, null, null, null, null, false);
		//
		var mat: Matrix = clip_importImage.transform.matrix;
		//
		canvasBitmapData.draw(bmd, mat, null, null, null, false);
		bmd.dispose();
		//
		//update_after_draw();
		//
	}catch(e:Error){
		trace("draw_import_fill error: no bitmap is loaded");
	}
}