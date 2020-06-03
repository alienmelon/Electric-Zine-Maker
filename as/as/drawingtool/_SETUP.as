/*
all events, listeners, and setup
init the drawing ui / start...
*/

//NOTES

//straight lines
//randomink pen
//>> glitch ink

//

//SETUP

for(var i:Number = 0; i<arr_menu_randFrames.length; ++i){
	//
	var clip = arr_menu_randFrames[i];
	//
	clip.gotoAndStop(Math.ceil(Math.random()*clip.totalFrames)-1);
	//
	clip.addEventListener(MouseEvent.MOUSE_OVER, event_playOnOver);
	clip.addEventListener(MouseEvent.MOUSE_OUT, event_stopOnOut);
	//
};

//EVENTS

// add children. Canvas must be below sprite
mc_draw.addChild(canvasBitmap);
mc_draw.addChild(penSprite);
mc_imageTexture.mc_imageTexture.addChild(penTextureBitmap);

penSprite.graphics.lineStyle(num_pen_size, pen_color, pen_alpha);

//set up alpha and listener for scrubber alpha field
setup_numberDecimal_txt(mc_slider.txt_alpha, pen_alpha);
mc_slider.txt_alpha.text = "100";//cosmetic (so it's not 1)
mc_slider.txt_alpha.addEventListener(Event.CHANGE, event_scrubber_alpha_CHANGE);

//
set_pencil_tool();
mc_imageTexture.visible = false;

mc_authentic.visible = false;
mc_smooshzone.visible = false;

visible_patternSprayUI(false);
visible_TextUI(false);
visible_imageUI(false);

//manage the sub-tools tool area (visibility on first run)
subtool_hideAll();
subtool_visibility(0, true);

// listen to stage, not to the root or you won't get mouse down events root sprite is empty.
mc_draw.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
mc_draw.addEventListener(MouseEvent.RELEASE_OUTSIDE, mouseUp);

//left/right tool pannel (sub tools)
btn_subtools_previous.addEventListener(MouseEvent.MOUSE_UP, event_subtools_previous);
btn_subtools_next.addEventListener(MouseEvent.MOUSE_UP, event_subtools_next);
//FESTIVAL BUILD (comment out)
//btn_subtools_previous.visible = false;
//btn_subtools_next.visible = false;
//

btn_undo.addEventListener(MouseEvent.MOUSE_DOWN, event_undo);
btn_redo.addEventListener(MouseEvent.MOUSE_UP, event_redo);
btn_clear.addEventListener(MouseEvent.MOUSE_DOWN, event_clear_all);

btn_text.addEventListener(MouseEvent.MOUSE_UP, event_text);

btn_save.addEventListener(MouseEvent.MOUSE_UP, event_quit);

//tool listeners
btn_pen.addEventListener(MouseEvent.MOUSE_UP, event_pencil);
btn_erase.addEventListener(MouseEvent.MOUSE_UP, event_erase);
btn_eyedropper.addEventListener(MouseEvent.MOUSE_UP, event_setEyedropper);
btn_colorfill.addEventListener(MouseEvent.MOUSE_UP, event_colorFill);
btn_spray.addEventListener(MouseEvent.MOUSE_UP, event_spray);

//save just the one panel
btn_exportPanel.addEventListener(MouseEvent.MOUSE_UP, event_save_panel);

//color
mc_colorPicker.mc_spectrum.addEventListener(MouseEvent.MOUSE_MOVE, event_updateColorPicker);
mc_colorPicker.mc_spectrum.addEventListener(MouseEvent.MOUSE_OUT, event_end_ColorPicker);
mc_colorPicker.mc_spectrum.addEventListener(MouseEvent.MOUSE_UP, event_setColor);
//
btn_color_setblack.addEventListener(MouseEvent.MOUSE_OUT, event_end_ColorPicker);
btn_color_setwhite.addEventListener(MouseEvent.MOUSE_OUT, event_end_ColorPicker);
btn_color_setblack.addEventListener(MouseEvent.MOUSE_OVER, event_overColorBlack);
btn_color_setwhite.addEventListener(MouseEvent.MOUSE_OVER, event_overColorWhite);
btn_color_setblack.addEventListener(MouseEvent.MOUSE_UP, event_setColorBlack);
btn_color_setwhite.addEventListener(MouseEvent.MOUSE_UP, event_setColorWhite);
//
btn_grayscale.addEventListener(MouseEvent.MOUSE_UP, event_colorPicker_GRAYSCALE);
btn_color.addEventListener(MouseEvent.MOUSE_UP, event_colorPicker_COLOR);

//setup tool size scrubber
init_scrubber(mc_slider, num_minVal, "scrubber_tool");
//scrubber listeners for tool slize
mc_slider.mc_knob.addEventListener(MouseEvent.MOUSE_DOWN, event_scrubber_DOWN);
mc_slider.mc_knob.addEventListener(MouseEvent.MOUSE_UP, event_scrubber_UP);
stage.addEventListener(MouseEvent.MOUSE_UP, event_scrubber_UP);
stage.addEventListener(MouseEvent.MOUSE_MOVE, event_scrubber_MOVE);

//setup smudge tool
init_smudge();
btn_smudge.addEventListener(MouseEvent.MOUSE_UP, event_smudge);

//setup pattern spray
btn_patternspray.addEventListener(MouseEvent.MOUSE_UP, event_open_patternSpray);
btn_patternspray_back.addEventListener(MouseEvent.MOUSE_UP, event_close_patternSpray);
//
mc_draw_spray.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_sprayPattern);
mc_draw_spray.addEventListener(MouseEvent.RELEASE_OUTSIDE, mouseUp_sprayPattern);
btn_patternspray_rotation.addEventListener(MouseEvent.MOUSE_UP, event_sprayPattern_setRotation);
btn_patternspray_size.addEventListener(MouseEvent.MOUSE_UP, event_sprayPattern_setSize);
btn_patternspray_clear.addEventListener(MouseEvent.MOUSE_UP, event_clear_sprayPatternCanvas);
btn_patternspray_image.addEventListener(MouseEvent.MOUSE_UP, event_sprayPattern_loadImage);
set_sprayPattern_UI(btn_patternspray_rotation, bool_sprayPattern_rotation);
set_sprayPattern_UI(btn_patternspray_size, bool_sprayPattern_size);
mc_patternspray_about.addEventListener(MouseEvent.MOUSE_UP, event_hideThis);

//TEXTURE PEN
btn_loadTexture.addEventListener(MouseEvent.MOUSE_UP, event_loadImagePenTexture);
mc_imageTexture.addEventListener(MouseEvent.MOUSE_UP, event_setImagePenTexture);
mc_imageTexture.buttonMode = true;
//////////////////////////////////////////////////////////////////

