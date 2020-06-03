
//TODO: THIS IS BAD, FIX ALL OF IT (SHOULD ONLY HAVE ONE)

//loader for import image. for reading width and height sizes to draw to canvas
var loader_importImage:Loader;

function load_bitmapSprayImage(_bitmapData:BitmapData, num_width:Number, num_height:Number) {
	var fileRef: FileReference;
	fileRef = new FileReference();
	
	_setListeners();
	_openBrowse();

	function _setListeners() {
		//stage.addEventListener(MouseEvent.MOUSE_DOWN, _onDown);
		fileRef.cancel();
		//remove first
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onDown);
		fileRef.removeEventListener(Event.CANCEL, _onCancel);
		fileRef.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
		fileRef.removeEventListener(Event.COMPLETE, _onLoaded);
		//re-add
		//stage.addEventListener(MouseEvent.MOUSE_DOWN, _onDown);
		fileRef.addEventListener(Event.CANCEL, _onCancel);
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, _onError);
	};
	
	function _openBrowse(){
		//
		fileRef.browse([new FileFilter("Images", "*.jpg;*.gif;*.png")]);
		//fileRef.cancel(); // Important
		//
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		fileRef.addEventListener(Event.SELECT, _onSelected);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onDown);
	};

	function _onCancel(evt: Event) {
		trace("_onCancel");
		_setListeners();
	};

	function _onError(evt: IOErrorEvent) {
		trace("error");
		_setListeners();
	}

	function _onDown(evt: MouseEvent): void {
		_openBrowse();
	}

	function _onSelected(evt: Event): void {
		//
		//var fr:File= evt.target as FileReference;
		//
		/*if (fr.type != ".gif" && fr.type!= ".jpg" && fr.type != ".png"){
			trace("ERROR: error loading. file not compatible");
		}else{*/
		//
		fileRef.load();
		//
		fileRef.addEventListener(Event.COMPLETE, _onLoaded);
		fileRef.removeEventListener(Event.SELECT, _onSelected);
	}

	function _onLoaded(evt: Event): void {
		//
		var loader: Loader = new Loader();
		loader.loadBytes(evt.target.data);
		//
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
		//addChild(loader);
		fileRef.removeEventListener(Event.COMPLETE, _onLoaded);
	}

	function _onComplete(e: Event) {
		//
		var loaderInfo: LoaderInfo = e.target as LoaderInfo;
		loaderInfo.removeEventListener(Event.COMPLETE, _onComplete);
		//get loader info as bitmap
		var _bitmap = Bitmap(LoaderInfo(e.target).content);//.bitmapData;
		//
		//var _bitmap_data = Bitmap(LoaderInfo(e.target).content).bitmapData;
		//for reading width/height if needed?
		var loader: Loader = loaderInfo.loader;
		trace("loader size: ", loader.width, loader.height);
		//
		//addChild(bitmap);
		var matrix:Matrix = new Matrix();
		matrix.scale(num_width / loader.width, num_height / loader.height);
		//matrix.scale(num_width*scale, num_height*scale);
		//
		//draw to bitmap
		_bitmapData.draw(_bitmap.bitmapData, matrix, null, null, null, true);
		//
	}
};


function load_penTexture() {
	var fileRef: FileReference;
	fileRef = new FileReference();
	
	_setListeners();
	_openBrowse();

	function _setListeners() {
		//s
		fileRef.cancel();
		//remove first
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onDown);
		fileRef.removeEventListener(Event.CANCEL, _onCancel);
		fileRef.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
		fileRef.removeEventListener(Event.COMPLETE, _onLoaded);
		//re-add
		fileRef.addEventListener(Event.CANCEL, _onCancel);
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		//reset UI so it doesn't allow you to paint empty bitmaps
		mc_imageTexture.visible = false;
		set_tool("PENCIL", btn_pen);
	};
	
	function _openBrowse(){
		//
		fileRef.browse([new FileFilter("Images", "*.jpg;*.gif;*.png")]);
		//
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		fileRef.addEventListener(Event.SELECT, _onSelected);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onDown);
	};

	function _onCancel(evt: Event) {
		trace("_onCancel");
		_setListeners();
	};

	function _onError(evt: IOErrorEvent) {
		trace("error");
		_setListeners();
	}

	function _onDown(evt: MouseEvent): void {
		_openBrowse();
	}

	function _onSelected(evt: Event): void {
		//
		fileRef.load();
		//
		fileRef.addEventListener(Event.COMPLETE, _onLoaded);
		fileRef.removeEventListener(Event.SELECT, _onSelected);
	}

	function _onLoaded(evt: Event): void {
		//
		var loader: Loader = new Loader();
		loader.loadBytes(evt.target.data);
		//
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
		//addChild(loader);
		fileRef.removeEventListener(Event.COMPLETE, _onLoaded);
	}

	function _onComplete(e: Event) {
		//
		var loaderInfo: LoaderInfo = e.target as LoaderInfo;
		loaderInfo.removeEventListener(Event.COMPLETE, _onComplete);
		//get loader info as bitmap
		var _bitmap = Bitmap(LoaderInfo(e.target).content).bitmapData;
		penTextureBitmapData = _bitmap;
		//penTextureBitmapData = _bitmap;
		var loader: Loader = loaderInfo.loader;
		//
		pen_texture.lineStyle(num_pen_size);
		pen_texture.lineBitmapStyle(_bitmap);
		//modify the small tab of image texture
		var matrix:Matrix = new Matrix();
		matrix.scale(mc_imageTexture.mc_imageTexture.width / loader.width, mc_imageTexture.mc_imageTexture.height / loader.height);
		//
		//update the small image tab showing what's loaded
		penTextureBitmap.bitmapData.draw(_bitmap, matrix, null, null, null, true);
		//
		set_tool("TEXTURE PEN", btn_loadTexture);//reset to tool after successful load (listener sets back to PEN incase of cancel...)
		mc_imageTexture.visible = true;
		mc_slider.visible = true;
		
		//
	}
};

