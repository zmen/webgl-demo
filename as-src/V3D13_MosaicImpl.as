package utme.views.main.stage3d{
	
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import jp.uniqlo.utlab.assets.images.textureMosic;
	
	import utme.app.managers.UTItemManager;
	import utme.app.UTCreateMain;
	import utme.app.consts.AppStoryDefs;
	import utme.app.consts.AppVals;
	import utme.views.main.stage3d.helpers.Stage3DHelper;
	
	public class V3D13_MosaicImpl extends V3D19_RemixBaseImpl{
		private var _texture:Texture;		
		private var _mozWidth:int;
		private var _mozHeight:int;
		
		private var _mipmaps:Vector.<BitmapData>;
		private var _LODLevel:ByteArray;
		private var _martigX:Number;
		private var _martigY:Number;
		private var _mosicRemderSize:Number;
		
		private var margin:Number=7;
		private var InMargin:Number=256/252;
		
		private var _bUpdated:Boolean;
		private var _bClear:Boolean;		
		private var updatePointsX:Vector.<uint>=new Vector.<uint>;
		private var updatePointsY:Vector.<uint>=new Vector.<uint>;
		private var updatePointsLod:Vector.<uint>=new Vector.<uint>;
		public var textureIndex:int;
		private var srcViewId:int;
		
		public var _enableTransparentWhite:Boolean;
		public function V3D13_MosaicImpl(_weakMode:Boolean){
			super(true,_weakMode);
			
			textureIndex=2;	
						
			_mozWidth=16*5/2;
			_mozHeight=16*6/2;
			_mosicRemderSize=23.9*2;
			
			if(weakMode){
				_mozWidth*=3/2.0;
				_mozHeight*=3/2.0;
				_mosicRemderSize*=2/3.0;
			}
			//是四边空白的大小，martigX，martigY也是第一个马赛克的起始坐标
			_martigX=(UTItemManager.IMAGE_WIDTH-_mosicRemderSize*_mozWidth)*.5;//-_mosicRemderSize*.5;;
			_martigY=(UTItemManager.IMAGE_HEIGHT-_mosicRemderSize*_mozHeight)*.5;//-_mosicRemderSize*.5;;
			
			trace(_mozWidth,_mozHeight,_martigX,_martigY);  
			
			_LODLevel=new ByteArray;
			_LODLevel.length=_mozWidth*_mozHeight;
			_LODLevel.position=0;
			while(_LODLevel.position<_LODLevel.length)_LODLevel.writeByte(1);
			
			_enableTransparentWhite=false;//AppVals.HISTORY==0;
			srcViewId=UTCreateMain.getActiveSrcType();
		}
		
		
		//private static var debugBm:Bitmap=new Bitmap
		
		private function generateMipmapWithBitmap( _org:BitmapData,width:int,height:int ):void {
			
			var mipWidth:int = width;  //纹理贴图的宽度
			var mipHeight:int = height;  //纹理贴图的高度
			var mipLevel:int = 0;    //纹理贴图的层
			
			var scaleTransform:Matrix = new Matrix();
			var s:Number=(mipWidth)/Number(_org.width);

			scaleTransform.translate(-_org.width*.5,-_org.height*.5);
			if(mipWidth/Number(_org.width),mipHeight/Number(_org.height)){   //？？？？？逗号应该是小于号吧？
				scaleTransform.scale(mipHeight/Number(_org.height),mipHeight/Number(_org.height));
			}else{
				scaleTransform.scale(mipWidth/Number(_org.width),mipWidth/Number(_org.width));
			}
			scaleTransform.translate(mipWidth*.5,mipHeight*.5);
			
			
			var bmd:BitmapData=_org;
			var mipImage:BitmapData;
			while ( mipWidth > 0 && mipHeight > 0 ){  //产生图像不同级别的纹理贴图，每次规模缩小一半
				mipImage = new BitmapData( mipWidth, mipHeight,true,0 );
				mipImage.draw( bmd, scaleTransform, null, null, null,false);//将原始图像处理成第一次马赛克纹理图像
				scaleTransform.identity();
				scaleTransform.scale( 0.5, 0.5 );
				mipLevel++;  //纹理层数加1
				mipWidth >>= 1;  //宽度减少一半
				mipHeight >>= 1;  //高度减少一般
				bmd=mipImage;  //将纹理贴图付给bmd进行再处理
				_mipmaps.push(mipImage);	//将纹理贴图压栈	
			}
			
			if(srcViewId!=AppStoryDefs.VIEW_SRC_PHOTO){  //如果是图片
				bmd=_mipmaps[0];  //取0层纹理贴图
				bmd.lock();
				var x:int,y:int,i:int;
				var c:uint;
				var r:int,g:int ,b:int ,a:int ;
				for(i=0; i<2;i++){   //图像上下两条线，透明度乘0.65
					y=i==0?0:bmd.height-1;
					for(x=0; x<bmd.width;x++){
						c=bmd.getPixel32(x,y);
						a=((c >> 24) & 0xFF)
						r=((c >> 16) & 0xFF)
						g=((c >> 8) & 0xFF)
						b=((c >> 0) & 0xFF)
						a*=0.65;
						c=(a << 24) | (r << 16) | (g << 8) | (b<<0);
						bmd.setPixel32(x,y,c);
					}
				}
				for(i=0; i<2;i++){   //图像左右两条线，透明度乘0.65
					x=i==0?0:bmd.width-1;
					for(y=0; y<bmd.height;y++){
						c=bmd.getPixel32(x,y);
						a=((c >> 24) & 0xFF)
						r=((c >> 16) & 0xFF)
						g=((c >> 8) & 0xFF)
						b=((c >> 0) & 0xFF)
						a*=0.65;
						c=(a << 24) | (r << 16) | (g << 8) | (b<<0);
						bmd.setPixel32(x,y,c);
					}
				}
				bmd.unlock();
				bmd=null;
			}
		}
		
		
		public var maxCellLod:uint;
		public var maxCellNum:uint;
		
		
		public override function initWithData(backBmd:BitmapData,srcBmd:BitmapData):void{
			_mipmaps=new Vector.<BitmapData>;
			generateMipmapWithBitmap(srcBmd,_mozWidth,_mozHeight);
			
			maxCellNum=_mozHeight*_mozWidth;  //初始化时产生的马赛克数量
			maxCellLod=_mozHeight*_mozWidth*(_mipmaps.length-1-2);  //最大最终剩余马赛克数量，对最后的马赛克数量产生影响，最多7*7
			
			
			super.init3D(backBmd,null);
		}
		
		public override function dispose():void{
			
			for(var i:int=0;i<_mipmaps.length;i++){
				_mipmaps[i].dispose();
				_mipmaps[i]=null;
			}
			_mipmaps.length=0;
			
			_texture.dispose();
			_texture=null;
			super.dispose();
		}
		
		
		protected override function setup():void{
			_bUpdated=true;
			_bClear=true;
			setTexture(textureIndex);
		}
		
		public function setTexture(tindex:int):void{
			textureIndex=tindex;
			if(!mCtx3D)return;
			var tex:textureMosic=new textureMosic;
			var m:Matrix=new Matrix();
			m.scale(4,4);   
			var _bmd:BitmapData=new BitmapData(1024,1024,true,0)
			
			switch(textureIndex){
				case 2:
					tex.gotoAndStop(2);
					margin=7;
					InMargin=256/252;
					break;
				case 3:
					tex.gotoAndStop(3);
					margin=7;
					InMargin=256/252;
					break;
				default:
					tex.gotoAndStop(1);
					margin=0;
					InMargin=1;
			}
		
			if(_bmd.hasOwnProperty("drawWithQuality")){
				_bmd.drawWithQuality(tex,m,null,null,null,true,StageQuality.HIGH);
			}else{
				_bmd.draw(tex,m,null,null,null,true);
			}
			
			if(_texture)_texture.dispose();
			_texture = Stage3DHelper.uploadTexture(mCtx3D,_bmd,Context3DTextureFormat.BGRA,true,true);
			_bUpdated=true;
			_bClear=true;
		}
		
		
		protected override function draw():void{
			if(!_bUpdated)return;
			
			//mCtx3D.clear(0,0,0,0);
			mCtx3D.setVertexBufferAt(0, mVerts, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setVertexBufferAt(1, mCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
			
			
			//LODレンダリングシステム//LOD渲染系统
			var c:uint;
			var p:uint;//ポインタポジション //指针位置
			var lp:uint;
			var lod:uint;
			var sd:uint;
			var x:uint;
			var y:uint;
			var i:uint;
			var al:Number;
			
			if(_bClear){
				mCtx3D.clear(0,0,0,0);
				mCtx3D.setTextureAt(0,_texture);	
				_LODLevel.position=0;
				for (y=0;y<_mozHeight;y++){  //两个for循环做马赛克块的显示
					for (x=0;x<_mozWidth;x++){	
						lod=_LODLevel.readUnsignedByte();
						lp=Math.pow(2,lod-1);
						
						if(x % lp!=0||y%lp!=0)continue;
						c=_mipmaps[lod-1].getPixel32(x/lp,y/lp); //取下一纹理图层该块对应的第一个像素颜色
						
						if(((c >> 24) & 0xFF)<10)continue;
						if(_enableTransparentWhite&&((c >> 16) & 0xFF)>235&&((c >> 8) & 0xFF)>235&&((c >> 0) & 0xFF)>235)continue;
						
						al=((c >> 24) & 0xFF) /255.0;;
						mUniformColor[0]     = al*((c >> 16) & 0xFF) /255.0;
						mUniformColor[1]     = al*((c >> 8) & 0xFF) /255.0;
						mUniformColor[2]     = al*((c >> 0) & 0xFF) /255.0;
						mUniformColor[3]     = al;
						
						mUniformMatrix[0] =	_martigX+ x*_mosicRemderSize+_mosicRemderSize*lp*.5 ;//+ xp*lodProg   
						mUniformMatrix[1] = -_martigY+UTItemManager.IMAGE_HEIGHT- y*_mosicRemderSize-_mosicRemderSize*lp*.5;// + yp*lodProg
						mUniformMatrix[2] = 0;
						mUniformMatrix[3] = _mosicRemderSize*lp*InMargin-margin;
						mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mUniformColor);
						mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mUniformMatrix);
						mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
						mCtx3D.drawTriangles(mIndicies);
					}
				}
				_bClear=false;
			}else{
				mCtx3D.setTextureAt(0,_texture);	
				for (i=0;i<updatePointsLod.length;i++){  //对每一个已经生成的马赛克点
				   //定位到该马赛克的起始点（x，y）
					x=updatePointsX[i];
					y=updatePointsY[i];
					_LODLevel.position=x+_mozWidth*y;
					lod=updatePointsLod[i];  //马赛克层数
					lp=Math.pow(2,lod-1);  //马赛克尺寸
					
					if(x % lp!=0||y%lp!=0)continue;  
					c=_mipmaps[lod-1].getPixel32(x/lp,y/lp); //取该块马赛克的颜色
					
					al=((c >> 24) & 0xFF) /255.0;
					mUniformColor[0]     = al*((c >> 16) & 0xFF) /255.0;
					mUniformColor[1]     = al*((c >> 8) & 0xFF) /255.0;
					mUniformColor[2]     = al*((c >> 0) & 0xFF) /255.0;
					mUniformColor[3]     = al;
					
					mUniformMatrix[0] =	_martigX+ x*_mosicRemderSize+_mosicRemderSize*lp*.5 ;//+ xp*lodProg   
					mUniformMatrix[1] = -_martigY+UTItemManager.IMAGE_HEIGHT- y*_mosicRemderSize-_mosicRemderSize*lp*.5;// + yp*lodProg
					mUniformMatrix[2] = 0;
					mUniformMatrix[3] = _mosicRemderSize*lp*InMargin-margin;
					
					mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mUniformColor);
					mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mUniformMatrix);
					mCtx3D.setBlendFactors(Context3DBlendFactor.ZERO,Context3DBlendFactor.ZERO);
					mCtx3D.drawTriangles(mIndicies);
					mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				
					if(((c >> 24) & 0xFF)<10)continue;
					if(_enableTransparentWhite&&((c >> 16) & 0xFF)>235&&((c >> 8) & 0xFF)>235&&((c >> 0) & 0xFF)>235)continue;
					mCtx3D.drawTriangles(mIndicies);  //显示马赛克
				}	
				updatePointsX.length=0;
				updatePointsY.length=0;
				updatePointsLod.length=0;
			}
			mUniformColor[3] =1;
			_bUpdated=false;
		}
		
		private var _lodSum:uint=0; 
		protected override function addedForce(_x:Number,_y:Number):void{
			_bUpdated=true;
			
			var va:Number=_lodSum/maxCellLod;  //保证在最后四个层停止，，可能的尺寸小于等于7*7
			var bUpdated:Boolean=false;
			var cnv:Number=(1-va)*8;  //小于等于8的数
			//cnv=Math.pow(cnv,2);
			var i:int;
			var x:uint;
			var y:uint;
			
			var _miR:int;
			var _miG:int;
			var _miB:int;
			var _maR:int;
			var _maG:int;
			var _maB:int;
			var _r:int;
			var _g:int;
			var _b:int;
			var c:uint;
			
			//if(Math.floor(cnv)==0&&Math.random()<0.9)return;
			
			if(cnv<5){    //static public var REMIX_PERTICLE_SPEED:Number=1.0;
				if(Math.random()> (cnv/5.0 *.5 + 0.05)*AppVals.REMIX_PERTICLE_SPEED)return ;
			}
			for(i=0;i<cnv*AppVals.REMIX_PERTICLE_SPEED;i++){//每次摇动手机，处理马赛克的数量，最多8个
				if(va==1)return; //达到小于7*7以下马赛克，停止

				LABEL_RESTART_RANDOM:	

				//随机取（x，y）
				x=Math.floor(_mozWidth*Math.random());
				y=Math.floor(_mozHeight*Math.random());
				
				LABEL_RESTART:
				
				_LODLevel.position=x+_mozWidth*y;
				var lod:uint=_LODLevel.readUnsignedByte();  //第一次读出来的是1，以后可能是该点买塞克的尺寸大小
				
				
				
				var writeLod:uint;
				writeLod=lod+1;   //==2 每次摇动，遂渐将原有的马赛克增大一倍
				
				var lp:uint=Math.pow(2,writeLod-1); //初始lp==2  马赛克尺寸增加一倍，比lod大一个尺寸
				x=Math.floor(x/lp)*lp;  //把x，y变为lp的倍数，定位到（x，y）要换到大一倍的马赛克粒的初始点
				y=Math.floor(y/lp)*lp;
				
				//check
				var ly:uint;
				var lx:uint;
				//检查，是否存在x，y点，从这个点起始，找到lp范围内，都是lod尺寸的马赛克块
				var chk:Boolean=true;
				for (ly=y;ly<y+lp;ly++){//检查马赛克，(x,y)是否是该马赛克起始点，并且在（x，y）到（lx，y+lp)都是同样规模的块
					if(ly<_mozHeight){
						_LODLevel.position=x+_mozWidth*ly;
						for (lx=x;lx<x+lp&&lx<_mozWidth;lx++){	//好像有bug
							if(_LODLevel.readUnsignedByte()!=lod){//该列（x，y）到（lx，y+lp)中存在不同大小的马赛克，
								x=lx;
								y=ly;
								goto LABEL_RESTART;
								chk=false;
								break;
							}
						}
					}else{
						chk=false;
					}	
					if(!chk)break;
				}
				if(!chk)goto LABEL_RESTART_RANDOM;
				//如果监测成果

				if(lod==_mipmaps.length-3){
					if(cnv<5){
						if(Math.random()< Math.pow(1-cnv/5.0,2)){
							if(_lod1Count<maxCellNum){
								if(Math.random()<0.6)goto LABEL_RESTART_RANDOM;
							}
						}else{
							goto LABEL_RESTART_RANDOM;
						}
					}
				}
				
				if(lod==_mipmaps.length-2){
					goto LABEL_RESTART_RANDOM;
				}
				
				
				if(weakMode){
					if(lod==2){
					goto LABEL_RESTART_RANDOM;
					}
				}
				
				
				//如果监测成果，将里面的四个大小一样的马赛克块处理成一个，色块内的颜色值不能差别太大
				chk=false;
				lp=Math.pow(2,writeLod-1);
				var lpc:uint=Math.pow(2,lod-1);
				for (ly=y;ly<y+lp&&ly<_mozHeight;ly++){//对(x,y,x+lp,y+lp)区域进行马赛克处理
					for (lx=x;lx<x+lp&&lx<_mozWidth;lx++){找到最大的颜色值ma，和最小的颜色值mi
						if(lx % lpc!=0||ly%lpc!=0)continue;
						c=_mipmaps[lod-1].getPixel(lx/lpc,ly/lpc);//取下一纹理图层对应的像素颜色
						_r= (( c >> 16)& 0xFF);
						_g= (( c >> 8)& 0xFF);
						_b= (( c >> 0)& 0xFF);
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
				
				var r:Number=Math.sqrt(_r*_r+_g*_g+_b*_b) / ((va)*500);  //颜色距离，这里是不是有bug？第一次调用addforce，va=0；
				if(weakMode){
					if(r>0.6)continue;
				}
				if(r>0.92)r=0.92;
				r=Math.pow(r,2);
				//trace("-----------",r,Math.sqrt(_r*_r+_g*_g+_b*_b),lp,lod);
				if(Math.random()<r)goto LABEL_RESTART_RANDOM;
				
				for (ly=y;ly<y+lp&&ly<_mozHeight;ly++){//将这个区域马赛克level标记为writelod
					_LODLevel.position=x+_mozWidth*ly;
					for (lx=x;lx<x+lp&&lx<_mozWidth;lx++){
						_LODLevel.writeByte(writeLod);
						_lodSum++;  //总处理的点数
						if(writeLod==2)_lod1Count++; 
					}
				}
				//trace(_lod1Count,maxCellNum);
				//标记马赛克起始点x，y，和马赛克大小writelod
				updatePointsX.push(x);
				updatePointsY.push(y);
				updatePointsLod.push(writeLod);
			}
		}
		
		private var _lod1Count:int=0;
		
		public override function clear():void{
			_LODLevel.position=0;
			while(_LODLevel.position<_LODLevel.length)_LODLevel.writeByte(1);
			super.clear();
			_bClear=true;
			_bUpdated=true;
			_lodSum=0;
			_lod1Count=0;
		}	
	}	
}