/*
code adapted from AS3 photo booth filters
rakuto.blogspot.com/2008/02/as3filters-photo-boothas3.html stackoverflow and the AS3 docs
largely inspired from an old article in the AS3 docs (likely not online anymore)

this is a windowed tool, it edits and updates a cloned bitmap of the canvas made with create_canvasDemo()...
the clone is edited. when the tool is closed, changes are saved to the main canvas.
this uses DisplacementMapFilters to get the effects
see DISPLACEMENT.as...
*/

//str_tool = "GLASS STAMPS"
//GLASS STAMPS VALUES//
//types of filters and stamps (for random)
var arr_glassStamp_filters:Array = new Array("fisheye", "twirl", "bulge", "squeeze", "pinch", "tunel", "stretch");
var arr_glassStamp_types:Array = new Array("square", "circle");
//currently selected type
var str_glassStamp_currType:String = "circle";
var str_glassStamp_currFilter:String = "twirl";
//values for glass stamps (shared)
var num_glassStamp_radius: uint = 50;//stamp size value
var shape_glassStamp_xCircle: Shape;
var shape_glassStamp_yCircle: Shape;
//maps
var bitmapData_glassStamp_map: BitmapData;
var bitmapData_glassStamp_mapBitmap: Bitmap;
//values for all fields
var num_glassStamp_twirl:Number = 5;
var num_glassStamp_buldge:Number = .5;
var num_glassStamp_squeeze:Number = 1.1;
var num_glassStamp_pinch:Number = .35;
var num_glassStamp_strech:Number = 100;
var num_glassStamp_lense:Number = 0.8;
//value for size text field
//var num_glassStamp_size:Number = 50;
//should you draw or stamp the glass stamp
var bool_glassStamp_stamp:Boolean = true;
////////////////////////

//set up the maping shapes and gradients
//shape is mapped from a sprite that's drawn and added to the UI
function glassStamp_setupCircles(str_type:String = "circle"){
	//clear sprites first
	try{
		shape_glassStamp_xCircle.graphics.clear();
		shape_glassStamp_yCircle.graphics.clear();
	}catch(e:Error){
		//trace(e);
	}
	// Create the gradient circles that will together form the  
	// displacement map image
	//THIS IS THE SQUARE OR CIRCULAR SELECTION, TOGGLE BETWEEN "LINEAR" OR "RADIAL"
	var type: String = GradientType.LINEAR;
	//if(str_type == "LINEAR"){
	//	type = GradientType.LINEAR;
	//}else{
	//	type = GradientType.RADIAL;
	//};
	//
	var redColors: Array = [0xFF0000, 0x000000];
	var blueColors: Array = [0x0000FF, 0x000000];
	var alphas: Array = [1, 1];
	var ratios: Array = [0, 255];
	var xMatrix: Matrix = new Matrix();
	xMatrix.createGradientBox(num_glassStamp_radius * 2, num_glassStamp_radius * 2);
	var yMatrix: Matrix = new Matrix();
	yMatrix.createGradientBox(num_glassStamp_radius * 2, num_glassStamp_radius * 2, Math.PI / 2);
	
	//genearte the shapes
	shape_glassStamp_xCircle = new Shape();
	shape_glassStamp_xCircle.graphics.lineStyle(0, 0, 0);
	shape_glassStamp_xCircle.graphics.beginGradientFill(type, redColors, alphas, ratios, xMatrix);
	
	if(str_type == "circle"){
		shape_glassStamp_xCircle.graphics.drawCircle(num_glassStamp_radius, num_glassStamp_radius, num_glassStamp_radius);
	}else{
		shape_glassStamp_xCircle.graphics.drawRect(0,0,num_glassStamp_radius*2,num_glassStamp_radius*2);
	};

	shape_glassStamp_yCircle = new Shape();
	shape_glassStamp_yCircle.graphics.lineStyle(0, 0, 0);
	shape_glassStamp_yCircle.graphics.beginGradientFill(type, blueColors, alphas, ratios, yMatrix);
	
	if(str_type == "circle"){
		shape_glassStamp_yCircle.graphics.drawCircle(num_glassStamp_radius, num_glassStamp_radius, num_glassStamp_radius);
	}else{
		shape_glassStamp_yCircle.graphics.drawRect(0,0,num_glassStamp_radius*2,num_glassStamp_radius*2);
	};
};

function glassStamps_clearSprites(){
	try{
		mc_glass_stamps.mc_ico_circle.mc_loader.removeChild(bitmapData_glassStamp_mapBitmap);
	}catch(e:Error){
		//null
	}
	try{
		mc_glass_stamps.mc_ico_square.mc_loader.removeChild(bitmapData_glassStamp_mapBitmap);
	}catch(e:Error){
		//null
	}
	try{
		mc_glass_stamps.mc_ico_random.mc_loader.removeChild(bitmapData_glassStamp_mapBitmap);
	}catch(e:Error){
		//null
	}
	try{
		//
		bitmapData_glassStamp_map.dispose();
		bitmapData_glassStamp_mapBitmap = null;
		//
	}catch(e:Error){
		//null
	}
}

