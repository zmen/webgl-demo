import Matrix from './Matrix';
import BitmapData from './BitmapData';
/*
未解决的问题
goto 语句的处理
导入外部源码，已用注释标注
矩阵和bitmap类的实现
*/
var UTItemManager = {
  IMAGE_WIDTH: 2048,
  IMAGE_HEIGHT: 2048,
}

function goto(func, self) {
  func(self);
}

function V3D13_MosaicImpl(_weakMode) {
  //     this._texture= null;//Texture;
  this.scale = 1;
  this.position = 0;
  this._mipmaps= [];//Vector.<BitmapData>;
  this._LODLevel= [];//ByteArray;
  this._martigX= null;//Number;f
  // this._martigY= null;//Number;
  this.mUniformColor=[];//原来代码没定义直接使用了，这里定义了一下
  //     this.mUniformMatrix=[];//原来代码没定义直接使用了，这里定义了一下

  this.margin= 7;//Number=7;
  this.InMargin= 256/252;//Number=256/252;

      this._lodSum=0; //private var _lodSum:uint=0; 
  //     this._lod1Count=0//private var _lod1Count:int=0;
      this.maxCellLod=null;//public var maxCellLod:uint;
  // this.maxCellNum=null;//public var maxCellNum:uint;
  this._bUpdated= null;//Boolean;
  this._lod1Count = 0;
  // this._bClear= null;//Boolean;		
  this.updatePointsX= [];//Vector.<uint>=new Vector.<uint>;
  this.updatePointsY= [];//Vector.<uint>=new Vector.<uint>;
  this.updatePointsLod= [];//Vector.<uint>=new Vector.<uint>;

  // this.srcViewId= null;//int;

  //     this._enableTransparentWhite= null;//Boolean;
  //     //super(_weakMode);

  //     this.textureIndex= 2;//int;	

  // this._mozWidth= 16*5/2;//int;
  //     this._mozHeight= 16*6/2;//int;
      this._mosicRemderSize= 23.9*2;//Number;

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

// V3D13_MosaicImpl.prototype.generateMipmapWithBitmap = function(_org,width,height){
//           var mipWidth = width;  //纹理贴图的宽度
//     var mipHeight = height;  //纹理贴图的高度
//     var mipLevel = 0;    //纹理贴图的层

//     var scaleTransform = new Matrix();//不会实现矩阵
//     var s=mipWidth/_org.width;

//     scaleTransform.translate(-_org.width*.5,-_org.height*.5);//矩阵变换
//     if(mipWidth/_org.width<mipHeight/Number(_org.height)){   //以前的逗号改成了小于号，也可能是大于
//       scaleTransform.scale(mipHeight/Number(_org.height),mipHeight/Number(_org.height));
//     }else{
//       scaleTransform.scale(mipWidth/Number(_org.width),mipWidth/Number(_org.width));
//     }
//     scaleTransform.translate(mipWidth*.5,mipHeight*.5);//矩阵变换

//     var bmd=_org;
//     var mipImage;
//     while ( mipWidth > 0 && mipHeight > 0 ){  //产生图像不同级别的纹理贴图，每次规模缩小一半
//       mipImage = new BitmapData( mipWidth, mipHeight,true,0 );//BitmapData 构造函数来着flash.display.BitmapData;
//       mipImage.draw( bmd, scaleTransform, null, null, null,false);//将原始图像处理成第一次马赛克纹理图像
//       scaleTransform.identity();
//       scaleTransform.scale( 0.5, 0.5 );
//       mipLevel++;  //纹理层数加1
//       mipWidth >>= 1;  //宽度减少一半
//       mipHeight >>= 1;  //高度减少一般
//       bmd=mipImage;  //将纹理贴图付给bmd进行再处理
//               this._mipmaps.push(mipImage);	//将纹理贴图压栈	
//           }

//           if(srcViewId!=AppStoryDefs.VIEW_SRC_PHOTO){  //如果是图片
//       bmd=this._mipmaps[0];  //取0层纹理贴图
//       bmd.lock();
//       var x,y,i;
//       var c;
//       var r,g ,b,a;
//       for(i=0; i<2;i++){   //图像上下两条线，透明度乘0.65
//         y=i==0?0:bmd.height-1;
//         for(x=0; x<bmd.width;x++){
//           c=bmd.getPixel32(x,y);//获得颜色
//           a=((c >> 24) & 0xFF)
//           r=((c >> 16) & 0xFF)
//           g=((c >> 8) & 0xFF)
//           b=((c >> 0) & 0xFF)
//           a*=0.65;
//           c=(a << 24) | (r << 16) | (g << 8) | (b<<0);
//           bmd.setPixel32(x,y,c);
//         }
//       }
//       for(i=0; i<2;i++){   //图像左右两条线，透明度乘0.65
//         x=i==0?0:bmd.width-1;
//         for(y=0; y<bmd.height;y++){
//           c=bmd.getPixel32(x,y);//获得颜色
//           a=((c >> 24) & 0xFF)
//           r=((c >> 16) & 0xFF)
//           g=((c >> 8) & 0xFF)
//           b=((c >> 0) & 0xFF)
//           a*=0.65;
//           c=(a << 24) | (r << 16) | (g << 8) | (b<<0);
//           bmd.setPixel32(x,y,c);
//         }
//       }
//       bmd.unlock();
//       bmd=null;
//     }
// }

V3D13_MosaicImpl.prototype.init = function (canvas, width, height) {
  this.canvas = canvas;
  this.ctx = this.canvas.getContext('2d');
  this.canvas.width = width;
  this.canvas.height = height;
  var self = this;
  var img = new Image();
  img.src = 'pic1.png';
  img.onload = function () {
    self.ctx.drawImage(img, 10, 10, 380, 390);
    var srcBmd = self.ctx.getImageData(0, 0, 400, 400);
    self.generateMipmapWithBitmap(srcBmd, 400, 400);
  }

  this._LODLevel = new Array(400 * 400).fill(1);
  this.maxCellLod=400*400*(this._mipmaps.length-1-2);

  this.canvas.addEventListener('mousedown', this.startEvent.bind(this), !1);
}

V3D13_MosaicImpl.prototype.generateMipmapWithBitmap = function (_org, width, height) {
  var imageData = this.ctx.getImageData(0, 0, width, height);
  var pixelData = imageData.data;


  //创建作为参考的像素
  var tmpImageData = this.ctx.getImageData(0, 0, width, height);
  var tmpPixelData = tmpImageData.data;
  console.log(tmpImageData);

  var size = 4//马赛克方块的边长
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
          var p = x * width + y
          totalr += tmpPixelData[p * 4 + 0]
          totalg += tmpPixelData[p * 4 + 1]
          totalb += tmpPixelData[p * 4 + 2]
        }
      }
      var p = i * width + j//每个像素点
      var resr = totalr / totalnum
      var resg = totalg / totalnum
      var resb = totalb / totalnum
      for (var dx = 0; dx < size; dx++) {
        for (var dy = 0; dy < size; dy++) {
          var x = i + dx;
          var y = j + dy;
          var p = x * width + y
          pixelData[p * 4 + 0] = resr
          pixelData[p * 4 + 1] = resg
          pixelData[p * 4 + 2] = resb
        }
      }
    }
  }
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
  // alert('下面我要开始晃动了');
  t.preventDefault(); // 阻止默认事件
  t.stopPropagation();// 阻止默认事件
  let i = this.getXY(t);// i是坐标对象
  this.addedForce(i.x, i.y);
  this.draw();
}

