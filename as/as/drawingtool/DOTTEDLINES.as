/*
code adapted/inspired from a community discussion from Snipplr
http://www.macromedia.com/devnet/mx/flash/articles/adv_draw_methods.html
and warmforestflash.com

draws a dotted line
speed of mouse also matters in placing the dots
can set dot spacing, dot length, and random dots (like sprinkles on a cake)

*/

//str_tool = "DOTTED LINES"

//DOTTED LINES//
var num_dottedLength:Number = .2;
var num_dottedSpacing:Number = 200;
var num_dottedSprinkle:Number = 0; //random x or y for mouse

/*
usage: in mouse MOVE
//draw_dotted(penSprite, num_prevMouseX, num_prevMouseY, event.localX, event.localY, num_dottedLength, num_dottedSpacing);
draw_dotted(penSprite, Math_randomRange(num_prevMouseX-num_dottedSprinkle, num_prevMouseX+num_dottedSprinkle), Math_randomRange(num_prevMouseY-num_dottedSprinkle, num_prevMouseY+num_dottedSprinkle), Math_randomRange(event.localX-num_dottedSprinkle, event.localX+num_dottedSprinkle), Math_randomRange(event.localY-num_dottedSprinkle, event.localY+num_dottedSprinkle), num_dottedLength, num_dottedSpacing);
//draw to canvas and clear
canvasBitmapData.draw(penSprite);
penSprite.graphics.clear();
*/

function draw_dotted(target:Sprite, x1: Number, y1: Number, x2: Number, y2: Number, dashLength: Number = 5, spaceLength: Number = 5): void {

	var x: Number = x2 - x1;
	var y: Number = y2 - y1;
	var hyp: Number = Math.sqrt((x) * (x) + (y) * (y));
	var units: Number = hyp / (dashLength + spaceLength);
	var dashSpaceRatio: Number = dashLength / (dashLength + spaceLength);
	var dashX: Number = (x / units) * dashSpaceRatio;
	var spaceX: Number = (x / units) - dashX;
	var dashY: Number = (y / units) * dashSpaceRatio;
	var spaceY: Number = (y / units) - dashY;
	
	target.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);
	target.graphics.moveTo(x1, y1);
	
	while (hyp > 0) {
		x1 += dashX;
		y1 += dashY;
		hyp -= dashLength;
		if (hyp < 0) {
			x1 = x2;
			y1 = y2;
		}
		target.graphics.lineTo(x1, y1);
		x1 += spaceX;
		y1 += spaceY;
		target.graphics.moveTo(x1, y1);
		hyp -= spaceLength;
		
	}
	//
	target.graphics.moveTo(x2, y2);
}