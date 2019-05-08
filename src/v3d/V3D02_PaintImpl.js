function PVVectprField() {
  this._buffer = null;
  this.cols = null;
  this.rows = null;
  this.cols_m1 = null;
  this.rows_m1 = null;
  this.width = null;
  this.height = null;
  this.nTotal = null;
  this.nTotalx2 = null;
  this.outX = null;
  this.outY = null;
  this.fieldPosX = null;
  this.fieldPosY = null;
  this.mPos = null;
}

function PVParticle() {
  this.flg = false;// 原来为!1
  this.angle = 0;
  this.scale = 0;
  this.int = 0;// texIndex
  this.velX = 0;
  this.posX = 0;
  this.velY = 0;
  this.posY = 0;
  this.life = 0;
  this.damping = 0.1;// public var damping:Number = 0.15;
  this.r = 0;
  this.g = 0;
  this.b = 0;
}

// 改变颜色
V3D02_PaintImpl.prototype.changeColor = function (color) {
  this.isEraser = false;// 关闭橡皮
  this.mActiveColor = color;
};

// 改变宽度
V3D02_PaintImpl.prototype.changeWidth = function (width) {
  this.penWidth = width;
  return this.penWidth;
};

PVVectprField.prototype.setupField = function (cols, rows, width, height) {
  this.cols = cols;
  this.rows = rows;
  this.cols_m1 = this.cols - 1;
  this.rows_m1 = this.rows - 1;
  this.width = width;
  this.height = height;
  this.nTotal = this.cols * this.rows;
  this.nTotalx2 = 2 * this.nTotal;
  this.dispose();
  // x、y坐标交替存储 喷溅偏移量
  this._buffer = new Array();
  for (let i = 0; i < this.nTotalx2; i++) {
    this._buffer.push(0);
  }
};

PVVectprField.prototype.dispose = function () {
  this._buffer = null;
};

PVVectprField.prototype.clear = function () {
  for (let t = 0; t < this.nTotalx2; t++) {
    this._buffer[t] = 0;
  }
};

PVVectprField.prototype.getForceFromPos = function (xpos, ypos) {
  xpos /= this.width;
  ypos /= this.height;
  if (xpos < 0 || xpos > 1 || ypos < 0 || ypos > 1) {
    this.outX = 0;
    this.outY = 0;
  } else {
    this.fieldPosX = xpos * this.cols;
    this.fieldPosY = ypos * this.rows;
    this.mPos = 2 * Math.trunc(this.fieldPosY * this.cols + this.fieldPosX);
    this.outX = 0.1 * this._buffer[this.mPos];
    this.outY = 0.1 * this._buffer[this.mPos + 1];
  }
};

// mVF.addVectorCircle(p_x , p_y, d_x*0.5, d_y*0.5, 80, 0.3);
PVVectprField.prototype.addVectorCircle = function (that, x, y, color, d_x, d_y) {
  let colorR = ((color >> 16) & 255);
  let colorG = ((color >> 8) & 255);
  let colorB = ((color >> 0) & 255);
  // that.drawTriangles([x,y,0,500],[colorR,colorG,colorB,1])
  let ctx = that.ctx;
  // that.ctx.fillStyle = `rgba(${colorR}, ${colorG}, ${colorB}, 1)`;
  // that.ctx.beginPath();
  // that.ctx.arc(x, y,20, 0, 2*Math.PI);
  // that.ctx.fill();

  ctx.strokeStyle = `rgba(${colorR}, ${colorG}, ${colorB}, 1)`;
  ctx.lineCap = 'round';
  ctx.lineWidth = 40;
  ctx.beginPath();
  ctx.moveTo(x, y);
  ctx.lineTo(d_x, d_y);
  ctx.stroke();
  // var distance, j, pos, i = 0;
  // 	//是所传点横坐标的所占列数
  // var	fieldPosX = x / this.width * this.cols;
  // var	fieldPosY = y / this.height * this.rows;
  // var	fieldRadius = radius / this.width * this.cols;
  // 	//所画圆的左上角
  // var	startx = fieldPosX - fieldRadius;
  // var	starty = fieldPosY - fieldRadius;
  // 	//所画圆的右下角
  // var	endx = fieldPosX + fieldRadius;
  // var	endy = fieldPosY + fieldRadius;

  // if(startx < 0){
  // 	startx = 0;
  // }
  // if(starty < 0){
  // 	starty = 0
  // }
  // if(endx > this.cols){
  // 	endx = this.cols;
  // }
  // if(endy > this.rows){
  // 	endy = this.rows;
  // }

  // for(i = startx; i < endx; i++) {
  // 	for(j = starty; j < endy; j++) {

  // 		pos = 2 * (j * this.cols + i);
  // 		distance = Math.sqrt((fieldPosX - i) * (fieldPosX - i) + (fieldPosY - j) * (fieldPosY - j));

  // 		if (distance < 0.0001)
  // 			distance = 0.0001;
  // 		if(distance < fieldRadius) {
  // 			distance = 1 - (distance / fieldRadius);
  // 			distance *= strength;
  // 			this._buffer[Math.floor(pos)] += vx * distance;
  // 			this._buffer[Math.floor(pos+1)] += vy * distance;
  // 		}
  // 	}
  // }
};