//TEXT LISTENERS
btn_text.addEventListener(MouseEvent.MOUSE_UP, event_text);
btn_textTool_DONE.addEventListener(MouseEvent.MOUSE_UP, event_text_done);
btn_textTool_CANCEL.addEventListener(MouseEvent.MOUSE_UP, event_text_cancel);
//text field
txt_textTool_input.addEventListener(Event.CHANGE, event_input_ONCHANGE);
txt_textTool_input.addEventListener(FocusEvent.FOCUS_IN, event_input_FOCUSIN);
btn_textTool_input_UP.addEventListener(MouseEvent.MOUSE_UP, event_input_scroll);
btn_textTool_input_DOWN.addEventListener(MouseEvent.MOUSE_UP, event_input_scroll);
//hide about window on click so you can edit color
mc_textTool_about.addEventListener(MouseEvent.MOUSE_UP, event_hideThis);
//allignment
btn_textTool_left.addEventListener(MouseEvent.MOUSE_UP, event_setAllign);
btn_textTool_right.addEventListener(MouseEvent.MOUSE_UP, event_setAllign);
btn_textTool_center.addEventListener(MouseEvent.MOUSE_UP, event_setAllign);
//sizes
txt_textTool_size.addEventListener(Event.CHANGE, event_fontsize_ONCHANGE);
txt_textTool_width.addEventListener(Event.CHANGE, event_fontwidth_ONCHANGE);
txt_textTool_rotation.addEventListener(Event.CHANGE, event_fontrotation_ONCHANGE);
//selecting a font from the list
txt_font_01.addEventListener(MouseEvent.MOUSE_UP, event_setFont);
txt_font_02.addEventListener(MouseEvent.MOUSE_UP, event_setFont);
txt_font_03.addEventListener(MouseEvent.MOUSE_UP, event_setFont);
txt_font_04.addEventListener(MouseEvent.MOUSE_UP, event_setFont);
txt_font_05.addEventListener(MouseEvent.MOUSE_UP, event_setFont);
txt_font_06.addEventListener(MouseEvent.MOUSE_UP, event_setFont);
txt_font_07.addEventListener(MouseEvent.MOUSE_UP, event_setFont);
//scroll through fonts (up or down)
btn_textTool_fonts_UP.addEventListener(MouseEvent.MOUSE_UP, event_prevFontList);
btn_textTool_fonts_DOWN.addEventListener(MouseEvent.MOUSE_UP, event_nextFontList);
//repositioning the text
canvas_textField_container.addEventListener(MouseEvent.MOUSE_DOWN, event_canvasText_startDrag);
canvas_textField_container.addEventListener(MouseEvent.MOUSE_UP, event_canvasText_startDrag);
//update font list on first run
updateFontList();
//////////////////////////////////////////////////////////////////

//IMPORT IMAGE
btn_importimage.addEventListener(MouseEvent.MOUSE_UP, event_image);
btn_image_DONE.addEventListener(MouseEvent.MOUSE_UP, event_image_DONE);
btn_image_CANCEL.addEventListener(MouseEvent.MOUSE_UP, event_image_CANCEL);
mc_importimage_about.addEventListener(MouseEvent.MOUSE_UP, event_hideThis);
//
btn_importimage_import02.addEventListener(MouseEvent.MOUSE_UP, event_import_fill);
btn_importimage_import01.addEventListener(MouseEvent.MOUSE_UP, event_import_small);
btn_importAnother.addEventListener(MouseEvent.MOUSE_UP, event_import_another);
//
btn_importimage_width.addEventListener(MouseEvent.MOUSE_UP, event_image_fullWidth);
btn_importimage_height.addEventListener(MouseEvent.MOUSE_UP, event_image_fullHeight);
btn_importimage_center.addEventListener(MouseEvent.MOUSE_UP, event_image_allign);
btn_importimage_topleft.addEventListener(MouseEvent.MOUSE_UP, event_image_allign);
btn_importimage_topright.addEventListener(MouseEvent.MOUSE_UP, event_image_allign);
btn_importimage_bottomleft.addEventListener(MouseEvent.MOUSE_UP, event_image_allign);
btn_importimage_bottomright.addEventListener(MouseEvent.MOUSE_UP, event_image_allign);
//////////////////////////////////////////////////////////////////

//AUTHENTICITY FILTER EVENTS
mc_authentic.btn_accept.addEventListener(MouseEvent.MOUSE_UP, event_accept_authentic);
mc_authentic.btn_cancel.addEventListener(MouseEvent.MOUSE_UP, event_cancel_authentic);
btn_authentic.addEventListener(MouseEvent.MOUSE_UP, event_open_authentic);
//text field changes
mc_authentic.txt_reduceColor_num.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_pixelart_num.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_hafltones_brushsize.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_hafltones_sample.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_badhalftone_color.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_badhalftone_num2.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_badhalftone_num1.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_floyd_num.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_dither_num.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_stucki_num.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
mc_authentic.txt_desaturate_num.addEventListener(Event.CHANGE, event_authentic_txt_CHANGE);
//grayscale changes
mc_authentic.txt_reduceColor_grayscale.addEventListener(MouseEvent.MOUSE_UP, event_authentic_grayscale);
mc_authentic.txt_badhalftone_invert.addEventListener(MouseEvent.MOUSE_UP, event_authentic_grayscale);
mc_authentic.txt_badhalftone_grayscale.addEventListener(MouseEvent.MOUSE_UP, event_authentic_grayscale);
mc_authentic.txt_floyd_grayscale.addEventListener(MouseEvent.MOUSE_UP, event_authentic_grayscale);
mc_authentic.txt_dither_grayscale.addEventListener(MouseEvent.MOUSE_UP, event_authentic_grayscale);
mc_authentic.txt_stucki_grayscale.addEventListener(MouseEvent.MOUSE_UP, event_authentic_grayscale);
//enable effect
mc_authentic.txt_creature.addEventListener(MouseEvent.MOUSE_UP, customInk_event_TOOLTIP);//invisible creature
mc_authentic.btn_monochrome.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_desaturate.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_floyd.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_dither.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_stucki.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_badhalftones.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_goodhalftones.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_sketch.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_grayscale.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_pixelart.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_reducecolor.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_cga.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_ega.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_ham.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_vga.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
mc_authentic.btn_svga.addEventListener(MouseEvent.MOUSE_UP, event_authentic_setEffect);
//////////////////////////////////////////////////////////////////

