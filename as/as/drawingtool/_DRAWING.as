/*
All functionality that controls the default drawing (pen tool)
Universal sizes (for any tool that also shares pen size values)
Alpha, and tool color...
This also applies to the erase tool, which is "pen" but set to white
*/

/*pen color
selected color
pen alpha
pen DRAWING (mouse x prev x...)
scrubber values (only, not actual rectangle and control)
PEN SIZES*/

//pen sprite for drawing
var penSprite: Sprite = new Sprite();
var pen_texture:Graphics = penSprite.graphics; //load image texture
//var eraseSprite: Shape = new Shape();

var str_tool:String = "PENCIL"; //the currently selected tool

//drawing bools (shared throughout)
var bool_isMouseDown: Boolean; //track mouse state for drawing
//(a windowed tool is open...)
var bool_editMode:Boolean = false; //edit mode for art tools, when another window or screen is open

//color and alpha (set by color picker)
var pen_color = 0x000000;
var selected_color = 0x000000;
var pen_alpha:Number = convert_to_decimal(100);

//current and previous mouse X and Y
//some tools use this to calculate drawing
var num_curMouseX:Number = mouseX;
var num_curMouseY:Number = mouseY;
var num_prevMouseX:Number = mouseX;
var num_prevMouseY:Number = mouseY;
//distance that needs to be traveled (example: used in egg)
var num_mouseDisX: Number;
var num_mouseDisY: Number;

//default pen size used throughought
var num_pen_size: Number = 2;

//updated pen settings (used in low ink, etc..)
var num_pen_size_defaultMax: Number = 20; //the unchanged default. the actual size is updated in the UI (defaultMax never changes)
var num_pen_size_MAX: Number = num_pen_size_defaultMax; //this one is adjusted and controls the animation (low ink, etc...)
var num_pen_size_MIN: Number = 0; //minimum size (restriction)

//IMAGE AS TEXTURE (load a texture from image on computer, then draw with it...)
var penTextureBitmapData:BitmapData = new BitmapData(mc_imageTexture.width, mc_imageTexture.height);
var penTextureBitmap:Bitmap = new Bitmap(penTextureBitmapData, "auto", true);


////////DEFAULT PEN////////////
//basic pen
//tool setup and management

//note: all sprites on canvas must be removed
//otherwise there are issues with smudging or other effects
//this is called during drawing (mouseUP)
function reset_pen(){
	//clear
	//remove
	//add again
	penSprite.graphics.clear();
	pen_texture.clear();
	//
	mc_draw.removeChild(penSprite);
	mc_draw.addChild(penSprite);
	//
	set_pen();
	//
};

//this get's called in all cases
//this refreshes the pen or any other brushes
//use this to update tools (always)
function set_pen(){
	//
	//the texture pen is selected
	if(str_tool == "TEXTURE PEN"){
		//the texture pen is selected (draw as texutre)
		//trace("set_pen :::: TEXTURE PEN");
		pen_texture = penSprite.graphics;
		pen_texture.lineStyle(num_pen_size);
		pen_texture.lineBitmapStyle(penTextureBitmapData);
		//
	}else if(str_tool == "ERASER"){
		//ERASER is selected (unique settings for eraser)
		penSprite.graphics.lineStyle(num_pen_size, 0xFFFFFF);
	}else {
		//default line tools
		//PEN and pattern spray lines
		//set pen size for all pens here (includes pattern spray pen)
		penSprite.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);
		penSprite_drawSpray.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);
	}
	//OTHER PEN SIZES
	//reset texture for perlin
	if(str_tool == "PERLIN BRUSH"){
		reset_perlinBrush();
	}
	if(str_tool == "TOAST"){
		reset_toastBrush();
	}
};


////////////DRAWING/////////////
//drawing for ALL tools
//these are the universal listeners that send things to the canvas
//

//TODO: THIS ENTIRE THING NEEDS TO BE RE-WORKED WHEN DONE...

