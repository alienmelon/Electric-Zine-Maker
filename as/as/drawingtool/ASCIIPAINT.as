/*
ASCII Paint lets you paint ASCII art. it draws a text grid over the canvas, and text is placed on each input text while you mouse over.
input updates everytime you mouse over it. paint is "random" based on a set of strings (eraser, random, dingbats, blocks, alphanumeric, intput)
each sets the ASCII to a different character set... "input" is if you want to paint with a user inputed string...
once you're done drawing you can save your ASCII to the canvas. the grid is removed, and everything cleared, when you're done.

the input strings (randomAscii, and randomDingbat) are from an old code example. probably nobody will get the throwback, but it's cute to include anyway :D
*/

//str_tool = "ASCIIPAINT"

//////////////ASCII PAINT///////////
//cell width and height (for padding)
var num_asciiCellWidth: Number = 19;
var num_asciiCellHeight: Number = 21;
var int_asciiColor: int = 0x000000;
//size of the grid that gets drawn (this is very flexible and you can make a larger canvas here)
var num_asciiMaxWidth: Number = Math.ceil(mc_draw.width / num_asciiCellWidth) - 1; //width number of cels
var num_asciiMaxHeight: Number = Math.ceil(mc_draw.height / num_asciiCellHeight) - 1; ///height number of cels
//containers
var clip_ascii: MovieClip = new MovieClip; //contains the ascii (inside of mc_draw)
var arr_asciiGrid: Array = new Array(); //contains the entire ascii grid
//draw modes
var str_ascii_drawMode: String = "dingbats"; //eraser, random, dingbats, blocks, alphanumeric, intput
//ascii string types
var str_randomAscii: String = "!\"#$%&'()*+,-./:;<=>?@[]^_`{|}~¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿×ǀǁǂǃʻʼʽʾʿˀˁ˂˃˄˅ˆˇˈˉˊˋˌˍˎˏːˑ˒˓˔˕˖˗˘˙˚˛˜˝˞˟ˠˡˢˣˤ˥˦˧˨˩˪˫ˬ˭ˮ˯˰˱˲˳˴˵˶˷˸˹˺˻˼˽˾˿̴̵̶̷̸̡̢̧̨̛̖̗̘̙̜̝̞̟̠̣̤̥̦̩̪̫̬̭̮̯̰̱̲̳̹̺̻̼͇͈͉͍͎̀́̂̃̄̅̆̇̈̉̊̋̌̍̎̏̐̑̒̓̔̽̾̿͂͆͊͋͌̕̚ͅ͏͓͔͕͖͙͚͐͑͒͗͛҃҄҅҆҇͘͜͟͢͝͞͠͡ՙ՚՛՜՝՞՟ᅡᅢᅣᅤᅥᅦᅧᅨᅩᅪᅫᅬᅭᅮᅯᅰᅱᅲᅳᅴᅵᅶᅷᅸᅹᅺᅻᅼᅽᅾᅿᆀᆁᆂᆃᆄᆅᆆᆇᆈᆉᆊᆋᆌᆍᆎᆏᆐᆑᆒᆓᆔᆕᆖᆗᆘᆙᆚᆛᆜᆝᆞᆟᆠᆡᆢ‐‑‒–—―‖‗‘’‚‛“”„‟†‡•‣․‥…‧‵‶‷‸‹›※‼‽‾‿⁀⁁⁂⁃⁄⁅⁆−∓∔∕∖∗∘∙√∛∜∝∞∟∠∡∢∣∤∥∦∧∨∩∪∫∬∴∵∶∷∸∹∺∻∼∽∾∿≠≡≤≥≦≧≨≩≪≫≬≭≮≯≰≱≲≳≴≵≶≷≸≹≺≻≼≽≾≿⊀⊁⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋⊹⊺⊻⊼⊽⊾⊿⋀⋢⋣⋤⋥⋦⋧⋨⋩⋪⋫⋬⋭⋮⋯✁✂✃✄✆✇✈✉✌✍✎✏";
var str_randomDingbat: String = "✀✁✂✃✄✅✆✇✈✉✊✋✌✍✎✏✐✑✒✓✔✕✖✗✘✙✚✛✜✝✞✟✠✡✢✣✤✥✦✧✨✩✪✫✬✭✮✯✰✱✲✳✴✵✶✷✸✹✺✻✼✽✾✿❀❁❂❃❄❅❆❇❈❉❊❋❌❍❎❏❐❑❒❓❔❕❖❗❘❙❚❛❜❝❞❟❠❡❢❣❤❥❦❧❨❩❪❫❬❭❮❯❰❱❲❳❴❵❶❷❸❹❺❻❼❽❾❿➀➁➂➃➄➅➆➇➈➉➊➋➌➍➎➏➐➑➒➓➔➕➖➗➘➙➚➛➜➝➞➟➠➡➢➣➤➥➦➧➨➩➪➫➬➭➮➯➰➱➲➳➴➵➶➷➸➹➺➻➼➽➾➿";
var str_randomBlocks: String = "▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏▐░▒▓▔▕▖▗▘▙▚▛▜▝▞▟";
var str_randomLetterNumber: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
var str_currAsciiLetters: String = "HELLO WORLD!"; //currently inputted letters, can have multiple -- "input" for drawmode
///////////////////////////////////

//returns the entire art grid as a formatted string
function returnAsciiGrid() {
	var j: Number = 1;
	var str: String = "";
	for (var i: Number = 0; i < arr_asciiGrid.length; ++i) {
		//
		j++;
		str += (arr_asciiGrid[i].text + " ");
		//
		if (j > num_asciiMaxWidth) {
			str += ("\r\n");
			j = 1;
		}
	}
	//
	return str;
}