//SMOOSHER
setup_authentic_num_inputText(mc_smooshzone.txt_smoosh_intensity, smoosher_displacementAmount);
setup_authentic_num_inputText(mc_smooshzone.txt_smoosh_size, num_smoosher_brushSize);
setup_authentic_num_inputText(mc_smooshzone.txt_smoosh_smoothness, smoosher_blurAmount);
//
btn_smoosher.addEventListener(MouseEvent.MOUSE_UP, event_smoosher);
//
mc_smooshzone.btn_smoosher_default.addEventListener(MouseEvent.MOUSE_UP, event_reset_smoosherSettings);
mc_smooshzone.txt_smoosh_bool.addEventListener(MouseEvent.MOUSE_UP, event_smoosher_toggleSmooth);
mc_smooshzone.btn_smoosh_accept.addEventListener(MouseEvent.MOUSE_UP, event_saveSmoosh);
mc_smooshzone.btn_smoosh_cancel.addEventListener(MouseEvent.MOUSE_UP, event_cancelSmooshes);
mc_smooshzone.btn_smoosher_restart.addEventListener(MouseEvent.MOUSE_UP, event_resetSmooshes);
//
mc_smooshzone.btn_smoosh_run.addEventListener(MouseEvent.MOUSE_UP, event_smoosher_run_UP);
mc_smooshzone.btn_smoosh_run.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_smoosher_run_UP);
mc_smooshzone.btn_smoosh_run.addEventListener(MouseEvent.MOUSE_OUT, event_smoosher_run_UP);
mc_smooshzone.btn_smoosh_run.addEventListener(MouseEvent.MOUSE_DOWN, event_smoosher_run_DOWN);
//
mc_smooshzone.txt_smoosh_intensity.addEventListener(Event.CHANGE, event_smoosher_numberUpdate);
mc_smooshzone.txt_smoosh_size.addEventListener(Event.CHANGE, event_smoosher_numberUpdate);
mc_smooshzone.txt_smoosh_smoothness.addEventListener(Event.CHANGE, event_smoosher_numberUpdate);
//////////////////////////////////////////////////////////////////

//GLASS STAMPS
mc_glass_stamps.visible = false;
//
btn_glass_stamps.addEventListener(MouseEvent.MOUSE_UP, event_glass_stamps);
mc_glass_stamps.btn_glasStamp_cancel.addEventListener(MouseEvent.MOUSE_UP, event_glass_stamps_cancel);
mc_glass_stamps.btn_glasStamp_accept.addEventListener(MouseEvent.MOUSE_UP, event_glass_stamps_accept);
mc_glass_stamps.btn_reset.addEventListener(MouseEvent.MOUSE_UP, event_glassStamps_reset);
//
mc_glass_stamps.mc_ico_circle.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassType);
mc_glass_stamps.mc_ico_square.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassType);
mc_glass_stamps.mc_ico_random.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassType);
//
setup_glassTextField(mc_glass_stamps.txt_twirl, num_glassStamp_twirl);
setup_glassTextField(mc_glass_stamps.txt_buldge, num_glassStamp_buldge);
setup_glassTextField(mc_glass_stamps.txt_squeeze, num_glassStamp_squeeze);
setup_glassTextField(mc_glass_stamps.txt_pinch, num_glassStamp_pinch);
setup_glassTextField(mc_glass_stamps.txt_stretch, num_glassStamp_strech);
setup_glassTextField(mc_glass_stamps.txt_lense, num_glassStamp_lense);
setup_glassTextField(mc_glass_stamps.txt_size, num_glassStamp_radius);
//
mc_glass_stamps.txt_twirl.addEventListener(Event.CHANGE, event_glass_txt_CHANGE);
mc_glass_stamps.txt_buldge.addEventListener(Event.CHANGE, event_glass_txt_CHANGE);
mc_glass_stamps.txt_squeeze.addEventListener(Event.CHANGE, event_glass_txt_CHANGE);
mc_glass_stamps.txt_pinch.addEventListener(Event.CHANGE, event_glass_txt_CHANGE);
mc_glass_stamps.txt_stretch.addEventListener(Event.CHANGE, event_glass_txt_CHANGE);
mc_glass_stamps.txt_lense.addEventListener(Event.CHANGE, event_glass_txt_CHANGE);
//
mc_glass_stamps.txt_size.addEventListener(Event.CHANGE, event_glass_setSize);
//
mc_glass_stamps.btn_stamp.addEventListener(MouseEvent.MOUSE_UP, event_glass_setMode);
mc_glass_stamps.btn_draw.addEventListener(MouseEvent.MOUSE_UP, event_glass_setMode);
//
mc_glass_stamps.btn_twirl.addEventListener(MouseEvent.MOUSE_OVER, play_glass_stamp_diamond);
mc_glass_stamps.btn_buldge.addEventListener(MouseEvent.MOUSE_OVER, play_glass_stamp_diamond);
mc_glass_stamps.btn_squeeze.addEventListener(MouseEvent.MOUSE_OVER, play_glass_stamp_diamond);
mc_glass_stamps.btn_pinch.addEventListener(MouseEvent.MOUSE_OVER, play_glass_stamp_diamond);
mc_glass_stamps.btn_tunnel.addEventListener(MouseEvent.MOUSE_OVER, play_glass_stamp_diamond);
mc_glass_stamps.btn_strech.addEventListener(MouseEvent.MOUSE_OVER, play_glass_stamp_diamond);
mc_glass_stamps.btn_lense.addEventListener(MouseEvent.MOUSE_OVER, play_glass_stamp_diamond);
//
mc_glass_stamps.btn_twirl.addEventListener(MouseEvent.MOUSE_OUT, stop_glass_stamp_diamond);
mc_glass_stamps.btn_buldge.addEventListener(MouseEvent.MOUSE_OUT, stop_glass_stamp_diamond);
mc_glass_stamps.btn_squeeze.addEventListener(MouseEvent.MOUSE_OUT, stop_glass_stamp_diamond);
mc_glass_stamps.btn_pinch.addEventListener(MouseEvent.MOUSE_OUT, stop_glass_stamp_diamond);
mc_glass_stamps.btn_tunnel.addEventListener(MouseEvent.MOUSE_OUT, stop_glass_stamp_diamond);
mc_glass_stamps.btn_strech.addEventListener(MouseEvent.MOUSE_OUT, stop_glass_stamp_diamond);
mc_glass_stamps.btn_lense.addEventListener(MouseEvent.MOUSE_OUT, stop_glass_stamp_diamond);
//select which type of stamp
mc_glass_stamps.btn_twirl.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassDifusion);
mc_glass_stamps.btn_buldge.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassDifusion);
mc_glass_stamps.btn_squeeze.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassDifusion);
mc_glass_stamps.btn_pinch.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassDifusion);
mc_glass_stamps.btn_tunnel.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassDifusion);
mc_glass_stamps.btn_strech.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassDifusion);
mc_glass_stamps.btn_lense.addEventListener(MouseEvent.MOUSE_UP, event_selectGlassDifusion);
//
glass_stamp_diamond(mc_glass_stamps.mc_btn_twirl.mc_clip, false);
glass_stamp_diamond(mc_glass_stamps.mc_btn_buldge.mc_clip, false);
glass_stamp_diamond(mc_glass_stamps.mc_btn_squeeze.mc_clip, false);
glass_stamp_diamond(mc_glass_stamps.mc_btn_pinch.mc_clip, false);
glass_stamp_diamond(mc_glass_stamps.mc_btn_tunnel.mc_clip, false);
glass_stamp_diamond(mc_glass_stamps.mc_btn_strech.mc_clip, false);
glass_stamp_diamond(mc_glass_stamps.mc_btn_lense.mc_clip, false);
//////////////////////////////////////////////////////////////////

