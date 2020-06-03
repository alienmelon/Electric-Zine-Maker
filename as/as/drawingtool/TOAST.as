/*
toast is a burn and sharpening tool
toast is similar to PERLINBRUSH in that it creates a bitmap above the canvas that you draw over, then the canvas is updated with that drawing
texture over the top with overlay (or other, strongest setting)

the brush is generated with draw_texture(event.localX, event.localY);
texture is set up using bitmapdata_texture (the perlin texture) and bitmapdata_tool (the tool/mask) with makeRadialBrush

texture is ONLY setup, drawing takes place via draw_texture(event.localX, event.localY); in mouse MOVE
in mouse UP reset_toastBrush is called to reset so you can layer burn strength

TODO: set a color to burn to (see TINT)
*/

//str_tool = "TOAST"

//////////TOAST///////////////
var num_toast_burnAmnt:Number = 50; //amount that is burned, is the contrast value of the image
//how to draw the toast burn (special values)
var bool_toast_outline:Boolean = false;
var bool_toast_negative:Boolean = false;
var bool_toast_grayscale:Boolean = false;
//////////////////////////////

//call this on init/open...
function reset_toastBrush(){
	delete_toastBrush();
	delete_toast();
	//reset
	setup_toast();
}

function delete_toastBrush(){
	//
	try{
		bitmapdata_tool.dispose();
	}catch(e:Error){
		trace("delete_toastBrush: bitmapdata_tool.dispose(); error");
	}
}

function delete_toast(){
	//
	delete_toastBrush();
	//delete all bitmaps
	try{
		bitmapdata_texture.dispose();
	}catch(e:Error){
		trace("delete_toast: bitmapdata_texture.dispose(); error");
	}
}

function setup_toast() {
	toast_generateTexture();
	makeRadialBrush();
}

function toast_generateTexture() {
	//
	//this is the toast
	var bd_toast: BitmapData = new BitmapData(mc_draw.width, mc_draw.height, false, 0);//new test();
	//
	bitmapdata_texture = new BitmapData(mc_draw.width, mc_draw.height, false, 0xff000000);
	bitmapdata_texture.draw(canvasBitmapData);
	//TEST: sketch(bitmapdata_texture); (TODO: THIS IS ALSO A COOL EFFECT, ADD THIS...)
	//this is in COLORS.as
	sharpenBitmap(bitmapdata_texture, num_toast_burnAmnt, bool_toast_outline, bool_toast_negative, bool_toast_grayscale);
	
	bitmapdata_texture.draw(bd_toast, new Matrix(1, 0, 0, 1), new ColorTransform(1, 1, 1, .45), BlendMode.OVERLAY);

	//remove temp after setup and adding to texture...
	bd_toast.dispose();
}