PVVectprField.prototype.fadeField = function (fadeAmount) {
  for (let i = 0; i < this.nTotalx2; i++) {
    let e = Math.trunc(i);
    this._buffer[e] *= fadeAmount;
  }
};

PVParticle.prototype.setInitialCondition = function (px, py, vx, vy, lifeTimes) {
  this.posX = px;
  this.posY = py;
  this.velX = vx;
  this.velY = vy;
  this.life = lifeTimes;
};

PVParticle.prototype.setVFupdate = function (x, y) {
  this.velX = this.velX + (x - this.velX * this.damping);
  this.velY = this.velY + (y - this.velY * this.damping);
  this.posX = this.posX + this.velX;
  this.posY = this.posY + this.velY;
  this.life = this.life - 1;
};

const STAGE_GLOBAL_DRAWABLE_CENTERY = 0;

const ScaleMaxPaint = 1.16;

const ScaleMin = 0.6;

const IMAGE_WIDTH = 398;

const IMAGE_HEIGHT = 500;

const IMAGE_MARGIN_Y = 12;

const IMAGE_MARGIN_X = 25;

const PAINT_RADIUS = 2;

function Easing() {
}

Easing.prototype.easeOutQuart = function (t, i, e, s) {
  return -e * ((t = t / s - 1) * t * t * t - 1) + i;
};

Easing.prototype.easeInOutQuart = function (t, i, e, s) {
  return (t /= s / 2) < 1 ? e / 2 * t * t * t * t + i : -e / 2 * ((t -= 2) * t * t * t - 2) + i;
};
const colorCols = [
  [13209, 15073299, 16773120, 0],
  [16727423, 16752285, 16771491, 10013846, 4176047],
  [15466892, 3342540],
  [16764159, 10079385],
  [16776960, 13421772],
  [0, 13092817, 16711680],
  [0, 5329233, 8750469],
  [26367, 16763904, 16711680],
  [15073299, 16694244, 16772608, 3059457, 45013, 3215303, 15466892, 0],
];

const easing = new Easing();

function V3D02_PaintImpl() {
  this.penWidth = 50;
}

var draw;

V3D02_PaintImpl.prototype.init = function (canvas, width, height) {
  this.canvas = canvas;
  this.ctx = this.canvas.getContext('2d');
  // this.canvas.width = 2048
  // this.canvas.height = 2304
  this.canvas.width = width;
  this.canvas.height = height;
  this.mParticles = [];
  this.mVF = new PVVectprField();
  // 第一种解释：把宽高分成630份
  // 第二种解释：把宽高按630长度均分
  // this.mVF.setupField(2048 / 75, 2304 / 75, 2048, 2304),
  this.isEraser = false;
  this.mVF.setupField(width / 30, height / 30, width, height);
  this.moveFlag = !1;
  this.isZoom = !1;
  this._toScale = 0;
  this._frScale = null;
  this._ticktime = null;
  this._zoomTryed = !1;
  this._drawingEnabled = !0;
  // this.mStageWidth = 800;
  // this.mStageHeight = 800;
  this.currentScale = 1.16;
  // this.mResolutionScale = 398 / window.innerWidth;
  this.mColorRandRange = 1;
  this.mActiveColor = 13209;
  this._eraseMode = !1;
  this.mFudeSize = 1.2;
  this.mUniformMatrix = new Array(4);
  this.mUniformColor = new Array(4);
  this.canvas.addEventListener('touchstart', this.startEvent.bind(this), !1);
  this.canvas.addEventListener('mousedown', this.startEvent.bind(this), !1);
  this.canvas.addEventListener('touchmove', this.moveEvent.bind(this), !1);
  this.canvas.addEventListener('mousemove', this.moveEvent.bind(this), !1);
  this.canvas.addEventListener('touchend', this.endEvent.bind(this), !1);
  this.canvas.addEventListener('mouseup', this.endEvent.bind(this), !1);
  this.textureParticle = [];

  // let img1= new Image();
  // img1.src = '../../../img/TextureParticle/01.png';
  // this.textureParticle.push(img1);
  // let img2 = new Image();
  // img2.src = '../../../img/TextureParticle/02.png';
  // this.textureParticle.push(img2)
  // let img3 = new Image();
  // img3.src = '../../../img/TextureParticle/03.png';
  // this.textureParticle.push(img3)
  // let img4 = new Image();
  // img4.src = '../../../img/TextureParticle/04.png';
  // this.textureParticle.push(img4)
  // let img5 = new Image();
  // img5.src = '../../../img/TextureParticle/05.png';
  // this.textureParticle.push(img5)
  // let img6 = new Image();
  // img6.src = '../../../img/TextureParticle/06.png';
  // this.textureParticle.push(img6)
  // let img7 = new Image();
  // img7.src = '../../../img/TextureParticle/07.png';
  // this.textureParticle.push(img7)

  this.animloop();
};

