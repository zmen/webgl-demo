const UTItemManager = {
  IMAGE_WIDTH: 2048,
  IMAGE_HEIGHT: 2048,
};

class V3D15_MOMA01Impl {
  constructor(canvas, width, height) {
    this.canvas = canvas;
    this.ctx = this.canvas.getContext('2d');
    this.srcWidth = width;
    this.srcHeight = height;
    this.canvas.width = width;
    this.canvas.height = height;
    this.BOOST_SPEED = 2;
    this.LIGHT_SPEED = 2;
    this._isEnableNextBtn = false;
    this._counter = 0;
    this.motion = 0;
    this.mActivePow = 0;
    this.prtHeight = 30;
    this.prtWidth = this.prtHeight * UTItemManager.IMAGE_WIDTH / UTItemManager.IMAGE_HEIGHT;
    this.parts = [];
    this.rndWidth = UTItemManager.IMAGE_WIDTH;
    this.rndHeight = UTItemManager.IMAGE_HEIGHT;
    this.srcImage = null;
    this.optImage = null;

    this.knlHeight =256;
    this.knlWidth = this.knlHeight * UTItemManager.IMAGE_WIDTH / Number(UTItemManager.IMAGE_HEIGHT);

    this.mTime = -1;
    this.toggler = 0;

    this.KernelCovorRangeX=this.rndWidth/(this.knlWidth-1)*5;
    this.KernelCovorRangeY=this.rndHeight/(this.knlHeight-1)*5;


    this.optImage = null;
    this.srcImage = null;

    this.LumCoeff = {
      x: 0.2125,
      y: 0.7154,
      z: 0.0721,
      w: 0,
    };
    this.AvgLumin = {
      x: 0.5,
      y: 0.5,
      z: 0.5,
      w: 0,
    };
  }

  // 初始化图片
  initWithData = (canvas, width, height) => {
    // this.canvas.addEventListener('mousedown', this.startEvent.bind(this), !1);
    if(this.srcImage === null){
      const self = this;
      const img = new Image();
      img.src = 'pic1.png';
      img.onload = function () {
        self.ctx.drawImage(img, 10, 10, 380, 390);
      };

      this.ctx1.drawImage(img, 10, 10, 380, 390);

      // var bmd:BitmapData=new BitmapData(knlWidth,knlHeight,true,0);
      // bmd.perlinNoise(knlHeight/30,knlHeight/30,1,Math.random()*10000,false,true);
      //
      // var rect:Rectangle=bmd.rect;
      // bmd.draw(_srcThumb,null,null,null,bmd.rect);
      //
      // this.optImage=H_MOMA01ImageUtils.calcOpticalFlowByteArray(bmd);
    }
  };

  // 晃动
  startEvent = (e) => {
    e.preventDefault(); // 阻止默认事件
    e.stopPropagation();// 阻止默认事件
    let i = this.getXY(e);// i是坐标对象
    this.addedForce(i.x, i.y);
    this.draw();
  };

  clampi = (x, min ,max) => {
    return x<min?min:(x>max?max:x);
  };

  clampf = (x, min, max) => {
    return x<min?min:(x>max?max:x);
  };

  getRandom = () => {
    return Math.random()*2.0-1.0;
  };

  multiply = (org, src) => {
    return {
      x: org.x * src,
      y: org.y * src,
      z: org.z * src,
      w: org.w * src,
    }
  };

  add = (org, src) => {
    return {
      x: org.x + src,
      y: org.y + src,
      z: org.z + src,
      w: org.w + src,
    }
  };

  dot = (org, src) => {
    return org.x*src.x+org.y*src.y+org.z*src.z+org.w*src.w;
  };

  ContrastSaturationBrightness = (color, brt, sat, con) => {
    let brtColor = {
      x: color.x,
      y: color.y,
      z: color.z,
      w: color.w,
    };
    color = this.multiply(color, brt);
    const intensity = this.dot(brtColor, this.LumCoeff)*(1.0-sat);
    brtColor = this.multiply(brtColor, sat);
    brtColor = this.add(brtColor, intensity);
    brtColor = this.multiply(brtColor, con);
    const conColor = 0.5*(1-con);
    brtColor = this.add(brtColor, conColor);
    return brtColor;
  };

