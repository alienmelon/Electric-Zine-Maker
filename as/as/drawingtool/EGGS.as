/*
adapted from the dead code preservation project (as3 works from wonderfl.net) wa.zozuar.org
this used to be a "meme" and was kind of an iconic effect for a while, therefore it is included as a tool throwing back to that...
eggs is a tool that draws lines and ocasionally sets splashies. lines and splashes are both different colors, and there are a number of options to adjust the tool's effects. the best is the "glitch" effect with takes advantage of a graphical glitch and draws extremely wild lines. this one will probably be the hardest to port (although it's very important that behavior is identical since it also throws back to a popular Flash specific visual style that was once popular on "high end" designer websites).
*/

//str_tool = "EGGS"

///////EGGS TOOL/////////////
var egg_sprite: Sprite = new Sprite();
//set the type of egg (round or square) and the "mood" (chaotic, nice...)
var str_eggType:String = "round"; //"round" "cubed"
var str_eggMood:String = "good"; //"good" "messy" "chaos" "eggnog" "glitch"
//egg colors
var ct_eggCol1:ColorTransform = new ColorTransform();
var ct_eggCol2:ColorTransform = new ColorTransform();
var egg_color1: uint = 0xFFFAD3;
var egg_color2: uint = 0xFFCC00;
var str_currEggColor:String = "1"; //currently selected egg tab
//egg filter array & filters (used for eggnog)
var filter_eggGlow:GlowFilter = new GlowFilter();
var arr_eggFilters:Array = new Array();
//filter settings
var num_eggGlow_blur:Number = 5;
var num_eggGlow_strength:Number = 2;
////////////////////////

//EGG DRAWING
//first run
function egg_init(){
	egg_delete();//in case it exists already
	mc_draw.addChild(egg_sprite);
	egg_updateFilters();
}
//delete the egg
function egg_delete(){
	//
	arr_eggFilters = [];
	//
	try{
		egg_sprite.filters = [];
		egg_sprite.graphics.clear();
	}catch(e:Error){
		trace("null egg filters");
	}
	//
	try{
		mc_draw.removeChild(egg_sprite);
	}catch(e:Error){
		trace("null egg");
	}
}
//set the egg's filter
//updated whenever a color change happens
//or if you enable/disable eggnog
//call whenever switching egg modes
function egg_updateFilters(){
	//GHOST EGG
	//TURN KNOCKOUT ON AND MAKE IT A DARKER COLOR
	//when turning on ghostegg, enable knockout and hide the color tab that's not in use
	//encourage them to change the colors
	//default values stay the same (glow is very faint)
	filter_eggGlow.blurX = filter_eggGlow.blurY = num_eggGlow_blur;
	filter_eggGlow.alpha = .5;
	filter_eggGlow.color = egg_color1;
	filter_eggGlow.inner = false;
	//if eggnog or not
	if(str_eggMood == "eggnog"){
		filter_eggGlow.knockout = true;
	}else{
		filter_eggGlow.knockout = false;
	}
	filter_eggGlow.quality = BitmapFilterQuality.HIGH;
	filter_eggGlow.strength = num_eggGlow_strength;

	//reset filters first (in case updated)
	arr_eggFilters = [];
	egg_sprite.filters = [];
	//push new
	arr_eggFilters.push(filter_eggGlow);
	egg_sprite.filters = arr_eggFilters;
};
//update the eggo coords for MOUSE_DOWN
//first click...
function egg_setCoords(event_localX:Number, event_localY:Number){
	//update coords...
	num_curMouseX = event_localX;
	num_curMouseY = event_localY;
	num_prevMouseX = event_localX;
	num_prevMouseY = event_localY;
	//move to
	egg_sprite.graphics.moveTo(event_localX, event_localY);
};

