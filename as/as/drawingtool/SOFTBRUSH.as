/*
AIRBRUSH

gradient brush that fades as you draw
or just paints gradients without fade
UI controls the diameter (size) and toggles fade
colors are also ajdusted

*/

//AIRBRUSH
//str_tool = "SOFT BRUSH"
var sprite_airbrush: Sprite; //gradient graphic
var sprite_airbrushMap: BitmapData; //gradient graphic is drawn to this map
var bool_airbrushFade:Boolean = true; //toggled in UI
var num_airbrushSize:Number = 50; //size of airbrush (set in UI)

function delete_airbrush(): void{
	try{
		sprite_airbrush.graphics.clear();
	}catch(e:Error){
		trace("sprite_airbrush.graphics.clear error: null");
	}
	try{
		sprite_airbrushMap.dispose();
	}catch(e:Error){
		trace("sprite_airbrushMap.dispose() is null");
	}
	try{
		bitmapdata_tool.dispose();
	}catch(e:Error){
		trace("bitmapdata_tool is null");
	}
	try{
		mc_draw.removeChild(bitmap_tool);
	}catch(e:Error){
		trace("removeChild(bitmap_tool) is null");
	}
}


//brush setup (called only on creating and when setting size)
function setup_airbrush(): void {
	var m: Matrix = new Matrix();
	m.createGradientBox(num_airbrushSize * 2, num_airbrushSize * 2, 0, -num_airbrushSize, -num_airbrushSize);
	//delete first (to reset all...)
	delete_airbrush();
	//refresh here
	bitmapdata_tool = new BitmapData(canvasBitmapData.width, canvasBitmapData.height, true, selected_color);
	bitmap_tool = new Bitmap(bitmapdata_tool, PixelSnapping.ALWAYS, true);
	mc_draw.addChild(bitmap_tool);
	//create
	sprite_airbrush = new Sprite();
	sprite_airbrushMap = new BitmapData(num_airbrushSize * 2, num_airbrushSize * 2, true, 0x00ffffff);
	//
	sprite_airbrush.graphics.beginGradientFill(GradientType.RADIAL, [selected_color, selected_color], [1, 0], [0, 250], m);
	sprite_airbrush.graphics.drawCircle(0, 0, num_airbrushSize);
	sprite_airbrush.graphics.endFill();
}

//todo...
//var rc:Number = 1/3, gc:Number = 1/2, bc:Number = 1/6;
//new ColorMatrixFilter([rc, gc, bc, 0, 0,rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]));
//
//call this to draw it (set to localX and localY of mouse position over the canvas)
function draw_airbrush(event_localX:Number, event_localY:Number){
	var mp: Matrix = new Matrix();
	mp.tx = event_localX;
	mp.ty = event_localY;
	bitmapdata_tool.draw(sprite_airbrush, mp);
	//fade trail
	//UI: TOGGLE
	if(bool_airbrushFade){
		bitmapdata_tool.applyFilter(bitmapdata_tool, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), new Point(), new BlurFilter(2, 2, BitmapFilterQuality.HIGH));
	};
}

/*
example
MOUSE_MOVE
draw_airbrush(event.localX, event.localY);

MOUSE_UP
canvasBitmapData.draw(bitmapdata_tool);
setup_airbrush();
*/