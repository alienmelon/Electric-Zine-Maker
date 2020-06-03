/*
everything controlling and setting up various tools goes here
all UI for each tool, initiating tools, clearing tools, shared UI code...
*/

//backgrounds or clips that play/stop on mouse over/out
var arr_menu_randFrames:Array = new Array(mc_setting_gifbrush.mc_draw, mc_goldfish.mc_background, mc_asciipaint.mc_background, mc_setting_toast.mc_toast_settings_title, mc_setting_toast.mc_toast_background, mc_setting_void.mc_void_free, mc_setting_perlinbrush.btn_drawNoise, mc_setting_perlinbrush.mc_toolback_03, mc_setting_perlinbrush.mc_toolback_02, mc_setting_perlinbrush.mc_toolback_01, mc_setting_perlinbrush.btn_drawRand, mc_setting_perlinbrush.btn_generateRand, mc_color_factory.mc_background, mc_blend_and_displace.mc_title, mc_glass_stamps.mc_title, mc_glass_stamps.mc_title_back, mc_smooshzone.mc_smoosh_about01, mc_smooshzone.mc_smoosh_about02, mc_smooshzone.mc_smoosh_about03, mc_smooshzone.mc_smooshzone_settings, mc_smooshzone.mc_smooshzone_title, mc_backgroundtab_01, mc_backgroundtab_02, mc_backgroundtab_03, mc_backgroundtab_04, mc_backgroundtab_05, mc_slider.mc_ui_ruler, mc_slider.mc_alphainput, mc_patternspray_about, mc_patternspray_settings, mc_textTool_about, mc_textTool_write, mc_textTool_input, mc_textTool_settings, mc_textTool_size, mc_textTool_width, mc_textTool_fonts, mc_textTool_fonts_scrollbar, mc_textTool_fonts_back, mc_textTool_rotation, mc_importimage_about);
//array of all the tools on the stage. for setting select/deselect colors
var arr_ui_tools:Array = new Array(btn_goldfish, btn_rainbowpaint, btn_gifbrush, btn_drawandfill, btn_eggs, btn_asciipaint, btn_toast, btn_bacon, btn_void, btn_lowink, btn_dotted, btn_customInk, btn_runnyInk, btn_perlinchalk, btn_perlinbrush, btn_softbrush, btn_color_factory, btn_blend_and_displace, btn_glass_stamps, btn_smoosher, btn_authentic, btn_pen, btn_eyedropper, btn_erase, btn_smudge, btn_colorfill, btn_spray, btn_patternspray, btn_text, btn_importimage);
//array of tools for pattern spray (show/hide)
var arr_ui_tools_patternspray:Array = new Array(btn_patternspray_back, mc_patternspray_about, mc_patternspray_settings, btn_patternspray_rotation, btn_patternspray_size, btn_patternspray_image, btn_patternspray_clear, mc_patternspray_outline, mc_draw_spray);
//array of all the tools in the font tool (add text)
var arr_ui_tools_textTool:Array = new Array(txt_textTool_rotation, mc_textTool_rotation, btn_textTool_left, btn_textTool_right, btn_textTool_center, mc_textTool_about, mc_textTool_write, txt_textTool_input, mc_textTool_input, btn_textTool_input_UP, btn_textTool_input_DOWN, mc_textTool_settings, mc_textTool_settingsTxt, txt_textTool_size, mc_textTool_size, txt_textTool_width, mc_textTool_width, mc_textTool_settingsTxt, btn_textTool_DONE, btn_textTool_CANCEL, mc_textTool_fonts, btn_textTool_fonts_UP, btn_textTool_fonts_DOWN, mc_textTool_fonts_scrollbar, mc_textTool_fonts_back, txt_font_01, txt_font_02, txt_font_03, txt_font_04, txt_font_05, txt_font_06, txt_font_07);
//tools for the import image
var arr_ui_tools_importImage:Array = new Array(btn_importAnother, btn_image_CANCEL, btn_image_DONE, mc_importimage_about, btn_importimage_import01, btn_importimage_import02, btn_importimage_width, btn_importimage_height, btn_importimage_center, btn_importimage_topleft, btn_importimage_topright, btn_importimage_bottomleft, btn_importimage_bottomright);

var arr_subtools:Array = new Array([btn_colorfill, btn_spray, btn_smudge, btn_patternspray], [btn_smoosher, btn_blend_and_displace, btn_glass_stamps, btn_color_factory], [btn_perlinbrush, btn_softbrush, btn_perlinchalk, btn_runnyInk], [btn_customInk, btn_dotted, btn_lowink, btn_void], [btn_bacon, btn_eggs, btn_toast, btn_asciipaint], [btn_goldfish, btn_rainbowpaint, btn_gifbrush, btn_drawandfill]);
var num_curr_subtools:Number = 0; //array number (paging up or down in tools)

//FOR PUBLISHING (UNCOMMENT WHEN DONE)
mc_soon.visible = false;

//////////////TEXT
//load fonts
var arr_allfonts: Array = new Array();
var arr_currFontList:Array = new Array();
var num_currFontList:Number = 0; //increment by 7 and start at the last number as the point to push from
var currFont;//the currently selected font
//current array value of font array that is being incremented/decremented
var currFontNum:Number = 0;
//current font selection on list
var font1;
var font2;
var font3;
var font4;
var font5;
var font6;
var font7;
//trace("update fonts here if parent is null. if it's not then get fonts from parent.");
try{
	//
	trace("arr_allfonts: getting fonts from parent");
	arr_allfonts = stage_parent.arr_allfonts;
	//
	/*arr_currFontList = stage_parent.arr_currFontList;
	num_currFontList = stage_parent.num_currFontList;
	currFont = stage_parent.currFont;
	trace("!!!!!!!! " + currFont);*/
	//
}catch(e:Error){
	//parent is null, populate with new
	arr_allfonts = Font.enumerateFonts(true);
	arr_allfonts.sortOn("fontName", Array.CASEINSENSITIVE);
	trace("error getting fonts from parent, re-populating list");
};
//current font width and heights
var num_currFont_width:Number = 300;
var num_currFont_rotation:Number = 0;
var num_currFont_size:Number = 25;
var str_currFont_allignment:String = "left";
//the text format (updated)
var tf_format:TextFormat;
//the field added to the canvas
var canvas_textField:TextField = new TextField();
var canvas_textField_container:MovieClip = new MovieClip(); //text is placed in a container so it can get dragged around
//////////////

//////////////COLOR VALUES (scrubber)
var bitmapData_ColorPicker:BitmapData = new BitmapData(mc_colorPicker.width, mc_colorPicker.height);
var ct_ColorPicker:ColorTransform = new ColorTransform();
var hexColor:*;//bitmap color data
bitmapData_ColorPicker.draw(mc_colorPicker.mc_spectrum);
//////////////

////////////////SCRUBBER
//tool specific scrubber values
var num_maxVal_tool: Number = 50;
var scrubber_tool: Rectangle;
//scrubber value (minimum)
var num_minVal: Number = 0;
//////////////

//IMPORT IMAGE (also used for blend&displace, and default image import...)
var clip_importImage:MovieClip; //container for importing the image into
//////////////


////TRANSFORM TOOL/////
// default tool

//reset the tool and set a new target
function set_transformTool(targ){

};

function reset_transformTool(){

};
//////////////

////////TEXT/////////
//setup input text fields for number's with decimal
function setup_numberDecimal_txt(txtField:TextField, num_defaultVal:Number){
	txtField.restrict = "0-9\\.";
	txtField.text = String(num_defaultVal);
}

function setup_numberNegativeDecimal_txt(txtField:TextField, num_defaultVal:Number){
	txtField.restrict = "0-9\\-.";
	txtField.text = String(num_defaultVal);
}

function setup_numberNegative_txt(txtField:TextField, num_defaultVal:Number){
	txtField.restrict = "0-9\\-";
	txtField.text = String(num_defaultVal);
}

//"0-9" restrict a text field to either leters or numbers + default value
function txt_restrict(txtField:TextField, defaultVal:String, str_range:String){
	txtField.restrict = str_range;
	txtField.text = defaultVal;
}
//////////////

////////////DRAWING////////////

//UI
//trace("TODO: THIS SHOULD BE CALLED FOR ALL TOOLS THAT OPEN A SPECIAL WINDOW. CURRENTLY DOES NOT!!");
function openWindow(clip:MovieClip){
	clip.visible = true;
	bool_editMode = true;
}

//TODO: CALL THIS WHENEVER SPECIAL UI'S CLOSE
function closeWindow(clip:MovieClip){
	clip.visible = false;
	bool_editMode = false;
}

//////////////

////////////CHOOSE TOOLS////////////
//called multiple times so in own function
function _setPencil(){
	//
	//pen_color = selected_color;
	set_tool("PENCIL", btn_pen);
};

//called at the end of closing most tools
function set_pencil_tool(){
	//set back to pencil
	set_tool("PENCIL", btn_pen);
	//mc_slider.visible = true;
	show_scrubber_alpha();
	//show_color();
}

//set tool
//always called when setting a tool. must be first thing called before initiating anything else.
function set_tool(strTool:String, btn){
	//incase anything is playing
	snd_chan.stop();
	//
	bool_isMouseDown = false;//reset incase it's still toggled
	//
	str_tool = strTool;
	//
	mc_tool.txt_tool.text = strTool;
	trace("SOUND: PLAY TOOL SOUND");
	deselectAll(arr_ui_tools);
	selectedColor(btn);
	//reset to show
	show_color();
	//normally hide this
	hide_scrubber();
	mc_setting_brushes.visible = false;
	mc_setting_runnyInk.visible = false;
	mc_setting_perlinbrush.visible = false;
	mc_settings_customInk.visible = false;
	mc_setting_dotted.visible = false;
	mc_setting_lowink.visible = false;
	mc_setting_void.visible = false;
	mc_setting_bacon.visible = false;
	mc_setting_eggs.visible = false;
	mc_setting_toast.visible = false;
	mc_setting_rainbowpaint.visible = false;
	mc_setting_gifbrush.visible = false;
	mc_setting_drawandfill.visible = false;
	//penSprite.graphics.clear();
	//penSprite.graphics.lineStyle(num_pen_size, pen_color);
	reset_pen();
	//reset color picker incase of EYEDROPPER
	_endColorPicker();
	//delete airbrush (clear)
	delete_airbrush();
	//delete perlin
	delete_perlin();
	delete_perlinBrush();
	//delete runny ink
	delete_runnyInk();
	//delete perlin chalk
	perlinChalk_DELETEALL();
	//delete eggs
	egg_delete();
	//clear ascii
	deleteAscii();
	//clear goldfish (water)
	clear_water();
	//clear all gifbrush and listeners
	gifbrush_clearAll();
	//simple clear vectors for draw and fill...
	//drawAndFill_clear();
	//remove listeners
	clear_all_toolListeners();
	//reset all colors here
	//set the color back if the tool is not eraser
	//some tools rely on the same color (like dotted line)
	//selecting eraser and then dotted line changes the color to white
	//(fixes this bug)
	if(str_tool != "ERASER"){
		pen_color = selected_color;
	}
};

//trace("CHECKLIST: ALL LISTENERS FOR TOOLS SHOULD BE REMOVED HERE!");
function clear_all_toolListeners(){
	mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
	mc_draw.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
	//
	mc_draw.removeEventListener(MouseEvent.MOUSE_DOWN, event_smudge_down);
	mc_draw.removeEventListener(MouseEvent.MOUSE_UP, event_smudge_up);
	mc_draw.removeEventListener(MouseEvent.RELEASE_OUTSIDE, event_smudge_up);
	//
	mc_draw.removeEventListener(MouseEvent.MOUSE_DOWN, event_spray_down);
	mc_draw.removeEventListener(MouseEvent.MOUSE_UP, event_spray_up);
	mc_draw.removeEventListener(MouseEvent.RELEASE_OUTSIDE, event_spray_up);
	//
	stage.removeEventListener(Event.ENTER_FRAME, event_runWaterAnimation);
	stage.removeEventListener(MouseEvent.MOUSE_MOVE, event_drawWater_MOVE);
	//restart smoosher
	//destory_smoosher();
	//misc events removed just in case...
	stage.removeEventListener(Event.ENTER_FRAME, event_color_factory_MIRROR_EVENT);
	stage.removeEventListener(Event.ENTER_FRAME, event_color_factory_FUZZY_EVENT);
}

function event_pencil(event:MouseEvent){
	_setPencil();
	show_scrubber_alpha();
};

function event_erase(event:MouseEvent){
	pen_color = 0xFFFFFF;
	pen_alpha = 100;
	set_tool("ERASER", btn_erase);
	show_scrubber();
};

//////////////

////////////PAGE THROUGH SUB TOOLS (NEXT PREVIOUS)////////////  

function subtool_hideAll(){
	for(var i:Number = 0; i<arr_subtools.length; ++i){
		//
		for(var n:Number = 0; n < arr_subtools[i].length; ++n){
			//
			arr_subtools[i][n].visible = false;
		}
	}
}

function subtool_visibility(num:Number, bool:Boolean){
	for(var i:Number = 0; i<arr_subtools[num].length; ++i){
		//
		arr_subtools[num][i].visible = bool;
	}
}

//paging left or right function are also used in keyboard shortcuts
function _subtools_next(){
	//hide current set
	subtool_visibility(num_curr_subtools, false);
	//
	num_curr_subtools += 1;
	//
	if(num_curr_subtools > arr_subtools.length - 1){
		num_curr_subtools = 0;
	};
	//show new set
	subtool_visibility(num_curr_subtools, true);
	//
}

function _subtools_previous(){
	//hide current set
	subtool_visibility(num_curr_subtools, false);
	//
	num_curr_subtools -= 1;
	//
	if(num_curr_subtools < 0){
		num_curr_subtools = arr_subtools.length-1;
	};
	//show new set
	subtool_visibility(num_curr_subtools, true);
	//
}

function event_subtools_next(event:MouseEvent){
	_subtools_next();
};

function event_subtools_previous(event:MouseEvent){
	_subtools_previous();
};

//////////////

////////////TEXT & FONT////////////

function updateFormat(txtField:TextField){
	//
	tf_format = new TextFormat();
	tf_format.font = currFont.fontName;
	//trace(currFont.fontName);
	tf_format.size = num_currFont_size;
	tf_format.align = str_currFont_allignment;
	tf_format.color = pen_color;
	//
	//
	txtField.wordWrap = true;
	txtField.width = num_currFont_width;
	txtField.height = num_currFont_width;
	txtField.autoSize = TextFieldAutoSize.LEFT;
	txtField.type = TextFieldType.DYNAMIC;
	txtField.selectable = false;
	//
	txtField.antiAliasType=AntiAliasType.ADVANCED;
	txtField.gridFitType=GridFitType.PIXEL;
	txtField.sharpness=400;
	//
	canvas_textField_container.rotationZ = num_currFont_rotation;
	//border for debug
	//txtField.border = true;
	//
	txtField.defaultTextFormat = tf_format;
	txtField.setTextFormat(tf_format);
	//TODO: FONT EFFECTS
	//canvas_textField_container.filters = [new DropShadowFilter(4.0,45,0x000000,1.0,4.0,4.0,1.0,1,false,true,false)];
	////canvas_textField_container.removeChild(canvas_textField);
	//var sharpenFilter: ConvolutionFilter = new ConvolutionFilter(3, 3, [0, -1, 0, -1, 10, -1, 0, -1, 0], 5);
	//canvas_textField.filters = [sharpenFilter];
};


function updateFontList(boolNext:Boolean = true){
	
	//boolNext = go forward, if false go back (decrement)
	if(currFont == null){
		currFont = arr_allfonts[0];
	};
	
	if(boolNext){
		currFontNum = currFontNum + 7;
		//
		if(currFontNum > arr_allfonts.length-1){
			//if at end, hardcode
			currFontNum = 0;
		}
		
	}else{
		currFontNum = currFontNum - 7;
		//
		if(currFontNum <= -7){
			//if less than, hardcode values
			currFontNum = arr_allfonts.length-1;
		}
	}
	
	font1 = arr_allfonts[currFontNum];
	font2 = arr_allfonts[currFontNum + 1];
	font3 = arr_allfonts[currFontNum + 2];
	font4 = arr_allfonts[currFontNum + 3];
	font5 = arr_allfonts[currFontNum + 4];
	font6 = arr_allfonts[currFontNum + 5];
	font7 = arr_allfonts[currFontNum + 6];
	
	updateFontTextField(txt_font_01, font1);
	updateFontTextField(txt_font_02, font2);
	updateFontTextField(txt_font_03, font3);
	updateFontTextField(txt_font_04, font4);
	updateFontTextField(txt_font_05, font5);
	updateFontTextField(txt_font_06, font6);
	updateFontTextField(txt_font_07, font7);
	
};

function updateFontTextField(txt:TextField, font){
	try{
		txt.text = font.fontName;
	}catch(e:Error){
		//null
		txt.text = "";
	}
}

function event_nextFontList(event:MouseEvent){
	//go forward 7
	updateFontList();
};

function event_prevFontList(event:MouseEvent){
	updateFontList(false);
};

function event_setFont(event:MouseEvent){
	var clip = event.currentTarget;
	//if name then
	if(clip.name == "txt_font_01"){
		currFont = font1;
	};
	if(clip.name == "txt_font_02"){
		currFont = font2;
	};
	if(clip.name == "txt_font_03"){
		currFont = font3;
	};
	if(clip.name == "txt_font_04"){
		currFont = font4;
	};
	if(clip.name == "txt_font_05"){
		currFont = font5;
	};
	if(clip.name == "txt_font_06"){
		currFont = font6;
	};
	if(clip.name == "txt_font_07"){
		currFont = font7;
	};
	//
	if(currFont == null){
		currFont = arr_allfonts[Math.ceil(Math.random()*arr_allfonts.length)-1];
	};
	//also update the field over there >>
	updateFormat(canvas_textField);
};

function event_setAllign(event:MouseEvent){
	var clip_name = event.currentTarget.name;
	//set the value
	if(clip_name == "btn_textTool_left"){
		str_currFont_allignment = "left";
	};
	if(clip_name == "btn_textTool_right"){
		str_currFont_allignment = "right";
	};
	if(clip_name == "btn_textTool_center"){
		str_currFont_allignment = "center";
	};
	//update now
	updateFormat(canvas_textField);
};


function event_fontsize_ONCHANGE(event:Event){
	//KEEP IT NUMBER ONLY CONVERT TO NUMBER
	num_currFont_size = Number(txt_textTool_size.text);
	//constraints (can't be negative value or not a number)
	if (isNaN(num_currFont_size)){
		num_currFont_size = 25;
	};
	if(num_currFont_size <= 1){
		num_currFont_size = 1;
	};
	//
	updateFormat(canvas_textField);
};

function event_fontwidth_ONCHANGE(event:Event){
	//
	num_currFont_width = Number(txt_textTool_width.text);
	//
	if (isNaN(num_currFont_width)){
		num_currFont_width = 300;
	};
	//
	updateFormat(canvas_textField);
};

function event_fontrotation_ONCHANGE(event:Event){
	//
	num_currFont_rotation = Number(txt_textTool_rotation.text);
	//
	if (isNaN(num_currFont_rotation)){
		num_currFont_rotation = 0;
	};
	//
	updateFormat(canvas_textField);
}

//change the text on input update
function event_input_ONCHANGE(event:Event){
	//update
	updateFormat(canvas_textField);
	canvas_textField.text = txt_textTool_input.text;
	mc_textTool_about.visible = false;
	//
};

function event_input_FOCUSIN(event:FocusEvent){
	if(txt_textTool_input.text == "Write your text here..."){
		txt_textTool_input.text = "";
	}
};

//scrolling
function event_input_scroll(event:MouseEvent){
	var clip_name = event.currentTarget.name;
	//
	if(clip_name == "btn_textTool_input_DOWN"){
		txt_textTool_input.scrollV += 5;
	}else{
		txt_textTool_input.scrollV -= 5;
	};
};

function visible_TextUI(bool_visible:Boolean){
	for(var i:Number = 0; i<arr_ui_tools_textTool.length; ++i){
		arr_ui_tools_textTool[i].visible = bool_visible;
	}
};

//dragging text into position
function event_canvasText_startDrag(event:MouseEvent){
	//
	event.currentTarget.startDrag(false, new Rectangle(
			  -canvas_textField_container.width,
			  -canvas_textField_container.height,
			  mc_draw.width + canvas_textField_container.width,
			  mc_draw.height + canvas_textField_container.height
		   )
	);
};

function event_canvasText_stopDrag(event:MouseEvent){
	event.currentTarget.stopDrag();
}

function event_text_done(event:MouseEvent){
	//trace("add text here");
	//trace("remove all");
	//trace("close");
	//draw_textField();
	//
	
	//update undo
	update_after_draw();
	
	//
	draw_textField();
	
	//
	text_close();
};

function event_text_cancel(event:MouseEvent){
	text_close();
};