  // 绘画
  draw = () => {
    this.mActivePow *= 0.90;
    if(this.motion<1)return;

    // 保证随机后才绘制
    this.motion--;

    // mCtx3D.setTextureAt(0,texture);
    // mCtx3D.setVertexBufferAt(0, mVerts, 0, 'float2');
    // mCtx3D.setVertexBufferAt(1, mCoords, 0, 'float2');
    // mCtx3D.setProgramConstantsFromMatrix('vertex', 0, mFBOMatrix, true);


    let i;
    let col;
    let vec = {
      x: 0,
      y: 0,
      z: 0,
      w: 0,
    };
    let p;
    let srcCol = {
      x: 0,
      y: 0,
      z: 0,
      w: 0,
    };
    this.toggler++;
    if(this.toggler+1 > this.LIGHT_SPEED) this.toggler=0;

    for(i=0;i<this.prtHeight*this.prtWidth;i++){
      if(i % this.LIGHT_SPEED !== this.toggler)continue;

      let pt = this.parts[i];
      if(pt.orgAlpha){
        p = this.clampi(pt.y/(this.rndHeight-1)*(this.knlHeight-1),0,this.knlHeight-1)*this.knlWidth+this.clampi(pt.x/(this.rndWidth-1)*(this.knlWidth-1),0,this.knlWidth-1);

        vec.x=(this.optImage[p*2]-127.0)*0.02*10*this.BOOST_SPEED;
        vec.y=(this.optImage[p*2+1]-127.0)*0.02*10*this.BOOST_SPEED;

        pt.x+=vec.x;
        pt.y+=vec.y;

        let mUniformMatrix= [0.0, 0.0, 0.0, 1.0];
        let mUniformColor= [1.0, 1.0, 1.0, 1.0];

        mUniformMatrix[0] = pt.x;
        mUniformMatrix[1] = this.rndHeight- pt.y;
        mUniformMatrix[2] = 0;
        mUniformMatrix[3] = 40*pt.scale;

        mUniformColor[3]=pt.alpha*pt.orgAlpha;
        mUniformColor[0]=pt.r*mUniformColor[3] ;
        mUniformColor[1]=pt.g*mUniformColor[3] ;
        mUniformColor[2]=pt.b*mUniformColor[3] ;

        let border = mUniformMatrix[3] * 0.55;

        if(mUniformColor[3]>0){

          if(pt.x>border&&
            pt.y>border&&
            pt.x<UTItemManager.IMAGE_WIDTH-border&&
            pt.y<UTItemManager.IMAGE_HEIGHT-border
          ){
            console.log(mUniformColor);
            console.log(mUniformMatrix);
            // mCtx3D.setProgramConstantsFromVector('fragment', 0, mUniformColor);
            // mCtx3D.setProgramConstantsFromVector('vertex', 4, mUniformMatrix);
            // mCtx3D.drawTriangles(mIndicies);
          }else{
            pt.orgAlpha=0;
          }
        }

        if(pt.alpha<1){
          pt.alpha+=this._alphaStep;
          if(pt.alpha>1)pt.alpha=1;
        }
      }
      pt.life--;
      if(pt.life<0){

        pt.x=pt.orgX+this.getRandom()*this.KernelCovorRangeX-this.KernelCovorRangeX*.5;
        pt.y=pt.orgY+this.getRandom()*this.KernelCovorRangeY-this.KernelCovorRangeY*.5;

        pt.life=Math.random()*this._lifeLength;
        pt.scale=Math.random()*this._scale+0.1;

        p=this.clampi(pt.y/(this.rndHeight-1)*(this.knlHeight-1),0,this.knlHeight-1)*this.knlWidth+this.clampi(pt.x/(this.rndWidth-1)*(this.knlWidth-1),0,this.knlWidth-1);

        srcCol.x=this.srcImage[p*4+1]/255.0;
        srcCol.y=this.srcImage[p*4+2]/255.0;
        srcCol.z=this.srcImage[p*4+3]/255.0;

        col=this.ContrastSaturationBrightness(srcCol,
          this._brightness,
          this.isMonoral?0.1:this._saturation,
          this._contrast
        );

        col.x=this.clampf(col.x,0,1);
        col.y=this.clampf(col.y,0,1);
        col.z=this.clampf(col.z,0,1);

        const vn=this.getRandom()*this._brigtnessNoize;
        pt.r=col.x+this.getRandom()*this._colorNoize+vn;
        pt.g=col.y+this.getRandom()*this._colorNoize+vn;
        pt.b=col.z+this.getRandom()*this._colorNoize+vn;

        pt.orgAlpha=this.srcImage[p*4]/255.0 ;
        pt.alpha=this._alpha;
      }
    }
  };

