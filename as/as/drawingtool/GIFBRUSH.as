/*
a simple gif loading and playback tool
loads an animated gif, and draws with its frames
see gifbrush_draw (for drawing with animation)
*/


//str_tool = "GIF BRUSH";

//GIF BRUSH (PAINT WITH AN ANIMATED GIF)
var fileReference_gifbrush: FileReference = new FileReference();//opening the gif
//var gifbrush_gifPlayer: GIFPlayer = new GIFPlayer();//the actual player
var gifbrush_gifContainer:MovieClip = new MovieClip();//containing clip used to set to mouse position
/////////////////////////////

//the gif should follow the mouse around
//it's only visible if MOUSE_OVER mc_draw is true...
function gifbrush_setMouseAsGif(event:Event){
	gifbrush_gifContainer.x = mouseX - Math.ceil(gifbrush_gifContainer.width/2);
	gifbrush_gifContainer.y = mouseY - Math.ceil(gifbrush_gifContainer.height/2);
	//use the slider to convert_to_decimal(num_pen_size * 2)
	//always called so gif is always being sized (instead of relying on slider to call that...)
	//gifbrush_gifPlayer.scaleX = gifbrush_gifPlayer.scaleY = convert_to_decimal(num_pen_size * 2);
	//
}

//visibility based on over/out of canvas
function gifbrush_overCanvas(event:MouseEvent){
	gifbrush_gifContainer.visible = true;
}
function gifbrush_outCanvas(event:MouseEvent){
	gifbrush_gifContainer.visible = false;
}

//if you're mousing over the canvas then enable this
//else disable
//used as FRAME_RENDERED event: .addEventListener(GIFPlayerEvent.FRAME_RENDERED, FUNCTION_NAME);
function gifbrush_draw(event_localX:Number, event_localY:Number){
	//
	var mat:Matrix=new Matrix();
	mat.translate(event_localX - Math.ceil(gifbrush_gifContainer.width/2), event_localY- Math.ceil(gifbrush_gifContainer.height/2));
	mat.scale(gifbrush_gifContainer.scaleX, gifbrush_gifContainer.scaleY);
	//
	canvasBitmapData.draw(gifbrush_gifContainer, mat);//gifbrush_gifContainer.transform.matrix);
}

//INIT: call this to start
//setup the player
//container
//and reference for loading the brush
//!! clear all first
function gifbrush_setupLoader(){
	//delete all first
	gifbrush_clearAll();
	//
	stage.addChild(gifbrush_gifContainer);
	//start listeners
	fileReference_gifbrush.addEventListener(Event.SELECT, event_gifbrushFileRef_SELECT);
	fileReference_gifbrush.addEventListener(Event.CANCEL, event_gifbrushFileRef_CANCEL);
	fileReference_gifbrush.addEventListener(Event.COMPLETE, event_gifbrushFileRef_LOADED);
	mc_setting_gifbrush.btn_loadgif.addEventListener(MouseEvent.MOUSE_UP, event_gifbrush_OPENFILE);
	//
}

function gifbrush_clearAll(){
	//remove all listeners
	fileReference_gifbrush.removeEventListener(Event.SELECT, event_gifbrushFileRef_SELECT);
	fileReference_gifbrush.removeEventListener(Event.CANCEL, event_gifbrushFileRef_CANCEL);
	fileReference_gifbrush.removeEventListener(Event.COMPLETE, event_gifbrushFileRef_LOADED);
	mc_setting_gifbrush.btn_loadgif.removeEventListener(MouseEvent.MOUSE_UP, event_gifbrush_OPENFILE);
	//
	mc_draw.removeEventListener(Event.ENTER_FRAME, gifbrush_setMouseAsGif);
	mc_draw.removeEventListener(MouseEvent.MOUSE_OVER, gifbrush_overCanvas);
	mc_draw.removeEventListener(MouseEvent.MOUSE_OUT, gifbrush_outCanvas);
	//clear all
	try{
		gifbrush_gifContainer.removeChildren();
	}catch(e:Error){
		trace("gifbrush_gifContainer: gifbrush_gifPlayer object not removed");
	}
	//clear container
	try{
		stage.removeChild(gifbrush_gifContainer);
	}catch(e:Error){
		trace("gifbrush_gifContainer not removed");
	}
	//
}

//setup listeners (load success)
function gifbrush_loadSuccess(){
	//important: disable gif so that coordinates get fed and it can actually draw to canvas (not intersept mouse clicks)
	gifbrush_gifContainer.mouseEnabled = false;
	//following the mouse and handle showing it...
	mc_draw.addEventListener(Event.ENTER_FRAME, gifbrush_setMouseAsGif);
	mc_draw.addEventListener(MouseEvent.MOUSE_OVER, gifbrush_overCanvas);
	mc_draw.addEventListener(MouseEvent.MOUSE_OUT, gifbrush_outCanvas);
}

function event_gifbrush_OPENFILE(event:MouseEvent): void {
	fileReference_gifbrush.browse([new FileFilter("Image Files (*.gif)", "*.gif")]);
}

function event_gifbrushFileRef_SELECT(event: Event): void {
	fileReference_gifbrush.load();
}

function event_gifbrushFileRef_CANCEL(event: Event): void {
	trace("Canceled file selection.");
}

function event_gifbrushFileRef_LOADED(event: Event): void {
	//
}

function handleGifLoadComplete(): void {
	//Gif load complete, adding to stage...
	//init gif listeners...
	gifbrush_loadSuccess();
}