//set up the stamp (add child into previews)
function glassStamp_setupMap(str_filter:String, icoClip:MovieClip, bool_isRandom:Boolean = false){
	//
	var filter: DisplacementMapFilter;
	var region: Rectangle = new Rectangle(0, 0, num_glassStamp_radius * 2, num_glassStamp_radius * 2);
	//remove icon first before re-generating
	glassStamps_clearSprites();
	// Create the map image by combining the two gradient circles. 
	bitmapData_glassStamp_map = new BitmapData(shape_glassStamp_xCircle.width, shape_glassStamp_xCircle.height, false, 0x7F7F7F); //0x7F7F7F
	bitmapData_glassStamp_map.draw(shape_glassStamp_xCircle);
	var yMap: BitmapData = new BitmapData(shape_glassStamp_yCircle.width, shape_glassStamp_yCircle.height, false, 0x7F7F7F); //0x7F7F7F
	yMap.draw(shape_glassStamp_yCircle);
	bitmapData_glassStamp_map.copyChannel(yMap, yMap.rect, new Point(0, 0), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
	yMap.dispose();

	//////DISPLAY IN UI AS CURRENT SELECTION -- ALSO MAKE BLACK AND WHITE
	// Display the map image on the Stage, for reference. 
	bitmapData_glassStamp_mapBitmap = new Bitmap(bitmapData_glassStamp_map);
	//add here
	icoClip.mc_loader.addChild(bitmapData_glassStamp_mapBitmap);
	//restrict size
	icoClip.mc_loader.width = 100;
	icoClip.mc_loader.height = 100;
	
	//MANAGE VALUES ACORDING TO UI INPUT HERE (REFRESH ON KEY DOWN)
	//the bool_isRandom is a quick hack, each needs to have a random value if you are generating a random one
	//random value for bool_isRandom is independent of other UI elements
	if(str_filter == "twirl"){
		if(!bool_isRandom){
			filter = twirlFilter(bitmapData_glassStamp_map, region, num_glassStamp_twirl);
		}else{
			filter = twirlFilter(bitmapData_glassStamp_map, region, Math_randomRange(2, 500));
		}
	}
	if(str_filter == "bulge"){
		if(!bool_isRandom){
			filter = bulgeFilter(bitmapData_glassStamp_map, region, num_glassStamp_buldge);
		}else{
			filter = bulgeFilter(bitmapData_glassStamp_map, region, Math_randomRange(2, 500));
		}
	}
	if(str_filter == "squeeze"){
		if(!bool_isRandom){
			filter = squeezeFilter(bitmapData_glassStamp_map, region, num_glassStamp_squeeze);
		}else{
			filter = squeezeFilter(bitmapData_glassStamp_map, region, Math_randomRange(2, 500));
		}
	}
	if(str_filter == "pinch"){
		if(!bool_isRandom){
			filter = pinchFilter(bitmapData_glassStamp_map, region, num_glassStamp_pinch);
		}else{
			filter = pinchFilter(bitmapData_glassStamp_map, region,  Math_randomRange_dec(2, 500));
		}
	}
	if(str_filter == "tunel"){
		filter = photicTunnelFilter(bitmapData_glassStamp_map, region);
	}
	if(str_filter == "stretch"){//
		if(!bool_isRandom){
			filter = strechFilter(bitmapData_glassStamp_map, num_glassStamp_strech);
		}else{
			filter = strechFilter(bitmapData_glassStamp_map, Math_randomRange_dec(.001, 500));
		}
	}
	//if(str_filter == "mirror"){
	//	bitmapData_glassStamp_map = mirror(bitmapData_glassStamp_map, 5);
	//}
	if(str_filter == "fisheye"){//
		if(!bool_isRandom){
			filter = fisheyeFilter(bitmapData_glassStamp_map, num_glassStamp_lense);
		}else{
			filter = fisheyeFilter(bitmapData_glassStamp_map, Math_randomRange(.01, 5));
		}
	}
	//apply filter now
	bitmapData_glassStamp_map.applyFilter(bitmapData_glassStamp_map, bitmapData_glassStamp_map.rect, new Point(0, 0), filter);
};

//this function creates the displacement. should be called on mouseMove 
function glassStamp_magnify(_bitmap:Bitmap, x_mouse, y_mouse): void {
	// Position the filter. 
	var filterX: Number = (x_mouse) - (bitmapData_glassStamp_map.width / 2);
	var filterY: Number = (y_mouse) - (bitmapData_glassStamp_map.height / 2);
	var pt: Point = new Point(filterX, filterY);
	var xyFilter: DisplacementMapFilter = new DisplacementMapFilter();
	xyFilter.mapBitmap = bitmapData_glassStamp_map;
	xyFilter.mapPoint = pt;
	// The red in the map image will control x displacement. 
	xyFilter.componentX = BitmapDataChannel.RED;
	// The blue in the map image will control y displacement. 
	xyFilter.componentY = BitmapDataChannel.BLUE;
	xyFilter.scaleX = 35;
	xyFilter.scaleY = 35;
	xyFilter.mode = DisplacementMapFilterMode.IGNORE;
	bitmap_canvasDemo.filters = [xyFilter];
}

function update_glassStamp(str_filter:String, str_type:String, iconClip:MovieClip, bool_isRandom:Boolean = false){

	glassStamp_setupCircles(str_type);
	glassStamp_setupMap(str_filter, iconClip, bool_isRandom);
	
};