  // 随机图案
  addedForce = (_x, _y) => {
    this.motion += 1;

    const t = new Date();
    this.mActivePow += Math.min(Math.sqrt(_x*_x+_y*_y)*(t-this.mTime)/1000,1.0);
    this.mTime=t;

    let power = (this.mActivePow-5)/4.0;
    if(power<0)power=0;
    if(power>1)power=1;

    this._colorNoize=this._colorNoize_s+(this._colorNoize_e-this._colorNoize_s)*power;
    this._brigtnessNoize=this._brigtnessNoize_s+(this._brigtnessNoize_e-this._brigtnessNoize_s)*power;
    this._alpha=this._alpha_s+(this._alpha_e-this._alpha_s)*power;
    this._alphaStep=this._alphaStep_s+(this._alphaStep_e-this._alphaStep_s)*power;
    this._scale=this._scale_s+(this._scale_e-this._scale_s)*power;
    this._lifeLength=this._lifeLength_s+(this._lifeLength_e-this._lifeLength_s)*power;
    this._brightness=this._brightness_s+(this._brightness_e-this._brightness_s)*power;
    this._contrast=this._contrast_s+(this._contrast_e-this._contrast_s)*power;
    this._saturation=this._saturation_s+(this._saturation_e-this._saturation_s)*power;


    if(!this._isEnableNextBtn&&this._counter>10){
      this._isEnableNextBtn=true;
      // changeNextBtnCallback(true);
    }
    this._counter++;
  };

  // 设置风格
  setStyle = (style) => {
    switch(style){
      case 1:
        this._colorNoize_s=0.066;
        this._brigtnessNoize_s=0.2;
        this._alpha_s=1;
        this._alphaStep_s=0.095;
        this._scale_s=0.5;
        this._lifeLength_s=300/this.BOOST_SPEED;
        this._brightness_s=1;
        this._contrast_s=1.5;
        this._saturation_s=1.5;

        this._colorNoize_e=0.5;
        this._brigtnessNoize_e=0.5;
        this._alpha_e=1;
        this._alphaStep_e=1;
        this._scale_e=0.32;
        this._lifeLength_e=500/this.BOOST_SPEED;
        this._brightness_e=1;
        this._contrast_e=1.5;
        this._saturation_e=1.5;
        break;
      case 2:
        this._colorNoize_s=0.5;
        this._brigtnessNoize_s=0.1215;
        this._alpha_s=1;
        this._alphaStep_s=1;
        this._scale_s=0.8;
        this._lifeLength_s=4/this.BOOST_SPEED;
        this._brightness_s=1;
        this._contrast_s=1.5;
        this._saturation_s=1.29;

        this._colorNoize_e=0.2;
        this._brigtnessNoize_e=0.123;
        this._alpha_e=1;
        this._alphaStep_e=1;
        this._scale_e=1.5;
        this._lifeLength_e=4/this.BOOST_SPEED;
        this._brightness_e=1;
        this._contrast_e=1.5;
        this._saturation_e=1.29;
        break;
      default:
        this._colorNoize_s=0.1;
        this._brigtnessNoize_s=0.1;
        this._alpha_s=0;
        this._alphaStep_s=0.02;
        this._scale_s=1.5;
        this._lifeLength_s=50/this.BOOST_SPEED;
        this._brightness_s=1;
        this._contrast_s=1.505;
        this._saturation_s=1.28;

        this._colorNoize_e=0.2;
        this._brigtnessNoize_e=0.1;
        this._alpha_e=0;
        this._alphaStep_e=0.03;
        this._scale_e=1.0;
        this._lifeLength_e=50/this.BOOST_SPEED;
        this._brightness_e=1;
        this._contrast_e=1.505;
        this._saturation_e=1.28;
        break;
    }
    this.clear();
  };

  clear = () => {
    let y;
    let x;
    this._isEnableNextBtn=false;

    this._counter = 0;
    this.motion = 0;
    this.mActivePow = 0;

    for(y=0; y < this.prtHeight; y++){
      for(x=0; x < this.prtWidth; x++){
        this.parts[y * this.prtWidth + x].orgX = this.rndWidth * x / (this.prtWidth) + (this.rndWidth / this.prtWidth) * 0.5;
        this.parts[y * this.prtWidth + x].orgY = this.rndHeight * y / (this.prtHeight) + (this.rndHeight / this.prtHeight) * 0.5;
        this.parts[y * this.prtWidth + x].life = 150 * Math.random();
        this.parts[y * this.prtWidth + x].alpha = 0;
        this.parts[y * this.prtWidth + x].orgAlpha = 0;
      }
    }
  };

};

export default V3D15_MOMA01Impl;