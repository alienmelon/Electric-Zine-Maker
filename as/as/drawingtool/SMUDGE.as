/*
code for the smudge tool

smudges colors by blending a copied gradient over the surface
addapted from code found on snipplr (social snipped repository), actionsnippet, and stack overflow
*/

//SMUDGE
//str_tool = "SMUDGE"
var smudge_brush:Shape = new Shape();
var smudge_diameter:Number = num_pen_size;
var smudge_radius:Number = smudge_diameter / 2;
var smudge_matrix:Matrix = new Matrix();
//setup
var smudge_brushAlpha:BitmapData = new BitmapData(smudge_diameter, smudge_diameter, true, 0x00000000);
//calc vals
var s_xp:Number = 0, s_yp:Number = 0, s_px:Number = 0, s_py:Number = 0;
var s_dx:Number, s_dy:Number;

function event_smudge_MOVE(evt:MouseEvent):void {
    s_xp = evt.localX - smudge_radius;
    s_yp = evt.localY - smudge_radius;
    s_dx = s_xp - s_px;
    s_dy = s_yp - s_py;
    canvasBitmapData.copyPixels(canvasBitmapData,
                    new Rectangle(s_px, s_py, smudge_diameter, smudge_diameter),
                    new Point(s_xp, s_yp), smudge_brushAlpha, new Point(0,0), true);
    s_px = s_xp;
    s_py = s_yp
}

//TODO: different customizable gradient types to add texture to the smudges...
function smudge_drawRadial(){
    smudge_matrix.createGradientBox(smudge_diameter, smudge_diameter, 0, 0, 0);
    with (smudge_brush.graphics){
        beginGradientFill(GradientType.RADIAL, [0xFFFFFF, 0xFFFFFF], [1,0], [0, 255], smudge_matrix, SpreadMethod.PAD); //REFLECT REPEAT
        drawCircle(smudge_radius, smudge_radius, smudge_radius);
    }
}

//INIT
function init_smudge(){
	smudge_drawRadial();
	smudge_brushAlpha.draw(smudge_brush);
}

//called when brush size is updated
function reset_smudge(){
	//
	//clear smudge_brushAlpha
	//start again...
	//
	s_xp = 0;
	s_yp = 0;
	s_px = 0;
	s_py = 0;
	s_dx = 0;
	s_dy = 0;
	//reset radius size based on pen size...
	smudge_diameter = calc_scrubber_val(mc_slider, num_minVal, num_maxVal_tool);
	smudge_radius = smudge_diameter / 2;
	//reset matrix
	smudge_matrix = null;
	smudge_matrix = new Matrix();
	smudge_brush.graphics.clear();
	//
	try{
		smudge_brushAlpha.dispose();
	}catch(e:Error){
		trace("reset_smudge() smudge_brushAlpha.dispose() error, unable to disposed");
	}
	//setup again...
	smudge_brushAlpha = new BitmapData(smudge_diameter, smudge_diameter, true, 0x00000000);
	//
	init_smudge();
}

function event_smudge_down(event:MouseEvent){
	//
	update_after_draw();
	//
	stage.addEventListener(MouseEvent.MOUSE_MOVE, event_smudge_MOVE);
};

function event_smudge_up(event:MouseEvent){
	stage.removeEventListener(MouseEvent.MOUSE_MOVE, event_smudge_MOVE);
};

//usage
/*
	mc_draw.addEventListener(MouseEvent.MOUSE_DOWN, event_smudge_down);
	mc_draw.addEventListener(MouseEvent.MOUSE_UP, event_smudge_up);
	mc_draw.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_smudge_up);
*/