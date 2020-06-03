/*
code partly addapted from HIDIHO en.nicoptere.net (site has been archived)
see also: http://www.barradeau.com/hidiho/index.html
can customize an inky brush stroke
smoothness also depends on speed of drawing
can be ink or can be set to a range to draw random lines within a range around the mouse
alpha can be set for more gentle art (shading)

this is a very modified version of the PEN/ERASE tool
*/

//str_tool = "CUSTOM INK"

//CUSOM INK//
var customInk_brush:Shape = new Shape();
//input values
var num_customInk_maxSize:Number = 2;
var num_customInk_precision:Number = 30; //higher values = precise & thicker stroke (10 - 30 = recommended range)
var num_customInk_alpha:Number = 5;
//custom ink random linerange to control current xy and prev xy
var num_customInk_lineRange_X1:Number = 10;
var num_customInk_lineRange_Y1:Number = 10;
var num_customInk_lineRange_X2:Number = 10;
var num_customInk_lineRange_Y2:Number = 10;
//bool for controling randomness
var bool_customInk_lineRange:Boolean = false; //no range keeps it restricted to cursor, range lets you control line randomness around cursor

//the draw function
//exmaple (on move):
//set cur xy
//call: customInk_draw(customInk_brush.graphics, [new Point(num_curMouseX, num_curMouseY), new Point(num_prevMouseX, num_prevMouseY)], canvas);
//set prev xy
function customInk_draw(graphics:Graphics, pts:Array, _bitmapData:BitmapData, color:uint = 0){
	var i:int;
	var j:int;
	var tmp:Array;
	var strokeWeight:Number = num_customInk_maxSize;
	var strokeAlpha:Number = convert_to_decimal(num_customInk_alpha);
	var points:Array = pts;
	//
	customInk_brush.graphics.lineStyle(0, color);
	//
	for( i = 0; i < points.length; i++ )
	{
		//set x/y values
		var p0:Point = points[i];
		var p1:Point = points[(i + 1) % points.length ];
		//customInk_calcPoints the stroke with new x/y values (pecision is an input)
		tmp = customInk_calcPoints( p0, p1, num_customInk_precision);
		j = 0;
		//move to new points
		customInk_brush.graphics.moveTo( tmp[0].x, tmp[0].y );
		//make stroke random
		while( j < tmp.length ) 
		{
			//restrict sizes
			strokeWeight += ( Math.random() - .5 ) * 2;
			strokeWeight = ( strokeWeight > 20 ) ? 20 : ( strokeWeight < 1 ) ? 1 : strokeWeight;
			//
			customInk_brush.graphics.lineStyle( strokeWeight + Math.random(), color, strokeAlpha);
			//if it should be drawn as a range around the mouse, or a straight smooth line
			if(!bool_customInk_lineRange){
				customInk_brush.graphics.lineTo( tmp[j].x, tmp[j].y );
			}else{
				customInk_brush.graphics.lineTo( Math_randomRange(tmp[j].x - num_customInk_lineRange_X1, tmp[j].x + num_customInk_lineRange_Y1), Math_randomRange(tmp[j].y - num_customInk_lineRange_X2, tmp[j].y + num_customInk_lineRange_Y2))
			}
			//increment
			j++;
			//
		}
		
	}
	//draw and clear
	_bitmapData.draw(customInk_brush, customInk_brush.transform.matrix, null);
	customInk_brush.graphics.clear();
	
	//for testing... TODO: ADD MORE EFFECTS TO THIS
	// var blur:BitmapData = canvas.clone();
	// blur.applyFilter(blur, blur.rect, new Point(0,0), new BlurFilter(10,10,1));
    //canvas.draw(blur);//, null, null, BlendMode.ADD);
}

//adjust line and velocity
function customInk_calcPoints( p0:Point, p1:Point, precision:int = 20 ):Array
{
	var tmp:Array = [];
	//
	var ox:Number = p0.x;
	var oy:Number = p0.y;
	var dx:Number = p1.x - ox;
	var dy:Number = p1.y - oy;
	//
	var offset:Number = Math.sqrt( dx*dx + dy*dy ) / 100;
	var angle:Number = Math.atan2( dy, dx );
	var intermediate:Point;
	var multi:Number = ( 1 + Math.random() * 5 ) * ( (Math.random() > .5 ) ? 3 : 1 );
	//
	var t:Number = 0;
	var step:Number = 1 / precision;
	//calc
	ox += Math.cos( angle ) * -offset * multi;
	oy += Math.sin( angle ) * -offset * multi;
	//
	dx += Math.cos( angle ) * offset * multi*2;
	dy += Math.sin( angle ) * offset * multi*2;
	//
	while( t <= 1 )
	{
		//
		t += step;
		intermediate = new Point();
		//
		intermediate.x = ox + ( dx * t ) + ( Math.random() - .5 ) * offset;
		intermediate.y = oy + ( dy * t ) + ( Math.random() - .5 ) * offset;
		//
		tmp.push( intermediate );
	}
	//
	return tmp;
}