//close functionality called in both buttons (done and cancel)
function text_close(){
	//reset to pencil
	set_pencil_tool();
	//close all
	bool_editMode = false;
	mc_popup_background_2.gotoAndPlay("close");
	visible_TextUI(false);
	event_positionColorPicker_DEFAULT();
	//
	canvas_textField_container.removeChild(canvas_textField);
	mc_draw.removeChild(canvas_textField_container);
	//
}

function event_text(event: MouseEvent) {
	//open settings window here
	//
	bool_editMode = true;
	//
	set_tool("TEXT", btn_text);
	visible_TextUI(true);
	mc_popup_background_2.gotoAndPlay("open");
	event_positionColorPicker_DOWN();
	//add a text field over canvas
	mc_draw.addChild(canvas_textField_container);
	canvas_textField_container.addChild(canvas_textField);
	//
	//
	canvas_textField.text = "";
	canvas_textField.width = num_currFont_width;
	canvas_textField_container.x = 100;
	canvas_textField_container.y = 100;
	//
	//reset here to avoid issues of font going off screen if it saves larger/weirder values
	num_currFont_size = 25;
	num_currFont_width = 300;
	num_currFont_rotation = 0;
	txt_textTool_size.text = String(num_currFont_size);
	txt_textTool_width.text = String(num_currFont_width);
	txt_textTool_rotation.text = String(num_currFont_rotation);
	txt_textTool_input.text = "Write your text here...";
	updateFormat(canvas_textField);
};

//////////////

////////////IMPORT IMAGE////////////

function event_import_fill(event:MouseEvent){
	load_image(clip_importImage, mc_draw.width, mc_draw.height, UI_load_image_default_setListeners, UI_load_image_default_onSelected, UI_load_impage_default_onComplete, true);
}

function event_import_small(event:MouseEvent){
	load_image(clip_importImage, mc_draw.width, mc_draw.height, UI_load_image_default_setListeners, UI_load_image_default_onSelected, UI_load_impage_default_onComplete, false);
}

function event_import_another(event:MouseEvent){
	//
	draw_import_fill();
	//
	reset_imageImportChildren();
	set_imageImportChildren();
	//
	load_image(clip_importImage, mc_draw.width, mc_draw.height, UI_load_image_default_setListeners, UI_load_image_default_onSelected, UI_load_impage_default_onComplete, false);
	//can't cancel once you place them
	btn_image_CANCEL.visible = false;
	btn_importimage_import01.visible = false;
	btn_importimage_import02.visible = false;
}

function visible_imageUI(bool_vis:Boolean){
	for(var i:Number = 0; i<arr_ui_tools_importImage.length; ++i){
		arr_ui_tools_importImage[i].visible = bool_vis;
	};
	btn_importAnother.visible = false;
}

//hack: need to change target of transform tool before changing size or position, then set back to target so it updates properly (todo: fix this)
function event_image_fullWidth(event:MouseEvent){
	clip_importImage.x = 0;
	clip_importImage.width = mc_draw.width;
}

function event_image_fullHeight(event:MouseEvent){
	clip_importImage.y = 0;
	clip_importImage.height = mc_draw.height;
}

//allignment (acording to registration point)
function event_image_allign(event:MouseEvent){
	var clip_name = event.currentTarget.name;
	//
	//
	if(clip_name == "btn_importimage_center"){
		clip_importImage.x = Math.ceil(mc_draw.width/2 - clip_importImage.width/2);
		clip_importImage.y = Math.ceil(mc_draw.height/2 - clip_importImage.height/2);
	};
	if(clip_name == "btn_importimage_topleft"){
		clip_importImage.x = 0;
		clip_importImage.y = 0;
	};
	if(clip_name == "btn_importimage_topright"){
		clip_importImage.x = mc_draw.width-clip_importImage.width;
		clip_importImage.y = 0;//mc_draw.height-clip_importImage.height;
	};
	if(clip_name == "btn_importimage_bottomleft"){
		clip_importImage.x = 0;
		clip_importImage.y = mc_draw.height-clip_importImage.height;
	}
	if(clip_name == "btn_importimage_bottomright"){
		clip_importImage.x = mc_draw.width-clip_importImage.width;
		clip_importImage.y = mc_draw.height-clip_importImage.height;
	}
	//
};

function event_image_DONE(event:MouseEvent){
	//trace("place on canvas");
	//trace("remove children");
	//draw
	draw_import_fill();
	//remove
	imageClose();
};

function event_image_CANCEL(event:MouseEvent){
	imageClose();
}

function imageClose(){
	//reset to pencil
	set_pencil_tool();
	bool_editMode = false;
	//
	mc_popup_background_3.gotoAndPlay("close");
	visible_imageUI(false);
	//
	reset_imageImportChildren();
};

//set and reset function remove children and add them again (for re importing)
function reset_imageImportChildren(){
	try{
		clip_importImage.removeChild(loader_importImage);
	}catch(e:Error){
		//image not loaded (canceled before initiating)
	}
	try{
		mc_draw.removeChild(clip_importImage);
	}catch(e:Error){
		trace("imageClose error! mc_draw.removeChild(clip_importImage) not removed");
	}
	clip_importImage = null;
	reset_transformTool();
};

function set_imageImportChildren(){
	clip_importImage = new MovieClip();
	mc_draw.addChild(clip_importImage);
	clip_importImage.x = 0;
	clip_importImage.y = 0;
	//transform tool is set inside of load_image in FILEREFERENCE.as
};

function event_image(event:MouseEvent){
	mc_popup_background_3.gotoAndPlay("open");
	set_tool("IMPORT IMAGE", btn_importimage);
	bool_editMode = true;
	visible_imageUI(true);
	//need to re-declare clip_importImage every time to unregister it with the transform tool
	set_imageImportChildren();
}


//////////////

////////////COLOR PICKER////////////

function _updateColorPicker(bitmapData:BitmapData, clip){
	//get color from mouse position and pass it to ColorTransform
	hexColor = "0x" + bitmapData.getPixel(clip.mouseX, clip.mouseY).toString(16);
	//
    ct_ColorPicker.color = hexColor;
	//update the color graphic behind the button
    mc_color.mc_color.transform.colorTransform = ct_ColorPicker;
    //.text = "#" + bitmapData.getPixel(mc_colorPicker.mc_spectrum.mouseX, mc_colorPicker.mc_spectrum.mouseY).toString(16).toUpperCase();
};

//cancel chosing a color and set tabs back
function _endColorPicker(){
	//selected_color (default)
	if(str_tool != "BACON" && str_tool != "EGGS" && str_tool != "RAINBOW PAINT"){
		ct_ColorPicker.color = selected_color;
		mc_color.mc_color.transform.colorTransform = ct_ColorPicker;
	};
	//if bacon set a different way
	if(str_tool == "BACON"){
		setBaconColors(); //set all the tabs to the last selected value
	}
	if(str_tool == "EGGS"){
		setEggColors();
	}
	if(str_tool == "RAINBOW PAINT"){
		setRainbowColors();
	}
	if(str_tool == "DRAW AND FILL"){
		setDrawAndFillColors();
	}
};

function event_updateColorPicker(e:MouseEvent){
	//if default
	if(str_tool != "BACON" && str_tool != "EGGS" && str_tool != "RAINBOW PAINT"){
		_updateColorPicker(bitmapData_ColorPicker, mc_colorPicker.mc_spectrum);
	};
	//if bacon call something else
	if(str_tool == "BACON"){
		update_bacon_color(bitmapData_ColorPicker, mc_colorPicker.mc_spectrum); //update the currently selected value
	}
	if(str_tool == "EGGS"){
		update_egg_color(bitmapData_ColorPicker, mc_colorPicker.mc_spectrum);
	}
	if(str_tool == "RAINBOW PAINT"){
		update_rainbowpaint_color(bitmapData_ColorPicker, mc_colorPicker.mc_spectrum);
	}
	if(str_tool == "DRAW AND FILL"){
		update_drawAndFill_color(bitmapData_ColorPicker, mc_colorPicker.mc_spectrum);
	}
};

function event_end_ColorPicker(event:MouseEvent){
	_endColorPicker();
};

function event_setColor(event:MouseEvent){
	//default
	if(str_tool != "BACON" && str_tool != "EGGS" && str_tool != "RAINBOW PAINT"){
		updateColor(hexColor);
	};
	//bacon
	if(str_tool == "BACON"){
		updateBaconColors(); //update (set) on click
	}
	if(str_tool == "EGGS"){
		updateEggColors();
	}
	if(str_tool == "RAINBOW PAINT"){
		updateRainbowColors();
	}
	if(str_tool == "DRAW AND FILL"){
		updateDrawAndFillColors();
	}
};

function event_overColorWhite(event:MouseEvent){
	ct_ColorPicker.color = 0xFFFFFF;
    mc_color.mc_color.transform.colorTransform = ct_ColorPicker;
};

function event_overColorBlack(event:MouseEvent){
	ct_ColorPicker.color = 0x000000;
    mc_color.mc_color.transform.colorTransform = ct_ColorPicker;
};

function event_setColorWhite(event:MouseEvent){
	updateColor(0xFFFFFF);
};

function event_setColorBlack(event:MouseEvent){
	updateColor(0x000000);
};


function updateColor(hex_col){
	//.text = hexColor;
    mc_currColor.mc_color.transform.colorTransform = ct_ColorPicker;
	selected_color = hex_col;
	//update all tools to new color here
	pen_color = selected_color;
	penSprite.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);
    //.text = previously rolled over text
	penSprite_drawSpray.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);
	//update airbrush color (if it's on)
	if(str_tool == "SOFT BRUSH"){
		setup_airbrush();
	};
	if(str_tool == "PERLIN CHALK"){
		perlinChalk_setupBitmap();
	}
	//update text format
	try{
		updateFormat(canvas_textField);
	}catch(e:Error){
		//field is null
	};
};

//set to color or grayscale
function event_colorPicker_COLOR(event:MouseEvent){
	mc_colorPicker.mc_spectrum.gotoAndStop(1);
	bitmapData_ColorPicker.draw(mc_colorPicker.mc_spectrum);
};

function event_colorPicker_GRAYSCALE(event:MouseEvent){
	mc_colorPicker.mc_spectrum.gotoAndStop(2);
	bitmapData_ColorPicker.draw(mc_colorPicker.mc_spectrum);
};

//positioning the entire color picker for menu popups (DOWN is bottom of screen);
function event_positionColorPicker_DEFAULT(){
	btn_color_setwhite.x = 20;
	btn_color_setwhite.y = 416;
	btn_color_setblack.x = 50;
	btn_color_setblack.y = 415;
	btn_color.x = 96;
	btn_color.y = 410;
	mc_color.x = 96;
	mc_color.y = 410;
	mc_currColor.x = 182;
	mc_currColor.y = 410;
	mc_colorPicker.x = 211;
	mc_colorPicker.y = 351;
};

function event_positionColorPicker_DOWN(){
	btn_color_setwhite.x = 20;
	btn_color_setwhite.y = 526;
	btn_color_setblack.x = 50;
	btn_color_setblack.y = 525;
	btn_color.x = 96;
	btn_color.y = 520;
	mc_color.x = 96;
	mc_color.y = 520;
	mc_currColor.x = 182;
	mc_currColor.y = 520;
	mc_colorPicker.x = 211;
	mc_colorPicker.y = 461;
};

//////////////

////////////EYEDROPPER////////////
//same as color picker but put it over the canvas
//don't create a new bitmap, just read on over for canvas

function event_setEyedropper(event:MouseEvent){
	set_tool("EYEDROPPER", btn_eyedropper);
	mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
	mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
};

//////////////

////////////PAINTBUCKET COLORFILL////////////

function event_colorFill(event:MouseEvent){
	set_tool("COLORFILL", btn_colorfill);
};

//////////////


////////////SLIDERS////////////

//INIT THE SCRUBBER must have mc_knob, mc_track, and txt_size in clip
function init_scrubber(curr_slider:MovieClip, minVal:Number, str_rect:String) {
	//position scrubbers
	curr_slider.mc_knob.x = minVal;
	//x=0, y=0, w=0, h=0 -- drag range
	this[str_rect] = new Rectangle(5,
		0,
		curr_slider.mc_track.width - 20,
		5);
};

function calc_scrubber_val(curr_slider:MovieClip, minVal:Number, maxVal:Number){
	//return value after sliding
	var num_getPercent: Number = curr_slider.mc_knob.x / (curr_slider.mc_track.width - 20) * 100;
	minVal = Math.floor(maxVal * num_getPercent / 100);
	//
	if(minVal <= 1){
		minVal = 2;
	};
	if(minVal >= maxVal){
		minVal = maxVal;
	}
	//
	return minVal;
}

//SET the scrubber to a designated position (for tools that need a basic value when they start)
function set_scrubber_XVal(curr_slider:MovieClip, num_X:Number){
	//
	curr_slider.mc_knob.x = num_X;
	//calculate (same as from MOVE)
	num_pen_size = calc_scrubber_val(mc_slider, num_minVal, num_maxVal_tool);
	//
}

//slider for the tool
//on MOUSE_MOVE (it's always running)
function event_scrubber_MOVE(event: MouseEvent) {
	//pencil
	num_pen_size = calc_scrubber_val(mc_slider, num_minVal, num_maxVal_tool);
}

function event_scrubber_DOWN(event: MouseEvent) {
	var object = event.target;
	object.startDrag(false, scrubber_tool);
}

function event_scrubber_UP(event: MouseEvent) {
	mc_slider.mc_knob.stopDrag();
	set_pen();
	//set other tool sizes here...
	if(str_tool == "SMUDGE"){
		reset_smudge();
	}
};

//positioning the scrubber for various UI states
function event_positionScrubber_DOWN(){
	mc_slider.x = 95;
	mc_slider.y = 401;
};

function event_positionScrubber_DEFAULT(){
	mc_slider.x = 95;
	mc_slider.y = 281;
};


function set_scrubberAlpha(){
	//pen_alpha
	var clip = mc_slider.txt_alpha;
	//maximum
	if(clip.text > 100){
		clip.text = 100;
	}
	//set
	pen_alpha = convert_to_decimal(Number(clip.text));
	//CHANGE LINE STYLE AND ANYTHING ELSE HERE
	set_pen();
	//for each tool, if tool has unique alpha input
	if(str_tool == "RAINBOW PAINT"){
		rainbowPaint_updateColor();
	}
}

//adjust the alpha in the scrubber tool
//all tools use the same alpha (when option exists)
function event_scrubber_alpha_CHANGE(event:Event){
	//
	set_scrubberAlpha();
}

//every tool calls one of these
//show scrubber should call hide first and disable any sub-tools in the scrubber
//they are set back to visible manually depending on the type

//show just the scrubber
function show_scrubber(){
	//hide first to disable alpha or any others
	hide_scrubber();
	//now show just the scrubber
	mc_slider.visible = true;
}

//show scrubber AND alpha
function show_scrubber_alpha(){
	mc_slider.txt_alpha.visible = true;
	mc_slider.mc_alphainput.visible = true;
	mc_slider.visible = true;
	//
	set_scrubberAlpha();//set back incase this value has changed (errase)
}

function hide_scrubber(){
	//manually hide alpha (certain tools will disable alpha while scrubber is on)
	mc_slider.txt_alpha.visible = false;
	mc_slider.mc_alphainput.visible = false;
	//
	mc_slider.visible = false;
}

//manually hide the color box
//for when you chose a tool that needs access to undo/redo
//but not color
function hide_color(){
	mc_colorPicker.visible = false;
	//
	btn_color_setblack.visible = false;
	btn_color_setwhite.visible = false;
	btn_color.visible = false;
	mc_color.visible = false;
	mc_currColor.visible = false;
	//
}

function show_color(){
	mc_colorPicker.visible = true;
	//
	btn_color_setblack.visible = true;
	btn_color_setwhite.visible = true;
	btn_color.visible = true;
	mc_color.visible = true;
	mc_currColor.visible = true;
	//
}

//////////////

////////////SMOOSHER////////////


//smoosher settings (input)
function event_smoosher_toggleSmooth(event:MouseEvent){
	bool_smoosher_blur = !bool_smoosher_blur;
	var txt = mc_smooshzone.txt_smoosh_bool;
	//
	if(!bool_smoosher_blur){
		txt.text = "rugged";
	}else{
		txt.text = "smooth";
	};
	//restart brush
	smoosher_initBrush();
}

//num_smoosher_brushSize
//update the number of the smoosher field
function event_smoosher_numberUpdate(event:Event){
	//
	var clip = event.currentTarget;
	//clip (defaults)
	//
	if(Number(clip.text) < 1){
		clip.text = "1";
	}
	if(Number(clip.text) > 100){
		clip.text = "100";
	}
	//Displacement amount (default is 50)
	if(clip.name == "txt_smoosh_intensity"){
		//
		smoosher_displacementAmount = Number(clip.text);
		//restart
		smoosher_initDisplacementMap();
	};
	//Brush size (default is 20)
	if(clip.name == "txt_smoosh_size"){
		//
		//
		num_smoosher_brushSize = Number(clip.text);
		smoosher_initBrush();
	}
	//Smoothness blur amount (default is 25)
	if(clip.name == "txt_smoosh_smoothness"){
		//
		smoosher_blurAmount = Number(clip.text);
		smoosher_initBrush();
	}
	//
}

function event_smoosher_run(event:Event){
	//
	event_runSmoosher(smoosher_lastMousePos.x, smoosher_lastMousePos.y);
	//
	save_transform_to_canvas(bitmapData_canvasDemo);
	//destory_smoosher();
	restart_smoosher();
}

function event_smoosher_run_DOWN(event:MouseEvent){
	stage.addEventListener(Event.ENTER_FRAME, event_smoosher_run);
	bool_isMouseDown = true;
}

function event_smoosher_run_UP(event:MouseEvent){
	stage.removeEventListener(Event.ENTER_FRAME, event_smoosher_run);
	bool_isMouseDown = false;
}

//smoosher events
function event_smoosher(event:MouseEvent){
	
	//update_after_draw();
	destory_smoosher();
	set_tool("SMOOSHER", btn_smoosher);
	
	openWindow(mc_smooshzone);
	
	mc_smooshzone.mc_background.gotoAndStop(Math.ceil(Math.random()*mc_smooshzone.mc_background.totalFrames));
	
	bool_smoosher_startedSmooshing = false;
	mc_smooshzone.btn_smoosh_run.visible = bool_smoosher_startedSmooshing;
	
	setup_smoosher(canvasBitmapData, false);
	
};

function event_reset_smoosherSettings(event:MouseEvent){
	//trace("reset smoosher settings here");
	smoosher_displacementAmount = 50;
	mc_smooshzone.txt_smoosh_intensity.text = "50";
	//
	mc_smooshzone.txt_smoosh_size.text = "20";
	num_smoosher_brushSize = 20;
	//
	mc_smooshzone.txt_smoosh_smoothness.text = "25";
	smoosher_blurAmount = 25;
	//
	mc_smooshzone.txt_smoosh_bool.text = "smooth";
	bool_smoosher_blur = true;
	//
	smoosher_initDisplacementMap();
	smoosher_initBrush();
}

function event_close_smoosher(){
	//
	//restart_smoosher();
	destory_smoosher();
	//mc_smooshzone.visible = false;
	closeWindow(mc_smooshzone);
	//set back to pencil
	set_pencil_tool();
}

function event_saveSmoosh(event:MouseEvent){
	//
	//only save if a smoosh is actually triggered (to avoid over-blurring)
	if(bool_smoosher_startedSmooshing){
		update_after_draw();
		save_transform_to_canvas(canvasBitmapData);
	};
	//
	event_close_smoosher();
	//
}

function event_resetSmooshes(event:MouseEvent){
	destory_smoosher();
	setup_smoosher(canvasBitmapData, false);
	bool_smoosher_startedSmooshing = false;
	mc_smooshzone.btn_smoosh_run.visible = bool_smoosher_startedSmooshing;
}

function event_cancelSmooshes(event:MouseEvent){
	event_close_smoosher();
}

//////////////

/////////////GLASS STAMPS//////////////

//pace the arrow over the "TYPE" icons
function glassStamps_placeArrow_type(clip:MovieClip){
	mc_glass_stamps.mc_arrow_type.x = clip.x + clip.width - 3;
}

function event_selectGlassType(event:MouseEvent){
	var clip = event.currentTarget;
	//
	if(clip.name == "mc_ico_circle"){
		str_glassStamp_currType = "circle";
		update_glassStamp(str_glassStamp_currFilter, str_glassStamp_currType, mc_glass_stamps["mc_ico_" + str_glassStamp_currType]);
	}
	if(clip.name == "mc_ico_square"){
		str_glassStamp_currType = "square";
		update_glassStamp(str_glassStamp_currFilter, str_glassStamp_currType, mc_glass_stamps["mc_ico_" + str_glassStamp_currType]);
	}
	if(clip.name == "mc_ico_random"){
		str_glassStamp_currType = "random";
		update_glassStamp(arr_glassStamp_filters[Math.ceil(Math.random()*arr_glassStamp_filters.length)-1], arr_glassStamp_types[Math.ceil(Math.random()*arr_glassStamp_types.length)-1], clip, true);
	}
	
	glassStamps_placeArrow_type(clip);

};

