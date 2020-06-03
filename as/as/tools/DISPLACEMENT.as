//DISPLACEMENT FILTERS

function twirlFilter(source:BitmapData, region:Rectangle=null, rotation:Number=0) {
	  var width:int = source.width;
	  var height:int = source.height;
	  region ||= new Rectangle(0, 0, width, height);
	  rotation ||= Math.PI / 2;
	  var dbmd:BitmapData = new BitmapData(width, height, false, 0x8080);
	  var radius:Number = Math.min(region.width, region.height) / 2;
	  var centerX:int = region.x + region.width / 2;
	  var centerY:int = region.y + region.height / 2;
	  for(var y:int=0;y<height;++y) {
		var ycoord:int = y - centerY;
		for(var x:int=0;x<width;++x) {
		  var xcoord:int = x - centerX;
		  var dr:Number = radius - Math.sqrt(xcoord * xcoord + ycoord * ycoord); 
		  if(dr > 0) {
			var angle:Number = dr / radius * rotation;
			var dx:Number = xcoord * Math.cos(angle) - ycoord * Math.sin(angle) - xcoord;
			var dy:Number = xcoord * Math.sin(angle) + ycoord * Math.cos(angle) - ycoord;
			var blue:int = 0x80 + Math.round(dx / width * 0xff);
			var green:int = 0x80 + Math.round(dy / height * 0xff);
			dbmd.setPixel(x, y, green << 8 | blue);
		  }
		} 
	  }
	  return new DisplacementMapFilter(dbmd,
									   new Point(0, 0),
									   BitmapDataChannel.BLUE,
									   BitmapDataChannel.GREEN,
									   width,
									   height,
									   DisplacementMapFilterMode.IGNORE);
}

//myBitmapData.draw(mirror(myBitmapData, 5));
function mirror(source:BitmapData, num_width:Number = 2){
	var bmd:BitmapData = new BitmapData(source.width, source.height, false);
	var halfWidth:int = Math.round(source.width / num_width);
	source.lock();
	bmd.copyPixels(source, new Rectangle(0, 0, halfWidth, source.height), new Point(0,0));
	for(var i:int=0;i<source.height;++i) {
		for(var j:int=0;j<halfWidth;++j) {
		  bmd.setPixel32(halfWidth + j, i, source.getPixel32(halfWidth - j, i));  
		}
	}
	source.unlock();
	return bmd;
}


function bulgeFilter(source: BitmapData, region: Rectangle = null,
	amount: Number = 0.5) {
	// wrapper method of pinchFilter
	return pinchFilter(source, region, Math.min(-amount, -1));
}

function squeezeFilter(source: BitmapData, region: Rectangle = null,
	amount: Number = 0.5) {
	// wrapper method of bulge filter 
	return pinchFilter(source, region, amount);
}



function pinchFilter(source: BitmapData, region: Rectangle = null,
	amount: Number = 0.35) {
	var width: int = source.width;
	var height: int = source.height;
	region ||= new Rectangle(0, 0, width, height); //||=
	var radius: Number = Math.min(region.width, region.height) / 2;
	var centerX: int = region.x + region.width / 2;
	var centerY: int = region.y + region.height / 2;
	var dbmd: BitmapData = new BitmapData(width, height, false, 0x8080);
	for (var y: int = 0; y < height; ++y) {
		var ycoord: int = y - centerY;
		for (var x: int = 0; x < width; ++x) {
			var xcoord: int = x - centerX;
			var d: Number = Math.sqrt(xcoord * xcoord + ycoord * ycoord);
			if (d < radius) {
				var t: Number = d == 0 ? 0 : Math.pow(Math.sin(Math.PI / 2 * d / radius), -amount);
				var dx: Number = xcoord * (t - 1) / width;
				var dy: Number = ycoord * (t - 1) / height;
				var blue: int = 0x80 + dx * 0xff;
				var green: int = 0x80 + dy * 0xff;
				dbmd.setPixel(x, y, green << 8 | blue);
			}
		}
	}
	return new DisplacementMapFilter(dbmd,
		new Point(0, 0),
		BitmapDataChannel.BLUE,
		BitmapDataChannel.GREEN,
		width,
		height,
		DisplacementMapFilterMode.CLAMP);
}



