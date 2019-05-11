import fillRoundRect from './fillRoundRect';

var AppVals_REMIX_PERTICLE_SPEED = 1.0;
var MOSAIC_SIZE = 10;
var MPSAIC_LENGTH = 40;
var MOSAIC_NUMS = MPSAIC_LENGTH * MPSAIC_LENGTH;
var CNV = 50;
var CIRCLE = 'circle';
var SQUARE = 'square';
var ROUND_RECT = 'round_rect';
var ROUND_RECT_RADIUS = Math.ceil(MOSAIC_SIZE / 2) - 1;
var PIC_URL = 'pic4.png';
var WIDTH = 400;
var HEIGHT = 400;

function V3D13_MosaicImpl(_weakMode) {
  this._LODLevel = [];
  this.updatePointsX = [];
  this.updatePointsY = [];
  this.updatePointsLod = [];
}

V3D13_MosaicImpl.prototype.getColor = function (x, y, d) {
  var x = x * MOSAIC_SIZE;
  var y = y * MOSAIC_SIZE;
  var lod = d;
  var width = WIDTH;
  var height = HEIGHT;
  var tmpImageData = this.ctx.getImageData(0, 0, width, height);
  var tmpPixelData = tmpImageData.data;

  var i = x;
  var j = y;
  var totalr = 0, totalg = 0, totalb = 0;
  var size = MOSAIC_SIZE * lod
  var totalnum = 0
  for (var dx = 0; dx < size; dx++) {
    for (var dy = 0; dy < size; dy++) {
      var x = i + dx;
      var y = j + dy;
      var p = x  + y* width
      if (!(!tmpPixelData[p * 4 + 0] && !tmpPixelData[p * 4 + 1] && !tmpPixelData[p * 4 + 2] && !tmpPixelData[p * 4 + 3])) {
        totalr += tmpPixelData[p * 4 + 0]
        totalg += tmpPixelData[p * 4 + 1]
        totalb += tmpPixelData[p * 4 + 2]
        totalnum++;
      }
    }
  }
  var p = i  + j* width
  if (!totalnum) {
    return 'rgba(0, 0, 0, 0)';
  }
  var resr = totalr / totalnum
  var resg = totalg / totalnum
  var resb = totalb / totalnum
  return 'rgb('+resr+','+resg+','+resb+')';
}

V3D13_MosaicImpl.prototype.getColorSquare = function (x, y, d) {
  var x = x * MOSAIC_SIZE + d * MOSAIC_SIZE / 2;
  var y = y * MOSAIC_SIZE + d * MOSAIC_SIZE / 2;
  var width = WIDTH;
  var height = HEIGHT;
  var tmpImageData = this.ctx.getImageData(0, 0, width, height);
  var tmpPixelData = tmpImageData.data;

  var i = x;
  var j = y;
  var totalr = 0, totalg = 0, totalb = 0;
  var size = 1
  var totalnum = size * size
  for (var dx = 0; dx < size; dx++) {
    for (var dy = 0; dy < size; dy++) {
      var x = i + dx;
      var y = j + dy;
      var p = x  + y* width
      totalr += tmpPixelData[p * 4 + 0]
      totalg += tmpPixelData[p * 4 + 1]
      totalb += tmpPixelData[p * 4 + 2]
    }
  }
  var p = i  + j* width
  var resr = totalr / totalnum
  var resg = totalg / totalnum
  var resb = totalb / totalnum
  return 'rgb('+resr+','+resg+','+resb+')';
}

V3D13_MosaicImpl.prototype.drawCircle = function (x, y, d) {
  var color = this.getColor(x, y, d);
  this.ctx.clearRect(x * MOSAIC_SIZE, y * MOSAIC_SIZE, d * MOSAIC_SIZE, d * MOSAIC_SIZE);
  this.ctx.beginPath();
  this.ctx.fillStyle = color;
  this.ctx.arc(x * MOSAIC_SIZE + d * MOSAIC_SIZE / 2, y * MOSAIC_SIZE + d * MOSAIC_SIZE / 2, d * MOSAIC_SIZE / 2, 0, Math.PI * 2, true);
  this.ctx.fill();
  this.ctx.closePath();
}