function event_selectGlassDifusion(event:MouseEvent){
	var clip = event.currentTarget;
	//mc_arrow_effect
	//str_glassStamp_currFilter "fisheye", "twirl", "bulge", "squeeze", "pinch", "tunel", "stretch"
	if(clip.name == "btn_twirl"){
		str_glassStamp_currFilter = "twirl";
	};
	if(clip.name == "btn_buldge"){
		str_glassStamp_currFilter = "bulge";
	};
	if(clip.name == "btn_squeeze"){
		str_glassStamp_currFilter = "squeeze";
	};
	if(clip.name == "btn_pinch"){
		str_glassStamp_currFilter = "pinch";
	};
	if(clip.name == "btn_tunnel"){
		str_glassStamp_currFilter = "tunel";
	};
	if(clip.name == "btn_strech"){
		str_glassStamp_currFilter = "stretch";
	};
	if(clip.name == "btn_lense"){
		str_glassStamp_currFilter = "fisheye";
	};
	mc_glass_stamps.mc_arrow_effect.y = Math.ceil(clip.y);
	//update stamp icon
	update_glassStamp(str_glassStamp_currFilter, str_glassStamp_currType, mc_glass_stamps["mc_ico_" + str_glassStamp_currType]);
};

function event_glass_txt_CHANGE(event:Event){
	var clip = event.currentTarget;
	if(clip.name == "txt_twirl"){
		num_glassStamp_twirl = Number(clip.text);
	}
	if(clip.name == "txt_buldge"){
		num_glassStamp_buldge = Number(clip.text);
	}
	if(clip.name == "txt_squeeze"){
		num_glassStamp_squeeze = Number(clip.text);
	}
	if(clip.name == "txt_pinch"){
		num_glassStamp_pinch = Number(clip.text);
	}
	if(clip.name == "txt_stretch"){
		num_glassStamp_strech = Number(clip.text);
	}
	if(clip.name == "txt_lense"){
		num_glassStamp_lense = Number(clip.text);
	}
	//update stamp icon
	update_glassStamp(str_glassStamp_currFilter, str_glassStamp_currType, mc_glass_stamps["mc_ico_" + str_glassStamp_currType]);
}

//set the drawing mode (MOUSE DOWN OR JUST STAMP)
function event_glass_setMode(event:MouseEvent){
	//
	//set bool
	bool_glassStamp_stamp = !bool_glassStamp_stamp;
	//set arrow
	//stamp mode
	if(bool_glassStamp_stamp){
		mc_glass_stamps.mc_arrow_drawing.y = Math.ceil(mc_glass_stamps.btn_stamp.y);
	}else{ //draw mode
		mc_glass_stamps.mc_arrow_drawing.y = Math.ceil(mc_glass_stamps.btn_draw.y);
	}
}

//set size of the stamp
function event_glass_setSize(event:Event){
	//
	//restrict size to prevent crash
	if(Number(event.currentTarget.text) > 500){
		event.currentTarget.text = String(500);
	}
	if(Number(event.currentTarget.text) <= 0){
		event.currentTarget.text = String(1);
	}
	//set size
	num_glassStamp_radius = Number(event.currentTarget.text);
	//update stamp icon
	update_glassStamp(str_glassStamp_currFilter, str_glassStamp_currType, mc_glass_stamps["mc_ico_" + str_glassStamp_currType]);
}

//setup input text fields
function setup_glassTextField(txtField:TextField, num_defaultVal:Number){
	txtField.restrict = "0-9\\.";
	txtField.text = String(num_defaultVal);
}

//play/stop the diamonds next to the stamp name on rollover of twirl,buldge,squeeze,etc...
function glass_stamp_diamond(clip:MovieClip, bool:Boolean = false){
	if(!bool){
		clip.stop();
	}else{
		clip.play();
	}
}
function play_glass_stamp_diamond(event:MouseEvent){
	//trace("mc_"+event.currentTarget.name);
	var clip = mc_glass_stamps["mc_"+event.currentTarget.name].mc_clip;
	glass_stamp_diamond(clip, true);
}
function stop_glass_stamp_diamond(event:MouseEvent){
	var clip = mc_glass_stamps["mc_"+event.currentTarget.name].mc_clip;
	glass_stamp_diamond(clip, false);
}

function event_glassStamps_reset(event:MouseEvent){
	bitmapData_canvasDemo.draw(canvasBitmapData); //resets it
};

//reset the entire UI and all values (used when closing the stamps UI)
function glassStamps_resetUI(){
	num_glassStamp_radius = 50;//stamp size value
	//values for all fields
	num_glassStamp_twirl = 5;
	num_glassStamp_buldge = .5;
	num_glassStamp_squeeze = 1.1;
	num_glassStamp_pinch = .35;
	num_glassStamp_strech = 100;
	num_glassStamp_lense = 0.8;
	//setup again
	setup_glassTextField(mc_glass_stamps.txt_twirl, num_glassStamp_twirl);
	setup_glassTextField(mc_glass_stamps.txt_buldge, num_glassStamp_buldge);
	setup_glassTextField(mc_glass_stamps.txt_squeeze, num_glassStamp_squeeze);
	setup_glassTextField(mc_glass_stamps.txt_pinch, num_glassStamp_pinch);
	setup_glassTextField(mc_glass_stamps.txt_stretch, num_glassStamp_strech);
	setup_glassTextField(mc_glass_stamps.txt_lense, num_glassStamp_lense);
	setup_glassTextField(mc_glass_stamps.txt_size, num_glassStamp_radius);
	//
	bool_glassStamp_stamp = true;
	mc_glass_stamps.mc_arrow_drawing.y = Math.ceil(mc_glass_stamps.btn_stamp.y);
	//
	//update stamp icon
	update_glassStamp(str_glassStamp_currFilter, str_glassStamp_currType, mc_glass_stamps["mc_ico_" + str_glassStamp_currType]);
}

function event_glass_stamps_accept(event:MouseEvent){
	//ADD TO CANVAS HERE
	update_after_draw();
	canvasBitmapData.draw(bitmap_canvasDemo.bitmapData, null, null, null, null, false);
	//
	close_glass_stamps();
}

function event_glass_stamps_cancel(event:MouseEvent){
	close_glass_stamps();
}

function close_glass_stamps(){
	//
	//mc_glass_stamps.visible = false;
	closeWindow(mc_glass_stamps);
	glassStamps_clearSprites();
	//
	clear_canvasDemo();
	//
	set_pencil_tool();
	//reset whole UI & all values
	glassStamps_resetUI();
}

function event_glass_stamps(event:MouseEvent){
	
	//setup clone bitmap
	create_canvasDemo();
	
	//mc_glass_stamps.visible = true;
	openWindow(mc_glass_stamps);
	
	glassStamps_placeArrow_type(mc_glass_stamps.mc_ico_circle);
	
	str_glassStamp_currType = "circle";
	update_glassStamp("twirl", "circle", mc_glass_stamps.mc_ico_circle);
	
	set_tool("GLASS STAMPS", btn_glass_stamps);
	
	//apply listeners for drawing event
	mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
	mc_draw.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
	mc_draw.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
	mc_draw.addEventListener(MouseEvent.RELEASE_OUTSIDE, mouseUp);
}

//////////////

////////////SMUDGE////////////
//trace("TODO: ADVANCED SMUDGE -- customize smudge with other textures");

function event_smudge(event:MouseEvent){
	//reset_pen();
	set_tool("SMUDGE", btn_smudge);
	//mc_slider.visible = false;
	show_scrubber();
	set_scrubber_XVal(mc_slider, 200);
	//update values incase they have changed...
	reset_smudge();
	//
	mc_draw.addEventListener(MouseEvent.MOUSE_DOWN, event_smudge_down);
	mc_draw.addEventListener(MouseEvent.MOUSE_UP, event_smudge_up);
	mc_draw.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_smudge_up);
};

//////////////

////////////AIRBRUSH////////////

//trigger it on/of
function event_airbrush(event:MouseEvent){
	//delete_airbrush is part of set_tools
	set_tool("SOFT BRUSH", btn_softbrush);
	hide_scrubber();
	mc_setting_brushes.visible = true;
	//
	setup_airbrush();
	airbrush_toggleFade(false);
	//
}

//////////////

///////////SHARED MISC BRUSH SIZE UI (ARIBRUSH AND PERLIN CHALK//////////

function airbrush_toggleFade(bool_isFalse:Boolean = false){
	//set this if default should be false (first run)
	if(!bool_isFalse){
		bool_airbrushFade = true;
	}else{
		bool_airbrushFade = !bool_airbrushFade;
	}
	//
	if(!bool_airbrushFade){
		mc_setting_brushes.txt_fade.text = "Fade OFF";
		deselectColor(mc_setting_brushes.btn_fade);
	}else{
		mc_setting_brushes.txt_fade.text = "Fade ON";
		selectedColor(mc_setting_brushes.btn_fade);
	}
}

function event_airbrush_toggleFade(event:MouseEvent){
	airbrush_toggleFade(true);
}

function airbrush_setSize(num_size:Number){
	//
	//maximum
	if(num_size > 100){
		num_size = 100;
	}
	if(num_size < 0){
		num_size = 0;
	}
	//
	num_airbrushSize = Number(num_size);
	//update text field incase this value is being passed
	mc_setting_brushes.txt_size.text = num_size;
	
	if(str_tool == "SOFT BRUSH"){
		setup_airbrush();
	}
	
	if(str_tool == "SOFT BRUSH"){
		perlinChalk_setupBitmap();
	}
}

//setting the size of the brush (is a Event.CHANGE)
function event_airbrush_setSize(event:Event){
	//
	airbrush_setSize(Number(mc_setting_brushes.txt_size.text));
	
}

//////////////

////////////PERLIN CHALK////////////

function event_perlinChalk(event:MouseEvent){
	
	//SHOW SETTINGS UI (size and trail)
	set_tool("PERLIN CHALK", btn_perlinchalk);
	hide_scrubber();
	mc_setting_brushes.visible = true;
	
	perlinChalk_setupBitmap();
	
	airbrush_setSize(20);
	airbrush_toggleFade(false);
}

//////////////

//////////////RUNNY INK/////////////

function event_runnyInk_input_CHANGE(event:Event){
	//
	var clip = event.currentTarget;
	var clip_name = clip.name;
	//maximum
	if(clip.text > 100){
		clip.text = "100";
	}
	//minimum
	if(clip.text < 0){
		clip.text = "1";
	}
	//
	if(clip_name == "txt_size"){
		num_runnyInkSize = Number(clip.text);
	}
	if(clip_name == "txt_alpha"){
		num_runnyInkAlpha = Number(clip.text);
	}
}

function event_runnyInk(event:MouseEvent){
	//
	set_tool("RUNNY INK", btn_runnyInk);
	hide_scrubber();
	mc_setting_runnyInk.visible = true;
	//RUNNY INK HAS SEPARATE UI
	//SIZE AND FADE RATE
	//SHOW UI FOR ADJUSTING
	//
	setup_runyInk();
}

//////////////

////////////PERLIN BRUSH////////////


function perlin_textSetup_bools(txtField:TextField, bool:Boolean){
	txtField.text = String(bool);
}

//update UI is called when adjusting the valeus
//and in the perlin function when setting random
//update UI is shared
function perlin_updateUI(){
	mc_setting_perlinbrush.txt_baseX.text = num_perlinBrush_baseX;
	mc_setting_perlinbrush.txt_baseY.text = num_perlinBrush_baseY;
	mc_setting_perlinbrush.txt_seed.text = num_perlinBrush_seed;
	mc_setting_perlinbrush.txt_octaves.text = num_perlinBrush_octaves;
	mc_setting_perlinbrush.txt_channelOptions.text = num_perlinBrush_channelOptions;
	//
	mc_setting_perlinbrush.txt_fractalNoise.text = bool_perlinBrush_fractalNoise;
	mc_setting_perlinbrush.txt_stitch.text = bool_perlinBrush_stitch;
	mc_setting_perlinbrush.txt_grayscale.text = bool_perlinBrush_grayScale;
}

//reset perlin after updating
function perlin_updateAll(){
	perlin_updateUI();
	reset_perlinBrush();
}

function perlin_channelOptions_setRGB_UP(event:MouseEvent){
	var clip_name = event.currentTarget.name;
	//
	if(clip_name == "btn_red"){
		num_perlinBrush_channelOptions = 1;
		trace("red");
	}
	if(clip_name == "btn_blue"){
		num_perlinBrush_channelOptions = 4;
		trace("blue");
	}
	if(clip_name == "btn_green"){
		num_perlinBrush_channelOptions = 2;
		trace("green");
	}
	//
	perlin_updateAll();
}

function perlin_textInput_EVENT(event:Event){
	var clip = event.currentTarget;
	var clip_name = clip.name;
	//none should be larger than 100
	//except for channels which should be 7
	if(clip.text > 100){
		clip.text = "100";
	};
	//
	if(clip_name == "txt_baseX"){
		num_perlinBrush_baseX = Number(clip.text);
	}
	if(clip_name == "txt_baseY"){
		num_perlinBrush_baseY = Number(clip.text);
	}
	if(clip_name == "txt_seed"){
		num_perlinBrush_seed = Number(clip.text);
	}
	if(clip_name == "txt_octaves"){
		num_perlinBrush_octaves = Number(clip.text);
	}
	if(clip_name == "txt_channelOptions"){
		if(clip.text > 7){
			clip.text = "7";
		}
		num_perlinBrush_channelOptions = Number(clip.text);
	}
	//
	perlin_updateAll();
};

function perlin_toggleBool_UP(event:MouseEvent){
	var clip = event.currentTarget;
	var clip_name = clip.name;
	//
	if(clip_name == "txt_fractalNoise"){
		bool_perlinBrush_fractalNoise = !bool_perlinBrush_fractalNoise;
	}
	if(clip_name == "txt_stitch"){
		bool_perlinBrush_stitch = !bool_perlinBrush_stitch;
	}
	if(clip_name == "txt_grayscale"){
		bool_perlinBrush_grayScale = !bool_perlinBrush_grayScale;
	}
	//
	perlin_updateAll();
}

//toggle draw random, bool controls the perlin function values
function perlin_toggleDrawRandom(event:MouseEvent){
	//
	var clip = event.currentTarget;
	
	bool_perlinBrush_drawRandom = !bool_perlinBrush_drawRandom;
	
	if(bool_perlinBrush_drawRandom){
		selectedColor(clip);
	}else{
		deselectColor(clip);
	};
	
	perlin_updateAll();
}

function perlin_generateRandVals_UP(event:MouseEvent){
	perlin_randomValues();
}

function perlin_toggleDrawNoise(event:MouseEvent){
	//
	var clip = event.currentTarget;
	//hide ui that's not noise related
	//only show channel options
	 bool_perlinBrush_drawNoise = !bool_perlinBrush_drawNoise;
	//
	if(bool_perlinBrush_drawNoise){
		//hide ui
		mc_setting_perlinbrush.txt_baseX.visible = false;
		mc_setting_perlinbrush.txt_baseY.visible = false;
		mc_setting_perlinbrush.txt_seed.visible = false;
		mc_setting_perlinbrush.txt_octaves.visible = false;
		mc_setting_perlinbrush.txt_fractalNoise.visible = false;
		mc_setting_perlinbrush.txt_stitch.visible = false;
		mc_setting_perlinbrush.txt_grayscale.visible = false;
		selectedColor(clip);
		//
	}else{
		//show
		mc_setting_perlinbrush.txt_baseX.visible = true;
		mc_setting_perlinbrush.txt_baseY.visible = true;
		mc_setting_perlinbrush.txt_seed.visible = true;
		mc_setting_perlinbrush.txt_octaves.visible = true;
		mc_setting_perlinbrush.txt_fractalNoise.visible = true;
		mc_setting_perlinbrush.txt_stitch.visible = true;
		mc_setting_perlinbrush.txt_grayscale.visible = true;
		deselectColor(clip);
	}
	//
	perlin_updateAll();
}

function event_perlinbrush(event:MouseEvent){
	set_tool("PERLIN BRUSH", btn_perlinbrush);
	//
	show_scrubber();
	mc_setting_perlinbrush.visible = true;
	//setup
	reset_perlinBrush();
	//
	//call setup
	//numbers
	setup_numberDecimal_txt(mc_setting_perlinbrush.txt_baseX, num_perlinBrush_baseX);
	setup_numberDecimal_txt(mc_setting_perlinbrush.txt_baseY, num_perlinBrush_baseY);
	setup_numberDecimal_txt(mc_setting_perlinbrush.txt_seed, num_perlinBrush_seed);
	setup_numberDecimal_txt(mc_setting_perlinbrush.txt_octaves, num_perlinBrush_octaves);
	setup_numberDecimal_txt(mc_setting_perlinbrush.txt_channelOptions, num_perlinBrush_channelOptions);
	//booleans
	perlin_textSetup_bools(mc_setting_perlinbrush.txt_fractalNoise, bool_perlinBrush_fractalNoise);
	perlin_textSetup_bools(mc_setting_perlinbrush.txt_stitch, bool_perlinBrush_stitch);
	perlin_textSetup_bools(mc_setting_perlinbrush.txt_grayscale, bool_perlinBrush_grayScale);
	//
	perlin_updateUI();
}

//////////////

////////////CUSTOM INK////////////

function customInk_randRange_visibility(){
	//
	mc_settings_customInk.mc_x.visible = bool_customInk_lineRange;
	mc_settings_customInk.mc_y.visible = bool_customInk_lineRange;
	mc_settings_customInk.txt_x1_1.visible = bool_customInk_lineRange;
	mc_settings_customInk.txt_x1_2.visible = bool_customInk_lineRange;
	mc_settings_customInk.txt_y1_1.visible = bool_customInk_lineRange;
	mc_settings_customInk.txt_y1_2.visible = bool_customInk_lineRange;
}

function customInk_toggleRange_EVENT(event:MouseEvent){
	//
	var clip = event.currentTarget;
	//
	bool_customInk_lineRange = !bool_customInk_lineRange;
	//
	customInk_randRange_visibility();
	//
	if(bool_customInk_lineRange){
		selectedColor(clip);
	}else{
		deselectColor(clip);
	}
}

function customInk_resetVals_EVENT(event:MouseEvent){
	//
	bool_customInk_lineRange = false;
	deselectColor(clip);
	customInk_randRange_visibility();
	//
	num_customInk_maxSize = 5;
	num_customInk_precision = 30;
	num_customInk_alpha = 5;
	//
	num_customInk_lineRange_X1 = 10;
	num_customInk_lineRange_X2 = 10;
	num_customInk_lineRange_Y1 = 10;
	num_customInk_lineRange_Y2 = 10;
	//
	setup_numberDecimal_txt(mc_settings_customInk.txt_maxsize, num_customInk_maxSize);
	setup_numberDecimal_txt(mc_settings_customInk.txt_precision, num_customInk_precision);
	setup_numberDecimal_txt(mc_settings_customInk.txt_alpha, num_customInk_alpha);
	setup_numberDecimal_txt(mc_settings_customInk.txt_x1_1, num_customInk_lineRange_X1);
	setup_numberDecimal_txt(mc_settings_customInk.txt_x1_2, num_customInk_lineRange_X2);
	setup_numberDecimal_txt(mc_settings_customInk.txt_y1_1, num_customInk_lineRange_Y1);
	setup_numberDecimal_txt(mc_settings_customInk.txt_y1_2, num_customInk_lineRange_Y2);
}

function customInk_input_CHECK(clip, str_var:String, max:Number){
	//
	this[str_var] = clip.text;
	//max
	if(this[str_var] > max){
		this[str_var] = max;
	}
	//set
	clip.text = this[str_var];
	//
	trace(str_var);
}

function customInk_input_CHANGE(event:Event){
	//
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//
	if(clip_name == "txt_maxsize"){
		customInk_input_CHECK(clip, "num_customInk_maxSize", 100);
	}
	if(clip_name == "txt_precision"){
		customInk_input_CHECK(clip, "num_customInk_precision", 80);
	}
	if(clip_name == "txt_alpha"){
		//
		customInk_input_CHECK(clip, "num_customInk_alpha", 100);
	}
	//
	if(clip_name == "txt_x1_1"){
		customInk_input_CHECK(clip, "num_customInk_lineRange_X1", 100);
	}
	if(clip_name == "txt_x1_2"){
		customInk_input_CHECK(clip, "num_customInk_lineRange_X2", 100);
	}
	if(clip_name == "txt_y1_1"){
		customInk_input_CHECK(clip, "num_customInk_lineRange_Y1", 100);
	}
	if(clip_name == "txt_y1_2"){
		customInk_input_CHECK(clip, "num_customInk_lineRange_Y2", 100);
	}
	//
}