//FUNCTIONS FOR THE GENERIC LOADING IMAGE
//called for all states to manage UI
function UI_load_image_default_setListeners(){
	btn_importimage_import01.visible = true;
	btn_importimage_import02.visible = true;
	btn_importAnother.visible = false;
}
function UI_load_image_default_onSelected(){
	btn_importimage_import01.visible = false;
	btn_importimage_import02.visible = false;
}
function UI_load_impage_default_onComplete(){
	btn_importAnother.visible = true;
}
//DISPLACEMENT LOADING IMAGE UI (for blend & displacer-izer)
function UI_load_image_displacement_setListeners(){
	//
	mc_blend_and_displace.btn_load.visible = true;
	mc_blend_and_displace.btn_load_another.visible = false;
	mc_blend_and_displace.mc_hideUI.visible = true;
	trace("UI_load_image_displacement_setListeners()");
}
function UI_load_image_displacement_onSelected(){
	//
	mc_blend_and_displace.btn_load.visible = false;
}
function UI_load_impage_displacement_onComplete(){
	mc_blend_and_displace.btn_load_another.visible = true;
	mc_blend_and_displace.btn_save.visible = true;
	mc_blend_and_displace.mc_hideUI.visible = false;
}
//same as UI load image but for load another
function UI_load_image_displacement_setListeners_loadAnother(){
	UI_load_impage_displacement_onComplete();
	mc_blend_and_displace.mc_hideUI.visible = true;
}

function load_image(clip:MovieClip, num_width:Number, num_height:Number, setListenersFunc:Function, onSelectedFunc:Function, onCompleteFunc:Function, bool_fill:Boolean){
	var fileRef: FileReference;
	fileRef = new FileReference();
	
	_setListeners();
	_openBrowse();

	function _setListeners() {
		//stage.addEventListener(MouseEvent.MOUSE_DOWN, _onDown);
		fileRef.cancel();
		//remove first
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onDown);
		fileRef.removeEventListener(Event.CANCEL, _onCancel);
		fileRef.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
		fileRef.removeEventListener(Event.COMPLETE, _onLoaded);
		//re-add
		//stage.addEventListener(MouseEvent.MOUSE_DOWN, _onDown);
		fileRef.addEventListener(Event.CANCEL, _onCancel);
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		//restart
		setListenersFunc();
	};
	
	function _openBrowse(){
		//
		fileRef.browse([new FileFilter("Images", "*.jpg;*.gif;*.png")]);
		//fileRef.cancel(); // Important
		//
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		fileRef.addEventListener(Event.SELECT, _onSelected);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onDown);
	};

	function _onCancel(evt: Event) {
		trace("_onCancel");
		_setListeners();
	};

	function _onError(evt: IOErrorEvent) {
		trace("error");
		_setListeners();
	}

	function _onDown(evt: MouseEvent): void {
		_openBrowse();
	}

	function _onSelected(evt: Event): void {
		//
		onSelectedFunc();
		//
		fileRef.load();
		//
		fileRef.addEventListener(Event.COMPLETE, _onLoaded);
		fileRef.removeEventListener(Event.SELECT, _onSelected);
	}

	function _onLoaded(evt: Event): void {
		//
		//var loader: Loader = new Loader();
		loader_importImage = new Loader();
		loader_importImage.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		loader_importImage.loadBytes(evt.target.data);
		loader_importImage.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
		//addChild(loader);
		clip.addChild(loader_importImage);
		//
		fileRef.removeEventListener(Event.COMPLETE, _onLoaded);
	}

	function _onComplete(e: Event) {
		//
		var loaderInfo: LoaderInfo = e.target as LoaderInfo;
		loaderInfo.removeEventListener(Event.COMPLETE, _onComplete);
		//get loader info as bitmap
		var _bitmap = Bitmap(LoaderInfo(e.target).content);//.bitmapData;
		//
		//var _bitmap_data = Bitmap(LoaderInfo(e.target).content).bitmapData;
		//for reading width/height if needed?
		loader_importImage = loaderInfo.loader;
		trace("loader size: ", loader_importImage.width, loader_importImage.height);
		//
		var scaleWidth:Number = mc_draw.width / loader_importImage.width;
	    var scaleHeight:Number = mc_draw.height / loader_importImage.height;
		//adjust the scale
		if(bool_fill){
			clip.width = num_width;
			clip.height = num_height;
		};
		//too big for stage
		if(!bool_fill && (loader_importImage.width > 400 || loader_importImage.height > 500)){
			clip.scaleX = mc_draw.scaleX/3;
			clip.scaleY = mc_draw.scaleY/3;
			
		};
		//
		set_transformTool(clip);
		//
		trace("clip size: ", clip_importImage.width, clip_importImage.height);
		//set "import another to true"
		onCompleteFunc();
	}
}

//save to text file
//used for saving ascii art
function saveAsciiToTextFile(str:String, fileName:String){
	var tFR:FileReference = new FileReference();
	tFR.save(str, fileName + ".txt");
}