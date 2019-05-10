function BitmapData(width, height, transparent, fillColor) {
	this._rect = null;
	this.imageData = null;
	this.image = null;
	this.bitmapBytes = null;
	this.checkTable = null;
	this.isLoaded = false;
	this.width = width;
	this.height = height;
	this.transparent = transparent;
	this.fillColor = fillColor;
	var len = width * height;
	if (len > 0) {
		var canvas = document.createElement("canvas");
		canvas.width = width;
		canvas.height = height;
		var ctx = canvas.getContext("2d");
		this.imageData = ctx.createImageData(width, height);
		if (transparent && fillColor == 0)
			len = 0;
		for (var i = 0; i < len; i++) {
			var index = i * 4;
			this.imageData.data[index + 0] = fillColor >> 16 & 0xFF;
			this.imageData.data[index + 1] = fillColor >> 8 & 0xFF;
			this.imageData.data[index + 2] = fillColor >> 0 & 0xFF;
			this.imageData.data[index + 3] = transparent ? (fillColor >> 24 & 0xFF) : 0xFF;
		}
		ctx.putImageData(this.imageData, 0, 0);
		this.image = canvas;
	}
	// this._rect = new flash.geom.Rectangle(0, 0, width, height);
};

BitmapData.prototype.draw = function(source, matrix, colorTransform, blendMode, clipRect, smoothing) {
	var sourceBitmapData = source;
	if (!sourceBitmapData || !this.image)
		return;
	if (!sourceBitmapData.image)
		return;
	var ctx = this.image.getContext("2d");
	ctx.drawImage(sourceBitmapData.image, 0, 0, sourceBitmapData.image.width * matrix.a, sourceBitmapData.image.height * matrix.d);
};

BitmapData.prototype.lock = function() {
};

BitmapData.prototype.unlock = function() {
};

BitmapData.prototype.getPixel32 = function(x, y) {
	this.bitmapBytes.position = (x + (y * this.width)) * 4;
	return this.bitmapBytes.readUnsignedInt();
};

export default BitmapData;