/*
code addapted from experiments on ActionSnippet and other community tinkering...
distorts the canvas bitmap with perlin noise, or just noise. distortion is random, and also depends on how often the user screamed into the void...
*/
//str_tool = "SCREAM INTO THE VOID"

//SCREAM INTO THE VOID//
var num_voidScreams:Number = 0;//keep track of how often you screamed
var str_voidScreams:String = ""; //comment about screaming into the void

//usage:
//scream_into_the_void(canvasBitmapData);
//num_voidScreams += 1;
function scream_into_the_void(bmd: BitmapData) {
	//
	//scaleX = scaleY = 1; //0.5;
	var w: int = bmd.width;
	var hw: int = w / 2;
	var hhw: int = hw / 2;
	var size: int = bmd.width * bmd.height;
	var col:uint;
	//random perlin SOMETIMES
	if(Math.random()*100 > 70 && num_voidScreams > 5){
		bmd.perlinNoise(hhw, hhw, 2, Math.random() * 100, false, false, 1, true);
	};
	//
	for (var i: int = 0; i < size; i++) {
		var xp: int = i % w;
		var yp: int = int(i / w);
		//
		if(Math.random()*100 > 50 && num_voidScreams > 10){
			col = bmd.getPixel(xp, yp) / (xp + yp - w/Math_randomRange(1, 5)) >> 5 & 0xFF;
		}else{
			col =  bmd.getPixel(xp, yp) / (xp|yp-w)>> 8 & 0xFF;
		};
		//
		bmd.setPixel(xp, yp, col << 16 | col << 8 | col);
	}
	//
	if(Math.random()*100 > 60){
		var blur:BitmapData = bmd.clone();
		blur.applyFilter(blur, blur.rect, new Point(0,0), new BlurFilter(10,10,1));
		bmd.draw(blur, null, null, BlendMode.DARKEN);
		blur.dispose();
	};
}