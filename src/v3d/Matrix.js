function Matrix(a, b, c, d, tx, ty) {
  this.a = a;
  this.b = b;
  this.c = c;
	this.d = d;
	this.tx = tx;
	this.ty = ty;
}

Matrix.prototype.translate = function(dx, dy) {
  this.tx = dx;
	this.ty = dy;
}

Matrix.prototype.concat = function(m) {
  var aT = this.a;
	var cT = this.c;
	var txT = this.tx;
	this.a = aT * m.a + this.b * m.c;
	this.b = aT * m.b + this.b * m.d;
	this.c = cT * m.a + this.d * m.c;
	this.d = cT * m.b + this.d * m.d;
	this.tx = txT * m.a + this.ty * m.c + m.tx;
	this.ty = txT * m.b + this.ty * m.d + m.ty;
}

Matrix.prototype.scale = function(sx, sy) {
  var m = new Matrix(sx, 0, 0, sy, 0, 0);
	this.concat(m);
}

Matrix.prototype.identity = function() {
  this.a = 1;
	this.b = 0;
	this.c = 0;
	this.d = 1;
	this.tx = 0;
	this.ty = 0;
}

export default Matrix;