V3D13_MosaicImpl.prototype.drawSquare = function (x, y, d, getColorFromCenter = false) {
  var color;
  if (getColorFromCenter) {
    color = this.getColorSquare(x, y, d);
  } else {
    color = this.getColor(x, y, d);
  }
  this.ctx.clearRect(x * MOSAIC_SIZE, y * MOSAIC_SIZE, d * MOSAIC_SIZE, d * MOSAIC_SIZE);
  this.ctx.beginPath();
  this.ctx.fillStyle = color;
  this.ctx.fillRect(x * MOSAIC_SIZE, y * MOSAIC_SIZE, d * MOSAIC_SIZE, d * MOSAIC_SIZE);
  this.ctx.fill();
  this.ctx.closePath();
}

V3D13_MosaicImpl.prototype.drawRoundRect = function (x, y, d) {
  var color = this.getColor(x, y, d);
  this.ctx.clearRect(x * MOSAIC_SIZE, y * MOSAIC_SIZE, d * MOSAIC_SIZE, d * MOSAIC_SIZE);
  fillRoundRect(this.ctx, x * MOSAIC_SIZE, y * MOSAIC_SIZE, d * MOSAIC_SIZE, d * MOSAIC_SIZE, ROUND_RECT_RADIUS, color);
} 

V3D13_MosaicImpl.prototype.drawCircleType = function () {
  this.mirror.forEach(v => {
    if (!!v) {
      var x = v[0];
      var y = v[1];
      var d = v[2];
      this.drawCircle(x, y, d);
    }
  });
}

V3D13_MosaicImpl.prototype.drawSquareType = function () {
  this.mirror.forEach(v => {
    if (!!v) {
      var x = v[0];
      var y = v[1];
      var d = v[2];
      this.drawSquare(x, y, d, true);
    }
  });
}

V3D13_MosaicImpl.prototype.drawRoundRectType = function () {
  this.mirror.forEach(v => {
    if (!!v) {
      var x = v[0];
      var y = v[1];
      var d = v[2];
      this.drawRoundRect(x, y, d, true);
    }
  });
}

V3D13_MosaicImpl.prototype.changeType = function(type) {
  if (type === CIRCLE) {
    this.type = CIRCLE;
    this.drawCircleType();
  } else if (type === ROUND_RECT) {
    this.type = ROUND_RECT;
    this.drawRoundRectType();
  } else if (type === SQUARE) {
    this.type = SQUARE;
    this.drawSquareType();
  }
}

V3D13_MosaicImpl.prototype.init = function (canvas, width, height) {
  this.type = SQUARE;
  this.canvas = canvas;
  this.ctx = this.canvas.getContext('2d');
  this.canvas.width = width;
  this.canvas.height = height;
  var self = this;
  var img = new Image();
  img.src = PIC_URL;
  img.onload = function () {
    self.ctx.drawImage(img, 0, 0, WIDTH, HEIGHT);
    var srcBmd = self.ctx.getImageData(0, 0, WIDTH, HEIGHT);
    self.generateMipmapWithBitmap(srcBmd, WIDTH, HEIGHT);
  }

  this._LODLevel = new Array(MOSAIC_NUMS).fill(1).map((v, i) => {
    var x = i % MPSAIC_LENGTH;
    var y = Math.floor(i / MPSAIC_LENGTH);
    return ([x, y, 1, i]);
  });
  this.mirror = new Array(MOSAIC_NUMS).fill(1).map((v, i) => {
    var x = i % MPSAIC_LENGTH;
    var y = Math.floor(i / MPSAIC_LENGTH);
    return ([x, y, 1, i]);
  });

  this.canvas.addEventListener('mousedown', this.startEvent.bind(this), !1);
}

