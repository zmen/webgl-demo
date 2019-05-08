package utme.views.main.stage3d
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageQuality;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import fl.motion.AdjustColor;
	
	import utme.app.UTCreateMain;
	import utme.app.consts.AppStoryDefs;
	import utme.app.consts.AppVals;
	import utme.app.managers.UTItemManager;
	import utme.views.main.stage3d.helpers.H_MOMA02CPerticles;
	
	public class V3D16_MOMA02Impl extends V3D19_RemixBaseImpl{
		
		
		private var parts:Vector.<H_MOMA02CPerticles>;
		private var _srcBmd:BitmapData;

		private const SHADOW_WIDTH:Number=30;
		private const MIN_WIDTH:Number=100;
		private const MAX_PERTS:Number=40;
		private var activeIndex:int=0; 
		
		private const SCALE_BIAS_UP:Number=4;
		private const SCALE_BIAS:Number=1.0/SCALE_BIAS_UP;
		
		private var srcRect:Rectangle;
		//private var isFaceRecognize:Boolean;
		
		private var BOOST_SPEED:Number=2;
		private var LIGHT_SPEED:int=5;
		private var mask:Shape;
		private var tmpView:MovieClip;
		private var tmpViewlayer:Bitmap;
		private var eyes_r:Rectangle;
		private var mouth_r:Rectangle;
		private var eye_l:Rectangle;
		private var partsIndex:int;
		private var itemIndex:int;
		public var mStyle:int=0;
		private var toggler:int;
		private var _thumBmd:BitmapData
		private var _srcTypePhoto:Boolean;
		
		private var _isEnableNextBtn:Boolean;
		public var changeNextBtnCallback:Function=null;;
		
		public function V3D16_MOMA02Impl(_weakMode:Boolean){
			parts=new Vector.<H_MOMA02CPerticles>;
			for(var i:int=0;i<MAX_PERTS;i++)parts.push(new H_MOMA02CPerticles());
			mask=new Shape;
			
			tmpView=new MovieClip;
			tmpViewlayer=new Bitmap;
			tmpView.addChild(tmpViewlayer);
			tmpView.addChild(mask);
			tmpViewlayer.mask=mask;
			shadwoPreviewActive=new DropShadowFilter(0,0,0,0.3,SHADOW_WIDTH*SCALE_BIAS,SHADOW_WIDTH*SCALE_BIAS,1.0,2);
			shadwoOutActive=new DropShadowFilter(0,0,0,0.3,SHADOW_WIDTH,SHADOW_WIDTH,1.0,2);
			
			shadwoInPreviewActive=new DropShadowFilter(0,0,0,1,SHADOW_WIDTH*SCALE_BIAS*.2,SHADOW_WIDTH*SCALE_BIAS*.2,1.0,2);
			shadwoINOutActive=new DropShadowFilter(0,0,0,1,SHADOW_WIDTH*.2,SHADOW_WIDTH*.2,1.0,2);
			
			colorManager=new AdjustColor;
		
			colorManager.brightness=0;
			colorManager.contrast=0;
			colorManager.saturation=0;
			colFilter=new ColorMatrixFilter;
			
			_srcTypePhoto=UTCreateMain.getActiveSrcType()==AppStoryDefs.VIEW_SRC_PHOTO;
			
			super(true,_weakMode);
		}
		
		public override function initWithData(backBmd:BitmapData,srcBmd:BitmapData):void{
			_srcBmd=srcBmd;
			srcRect=_srcBmd.getColorBoundsRect(0xff000000, 0, false);
			_thumBmd=new BitmapData(_srcBmd.width*SCALE_BIAS,_srcBmd.height*SCALE_BIAS,true,0);
			var mat:Matrix;
			mat=new Matrix;
			mat.scale(_thumBmd.width/_srcBmd.width,_thumBmd.height/_srcBmd.height);
			_thumBmd.draw(_srcBmd,mat,null,null,null,true);
			tmpViewlayer.bitmapData=_thumBmd;
			tmpViewlayer.smoothing=true;
			super.init3D(backBmd,null);
		}
		
		private function getRandom():Number{
			return Math.random()*2.0-1.0;
		}
		
		private var imageRect:Boolean;
		
		private var shadwoPreviewActive:DropShadowFilter;
		private var shadwoOutActive:DropShadowFilter;
		private var shadwoInPreviewActive:DropShadowFilter;
		private var shadwoINOutActive:DropShadowFilter;
		protected override function setup():void{
			var i:int;

			mFBO.dispose();
			mFBO= mCtx3D.createTexture(AppVals.TEXTURE_WIDTH/2 , AppVals.TEXTURE_WIDTH/2,Context3DTextureFormat.BGRA,true);
			
			for(i=0;i<MAX_PERTS;i++)parts[i].setCtx(mCtx3D);
			recreateTexture();
		}
		
		protected override function draw():void{
			mCtx3D.clear(0,0,0,0);
			mCtx3D.setProgram(mNoMipShader);
			mCtx3D.setVertexBufferAt(0, mVerts, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setVertexBufferAt(1, mCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
			var i:int;
			
			for(i=activeIndex;i<parts.length;i++){
				parts[i].draw(mIndicies);
			}
			for(i=0;i<activeIndex;i++){
				parts[i].draw(mIndicies);
			}
			mCtx3D.setProgram(mMipShader);
			
			mActivePow*=0.90;
		}
		
		public override function captureToBitmap(bmd:BitmapData):void{
			var i:int
			for(i=0;i<MAX_PERTS;i++)parts[i].destory();
			tmpView.filters=[new DropShadowFilter(0,0,0,1,SHADOW_WIDTH,SHADOW_WIDTH,1.0,2)];
			
			mFBO.dispose();
			mFBO= mCtx3D.createTexture(AppVals.TEXTURE_WIDTH , AppVals.TEXTURE_WIDTH,Context3DTextureFormat.BGRA,true);
			
			mCtx3D.setRenderToTexture(mFBO);
			mCtx3D.clear(0,0,0,0);
			mCtx3D.setProgram(mNoMipShader);
			mCtx3D.setVertexBufferAt(0, mVerts, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setVertexBufferAt(1, mCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
			recreateAndDrawTexture();
			mCtx3D.setProgram(mMipShader);
			for(i=0;i<MAX_PERTS;i++)parts[i].destory();
			super.captureToBitmap(bmd);
		}
		
		public function recreateAndDrawTexture():void{
			
			tmpViewlayer.bitmapData=_srcBmd;
			tmpViewlayer.smoothing=true;
			
			var mat:Matrix=new Matrix;
			var rect:Rectangle=new Rectangle;
			var scale:Number=1;
			var scale_up:Number=SCALE_BIAS_UP;
			
			var i:int;
			
			for(i=activeIndex;i<parts.length;i++){
				recreateAndDraw(parts[i]);
			}
			for(i=0;i<activeIndex;i++){
				recreateAndDraw(parts[i]);
			}
			function recreateAndDraw(pt:H_MOMA02CPerticles):void{
				if(!pt.bAllocated)return;
				rect.x=(pt.org_x-pt.org_width*.5);
				rect.y=(pt.org_y-pt.org_height*.5);
				rect.width=pt.org_width;
				rect.height=pt.org_height;
				updateMask(rect,mStyle,scale);
				var _bmd:BitmapData=new BitmapData(pt.texSize*scale_up,pt.texSize*scale_up,true,0);
				mat.identity();
				mat.translate(-pt.tx*scale_up,-pt.ty*scale_up);
				colorManager.hue=pt.hue;
				colFilter.matrix=colorManager.CalculateFinalFlatArray();
				tmpView.filters=[colFilter,shadwoOutActive,shadwoINOutActive];
				_bmd.drawWithQuality(tmpView,mat,null,null,null,true,StageQuality.HIGH);
				pt.updateTexture(_bmd);
				_bmd.dispose();	
				pt.draw(mIndicies);
				pt.destory();
			}
		}
		
		
		public function recreateTexture():void{
			var i:int
			tmpViewlayer.bitmapData=_thumBmd;
			var mat:Matrix=new Matrix;
			var rect:Rectangle=new Rectangle;
			var scale:Number=SCALE_BIAS;
			var scale_up:Number=1;
			
			for(i=0;i<MAX_PERTS;i++){
				var pt:H_MOMA02CPerticles=parts[i];
				if(!pt.bAllocated)continue;
				
				rect.x=(pt.org_x-pt.org_width*.5);
				rect.y=(pt.org_y-pt.org_height*.5);
				rect.width=pt.org_width;
				rect.height=pt.org_height;
				
				updateMask(rect,mStyle,scale);
				
				var _bmd:BitmapData=new BitmapData(pt.texSize*scale_up,pt.texSize*scale_up,true,0);
				mat.identity();
				mat.translate(-pt.tx*scale_up,-pt.ty*scale_up);
				colorManager.hue=pt.hue;
				colFilter.matrix=colorManager.CalculateFinalFlatArray();
				tmpView.filters=[colFilter,shadwoPreviewActive,shadwoInPreviewActive];
				_bmd.drawWithQuality(tmpView,mat,null,null,null,true,StageQuality.HIGH);
				pt.updateTexture(_bmd);
				_bmd.dispose();				
			}	
		}
		
		
		public function setStyle(style:int):void{
			mStyle=style;
			clear();
		}
		
		
		private function updateMask(rect:Rectangle,style:int,scale:Number):void{
			mask.graphics.clear();
			mask.graphics.beginFill(0xFFFFFF,1);
			if(style==1){
				//Full Circler
				mask.graphics.drawRoundRect(
					SHADOW_WIDTH*scale,
					SHADOW_WIDTH*scale,
					(rect.width-SHADOW_WIDTH*2)*scale,
					(rect.height-SHADOW_WIDTH*2)*scale,
					(rect.width-SHADOW_WIDTH*2)*scale,
					(rect.height-SHADOW_WIDTH*2)*scale
				);
			}else if(style==2){
				//Full Circler
				var tri:Vector.<Number>=new Vector.<Number>;
				for(var i:int=0;i<3;i++){
					tri.push(SHADOW_WIDTH*scale+Math.random()*(rect.width-SHADOW_WIDTH*2)*scale);
					tri.push(SHADOW_WIDTH*scale+Math.random()*(rect.height-SHADOW_WIDTH*2)*scale);
				}
				mask.graphics.drawTriangles(tri);
			}else{
				//Rectangle
				mask.graphics.drawRect(
					SHADOW_WIDTH*scale,
					SHADOW_WIDTH*scale,
					(rect.width-SHADOW_WIDTH*2)*scale,
					(rect.height-SHADOW_WIDTH*2)*scale
				);
			}
			mask.graphics.endFill();
			tmpViewlayer.x=-rect.x*scale;
			tmpViewlayer.y=-rect.y*scale;
		}
		
		
		
		private var mActivePow:Number=0;
		private var mTime:Number=-1;
		private var _intervalPoinst:Number
		private var _animaCounter:Number=0;
		private var colorManager:AdjustColor;
		private var colFilter:ColorMatrixFilter;
		protected override function addedForce(_x:Number,_y:Number):void{
			
			var t:Number=(new Date).time;
			mActivePow+=Math.min(Math.sqrt(_x*_x+_y*_y)*(t-mTime)/1000,1.0);
			mTime=t;
			
			var power:Number=(mActivePow-5)/4.0;
			if(power<0)power=0;
			if(power>1)power=1;
			
			_animaCounter+=power;
			if(_animaCounter<1.0){
			
			}else{

			//	var maxSide:Number=1024+power*(800-1024);		
			//	var minSide:Number=SHADOW_WIDTH*2+MIN_WIDTH+20*(1-power);
				
				motion+=1;
				if(motion<3)return;
				motion=0;
				
				var rect:Rectangle=null;
				
				var scale:Number=Math.random()*0.8+0.5+(0.5-0.5)*(1-power);
				var rad:Number=(Math.random()-0.5)*0.13;
				
				var areaMaxWidth:Number=UTItemManager.IMAGE_WIDTH;
				var areaMaxHeight:Number=UTItemManager.IMAGE_HEIGHT;
				
				var LONG_WID:Number=800+(400-800)*(1-power);
				var SHORT_WID:Number=700+(200-700)*(1-power);
				
				var MaxMenseki:Number=LONG_WID*LONG_WID;
				var MinMenseki:Number=SHORT_WID*SHORT_WID;
				var MIN_SIDE:Number=SHADOW_WIDTH*2+MIN_WIDTH;
				
				var Menseki:Number=MinMenseki+(MaxMenseki-MinMenseki)*Math.random();
				var SISE_MAX:Number=Math.sqrt(Menseki);
				
				if(rect==null){
					rect=new Rectangle;
					const TEX_MAX:Number=1024;
					
					var area:Rectangle=new Rectangle;
					
					var AREA_MARGIN:Number=200;
					if(mStyle==1&&_srcTypePhoto)AREA_MARGIN=0;	
					
					area.x=Math.max(0,srcRect.x-AREA_MARGIN);
					area.y=Math.max(0,srcRect.y-AREA_MARGIN);	
					area.width=Math.min(areaMaxWidth-area.x, srcRect.width+AREA_MARGIN*2) ;
					area.height=Math.min(areaMaxHeight-area.y, srcRect.height+AREA_MARGIN*2) ;
					
					
					if(mStyle==1){
						rect.width=rect.height=Math.sqrt(Menseki);
						rect.x=Math.random()*(area.width-rect.width)+area.x;
						rect.y=Math.random()*(area.height-rect.height)+area.y;
					}else{
						//var menseki:Number=700*700+(300*300-700*700)*power
			
						if(Math.random()<0.5){
							rect.width=Math.min(TEX_MAX,Math.max(SISE_MAX*(0.4+Math.random()) ) );
							rect.height=Math.min(TEX_MAX,Menseki/rect.width);
						}else{
							rect.height=Math.min(TEX_MAX,Math.max(SISE_MAX*(0.4+Math.random()) ) );
							rect.width=Math.min(TEX_MAX,Menseki/rect.height);
						}
						
						rect.x=Math.random()*(area.width-rect.width)+area.x;
						rect.y=Math.random()*(area.height-rect.height)+area.y;
					}	
				}
				
				updateMask(rect,mStyle,SCALE_BIAS);
				var bmd2:BitmapData=new BitmapData(rect.width*SCALE_BIAS,rect.height*SCALE_BIAS,true,0);

				
				var pt:H_MOMA02CPerticles=parts[activeIndex];	
				pt.hue=20*(Math.random()-0.5);
				colorManager.hue=pt.hue;
				colFilter.matrix=colorManager.CalculateFinalFlatArray();
				tmpView.filters=[colFilter,shadwoPreviewActive,shadwoInPreviewActive];
				bmd2.drawWithQuality(tmpView,null,null,null,null,true,StageQuality.HIGH);
				
				//はみ出し処理
				var cx:Number =Math.max(
					Math.abs( rect.width*.5*scale*Math.cos(rad)-rect.height*.5*scale*Math.sin(rad)),
					Math.abs( rect.width*.5*scale*Math.cos(rad)+rect.height*.5*scale*Math.sin(rad))
				);
				var cy:Number =Math.max(
					Math.abs( rect.width*.5*scale*Math.sin(rad)+rect.height*.5*scale*Math.cos(rad)),
					Math.abs( rect.width*.5*scale*Math.sin(rad)-rect.height*.5*scale*Math.cos(rad))
				);
				
				var px:Number=rect.x+rect.width*.5;
				var py:Number=rect.y+rect.height*.5;
				if(px-cx<0)scale*=px/cx;
				if(px+cx>areaMaxWidth)scale*=(areaMaxWidth-px)/cx;
				if(py-cy<0)scale*=py/cy;
				if(py+cy>areaMaxHeight)scale*=(areaMaxHeight-py)/cy;
				
				pt.setup(bmd2,px,py,rect.width,rect.height,rad,scale*SCALE_BIAS_UP);
				bmd2.dispose();	
			}
			
			activeIndex++;
			if(activeIndex+1>MAX_PERTS)activeIndex=0;
			
			pt=parts[activeIndex];
			pt.setOrgRadWithScale(0,0);
			if(!_isEnableNextBtn&&activeIndex>3){
				_isEnableNextBtn=true;
				changeNextBtnCallback(true);
			}
		}
		
		private var  motion:int
		
		public override function clear():void{
			_isEnableNextBtn=false;
			changeNextBtnCallback(false);
			_intervalPoinst=0;
			motion=0;
			activeIndex=0;
			itemIndex=0;
			partsIndex=0;
			mActivePow=0;
			_animaCounter=100;
			for(var i:int=0;i<MAX_PERTS;i++)parts[i].dispose();
			
			super.clear();
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		//Face Recongnize
		
	
		

	}
}