V3D02_PaintImpl.prototype.animloop = function () {
  window.requestAnimFrame(this.animloop.bind(this));
  this.onEnterFrame();
};

// t是触发的事件  该方法对应convertMousePos进行坐标转换
V3D02_PaintImpl.prototype.getXY = function (t) {
  const i = t.touches ? t.touches[0].clientX : t.clientX;

  const e = t.touches ? t.touches[0].clientY : t.clientY;
  return {
    x: i - this.canvas.offsetLeft + (document.body.scrollLeft || document.documentElement.scrollLeft),
    y: e - this.canvas.offsetTop + (document.body.scrollTop || document.documentElement.scrollTop),
  };// 返回坐标对象
};
// onMousePress
V3D02_PaintImpl.prototype.startEvent = function (t) {
  t.preventDefault(); // 阻止默认事件
  t.stopPropagation();// 阻止默认事件
  let i = this.getXY(t);// i是坐标对象
  this.mPrevMouseX = i.x;
  this.mPrevMouseY = i.y;
  this.mPrevDiffX = 0;
  this.mPrevDiffY = 0;
  this.moveFlag = true; //! 0
};
// x
let tmp = 0;
V3D02_PaintImpl.prototype.moveEvent = function (t) {
  if (t.preventDefault(), t.stopPropagation(), !this.moveFlag) {
    return;
  }

  let curMousePostion = this.getXY(t);
  // 鼠标移动到的当前点
  let pos_x = curMousePostion.x;
  let pos_y = curMousePostion.y;
  if (this.isEraser) {
    // console.log('进入橡皮分支',this.isEraser)
    this.resetEraser(pos_x, pos_y);
  } else {
    // 鼠标间隔
    let diff_x = pos_x - this.mPrevMouseX;
    let diff_y = pos_y - this.mPrevMouseY;
    let v = Math.max(Math.sqrt(diff_x * diff_x + diff_y * diff_y) / 30, 1.0);
    // console.log('u',u)

    // console.info(curMousePostion)
    for (let i = 0; i < v; i++) {
      let f = (i + 1) / v;
      let p_x = pos_x - this.mPrevMouseX;
      let p_y = pos_y - this.mPrevMouseY;
      // p_x此时表示把AB的横向距离分成u份*的前i+1份*
      p_x *= f;
      p_y *= f;
      // p_x此时表示第i次遍历的目标坐标
      p_x = this.mPrevMouseX + p_x;
      p_y = this.mPrevMouseY + p_y;
      // d_x此时表示本次AB距离差和上次AB距离差的差，有可能是负数
      let d_x = diff_x - this.mPrevDiffX;
      let d_y = diff_y - this.mPrevDiffY;
      // d_x此时表示。。。。前i+1份，有可能是负数
      d_x *= f;
      d_y *= f;
      // d_x此时表示上一次偏移量加上本次偏移量
      d_x = this.mPrevDiffX + d_x;
      d_y = this.mPrevDiffY + d_y;
      let strength = 0.2 + Math.min(this.mFudeSize, Math.sqrt(d_x * d_x + d_y * d_y) / 50.0);
      // 第二个参数原来是80
      // this.mVF.addVectorCircle(this,p_x, p_y, 0.5 * d_x, 0.5 * d_y, 20, 0.2);
      this.mVF.addVectorCircle(this, this.mPrevMouseX, this.mPrevMouseY, this.mActiveColor, p_x, p_y);

      // j的遍历越多，点越密集
      for (let j = 0; j < 10; j++) {
        let possibility = this._eraseMode ? 1000 : 1000 * Math.random();
        let particle = new PVParticle();
        particle.angle = 720 * Math.random();
        particle.flg = false;
        let color;
        if (Math.random() < 0.1) {
          let coladd = 255 * (Math.random() * this.mColorRandRange - 0.5 * this.mColorRandRange);
          let colorR = ((this.mActiveColor >> 16) & 255) + coladd;
          let colorG = ((this.mActiveColor >> 8) & 255) + coladd;
          let colorB = ((this.mActiveColor >> 0) & 255) + coladd;

          colorR = colorR < 0 ? 0 : (colorR > 255 ? 255 : colorR);
          colorG = colorG < 0 ? 0 : (colorG > 255 ? 255 : colorG);
          colorB = colorB < 0 ? 0 : (colorB > 255 ? 255 : colorB);

          color = (colorR << 16) | (colorG << 8) | (colorB);
        } else {
          color = this.mActiveColor;
        }
        particle.r = color >> 16 & 255;
        particle.g = color >> 8 & 255;
        particle.b = color >> 0 & 255;
        // -50~50
        let pR_x = 100 * Math.random() - 50;
        let pR_y = 100 * Math.random() - 50;
        // 正方形内一点到中心的距离
        let f = Math.sqrt(pR_x * pR_x + pR_y * pR_y);
        // 把随机的点缩放到中心点一单位以内
        pR_x /= f;
        pR_y /= f;
        // -25~25
        // 此处需要用笔画宽度控制

        let c = Math.random() * 50 - 25;
        pR_x *= c;
        pR_y *= c;
        // 随机出来一个随机方向，但长度在0~25以内
        if (possibility < 10) {
          // 这个表示笔画两侧（-50~50）的随机点
          if (Math.random() < 0.1) {
            // 千分之一
            particle.scale = Math.random() * 6.0;
          } else {
            // 千分之九
            particle.scale = Math.random() * 3.0;
          }
          particle.setInitialCondition(p_x + Math.random() * 100 - 50, p_y + Math.random() * 100 - 50, 0, 0, 0);
          particle.texIndex = Math.random() * 6;
        } else if (possibility < 30) {
          // 这个表示惯性喷溅距离
          // 百分之二
          if (Math.random() < 0.1) {
            // 千分之二
            particle.scale = Math.random() * 4.0;
            particle.texIndex = 1;
          } else {
            particle.scale = Math.random() * 0.5 + 1.0;
            particle.texIndex = Math.random() * 6;
          }

          let pw = Math.random() * 0.7 + 0.3;
          // particle.scale*=0.5;
          // pw*=0.5;
          particle.setInitialCondition(p_x + d_x * pw * 15, p_y + d_y * pw * 15, 0, 0, 0);
        } else if (possibility < 50) {
          // 这个表示惯性喷溅距离+透明度+流动
          /// /百分之二
          let pw = Math.random() * 0.7 + 0.3;
          particle.scale = Math.random() * 0.5 + 1.0;
          // 表示在点（p_x,p_y）处附近随机一点，指定
          // 这个表示手臂
          // particle.scale*=0.5;
          // pw*=0.5;
          particle.setInitialCondition(p_x + pR_x, p_y + pR_y, d_x * pw, d_y * pw, 30 * Math.pow(strength, 0.7));
          particle.texIndex = 0;
          particle.flg = true;
        } else {
          // 百分之95
          particle.setInitialCondition(p_x + pR_x, p_y + pR_y, d_x * 0.2, d_y * 0.2, 30);
          // if(pR_x*pR_x+pR_y*pR_y>150){
          // 	particle.setInitialCondition(  p_x+pR_x , p_y+pR_y,  d_x*0.1, d_y*0.1,30);
          // }else{
          // 	particle.setInitialCondition(  p_x+pR_x , p_y+pR_y,  d_x*0.1, d_y*0.1,30);
          // }
          particle.texIndex = Math.random() < 0.2 ? 1 : 0;
          particle.scale = Math.random() * 0.3 + 1.2;
        }
        ;
        particle.scale *= 1.2;
        particle.scale *= strength * 50;
        this.mParticles.push(particle);
        // 此处表示点密度，总点数是固定的，画的长度超出一定程度，会出现类似没有墨的感觉
        // 注释掉则表示不限制
        if (this.mParticles.length > 500) {
          let anyoneTop250 = 250 * Math.random();
          this.mParticles.splice(anyoneTop250, 1);
        }
      }
    }
    this.mPrevDiffX = diff_x;
    this.mPrevDiffY = diff_y;
    this.mPrevMouseX = pos_x;
    this.mPrevMouseY = pos_y;
  }
};

