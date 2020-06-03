//PARSING TEXT AND OTHER THINGS//

//var n:Number = string_getNumber("testing1");
function string_getNumber(source:String):Number
{
    var pattern:RegExp = /[^0-9]/g;
    return Number(source.replace(pattern, ''));
}

//open a URL
function openURL(str_URL:String){
	var openPage:URLRequest = new URLRequest(str_URL);
	navigateToURL(openPage,"_blank");
}