function photicTunnelFilter(source: BitmapData, region: Rectangle = null) {
	var width: int = source.width;
	var height: int = source.height;
	region ||= new Rectangle(0, 0, width, height); //||=
	var centerX: int = region.x + region.width / 2;
	var centerY: int = region.y + region.height / 2;
	var dbmd: BitmapData = new BitmapData(width, height, false, 0x8080);
	var radius: Number = Math.min(region.width, region.height) / 2;
	for (var y: int = 0; y < height; ++y) {
		var ycoord: int = y - centerY;
		for (var x: int = 0; x < width; ++x) {
			var xcoord: int = x - centerX;
			var d: Number = Math.sqrt(xcoord * xcoord + ycoord * ycoord);
			if (radius < d) {
				var angle: Number = Math.atan2(Math.abs(ycoord), Math.abs(xcoord));
				var dx: Number = (xcoord > 0 ? -1 : 1) * (d - radius) * Math.cos(angle) / width;
				var dy: Number = (ycoord > 0 ? -1 : 1) * (d - radius) * Math.sin(angle) / height;
				var blue: int = 0x80 + dx * 0xff;
				var green: int = 0x80 + dy * 0xff;
				dbmd.setPixel(x, y, green << 8 | blue);
			}
		}
	}
	return new DisplacementMapFilter(dbmd,
		new Point(0, 0),
		BitmapDataChannel.BLUE,
		BitmapDataChannel.GREEN,
		width,
		height,
		DisplacementMapFilterMode.CLAMP);
}

function strechFilter(source: BitmapData, amount: Number = 0.6) {
	var width: int = source.width;
	var height: int = source.height;
	var dbmd: BitmapData = new BitmapData(width, height, false, 0x8080);
	var centerX: int = width / 2;
	var centerY: int = height / 2;
	var vregion: Rectangle = new Rectangle(0, 0, width / 3, height);
	var hregion: Rectangle = new Rectangle(0, 0, width, height / 3);
	var blue: int;
	var green: int;
	for (var y: int = 0; y < height; ++y) {
		var ycoord: int = y - centerY;
		for (var x: int = 0; x < width; ++x) {
			var xcoord: int = x - centerX;
			var dx: int = (Math.abs(xcoord) < vregion.width) ? xcoord * (Math.pow(Math.abs(xcoord) / vregion.width, amount) - 1) : 0x0;
			var dy: int = (Math.abs(ycoord) < hregion.height) ? ycoord * (Math.pow(Math.abs(ycoord) / hregion.height, amount) - 1) : 0x0;
			blue = 0x80 + 0xff * dx / width;
			green = 0x80 + 0xff * dy / height;
			dbmd.setPixel(x, y, green << 8 | blue);
		}
	}
	return new DisplacementMapFilter(dbmd,
		new Point(0, 0),
		BitmapDataChannel.BLUE,
		BitmapDataChannel.GREEN,
		width,
		height,
		DisplacementMapFilterMode.CLAMP);
}

function fisheyeFilter(source: BitmapData, amount: Number = 0.8) {
	var width: int = source.width;
	var height: int = source.height;
	var dbmd: BitmapData = new BitmapData(width, height, false, 0x8080);
	var centerX: int = width / 2;
	var centerY: int = height / 2;
	var radius: Number = Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2));
	for (var y: int = 0; y < height; ++y) {
		var ycoord: int = y - centerY;
		for (var x: int = 0; x < width; ++x) {
			var xcoord: int = x - centerX;
			var d: Number = Math.sqrt(xcoord * xcoord + ycoord * ycoord);
			if (d < radius) {
				var t: Number = d == 0 ? 0 : Math.pow(Math.sin(Math.PI / 2 * d / radius), amount);
				var dx: Number = xcoord * (t - 1) / width;
				var dy: Number = ycoord * (t - 1) / height;
				var blue: int = 0x80 + dx * 0xff;
				var green: int = 0x80 + dy * 0xff;
				dbmd.setPixel(x, y, green << 8 | blue);
			}
		}
	}
	return new DisplacementMapFilter(dbmd,
		new Point(0, 0),
		BitmapDataChannel.BLUE,
		BitmapDataChannel.GREEN,
		width,
		height,
		DisplacementMapFilterMode.CLAMP);
}