//BLEND AND DISPLACER-izer
mc_blend_and_displace.visible = false;
btn_blend_and_displace.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace);
mc_blend_and_displace.btn_load_another.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_loadAnother);
mc_blend_and_displace.btn_load.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_loadImage);
mc_blend_and_displace.btn_save.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_save);
mc_blend_and_displace.btn_cancel.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_cancel);
//
mc_blend_and_displace.btn_add.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_darken.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_difference.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_hardlight.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_invert.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_lighten.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_multiply.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_overlay.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_screen.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_subtract.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_setMode);
mc_blend_and_displace.btn_displacementmap.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_displacement);
//text fields
setup_blend_and_displace_txt(mc_blend_and_displace.txt_blur, 0);
setup_blend_and_displace_txt(mc_blend_and_displace.txt_disp_scaleX, 200);
setup_blend_and_displace_txt(mc_blend_and_displace.txt_disp_scaleY, 200);
setup_blend_and_displace_txt(mc_blend_and_displace.txt_disp_color, 0.1);
setup_blend_and_displace_txt(mc_blend_and_displace.txt_disp_alpha, 0.25);
//events for text fields
mc_blend_and_displace.txt_blur.addEventListener(Event.CHANGE, event_blend_and_displace_txtCHANGE);
mc_blend_and_displace.txt_disp_scaleX.addEventListener(Event.CHANGE, event_blend_and_displace_txtCHANGE);
mc_blend_and_displace.txt_disp_scaleY.addEventListener(Event.CHANGE, event_blend_and_displace_txtCHANGE);
mc_blend_and_displace.txt_disp_color.addEventListener(Event.CHANGE, event_blend_and_displace_txtCHANGE);
mc_blend_and_displace.txt_disp_alpha.addEventListener(Event.CHANGE, event_blend_and_displace_txtCHANGE);
mc_blend_and_displace.txt_disp_mapX.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_txtCLICK);
mc_blend_and_displace.txt_disp_mapY.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_txtCLICK);
mc_blend_and_displace.txt_disp_mode.addEventListener(MouseEvent.MOUSE_UP, event_blend_and_displace_txtCLICK);
//////////////////////////////////////////////////////////////////

//COLOR FACTORY
mc_color_factory.visible = false;
mc_color_factory.mc_settings.visible = false;
//
btn_color_factory.addEventListener(MouseEvent.MOUSE_UP, event_color_factory);
//
mc_color_factory.btn_reset.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_RESET);
mc_color_factory.btn_accept.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ACCEPT);
mc_color_factory.btn_cancel.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_CANCEL);