//没被调用
// V3D13_MosaicImpl.prototype.initWithData = function(backBmd,srcBmd){
//   this._mipmaps=[];//new Vector.<BitmapData>;
//   this.generateMipmapWithBitmap(srcBmd,this._mozWidth,this._mozHeight);

//   this.maxCellNum=this._mozHeight*this._mozWidth;  //初始化时产生的马赛克数量
//   this.maxCellLod=this._mozHeight*this._mozWidth*(this._mipmaps.length-1-2);  //最大最终剩余马赛克数量，对最后的马赛克数量产生影响，最多7*7


//   super.init3D(backBmd,null);
// }

// V3D13_MosaicImpl.prototype.dispose = function (){

//   for(let i=0;i<this._mipmaps.length;i++){
//       this._mipmaps[i].dispose();
//       this._mipmaps[i]=null;
//   }
//   this._mipmaps.length=0;

//   this._texture.dispose();
//   this._texture=null;
//   super.dispose();//继承类还没有实现
// }

// V3D13_MosaicImpl.prototype.setup = function (){
// this._bUpdated=true;
//   this._bClear=true;
//   this.setTexture(this.textureIndex);
// }

// V3D13_MosaicImpl.prototype.setTexture = function (tindex){
// this.textureIndex=tindex;
//   if(!mCtx3D)return;
//   var tex=new textureMosic;//:textureMosic
//   var m=new Matrix();//Matrix
//   m.scale(4,4);   
//   var _bmd=new BitmapData(1024,1024,true,0)//:BitmapData
//   switch(this.textureIndex){
//       case 2:
//           tex.gotoAndStop(2);
//           this.margin=7;
//           this.InMargin=256/252;
//           break;
//       case 3:
//           tex.gotoAndStop(3);
//           this.margin=7;
//           this.InMargin=256/252;
//           break;
//       default:
//           tex.gotoAndStop(1);
//           this.margin=0;
//           this.InMargin=1;
//   }