function customInk_event_TOOLTIP(event:MouseEvent){
	//
	var clip = event.currentTarget;
	clip.text = rand_array(arr_invisibleCreature);
}

function customInk_event_TOOLTIP_OUT(event:MouseEvent){
	var clip = event.currentTarget;
	clip.text = "";
}

function event_customInk(event:MouseEvent){
	
	//open new ui
	//hide old ui
	//setup text fields
	set_tool("CUSTOM INK", btn_customInk);
	//
	hide_scrubber();
	mc_settings_customInk.visible = true;
	//
	customInk_randRange_visibility();
	
}

//////////////

////////////DOTTED LINES////////////

function event_dotted_INPUT_CHANGE(event:Event){
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//
	if(clip.text > 200){
		clip.text = "300";
	}
	//
	if(clip_name == "txt_length"){
		num_dottedLength = clip.text;
	}
	if(clip_name == "txt_spacing"){
		num_dottedSpacing = clip.text;
	}
	if(clip_name == "txt_sprinkle"){
		num_dottedSprinkle = clip.text;
	}
}

function event_dashedLines_comment_OVER(event:MouseEvent){
	mc_setting_dotted.txt_comment.text = rand_array(arr_dottedLines);
}
function event_dashedLines_comment_OUT(event:MouseEvent){
	mc_setting_dotted.txt_comment.text = "";
}

function event_dashedLines(event:MouseEvent){
	//
	set_tool("DOTTED LINES", btn_dotted);
	//
	show_scrubber_alpha();
	mc_setting_dotted.visible = true;
	//SHOW SETTINGS UI
	//LENGTH AND SPACING
}

//////////////

////////////LOW INK LINES////////////

function event_lowInk_setInk(event:MouseEvent){
	var clip = event.currentTarget;
	var clip_name = clip.name;
	//deselect all others
	deselectColor(mc_setting_lowink.btn_default);
	deselectColor(mc_setting_lowink.btn_random);
	deselectColor(mc_setting_lowink.btn_pulse);
	deselectColor(mc_setting_lowink.btn_wave);
	//select this one
	selectedColor(clip);
	//
	if(clip_name == "btn_default"){
		str_lowInk_type = "default";
	}
	if(clip_name == "btn_random"){
		str_lowInk_type = "random";
	}
	if(clip_name == "btn_pulse"){
		str_lowInk_type = "pulse";
	}
	if(clip_name == "btn_wave"){
		str_lowInk_type = "wave";
	}
}

function event_lowInk_input_CHANGE(event:Event){
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//
	if(clip_name == "txt_fadeRate"){
		num_lowInk_fadeRate = clip.text;
	}
	if(clip_name == "txt_maxSize"){
		num_pen_size_defaultMax = clip.text;
	}
	if(clip_name == "txt_minSize"){
		num_pen_size_MIN = clip.text;
	}

	//update text fields here (if value is too high/low, set back)
	mc_setting_lowink.txt_minSize.text = num_pen_size_MIN;
	mc_setting_lowink.txt_maxSize.text = num_pen_size_defaultMax;
	//
	
	//reset
	//lowInk_resetValues();
	//cap values (adjust if too much/too low...)
	//convert fade rate to decimal here
	lowInk_setValues();
}

function event_lowInk(event:MouseEvent){
	//
	set_tool("LOW INK", btn_lowink);
	//
	hide_scrubber();
	mc_setting_lowink.visible = true;
	//
	//lowInk_resetValues();
	lowInk_setValues();
}

//////////////

trace("TODO: STRAIGHT LINES");
////////////STRAIGHT LINES////////////




//////////////

////////////BACON////////////

//TODO: FIX THIS AND MAKE IT USABLE ACROSS ALL COLOR CHOOSING TOOLS...
//BACON COLOR UI
//select a color tab in the bacon menu
function event_bacon_selectColor(event:MouseEvent){
	//
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//
	str_currPenColor = String(string_getNumber(clip_name));
	//set the rectangle position
	mc_setting_bacon.mc_colSelect.x = clip.x;
	mc_setting_bacon.mc_colSelect.y = clip.y;
	//
}
//update color channel from spectrum
function update_bacon_color(bitmapData:BitmapData, clip){
	//get color from mouse position and pass it to ColorTransform
	hexColor = "0x" + bitmapData.getPixel(clip.mouseX, clip.mouseY).toString(16);
	//
	//what tab is selected...
	this["ct_baconCol"+str_currPenColor].color = hexColor;
	mc_setting_bacon["mc_col" + str_currPenColor].mc_col.transform.colorTransform = this["ct_baconCol"+str_currPenColor];
	//
};
function updateBaconColors(){
	//set current clip to ct_colorPicker
	//selected color = hexColor
	//pen_color = selected_color;
	this["baconPen_color" + str_currPenColor] = hexColor;
	this["ct_baconCol"+str_currPenColor].color = this["baconPen_color" + str_currPenColor];
	mc_setting_bacon["mc_col" + str_currPenColor].mc_col.transform.colorTransform = this["ct_baconCol"+str_currPenColor];
	//
}
//set the graphics to the colors
//for first run & when a color is selected
function setBaconColors(){
	ct_baconCol1.color = baconPen_color1;
	ct_baconCol2.color = baconPen_color2;
	ct_baconCol3.color = baconPen_color3;
	ct_baconCol4.color = baconPen_color4;
	//set tabs
	mc_setting_bacon.mc_col1.mc_col.transform.colorTransform = ct_baconCol1;
	mc_setting_bacon.mc_col2.mc_col.transform.colorTransform = ct_baconCol2;
	mc_setting_bacon.mc_col3.mc_col.transform.colorTransform = ct_baconCol3;
	mc_setting_bacon.mc_col4.mc_col.transform.colorTransform = ct_baconCol4;
}

//TEXT FIELDS
function event_baconText_CHANGE(event:Event){
	//
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//max
	if(clip.text > 500){
		clip.text = 500;
	}
	//x
	if(clip_name == "txt_xMin"){
		num_bacon_x_MIN = Number(clip.text);
	}
	if(clip_name == "txt_xMax"){
		num_bacon_x_MAX = Number(clip.text);
	}
	//y
	if(clip_name == "txt_yMin"){
		num_bacon_x_MIN = Number(clip.text);
	}
	if(clip_name == "txt_yMax"){
		num_bacon_x_MAX = Number(clip.text);
	}
	//
}

function event_bacon(event:MouseEvent){
	//
	set_tool("BACON", btn_bacon);
	//
	show_scrubber_alpha();
	mc_setting_bacon.visible = true;
	//
}

//////////////

/////////////EGGS////////////////

//SET THE COLORS OF EGG
trace("TODO: BACON AND EGG COLOR TABS> IF YOU ADD MORE MAKE THIS GENERIC AND USE THE SAME FOR BACON AND EGGS AND ANY OTHER...");
//select which color tab
function event_egg_selectColor(event:MouseEvent){
	//
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//
	str_currEggColor = String(string_getNumber(clip_name));
	//set the rectangle position
	mc_setting_eggs.mc_colSelect.x = clip.x;
	mc_setting_eggs.mc_colSelect.y = clip.y;
	//
}
//update color channel from spectrum
function update_egg_color(bitmapData:BitmapData, clip){
	hexColor = "0x" + bitmapData.getPixel(clip.mouseX, clip.mouseY).toString(16);
	//what tab is selected...
	this["ct_eggCol"+str_currEggColor].color = hexColor;
	mc_setting_eggs["mc_col" + str_currEggColor].mc_col.transform.colorTransform = this["ct_eggCol"+str_currEggColor];
	//
};
function updateEggColors(){
	//
	this["egg_color" + str_currEggColor] = hexColor;
	this["ct_eggCol"+str_currEggColor].color = this["egg_color" + str_currEggColor];
	mc_setting_eggs["mc_col" + str_currEggColor].mc_col.transform.colorTransform = this["ct_eggCol"+str_currEggColor];
	//
	egg_updateFilters();
}
//set the graphics to the egg colors
function setEggColors(){
	ct_eggCol1.color = egg_color1;
	ct_eggCol2.color = egg_color2;
	//set tabs
	mc_setting_eggs.mc_col1.mc_col.transform.colorTransform = ct_eggCol1;
	mc_setting_eggs.mc_col2.mc_col.transform.colorTransform = ct_eggCol2;
}

//EGG EVENTS
//set the egg type
//highlight button
//set var
function event_set_eggType(event:MouseEvent){
	//
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//unhighlight
	deselectColor(mc_setting_eggs.btn_round);
	deselectColor(mc_setting_eggs.btn_cube);
	//highlight
	selectedColor(clip);
	//
	if(clip_name == "btn_round"){
		str_eggType = "round";
	}
	if(clip_name == "btn_cube"){
		str_eggType = "cubed";
	}
}
//set the egg mood
//highlight these buttons separately
//set var...
function event_set_eggMood(event:MouseEvent){
	//
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//unhighlight
	deselectColor(mc_setting_eggs.btn_good);
	deselectColor(mc_setting_eggs.btn_messy);
	deselectColor(mc_setting_eggs.btn_chaos);
	deselectColor(mc_setting_eggs.btn_eggnog);
	deselectColor(mc_setting_eggs.btn_glitch);
	//highlight
	selectedColor(clip);
	//set... "good" "messy" "chaos" "eggnog" "glitch"
	if(clip_name == "btn_good"){
		str_eggMood = "good";
	}
	if(clip_name == "btn_messy"){
		str_eggMood = "messy";
	}
	if(clip_name == "btn_chaos"){
		str_eggMood = "chaos";
	}
	if(clip_name == "btn_eggnog"){
		str_eggMood = "eggnog";
	}
	if(clip_name == "btn_glitch"){
		str_eggMood = "glitch";
	}
	//call filter again (incase of eggnog...)
	egg_updateFilters();
}
//set glow (update glow)
function event_set_glow_CHANGE(event:Event){
	//
	var clip = event.currentTarget;
	//max and min settings...
	if(clip.text > 200){
		clip.text = "200";
	}
	if(clip.text <= 0){
		clip.text = "0";
	}
	//set values...
	if(clip.name == "txt_blur"){
		num_eggGlow_blur = Number(clip.text);
	}
	if(clip.name == "txt_strength"){
		num_eggGlow_strength = Number(clip.text);
	}
	//call filter again to update
	egg_updateFilters();
}

function event_egg(event:MouseEvent){
	//
	set_tool("EGGS", btn_eggs);
	//
	show_scrubber_alpha();
	mc_setting_eggs.visible = true;
	//
	setEggColors();
	//
	egg_init();
}

//////////////

////////////TOAST////////////
/*
toast is a burn tool
texture over the top with overlay (or other, strongest setting)
set a color to burn to (see TINT)

then you paint, use same principle as the PERLIN NOISE brush...
*/

function event_toast_burn_CHANGE(event:Event){
	//get it from the text field so you can control the pileon of decimal convertion
	var txt = event.currentTarget.text;
	var num_convert = Number(txt);
	
	//max and minimum
	if(num_convert <= 0){
		num_convert = 1;
	}
	if(num_convert >= 500){
		num_convert = 500;
	}
	
	num_toast_burnAmnt = num_convert;//convert_to_decimal(num_convert);
	
	//set text again incase it's above max/min
	txt = num_toast_burnAmnt;
	
	reset_toastBrush();
};

function event_toast_toggleBools(event:MouseEvent){
	var clip = event.currentTarget;
	var bool = clip.text;
	//
	if(clip.name == "txt_outline"){
		bool_toast_outline = !bool_toast_outline;
		clip.text = bool_toast_outline;
	};
	if(clip.name == "txt_negative"){
		bool_toast_negative = !bool_toast_negative;
		clip.text = bool_toast_negative;
	}
	if(clip.name == "txt_gray"){
		bool_toast_grayscale = !bool_toast_grayscale;
		clip.text = bool_toast_grayscale;
	}
	
	reset_toastBrush();
}

function event_toast(event:MouseEvent){	
	set_tool("TOAST", btn_toast);
	//
	show_scrubber();
	mc_setting_toast.visible = true;
	//
	//call setup
	reset_toastBrush();
	//
	//update any UI values here
	setup_numberDecimal_txt(mc_setting_toast.txt_burn, num_toast_burnAmnt);
}

//////////////

////////////ASCII PAINT////////////

function closeAsciiPaint(){
	mc_asciipaint.visible = false;
	deleteAscii();
	//reset to pen
	set_pencil_tool();
}

//DONE! button
//save to canvas, clear everything, return to drawing tool
function event_ascii_DONE(event:MouseEvent){
	saveAsciiToBitmap(canvasBitmapData);
	//
	closeAsciiPaint();
}

//reset the ascii grid (start over)
function event_ascii_CLEAR(event:MouseEvent){
	resetAsciiGrid();
}

//cancel (don't draw anything)
//get rid of all ascii
function event_ascii_CANCEL(event:MouseEvent){
	closeAsciiPaint();
}

//save current ascii art to a text file
function event_ascii_saveAsText(event:MouseEvent){
	saveAsciiToTextFile(returnAsciiGrid(), "MY_ASCII_ART");
}

//save ascii art to clipboard
function event_ascii_saveToClipboard(event:MouseEvent){
	saveAsciiToClipboard(returnAsciiGrid());
}

//set the mode to draw with
//chose which type
//and set the highlighter to that
function event_ascii_SET_MODE(event:MouseEvent){
	//
	var clip = event.currentTarget;
	//highlight...
	mc_asciipaint.mc_settings.mc_selected.x = clip.x;
	mc_asciipaint.mc_settings.mc_selected.y = clip.y;
	//hide custom again
	mc_asciipaint.mc_settings.mc_input.visible = false;
	//eraser, random, dingbats, blocks, alphanumeric, intput
	if(clip.name == "btn_unicode"){
		str_ascii_drawMode = "random";
	};
	if(clip.name == "btn_dingbats"){
		str_ascii_drawMode = "dingbats";
	};
	if(clip.name == "btn_blocks"){
		str_ascii_drawMode = "blocks";
	};
	if(clip.name == "btn_alphanumeric"){
		str_ascii_drawMode = "alphanumeric";
	};
	//if erase
	if(clip.name == "btn_eraser"){
		str_ascii_drawMode = "eraser";
	}
	//if custom field
	if(clip.name == "btn_custom"){
		str_ascii_drawMode = "input";
		mc_asciipaint.mc_settings.mc_input.visible = true;
	};
}

//input custom string for ascii art
//this is the custom field that hides/shows when you select draw custom
function event_ascii_SET_INPUT(event:Event){
	var clip = event.currentTarget;
	str_currAsciiLetters = clip.text;
}

//set the color
function event_ascii_SET_COLOR(event:MouseEvent){
	var clip = event.currentTarget;
	//set colors
	mc_asciipaint.mc_settings.mc_selected_color.x = clip.x;
	mc_asciipaint.mc_settings.mc_selected_color.y = clip.y;
	//ROW 1
	//black
	if(clip.name == "btn_col1"){
		int_asciiColor = 0x000000;
	}
	//blue
	if(clip.name == "btn_col2"){
		int_asciiColor = 0x0001A8;
	}
	//green
	if(clip.name == "btn_col3"){
		int_asciiColor = 0x00A801;
	}
	//blue
	if(clip.name == "btn_col4"){
		int_asciiColor = 0x00A8A8;
	}
	//ROW 2
	//red
	if(clip.name == "btn_col5"){
		int_asciiColor = 0xA80000;
	}
	//pink
	if(clip.name == "btn_col6"){
		int_asciiColor = 0xA800A8;
	}
	//brown
	if(clip.name == "btn_col7"){
		int_asciiColor = 0xA85700;
	}
	//darkbrown
	if(clip.name == "btn_col8"){
		int_asciiColor = 0x660033;
	}
	//ROW3
	//grey
	if(clip.name == "btn_col9"){
		int_asciiColor = 0x575757;
	}
	//blue
	if(clip.name == "btn_col10"){
		int_asciiColor = 0x5757FF;
	}
	//green
	if(clip.name == "btn_col11"){
		int_asciiColor = 0x57FF57;
	}
	//blue
	if(clip.name == "btn_col12"){
		int_asciiColor = 0x57FFFF;
	}
	//red
	if(clip.name == "btn_col13"){
		int_asciiColor = 0xFF5757;
	}
	//pink
	if(clip.name == "btn_col14"){
		int_asciiColor = 0xFF57FF;
	}
	//yellow
	if(clip.name == "btn_col15"){
		int_asciiColor = 0xFFFF57;
	}
	//white
	if(clip.name == "btn_col16"){
		int_asciiColor = 0xFFFFFF;
	}
}

function ascii_skeletonFact(){
	mc_asciipaint.mc_popup.visible = true;
	mc_asciipaint.mc_popup.txt_fact.text = rand_array(arr_skeleton_didyouknow);
}

//close the skeleton popup
function event_asciipaint_popup_close(event:MouseEvent){
	mc_asciipaint.mc_popup.visible = false;
	mc_asciipaint.mc_skeleton.stop();
}

//click the skeleton in the corner
function event_asciipaint_skeleton_UP(event:MouseEvent){
	mc_asciipaint.mc_skeleton.play();
	ascii_skeletonFact();
}

//open the settings if cat is showing (closed)
function event_asciipaint_openSettings(event:MouseEvent){
	mc_asciipaint.mc_settings.visible = true;
	mc_asciipaint.mc_cat.gotoAndStop("hide");
}
//close settings (show the cat)
function event_asciipaint_minimizeSettings(event:MouseEvent){
	mc_asciipaint.mc_settings.visible = false;
	mc_asciipaint.mc_cat.gotoAndStop("idle");
}

//click the cat
//arr_snd_cat rand_array
//snd_chan
function event_asciiCat_PET(event:MouseEvent){
	snd_chan.stop();
	snd_chan = rand_array(arr_snd_cat).play();
	mc_asciipaint.mc_cat.gotoAndStop("pet");
}

function event_asciipaint(event:MouseEvent){
	//
	set_tool("ASCIIPAINT", btn_asciipaint);
	//show ascii UI
	mc_asciipaint.visible = true;
	mc_asciipaint.mc_popup.visible = false;
	mc_asciipaint.mc_fade.gotoAndPlay(1);
	mc_asciipaint.mc_cat.gotoAndStop("hide");
	
	//enable ascii grid
	resetAsciiGrid();
}

//////////////

/////////////GOLDFISH - FISH DYNAMIX PRO////////
//submerge your art in water and splash around in it 

//set the input fields (text) for water
function event_waterInputs_CHANGE(event:Event){
	//
	var clip = event.currentTarget;
	var num_val:Number = clip.text;//get value from field
	//
	//restrict MAX/MIN of either
	if(num_val > 200){
		//restrict and set back...
		clip.text = "200";
		num_val = clip.text;
	}
	//
	if(num_val <= 3){
		clip.text = "3";
		num_val = clip.text;
	}
	//
	if(clip.name == "txt_fluid_distance"){
		//
		num_val = convert_to_decimal(num_val);
		//
		//set again to updated value
		num_water_bufferScale = num_val;
	}
	if(clip.name == "txt_fluid_ripple"){
		//do not convert this to decimal
		int_water_rippleSize = num_val;
	}
	//reset with updated values
	save_waterDraw(canvasBitmapData);
	reset_water();
	//
}

function event_waterToggleRain(event:MouseEvent){
	//toggle
	bool_water_rain = !bool_water_rain;
	//
	if(!bool_water_rain){
		mc_goldfish.mc_fluid_toggle.gotoAndStop(1);
	}else{
		mc_goldfish.mc_fluid_toggle.gotoAndStop(2);
	}
	//save to canvas to save "splashes"
	save_waterDraw(canvasBitmapData);
	//reset here
	reset_water();
}

function event_waterSetMode(event:MouseEvent){
	//choose between draw modes
	var clip = event.currentTarget;
	//set fish (show what is selected)
	mc_goldfish.mc_fish.y = clip.y;
	mc_goldfish.mc_fish.x = clip.x + clip.width + 70;
	//
	if(clip.name == "btn_draw"){
		str_water_drawType = "draw";
	}
	if(clip.name == "btn_splash"){
		str_water_drawType = "splash";
	}
	//save to canvas to save "splashes"
	save_waterDraw(canvasBitmapData);
	//reset here
	reset_water();
}

//the ACCEPT button - quit and save bitmapdata
function event_water_ACCEPT(event:MouseEvent){
	//
	//CLOSE GOLDFISH
	show_color();//show color field again
	save_waterDraw(canvasBitmapData);
	clear_water();
	mc_goldfish.visible = false;
	//set back to pencil
	set_pencil_tool();
}

//open website...
function event_water_poweredBy(event:MouseEvent){
	openURL("http://mackerelmediafish.com/");
}