mc_color_factory.mc_settings.btn_cancel.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_SETTINGS_CANCEL);
mc_color_factory.mc_settings.btn_apply.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_SETTINGS_APPLY);
mc_color_factory.mc_settings.btn_about.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_about);
//color factory default icons
mc_color_factory.btn_blur.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_colormatrix.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_convolution.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_rbgshift.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_colorTransform.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_pixelblast.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_shuffle.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_ascii.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_mirror.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_perlin.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_fuzzy.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
//special window (extras)
mc_color_factory.btn_pixelblast.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_mirror.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_shuffle.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_perlin.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_ascii.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
mc_color_factory.btn_fuzzy.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_openSettings);
//text fields
mc_color_factory.mc_settings.txt_blurX_input.addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
mc_color_factory.mc_settings.txt_blurY_input.addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
//arrays
for(var _colMatrix:Number = 0; _colMatrix<arr_color_factory_colorMatrixInputFields.length; ++_colMatrix){
	arr_color_factory_colorMatrixInputFields[_colMatrix].addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
};
color_factory_window.txt_colorMatrix_RANDOM.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_colormatrix_RANDOM);
color_factory_window.txt_colorMatrix_RED.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_colormatrix_SINGLE);
color_factory_window.txt_colorMatrix_GREEN.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_colormatrix_SINGLE);
color_factory_window.txt_colorMatrix_BLUE.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_colormatrix_SINGLE);
//
color_factory_window.txt_convolution_RANDOM.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_convolution_RANDOM);
//up/down buttons for the convolution window
for(var _colConvolution:Number = 0; _colConvolution<arr_color_factory_colorMatrixInputFields.length; ++_colConvolution){
	arr_color_factory_convolution_ARROWS[_colConvolution].addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ARROWS);
};
//text change for color factory
for(var _colConvolutionChange:Number = 0; _colConvolutionChange<arr_color_factory_convolution_INPUTS.length; ++_colConvolutionChange){
	arr_color_factory_convolution_INPUTS[_colConvolutionChange].addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
}
//
color_factory_window.txt_rgbshift_RANDOM.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_RGBshift_RANDOM);
//up/down arrows for the RGB shift
for(var _colRGBshift:Number = 0; _colRGBshift<arr_color_factory_RGBshift_ARROWS.length; ++_colRGBshift){
	arr_color_factory_RGBshift_ARROWS[_colRGBshift].addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ARROWS);
}
//text change for RGB shift
for(var _colRGBshiftChange:Number = 0; _colRGBshiftChange<arr_color_factory_RGBshift_INPUTS.length; ++_colRGBshiftChange){
	arr_color_factory_RGBshift_INPUTS[_colRGBshiftChange].addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
}
//
color_factory_window.txt_colorTransform_RANDOM.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_colorTransform_RANDOM);
//
for(var _colTransform:Number = 0; _colTransform<arr_color_factory_ColorTransform_INPUTS.length; ++_colTransform){
	arr_color_factory_ColorTransform_INPUTS[_colTransform].addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
}
//special events
color_factory_window.btn_pixelblast.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_blastpixels);
//shuffle
for(var _colShuffle:Number = 0; _colShuffle<arr_color_factory_Shuffle_INPUTS.length; ++_colShuffle){
	arr_color_factory_Shuffle_INPUTS[_colShuffle].addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
}
//random (special)
color_factory_window.txt_shuffle_RANDOM.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_RANDOM);
//up/down for tile size
color_factory_window.txt_shuffle_size_INPUT_DOWN.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ARROWS_SHUFFLE);
color_factory_window.txt_shuffle_size_INPUT_UP.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ARROWS_SHUFFLE);
//up/down for x/y
color_factory_window.txt_shuffle_spacing_INPUT_UP.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ARROWS_SHUFFLEXY);
color_factory_window.txt_shuffle_spacing_INPUT_DOWN.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ARROWS_SHUFFLEXY);
//window "shuffle" button
color_factory_window.btn_shuffle.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_SHUFFLE);
//ascii
color_factory_window.btn_asciiart.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ASCII);
color_factory_window.btn_asciiart_save.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ASCII_SAVE);
color_factory_window.btn_asciiart_clipboard.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_ASCII_CLIPBOARD);
//mirror (kaleidoscope)
color_factory_window.btn_mirror_01.addEventListener(MouseEvent.MOUSE_DOWN, event_color_factory_MIRROR_DOWN);
color_factory_window.btn_mirror_02.addEventListener(MouseEvent.MOUSE_DOWN, event_color_factory_MIRROR_DOWN);
color_factory_window.btn_mirror_03.addEventListener(MouseEvent.MOUSE_DOWN, event_color_factory_MIRROR_DOWN);
color_factory_window.btn_mirror_04.addEventListener(MouseEvent.MOUSE_DOWN, event_color_factory_MIRROR_DOWN);
color_factory_window.btn_mirror_05.addEventListener(MouseEvent.MOUSE_DOWN, event_color_factory_MIRROR_DOWN);
color_factory_window.btn_mirror_01.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_02.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_03.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_04.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_05.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_01.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_02.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_03.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_04.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_color_factory_MIRROR_UP);
color_factory_window.btn_mirror_05.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_color_factory_MIRROR_UP);
//perlin noise texture
for(var _colPerlinBool:Number = 0; _colPerlinBool<arr_color_factory_PerlinTexture_BOOLS.length; ++_colPerlinBool){
	arr_color_factory_PerlinTexture_BOOLS[_colPerlinBool].addEventListener(MouseEvent.MOUSE_UP, event_color_factory_text_TOGGLE);
}
for(var _colPerlin:Number = 0; _colPerlin<arr_color_factory_PerinTexture_INPUTS.length; ++_colPerlin){
	arr_color_factory_PerinTexture_INPUTS[_colPerlin].addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
}
color_factory_window.txt_perlin_RANDOM.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_PerlinTexture_RANDOM);
//fuzzy
for (var _colFuzzyBool:Number = 0; _colFuzzyBool<arr_color_factory_fuzzy_BOOLS.length; ++_colFuzzyBool){
	arr_color_factory_fuzzy_BOOLS[_colFuzzyBool].addEventListener(MouseEvent.MOUSE_UP, event_color_factory_text_TOGGLE);
}
for (var _colFuzzyInput:Number = 0; _colFuzzyInput<arr_color_factory_fuzzy_INPUTS.length; ++_colFuzzyInput){
	arr_color_factory_fuzzy_INPUTS[_colFuzzyInput].addEventListener(Event.CHANGE, event_color_factory_text_CHANGE);
}
color_factory_window.btn_grow.addEventListener(MouseEvent.MOUSE_DOWN, event_color_factory_FUZZY_DOWN);
color_factory_window.btn_grow.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_FUZZY_UP);
color_factory_window.btn_grow.addEventListener(MouseEvent.RELEASE_OUTSIDE, event_color_factory_FUZZY_UP);
color_factory_window.btn_reset_hair.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_FUZZY_RESETSCAN);
color_factory_window.txt_fuzzy_RANDOM.addEventListener(MouseEvent.MOUSE_UP, event_color_factory_fuzzy_RESET);
//////////////////////////////////////////////////////////////////

/////////////////AIRBRUSH///////
mc_setting_brushes.visible = false;
mc_setting_brushes.txt_fade.mouseEnabled = false;
btn_softbrush.addEventListener(MouseEvent.MOUSE_UP, event_airbrush);
mc_setting_brushes.btn_fade.addEventListener(MouseEvent.MOUSE_UP, event_airbrush_toggleFade);
mc_setting_brushes.txt_size.addEventListener(Event.CHANGE, event_airbrush_setSize);
txt_restrict(mc_setting_brushes.txt_size, String(num_airbrushSize), "0-9");
//////////////////////////////////////////////////////////////////

///////////////PERLIN BRUSH/////////
mc_setting_perlinbrush.visible = false;
mc_setting_perlinbrush.btn_generateRand.buttonMode = true;
mc_setting_perlinbrush.btn_drawRand.buttonMode = true;
//
btn_perlinbrush.addEventListener(MouseEvent.MOUSE_UP, event_perlinbrush);
//
mc_setting_perlinbrush.btn_drawRand.addEventListener(MouseEvent.MOUSE_UP, perlin_toggleDrawRandom);
mc_setting_perlinbrush.btn_generateRand.addEventListener(MouseEvent.MOUSE_UP, perlin_generateRandVals_UP);
mc_setting_perlinbrush.btn_drawNoise.addEventListener(MouseEvent.MOUSE_UP, perlin_toggleDrawNoise);
//perlin UI events (booleans)
mc_setting_perlinbrush.txt_fractalNoise.addEventListener(MouseEvent.MOUSE_UP, perlin_toggleBool_UP);
mc_setting_perlinbrush.txt_stitch.addEventListener(MouseEvent.MOUSE_UP, perlin_toggleBool_UP);
mc_setting_perlinbrush.txt_grayscale.addEventListener(MouseEvent.MOUSE_UP, perlin_toggleBool_UP);
//inputs
mc_setting_perlinbrush.txt_baseX.addEventListener(Event.CHANGE, perlin_textInput_EVENT);
mc_setting_perlinbrush.txt_baseY.addEventListener(Event.CHANGE, perlin_textInput_EVENT);
mc_setting_perlinbrush.txt_seed.addEventListener(Event.CHANGE, perlin_textInput_EVENT);
mc_setting_perlinbrush.txt_octaves.addEventListener(Event.CHANGE, perlin_textInput_EVENT);
mc_setting_perlinbrush.txt_channelOptions.addEventListener(Event.CHANGE, perlin_textInput_EVENT);
//RGB buttons
mc_setting_perlinbrush.btn_red.addEventListener(MouseEvent.MOUSE_UP, perlin_channelOptions_setRGB_UP);
mc_setting_perlinbrush.btn_blue.addEventListener(MouseEvent.MOUSE_UP, perlin_channelOptions_setRGB_UP);
mc_setting_perlinbrush.btn_green.addEventListener(MouseEvent.MOUSE_UP, perlin_channelOptions_setRGB_UP);
//////////////////////////////////////////////////////////////////

