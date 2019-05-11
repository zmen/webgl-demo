const PIC_URL = 'pic1.png';
const WIDTH = 400;
const HEIGHT = 400;

class V3D15_MOMA01Impl {
  constructor() {
    this.drawImg = null;
    this.img = null;
    this.x = null;
    this.y = null;
    this.w = null;
    this.h = null;
  }

  // 初始化图片
  initWithData = (current, width, height) => {
    this.canvas = current;
    this.ctx = this.canvas.getContext('2d');
    this.canvas.width = width;
    this.canvas.height = height;
    const self = this;
    const img = new Image();
    img.src = PIC_URL;
    img.onload = function () {
      self.img = img;
      self.ctx.drawImage(img, 0, 0, WIDTH, HEIGHT);
      self.srcBmd = self.ctx.getImageData(0, 0, WIDTH, HEIGHT);
      setTimeout(() => {
        self.ctx.fillStyle = "white";
        self.ctx.fillRect (0, 0, WIDTH, HEIGHT);
      }, 400);
    };
    this.canvas.addEventListener('mousedown', this.startEvent.bind(this), !1);
  };

  // 晃动
  startEvent = (e) => {
    e.preventDefault(); // 阻止默认事件
    e.stopPropagation();// 阻止默认事件
    this.addedForce();
    this.draw();
  };

  // 绘画
  draw = () => {
    const that = this;
    this.drawImg.onload = function () {
      that.ctx.save();
      that.ctx.translate(that.x + that.w / 2, that.y + that.h / 2);
      that.ctx.rotate(20*(Math.random()-0.5) * Math.PI / 180);
      that.ctx.drawImage(that.drawImg, - that.w / 2, - that.h / 2);
      that.ctx.restore();
    };
  };

  getRandomXY = (value) => {
    const newValue = Math.random() * value;
    return newValue < 1 ? 1 : newValue;
  };

  getRandomWH = (value) => {
    let random = Math.random();
    if (random < 0.3) {
      random = 0.3;
    } else if (random > 0.6) {
      random = 0.6;
    }
    const newValue = random * value;
    return newValue < 1 ? 1 : newValue;
  };

  // 随机图案
  addedForce = () => {
    const srcCanvas = document.createElement('canvas');
    srcCanvas.width = WIDTH;
    srcCanvas.height = HEIGHT;
    const srcCtx = srcCanvas.getContext('2d');
    srcCtx.drawImage(this.img, 0, 0, 400, 400);
    this.x = this.getRandomXY(400);
    this.y = this.getRandomXY(400);
    this.w = this.getRandomWH(400 - this.x);
    this.h = this.getRandomWH(400 - this.y);
    const imageData = srcCtx.getImageData(this.x, this.y, this.w, this.h);

    const destCanvas = document.createElement('canvas');
    destCanvas.width = this.w;
    destCanvas.height = this.h;
    const destCtx = destCanvas.getContext('2d');
    destCtx.putImageData(imageData, 0, 0, 0, 0, this.w, this.h);
    destCtx.strokeRect(0, 0, this.w, this.h);

    const img = new Image();
    img.src = destCanvas.toDataURL("image/png");
    this.drawImg = img;
  };
}

export default V3D15_MOMA01Impl;