function event_goldfish(event:MouseEvent){
	
	set_tool("GOLDFISH", btn_goldfish);
	
	hide_color();//hide color field, only undo/redo show at top
	mc_goldfish.visible = true;
	mc_goldfish.mc_fade.gotoAndPlay(1);
	
	//clear first - incase...
	clear_water();
	//start - send it the base canvas
	init_water(canvasBitmap.bitmapData);
}

//////////////

////////////RAINBOW PAINT////////////
//a custom gradient to draw lines with

//THE COLOR TABS...
//(also called in the color picker, with all the other special settings color tips)
//calls from arrays. could allow user to set how many colors they want...
function event_rainbowpaint_selectColor(event:MouseEvent){
	//
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//
	str_currRainbowColor = String(string_getNumber(clip_name));
	//set the rectangle position
	mc_setting_rainbowpaint.mc_colSelect.x = clip.x;
	mc_setting_rainbowpaint.mc_colSelect.y = clip.y;
	//
}
//update from spectrum
function update_rainbowpaint_color(bitmapData:BitmapData, clip){
	//get color from mouse position and pass it to ColorTransform
	hexColor = "0x" + bitmapData.getPixel(clip.mouseX, clip.mouseY).toString(16);
	//what tab is selected...
	arr_rainbowColorTransform[Number(str_currRainbowColor)-1].color = hexColor;
	mc_setting_rainbowpaint["mc_col" + str_currRainbowColor].mc_col.transform.colorTransform = arr_rainbowColorTransform[Number(str_currRainbowColor)-1];//this["ct_rainbowCol"+str_currRainbowColor];
	//
};
//update the color clip and keep it
function updateRainbowColors(){
	//set current clip to ct_rainbowCol[NUMBER]
	//selected color = hexColor
	//pen_color = selected_color
	arr_rainbowColor[Number(str_currRainbowColor)-1] = hexColor;
	arr_rainbowColorTransform[Number(str_currRainbowColor)-1].color = hexColor;
	mc_setting_rainbowpaint["mc_col" + str_currRainbowColor].mc_col.transform.colorTransform = arr_rainbowColorTransform[Number(str_currRainbowColor)-1];//this["ct_rainbowCol"+str_currRainbowColor];
	//
}
//set the colors (when you click or roll out of the color wheel, this is the actual color that is selected
//populate all
function setRainbowColors(){
	//
	for (var i:Number = 0; i<arr_rainbowColorTransform.length; ++i){
		arr_rainbowColorTransform[i].color = arr_rainbowColor[i];
		mc_setting_rainbowpaint["mc_col" + Number(i+1)].mc_col.transform.colorTransform = arr_rainbowColorTransform[i];
	}
}

//BOTTOM BUTTONS
//rainbowGradientType, rainbowSpreadMethod, and rainbowInterpolationMethod
//rainbowGradientType = GradientType.LINEAR or GradientType.RADIAL
//rainbowSpreadMethod = SpreadMethod.PAD	SpreadMethod.REFLECT or SpreadMethod.REPEAT
//rainbowInterpolationMethod = InterpolationMethod.LINEAR_RGB	InterpolationMethod.RGB
function event_rainbow_toggleSetting(event:MouseEvent){
	//
	var clip = event.currentTarget;
	//gradient TYPE
	if(clip.name == "btn_type"){
		//
		if(rainbowGradientType == "linear"){
			rainbowGradientType = GradientType.RADIAL;
			trace("set to RADIAL");
		}else{
			rainbowGradientType = GradientType.LINEAR;
			trace("set to LINEAR");
		}
		//set UI text
		mc_setting_rainbowpaint.txt_type.text = rainbowGradientType.toUpperCase();
	}
	//gradient SPREAD METHOD
	if(clip.name == "btn_spread"){
		//step through all spread methods
		if(rainbowSpreadMethod == "pad"){
			rainbowSpreadMethod = SpreadMethod.REFLECT;
		}else if(rainbowSpreadMethod == "reflect"){
			rainbowSpreadMethod = SpreadMethod.REPEAT;
		}else{
			rainbowSpreadMethod = SpreadMethod.PAD
		}
		//set ui
		mc_setting_rainbowpaint.txt_spread.text = rainbowSpreadMethod.toUpperCase();
	}
	//gradient INTERPOLATION METHOD
	if(clip.name == "btn_interpolation"){
		//
		if(rainbowInterpolationMethod == "linearRGB"){
			rainbowInterpolationMethod = InterpolationMethod.RGB;
		}else{
			rainbowInterpolationMethod = InterpolationMethod.LINEAR_RGB;
		}
		//set ui
		mc_setting_rainbowpaint.txt_interpolation.text = rainbowInterpolationMethod.toUpperCase();
	}
	//
}

//TEXT INPUTS
function event_rainbow_textInput_CHANGE(event:Event){
	//
	var clip = event.currentTarget;
	var num_val = Number(clip.text);
	//min/max (x,y,width,height)
	if(num_val > 1000){
		num_val = 1000;
	}
	if(num_val < -1000){
		num_val = -1000;
	}
	//specific for txt_offset (range from -1 to 0 to 1)
	if(clip.name == "txt_offset" && num_val < -1){
		num_val = -1;
	}
	if(clip.name == "txt_offset" && num_val > 1){
		num_val = 1;
	}
	//update text field to reflect max/min
	if(!isNaN(Number(clip.text))){
		clip.text = num_val;
	}
	//
	if(clip.name == "txt_width"){
		num_rainbowGradientWidth = num_val;
	}
	if(clip.name == "txt_height"){
		num_rainbowGradientHeight = num_val;
	}
	if(clip.name == "txt_offset"){
		num_rainbowGradientOffset = num_val;
	}
	//
	if(clip.name == "txt_x"){
		num_rainbowGradientX = num_val;
	}
	if(clip.name == "txt_y"){
		num_rainbowGradientY = num_val;
	}
	//
	event_rainbow_textInput_setText();
	//restrict NaN to show just the "-"
	//if you make a negative value it will default to NaN before you can add the rest
	//this restricts that...
	if(isNaN(Number(clip.text))){
		clip.text = "-";
	}
}

//set all text fields to the current var values
function event_rainbow_textInput_setText(){
	mc_setting_rainbowpaint.txt_width.text = String(num_rainbowGradientWidth);
	mc_setting_rainbowpaint.txt_height.text = String(num_rainbowGradientHeight);
	mc_setting_rainbowpaint.txt_offset.text = String(num_rainbowGradientOffset);
	mc_setting_rainbowpaint.txt_x.text = String(num_rainbowGradientX);
	mc_setting_rainbowpaint.txt_y.text = String(num_rainbowGradientY);
}

function event_rainbow_textInput_RESET(event:MouseEvent){
	//
	num_rainbowGradientWidth = mc_draw.width;
	num_rainbowGradientHeight = mc_draw.height;
	num_rainbowGradientX = 0;
	num_rainbowGradientY = 0;
	num_rainbowGradientOffset = 0;
	//
	event_rainbow_textInput_setText();
	//
}

function rainbowPaint_updateColor(){
	//update the color array based on new values here
	//update all other setings...
	rainbowPaint_initColors();
}

function event_rainbowpaint(event:MouseEvent){
	//
	set_tool("RAINBOW PAINT", btn_rainbowpaint);
	mc_setting_rainbowpaint.visible = true;
	//init
	rainbowPaint_initColors();
	show_scrubber_alpha();
	setRainbowColors();//set the color tabs
	//
}

//////////////

////////////DRAW AND FILL////////////////////
//draw a line and fill with chosen color after drawing
//auto fill...
//UI lets you select line or fill color

//select which color tab
function event_drawAndFill_selectColor(event:MouseEvent){
	//
	var clip = event.currentTarget;
	var clip_name = event.currentTarget.name;
	//
	if(clip_name == "mc_col_line"){
		str_drawAndFill_currSelection = "line";
	}else{
		str_drawAndFill_currSelection = "fill";
	}
	//set the rectangle position
	mc_setting_drawandfill.mc_colSelect.x = clip.x;
	mc_setting_drawandfill.mc_colSelect.y = clip.y;
	//
}
//update color channel from spectrum
function update_drawAndFill_color(bitmapData:BitmapData, clip){
	hexColor = "0x" + bitmapData.getPixel(clip.mouseX, clip.mouseY).toString(16);
	//what tab is selected...
	this["ct_drawAndFill_"+str_drawAndFill_currSelection+"Col"].color = hexColor;
	mc_setting_drawandfill["mc_col_" + str_drawAndFill_currSelection].mc_col.transform.colorTransform = this["ct_drawAndFill_"+str_drawAndFill_currSelection+"Col"];
	//
};
function updateDrawAndFillColors(){
	//
	this["drawAndFill_" + str_drawAndFill_currSelection + "Col"] = hexColor;
	this["ct_drawAndFill_"+str_drawAndFill_currSelection+"Col"].color = this["drawAndFill_" + str_drawAndFill_currSelection + "Col"];
	mc_setting_drawandfill["mc_col_" + str_drawAndFill_currSelection].mc_col.transform.colorTransform = this["ct_drawAndFill_"+str_drawAndFill_currSelection+"Col"];
	//
	//update or reset pen modes here...
}
//set the UI to the new colors (also call on open)
function setDrawAndFillColors(){
	ct_drawAndFill_lineCol.color = drawAndFill_lineCol;
	ct_drawAndFill_fillCol.color = drawAndFill_fillCol;
	//set tabs
	mc_setting_drawandfill.mc_col_line.mc_col.transform.colorTransform = ct_drawAndFill_lineCol;
	mc_setting_drawandfill.mc_col_fill.mc_col.transform.colorTransform = ct_drawAndFill_fillCol;
}


//the compliment button that generates some kind words
function event_drawAndFill_compliment(event:MouseEvent){
	//cat squeak sound
	//play_sound_array(arr_snd_cat);
	//
	mc_setting_drawandfill.txt_compliment.text = rand_array(arr_paintandfill_compliments);
	//
}


function event_drawAndFill(event:MouseEvent){
	//
	set_tool("DRAW AND FILL", btn_drawandfill);
	show_scrubber_alpha();
	setDrawAndFillColors();
	//
	mc_setting_drawandfill.visible = true;
}

//////////////

////////////BASIC SHAPES/////////////////////
trace("I AM HERE: MAKING THE PLACEMENT AND DRAWING OF SIMPLE SHAPES");
//circles, squares, stars...



//////////////

/////////////GIF BRUSH//////////////////////
//load animated gif
//paint animation to canvas

function event_gifbrush(event:MouseEvent){
	//
	set_tool("GIF BRUSH", btn_gifbrush);
	mc_setting_gifbrush.visible = true;
	//size it for first run (setX)
	set_scrubber_XVal(mc_slider, 150);
	//
	gifbrush_setupLoader();
	//init here
	show_scrubber();
}

//////////////

////////////SCREAM INTO THE VOID////////////

function scream_into_the_void_text(){
	//
	if(Math.random()*100 > 70 && num_voidScreams > 2){
		str_voidScreams = "THE VOID " + rand_array(arr_void_actions) + " YOU" + rand_array(arr_punctuation);
	}else{
		str_voidScreams = rand_array(arr_void) + rand_array(arr_punctuation);
	}
	//
	str_voidScreams = str_voidScreams.toUpperCase();
	mc_setting_void.txt_void.text = str_voidScreams;
	//str_voidScreams
}

function event_scream_into_the_void(event:MouseEvent){
	//
	update_after_draw();
	//
	scream_into_the_void_text();
	scream_into_the_void(canvasBitmapData);
	num_voidScreams += 1;//increment how often you have screamed
	//sound
	play_sound_array(arr_snd_voidScreams);
}


function event_void(event:MouseEvent){
	//
	set_tool("SCREAM INTO THE VOID", btn_void);
	//
	num_voidScreams = 0;//reset
	mc_setting_void.visible = true;
	hide_scrubber();
	//
}

//////////////

////////////SPRAY////////////

trace("TODO: DRAWING SPRAY SHOULD BE IN THE DEFAULT DRAWING MOVE FUNCTION, NOT SEPARATE -- MOVE THIS");

function event_spray_MOVE(event: MouseEvent) {
	draw_spray(event.localX, event.localY);
}

function event_spray_down(event:MouseEvent){
	//
	update_after_draw();
	//
	mc_draw.addEventListener(MouseEvent.MOUSE_MOVE, event_spray_MOVE);
};

function event_spray_up(event:MouseEvent){
	mc_draw.removeEventListener(MouseEvent.MOUSE_MOVE, event_spray_MOVE);
};

function event_spray(event:MouseEvent){
	set_tool("SPRAY", btn_spray);
	show_scrubber();
	mc_draw.addEventListener(MouseEvent.MOUSE_DOWN, event_spray_down);
	mc_draw.addEventListener(MouseEvent.MOUSE_UP, event_spray_up);
	mc_draw.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_spray_up);
};

//////////////

////////////PATTERN SPRAY////////////

function event_clear_sprayPatternCanvas(event: MouseEvent){
	clear_sprayPatternCanvas();
};

//buttoms for sizing and rotation
function set_sprayPattern_UI(clip, bool: Boolean) {
	//button colors
	if (!bool) {
		//unselect button (change color)
		deselectColor(clip);
		//
	} else {
		//select button (change color)
		selectedColor(clip);
		//
	}
}

function event_sprayPattern_setRotation(event: MouseEvent) {
	//
	bool_sprayPattern_rotation = !bool_sprayPattern_rotation;
	set_sprayPattern_UI(event.currentTarget, bool_sprayPattern_rotation);
};

function event_sprayPattern_setSize(event: MouseEvent) {
	//
	bool_sprayPattern_size = !bool_sprayPattern_size;
	set_sprayPattern_UI(event.currentTarget, bool_sprayPattern_size);
};

function event_sprayPattern_loadImage(event: MouseEvent) {
	//remove lines
	//clear canvas and bitmap/data
	//load image
	clear_sprayPatternCanvas();
	load_bitmapSprayImage(canvasBitmapData_drawSpray, mc_draw_spray.width, mc_draw_spray.height);
};


function visible_patternSprayUI(bool_visible:Boolean){
	for(var i:Number = 0; i<arr_ui_tools_patternspray.length; ++i){
		arr_ui_tools_patternspray[i].visible = bool_visible;
	};
};

function event_close_patternSpray(event:MouseEvent){
	visible_patternSprayUI(false);
	mc_popup_background.gotoAndPlay("close");
	//
	event_positionColorPicker_DEFAULT();
	//
	show_scrubber_alpha();
	event_positionScrubber_DEFAULT();
	//bool_editMode = false;
};

function event_open_patternSpray(event:MouseEvent){
	
	set_tool("PATTERNSPRAY", btn_patternspray);
	//
	event_positionScrubber_DOWN();
	show_scrubber_alpha();
	//
	event_positionColorPicker_DOWN();
	//
	visible_patternSprayUI(true);
	mc_popup_background.gotoAndPlay("open");
	
};

//////////////

////////////AUTHENTICIFY !?!?////////////

//trace("TODO: STACK EFFECTS, HAVE A BLUE 'RESET' BUTTON THAT DISABLES ALL");

//This is the actual set effect function
//this is where you call everything
function event_authentic_setEffect(event:MouseEvent){
	var effect_name:String = event.currentTarget.name;
	
	//reset all
	authentic_resetBitmap();
	authentic_disableAll();
	//Punk Aesthetic
	if(effect_name == "btn_monochrome"){
		set_checkBox(mc_authentic.mc_monochrome);
		monochrome(bitmapData_canvasDemo);
	}
	if(effect_name == "btn_desaturate"){
		set_checkBox(mc_authentic.mc_desaturate);
		auth_desaturate();
	}
	//Netscape Navigator
	if(effect_name == "btn_floyd"){
		set_checkBox(mc_authentic.mc_floyd);
		auth_floyd();
	}
	if(effect_name == "btn_dither"){
		set_checkBox(mc_authentic.mc_dither);
		auth_dither();
	}
	if(effect_name == "btn_stucki"){
		set_checkBox(mc_authentic.mc_stucki);
		auth_stucki();
	}
	//BAD PRINTSHOP
	if(effect_name == "btn_badhalftones"){
		set_checkBox(mc_authentic.mc_badhalftones);
		auth_badHalftone();
	}
	if(effect_name == "btn_goodhalftones"){
		set_checkBox(mc_authentic.mc_goodhalftones);
		auth_goodHalftone();
	}
	//NICE THINGS
	if(effect_name == "btn_grayscale"){
		set_checkBox(mc_authentic.mc_grayscale);
		setGrayScale(bitmapData_canvasDemo);
	};
	if(effect_name == "btn_pixelart"){
		set_checkBox(mc_authentic.mc_pixelart);
		auth_pixelArt();
		//filt_pixelate(bitmapData_canvasDemo, bitmapData_canvasDemo, auth_num_pixelSize);
	};
	if(effect_name == "btn_sketch"){
		set_checkBox(mc_authentic.mc_sketch);
		sketch(bitmapData_canvasDemo);
	}
	//COLOR MANAGEMENT
	if(effect_name == "btn_reducecolor"){
		set_checkBox(mc_authentic.mc_reducecolor);
		auth_reduceColors();
	};
	if(effect_name == "btn_cga"){
		set_checkBox(mc_authentic.mc_cga);
		toCGA(bitmapData_canvasDemo);
	};
	if(effect_name == "btn_ega"){
		set_checkBox(mc_authentic.mc_ega);
		toEGA(bitmapData_canvasDemo);
	}
	if(effect_name == "btn_ham"){
		set_checkBox(mc_authentic.mc_ham);
		toHAM(bitmapData_canvasDemo);
	}
	if(effect_name == "btn_vga"){
		set_checkBox(mc_authentic.mc_vga);
		toVGA(bitmapData_canvasDemo);
	}
	if(effect_name == "btn_svga"){
		set_checkBox(mc_authentic.mc_svga);
		toSVGA(bitmapData_canvasDemo);
	}
};

function authentic_resetBitmap(){
	bitmapData_canvasDemo.draw(canvasBitmapData); //resets it
};

function authentic_disableAll(){
	set_checkBox(mc_authentic.mc_monochrome, false);
	set_checkBox(mc_authentic.mc_desaturate, false);
	set_checkBox(mc_authentic.mc_floyd, false);
	set_checkBox(mc_authentic.mc_dither, false);
	set_checkBox(mc_authentic.mc_stucki, false);
	set_checkBox(mc_authentic.mc_badhalftones, false);
	set_checkBox(mc_authentic.mc_goodhalftones, false);
	set_checkBox(mc_authentic.mc_grayscale, false);
	set_checkBox(mc_authentic.mc_sketch, false);
	set_checkBox(mc_authentic.mc_pixelart, false);
	set_checkBox(mc_authentic.mc_reducecolor, false);
	set_checkBox(mc_authentic.mc_cga, false);
	set_checkBox(mc_authentic.mc_ega, false);
	set_checkBox(mc_authentic.mc_ham, false);
	set_checkBox(mc_authentic.mc_vga, false);
	set_checkBox(mc_authentic.mc_svga, false);
}