V3D02_PaintImpl.prototype.endEvent = function (e) {
  e.preventDefault();
  e.stopPropagation();
  this.moveFlag = false;//! 1
};

V3D02_PaintImpl.prototype.clearCanvas = function () {
  this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
};

V3D02_PaintImpl.prototype.onEnterFrame = function () {
  let t;
  if (this._drawingEnabled) {
    // this.ctx.fillStyle = "rgba(0, 0, 0, 0)";
    // this.mUniformMatrix[0] = 0
    // this.mUniformMatrix[1] = 0
    // this.mUniformMatrix[2] = 0
    // this.mUniformMatrix[3] = 1024
    // this.mUniformColor[0] = 1
    // this.mUniformColor[1] = 1
    // this.mUniformColor[2] = 1
    // this.drawTriangles(this.mUniformMatrix, this.mUniformColor)
    this.draw();
    // this.mUniformMatrix[0] = 0
    // this.mUniformMatrix[1] = 0
    // this.mUniformMatrix[2] = 0
    // this.mUniformMatrix[3] = 1
    // this.mUniformColor[0] = 1
    // this.mUniformColor[1] = 1
    // this.mUniformColor[2] = 1
    // this.ctx.fillStyle = "rgba(0, 0, 0, 0)"
    // this.mUniformMatrix[1] = 0
    // this.mUniformMatrix[3] = 1024
    // this.drawTriangles(this.mUniformMatrix, this.mUniformColor)
  }
  // this.ctx.fillStyle = "rgba(1, 1, 1, 1)";
  // this.mUniformColor[0] = 1;
  // this.mUniformColor[1] = 1;
  // this.mUniformColor[2] = 1;
  // this.mUniformMatrix[0] = 0;
  // this.mUniformMatrix[2] = 0;
  // let i = this.mStageWidth * this.currentScale;
  // this.mUniformMatrix[1] = 0;
  // this.mUniformMatrix[3] = 1.125 * i * 1.81;
  // this.drawTriangles(this.mUniformMatrix, this.mUniformColor);
  // this.mUniformMatrix[1] = 1.125 * -i * -.016 + 0;
  // this.mUniformMatrix[3] = i;
  // this.drawTriangles(this.mUniformMatrix, this.mUniformColor);
  if (this.isZoom) {
    // if(1.16 != this._toScale){
    // 	this._toScale = 1.16
    // 	this._frScale = this.currentScale
    // 	this._ticktime = (new Date()).getTime()
    // }
    if (this._toScale != 1) {
      this._toScale = 1;
      this._frScale = this.currentScale;
      this._ticktime = (new Date()).getTime();
    }
  } else {
    // if(.6 != this._toScale){
    // 	this._toScale = .6
    // 	this._frScale = this.currentScale
    // 	this._ticktime = (new Date).getTime()
    // }
    if (this._toScale != 0) {
      this._toScale = 0;
      this._frScale = this.currentScale;
      this._ticktime = (new Date()).getTime();
    }
  }
  if (this.currentScale != this._toScale && this._drawingEnabled) {
    let v = (new Date().getTime() - this.__ticktime) / 1000 * 0.3;
    if (v > 1.0) {
      v = 1;
      this.currentScale = this._toScale;
      // _currentRect= UTItemManager.getZoomRectMotion(currentScale,_mcWidth,_mcHeight);
    }
    // (this._zoomTryed ? ((t = ((new Date).getTime() - this._ticktime) / 400) > 1 && (t = 1), t = easing.easeOutQuart(t, 0, 1, 1)) : ((t = ((new Date).getTime() - this._ticktime) / 1e3) > 1 && (t = 1, this._zoomTryed = !0), t = easing.easeInOutQuart(t, 0, 1, 1)), this.currentScale = this._frScale + (this._toScale - this._frScale) * t)
  }
};