V3D13_MosaicImpl.prototype.generateMipmapWithBitmap = function (_org, width, height) {
  var imageData = this.ctx.getImageData(0, 0, width, height);
  var pixelData = imageData.data;
  var tmpImageData = this.ctx.getImageData(0, 0, width, height);
  var tmpPixelData = tmpImageData.data;

  var size = MOSAIC_SIZE
  var totalnum = size * size
  for (var i = 0; i < height; i += size) {
    for (var j = 0; j < width; j += size) {
      var totalr = 0, totalg = 0, totalb = 0;
      for (var dx = 0; dx < size; dx++) {
        for (var dy = 0; dy < size; dy++) {
          var x = i + dx;
          var y = j + dy;
          var p = x  + y* width
          totalr += tmpPixelData[p * 4 + 0]
          totalg += tmpPixelData[p * 4 + 1]
          totalb += tmpPixelData[p * 4 + 2]
        }
      }
      var p = i  + j* width
      var resr = totalr / totalnum
      var resg = totalg / totalnum
      var resb = totalb / totalnum
      for (var dx = 0; dx < size; dx++) {
        for (var dy = 0; dy < size; dy++) {
          var x = i + dx;
          var y = j + dy;
          var p = x  + y* width
          pixelData[p * 4 + 0] = resr
          pixelData[p * 4 + 1] = resg
          pixelData[p * 4 + 2] = resb
        }
      }
    }
  }
  this.ctx.putImageData(imageData, 0, 0, 0, 0, width, height)
}

V3D13_MosaicImpl.prototype.startEvent = function (t) {
  t.preventDefault();
  t.stopPropagation();
  this.addedForce();
  this.draw();
}

V3D13_MosaicImpl.prototype.draw = function () {
  this.updatePointsX.forEach((v, i) => {
    var x = this.updatePointsX[i];
    var y = this.updatePointsY[i];
    var lod = this.updatePointsLod[i];
    if (this.type === SQUARE) {
      this.drawSquare(x, y, lod);
    } else if (this.type === CIRCLE) {
      this.drawCircle(x, y, lod);
    } else if (this.type === ROUND_RECT) {
      this.drawRoundRect(x, y, lod);
    }
    return;
  });
  this.updatePointsX = [];
  this.updatePointsY = [];
  this.updatePointsLod = [];
}

V3D13_MosaicImpl.prototype.addedForce = function () {
  var self = this;
  var x;
  var y;
  var d;
  var td;
  var index;
  var node;

  for (let i = 0; i < CNV * AppVals_REMIX_PERTICLE_SPEED; i++) {
    LABEL_RESTART_RANDOM(self);
  }

  function LABEL_RESTART_RANDOM(self) {
    index = Math.floor(self._LODLevel.length * Math.random());
    node = self._LODLevel[index];
    x = node[0];
    y = node[1];
    d = node[2];
    td = d === 8 ? 8 : 2 * d;

    LABEL_RESTART(self);
  }

  function LABEL_RESTART(self) {
    if (x % 2 === 1) {
      x = x -1;
    } else {
      if (Math.floor(x / d) % 2 === 1) {
        x = x - d;
      }
    }
    if (y % 2 === 1) {
      y = y - 1;
    } else {
      if (Math.floor(y / d) % 2 === 1) {
        y = y - d;
      }
    }
    
    for (var ly = y; ly < y + td; ly++) {
      for (var lx = x; lx < x + td; lx++) {
        self._LODLevel.forEach((v, i) => {
          if (v && v[0] === lx && v[1] === ly) {
            if (v && v[0] === x && v[1] === y) {
              v[2] = td;
            } else {
              self._LODLevel[i] = undefined;
            }
          }
        });
        self.mirror.forEach((v, i) => {
          if (v && v[0] === lx && v[1] === ly) {
            if (v && v[0] === x && v[1] === y) {
              v[2] = td;
            } else {
              self.mirror[i] = undefined;
            }
          }
        });
      }
    }
    self._LODLevel = self._LODLevel.filter(v => !!v);
    self.updatePointsX.push(x);
    self.updatePointsY.push(y);
    self.updatePointsLod.push(td);
  }
}

export default V3D13_MosaicImpl;