//////////////PERLIN CHALK//////////
btn_perlinchalk.addEventListener(MouseEvent.MOUSE_UP, event_perlinChalk);
//////////////////////////////////////////////////////////////////

//////////////RUNNY INK////////////////////
txt_restrict(mc_setting_runnyInk.txt_size, String(num_runnyInkSize), "0-9");
txt_restrict(mc_setting_runnyInk.txt_alpha, String(num_runnyInkAlpha), "0-9");
mc_setting_runnyInk.txt_size.addEventListener(Event.CHANGE, event_runnyInk_input_CHANGE);
mc_setting_runnyInk.txt_alpha.addEventListener(Event.CHANGE, event_runnyInk_input_CHANGE);
btn_runnyInk.addEventListener(MouseEvent.MOUSE_UP, event_runnyInk);
//////////////////////////////////////////////////////////////////

////////////////CUSTOM INK//////////////////////
btn_customInk.addEventListener(MouseEvent.MOUSE_UP, event_customInk);
//
mc_settings_customInk.btn_toggle.addEventListener(MouseEvent.MOUSE_UP, customInk_toggleRange_EVENT);
mc_settings_customInk.btn_reset.addEventListener(MouseEvent.MOUSE_UP, customInk_resetVals_EVENT);
//mc_settings_customInk.txt_tooltip.addEventListener(MouseEvent.MOUSE_OVER, customInk_event_TOOLTIP);
//mc_settings_customInk.txt_tooltip.addEventListener(MouseEvent.MOUSE_OUT, customInk_event_TOOLTIP_OUT);
//
mc_settings_customInk.txt_maxsize.addEventListener(Event.CHANGE, customInk_input_CHANGE);
mc_settings_customInk.txt_precision.addEventListener(Event.CHANGE, customInk_input_CHANGE);
mc_settings_customInk.txt_alpha.addEventListener(Event.CHANGE, customInk_input_CHANGE);
mc_settings_customInk.txt_x1_1.addEventListener(Event.CHANGE, customInk_input_CHANGE);
mc_settings_customInk.txt_x1_2.addEventListener(Event.CHANGE, customInk_input_CHANGE);
mc_settings_customInk.txt_y1_1.addEventListener(Event.CHANGE, customInk_input_CHANGE);
mc_settings_customInk.txt_y1_2.addEventListener(Event.CHANGE, customInk_input_CHANGE);
//
setup_numberDecimal_txt(mc_settings_customInk.txt_maxsize, num_customInk_maxSize);
setup_numberDecimal_txt(mc_settings_customInk.txt_precision, num_customInk_precision);
setup_numberDecimal_txt(mc_settings_customInk.txt_alpha, num_customInk_alpha);
setup_numberDecimal_txt(mc_settings_customInk.txt_x1_1, num_customInk_lineRange_X1);
setup_numberDecimal_txt(mc_settings_customInk.txt_x1_2, num_customInk_lineRange_X2);
setup_numberDecimal_txt(mc_settings_customInk.txt_y1_1, num_customInk_lineRange_Y1);
setup_numberDecimal_txt(mc_settings_customInk.txt_y1_2, num_customInk_lineRange_Y2);
//////////////////////////////////////////////////////////////////

////////////////DOTTED LINES////////////////////////////////
mc_setting_dotted.visible = false;
btn_dotted.addEventListener(MouseEvent.MOUSE_UP, event_dashedLines);
//
mc_setting_dotted.txt_comment.addEventListener(MouseEvent.MOUSE_OVER, event_dashedLines_comment_OVER);
mc_setting_dotted.txt_comment.addEventListener(MouseEvent.MOUSE_OUT, event_dashedLines_comment_OUT);
//
mc_setting_dotted.txt_length.addEventListener(Event.CHANGE, event_dotted_INPUT_CHANGE);
mc_setting_dotted.txt_spacing.addEventListener(Event.CHANGE, event_dotted_INPUT_CHANGE);
mc_setting_dotted.txt_sprinkle.addEventListener(Event.CHANGE, event_dotted_INPUT_CHANGE);

setup_numberDecimal_txt(mc_setting_dotted.txt_length, num_dottedLength);
setup_numberDecimal_txt(mc_setting_dotted.txt_spacing, num_dottedSpacing);
setup_numberDecimal_txt(mc_setting_dotted.txt_sprinkle, num_dottedSprinkle);
//////////////////////////////////////////////////////////////////

//////////////////LOW INK////////////////////////////////////
//LOW INK
mc_setting_lowink.visible = false;
selectedColor(mc_setting_lowink.btn_default);//select first option
//
btn_lowink.addEventListener(MouseEvent.MOUSE_UP, event_lowInk);
//
mc_setting_lowink.btn_default.addEventListener(MouseEvent.MOUSE_UP, event_lowInk_setInk);
mc_setting_lowink.btn_random.addEventListener(MouseEvent.MOUSE_UP, event_lowInk_setInk);
mc_setting_lowink.btn_pulse.addEventListener(MouseEvent.MOUSE_UP, event_lowInk_setInk);
mc_setting_lowink.btn_wave.addEventListener(MouseEvent.MOUSE_UP, event_lowInk_setInk);
//
mc_setting_lowink.txt_minSize.addEventListener(Event.CHANGE, event_lowInk_input_CHANGE);
mc_setting_lowink.txt_maxSize.addEventListener(Event.CHANGE, event_lowInk_input_CHANGE);
mc_setting_lowink.txt_fadeRate.addEventListener(Event.CHANGE, event_lowInk_input_CHANGE);
//
//////////////////////////////////////////////////////////////////


