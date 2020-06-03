/*
recreate Flash specific blend modes and blend layering
this is important because it's very iconic to old-school Flash aesthetic
all blend modes applied to importing and image then layering that image over your art
image is imported into separate bitmap, once blend mode is selected, and size/placement is done, then it's drawn to the main canvas...
//load an image from your drive and
//merge one image with another
*/

//str_tool == "BLEND & DISPLACER-izer";

//BLEND AND DISPLACE//
//blend and displace values
//displacement shared (set in UI)
var blend_and_displace_componentX:uint = BitmapDataChannel.ALPHA;
var blend_and_displace_componentY:uint = BitmapDataChannel.GREEN;
var arr_displacement_componentModes:Array = new Array([BitmapDataChannel.ALPHA, "ALPHA"], [BitmapDataChannel.BLUE, "BLUE"], [BitmapDataChannel.GREEN, "GREEN"], [BitmapDataChannel.RED, "RED"]);
var num_componentX_arr:Number = 0;
var num_componentY_arr:Number = 3;
//color modes
var blend_and_displace_mode:String = DisplacementMapFilterMode.COLOR;
var arr_displacement_modes:Array = new Array([DisplacementMapFilterMode.WRAP, "WRAP"], [DisplacementMapFilterMode.CLAMP, "CLAMP"], [DisplacementMapFilterMode.IGNORE, "IGNORE"], [DisplacementMapFilterMode.COLOR, "COLOR"]);
var num_displacementNode_arr:Number = 3;
////////////////////////

//see COLOR.as for all blendmodes
//the rest of the code is in _DRAWING_UI.as since it's entirely UI related...