function mouseDown(event: MouseEvent): void {
	//
	//update_after_draw(); //NEEDS TO BE SET *BEFORE* ANY TOOL PLACES ANYTHING ON CANVAS
	//
	if(str_tool == "PENCIL" || str_tool == "ERASER"){
		//
		update_after_draw();
		//
		penSprite.graphics.moveTo(event.localX, event.localY);
		// add movement listeners here specifically for these tools
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	};
	if(str_tool == "PATTERNSPRAY"){
		//
		update_after_draw();
		//
		draw_sprayPattern(event.localX, event.localY);
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	};
	if(str_tool == "TEXTURE PEN"){
		//
		update_after_draw();
		//
		pen_texture.moveTo(event.localX, event.localY);
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	//AIRBRUSH
	if(str_tool == "SOFT BRUSH"){
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	//PERLIN CHALK
	if (str_tool == "PERLIN CHALK"){
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	//COLORFILL TOOL
	if(str_tool == "COLORFILL"){
		//
		update_after_draw();
		//
		canvasBitmap.bitmapData.floodFill(event.localX, event.localY, pen_color);
	}
	//PERLIN BRUSH
	if(str_tool == "PERLIN BRUSH"){
		//
		update_after_draw();
		// add movement listeners here specifically for these tools
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	};
	//TOAST
	if(str_tool == "TOAST"){
		//
		update_after_draw();
		// add movement listeners here specifically for these tools
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);	
	}
	//RUNNY INK
	if(str_tool == "RUNNY INK"){
		//
		//update_after_draw();
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	//CUSTOM INK
	if(str_tool == "CUSTOM INK"){
		//
		update_after_draw();
		//
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	//DOTTED LINES
	if(str_tool == "DOTTED LINES"){
		//
		update_after_draw();
		//
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);		
	}
	//LOW INK
	if(str_tool == "LOW INK"){
		//
		update_after_draw();
		//
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);			
	}
	//BACON
	if(str_tool == "BACON"){
		//
		update_after_draw();
		set_bacon();
		//
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);		
	}
	//EGGS
	if(str_tool == "EGGS"){
		//
		update_after_draw();
		egg_setCoords(event.localX, event.localY);
		//
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);	
	}
	//OTHER TOOLS THAT TRIGGER DOWN/UP BUT ONLY DRAW ON MOVE
	if(str_tool == "SMOOSHER"){
		//mostly to toggle mouse down bool
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		//
	}
	//GLASS STAMPS - place them here
	if(str_tool == "GLASS STAMPS"){
		save_transform_to_canvas(bitmapData_canvasDemo);
	}
	//FLUID DYNAMICS (GOLDFISH)
	if(str_tool == "GOLDFISH"){
		//
		//update undo and draw rectangle
		try{
			water_updateUndo();
			water_updateDrawRect();
		}catch(e:Error){
			//TODO: FIX THIS
			//if you import a zine, then open the drawing tool (0 undos)
			//and undo, then SPLASH mode, it will generate bug...
			//see if this happens to other tools with 0 undo stack
			trace("Error: undo is null, reset first...");
			update_after_draw();
			save_waterDraw(canvasBitmapData);
		}
		//
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	//RAINBOW PAINT
	if(str_tool == "RAINBOW PAINT"){
		//update drawing
		update_after_draw();
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	//GIFBRUSH
	if(str_tool == "GIF BRUSH"){
		//update drawing
		update_after_draw();
		//call once here too for "stamp" effect
		gifbrush_draw(event.localX, event.localY);
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	//DRAW AND FILL
	if(str_tool == "DRAW AND FILL"){
		//update drawing
		update_after_draw();
		//place pen and start drawing at this point...
		drawAndFill_startDraw(event.localX, event.localY);
		//
		mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}

	//
	bool_isMouseDown = true;
	//
	//set mouse values (to prevent lines from jumping)
	num_curMouseX = event.localX;
	num_curMouseY = event.localY;
	num_prevMouseX = event.localX;
	num_prevMouseY = event.localY;
};

//for acuracy, some tools require event.localX and event.localY because bitmap is nested
function mouseMove(event: MouseEvent){
	//set XY of current mouse (for tools like custom ink)
	num_curMouseX = event.localX;
	num_curMouseY = event.localY;
	//DRAWING
	if(str_tool == "PENCIL" || str_tool == "ERASER"){
		penSprite.graphics.lineTo(event.localX, event.localY);
	};
	if(str_tool == "PATTERNSPRAY"){
		draw_sprayPattern(event.localX, event.localY);
	};
	if(str_tool == "TEXTURE PEN"){
		pen_texture.lineTo(event.localX, event.localY);
	}
	//EYEDROPPER (update color tabs)
	if(str_tool == "EYEDROPPER"){
		//GET AND UPDATE COLOR TABS
		_updateColorPicker(canvasBitmapData, mc_draw);
	};
	//PERLIN BRUSH
	if(str_tool == "PERLIN BRUSH"){
		draw_texture(event.localX, event.localY);
	}
	//TOAST
	if(str_tool == "TOAST"){
		draw_texture(event.localX, event.localY);
	}
	//SMOOSHER DRAWING
	if(str_tool == "SMOOSHER"){
		event_runSmoosher(event.localX, event.localY);
	}
	//GLASS STAMPS (MOVEMENT OVER CANVAS)
	if(str_tool == "GLASS STAMPS"){
		//STAMP MODE
		if (mc_draw.hitTestPoint(stage.mouseX, stage.mouseY)) {
			glassStamp_magnify(bitmap_canvasDemo, event.localX, event.localY);
		};
		//DRAW MODE (constant placement)
		if(mc_draw.hitTestPoint(stage.mouseX, stage.mouseY) && !bool_glassStamp_stamp && bool_isMouseDown){
			save_transform_to_canvas(bitmapData_canvasDemo);
		}
	}
	//AIRBRUSH
	if(str_tool == "SOFT BRUSH"){
		draw_airbrush(event.localX, event.localY);
	}
	//PERLIN CHALK
	if(str_tool == "PERLIN CHALK"){
		perlinChalk_draw(event.localX, event.localY);
	}
	//RUNNY INK
	if(str_tool == "RUNNY INK"){
		draw_runnyInk(event.localX, event.localY);
	}
	//CUSTOM INK
	if(str_tool == "CUSTOM INK"){
		customInk_draw(customInk_brush.graphics, [new Point(num_curMouseX, num_curMouseY), new Point(num_prevMouseX, num_prevMouseY)], canvasBitmapData, selected_color);
	}
	//DOTTED LINES
	if(str_tool == "DOTTED LINES"){
		//draw dotted lines
		//draw_dotted(penSprite, num_prevMouseX, num_prevMouseY, event.localX, event.localY, num_dottedLength, num_dottedSpacing);
		draw_dotted(penSprite, Math_randomRange(num_prevMouseX-num_dottedSprinkle, num_prevMouseX+num_dottedSprinkle), Math_randomRange(num_prevMouseY-num_dottedSprinkle, num_prevMouseY+num_dottedSprinkle), Math_randomRange(event.localX-num_dottedSprinkle, event.localX+num_dottedSprinkle), Math_randomRange(event.localY-num_dottedSprinkle, event.localY+num_dottedSprinkle), num_dottedLength, num_dottedSpacing);
		//draw to canvas and clear
		canvasBitmapData.draw(penSprite);
		penSprite.graphics.clear();
	}
	//LOW INK
	if(str_tool == "LOW INK"){
		//draw low ink
		lowInk_drawInk(event.localX, event.localY);
		//draw to canvas and clear
		canvasBitmapData.draw(penSprite);
		penSprite.graphics.clear();
	}
	//BACON
	if(str_tool == "BACON"){
		draw_bacon(event.localX, event.localY);
	}
	//EGGS
	if(str_tool == "EGGS"){
		if(bool_isMouseDown){
			egg_paint(event.localX, event.localY);
		}
	}
	//GOLDFISH (FLUID DYNAMICS)
	if(str_tool == "GOLDFISH"){
		//todo: move goldfish MOVE to be called here, so it's not separate...
	}
	//RAINBOW PAINT (GRADIENT LINES)
	if(str_tool == "RAINBOW PAINT"){
		draw_rainbowPaint(event.localX, event.localY);
	}
	//GIF BRUSH
	if(str_tool == "GIF BRUSH"){
		gifbrush_draw(event.localX, event.localY);
	}
	//DRAW AND FILL
	if(str_tool == "DRAW AND FILL"){
		drawAndFill_moveDraw(event.localX, event.localY);
	}
	
	//set previous xy of mouse (for tools like runny ink)
	num_prevMouseX = event.localX;
	num_prevMouseY = event.localY;
};

//Draw sprite graphics to canvas and end drawing by cleaning up sprite graphics and unregistering movement listeners
function mouseUp(event: MouseEvent){
	
	//PENCIL
	//draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:flash.geom:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false)
	if(str_tool == "PENCIL" || str_tool == "ERASER" || str_tool == "TEXTURE PEN"){
		// draw sprite graphics to bitmap data (last parameter makes drawing smooth)
		canvasBitmapData.draw(penSprite, null, null, null, null, false);
		// remove listeners specifically for these tools
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		//
		reset_pen();
	};
	
	if(str_tool == "PATTERNSPRAY"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	if(str_tool == "PERLIN BRUSH"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		//reset new brush (on up generates a new one every time. this is optional)
		reset_perlinBrush();
	}
	
	if(str_tool == "TOAST"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		//reset new brush
		reset_toastBrush();
	}
	
	//EYEDROPPER (get value)
	if(str_tool == "EYEDROPPER"){
		//trace("SET COLOR VALUE");
		updateColor(hexColor);
		_setPencil();
	};
	
	//OTHER TOOLS THAT TRIGGER DOWN/UP BUT ONLY DRAW ON MOVE
	if(str_tool == "SMOOSHER"){
		//to toggle mouse down bool
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		//
	}
	
	//COMMIT AIRBRUSH TO CANVAS
	//CLEAR ARIBRUSH AND RESET
	if(str_tool == "SOFT BRUSH"){
		update_after_draw();
		canvasBitmapData.draw(bitmapdata_tool);
		setup_airbrush();
		//
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//PERLIN CHALK
	if(str_tool == "PERLIN CHALK"){
		//
		update_after_draw();
		//delete and setup again
		canvasBitmapData.draw(bitmap_tool);
		perlinChalk_setupBitmap();
		//
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//RUNNY INK
	if(str_tool == "RUNNY INK"){
		//
		update_after_draw();
		//update canvas and delete again, then reset up
		canvasBitmapData.draw(bitmap_tool);
		setup_runyInk();
		//
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//CUSTOM INK
	if(str_tool == "CUSTOM INK"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//DOTTED LINES
	if(str_tool == "DOTTED LINES"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//LOW INK
	if(str_tool == "LOW INK"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		//reset values
		lowInk_resetValues();
		lowInk_resetUp();
	}
	
	//BACON
	if(str_tool == "BACON"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//EGGS
	if(str_tool == "EGGS"){
		
		canvasBitmapData.draw(egg_sprite);
		egg_sprite.graphics.clear();
		
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//GOLDFISH (FLUID DYNAMICS)
	if(str_tool == "GOLDFISH"){
		//SAVE IT HERE
		event_water_MOUSEUP();
		//
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//RAINBOW PAINT (GRADIENT LINES)
	if(str_tool == "RAINBOW PAINT"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//GIF BRUSH (ANIMATED GIF AS BRUSH)
	if(str_tool == "GIF BRUSH"){
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//DRAW AND FILL (fill paintbucket
	if(str_tool == "DRAW AND FILL"){
		//
		drawAndFill_endDraw();
		//
		mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	}
	
	//
	bool_isMouseDown = false;
};