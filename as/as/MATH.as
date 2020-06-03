//MATH
//include "as/Maths.as";
//

function RGBtoRGBA(hexStr:String,alpha:uint):uint{
    var rgb:uint = (uint)(hexStr.replace("#","0x"));
    var a:uint = (uint)((alpha * .01) * 255);
    return (rgb << 8 | a);
}

function toARGB(rgb:uint, newAlpha:uint):uint{
  var argb:uint = 0;
  argb = (rgb);
  argb += (newAlpha<<25); //24
  return argb;
}

function hex_to_ARGB(col:uint, a:uint){
	
	var rgb:uint = col;
	var a:uint = (uint)((a * .01) * 255);
	var rgba:uint = rgb << 8 | a;
	var argb:uint = a << 24 | rgb;
	
	return argb;
};

//returns maximum pixels per inch supported by printer
function return_max_DPI(){
	var printJob: PrintJob = new PrintJob();
	return printJob.maxPixelsPerInch;
}

//convert inches to pixels
function inch_toPixel(inches:Number):int{
	return Math.round(Capabilities.screenDPI*inches);
}
//millimeters to pixel
function mm_toPixel(mm:Number):int{
	return Math.round(Capabilities.screenDPI*(mm/25.4));
}

//save mm as pixels at 72 dpi
function return_mmAsPixel(mm:Number){
	return Math.round(72 * (mm / 25.4));
}

function radiansToDegrees(radians:Number):Number {
	var degrees:Number = radians * (180 / Math.PI);
	return degrees;
}

function degreesToRadians(degrees:Number):Number {
	var radians:Number = degrees * (Math.PI / 180);
	return radians;
}

//make number to decimal (for alpha 100 becomes 1, 50 becomes 0.5...)
function convert_to_decimal(num:Number){
	var _format:Number = num * 0.01;
	return _format;
}

//format a number
function formatNumber(num:Number) {
	var nf: NumberFormatter = new NumberFormatter("en-US");
	return (nf.formatNumber(num));
};

//random number range
function Math_randomRange(num_min:Number, num_max:Number){
	return Math.ceil(num_min + (num_max - num_min) * Math.random());
}
//same as above but decimal
function Math_randomRange_dec(num_min:Number, num_max:Number){
	return num_min + (num_max - num_min) * Math.random();
}

//random sign (utils) -- return 1 or -1 ...
function randomSign(chance: Number = 0.5): int {
	return (Math.random() < chance) ? 1 : -1;
}

//
function range(min:Number, max:Number){
	return min + (max - min) * Math.random();
}

function randomNumber(n:Number) {
	return Math.ceil(Math.random()*n);
}

//return percent (100)
function return_percent(currVal:Number, totalVal:Number){
	var calc_percent:Number = Math.ceil((currVal/totalVal)*100);
	return calc_percent;
}

//extract number from this string (regexp)
//var str:String = regex_getNumber("this10test"), returns 10
function regex_getNumber(str:String){
	return str.replace(/[^\d.]/g,"");
}

//
//calculate the rotation and friction of a clip in relation to a target location
function Math_frictionRotation(clip:MovieClip, target, num_fric:Number) {
	//
	//how far and friction
	var num_distX:Number = (target.x-clip.x)/num_fric;
	var num_distY:Number = (target.y-clip.y)/num_fric;
	//
	//calculate rotation
	var num_rads:Number = Math.atan2(num_distY, num_distX);
    var num_degs:Number = Math.round(num_rads*180/Math.PI)+90;
	//
	//apply all of the above
	clip.x += num_distX;
	clip.y += num_distY;
    clip.rotation = num_degs;
}
//

//positive or negative
function mathPosNeg(num) {
	if(Math.random()*100 > 70){
		num = num;
	}else{
		num = num*-1;
	}
    return num;
}