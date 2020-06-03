//basic saving
//shared between the drawing UI and the zine maker main menu

import flash.filesystem.File;
import flash.filesystem.FileStream;
import flash.display.PNGEncoderOptions;
import flash.utils.ByteArray;
import flash.filesystem.*;

//save only part of stage from certain x and y AS A TRANSPARENT PNG
function save_pic_PNG_xy(num_width: Number, num_height: Number, num_x: Number, num_y: Number, str_filename: String) {
	var bitmapdata: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
	bitmapdata.draw(stage);
	//cut part
	var bitmapDataA: BitmapData = new BitmapData(num_width, num_height, true, 0);
	bitmapDataA.copyPixels(bitmapdata, new Rectangle(num_x, num_y, num_width, num_height), new Point(0, 0));
	//encode
	var byteArray: ByteArray = bitmapDataA.encode(bitmapDataA.rect, new flash.display.PNGEncoderOptions(), byteArray);
	//done
	var fileReference: FileReference = new FileReference();
	fileReference.save(byteArray, str_filename + ".png");
}

function save_bitmapdata_PNG(bitmapData:BitmapData, str_filename: String){
	var byteArray: ByteArray = bitmapData.encode(bitmapData.rect, new flash.display.PNGEncoderOptions(), byteArray);
	//done
	var fileReference: FileReference = new FileReference();
	fileReference.save(byteArray, str_filename + ".png");
}