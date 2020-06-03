/*
this was taken from my javascript example
*/

var arr_write:Array = new Array();
var num_write:Number = 0;//the current array element (word)

var int_write:uint;//writing interval
var num_intAmnt:Number = 200;
var resetCount:Number = 100;

//writing
function write_words(str:String, txt_field:TextField){
	arr_write = [];
	num_write = 0;
	txt_field.text = "";
	resetCount = 200;
	//
	arr_write = str.split(" ");
	//
	clearInterval(int_write);
	int_write = setInterval(_write, num_intAmnt, txt_field);
	//
}

function _write(txt_field:TextField){
	//
	var str = arr_write[num_write];
	//
	txt_field.appendText(" " + str);
	num_write += 1;
	//
	if(num_write > arr_write.length-1){
		clearInterval(int_write);
	}
}

function end_write_set(str:String, txt_field:TextField){
	clearInterval(int_write);
	txt_field.text = "";
	txt_field.text = str;
}

function stop_writing(){
	clearInterval(int_write);
}