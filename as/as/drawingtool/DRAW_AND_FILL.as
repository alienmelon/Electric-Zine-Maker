/*
inspired by projects once hosted on wonderfl, and other places like senocular and ctyeung
this code is a simplified version adapted from above
draw a line and fill with chosen color after drawing (mouse up)
auto fill lines...
you can choose line and fill color, you can also set line size and alpha
this is an expanded on version of the pen tool and pen tool values apply to this
*/

//str_tool = "DRAW AND FILL"

//DRAW AND FILL (DRAW AND AUTO FILL ON MOUSE UP)
//DRAW & FILL vars
var pt_drawAndFill_lastPos: Point; //last mouse position
var vec_drawAndFill_pathComnd: Vector.<int>; //graphics path command
var vec_drawAndFill_mousePos: Vector.<Number>; //current mouse position
//DRAW AND FILL color selection in the UI
var ct_drawAndFill_lineCol:ColorTransform = new ColorTransform();
var ct_drawAndFill_fillCol:ColorTransform = new ColorTransform();
var drawAndFill_lineCol: uint = 0x000000;
var drawAndFill_fillCol: uint = 0xFFFFFF;
var str_drawAndFill_currSelection:String = "line"; //UI: currently selected color tab (line or fill)
/////////////////////////////////////

function drawAndFill_startDraw(event_localX:Number, event_localY:Number){
	//
	pt_drawAndFill_lastPos = new Point(event_localX, event_localY);
	vec_drawAndFill_pathComnd = new Vector.<int>();
	vec_drawAndFill_mousePos = new Vector.<Number>();
	vec_drawAndFill_pathComnd.push(GraphicsPathCommand.MOVE_TO);
	vec_drawAndFill_mousePos.push(event_localX);
	vec_drawAndFill_mousePos.push(event_localY);
	//
}

function drawAndFill_moveDraw(event_localX:Number, event_localY:Number){
	//
	penSprite.graphics.lineStyle(num_pen_size, drawAndFill_lineCol);
	penSprite.graphics.moveTo(pt_drawAndFill_lastPos.x, pt_drawAndFill_lastPos.y);
	penSprite.graphics.lineTo(event_localX, event_localY);
	pt_drawAndFill_lastPos.x = event_localX;
	pt_drawAndFill_lastPos.y = event_localY;
	//update vectors for filling on mouse up...
	vec_drawAndFill_pathComnd.push(GraphicsPathCommand.LINE_TO);
	vec_drawAndFill_mousePos.push(event_localX);
	vec_drawAndFill_mousePos.push(event_localY);
	//
}

function drawAndFill_endDraw(){
	//
	penSprite.graphics.beginFill(drawAndFill_fillCol);
	//drawPath(commands:Vector.<int>, mousePos:Vector.<Number>, winding:String = "evenOdd"):void
	penSprite.graphics.drawPath(vec_drawAndFill_pathComnd, vec_drawAndFill_mousePos, GraphicsPathWinding.EVEN_ODD); //NON_ZERO
	penSprite.graphics.endFill();
	//important to clear all first, else error occurs with penSprite colors between tools...
	drawAndFill_clear();
	//push to canvas here
	canvasBitmapData.draw(penSprite, penSprite.transform.matrix);
	//clear all pen sprites and start over...
	penSprite.graphics.clear();
	//
}

//clear all values and vectors (reset)
function drawAndFill_clear(){
	pt_drawAndFill_lastPos = null;
	vec_drawAndFill_pathComnd.length = 0;
	vec_drawAndFill_mousePos.length = 0;
}

/*
usage:
on mouse move:
	drawAndFill_moveDraw(event.localX, event.localY);
	
on mouse up:
	drawAndFill_endDraw();
	
on mouse down:
	drawAndFill_startDraw(event.localX, event.localY);
*/