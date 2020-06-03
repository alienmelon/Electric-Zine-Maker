/*
very simple spray paint (identical to MS Paint "spray" tool)
uses size and color values from the pen tool
*/

//str_tool = "SPRAY"

function draw_spray(event_localX, event_localY){
	var angle: Number;
	var xpos: Number;
	var ypos: Number;
	var radius: Number;
	for (var i = 0; i < num_pen_size; i++) {
		angle = Math.random() * Math.PI * 2;
		radius = Math.random() * num_pen_size; //radius of the circle
		xpos = event_localX + Math.cos(angle) * radius;
		ypos = event_localY + Math.sin(angle) * radius;
		canvasBitmapData.setPixel32(xpos, ypos, pen_color);
	}
}