////////////////////////BACON////////////////////////////////////
mc_setting_bacon.visible = false;
btn_bacon.addEventListener(MouseEvent.MOUSE_UP, event_bacon);
//first run bacon
setBaconColors();
//
mc_setting_bacon.mc_col1.addEventListener(MouseEvent.MOUSE_UP, event_bacon_selectColor);
mc_setting_bacon.mc_col2.addEventListener(MouseEvent.MOUSE_UP, event_bacon_selectColor);
mc_setting_bacon.mc_col3.addEventListener(MouseEvent.MOUSE_UP, event_bacon_selectColor);
mc_setting_bacon.mc_col4.addEventListener(MouseEvent.MOUSE_UP, event_bacon_selectColor);
//restrict bacon fields
setup_numberNegative_txt(mc_setting_bacon.txt_xMin, 0);
setup_numberNegative_txt(mc_setting_bacon.txt_xMax, 0);
setup_numberNegative_txt(mc_setting_bacon.txt_yMin, 0);
setup_numberNegative_txt(mc_setting_bacon.txt_yMax, 0);
//
mc_setting_bacon.txt_xMin.addEventListener(Event.CHANGE, event_baconText_CHANGE);
mc_setting_bacon.txt_xMax.addEventListener(Event.CHANGE, event_baconText_CHANGE);
mc_setting_bacon.txt_yMin.addEventListener(Event.CHANGE, event_baconText_CHANGE);
mc_setting_bacon.txt_yMax.addEventListener(Event.CHANGE, event_baconText_CHANGE);
//
//////////////////////////////////////////////////////////////////

////////////////////////EGGS////////////////////////////////////
//first runn egg
selectedColor(mc_setting_eggs.btn_round);
selectedColor(mc_setting_eggs.btn_good);
btn_eggs.addEventListener(MouseEvent.MOUSE_UP, event_egg);
//setup input fields
setup_numberDecimal_txt(mc_setting_eggs.txt_blur, num_eggGlow_blur);
setup_numberDecimal_txt(mc_setting_eggs.txt_strength, num_eggGlow_strength);
//egg events
//settings
mc_setting_eggs.btn_round.addEventListener(MouseEvent.MOUSE_UP, event_set_eggType);
mc_setting_eggs.btn_cube.addEventListener(MouseEvent.MOUSE_UP, event_set_eggType);
//moods
mc_setting_eggs.btn_good.addEventListener(MouseEvent.MOUSE_UP, event_set_eggMood);
mc_setting_eggs.btn_messy.addEventListener(MouseEvent.MOUSE_UP, event_set_eggMood);
mc_setting_eggs.btn_chaos.addEventListener(MouseEvent.MOUSE_UP, event_set_eggMood);
mc_setting_eggs.btn_eggnog.addEventListener(MouseEvent.MOUSE_UP, event_set_eggMood);
mc_setting_eggs.btn_glitch.addEventListener(MouseEvent.MOUSE_UP, event_set_eggMood);
//color tabs
mc_setting_eggs.mc_col1.addEventListener(MouseEvent.MOUSE_UP, event_egg_selectColor);
mc_setting_eggs.mc_col2.addEventListener(MouseEvent.MOUSE_UP, event_egg_selectColor);
//update text fields (glow)
mc_setting_eggs.txt_blur.addEventListener(Event.CHANGE, event_set_glow_CHANGE);
mc_setting_eggs.txt_strength.addEventListener(Event.CHANGE, event_set_glow_CHANGE);

//////////////////////////////////////////////////////////////////

////////////////////////TOAST////////////////////////////////////
mc_setting_toast.visible = false;
btn_toast.addEventListener(MouseEvent.MOUSE_UP, event_toast);
//toast ui
mc_setting_toast.txt_burn.addEventListener(Event.CHANGE, event_toast_burn_CHANGE);
mc_setting_toast.txt_outline.addEventListener(MouseEvent.MOUSE_UP, event_toast_toggleBools);
mc_setting_toast.txt_negative.addEventListener(MouseEvent.MOUSE_UP, event_toast_toggleBools);
mc_setting_toast.txt_gray.addEventListener(MouseEvent.MOUSE_UP, event_toast_toggleBools);

//////////////////////////////////////////////////////////////////

////////////////////SCREAM INTO THE VOID//////////////////////////
mc_setting_void.visible = false;
btn_void.addEventListener(MouseEvent.MOUSE_UP, event_void);
mc_setting_void.btn_scream.addEventListener(MouseEvent.MOUSE_UP, event_scream_into_the_void);
//////////////////////////////////////////////////////////////////

///////////////////////ASCII PAINT////////////////////////////////
mc_asciipaint.visible = false;
mc_asciipaint.mc_popup.visible = false;
mc_asciipaint.mc_cat.gotoAndStop("hide");
mc_asciipaint.mc_skeleton.stop();
mc_asciipaint.btn_open.buttonMode = true;
mc_asciipaint.mc_cat.buttonMode = true;
mc_asciipaint.mc_skeleton.buttonMode = true;
mc_asciipaint.mc_settings.mc_input.visible = false;//custom field
mc_asciipaint.mc_settings.mc_selected.mouseEnabled = false;
mc_asciipaint.mc_settings.mc_selected_color.mouseEnabled = false;
//open
btn_asciipaint.addEventListener(MouseEvent.MOUSE_UP, event_asciipaint);
//UI events
mc_asciipaint.mc_skeleton.addEventListener(MouseEvent.MOUSE_UP, event_asciipaint_skeleton_UP);
mc_asciipaint.mc_popup.btn_fact.addEventListener(MouseEvent.MOUSE_UP, event_asciipaint_popup_close);
mc_asciipaint.btn_open.addEventListener(MouseEvent.MOUSE_UP, event_asciipaint_openSettings);
mc_asciipaint.mc_settings.btn_minimize.addEventListener(MouseEvent.MOUSE_UP, event_asciipaint_minimizeSettings);
mc_asciipaint.mc_cat.addEventListener(MouseEvent.MOUSE_UP, event_asciiCat_PET);
//UI (DONE, CLEAR, CANCEL, SAVES...)
mc_asciipaint.mc_settings.btn_done.addEventListener(MouseEvent.MOUSE_UP, event_ascii_DONE);
mc_asciipaint.mc_settings.btn_clear.addEventListener(MouseEvent.MOUSE_UP, event_ascii_CLEAR);
mc_asciipaint.mc_settings.btn_cancel.addEventListener(MouseEvent.MOUSE_UP, event_ascii_CANCEL);
mc_asciipaint.mc_settings.btn_saveText.addEventListener(MouseEvent.MOUSE_UP, event_ascii_saveAsText);
mc_asciipaint.mc_settings.btn_saveClipboard.addEventListener(MouseEvent.MOUSE_UP, event_ascii_saveToClipboard);
//UI MODES
mc_asciipaint.mc_settings.mc_input.txt_custom.addEventListener(Event.ENTER_FRAME, event_ascii_SET_INPUT);
mc_asciipaint.mc_settings.btn_unicode.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_MODE);
mc_asciipaint.mc_settings.btn_dingbats.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_MODE);
mc_asciipaint.mc_settings.btn_blocks.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_MODE);
mc_asciipaint.mc_settings.btn_alphanumeric.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_MODE);
mc_asciipaint.mc_settings.btn_eraser.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_MODE);
mc_asciipaint.mc_settings.btn_custom.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_MODE);
//UI COLOR SELECTION
mc_asciipaint.mc_settings.btn_col1.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col2.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col3.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col4.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col5.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col6.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col7.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col8.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col9.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col10.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col11.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col12.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col13.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col14.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col15.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
mc_asciipaint.mc_settings.btn_col16.addEventListener(MouseEvent.MOUSE_UP, event_ascii_SET_COLOR);
//////////////////////////////////////////////////////////////////