V3D02_PaintImpl.prototype.getZoomRectMotion = function () {
  // TODO
};

V3D02_PaintImpl.prototype.draw = function () {
  let num = this.mParticles.length;
  if (num > 0) {
    if (this.__eraseMode) {

    } else {

    }
    // console.info(1)
    // mCtx3D.setVertexBufferAt(0, mVerts, 0, Context3DVertexBufferFormat.FLOAT_2);
    // mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
    let ac = -1;
    for (let i = 0; i < num;) {
      let part = this.mParticles[i];
      if (!(part.flg && Math.random() > 0.5)) {
        // if((part.posX-part.scale*0.55>0&&
        // 	part.posY-part.scale*0.55>0&&
        // 	part.posX+part.scale*0.55<UTItemManager.IMAGE_WIDTH&&
        // 	part.posY+part.scale*0.55<UTItemManager.IMAGE_HEIGHT)||_eraseMode
        // ){

        // if(ac!=part.texIndex){
        // 	mCtx3D.setTextureAt(0, mTexParts[part.texIndex]);
        // 	ac=part.texIndex
        // }
        if (part.flg) {
          this.mUniformMatrix[0] = part.posX + (Math.random() * 1 - 0.5) * part.scale * 0.06;
          this.mUniformMatrix[1] = part.posY + (Math.random() * 1 - 0.5) * part.scale * 0.06;
          this.mUniformMatrix[3] = part.scale * (Math.random() * 0.4 + 0.8);
          this.mUniformColor[3] = Math.random();
          this.mUniformColor[0] = part.r * this.mUniformColor[3];
          this.mUniformColor[1] = part.g * this.mUniformColor[3];
          this.mUniformColor[2] = part.b * this.mUniformColor[3];
        } else {
          this.mUniformMatrix[0] = part.posX;
          this.mUniformMatrix[1] = part.posY;
          this.mUniformMatrix[3] = part.scale;
          this.mUniformColor[0] = part.r;
          this.mUniformColor[1] = part.g;
          this.mUniformColor[2] = part.b;
          this.mUniformColor[3] = 1;
        }
        this.mUniformMatrix[2] = part.angle;
        // this.mUniformMatrix[3] = part.scale;
        // mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mUniformColor);
        // mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mUniformMatrix);
        this.drawTriangles(this.mUniformMatrix, this.mUniformColor);
        // if(!_painted){
        // 	if(onPainted)onPainted();
        // 	_painted=true;
        // }
        // }
      }
      if (part.life > 0) {
        this.mVF.getForceFromPos(part.posX, part.posY);
        part.setVFupdate(this.mVF.outX, this.mVF.outY);
        i++;
      } else {
        this.mParticles.splice(i, 1);
        --num;
        // 在这沸腾
        // ++e
      }
    }
    this.mUniformColor[3] = 1;
  }
  this.mVF.fadeField(0.96);
};

