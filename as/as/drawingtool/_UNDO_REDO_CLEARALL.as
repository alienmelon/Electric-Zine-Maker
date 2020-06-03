/*
basic state management
manage two arrays (undo and redo)
bitmapdata is saved there...
this is a simple implementation that needs to be re-visited later

TODO: rework this
*/

//////////////STATE (UNDO/REDO)
//undo is pushed to this
//save bitmap data...
var arr_undo: Array = new Array();
var arr_redo:Array = new Array();
//////////////

//UNDO / REDO

//update undo/redo for specific tools
//that modify the canvas but are conditional
function _undo_specialCase(){
	if(str_tool == "GOLDFISH"){
		reset_water();
	}
}

function _undo(){
	
	reset_pen();
	
	//update specific cases for tools
	_undo_specialCase();

	if (arr_undo[0] != null) {
		//push to redo (save canvas FIRST before undoing)
		arr_redo.push(canvasBitmapData.clone());
		//trace("arr_redo.length: " + arr_redo.length);
		update_canvas_with(arr_undo[arr_undo.length - 1]);
		//remove from undo
		arr_undo.removeAt(arr_undo.length - 1);
		//
	} else {
		arr_undo = [];
	};

	//SEND TO PARENT
	try {
		save_art_to_parent();
	} catch (e: Error) {
		trace("save_art_to_parent() error: no parent");
	}
}

function _redo(){
	//if not null
	if(arr_redo[0] != null){
		//push to undo
		arr_undo.push(canvasBitmapData.clone());
		//update canvas
		update_canvas_with(arr_redo[arr_redo.length - 1]);
		//remove after
		arr_redo.removeAt(arr_redo.length - 1);
		
		//update specific cases for tools
		_undo_specialCase();
		
		//SEND TO PARENT
		try {
			save_art_to_parent();
		} catch (e: Error) {
			trace("save_art_to_parent() error: no parent");
		}
	}else{
		arr_redo = [];
	}
}

function event_undo(event: MouseEvent) {
	
	_undo();

};

function event_redo(event:MouseEvent){
	_redo();
};


function event_clear_all(event: MouseEvent) {

	//arr_undo = [];
	update_after_draw();
	//clear pen and re-set it
	penSprite.graphics.clear();

	//clear and re-set them
	canvasBitmapData.dispose();
	canvasBitmapData = new BitmapData(mc_draw.width, mc_draw.height, false);
	canvasBitmap = new Bitmap(canvasBitmapData, "auto", false);

	penSprite.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);
	pen_texture.lineStyle(num_pen_size);

	try {
		mc_draw.removeChild(canvasBitmap);
		mc_draw.removeChild(penSprite);
	} catch (e: Error) {
		trace("event_undo: error in remove");
	}

	try {
		//addChildAt 1 is new. some children get sent to back if not (like eggs's depth issue)...
		mc_draw.addChildAt(canvasBitmap, 1);//mc_draw.numChildren - 1);
		mc_draw.addChild(penSprite);
		//mc_draw.setChildIndex(canvasBitmap, mc_draw.numChildren - 1);
		//trace(mc_draw.numChildren);
	} catch (e: Error) {
		trace("event_undo: error in add");
	}

	//SEND TO PARENT
	try {
		save_art_to_parent();
	} catch (e: Error) {
		trace("save_art_to_parent() error: no parent");
	}

};