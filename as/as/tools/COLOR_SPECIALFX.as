//special bitmap effects used in color factory

//FUZZY vars
var int_fuzzy_iterator: int = 0;
var fuzzy_canvas: Shape;
fuzzy_canvas = new Shape();
//values set in the UI
var num_fuzzy_scanSpeed:Number = 1;
var num_fuzzy_segment:Number = 10;
var num_fuzzy_fuzziness:Number = .01;
var num_fuzzy_hairLength:Number = 5;
var num_fuzzy_randomHair:Number = 20;
var bool_fuzzy_unrulyHair:Boolean = true;
var bool_fuzzy_badHairday:Boolean = false;

//ASCII art vals
var str_colorfactory_ascii:String = ""; //save the string for outputting to text

//FUZZY EFFECT (see Fuzzy.as for class)
//first run
function setupFuzzy(src:BitmapData, srcBitmap:Bitmap){

}
//reset (when loading ui, etc...)
function resetFuzzy(src:BitmapData, srcBitmap:Bitmap){

}
//delete fuzzy (fully delete)
function deleteFuzzy(){

}
//call when scanning (enter_frame or interval)
function nextFuzzy(src:BitmapData, srcBitmap:Bitmap) {

}
function fuzzyCalcScan(bd: BitmapData) {	

}

//PERLIN TEXTURE (add perlin noise over an image to texture it)
function perlin_texture( input:Bitmap, scale:Number = 1, alpha:Number = 1, baseX:Number = 5, baseY:Number = 5, numOctaves:uint = 2, randomSeed:int = 1, stitch:Boolean = false, fractalNoise:Boolean = false, channelOptions:uint = 7, grayScale:Boolean = false, smooth:Boolean = true ){
	//
	trace("stitch: " + stitch);
	trace("fractalNoise: " + fractalNoise);
	trace("grayScale: " + grayScale);
	//set a random seed if a value isn't exactly set
	if(randomSeed == 1) randomSeed = Math.random() * 0xFFFFFF;
	//adjust scale
    if( scale > 1 ) scale = 1;
	//
    var bd:BitmapData = input.bitmapData.clone();
    bd.perlinNoise(baseX, baseY, numOctaves, randomSeed, stitch, fractalNoise, channelOptions, grayScale ); //SETTING FOR NOISE
    input.bitmapData.draw( bd, new Matrix( 1 / scale, 0, 0, 1 / scale ), new ColorTransform( 1,1,1, alpha ), BlendMode.OVERLAY, null, smooth );
	bd.dispose();
}

//MIRROR (like a kaleidoscope to bitmaps)
//send it bitmapdata and it draws to it (best on enter_frame)
function bitmapMirror( bd:BitmapData, direction:int = 0 ){
    var w:int = bd.width;
    var h:int = bd.height;
     
    var vertices:Vector.<Number>;
    var indices:Vector.<int>;
    var uvs:Vector.<Number>;
    var p0:Point, p1:Point, p2:Point, p3:Point;
     
    //TOP LEFT -> BOTTOM RIGHT
    if ( direction == 0 ) 
    {
         
        p0 = new Point( 0, h );
        p1 = new Point( 0, 0 );
        p2 = new Point( w, 0 );
        p3 = new Point( w, h );
        uvs = Vector.<Number>( [ 0,1 , 0,0 , 1,0 , 0,0 ] );
         
    }
     
    //TOP RIGHT -> BOTTOM LEFT
    if ( direction == 1 ) 
    {
         
        p0 = new Point( 0, 0 );
        p1 = new Point( w, 0 );
        p2 = new Point( w, h );
        p3 = new Point( 0, h );
        uvs = Vector.<Number>( [ 0,0 , 1,0, 1,1 , 1,0 ] );
         
    }
     
    //BOTTOM RIGHT -> TOP LEFT
    if ( direction == 2 ) 
    {
         
        p0 = new Point( w, 0 );
        p1 = new Point( w, h );
        p2 = new Point( 0, h );
        p3 = new Point( 0, 0 );
        uvs = Vector.<Number>( [ 1,0 , 1,1 , 0,1 , 1,1 ] );
         
    }
     
    //BOTTOM LEFT -> TOP RIGHT
    if ( direction == 3 ) 
    {
         
        p0 = new Point( w, h );
        p1 = new Point( 0, h );
        p2 = new Point( 0, 0 );
        p3 = new Point( w, 0 );
        uvs = Vector.<Number>( [ 1,1 , 0,1 , 0,0 , 0,1 ] );
         
    }
    vertices = Vector.<Number>( [ p0.x, p0.y, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y ] );
    indices = Vector.< int >( [ 0, 1, 2, 0, 2, 3 ] );
     
    for each( var i:Number in vertices ) 
     
    var src:BitmapData = bd.clone();
    var shape:Shape = new Shape();
    shape.graphics.beginBitmapFill( bd, null, false );
    shape.graphics.drawTriangles( vertices, indices, uvs );
    src.draw( shape );
     
    shape = null;
    indices = null;
    vertices = uvs = null;
    p0 = p1 = p2 = p3 = null;
    //return src;
	//draw and dispose
	bd.draw(src);
	src.dispose();
}