////////////////////////GOLDFISH (FLUID DYNAMICS)/////////////////
//GOLDFISH (FLUID DYNAMICS)
btn_goldfish.addEventListener(MouseEvent.MOUSE_UP, event_goldfish);
mc_goldfish.visible = false;
//buttons
mc_goldfish.mc_fluid_toggle.gotoAndStop(1);
mc_goldfish.mc_fluid_toggle.mouseEnabled = true;
mc_goldfish.mc_fluid_toggle.addEventListener(MouseEvent.MOUSE_UP, event_waterToggleRain);
//setup   
setup_numberDecimal_txt(mc_goldfish.txt_fluid_distance, 30);
txt_restrict(mc_goldfish.txt_fluid_ripple, String(int_water_rippleSize), "0-9");
//text input
mc_goldfish.txt_fluid_distance.addEventListener(Event.CHANGE, event_waterInputs_CHANGE);
mc_goldfish.txt_fluid_ripple.addEventListener(Event.CHANGE, event_waterInputs_CHANGE);
//toggle modes
mc_goldfish.btn_draw.addEventListener(MouseEvent.MOUSE_UP, event_waterSetMode);
mc_goldfish.btn_splash.addEventListener(MouseEvent.MOUSE_UP, event_waterSetMode);
//the ACCEPT button (quit and save bitmap data)
mc_goldfish.btn_accept.addEventListener(MouseEvent.MOUSE_UP, event_water_ACCEPT);
mc_goldfish.btn_poweredby.addEventListener(MouseEvent.MOUSE_UP, event_water_poweredBy);
//////////////////////////////////////////////////////////////////

/////////////////////RAINBOW PAINT////////////////////////////////
mc_setting_rainbowpaint.visible = false;
btn_rainbowpaint.addEventListener(MouseEvent.MOUSE_UP, event_rainbowpaint);
setRainbowColors();
//setup UI
//click through...
mc_setting_rainbowpaint.mc_colSelect.mouseEnabled = false;
mc_setting_rainbowpaint.txt_type.mouseEnabled = false;
mc_setting_rainbowpaint.txt_spread.mouseEnabled = false;
mc_setting_rainbowpaint.txt_interpolation.mouseEnabled = false;
//
mc_setting_rainbowpaint.btn_reset.addEventListener(MouseEvent.MOUSE_DOWN, event_rainbow_textInput_RESET);
//
mc_setting_rainbowpaint.mc_col1.addEventListener(MouseEvent.MOUSE_UP, event_rainbowpaint_selectColor);
mc_setting_rainbowpaint.mc_col2.addEventListener(MouseEvent.MOUSE_UP, event_rainbowpaint_selectColor);
mc_setting_rainbowpaint.mc_col3.addEventListener(MouseEvent.MOUSE_UP, event_rainbowpaint_selectColor);
mc_setting_rainbowpaint.mc_col4.addEventListener(MouseEvent.MOUSE_UP, event_rainbowpaint_selectColor);
mc_setting_rainbowpaint.mc_col5.addEventListener(MouseEvent.MOUSE_UP, event_rainbowpaint_selectColor);
mc_setting_rainbowpaint.mc_col6.addEventListener(MouseEvent.MOUSE_UP, event_rainbowpaint_selectColor);
//
mc_setting_rainbowpaint.btn_type.addEventListener(MouseEvent.MOUSE_UP, event_rainbow_toggleSetting);
mc_setting_rainbowpaint.btn_spread.addEventListener(MouseEvent.MOUSE_UP, event_rainbow_toggleSetting);
mc_setting_rainbowpaint.btn_interpolation.addEventListener(MouseEvent.MOUSE_UP, event_rainbow_toggleSetting);
//
setup_numberNegative_txt(mc_setting_rainbowpaint.txt_width, num_rainbowGradientWidth);
setup_numberNegative_txt(mc_setting_rainbowpaint.txt_height, num_rainbowGradientHeight);
setup_numberNegative_txt(mc_setting_rainbowpaint.txt_x, num_rainbowGradientX);
setup_numberNegative_txt(mc_setting_rainbowpaint.txt_y, num_rainbowGradientY);
setup_numberNegativeDecimal_txt(mc_setting_rainbowpaint.txt_offset, 0); //from -1 to 1 (negative decimals are ok)
//
mc_setting_rainbowpaint.txt_width.addEventListener(Event.CHANGE, event_rainbow_textInput_CHANGE);
mc_setting_rainbowpaint.txt_height.addEventListener(Event.CHANGE, event_rainbow_textInput_CHANGE);
mc_setting_rainbowpaint.txt_x.addEventListener(Event.CHANGE, event_rainbow_textInput_CHANGE);
mc_setting_rainbowpaint.txt_y.addEventListener(Event.CHANGE, event_rainbow_textInput_CHANGE);
mc_setting_rainbowpaint.txt_offset.addEventListener(Event.CHANGE, event_rainbow_textInput_CHANGE);
//set inputs only after CHANGE has been set else "is not a function" error
event_rainbow_textInput_setText();
//////////////////////////////////////////////////////////////////

///////////////////////////GIF BRUSH//////////////////////////////
mc_setting_gifbrush.visible = false;
btn_gifbrush.addEventListener(MouseEvent.MOUSE_UP, event_gifbrush);
//////////////////////////////////////////////////////////////////

///////////////////////////DRAW AND FILL//////////////////////////
btn_drawandfill.addEventListener(MouseEvent.MOUSE_UP, event_drawAndFill);
mc_setting_drawandfill.visible = false;
mc_setting_drawandfill.txt_compliment.mouseEnabled = false;
mc_setting_drawandfill.btn_compliment.addEventListener(MouseEvent.MOUSE_UP, event_drawAndFill_compliment);
mc_setting_drawandfill.mc_col_line.addEventListener(MouseEvent.MOUSE_UP, event_drawAndFill_selectColor);
mc_setting_drawandfill.mc_col_fill.addEventListener(MouseEvent.MOUSE_UP, event_drawAndFill_selectColor);
//////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////


//

stop();