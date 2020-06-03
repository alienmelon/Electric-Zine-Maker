/*
CLIPBOARD SPECIFIC
*/

//save bitmapdata to clipboard
//can paste into any image editing app
function saveBitmapToClipboard(bd:BitmapData){
	try{
		Clipboard.generalClipboard.clear();
		Clipboard.generalClipboard.setData(ClipboardFormats.BITMAP_FORMAT, bd, false);
		trace("saveBitmapToClipboard()");
	}catch(e:Error){
		trace("error saveBitmapToClipboard");
	}
}

//bitmapdata = writeBitmapFromClipboard();
function writeBitmapFromClipboard(bdTo:BitmapData, numWidth:Number = 421, numHeight:Number = 595){
	if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT)) {
		trace("bitmapdata copied from clipboard");
		bdTo.draw(BitmapData(Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT)));//, null, null, null, null, true
		//
	} else {
		trace("no bitmapdata in clipboard");
		//return null;
	}
}

//to clipboard
function saveAsciiToClipboard(str:String){
	Clipboard.generalClipboard.clear();
	Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, str);
}