//UPDATING SETTINGS
function event_authentic_txt_CHANGE(event:Event){
	var currField = event.currentTarget;
	//
	if(currField.name == "txt_desaturate_num"){
		auth_num_desaturate = Number(currField.text);
		if(auth_num_desaturate >= 100){
			auth_num_desaturate = 100;
			currField.text = auth_num_desaturate;
		}
		auth_desaturate();
	}
	//
	if(currField.name == "txt_floyd_num"){
		auth_num_floyd = Number(currField.text);
		if(auth_num_floyd > 10){
			auth_num_floyd = 10;
			currField.text = auth_num_floyd;
		}
		auth_floyd();
	}
	if(currField.name == "txt_dither_num"){
		auth_num_dither = Number(currField.text);
		if(auth_num_dither > 10){
			auth_num_dither = 10;
			currField.text = auth_num_dither;
		}
		auth_dither();
	}
	if(currField.name == "txt_stucki_num"){
		auth_num_stucki = Number(currField.text);
		if(auth_num_stucki > 10){
			auth_num_stucki = 10;
			currField.text = auth_num_stucki;
		}
		auth_stucki();
	}
	//
	if(currField.name == "txt_badhalftone_num1"){
		auth_num_badHalftone_pointRadius = Number(currField.text);
		if(auth_num_badHalftone_pointRadius > 100){
			auth_num_badHalftone_pointRadius = 100;
			currField.text = auth_num_badHalftone_pointRadius;
		}
		auth_badHalftone();
	}
	if(currField.name == "txt_badhalftone_num2"){
		auth_num_badHalftone_pointMultiplier = Number(currField.text);
		if(auth_num_badHalftone_pointMultiplier > 5){
			auth_num_badHalftone_pointMultiplier = 5;
			currField.text = auth_num_badHalftone_pointMultiplier;
		}
		auth_badHalftone();
	}
	if(currField.name == "txt_badhalftone_color"){
		auth_col_badHalftone = "0x" + currField.text;
		auth_badHalftone();
	}
	//
	if(currField.name == "txt_hafltones_brushsize"){
		auth_num_goodHalftone_brushsize = Number(currField.text);
		//min and max values (control values to prevent timeout)
		if(auth_num_goodHalftone_brushsize > 50){
			auth_num_goodHalftone_brushsize = 50;
			currField.text = 50;
		};
		//
		if(auth_num_goodHalftone_brushsize > 10 && auth_num_goodHalftone_sample < 5){
			auth_num_goodHalftone_sample = 5;
			mc_authentic.txt_hafltones_sample.text = auth_num_goodHalftone_sample;
		}
		//
		auth_goodHalftone();
	}
	if(currField.name == "txt_hafltones_sample"){
		auth_num_goodHalftone_sample = Number(currField.text);
		//min and max values (control values to prevent timeout)
		if(auth_num_goodHalftone_brushsize > 10 && auth_num_goodHalftone_sample < 5){
			auth_num_goodHalftone_sample = 5;
			mc_authentic.txt_hafltones_sample.text = auth_num_goodHalftone_sample;
		}
		//
		auth_goodHalftone();
	}
	//
	if(currField.name == "txt_pixelart_num"){
		auth_num_pixelSize = Number(currField.text);
		if(auth_num_pixelSize > 100){
			auth_num_pixelSize = 100;
			currField.text = auth_num_pixelSize;
		}
		auth_pixelArt();
	}
	//
	if(currField.name == "txt_reduceColor_num"){
		auth_num_reduceColor = Number(currField.text);
		auth_reduceColors();
	};
}
function event_authentic_grayscale(event:MouseEvent){
	var curr_field = event.currentTarget;
	//
	if(curr_field.name == "txt_floyd_grayscale"){
		auth_bool_floyd = !auth_bool_floyd;
		curr_field.text = "Grayscale: " + Number(auth_bool_floyd);
		auth_floyd();
	}
	if(curr_field.name == "txt_dither_grayscale"){
		auth_bool_dither = !auth_bool_dither;
		curr_field.text = "Grayscale: " + Number(auth_bool_dither);
		auth_dither();
	}
	if(curr_field.name == "txt_stucki_grayscale"){
		auth_bool_stucki = !auth_bool_stucki;
		curr_field.text = "Grayscale: " + Number(auth_bool_stucki);
		auth_stucki();
	}
	//
	if(curr_field.name == "txt_badhalftone_invert"){
		auth_bool_badHalftone_invert = !auth_bool_badHalftone_invert;
		curr_field.text = "Invert: " + Number(auth_bool_badHalftone_invert);
		auth_badHalftone();
	}
	if(curr_field.name == "txt_badhalftone_grayscale"){
		auth_bool_badHalftone_grayscale = !auth_bool_badHalftone_grayscale;
		curr_field.text = "Grayscale: " + Number(auth_bool_badHalftone_grayscale);
		auth_badHalftone();
	}
	//
	if(curr_field.name == "txt_reduceColor_grayscale"){
		auth_bool_reduceColor = !auth_bool_reduceColor;
		curr_field.text = "Grayscale: " + Number(auth_bool_reduceColor);
		auth_reduceColors();
	}
}

//setup input text fields
function setup_authentic_num_inputText(txtField:TextField, num_defaultVal:Number){
	txtField.restrict = "0-9";
	txtField.text = String(num_defaultVal);
}
function setup_authentic_hex_inputText(txtField:TextField, str_defaultVal:String){
	txtField.restrict = "0-9\\a-z\\A-Z";
	txtField.text = str_defaultVal;
}

function set_checkBox(clip:MovieClip, bool_enabled:Boolean = true){
	//
	var clip_name = clip.name;
	//
	if(bool_enabled){
		clip.gotoAndStop(2);
	}else{
		clip.gotoAndStop(1);
	}
	//hide or show text fields
	if(clip_name == "mc_desaturate"){
		mc_authentic.txt_desaturate_num.visible = bool_enabled;
	}
	if(clip_name == "mc_floyd"){
		mc_authentic.txt_floyd_num.visible = bool_enabled;
		mc_authentic.txt_floyd_grayscale.visible = bool_enabled;
	}
	if(clip_name == "mc_dither"){
		mc_authentic.txt_dither_num.visible = bool_enabled;
		mc_authentic.txt_dither_grayscale.visible = bool_enabled;
	}
	if(clip_name == "mc_stucki"){
		mc_authentic.txt_stucki_num.visible = bool_enabled;
		mc_authentic.txt_stucki_grayscale.visible = bool_enabled;
	}
	if(clip_name == "mc_badhalftones"){
		mc_authentic.txt_badhalftone_num1.visible = bool_enabled;
		mc_authentic.txt_badhalftone_color.visible = bool_enabled;
		mc_authentic.txt_badhalftone_invert.visible = bool_enabled;
		mc_authentic.txt_badhalftone_num2.visible = bool_enabled;
		mc_authentic.txt_badhalftone_grayscale.visible = bool_enabled;
	}
	if(clip_name == "mc_goodhalftones"){
		mc_authentic.txt_hafltones_sample.visible = bool_enabled;
		mc_authentic.txt_hafltones_brushsize.visible = bool_enabled;
	}
	if(clip_name == "mc_pixelart"){
		mc_authentic.txt_pixelart_num.visible = bool_enabled;
	}
	if(clip_name == "mc_reducecolor"){
		mc_authentic.txt_reduceColor_num.visible = bool_enabled;
		mc_authentic.txt_reduceColor_grayscale.visible = bool_enabled;
	}
}

function reset_authenticTool(){
	//when you close it
	_setPencil();
	show_scrubber_alpha();
	//remove
	mc_draw.removeChild(bitmap_canvasDemo);
	bitmapData_canvasDemo.dispose();
	//
	closeWindow(mc_authentic);
	//reset all UI here...
	//arr_authentic_effects = [];//clear array
}

function event_accept_authentic(event:MouseEvent){
	//set filter here
	//
	update_after_draw();
	//
	//var matrix:Matrix = bitmap_canvasDemo.transform.matrix;
	canvasBitmapData.draw(bitmap_canvasDemo.bitmapData, null, null, null, null, false);
	//close & remove
	reset_authenticTool();
};

function event_cancel_authentic(event:MouseEvent){
	//close & remove
	reset_authenticTool();
};

function event_open_authentic(event:MouseEvent){
	//
	set_tool("AUTHENTICITY TOoL", btn_authentic);
	
	//tagline
	mc_authentic.txt_tip.text = rand_array(arr_fanzineline);
	
	//FOR TEST PURPOSES ONLY HAVE test(), REVERT TO canvasBitmapData when done
	bitmap_canvasDemo = new Bitmap(canvasBitmapData, "auto", true);
	
	//draw it
	bitmapData_canvasDemo = new BitmapData(mc_draw.width, mc_draw.height, false, 0x000000);
	bitmapData_canvasDemo.draw(bitmap_canvasDemo);
	bitmap_canvasDemo.bitmapData = bitmapData_canvasDemo;
	
	//
	mc_draw.addChild(bitmap_canvasDemo);
	//
	mc_authentic.mc_fade.gotoAndPlay(2);
	openWindow(mc_authentic);
	//
	setup_authentic_num_inputText(mc_authentic.txt_desaturate_num, auth_num_desaturate);
	setup_authentic_num_inputText(mc_authentic.txt_floyd_num, auth_num_floyd);
	setup_authentic_num_inputText(mc_authentic.txt_dither_num, auth_num_dither);
	setup_authentic_num_inputText(mc_authentic.txt_stucki_num, auth_num_stucki);
	setup_authentic_num_inputText(mc_authentic.txt_badhalftone_num1, auth_num_badHalftone_pointRadius);
	setup_authentic_num_inputText(mc_authentic.txt_badhalftone_num2, auth_num_badHalftone_pointMultiplier);
	setup_authentic_num_inputText(mc_authentic.txt_hafltones_sample, auth_num_goodHalftone_sample);
	setup_authentic_num_inputText(mc_authentic.txt_hafltones_brushsize, auth_num_goodHalftone_brushsize);
	setup_authentic_num_inputText(mc_authentic.txt_pixelart_num, auth_num_pixelSize);
	setup_authentic_num_inputText(mc_authentic.txt_reduceColor_num, auth_num_reduceColor);
	//
	setup_authentic_hex_inputText(mc_authentic.txt_badhalftone_color, "FFFFFF");
	//undo all checkboxes
	authentic_disableAll();
	//
	
};

//////////////

/////////////EASY BLEND & DISPLACER-IZER//////////////
//load an image from your drive and
//merge one image with another!
//simple overlay, blend, and dispacement effects <3
// >> load image and it sets to full + that transform tool, can set the type of effect and it live sets as you move with transform tool

//completely reset the blend and displace loaded image
function reset_blend_and_displace_image(){
	blend_and_displace_clearFilters();
	//
	reset_imageImportChildren();
	set_imageImportChildren();
	//
	//
}

//restart it, and re-add it after removing everything
function restart_blend_and_displace_image(){
	reset_blend_and_displace_image();
	//add clip again after completely erasing it
	clip_importImage.addChild(loader_importImage);
	clip_importImage.x = mc_draw.x;
	clip_importImage.y = mc_draw.y;
	//
}

//rest all values and filters here
function blend_and_displace_resetAfterPlace(){
	setup_blend_and_displace_txt(mc_blend_and_displace.txt_blur, 0);
	blend_and_displace_clearFilters();//clear all filters
	set_blend_and_displace_mode("add", clip_importImage);
}

function blend_and_displace_clearFilters(){
	//clear all filters!!
	clip_importImage.filters = [];//clear all filters
	mc_draw.filters = [];
}

function set_blend_and_displace_arrow(str_type:String){
	//set the arrow
	mc_blend_and_displace.mc_selected.x = Math.ceil(mc_blend_and_displace["btn_" + str_type].width - 20);
	mc_blend_and_displace.mc_selected.y = Math.ceil(mc_blend_and_displace["btn_" + str_type].y + 20);
}

//set arrow to the selected blendmode
function set_blend_and_displace_mode(str_type:String, clip:MovieClip){
	//set the blend mode
	//call (see COLOR.as)
	this["blendMode_" + str_type](clip);
	set_blend_and_displace_arrow(str_type);
}

//listeners for activating different blendmodes
function event_blend_and_displace_setMode(event:MouseEvent){
	//
	var clip_name = event.currentTarget.name;
	var clip = event.currentTarget;
	//check if you should clear it first
	//trace(mc_draw.filters[0]);
	//reset and rebuild if the displacement filter has been applied
	if(String(mc_draw.filters[0]) == "[object DisplacementMapFilter]"){
		restart_blend_and_displace_image();
		//must be called here, before setting anything, so that it restarts properly & blendmode is applied
	}
	//restart before applying new...
	trace("!!! TODO: THERE'S A BUG HERE, WHERE IF YOU CHOOSE DISPLACEMENT, FILTERS STOP WORKING.");
	blend_and_displace_clearFilters();
	//
	if(clip_name == "btn_add"){
		set_blend_and_displace_mode("add", clip_importImage);
	}
	if(clip_name == "btn_darken"){
		set_blend_and_displace_mode("darken", clip_importImage);
	}
	if(clip_name == "btn_difference"){
		set_blend_and_displace_mode("difference", clip_importImage);
	}
	if(clip_name == "btn_hardlight"){
		set_blend_and_displace_mode("hardlight", clip_importImage);
	}
	if(clip_name == "btn_invert"){
		set_blend_and_displace_mode("invert", clip_importImage);
	}
	if(clip_name == "btn_lighten"){
		set_blend_and_displace_mode("lighten", clip_importImage);
	}
	if(clip_name == "btn_multiply"){
		set_blend_and_displace_mode("multiply", clip_importImage);
	}
	if(clip_name == "btn_overlay"){
		set_blend_and_displace_mode("overlay", clip_importImage);
	}
	if(clip_name == "btn_screen"){
		set_blend_and_displace_mode("screen", clip_importImage);
	}
	if(clip_name == "btn_subtract"){
		set_blend_and_displace_mode("subtract", clip_importImage);
	}
	//
	//
};
//set the displacement (not blend mode)
function event_blend_and_displace_displacement(event:MouseEvent){
	//setting displacement is in a separate function
	//so things can properly reset when going back to blend modes
	//and text fields can update the displacement
	blend_and_displace_setDisplacement();
};

//set up the displacement mode for mc_draw of loaded image
//called on click and when text boxes are updated
function blend_and_displace_setDisplacement(){
	//
	//restart all first
	//compeltely reset the transform tool & remove it's target
	reset_transformTool();
	//completely reset and rebuild the sprite containing the image
	reset_blend_and_displace_image();
	set_blend_and_displace_arrow("displacementmap");
	//clear first incase you are re-setting it
	mc_draw.filters = [];
	// This function creates the displacement map filter at clip_import's location
	// Position the filter. 
	var filterX: Number = (clip_importImage.x);
	var filterY: Number = (clip_importImage.y);
	var pt: Point = new Point(filterX, filterY);
	//
	var mapBitmap = Bitmap(loader_importImage.content).bitmapData;
	var mapPoint = pt;
	/*
    BitmapDataChannel.ALPHA
    BitmapDataChannel.BLUE
    BitmapDataChannel.GREEN
    BitmapDataChannel.RED	
	*/
	var componentX:uint      = blend_and_displace_componentX;//!!!!   colors to map to
	var componentY:uint      = blend_and_displace_componentY;//!!!!   colors to map to
	//The multiplier to use to scale the x or y displacement result from the map calculation. 
	var scaleX:Number        = Number(mc_blend_and_displace.txt_disp_scaleX.text);//!!!!   horizontal shift
	var scaleY:Number        = Number(mc_blend_and_displace.txt_disp_scaleY.text);//!!!!   vertical shift
	/*
    DisplacementMapFilterMode.WRAP — Wraps the displacement value to the other side of the source image.
    DisplacementMapFilterMode.CLAMP — Clamps the displacement value to the edge of the source image.
    DisplacementMapFilterMode.IGNORE — If the displacement value is out of range, ignores the displacement and uses the source pixel.
    DisplacementMapFilterMode.COLOR — If the displacement value is outside the image, substitutes the values in the color and alpha properties.	
	*/
	var mode:String          = blend_and_displace_mode;//DisplacementMapFilterMode.COLOR; //how to wrap it
	/*
	Specifies what color to use for out-of-bounds displacements. The valid range of displacements is 0.0 to 1.0. Values are in hexadecimal format. The default value for color is 0. Use this property if the mode property is set to DisplacementMapFilterMode.COLOR. 	
	*/
	var color:uint           = Number(mc_blend_and_displace.txt_disp_color.text);//!!!!   
	/*
	Specifies the alpha transparency value to use for out-of-bounds displacements. It is specified as a normalized value from 0.0 to 1.0. For example, .25 sets a transparency value of 25%. The default value is 0. Use this property if the mode property is set to DisplacementMapFilterMode.COLOR.
	*/
	var alpha:Number         = Number(mc_blend_and_displace.txt_disp_alpha.text);//!!!!  
	//set it
	var xyFilter: DisplacementMapFilter = new DisplacementMapFilter(mapBitmap, mapPoint, componentX, componentY, scaleX, scaleY, mode, color, alpha);
	//apply it
	mc_draw.filters = [xyFilter];
	//debug
	/*trace("blend_and_displace_setDisplacement");
	trace("componentX: " + componentX);
	trace("componentY: " + componentY);
	trace("scaleX: " + scaleX);
	trace("scaleY: " + scaleY);
	trace("mode: " + mode);
	trace("color: " + color);
	trace("alpha: " + alpha);*/
}

//setup input text fields
function setup_blend_and_displace_txt(txtField:TextField, num_defaultVal:Number){
	txtField.restrict = "0-9\\.";
	txtField.text = String(num_defaultVal);
}

function event_blend_and_displace_txtCHANGE(event:Event){
	//set values for number fields
	var clip = event.currentTarget;
	var clip_txt = Number(clip.text);
	//
	var num_maxVal:Number = 500;
	//BLUR
	if(clip.name == "txt_blur"){
		//maximum blur value
		if(clip_txt >= num_maxVal){
			clip_txt = num_maxVal;
			clip.text = String(num_maxVal);
		};
		//
		setBlur(clip_importImage, clip_txt, clip_txt, 1);
		//
	};
	//both x/y share same maximum/minimum
	if(clip.name == "txt_disp_scaleX" || clip.name == "txt_disp_scaleY"){
		//maximum x first
		//if(){}
		blend_and_displace_setDisplacement();
	};
	//both alpha and color share the same maximu/minimum
	if(clip.name == "txt_disp_color" || clip.name == "txt_disp_alpha"){
		//max color value first
		if(clip_txt >= 1){
			clip_txt = 1;
			clip.text = String(1);
		};
		blend_and_displace_setDisplacement();
	};
};

//stepping through array for setting the modes for component and color
//for the displacement map
//see: arr_displacement_componentModes
function event_blend_and_displace_setArray(_var:String, _setVar:String, arr:Array){
	//_var is the number of the array element
	//_setVar is the variable to set to (updated variable)
	//array is the array that's being stepped through
	this[_var] += 1;
	if(this[_var] > arr.length-1){
		this[_var] = 0;
	}
	this[_setVar] = arr[this[_var]][0];
	//return the name
	return arr[this[_var]][1];
}

function event_blend_and_displace_txtCLICK(event:MouseEvent){
	//cycle through values for word text fields
	var clip_name = event.currentTarget.name;
	//componentX and Y
	if(clip_name == "txt_disp_mapX"){
		//step through array
		event.currentTarget.text = event_blend_and_displace_setArray("num_componentX_arr", "blend_and_displace_componentX", arr_displacement_componentModes);
		blend_and_displace_setDisplacement();
	}
	if(clip_name == "txt_disp_mapY"){
		//step through array
		event.currentTarget.text = event_blend_and_displace_setArray("num_componentY_arr", "blend_and_displace_componentY", arr_displacement_componentModes);
		blend_and_displace_setDisplacement();
	}
	//color mode
	if(clip_name == "txt_disp_mode"){
		//step through array
		event.currentTarget.text = event_blend_and_displace_setArray("num_displacementNode_arr", "blend_and_displace_mode", arr_displacement_modes);
		blend_and_displace_setDisplacement();
	}
}

function event_blend_and_displace_loadImage(event:MouseEvent){
	//load the first image
	load_image(clip_importImage, mc_draw.width, mc_draw.height, UI_load_image_displacement_setListeners, UI_load_image_displacement_onSelected, UI_load_impage_displacement_onComplete, true);
}

function event_blend_and_displace_loadAnother(event:MouseEvent){
	//PLACE AND LOAD ANOTHER (RESET LAST ONE)
	//take picture of canvas and commit to main canvas, update undo's
	update_after_draw();
	save_transform_to_canvas(canvasBitmapData);
	//reset and prepare for re-import
	reset_blend_and_displace_image();
	//
	load_image(clip_importImage, mc_draw.width, mc_draw.height, UI_load_image_displacement_setListeners_loadAnother, UI_load_image_displacement_onSelected, UI_load_impage_displacement_onComplete, true);
	//RESET ALL AFTER PLACING
	blend_and_displace_resetAfterPlace();
}

function event_blend_and_displace_save(event:MouseEvent){
	//take picture of canvas and commit to main, update undo's
	update_after_draw();
	save_transform_to_canvas(canvasBitmapData);
	//
	close_blend_and_displace();
}

function event_blend_and_displace_cancel(event:MouseEvent){
	//clear all, make sure main canvas is not updated, place saved bitmapdata on main canvas
	//save_transform_to_canvas(bitmapData_canvasDemo);
	update_canvas_with(bitmapData_canvasDemo);
	//
	close_blend_and_displace();
}

function close_blend_and_displace(){
	//clear and remove all here
	bitmapData_canvasDemo.dispose();
	blend_and_displace_clearFilters();
	//
	reset_imageImportChildren();
	//
	//mc_blend_and_displace.visible = false;
	closeWindow(mc_blend_and_displace);
	//set back to pencil
	set_pencil_tool();
}

function event_blend_and_displace(event:MouseEvent){
	//
	set_tool("BLEND & DISPLACER-izer", btn_blend_and_displace);
	
	//SAVE A VALUE OF THE CANVAS TO THE SAMPLE CANVAS BUT DON'T DRAW, USED ONLY FOR CANCEL
	//MAKE SURE YOU DISPOSE SAVED CANVAS WHEN DONE
	bitmapData_canvasDemo = canvasBitmapData.clone();//new BitmapData(mc_draw.width, mc_draw.height, false, 0x000000);
	
	openWindow(mc_blend_and_displace);
	
	set_imageImportChildren();
	
	//
	mc_blend_and_displace.btn_save.visible = false; //save should only show if there is something to save, triggered after first load
	mc_blend_and_displace.btn_load.visible = true;
	mc_blend_and_displace.btn_load_another.visible = false;
	mc_blend_and_displace.mc_hideUI.visible = true;
	//
	//reset default values (set up)
	blend_and_displace_resetAfterPlace();
}

