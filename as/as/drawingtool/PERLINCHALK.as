//PERLIN CHALK
//randomly placed pixels that are blurred and simulate a gentle "chalk" texture
//chalk can fade as you draw, or stays (like softbrush)
//you draw on a bitmap (bitmapdata_tool) that's over the canvas, then that bitmap is saved to canvas on UP
//WAS a perlin texture, but pixels worked better...
//size UI is shared with SOFTBRUSH
//
//str_tool = "PERLIN CHALK"
//
//vars and numbers
//shared: num_airbrushSize = size
//shared: bool_airbrushFade = should the chalk do a trailing fade
//filters
var perlinChalk_BF: BlurFilter = new BlurFilter(1.05, 1.05, 3);
perlinChalk_BF.quality = BitmapFilterQuality.HIGH;

//basic setup of bitmaps
//apply filters...
function perlinChalk_setupBitmap(){
	trace("perlinChalk_setupBitmap");
	//delete first (in case)
	perlinChalk_DELETEALL();
	//
	//setup
	bitmapdata_tool = new BitmapData(mc_draw.width, mc_draw.height, true, 0xffffff);
	bitmap_tool = new Bitmap(bitmapdata_tool, "auto", false);
	mc_draw.addChild(bitmap_tool);
	bitmap_tool.filters = [new BlurFilter(1.4, 1.4, 3)];
	//
}

//completely delete everything
function perlinChalk_DELETEALL(){
	//
	try{
		bitmap_tool.filters = [];
	}catch(e:Error){
		trace("perlinChalk_DELETEALL bitmap_tool.filters = [] error");
	}
	//
	try{
		bitmapdata_tool.dispose();
	}catch(e:Error){
		trace("perlinChalk_DELETEALL bitmapdata_tool.dispose() error");
	}
	//
	try{
		mc_draw.removeChild(bitmap_tool);
	}catch(e:Error){
		trace("perlinChalk_DELETEALL mc_draw.removeChild error");
	}
}

//usage: on mouse MOVE perlinChalk_draw(event.localX, event.localY);
function perlinChalk_draw(event_localX:Number, event_localY:Number){
	//
	//color conversion for colors with alpha
	var num_sizeAdd:Number = 2;
	var col = hex_to_ARGB(selected_color , 100);
	//
	if(num_airbrushSize < 10){
		num_sizeAdd = 1;
	}
	if(num_airbrushSize > 50){
		num_sizeAdd = Math.ceil(num_airbrushSize/8);
	}
	//
	for (var i: int = 0; i < 100*num_sizeAdd; i++) {
		bitmapdata_tool.setPixel32(event_localX + Math.random() * num_airbrushSize - (num_airbrushSize/2),
			event_localY + Math.random() * num_airbrushSize - (num_airbrushSize/2),
			col);
	}
	//
	if(bool_airbrushFade){
		bitmapdata_tool.applyFilter(bitmapdata_tool, bitmapdata_tool.rect, new Point(0, 0), perlinChalk_BF);
	};
}