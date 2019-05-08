package utme.views.main.stage3d
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import jp.uniqlo.utlab.assets.images.TextureParticleMOMAPAINT;
	
	
	import utme.app.managers.UTItemManager;
	import utme.views.main.stage3d.helpers.objects.IPPerticles;
	import utme.views.main.stage3d.helpers.objects.Vec4;
	import utme.views.main.stage3d.helpers.H_MOMA01ImageUtils;
	import utme.views.main.stage3d.helpers.Stage3DHelper;

	public class V3D15_MOMA01Impl extends V3D19_RemixBaseImpl{
		
		public function V3D15_MOMA01Impl(_weakMode:Boolean){
			super(true,_weakMode);
			mNeedCache=true;
			parts=new Vector.<IPPerticles>;
			var i:int;
			knlHeight =256;	
			knlWidth=knlHeight*UTItemManager.IMAGE_WIDTH/Number(UTItemManager.IMAGE_HEIGHT) ;
			prtHeight=64;
			prtWidth=prtHeight*UTItemManager.IMAGE_WIDTH/Number(UTItemManager.IMAGE_HEIGHT );
			rndWidth=UTItemManager.IMAGE_WIDTH;
			rndHeight=UTItemManager.IMAGE_HEIGHT;
			KernelCovorRangeX=rndWidth/(knlWidth-1)*5;
			KernelCovorRangeY=rndHeight/(knlHeight-1)*5;
			
			for(i=0;i<prtHeight*prtWidth;i++){
				parts.push(new IPPerticles());
			}
			setStyle(mStyle);
		}
		
		private var knlHeight:int =256;	
		private var knlWidth:int=knlHeight*UTItemManager.IMAGE_WIDTH/UTItemManager.IMAGE_HEIGHT ;
		private var  prtHeight:int=30;
		private var  prtWidth:int=prtHeight*UTItemManager.IMAGE_WIDTH/UTItemManager.IMAGE_HEIGHT ;
		private var rndWidth:int=UTItemManager.IMAGE_WIDTH;
		private var rndHeight:int=UTItemManager.IMAGE_HEIGHT;
		public var mStyle:int=-1;
		
		private var _isEnableNextBtn:Boolean;
		public var changeNextBtnCallback:Function=null;;
		
		private var optHeight:int;
		
		public override function initWithData(backBmd:BitmapData,srcBmd:BitmapData):void{
			if(srcImage==null){
				trace("begin");
				var _srcThumb:BitmapData=new BitmapData(knlWidth,knlHeight,true,0);
				var mat:Matrix=new Matrix;
				mat.scale(_srcThumb.width/srcBmd.width,_srcThumb.height/srcBmd.height);
				_srcThumb.draw(srcBmd,mat,null,null,null,true);
				srcImage=_srcThumb.getPixels(_srcThumb.rect);
				var bmd:BitmapData=new BitmapData(knlWidth,knlHeight,true,0);
				bmd.perlinNoise(knlHeight/30,knlHeight/30,1,Math.random()*10000,false,true);
				var rect:Rectangle=bmd.rect;
				bmd.draw(_srcThumb,null,null,null,bmd.rect);
				optImage=H_MOMA01ImageUtils.calcOpticalFlowByteArray(bmd);
			}
			super.init3D(backBmd,null);
		}

		
		private var optImage:ByteArray=null;
		private var srcImage:ByteArray=null;
		
		private var parts:Vector.<IPPerticles>;
		private static const LumCoeff:Vec4=new Vec4(0.2125, 0.7154, 0.0721);
		private static const AvgLumin:Vec4=new Vec4(0.5,0.5,0.5);
		
		
		
		private function  ContrastSaturationBrightness(color:Vec4, brt:Number,sat:Number,con:Number):Vec4{
			var brtColor:Vec4 = new Vec4(color.x,color.y,color.z,color.w);
			color.multiply(brt);
			var  intensity:Number = brtColor.dot( LumCoeff)*(1.0-sat);
			brtColor.multiply(sat);
			brtColor.add(intensity);
			brtColor.multiply(con);
			var  conColor:Number = 0.5*(1-con)
			brtColor.add(conColor);
			return brtColor;
		}
		

		 
		
		private function getRandom():Number{
			return Math.random()*2.0-1.0;
		}
		protected override function setup():void{
			texture=Stage3DHelper.uploadTexture(mCtx3D,new TextureParticleMOMAPAINT, Context3DTextureFormat.BGRA,true,true)
		}
		
		
		private var BOOST_SPEED:Number=2;
		private var LIGHT_SPEED:int=2;

		private var isMonoral:Boolean=false;;
		
		private var  _colorNoize:Number=0.066;
		private var  _brigtnessNoize:Number=0.066;
		private var  _alpha:Number=1;
		private var  _alphaStep:Number=0.095;
		private var  _scale:Number=0.7;
		private var  _lifeLength:int=300/BOOST_SPEED;
		private var  _brightness:Number=1;
		private var  _contrast:Number=1.5;
		private var  _saturation:Number=1.5;
		
		private var texture:Texture;
		private var KernelCovorRangeX:Number;
		private var KernelCovorRangeY:Number;
		private var _BORDER_MARGIN:Number = 50;
		private var toggler:int;

		protected override function draw():void{
			mActivePow*=0.90;
			if(motion<1)return;
			
			motion--;
			mCtx3D.setTextureAt(0,texture);
			mCtx3D.setVertexBufferAt(0, mVerts, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setVertexBufferAt(1, mCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
			
			
			var i:int;
			var col:Vec4;
			var vec:Vec4=new Vec4;
			var p:int;
			var srcCol:Vec4=new Vec4;
			toggler++;
			if(toggler+1>LIGHT_SPEED)toggler=0;
				
			for(i=0;i<prtHeight*prtWidth;i++){
				if(i%LIGHT_SPEED!=toggler)continue;
				var pt:IPPerticles=parts[i];
				if(pt.orgAlpha){
					p=H_MOMA01ImageUtils.clampi(pt.y/(rndHeight-1)*(knlHeight-1),0,knlHeight-1)*knlWidth+H_MOMA01ImageUtils.clampi(pt.x/(rndWidth-1)*(knlWidth-1),0,knlWidth-1);
					
					vec.x=(optImage[p*2]-127.0)*0.02*10*BOOST_SPEED;
					vec.y=(optImage[p*2+1]-127.0)*0.02*10*BOOST_SPEED;
					
					pt.x+=vec.x;
					pt.y+=vec.y;
					
					
					mUniformMatrix[0] = pt.x;
					mUniformMatrix[1] = rndHeight- pt.y;
					mUniformMatrix[2] = 0;
					mUniformMatrix[3] = 40*pt.scale;
					
					mUniformColor[3]=pt.alpha*pt.orgAlpha;
					mUniformColor[0]=pt.r*mUniformColor[3] ;
					mUniformColor[1]=pt.g*mUniformColor[3] ;
					mUniformColor[2]=pt.b*mUniformColor[3] ;
					
					var border:Number=mUniformMatrix[3]*.55;
					
					if(mUniformColor[3]>0){
						
						if(pt.x>border&&
							pt.y>border&&
							pt.x<UTItemManager.IMAGE_WIDTH-border&&
							pt.y<UTItemManager.IMAGE_HEIGHT-border
						){
							mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mUniformColor);
							mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mUniformMatrix);
							mCtx3D.drawTriangles(mIndicies);
						}else{
							pt.orgAlpha=0;
						}
					}
					
					if(pt.alpha<1){
						pt.alpha+=_alphaStep;
						if(pt.alpha>1)pt.alpha=1;
					}
				}
				pt.life--;
				if(pt.life<0){
					
					pt.x=pt.orgX+getRandom()*KernelCovorRangeX-KernelCovorRangeX*.5;
					pt.y=pt.orgY+getRandom()*KernelCovorRangeY-KernelCovorRangeY*.5;
					
					pt.life=Math.random()*_lifeLength;
					pt.scale=Math.random()*_scale+0.1;
					
					p=H_MOMA01ImageUtils.clampi(pt.y/(rndHeight-1)*(knlHeight-1),0,knlHeight-1)*knlWidth+H_MOMA01ImageUtils.clampi(pt.x/(rndWidth-1)*(knlWidth-1),0,knlWidth-1);
					
					srcCol.x=srcImage[p*4+1]/255.0;
					srcCol.y=srcImage[p*4+2]/255.0;
					srcCol.z=srcImage[p*4+3]/255.0;
					
					col=ContrastSaturationBrightness(srcCol,
						_brightness,
						isMonoral?0.1:_saturation,
						_contrast);
					
					col.x=H_MOMA01ImageUtils.clampf(col.x,0,1);
					col.y=H_MOMA01ImageUtils.clampf(col.y,0,1);
					col.z=H_MOMA01ImageUtils.clampf(col.z,0,1);
					
					var vn:Number=getRandom()*_brigtnessNoize;
					pt.r=col.x+getRandom()*_colorNoize+vn;
					pt.g=col.y+getRandom()*_colorNoize+vn;
					pt.b=col.z+getRandom()*_colorNoize+vn;
					
					pt.orgAlpha=srcImage[p*4]/255.0 ;
					pt.alpha=_alpha;
				}
			}	
			
			
		}
		private var mActivePow:Number=0;
		private var mTime:Number=-1;
		protected override function addedForce(_x:Number,_y:Number):void{
			motion+=1;
			
			var t:Number=(new Date).time;
			mActivePow+=Math.min(Math.sqrt(_x*_x+_y*_y)*(t-mTime)/1000,1.0);
			mTime=t;
			
			var power:Number=(mActivePow-5)/4.0;
			if(power<0)power=0;
			if(power>1)power=1;
			
			_colorNoize=_colorNoize_s+(_colorNoize_e-_colorNoize_s)*power;
			_brigtnessNoize=_brigtnessNoize_s+(_brigtnessNoize_e-_brigtnessNoize_s)*power;
			_alpha=_alpha_s+(_alpha_e-_alpha_s)*power;
			_alphaStep=_alphaStep_s+(_alphaStep_e-_alphaStep_s)*power;
			_scale=_scale_s+(_scale_e-_scale_s)*power;
			_lifeLength=_lifeLength_s+(_lifeLength_e-_lifeLength_s)*power;
			_brightness=_brightness_s+(_brightness_e-_brightness_s)*power;
			_contrast=_contrast_s+(_contrast_e-_contrast_s)*power;
			_saturation=_saturation_s+(_saturation_e-_saturation_s)*power;
			
			
			if(!_isEnableNextBtn&&_counter>10){
				_isEnableNextBtn=true;
				changeNextBtnCallback(true);
			}
			_counter++;
			
		}
		private var _counter:Number;
		private var  _colorNoize_s:Number=0.066;
		private var  _brigtnessNoize_s:Number=0.066;
		private var  _alpha_s:Number=1;
		private var  _alphaStep_s:Number=0.095;
		private var  _scale_s:Number=0.7;
		private var  _lifeLength_s:int=300/BOOST_SPEED;
		private var  _brightness_s:Number=1;
		private var  _contrast_s:Number=1.5;
		private var  _saturation_s:Number=1.5;
		
		private var  _colorNoize_e:Number=0.066;
		private var  _brigtnessNoize_e:Number=0.066;
		private var  _alpha_e:Number=1;
		private var  _alphaStep_e:Number=0.095;
		private var  _scale_e:Number=0.7;
		private var  _lifeLength_e:int=300/BOOST_SPEED;
		private var  _brightness_e:Number=1;
		private var  _contrast_e:Number=1.5;
		private var  _saturation_e:Number=1.5;
		
		public function setStyle(style:int):void{
					
			mStyle=style;
			
			switch(mStyle){
				case 1:
					_colorNoize_s=0.066;
					_brigtnessNoize_s=0.2;
					_alpha_s=1;
					_alphaStep_s=0.095;
					_scale_s=0.5;
					_lifeLength_s=300/BOOST_SPEED;
					_brightness_s=1;
					_contrast_s=1.5;
					_saturation_s=1.5;
					
					_colorNoize_e=0.5;
					_brigtnessNoize_e=0.5;
					_alpha_e=1;
					_alphaStep_e=1;
					_scale_e=0.32;
					_lifeLength_e=500/BOOST_SPEED;
					_brightness_e=1;
					_contrast_e=1.5;
					_saturation_e=1.5;
					break;
				case 2:
					_colorNoize_s=0.5;
					_brigtnessNoize_s=0.1215;
					_alpha_s=1;
					_alphaStep_s=1;
					_scale_s=0.8;
					_lifeLength_s=4/BOOST_SPEED;
					_brightness_s=1;
					_contrast_s=1.5;
					_saturation_s=1.29;
					
					_colorNoize_e=0.2;
					_brigtnessNoize_e=0.123;
					_alpha_e=1;
					_alphaStep_e=1;
					_scale_e=1.5;
					_lifeLength_e=4/BOOST_SPEED;
					_brightness_e=1;
					_contrast_e=1.5;
					_saturation_e=1.29;
					break;
				default:
					_colorNoize_s=0.1;
					_brigtnessNoize_s=0.1;
					_alpha_s=0;
					_alphaStep_s=0.02;
					_scale_s=1.5;
					_lifeLength_s=50/BOOST_SPEED;
					_brightness_s=1;
					_contrast_s=1.505;
					_saturation_s=1.28;
					
					_colorNoize_e=0.2;
					_brigtnessNoize_e=0.1;
					_alpha_e=0;
					_alphaStep_e=0.03;
					_scale_e=1.0;
					_lifeLength_e=50/BOOST_SPEED;
					_brightness_e=1;
					_contrast_e=1.505;
					_saturation_e=1.28;
					break;
			}
			clear();
		}
		
		private var  motion:int
		
		public override function clear():void{	
			var y:int;
			var x:int;
			_isEnableNextBtn=false;
			if(changeNextBtnCallback!=null)changeNextBtnCallback(false);

			_counter=0;
			motion=0;
			mActivePow=0;
			
			for(y=0;y<prtHeight;y++){
				for(x=0;x<prtWidth;x++){
					parts[y*prtWidth+x].orgX=rndWidth*x/(prtWidth)+(rndWidth/prtWidth)*.5;
					parts[y*prtWidth+x].orgY=rndHeight*y/(prtHeight)+(rndHeight/prtHeight)*.5;
					parts[y*prtWidth+x].life=150*Math.random();
					parts[y*prtWidth+x].alpha=0;
					parts[y*prtWidth+x].orgAlpha=0;
				}
			}
			if(mCtx3D)super.clear();
		}	
	}
}