//   if(_bmd.hasOwnProperty("drawWithQuality")){
//       _bmd.drawWithQuality(tex,m,null,null,null,true,StageQuality.HIGH);
//   }else{
//       _bmd.draw(tex,m,null,null,null,true);
//   }

//   if(this._texture){
//       this._texture.dispose();
//   }
//   this._texture = Stage3DHelper.uploadTexture(mCtx3D,_bmd,Context3DTextureFormat.BGRA,true,true);
//   this._bUpdated=true;
//   this.this_bClear=true;
// }


V3D13_MosaicImpl.prototype.draw = function(){
  var width = 400;
  var height = 400;
  var imageData = this.ctx.getImageData(0, 0, width, height);
  var pixelData = imageData.data;


  //创建作为参考的像素
  var tmpImageData = this.ctx.getImageData(0, 0, width, height);
  var tmpPixelData = tmpImageData.data;
  console.log(tmpImageData);

  // var lod=this._LODLevel[this.position];
  var lod = this.scale;
  var size = 4*lod//马赛克方块的边长
  var totalnum = size * size
  //此处循环需从1开始，..-1结束，否则在里面的二层循环（dx=-1,dy=-1）就会越界
  this.updatePointsX.forEach((v, i) => {
    var x = this.updatePointsX[i];
    var y = this.updatePointsY[i];
    
    for (var i = 0; i < height; i += 1) {
      for (var j = 0; j < width; j += 1) {
        if (i === x && j === y) {
          var totalr = 0, totalg = 0, totalb = 0;
          //一个像素点周围的加上自身
          for (var dx = 0; dx < size; dx++) {
            for (var dy = 0; dy < size; dy++) {
              var x = i + dx;
              var y = j + dy;
              var p = x * width + y
              totalr += tmpPixelData[p * 4 + 0]
              totalg += tmpPixelData[p * 4 + 1]
              totalb += tmpPixelData[p * 4 + 2]
            }
          }
          var p = i * width + j//每个像素点
          var resr = totalr / totalnum
          var resg = totalg / totalnum
          var resb = totalb / totalnum
          for (var dx = 0; dx < size; dx++) {
            for (var dy = 0; dy < size; dy++) {
              var x = i + dx;
              var y = j + dy;
              var p = x * width + y
              pixelData[p * 4 + 0] = resr
              pixelData[p * 4 + 1] = resg
              pixelData[p * 4 + 2] = resb
            }
          }
        }
      }
    }
  });
  this.ctx.putImageData(imageData, 0, 0, 0, 0, width, height)
}

