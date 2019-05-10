var AppVals_REMIX_PERTICLE_SPEED = 1.0;
var MOSAIC_SIZE = 10;
var MPSAIC_LENGTH = 40;
var MOSAIC_NUMS = MPSAIC_LENGTH * MPSAIC_LENGTH;
var CNV = 45;
var IMG_SRC = 'pic5.png';
var CANVAS_WIDTH = 400;
var CANVAS_HEIGHT = 400;
function goto(func, self) {
  func(self);
}

function V3D13_MosaicImpl(_weakMode) {
  //     this._texture= null;//Texture;
  this.scale = 1;
  this.position = 0;
  this._mipmaps = new Array(9);//Vector.<BitmapData>;
  this._LODLevel = [];//ByteArray;
  this._martigX = null;//Number;f
  // this._martigY= null;//Number;
  this.mUniformColor = [];//原来代码没定义直接使用了，这里定义了一下
  //     this.mUniformMatrix=[];//原来代码没定义直接使用了，这里定义了一下

  this.margin = 7;//Number=7;
  this.InMargin = 106 / 102;//Number=106/102;

  this._lodSum = 0; //private var _lodSum:uint=0; 
  //     this._lod1Count=0//private var _lod1Count:int=0;
  this.maxCellLod = null;//public var maxCellLod:uint;
  // this.maxCellNum=null;//public var maxCellNum:uint;
  this._bUpdated = null;//Boolean;
  this._lod1Count = 0;
  // this._bClear= null;//Boolean;		
  this.updatePointsX = [];//Vector.<uint>=new Vector.<uint>;
  this.updatePointsY = [];//Vector.<uint>=new Vector.<uint>;
  this.updatePointsLod = [];//Vector.<uint>=new Vector.<uint>;

  // this.srcViewId= null;//int;

  //     this._enableTransparentWhite= null;//Boolean;
  //     //super(_weakMode);

  //     this.textureIndex= 2;//int;	

  // this._mozWidth= 16*5/2;//int;
  //     this._mozHeight= 16*6/2;//int;
  this._mosicRemderSize = 23.9 * 2;//Number;

  //     if(_weakMode){
  //         this._mozWidth*=3/2.0;
  //         this._mozHeight*=3/2.0;
  //         this._mosicRemderSize*=2/3.0;
  //     }

  //     //是两边空白的大小吗？
  this._martigX = 0;
  this._martigY = 0;
  // this._martigX=(UTItemManager.IMAGE_WIDTH-this._mosicRemderSize*this._mozWidth)*.5;//-_mosicRemderSize*.5;;
  //     this._martigY=(UTItemManager.IMAGE_HEIGHT-this._mosicRemderSize*this._mozHeight)*.5;//-_mosicRemderSize*.5;;

  //     //trace(_mozWidth,_mozHeight,_martigX,_martigY);  //？？？？bug


  //     this._LODLevel=[];
  //     //_LODLevel.position=0;
  //     while(this._LODLevel.length<this._mozWidth*this._mozHeight){
  //         this._LODLevel.push(1);
  //     }

  //     this._enableTransparentWhite=false;//AppVals.HISTORY==0;
  //srcViewId=UTCreateMain.getActiveSrcType();
}

V3D13_MosaicImpl.prototype.init = function (canvas, width, height) {
  this.canvas = canvas;
  this.ctx = this.canvas.getContext('2d');
  this.canvas.width = width;
  this.canvas.height = height;
  var self = this;
  var img = new Image();
  img.src = IMG_SRC;
  img.onload = function () {
    self.ctx.drawImage(img, 0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
    var srcBmd = self.ctx.getImageData(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
    self.generateMipmapWithBitmap(srcBmd, CANVAS_WIDTH, CANVAS_HEIGHT);
  }

  this._LODLevel = new Array(MOSAIC_NUMS).fill(1).map((v, i) => {
    var x = i % MPSAIC_LENGTH;
    var y = Math.floor(i / MPSAIC_LENGTH);
    return ([x, y, 1, i]);
  });
  this.maxCellLod = 40 * 40;

  this.canvas.addEventListener('mousedown', this.startEvent.bind(this), !1);
}

V3D13_MosaicImpl.prototype.generateMipmapWithBitmap = function (_org, width, height) {
  var imageData = this.ctx.getImageData(0, 0, width, height);
  var pixelData = imageData.data;
  var tmpImageData = this.ctx.getImageData(0, 0, width, height);
  var tmpPixelData = tmpImageData.data;
  console.log(tmpImageData);

  var size = MOSAIC_SIZE//马赛克方块的边长
  var totalnum = size * size
  //此处循环需从1开始，..-1结束，否则在里面的二层循环（dx=-1,dy=-1）就会越界
  for (var i = 0; i < height; i += size) {
    for (var j = 0; j < width; j += size) {
      var totalr = 0, totalg = 0, totalb = 0;
      //一个像素点周围的加上自身
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
      var p = i  + j* width//每个像素点
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
  // this.ctx.clear();
  this.ctx.putImageData(imageData, 0, 0, 0, 0, width, height)
}

V3D13_MosaicImpl.prototype.getXY = function (t) {
  const i = t.touches ? t.touches[0].clientX : t.clientX;

  const e = t.touches ? t.touches[0].clientY : t.clientY;
  return {
    x: i - this.canvas.offsetLeft + (document.body.scrollLeft || document.documentElement.scrollLeft),
    y: e - this.canvas.offsetTop + (document.body.scrollTop || document.documentElement.scrollTop),
  };// 返回坐标对象
};

V3D13_MosaicImpl.prototype.startEvent = function (t) {
  t.preventDefault();
  t.stopPropagation();
  let i = this.getXY(t);
  this.addedForce(i.x, i.y);
  this.draw();
}

V3D13_MosaicImpl.prototype.draw = function () {
  console.log(this.updatePointsX);
  console.log(this.updatePointsY);
  console.log(this.updatePointsLod);
  console.log(this._LODLevel.length);
  // return;
  
  var width = CANVAS_WIDTH;
  var height = CANVAS_HEIGHT;
  var imageData = this.ctx.getImageData(0, 0, width, height);
  var pixelData = imageData.data;
  //创建作为参考的像素
  var tmpImageData = this.ctx.getImageData(0, 0, width, height);
  var tmpPixelData = tmpImageData.data;


  this.updatePointsX.forEach((v, i) => {
    var x = this.updatePointsX[i] * MOSAIC_SIZE;
    var y = this.updatePointsY[i] * MOSAIC_SIZE;
    var lod = this.updatePointsLod[i];

    var i = x;
    var j = y;
    var totalr = 0, totalg = 0, totalb = 0;
    var size = MOSAIC_SIZE * lod
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
  });
  this.updatePointsX = [];
  this.updatePointsY = [];
  this.updatePointsLod = [];
  this.ctx.clearRect(0, 0, width, height);
  this.ctx.putImageData(imageData, 0, 0, 0, 0, width, height)
}

V3D13_MosaicImpl.prototype.addedForce = function (_x, _y) {
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
    // console.log("index: " + index)
    node = self._LODLevel[index];
    // console.log(node);
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
        // if (lx === x && ly === y) {
        //   // self._LODLevel[lx + 40 * ly][2] = td;
        // } else {
        //   self._LODLevel[lx + 40 * ly] = undefined;
        // }
      }
    }
    self._LODLevel = self._LODLevel.filter(v => !!v);
    // console.log(self._LODLevel.filter(v => v[2] !== 1));
    self.updatePointsX.push(x);
    self.updatePointsY.push(y);
    self.updatePointsLod.push(td);
  }
}

export default V3D13_MosaicImpl;