function saveAsciiToBitmap(bm: BitmapData) {
	//canvasBitmapData.draw(mc_draw.clip_ascii);
	update_after_draw();
	//deleteAscii();
	var bmd: BitmapData = new BitmapData(mc_draw.width, mc_draw.height, true, 0);
	bmd.draw(clip_ascii, null, null, null, null, true);
	//
	var mat: Matrix = new Matrix(); //canvas_textField.transform.matrix;
	mat.translate(clip_ascii.x, clip_ascii.y);
	bm.draw(bmd, mat, null, null, null, true);
	//delete
	bmd.dispose();
	//
	deleteAscii();
}

//return a random ascii character from string
function randomAsciiCharacter(str: String) {
	var bits: Array;
	var randBit: String;
	bits = str.split("");
	randBit = bits[Math.ceil(Math.random() * bits.length) - 1];
	return randBit;
}

function returnAsciiFormat(textField: TextField) {
	var embeddedFont:Font = new TXT_ARIAL();
	var textFormat: TextFormat = new TextFormat();
	textFormat.font = embeddedFont.fontName;
	//textField.autoSize = TextFieldAutoSize.LEFT;
	//textField.background = true;
	//textField.border = true;
	//textField.width = num_asciiCellWidth;
	//textField.height = num_asciiCellHeight;
	//
	//textFormat.font = "Arial";
	textFormat.size = 20;
	textFormat.color = int_asciiColor;
	textField.setTextFormat(textFormat);
}

//delete ascii first
function deleteAscii() {
	//remove grid
	try {
		for (var i: Number = 0; i < arr_asciiGrid.length; ++i) {
			arr_asciiGrid[i].removeEventListener(MouseEvent.MOUSE_OVER, event_ascii_textField_OVER);
			arr_asciiGrid[i].removeEventListener(MouseEvent.MOUSE_DOWN, event_ascii_textField_DOWN);
			clip_ascii.removeChild(arr_asciiGrid[i]);
		}
	} catch (e: Error) {
		//null
	}
	//remove parent
	try {
		mc_draw.removeChild(clip_ascii);
	} catch (e: Error) {
		//null
	}
	//
	arr_asciiGrid = [];//clear grid at end so it doesn't save every rendition of the drawing...
	mc_draw.removeEventListener(MouseEvent.MOUSE_DOWN, event_ascii_DOWN);
	mc_draw.removeEventListener(MouseEvent.MOUSE_UP, event_ascii_UP);
}

//make input
function makeAsciiGrid() {
	//
	//remove all and delete first
	deleteAscii();
	//add here
	mc_draw.addChild(clip_ascii);
	//pixels are 20x20 in size
	for (var j: Number = 0; j < num_asciiMaxHeight; ++j) {
		for (var i: Number = 0; i < num_asciiMaxWidth; ++i) {
			//
			var clip: TextField = new TextField();
			//var clip: INPUT = new INPUT();
			clip_ascii.addChild(clip);
			//place (multiply!)
			clip.name = "mc_clip_" + j + "_" + i;
			clip.x += (i * num_asciiCellWidth);
			clip.y += (j * num_asciiCellHeight);
			clip.text = " ";
			//
			//formatting
			//returnAsciiFormat(clip); // REMOVED: HEAVY LAG ON WINDOWS IF YOU DO THIS
			clip.selectable = false;
			clip.type = TextFieldType.DYNAMIC;
			//event
			clip.addEventListener(MouseEvent.MOUSE_OVER, event_ascii_textField_OVER);
			clip.addEventListener(MouseEvent.MOUSE_DOWN, event_ascii_textField_DOWN);
			//
			arr_asciiGrid.push(clip);
		}
	}
	//
	mc_draw.addEventListener(MouseEvent.MOUSE_DOWN, event_ascii_DOWN);
	mc_draw.addEventListener(MouseEvent.MOUSE_UP, event_ascii_UP);
};

function resetAsciiGrid() {
	deleteAscii();
	makeAsciiGrid();
}

function drawAscii(clip) {
	//
	if (str_ascii_drawMode == "random") {
		clip.text = randomAsciiCharacter(str_randomAscii);
		returnAsciiFormat(clip);
	}
	if (str_ascii_drawMode == "dingbats") {
		clip.text = randomAsciiCharacter(str_randomDingbat);
		returnAsciiFormat(clip);
	}
	if (str_ascii_drawMode == "blocks") {
		clip.text = randomAsciiCharacter(str_randomBlocks);
		returnAsciiFormat(clip);
	}
	if (str_ascii_drawMode == "alphanumeric") {
		clip.text = randomAsciiCharacter(str_randomLetterNumber);
		returnAsciiFormat(clip);
	}
	if (str_ascii_drawMode == "input") {
		clip.text = randomAsciiCharacter(str_currAsciiLetters);
		returnAsciiFormat(clip);
	}
	if(str_ascii_drawMode == "eraser"){
		clip.text = " ";
		returnAsciiFormat(clip);
	}
}

//drawing it (listeners placed on each input cell)
//ASCII drawing is different from normal drawing because all it does is impose a text grid over the canvas
//when you're done, then the text is drawn to actual canvas (see saveAsciiToBitmap)

//these togle ONLY the bool and are registered to the draw clip
function event_ascii_DOWN(event: MouseEvent) {
	bool_isMouseDown = true;
}

function event_ascii_UP(event: MouseEvent) {
	bool_isMouseDown = false;
}

//clicking the texti field, or moving over it
//handled in two separate ways
//OVER is mouse move over all so it needs the bool
function event_ascii_textField_DOWN(event:MouseEvent){
	drawAscii(event.currentTarget);
}
function event_ascii_textField_OVER(event: MouseEvent) {
	//
	if (bool_isMouseDown) {
		drawAscii(event.currentTarget);
	};
}