//paint with egg (MOUSE_MOVE)
function egg_paint(event_localX:Number, event_localY:Number){
	//
	var distance: Number = Math.sqrt(Math.pow(num_prevMouseX - num_curMouseX, 2) + Math.pow(num_prevMouseY - num_curMouseY, 2));
	var a: Number = distance * 10 * (Math.pow(Math.random(), 2) - 0.5);
	var r: Number = Math.random() - 0.5;
	//size determined by pen size slider
	var size: Number = Math.random() * num_pen_size / distance;
	//
	var paintSize:Number = ((Math.random() + num_pen_size / 10 - 0.5) * size + (1 - Math.random() + num_pen_size / 20 - 0.5) * size);
	//
	var color:uint;
	//These are set in the UI (toggle)
	var capsStyle;
	var jointStyle;
	//set caps and joint...
	if(str_eggType == "round" && str_eggMood != "chaos" && str_eggMood != "glitch"){
		capsStyle = CapsStyle.ROUND;
	}else{
		//cubed
		capsStyle = CapsStyle.SQUARE;
	};
	if(str_eggType == "round" && str_eggMood != "chaos" && str_eggMood != "glitch"){
		jointStyle = JointStyle.BEVEL;
	}else{
		//cubed
		jointStyle = JointStyle.MITER;
	}
	//control the colors
	if(Math.ceil(a) == Math.ceil(r) || size > distance && Math.random()*100 > 90){
		color = egg_color1;
	}else{
		color = egg_color2;
	}
	//
	if(size > distance/2){
		color = egg_color1;
	}
	
	//IF size is bigger than something set color to darker
	//if size is smaller then color is lighter

	num_mouseDisX = (num_prevMouseX - num_curMouseX) * Math.sin(0.5) + num_curMouseX;
	num_mouseDisY = (num_prevMouseY - num_curMouseY) * Math.cos(0.5) + num_curMouseY;
	
	num_curMouseX = num_prevMouseX;
	num_curMouseY = num_prevMouseY;
	num_prevMouseX = event_localX;
	num_prevMouseY = event_localY;
	
	////////////////////
	
	egg_sprite.graphics.beginFill(color);
	
	//this is necessary. it breaks if it's not here. this is the glitch feature
	if(str_eggMood != "glitch"){
		egg_sprite.graphics.moveTo(num_curMouseX, num_curMouseY);
	};
	
	//CHAOS
	if(str_eggMood == "chaos" || str_eggMood == "glitch"){
		egg_sprite.graphics.curveTo(Math_randomRange_dec(num_mouseDisX-10, num_mouseDisX+10), Math_randomRange_dec(num_mouseDisY-10, num_mouseDisY+10), Math_randomRange_dec(num_prevMouseX-10, num_prevMouseX+10), Math_randomRange_dec(num_prevMouseY-10, num_prevMouseY+10));
		egg_sprite.graphics.curveTo(num_mouseDisX, num_mouseDisY, num_prevMouseX + r, num_prevMouseY + r + a); //make a leaf. reamove r and a for normal curve...
	};
	//MESSY
	if(str_eggMood == "messy"){
		egg_sprite.graphics.curveTo(Math_randomRange_dec(num_mouseDisX-50, num_mouseDisX+50), Math_randomRange_dec(num_mouseDisY-50, num_mouseDisY+50), Math_randomRange_dec(num_prevMouseX-10, num_prevMouseX+10), Math_randomRange_dec(num_prevMouseY-10, num_prevMouseY+10));
	}
	
	//if square (default line always shows ALONG WITH curveTO)
	egg_sprite.graphics.moveTo(num_curMouseX, num_curMouseY);
	egg_sprite.graphics.lineTo(num_prevMouseX, num_prevMouseY);
	
	egg_sprite.graphics.lineStyle(paintSize, color, 1, false, LineScaleMode.NONE, capsStyle, jointStyle);
	
	//this makes the splotches (remove for chaos)
	if(str_eggMood != "chaos" && str_eggMood != "glitch"){
		egg_sprite.graphics.moveTo(num_curMouseX + a, num_curMouseY + a);
	};
	
	egg_sprite.graphics.lineTo(num_curMouseX + r + a, num_curMouseY + r + a);
	//
	
	if(str_eggMood != "chaos" && str_eggMood != "glitch"){
		egg_sprite.graphics.lineStyle(paintSize, color, 1, false, LineScaleMode.NONE, capsStyle, jointStyle);
	};
	
	egg_sprite.graphics.endFill();
	
};