V3D02_PaintImpl.prototype.drawTriangles = function (t, i) {
  // var pattern = this.ctx.createPattern(this.textureParticle[1], 'no-repeat');
  this.ctx.fillStyle = `rgba(${i[0]}, ${i[1]}, ${i[2]}, ${i[3]})`;
  // 叠加canvas
  //  this.ctx.globalCompositeOperation="destination-in"
  // 绘制文本

  // this.ctx.globalAlpha = 0.9;
  this.ctx.beginPath();
  this.ctx.arc(t[0], t[1], t[3] / 40, 0, 2 * Math.PI);
  this.ctx.fill();

  // this.ctx.fillStyle = pattern;
  // this.ctx.beginPath();
  // this.ctx.arc(t[0], t[1],t[3]/40, 0, 2*Math.PI);
  // this.ctx.fill();

  // this.ctx.fillRect(t[0],t[1],20,20);
};
V3D02_PaintImpl.prototype.resetEraser = function (_x, _y) {
  // console.log('调用橡皮方法',this.isEraser)
  // this.ctx.globalCompositeOperation = "destination-out";
  this.ctx.globalCompositeOperation = 'source-over';
  this.ctx.beginPath();
  this.ctx.arc(_x, _y, 30, 0, 2 * Math.PI);
  this.ctx.fillStyle = 'rgba(255,255,255,1)';
  this.ctx.fill();
  this.ctx.globalCompositeOperation = 'source-over';
};
V3D02_PaintImpl.prototype.openEraser = function () {
  this.isEraser = true;
  // console.log('开启橡皮',this.isEraser)
};
// V3D02_PaintImpl.prototype.closeEraser = function() {
// 	this.isEraser = false;
// 	// console.log('关闭橡皮',this.isEraser)
// };
window.requestAnimFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || function (t) {
  window.setTimeout(t, 1000 / 60);
};

// export{ init };

export default V3D02_PaintImpl;