//////////////

/////////////COLOR FACTORY/////////////

function set_color_factory_inputs(str_window:String, bool_visibility:Boolean = false){
	//
	var i:Number = 0;
	color_factory_window.visible = true;
	//
	color_factory_window.txt_title.text = str_window.toUpperCase() + " SETTINGS";
	//
	//trace("remove all filters here");
	//trace("remove anything applied here");
	color_factory_resetAllFilters();
	color_factory_resetTempBitmaps();
	//
	for (i = 0; i<arr_color_factory_allFields.length; ++i){
		arr_color_factory_allFields[i].visible = false;
	};
	for(i = 0; i<arr_color_factory_colorMatrixInputFields.length; ++i){
		arr_color_factory_colorMatrixInputFields[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_convolution_ARROWS.length; ++i){
		arr_color_factory_convolution_ARROWS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_convolution_INPUTS.length; ++i){
		arr_color_factory_convolution_INPUTS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_RGBshift_ARROWS.length; ++i){
		arr_color_factory_RGBshift_ARROWS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_RGBshift_INPUTS.length; ++i){
		arr_color_factory_RGBshift_INPUTS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_ColorTransform_INPUTS.length; ++i){
		arr_color_factory_ColorTransform_INPUTS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_Shuffle_INPUTS.length; ++i){
		arr_color_factory_Shuffle_INPUTS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_Shuffle_ARROWS.length; ++i){
		arr_color_factory_Shuffle_ARROWS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_PerinTexture_INPUTS.length; ++i){
		arr_color_factory_PerinTexture_INPUTS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_PerlinTexture_BOOLS.length; ++i){
		arr_color_factory_PerlinTexture_BOOLS[i].visible = false;
	}
	for (i = 0; i<arr_color_factory_fuzzyFields.length; ++i){
		arr_color_factory_fuzzyFields[i].visible = false;
	}
	//
	color_factory_window.txt_about.text = "";
	//
	//
	if(str_window == "blur"){
		//allign window
		color_factory_window.y = mc_color_factory.btn_blur.y;
		//
		color_factory_window.txt_blurX.visible = bool_visibility;
		color_factory_window.txt_blurY.visible = bool_visibility;
		color_factory_window.txt_blurX_input.visible = bool_visibility;
		color_factory_window.txt_blurY_input.visible = bool_visibility;
		//
		//start blur
		setBlur(mc_draw, Number(color_factory_window.txt_blurX_input.text), Number(color_factory_window.txt_blurY_input.text));
		//
	};
	//
	if(str_window == "color matrix"){
		//allign window
		color_factory_window.y = mc_color_factory.btn_colormatrix.y;
		//
		for(i = 0; i<arr_color_factory_colorMatrixInputFields.length; ++i){
			arr_color_factory_colorMatrixInputFields[i].visible = bool_visibility;
		}
		//
		color_factory_window.txt_colorMatrix_INSTRUCTIONS.visible = bool_visibility;
		//
		color_factory_window.txt_colorMatrix_RANDOM.visible = bool_visibility;
		color_factory_window.txt_colorMatrix_ALPHA.visible = bool_visibility;
		color_factory_window.txt_colorMatrix_BLUE.visible = bool_visibility;
		color_factory_window.txt_colorMatrix_GREEN.visible = bool_visibility;
		color_factory_window.txt_colorMatrix_RED.visible = bool_visibility;
		//
		//start values
		color_factory_refreshColorMatrix();
	};
	//
	if(str_window == "convolution"){
		//allign window
		color_factory_window.y = mc_color_factory.btn_convolution.y;
		//
		for (i = 0; i<arr_color_factory_convolution_ARROWS.length; ++i){
			arr_color_factory_convolution_ARROWS[i].visible = bool_visibility;
		}
		for (i = 0; i<arr_color_factory_convolution_INPUTS.length; ++i){
			arr_color_factory_convolution_INPUTS[i].visible = bool_visibility;
		}
		color_factory_window.txt_convolution_MATRIX.visible = bool_visibility;
		color_factory_window.txt_convolution_MULTIPLIER.visible = bool_visibility;
		color_factory_window.txt_convolution_RANDOM.visible = bool_visibility;
		//start values
		color_factory_refreshConvolution();
	};
	//
	if(str_window == "rgb shift"){
		//allign window
		color_factory_window.y = mc_color_factory.btn_rbgshift.y;
		//
		for (i = 0; i<arr_color_factory_RGBshift_ARROWS.length; ++i){
			arr_color_factory_RGBshift_ARROWS[i].visible = bool_visibility;
		}
		for (i = 0; i<arr_color_factory_RGBshift_INPUTS.length; ++i){
			arr_color_factory_RGBshift_INPUTS[i].visible = bool_visibility;
		}
		color_factory_window.txt_rgbshift_RED.visible = bool_visibility;
		color_factory_window.txt_rgbshift_GREEN.visible = bool_visibility;
		color_factory_window.txt_rgbshift_BLUE.visible = bool_visibility;
		color_factory_window.txt_rgbshift_RANDOM.visible = bool_visibility;
		color_factory_window.txt_rgbshift_RED_X.visible = bool_visibility;
		color_factory_window.txt_rgbshift_RED_Y.visible = bool_visibility;
		color_factory_window.txt_rgbshift_GREEN_X.visible = bool_visibility;
		color_factory_window.txt_rgbshift_GREEN_Y.visible = bool_visibility;
		color_factory_window.txt_rgbshift_BLUE_X.visible = bool_visibility;
		color_factory_window.txt_rgbshift_BLUE_Y.visible = bool_visibility;
		//start values
		arr_savedBitmaps = [];
		arr_savedBitmaps.push(bitmapData_canvasDemo.clone());
		//
		//
		color_factory_refreshRGBshift();
	}
	//
	if(str_window == "color transform"){
		//allign window
		color_factory_window.y = mc_color_factory.btn_colorTransform.y;
		//
		for (i = 0; i<arr_color_factory_ColorTransform_INPUTS.length; ++i){
			arr_color_factory_ColorTransform_INPUTS[i].visible = bool_visibility;
		}
		color_factory_window.txt_colorTransform_redMultiplier.visible = bool_visibility;
		color_factory_window.txt_colorTransform_redOffset.visible = bool_visibility;
		color_factory_window.txt_colorTransform_greenMultiplier.visible = bool_visibility;
		color_factory_window.txt_colorTransform_greenOffset.visible = bool_visibility;
		color_factory_window.txt_colorTransform_blueMultiplier.visible = bool_visibility;
		color_factory_window.txt_colorTransform_blueOffset.visible = bool_visibility;
		color_factory_window.txt_colorTransform_alphaMultiplier.visible = bool_visibility;
		color_factory_window.txt_colorTransform_alphaOffset.visible = bool_visibility;
		color_factory_window.txt_colorTransform_RANDOM.visible = bool_visibility;
		color_factory_window.txt_colorTransform_instructions.visible = bool_visibility;
		//start
		//
		color_factory_refreshColorTransform();
	}
	//
	if(str_window == "pixel blast"){
		//allign window
		color_factory_window.y = Math.ceil(mc_color_factory.mc_special.y - mc_color_factory.mc_special.height - 50);
		//
		color_factory_window.btn_pixelblast.visible = bool_visibility;
		color_factory_window.txt_pixelblast.visible = bool_visibility;
		//start values
		arr_savedBitmaps = [];
		arr_savedBitmaps.push(bitmapData_canvasDemo.clone());
		//
		//color_factory_refreshPixelBlast();
	}
	//
	if(str_window == "shuffle"){
		//allign window
		color_factory_window.y = Math.ceil(mc_color_factory.mc_special.y - mc_color_factory.mc_special.height - 50);
		//
		for (i = 0; i<arr_color_factory_Shuffle_INPUTS.length; ++i){
			arr_color_factory_Shuffle_INPUTS[i].visible = bool_visibility;
		}
		for (i = 0; i<arr_color_factory_Shuffle_ARROWS.length; ++i){
			arr_color_factory_Shuffle_ARROWS[i].visible = bool_visibility;
		}
		color_factory_window.txt_shuffle_spacing.visible = bool_visibility;
		color_factory_window.txt_shuffle_spacing_x.visible = bool_visibility;
		color_factory_window.txt_shuffle_spacing_y.visible = bool_visibility;
		color_factory_window.txt_shuffle_size.visible = bool_visibility;
		color_factory_window.txt_shuffle_RANDOM.visible = bool_visibility;
		color_factory_window.btn_shuffle.visible = bool_visibility;
		//start values
		arr_savedBitmaps = [];
		arr_savedBitmaps.push(bitmapData_canvasDemo.clone());
		//
		color_factory_refreshShuffle();
	}
	//
	if(str_window == "ascii"){
		//allign window
		color_factory_window.y = Math.ceil(mc_color_factory.mc_special.y - mc_color_factory.mc_special.height - 50);
		//
		color_factory_window.btn_asciiart.visible = bool_visibility;
		color_factory_window.txt_asciiart.visible = bool_visibility;
		//start values
		arr_savedBitmaps = [];
		arr_savedBitmaps.push(bitmapData_canvasDemo.clone());
		//
		//color_factory_refreshASCII();
	}
	//
	if(str_window == "mirror"){
		//allign
		color_factory_window.y = Math.ceil(mc_color_factory.mc_special.y - mc_color_factory.mc_special.height - 50);
		//
		color_factory_window.txt_mirror.visible = bool_visibility;
		color_factory_window.btn_mirror_01.visible = bool_visibility;
		color_factory_window.btn_mirror_02.visible = bool_visibility;
		color_factory_window.btn_mirror_03.visible = bool_visibility;
		color_factory_window.btn_mirror_04.visible = bool_visibility;
		color_factory_window.btn_mirror_05.visible = bool_visibility;
		//start values
		arr_savedBitmaps = [];
		arr_savedBitmaps.push(bitmapData_canvasDemo.clone());
		//
	}
	//
	if(str_window == "perlin texture"){
		//allign
		color_factory_window.y = Math.ceil(mc_color_factory.mc_special.y - mc_color_factory.mc_special.height - 50);
		//
		color_factory_window.txt_perlin_baseX.visible = bool_visibility;
		color_factory_window.txt_perlin_baseY.visible = bool_visibility;
		color_factory_window.txt_perlin_numOctaves.visible = bool_visibility;
		color_factory_window.txt_perlin_randomSeed.visible = bool_visibility;
		color_factory_window.txt_perlin_stitch.visible = bool_visibility;
		color_factory_window.txt_perlin_fractalNoise.visible = bool_visibility;
		color_factory_window.txt_perlin_channelOptions.visible = bool_visibility;
		color_factory_window.txt_perlin_grayScale.visible = bool_visibility;
		color_factory_window.txt_perlin_scale.visible = bool_visibility;
		color_factory_window.txt_perlin_RANDOM.visible = bool_visibility;
		color_factory_window.txt_perlin_tip.visible = bool_visibility;
		//
		color_factory_window.txt_perlin_baseX_INPUT.visible = bool_visibility;
		color_factory_window.txt_perlin_baseY_INPUT.visible = bool_visibility;
		color_factory_window.txt_perlin_numOctavesINPUT.visible = bool_visibility;
		color_factory_window.txt_perlin_randomSeed_INPUT.visible = bool_visibility;
		color_factory_window.txt_perlin_stitch_INPUT.visible = bool_visibility;
		color_factory_window.txt_perlin_fractalNoise_INPUT.visible = bool_visibility;
		color_factory_window.txt_perlin_channelOptions_INPUT.visible = bool_visibility;
		color_factory_window.txt_perlin_grayScale_INPUT.visible = bool_visibility;
		color_factory_window.txt_perlin_scale_INPUT.visible = bool_visibility;
		//start values
		arr_savedBitmaps = [];
		arr_savedBitmaps.push(bitmapData_canvasDemo.clone());
		//
		color_factory_refreshPerlin();
	}
	//
	if(str_window == "fuzzy"){
		//allign
		color_factory_window.y = Math.ceil(mc_color_factory.mc_special.y - mc_color_factory.mc_special.height - 50);
		//
		for (i = 0; i<arr_color_factory_fuzzyFields.length; ++i){
			arr_color_factory_fuzzyFields[i].visible = bool_visibility;
		}
		//
		//start values
		arr_savedBitmaps = [];
		arr_savedBitmaps.push(bitmapData_canvasDemo.clone());
		//
		setupFuzzy(bitmapData_canvasDemo, bitmap_canvasDemo);
	}
};


function event_color_factory_openSettings(event:MouseEvent){
	//
	var clip = event.currentTarget;
	//
	if(clip.name == "btn_blur"){
		set_color_factory_inputs("blur", true);
	};
	if(clip.name == "btn_colormatrix"){
		set_color_factory_inputs("color matrix", true);
	}
	if(clip.name == "btn_convolution"){
		set_color_factory_inputs("convolution", true);
	}
	if(clip.name == "btn_rbgshift"){
		set_color_factory_inputs("rgb shift", true);
	}
	if(clip.name == "btn_colorTransform"){
		set_color_factory_inputs("color transform", true);
	}
	if(clip.name == "btn_pixelblast"){
		set_color_factory_inputs("pixel blast", true);
		mc_color_factory.txt_about.text = "BLAST THOSE PIXELS!";
	}
	if(clip.name == "btn_shuffle"){
		set_color_factory_inputs("shuffle", true);
		mc_color_factory.txt_about.text = "SHAKE AND SHUFFLE!";
	}
	if(clip.name == "btn_ascii"){
		set_color_factory_inputs("ascii", true);
		mc_color_factory.txt_about.text = "INSTANT ASCII ART :D";
	}
	if(clip.name == "btn_mirror"){
		set_color_factory_inputs("mirror", true);
		mc_color_factory.txt_about.text = "KALEIDOSCOPE MODE";
	}
	if(clip.name == "btn_perlin"){
		set_color_factory_inputs("perlin texture", true);
		mc_color_factory.txt_about.text = "PERLIN NOISE IS BEAUTIFUL";
	}
	if(clip.name == "btn_fuzzy"){
		set_color_factory_inputs("fuzzy", true);
		mc_color_factory.txt_about.text = "FOR SOFT ART";
	}
}

function event_color_factory_text_CHANGE(event:Event){
	//update any settings with the changed values here
	var i:Number = 0;
	var clip = event.currentTarget;
	//BLUR
	if(clip.name == "txt_blurX_input" || clip.name == "txt_blurY_input"){
		setBlur(mc_draw, Number(color_factory_window.txt_blurX_input.text), Number(color_factory_window.txt_blurY_input.text));
	};
	//COLOR MATRIX
	for(i = 0; i<arr_color_factory_colorMatrixInputFields.length; ++i){
		if(clip.name == arr_color_factory_colorMatrixInputFields[i].name){
			color_factory_refreshColorMatrix();
		}
	}
	//CONVOLUTION
	for(i = 0; i<arr_color_factory_convolution_INPUTS.length; ++i){
		if(clip.name == arr_color_factory_convolution_INPUTS[i].name){
			color_factory_refreshConvolution();
		}
	}
	//RGB SHIFT
	for(i = 0; i<arr_color_factory_RGBshift_INPUTS.length; ++i){
		if(clip.name == arr_color_factory_RGBshift_INPUTS[i].name){
			color_factory_refreshRGBshift();
		}
	}
	//COLOR TRANSFORM
	for(i = 0; i<arr_color_factory_ColorTransform_INPUTS.length; ++i){
		if(clip.name == arr_color_factory_ColorTransform_INPUTS[i].name){
			color_factory_refreshColorTransform();
		}
	}
	//SHUFFLE (make sure to cap it at 60 for x/y)
	for(i = 0; i<arr_color_factory_Shuffle_INPUTS.length; ++i){
		if(clip.name == arr_color_factory_Shuffle_INPUTS[i].name){
			//
			if(color_factory_window.txt_shuffle_spacing_x_INPUT.text >= 60 || color_factory_window.txt_shuffle_spacing_y_INPUT.text >= 60){
				color_factory_window.txt_shuffle_spacing_x_INPUT.text = "60";
				color_factory_window.txt_shuffle_spacing_y_INPUT.text = "60";
			}
			if(color_factory_window.txt_shuffle_spacing_x_INPUT.text <= 5 || color_factory_window.txt_shuffle_spacing_y_INPUT.text <= 5){
				color_factory_window.txt_shuffle_spacing_x_INPUT.text = "5";
				color_factory_window.txt_shuffle_spacing_y_INPUT.text = "5";
			}
			if(color_factory_window.txt_shuffle_size_rows_INPUT.text >= 46){
				color_factory_window.txt_shuffle_size_rows_INPUT.text = "46";
			}
			if(color_factory_window.txt_shuffle_size_cols_INPUT.text >= 65){
				color_factory_window.txt_shuffle_size_cols_INPUT.text = "65";
			}
			//
			color_factory_refreshShuffle();
		}
	}
	//PERLIN TEXTURE
	//arr_color_factory_PerinTexture_INPUTS
	for (i = 0; i<arr_color_factory_PerinTexture_INPUTS.length; ++i){
		if(clip.name == arr_color_factory_PerinTexture_INPUTS[i].name){
			//
			if(color_factory_window.txt_perlin_numOctavesINPUT.text > 20){
				color_factory_window.txt_perlin_numOctavesINPUT.text = "20";
			}
			color_factory_refreshPerlin();
		}
	}
	//FUZZY
	//maximum value for ALL fields
	for (i = 0; i<arr_color_factory_fuzzy_INPUTS.length; ++i){
		if(clip.name == arr_color_factory_fuzzy_INPUTS[i].name){
			//maximum
			if(arr_color_factory_fuzzy_INPUTS[i].text > 20){
				arr_color_factory_fuzzy_INPUTS[i].text = "20";
			}
			//min
			if(arr_color_factory_fuzzy_INPUTS[i].text < .01){
				arr_color_factory_fuzzy_INPUTS[i].text = ".01";
			}
		}
	}
	//set them
	if(!isNaN(Number(clip.text))){
		//trace("is a number, set");
		if(clip.name == "txt_fuzzy_speed_INPUT"){
			num_fuzzy_scanSpeed = Number(color_factory_window.txt_fuzzy_speed_INPUT.text);
		}
		if(clip.name == "txt_fuzzy_segment_INPUT"){
			num_fuzzy_segment = Number(color_factory_window.txt_fuzzy_segment_INPUT.text);
		}
		if(clip.name == "txt_fuzzy_length_INPUT"){
			num_fuzzy_hairLength = Number(color_factory_window.txt_fuzzy_length_INPUT.text);
		}
		if(clip.name == "txt_fuzzy_fuzziness_INPUT"){
			num_fuzzy_fuzziness = Number(color_factory_window.txt_fuzzy_fuzziness_INPUT.text);
		}
		if(clip.name == "txt_fuzzy_random_INPUT"){
			num_fuzzy_randomHair = Number(color_factory_window.txt_fuzzy_random_INPUT.text);
		}
	}
	//...
};


//toggle for booleans
function event_color_factory_text_TOGGLE(event:MouseEvent){
	//update any settings with the changed values here
	var i:Number = 0;
	var clip = event.currentTarget;
	//
	if(clip.text == "false"){
		clip.text = "true"
	}else if (clip.text == "true"){
		clip.text = "false"
	}
	//perlin texture booleans
	for(i = 0; i<arr_color_factory_PerlinTexture_BOOLS.length; ++i){
		if(clip.name == arr_color_factory_PerlinTexture_BOOLS[i].name){
			//call
			color_factory_refreshPerlin();
		}
	}
	//fuzzy
	if(clip.name == "txt_fuzzy_unruly_INPUT"){
		bool_fuzzy_unrulyHair = !bool_fuzzy_unrulyHair;
		color_factory_window.txt_fuzzy_unruly_INPUT.text = String(bool_fuzzy_unrulyHair);
	}
	if(clip.name == "txt_fuzzy_badhair_INPUT"){
		bool_fuzzy_badHairday = !bool_fuzzy_badHairday;
		color_factory_window.txt_fuzzy_badhair_INPUT.text = String(bool_fuzzy_badHairday);
	}
}

//paging arrows for the color factory
function event_color_factory_ARROWS(event:MouseEvent){
	var btn = event.currentTarget;
	//parse the name of the text field from the button name
	//button and text fields must share the name (replace btn_ and UP from the string)
	//example: button name is btn_convolution_matrix_01_UP and the text field is txt_convolution_matrix_01 after parsing
	var str_name:String = btn.name;
	str_name = str_name.replace("btn_", "txt_");
	str_name = str_name.replace("_UP", "");
	str_name = str_name.replace("_DOWN", "");
	//value (number) of text field
	var num_input:Number = Number(color_factory_window[str_name].text);
	//make sure it's not NaN
	//if NaN set to 1
	if(isNaN(num_input)){
		num_input = 1;
		color_factory_window[str_name].text = 1;
	}
	//increment or decrement the value of the text field
	if(btn.name.indexOf("_DOWN") > -1 ){
		color_factory_window[str_name].text = String(num_input - 1);
	}else{
		color_factory_window[str_name].text = String(num_input + 1);
	}
	//APPLY FILTERS
	//call function here (depending on the button name call the appropriate filter)
	if(btn.name.indexOf("convolution") > -1){
		color_factory_refreshConvolution();
	}
	if(btn.name.indexOf("rgbshift") > -1){
		//
		color_factory_refreshRGBshift();
	}
}

function event_color_factory_ARROWS_SHUFFLE(event:MouseEvent){
	//shuffle event up/down
	//num_color_factory_shuffle_ARROWS  arr_color_factory_shuffle_valsWH[][]
	var btn = event.currentTarget;
	//
	if(btn.name == "txt_shuffle_size_INPUT_UP"){
		num_color_factory_shuffle_ARROWS += 1;
		if(num_color_factory_shuffle_ARROWS >= arr_color_factory_shuffle_valsWH.length-1){
			num_color_factory_shuffle_ARROWS = 0;
		}
	}
	if(btn.name == "txt_shuffle_size_INPUT_DOWN"){
		num_color_factory_shuffle_ARROWS -= 1;
		if(num_color_factory_shuffle_ARROWS <= 0){
			num_color_factory_shuffle_ARROWS = arr_color_factory_shuffle_valsWH.length-1;
		}
	}
	//SET HERE
	color_factory_window.txt_shuffle_size_rows_INPUT.text = arr_color_factory_shuffle_valsWH[num_color_factory_shuffle_ARROWS][0];
	color_factory_window.txt_shuffle_size_cols_INPUT.text = arr_color_factory_shuffle_valsWH[num_color_factory_shuffle_ARROWS][1];
	//
	//color_factory_refreshShuffle();
};

function event_color_factory_ARROWS_SHUFFLEXY(event:MouseEvent){
	//
	var btn = event.currentTarget;
	var num:Number = Number(color_factory_window.txt_shuffle_spacing_x_INPUT.text);
	//
	if(isNaN(num)){
		num = 10;
	}
	//
	if(num >= 60){
		num = 60;
	}
	if(num <= 5){
		num = 5;
	}
	//
	if(btn.name == "txt_shuffle_spacing_INPUT_UP"){
		//
		num += 1;
		//
		color_factory_window.txt_shuffle_spacing_x_INPUT.text = String(num);
		color_factory_window.txt_shuffle_spacing_y_INPUT.text = String(num);
	}
	if(btn.name == "txt_shuffle_spacing_INPUT_DOWN"){
		//
		num -= 1;
		//
		color_factory_window.txt_shuffle_spacing_x_INPUT.text = String(num);
		color_factory_window.txt_shuffle_spacing_y_INPUT.text = String(num);
	}
};


//populate the color matrix fields with random values
function color_factory_colormatrix_setRandom(){
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_01, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_02, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_03, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_04, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_05, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_01, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_02, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_03, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_04, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_05, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_01, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_02, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_03, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_04, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_05, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_01, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_02, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_03, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_04, Math_randomRange(-1, 1));
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_05, Math_randomRange(-1, 1));
}