//draw ASCII art to canvas
//draw ascii to bitmap, send source bitmap and bitmapdata then update source with ascii
function drawAsciiToBitmap(bp:Bitmap, bpData:BitmapData){
	
	//copy source to bitmapdata
	//generate ascii to it
	//delete ascii and generated...
	
	reduceColors(bpData, 3, true);
	
	var _tempBitmapData: BitmapData = new BitmapData(bp.width, bp.height, false, 0xFFFFFF);
	var _tempBitmap:Bitmap = new Bitmap(bpData);
	
	var font = new ProggyCleanTT();
	var textFormat = new TextFormat();
	textFormat.font = font.fontName;
	textFormat.size = 16;
	textFormat.leading = -9;
	textFormat.letterSpacing = .9;//-.6;
	
	//ascii code goes here
	
	bp.bitmapData.draw(_tempBitmapData);//white first to clear
	
	//delete and clear all
	_tempBitmapData.dispose();
	_tempBitmap = null;
};

//explode the pixels (write it to source bitmap)
function pixelblast(srcBmp: BitmapData) {
	
	var i:uint;
	var j:uint;
	
	var imageWidth: Number = srcBmp.width;
	var imageHeight: Number = srcBmp.height;

	var pixels: ByteArray = srcBmp.getPixels(new Rectangle(0, 0, imageWidth, imageHeight));
	var copyBmp: BitmapData = new BitmapData(imageWidth, imageHeight, false);

	pixels.position = 0;

	for (i = 0; i < imageHeight; i++) {
		for (j = 0; j < imageWidth; j++) {
			copyBmp.setPixel(j + Math.random()*j / j - Math_randomRange(0, 100), i, pixels.readUnsignedInt());
		}
	}
	
	srcBmp.draw(copyBmp);
	
	copyBmp.dispose();
	pixels.clear();
	
};

//cuts upp a bitap into squares and randomly shuffles them
//draw back to source bitmap
function shuffle_bitmap(_bitmap:Bitmap, canvasContainer:MovieClip, num_imgWidth:Number = 10, num_imgHeight:Number = 10, num_rows:Number = 46, num_cols:Number = 65){
	
	//canvasContainer = mc_draw
	//var bp: Bitmap = Bitmap(e.target.content);
	var bpHeight: Number = _bitmap.width / num_rows;
	var bpWidth: Number = _bitmap.height / num_cols;
	
	var imagesArr: Array = new Array();
	var container:Sprite = new Sprite();
	canvasContainer.addChild(container);

	for (var _x: uint = 0; _x < num_rows; _x++) {
		for (var _y: uint = 0; _y < num_cols; _y++) {

			var newBp: Bitmap = new Bitmap(new BitmapData(bpWidth, bpHeight));
			newBp.bitmapData.copyPixels(_bitmap.bitmapData,
				new Rectangle(_x * bpWidth, _y * bpHeight, bpWidth, bpHeight),
				new Point(0, 0));


			//add image holder
			var holder: Sprite = new Sprite();
			holder.x = _x * bpWidth;
			holder.y = _y * bpHeight;
			
			container.addChild(holder);
			holder.addChild(newBp);

			imagesArr.push([holder, newBp]);

		}
	}

	//shuffle pieces 
	if (imagesArr.length == (num_rows * num_cols)) {
		for (var i: uint = 0; i < imagesArr.length; i++) {
			var xPos: int = randomSign() * Math.random() * num_imgWidth / 2;
			var yPos: int = randomSign() * Math.random() * num_imgHeight / 2
			imagesArr[i][1].x = xPos;
			imagesArr[i][1].y = yPos;
		}
	}
	
	//draw to source first
	_bitmap.bitmapData.draw(container, null, null, null, null, true);
	
	//clear everything and delete
	for(var j:Number = 0; j<imagesArr.length; ++j){
		imagesArr[j][0].removeChild(imagesArr[j][1]);
		container.removeChild(imagesArr[j][0]);
	}
	canvasContainer.removeChild(container);

};