V3D13_MosaicImpl.prototype.addedForce=function(_x,_y){//传的两个参数没用到
  this.scale = this.scale+1;
  this._bUpdated=true;
  var va=this._lodSum/this.maxCellLod;  //保证在最后四个层停止，，可能的尺寸小于等于7*7
  var bUpdated=false;
  var cnv=(1-va)*8;  //小于等于8的数
  //cnv=Math.pow(cnv,2);
  var i;//:int;
  var x;//:uint;
  var y;//:uint;

  var _miR;//:int;
  var _miG;//:int;
  var _miB;//:int;
  var _maR;//:int;
  var _maG;//:int;
  var _maB;//:int;
  var _r;//:int;
  var _g;//:int;
  var _b;//:int;
  var c;//:uint;
  var self = this;

  //if(Math.floor(cnv)==0&&Math.random()<0.9)return;

  var AppVals_REMIX_PERTICLE_SPEED = 1.0;

  if(cnv<5){    //static public var REMIX_PERTICLE_SPEED:Number=1.0;
      if(Math.random()> (cnv/5.0 *.5 + 0.05)*AppVals_REMIX_PERTICLE_SPEED){
          //import utme.app.consts.AppVals;
          return ;
      }
  }
   //import utme.app.consts.AppVals;
  for(let i=0;i<cnv*AppVals_REMIX_PERTICLE_SPEED;i++){//每次摇动手机，处理马赛克的数量，最多8个
      if(va==1)return; //达到小于7*7以下马赛克，停止

      LABEL_RESTART_RANDOM(self);
  }

  function LABEL_RESTART_RANDOM(self) {
    //随机取（x，y）
    x=Math.floor(400*Math.random());
    y=Math.floor(400*Math.random());
  
    LABEL_RESTART(self);
  }
  
  function LABEL_RESTART(self) {
    self.position=x+400*y;
    //var lod:uint=this._LODLevel.readUnsignedByte();  //第一次读出来的是1，以后可能是该点买塞克的尺寸大小
    if(self.position<self._LODLevel.length){
        var lod=self._LODLevel[self.position];
        self.position++;
    }
  
    var writeLod;//:uint;
    writeLod=lod+1;   //==2 每次摇动，遂渐将原有的马赛克增大一倍
  
    var lp=Math.pow(2,writeLod-1); //初始lp==2  马赛克尺寸增加一倍，比lod大一个尺寸//:uint
    x=Math.floor(x/lp)*lp;  //把x，y变为lp的倍数，定位到（x，y）要换到大一倍的马赛克粒的初始点
    y=Math.floor(y/lp)*lp;
  
    //check
    var ly;//:uint;
    var lx;//:uint;
    //检查，是否存在x，y点，从这个点起始，找到lp范围内，都是lod尺寸的马赛克块
    var chk=true;//:Boolean
    for (let ly=y;ly<y+lp;ly++){//检查马赛克，(x,y)是否是该马赛克起始点，并且在（x，y）到（lx，y+lp)都是同样规模的块
        if(ly<400){
            self.position=x+400*ly;
            for (let lx=x;lx<x+lp&&lx<400;lx++){	//好像有bug
                if(self._LODLevel[self.position]!=lod){//该列（x，y）到（lx，y+lp)中存在不同大小的马赛克，
                    x=lx;
                    y=ly;
                    // goto LABEL_RESTART;
                    goto(LABEL_RESTART, self);
                    return;
                    chk=false;
                    break;
                }
            }
        }else{
            chk=false;
        }	
        if(!chk)break;
    }
    if(!chk) {
      goto(LABEL_RESTART_RANDOM, self);
      return;
    }
    //如果监测成果
  
    if(lod==self._mipmaps.length-3){
        if(cnv<5){
            if(Math.random()< Math.pow(1-cnv/5.0,2)){
                if(self._lod1Count<self.maxCellNum){
                    if(Math.random()<0.6)
                    goto(LABEL_RESTART_RANDOM, self);
                    return;
                }
            }else{
                goto(LABEL_RESTART_RANDOM, self);
                return;
            }
        }
    }
  
    if(lod==self._mipmaps.length-2){
        goto(LABEL_RESTART_RANDOM, self);
        return;
    }
  
  
    if(true){
        if(lod==2){
            goto(LABEL_RESTART_RANDOM, self);
            return;
        }
    }
  
  
    //如果监测成果，将里面的四个大小一样的马赛克块处理成一个，色块内的颜色值不能差别太大
    chk=false;
    lp=Math.pow(2,writeLod-1);
    var lpc=Math.pow(2,lod-1);//:uint
    for (let ly=y;ly<y+lp&&ly<400;ly++){//对(x,y,x+lp,y+lp)区域进行马赛克处理
        for (let lx=x;lx<x+lp&&lx<400;lx++){//找到最大的颜色值ma，和最小的颜色值mi
            if(lx % lpc!=0||ly%lpc!=0)continue;
            // c=self._mipmaps[lod-1].getPixel(lx/lpc,ly/lpc);//取下一纹理图层对应的像素颜色
            // _r= (( c >> 16)& 0xFF);
            // _g= (( c >> 8)& 0xFF);
            // _b= (( c >> 0)& 0xFF);
            c = self.ctx.getImageData(lx/lpc,ly/lpc, 1, 1).data;
            _r = c[0];
            _g = c[1];
            _b = c[2];
            // console.log(_r);
            //trace(_r,_g,_b);
            if(chk){
                if(_miR>_r)_miR=_r;
                if(_maR<_r)_maR=_r;
                if(_miG>_g)_miG=_g;
                if(_maG<_g)_maG=_g;
                if(_miB>_b)_miB=_b;
                if(_maB<_b)_maB=_b;
            }else{
                chk=true;
                _miR=_maR=_r;
                _miG=_maG=_g;
                _miB=_maB=_b;
            }
        }
    }
    //计算颜色距离
    _r=_maR-_miR;
    _g=_maG-_miG;
    _b=_maB-_miB;
  
    var r=Math.sqrt(_r*_r+_g*_g+_b*_b) / ((va)*500);  //颜色距离，这里是不是有bug？第一次调用addforce，va=0；//:Number
    if(true){
        if(r>0.6) {}
            // continue;
    }
    if(r>0.92){
        r=0.92;
    }
    r=Math.pow(r,2);
    //trace("-----------",r,Math.sqrt(_r*_r+_g*_g+_b*_b),lp,lod);
    if(Math.random()<r){
        goto(LABEL_RESTART_RANDOM, self);
        return;
    }
  
    for (let ly=y;ly<y+lp&&ly<400;ly++){//将这个区域马赛克level标记为writelod
        //_LODLevel.position=x+_mozWidth*ly;
        self.position = x+400*ly;
        for (let lx=x;lx<x+lp&&lx<400;lx++){
            self._LODLevel[self.position]=writeLod;////_LODLevel.writeByte(writeLod); 把position位置的原来元素换成 writeLod 不知道理解的对不对
            self._lodSum++;  //总处理的点数
            if(writeLod==2)self._lod1Count++; 
        }
    }
    //trace(_lod1Count,maxCellNum);
    //标记马赛克起始点x，y，和马赛克大小writelod
    self.updatePointsX.push(x);
    self.updatePointsY.push(y);
    self.updatePointsLod.push(writeLod);
    // console.log(self.updatePointsX);
    // console.log(self.updatePointsY);
    // console.log(self.updatePointsLod);
  }
}

// V3D13_MosaicImpl.prototype.clear=function(){
//   let position=0;
//   while(position<this._LODLevel.length){
//       this._LODLevel[position]=1;
//   }
//   super.clear();//父类
//   this._bClear=true;
//   this._bUpdated=true;
//   this._lodSum=0;
//   this._lod1Count=0;
// }

export default V3D13_MosaicImpl;