function color_factory_colormatrix_setSingle(num_r:Number = 0, num_g:Number = 0, num_b:Number = 0){
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_01, num_r);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_02, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_03, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_04, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_RED_05, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_01, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_02, num_g);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_03, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_04, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_GREEN_05, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_01, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_02, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_03, num_b);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_04, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_BLUE_05, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_01, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_02, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_03, 0);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_04, 1);
	setup_numberNegative_txt(color_factory_window.txt_colorMatrix_ALPHA_05, 0);
	//set
	//color_factory_refreshColorMatrix();
}

function color_factory_convolution_setFields(numMult:Number = 0, n1:Number = -2, n2:Number = -1, n3:Number = 0, n4:Number = -9, n5:Number = 1, n6:Number = 5, n7:Number = 0, n8:Number = 1, n9:Number = 5){
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_01, n1);
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_02, n2);
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_03, n3);
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_04, n4);
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_05, n5);
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_06, n6);
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_07, n7);
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_08, n8);
	setup_numberNegative_txt(color_factory_window.txt_convolution_matrix_09, n9);
	setup_numberNegative_txt(color_factory_window.txt_convolution_multiplyer_01, numMult);
}

function event_color_factory_convolution_RANDOM(event:MouseEvent){
	//random presets
	//var filt_extreme:Array = new Array(1, 0, 20, 0, 20, -80, 20, 0, 20, 0);
	color_factory_convolution_setFields(Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80));
	color_factory_refreshConvolution();
};

function color_factory_RGBshift_setFields(numRX:Number = 5, numRY:Number = 0, numGX:Number = 10, numGY:Number = 0, numBX:Number = 15, numBY:Number = 0){
	//
	setup_numberNegative_txt(color_factory_window.txt_rgbshift_RED_X_INPUT, numRX);
	setup_numberNegative_txt(color_factory_window.txt_rgbshift_RED_Y_INPUT, numRY);
	setup_numberNegative_txt(color_factory_window.txt_rgbshift_GREEN_X_INPUT, numGX);
	setup_numberNegative_txt(color_factory_window.txt_rgbshift_GREEN_Y_INPUT, numGY);
	setup_numberNegative_txt(color_factory_window.txt_rgbshift_BLUE_X_INPUT, numBX);
	setup_numberNegative_txt(color_factory_window.txt_rgbshift_BLUE_Y_INPUT, numBY);	
	//
};

function event_color_factory_RGBshift_RANDOM(event:MouseEvent){
	//
	color_factory_RGBshift_setFields(Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80), Math_randomRange(-80, 80));
	color_factory_refreshRGBshift();
	
};

function color_factory_colorTransform_setFields(rMult:Number = .5, rOff:Number = 1, gMult:Number = 2, gOff:Number = 1, bMult:Number = 10, bOff:Number = 10, alphMult:Number = 1, alphOff:Number = 0){
	//trace("color_factory_colorTransform_setFields: " + rMult);
	setup_numberNegative_txt(color_factory_window.txt_colorTransform_redMultiplier_INPUT, rMult);
	setup_numberNegative_txt(color_factory_window.txt_colorTransform_redOffset_INPUT, rOff);
	setup_numberNegative_txt(color_factory_window.txt_colorTransform_greenMultiplier_INPUT, gMult);
	setup_numberNegative_txt(color_factory_window.txt_colorTransform_greenOffset_INPUT, gOff);
	setup_numberNegative_txt(color_factory_window.txt_colorTransform_blueMultiplier_INPUT, bMult);
	setup_numberNegative_txt(color_factory_window.txt_colorTransform_blueOffset_INPUT, bOff);
	setup_numberNegative_txt(color_factory_window.txt_colorTransform_alphaMultiplier_INPUT, alphMult);
	setup_numberNegative_txt(color_factory_window.txt_colorTransform_alphaOffset_INPUT, alphOff);
};

function event_color_factory_colorTransform_RANDOM(event:MouseEvent){
	color_factory_colorTransform_setFields(Math_randomRange(-1, 1), Math_randomRange(-255, 255), Math_randomRange(-1, 1), Math_randomRange(-255, 255), Math_randomRange(-1, 1), Math_randomRange(-255, 255), 1, 0);
	color_factory_refreshColorTransform();
};


function color_factory_shuffle_setFields(xNum:Number = 10, yNum:Number = 10, wNum:Number = 46, hNum:Number = 65){
	setup_numberNegative_txt(color_factory_window.txt_shuffle_spacing_x_INPUT, xNum);
	setup_numberNegative_txt(color_factory_window.txt_shuffle_spacing_y_INPUT, yNum);
	setup_numberNegative_txt(color_factory_window.txt_shuffle_size_rows_INPUT, wNum);
	setup_numberNegative_txt(color_factory_window.txt_shuffle_size_cols_INPUT, hNum);
}

function color_factory_PerlinTexture_setFields(numScale:Number = 1, baseX:Number = 5, baseY:Number = 5, numOctaves:Number = 2, randomSeed:Number = 1, stitch:Boolean = false, fractalNoise:Boolean = false, channelOptions:Number = 7, grayscale:Boolean = false, scale:Number = 1){
	setup_numberDecimal_txt(color_factory_window.txt_perlin_scale_INPUT, numScale);
	setup_numberDecimal_txt(color_factory_window.txt_perlin_baseX_INPUT, baseX);
	setup_numberDecimal_txt(color_factory_window.txt_perlin_baseY_INPUT, baseY);
	setup_numberDecimal_txt(color_factory_window.txt_perlin_numOctavesINPUT, numOctaves);
	setup_numberDecimal_txt(color_factory_window.txt_perlin_randomSeed_INPUT, randomSeed);
	setup_numberDecimal_txt(color_factory_window.txt_perlin_channelOptions_INPUT, channelOptions);
	setup_numberDecimal_txt(color_factory_window.txt_perlin_scale_INPUT, scale);
	//
	color_factory_window.txt_perlin_stitch_INPUT.text = String(stitch);
	color_factory_window.txt_perlin_fractalNoise_INPUT.text = String(fractalNoise);
	color_factory_window.txt_perlin_grayScale_INPUT.text = String(grayscale);
}

function color_factory_fuzzy_setFields(scanSpeed:Number = 1, segment:Number = 10, fuzziness:Number = .01, _length:Number = 5, random:Number = 20, unruly:Boolean = true, badhair:Boolean = false){
	//reset all vals
	num_fuzzy_scanSpeed = scanSpeed;
	num_fuzzy_segment = segment;
	num_fuzzy_fuzziness = fuzziness;
	num_fuzzy_hairLength = _length;
	num_fuzzy_randomHair = random;
	bool_fuzzy_unrulyHair = unruly;
	bool_fuzzy_badHairday = badhair;
	//setup
	setup_numberDecimal_txt(color_factory_window.txt_fuzzy_speed_INPUT, num_fuzzy_scanSpeed);
	setup_numberDecimal_txt(color_factory_window.txt_fuzzy_segment_INPUT, num_fuzzy_segment);
	setup_numberDecimal_txt(color_factory_window.txt_fuzzy_fuzziness_INPUT, num_fuzzy_fuzziness);
	setup_numberDecimal_txt(color_factory_window.txt_fuzzy_length_INPUT, num_fuzzy_hairLength);
	setup_numberDecimal_txt(color_factory_window.txt_fuzzy_random_INPUT, num_fuzzy_randomHair);
	//bools
	color_factory_window.txt_fuzzy_unruly_INPUT.text = String(unruly);
	color_factory_window.txt_fuzzy_badhair_INPUT.text = String(badhair);
}

function event_color_factory_PerlinTexture_RANDOM(event:MouseEvent){
	//generate random
	var numScale:Number = Math_randomRange_dec(0.01, 1);
	var baseX:Number = Math_randomRange(1, 50);
	var baseY:Number = Math_randomRange(1, 50);
	var numOctaves:Number = Math_randomRange(1, 20);
	var randomSeed:Number = Math_randomRange(1, 10)
	var stitch:Boolean = Math_randomRange(-1, 1);
	var fractalNoise:Boolean = Math_randomRange(-1, 1);
	var channelOptions:Number = Math_randomRange(1, 50);
	var grayscale:Boolean = Math_randomRange(-1, 1);
	//
	color_factory_PerlinTexture_setFields(numScale, baseX, baseY, numOctaves, randomSeed, stitch, fractalNoise, channelOptions, grayscale);
	//
	color_factory_refreshPerlin();
}

function event_color_factory_fuzzy_RESET(event:MouseEvent){
	//was random is reset now
	color_factory_fuzzy_setFields();
}


function event_color_factory_SHUFFLE(event:MouseEvent){
	color_factory_refreshShuffle();
}

function event_color_factory_RANDOM(event:MouseEvent){
	//
	var randElement:Number = Math.ceil(Math.random()*arr_color_factory_shuffle_valsWH.length)-1;
	var randW:Number = arr_color_factory_shuffle_valsWH[randElement][0];
	var randH:Number = arr_color_factory_shuffle_valsWH[randElement][1];
	//
	var randX:Number = Math_randomRange(5, 60);
	var randY:Number = randX;
	//
	setup_numberNegative_txt(color_factory_window.txt_shuffle_spacing_x_INPUT, randX);
	setup_numberNegative_txt(color_factory_window.txt_shuffle_spacing_y_INPUT, randY);
	setup_numberNegative_txt(color_factory_window.txt_shuffle_size_rows_INPUT, randW);
	setup_numberNegative_txt(color_factory_window.txt_shuffle_size_cols_INPUT, randH);
	//
	color_factory_refreshShuffle();
};

//single RGB color
function event_color_factory_colormatrix_SINGLE(event:MouseEvent){
	var clip = event.currentTarget;
	//
	if(clip.name == "txt_colorMatrix_RED"){
		color_factory_colormatrix_setSingle(1);
	}
	if(clip.name == "txt_colorMatrix_GREEN"){
		color_factory_colormatrix_setSingle(0, 1);
	}
	if(clip.name == "txt_colorMatrix_BLUE"){
		color_factory_colormatrix_setSingle(0, 0, 1);
	}
	//call
	color_factory_refreshColorMatrix();
}

function event_color_factory_colormatrix_RANDOM(event:MouseEvent){
	//the GENERATE RANDOM button
	color_factory_colormatrix_setRandom();
	color_factory_refreshColorMatrix();
}

//the small about dialogue in the settings window
function event_color_factory_about(event:MouseEvent){

	write_words(arr_dialogue_colors[num_color_factory_dialogue], mc_color_factory.mc_settings.txt_about);
	//arr_dialogue_colors
	
	//loop around
	num_color_factory_dialogue += 1;
	if(num_color_factory_dialogue > arr_dialogue_colors.length - 1){
		num_color_factory_dialogue = 0;
	}
}

function event_color_factory_blur(event:MouseEvent){
	//open blur window and prepare text fields
	set_color_factory_inputs("blur", true);
}

//SPECIAL WINDOW EVENTS
//blast pixels
function event_color_factory_blastpixels(event:MouseEvent){
	color_factory_refreshPixelBlast();
}

//start ascii
function event_color_factory_ASCII(event:MouseEvent){
	color_factory_refreshASCII();
	//
	color_factory_window.btn_asciiart_save.visible = true;
	color_factory_window.btn_asciiart_clipboard.visible = true;
}

function event_color_factory_ASCII_SAVE(event:MouseEvent){
	//
	saveAsciiToTextFile(str_colorfactory_ascii, "MY_COOL_ASCII_ART");
}

function event_color_factory_ASCII_CLIPBOARD(event:MouseEvent){
	saveAsciiToClipboard(str_colorfactory_ascii);
}



//mirror mode (kaleidoscope)
function event_color_factory_MIRROR_DOWN(event:MouseEvent){
	//
	var clip = event.currentTarget;
	//
	bool_isMouseDown = true;
	//
	if(clip.name == "btn_mirror_01"){
		str_color_factory_MIRROR_TYPE = "0";
	}
	if(clip.name == "btn_mirror_02"){
		str_color_factory_MIRROR_TYPE = "1";
	}
	if(clip.name == "btn_mirror_03"){
		str_color_factory_MIRROR_TYPE = "2";
	}
	if(clip.name == "btn_mirror_04"){
		str_color_factory_MIRROR_TYPE = "3";
	}
	if(clip.name == "btn_mirror_05"){
		str_color_factory_MIRROR_TYPE = "RANDOM";
	};
	//
	stage.addEventListener(Event.ENTER_FRAME, event_color_factory_MIRROR_EVENT);
}
//
function event_color_factory_MIRROR_UP(event:MouseEvent){
	bool_isMouseDown = false;
	stage.addEventListener(Event.ENTER_FRAME, event_color_factory_MIRROR_EVENT);
}
//continuously run the mirror mode on mouse down
function event_color_factory_MIRROR_EVENT(event:Event){
	if(bool_isMouseDown){
		color_factory_refreshMirror(str_color_factory_MIRROR_TYPE);
	}else{
		//if mouse is up remove
		stage.removeEventListener(Event.ENTER_FRAME, event_color_factory_MIRROR_EVENT);
	}
}
//fuzzy mode
function event_color_factory_FUZZY_DOWN(event:MouseEvent){
	bool_isMouseDown = true;
	stage.addEventListener(Event.ENTER_FRAME, event_color_factory_FUZZY_EVENT);
}
function event_color_factory_FUZZY_UP(event:MouseEvent){
	bool_isMouseDown = false;
	stage.removeEventListener(Event.ENTER_FRAME, event_color_factory_FUZZY_EVENT);
}
//refresh continuously
function event_color_factory_FUZZY_EVENT(event:Event){
	//remove listener if mouse is up
	if(bool_isMouseDown){
		color_factory_refreshFuzzy();
	}else{
		stage.removeEventListener(Event.ENTER_FRAME, event_color_factory_FUZZY_EVENT);
	}
}
function event_color_factory_FUZZY_RESETSCAN(event:MouseEvent){
	resetFuzzy(bitmapData_canvasDemo, bitmap_canvasDemo);
}
//

function event_color_factory_SETTINGS_APPLY(event:MouseEvent){
	//apply current window settings
	//update_bitmaps_from(bitmapToDrawFrom:BitmapData, targetBitmapData:BitmapData, targetBitmap:Bitmap)
	
	save_transform_to_canvas(bitmapData_canvasDemo, true);
		
	color_factory_resetAllFilters(true);
	
	event.currentTarget.parent.visible = false;
}

function event_color_factory_SETTINGS_CANCEL(event:MouseEvent){
	//cancel current window settings

	color_factory_resetTempBitmaps();
	
	color_factory_resetAllFilters();
		
	event.currentTarget.parent.visible = false;
}

function color_factory_close(){
	//
	set_pencil_tool();
	//
	closeWindow(mc_color_factory);
	//
	clear_canvasDemo();
	color_factory_resetAllFilters(true);
	
}

function event_color_factory_RESET(event:MouseEvent){
	//
	color_factory_window.visible = false;
	
	//clear first
	color_factory_resetTempBitmaps();
	color_factory_resetAllFilters(true);
	
	//then set canvas
	clear_canvasDemo();
	create_canvasDemo();
}

function event_color_factory_ACCEPT(event:MouseEvent){
	//update undos and apply new
	update_after_draw();
	save_transform_to_canvas(canvasBitmapData, true);
	//
	color_factory_close();
}

function event_color_factory_CANCEL(event:MouseEvent){
	color_factory_close();
}

function event_color_factory(event:MouseEvent){
	//
	//
	set_tool("COLOR FACTORY", btn_color_factory);
	color_factory_resetAllFilters();
	
	openWindow(mc_color_factory);
	color_factory_window.visible = false;
	
	//set demo canvas
	create_canvasDemo();
	
	//set up text fields
	setup_numberDecimal_txt(color_factory_window.txt_blurX_input, 5);
	setup_numberDecimal_txt(color_factory_window.txt_blurY_input, 5);
	//bulk setups for text fields (called multiple times)
	color_factory_colormatrix_setRandom();
	color_factory_convolution_setFields();
	color_factory_RGBshift_setFields();
	color_factory_colorTransform_setFields();
	color_factory_shuffle_setFields();
	color_factory_PerlinTexture_setFields();
	color_factory_fuzzy_setFields();
	//
};

//////////////

////////////BITMAP AS LINESTYLE////////////

function event_loadImagePenTexture(event:MouseEvent){
	set_tool("TEXTURE PEN", btn_loadTexture);
	//mc_slider.visible = true; //set after image is loaded
	load_penTexture();
};

//chose the thumbnail if it's visible and a texture is loaded
function event_setImagePenTexture(event:MouseEvent){
	set_tool("TEXTURE PEN", btn_loadTexture);
	//mc_slider.visible = true;
	show_scrubber();
}

//////////////

////////////SAVE INDIVIDUAL PANEL////////////

//not referenced in keyboard shortcuts
function _save_panel(){
	save_bitmapdata_PNG(canvasBitmapData, "myPanel");
	//saveBitmapToClipboard(canvasBitmapData);//also copy to clipboard
}

function event_save_panel(event:MouseEvent){
	_save_panel();
};

//////////////

/////////////KEYBOARD SHORTCUTS//////////////


/////////////MISC//////////////

//CLOSE

function _quit(){
	//stop anyting playing
	snd_chan.stop();
	//
	try{
		stage_parent.event_closeDrawingWindow();
	}catch(e:Error){
		trace("event_quit: " + e);
	}
}

function event_quit(event:MouseEvent){
	//
	_quit();
};

//MISC UI

function event_hideThis(event:MouseEvent){
	event.currentTarget.visible = false;
};

//play animation on UI rollover
function event_playOnOver(event:MouseEvent){
	var clip = event.currentTarget;
	clip.play();
};

function event_stopOnOut(event:MouseEvent){
	var clip = event.currentTarget;
	clip.stop();
};


//////////////