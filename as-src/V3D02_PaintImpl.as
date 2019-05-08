package  utme.views.main.stage3d
{
	
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jp.uniqlo.utlab.assets.images.TextureParticle01;
	import jp.uniqlo.utlab.assets.images.TextureParticle02;
	import jp.uniqlo.utlab.assets.images.TextureParticle04;
	import jp.uniqlo.utlab.assets.images.TextureParticle05;
	import jp.uniqlo.utlab.assets.images.TextureParticle06;
	import jp.uniqlo.utlab.assets.images.TextureParticle07;
	
	import utme.app.NSFuncs.UTDeviceCapabilities;
	import utme.app.consts.AppVals;
	import utme.app.managers.UTItemManager;
	import utme.app.managers.UTTopLayerManager;
	import utme.views.common.classes.UTImageBuilder;
	import utme.views.common.classes.viewHelpers.Easing;
	import utme.views.main.stage3d.helpers.PVParticle;
	import utme.views.main.stage3d.helpers.PVVectprField;
	import utme.views.main.stage3d.helpers.Stage3DHelper;
	
	public class V3D02_PaintImpl extends EventDispatcher
	{
		private var mVF:PVVectprField;
		private var mParticles:Vector.<PVParticle>;
		
		//context3D
		public var stage3d:Stage3D;
		private var mCtx3D:Context3D;
		
		private var mVerts:VertexBuffer3D;
		private var mCoords:VertexBuffer3D;
		private var mVertsStage:VertexBuffer3D;
		private var mIndicies:IndexBuffer3D;
		private var mMipShader:Program3D;
		private var mNoMipShader:Program3D;
		private var mTexBaseT:Texture;
		private var mFBO:Texture;
		private var mUniformMatrix:Vector.<Number>;
		private var mUniformColor:Vector.<Number>;
		private var mScreenMatrix:Matrix3D;
		private var mFBOMatrix:Matrix3D;
		private var _bmdBackImage:BitmapData;
		
		private var mPrevMouseX:Number; 
		private var mPrevMouseY:Number; 
		private var mPrevDiffX:Number;
		private var mPrevDiffY:Number;
		private var mFudeSize:Number=1.2;
		private var mColorRandRange:Number=1.0;
		private var mActiveColor:uint=0xFF00FF;		
		private var _drawingEnabled:Boolean;
		public var _isZoom:Boolean;
		public var currentScale:Number=0;
		private var _currentRect:Rectangle;
		
		private var mCacheBmd:BitmapData;
		private var mBackImage:BitmapData;
		private var mTexParts:Vector.<Texture>;
		
		private var mDisplayFboMatrix:Matrix3D;
		public var colorSelectMode:Boolean=false;
		public var selectedColor:int=0;
		public var CBcolorChanged:Function=null;
		private var _painted:Boolean;
		public var onPainted:Function;
		
		public function V3D02_PaintImpl() {
			mVF=new PVVectprField;
			mParticles=new Vector.<PVParticle>;
			_isZoom=false;
			currentScale=_isZoom?1:0;
			_painted=false;
			
			
		}
		
		public function initWithData(backBmd:BitmapData,cacheBmd:BitmapData):void{

			mCacheBmd=cacheBmd;
			mBackImage=backBmd;
			
			init3D(mBackImage);
		}

		public function dispose():void{		
			
			stopRendering();
			stage3d.removeEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);
			AppVals.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
			mParticles.length=0;
			
			
			mMipShader.dispose();
			mMipShader=null;
			mNoMipShader.dispose();
			mNoMipShader=null;
			
			mVerts.dispose();
			mVerts=null;
			mCoords.dispose();
			mCoords=null;
			mVertsStage.dispose();
			mVertsStage=null;
			mIndicies.dispose();
			mIndicies=null;
			if(texTopLayer)texTopLayer.dispose();

			for(var i:int=0;i<mTexParts.length;i++){
				mTexParts[i].dispose();
			}
			mTexParts.length=0;
			mTexParts=null;
			
			if(mTexBaseT)mTexBaseT.dispose();
			mTexBaseT=null;
			mFBO.dispose();
			mFBO=null;
			
			mUniformMatrix.length=0;
			mUniformMatrix=null;
			mUniformColor.length=0;
			mUniformColor=null;
			
			mScreenMatrix=null;
			mFBOMatrix=null;
	
			mCacheBmd=null;
			_bmdBackImage=null;
			mCtx3D.dispose();
			mCtx3D=null;
			stage3d=null;
		}
		
		public function stopRendering():void{
			_drawingEnabled=false;
		}
		
		public function startRendering():void{
			_drawingEnabled=true;
			_toScale=0;
		}
		
		public function toggleScale():void{
			_isZoom=!_isZoom;
		}
		
		private var _eraseMode:Boolean
		public function setEraseMode(eraseMode:Boolean):void{
			mParticles.length=0;
			_eraseMode=eraseMode;
		}
		
		public function getEraseMode():Boolean{return _eraseMode;}
		
		public function setSelectedToolMode(toolMode:String):void {
			if(toolMode == "eraserMenuBtn")
				AppVals.SELECTED_TOOL_MODE = AppVals.ERASE_MODE;
			else if(toolMode == "thickBrushBtn")
				AppVals.SELECTED_TOOL_MODE = AppVals.THICK_BRUSH_MODE;
			else if(toolMode == "thinBrushBtn")
				AppVals.SELECTED_TOOL_MODE = AppVals.THIN_BRUSH_MODE;
		}
		
		public function getSelectedToolMode():String {
			return AppVals.SELECTED_TOOL_MODE;
			
		}
		
		protected function init3D(back:BitmapData):void{

			mScreenMatrix = new Matrix3D();
			mVF.setupField(UTItemManager.IMAGE_WIDTH/75,UTItemManager.IMAGE_HEIGHT/75,UTItemManager.IMAGE_WIDTH,UTItemManager.IMAGE_HEIGHT);
			
			_drawingEnabled=false;
			_bmdBackImage=back;
		
			stage3d=AppVals.stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);
			stage3d.requestContext3D(Context3DRenderMode.AUTO,AppVals.STAGE3D_PROFILE);
		}
		
		public function updateTopLayer():void{
			hasTopLayer=UTTopLayerManager.hasTopLayer();
			if(hasTopLayer){
				texTopLayer=Stage3DHelper.uploadTexture(mCtx3D,UTTopLayerManager.getTopLayerThumbImage(),Context3DTextureFormat.BGRA,true,true);
			}
		}
		
		private var hasTopLayer:Boolean;
		private var texTopLayer:Texture;
		private function context3DCreateHandler(e:Event):void {
			trace("context created");
			//Begin Stage 3Ds////////////////////////////////////////////////////////////////
			//stage3d.removeEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);
			onDeactive();
			
			mTexBaseT=null;
			mCtx3D = Stage3D(e.target).context3D;
			
			if(AppVals.DEBUG_MODE)mCtx3D.enableErrorChecking=true;
			
			trace(mCtx3D.driverInfo);
			
			onResize();
			
			var vertices:Vector.<Number> = new <Number>[-0.5, -0.5, 0.5, -0.5, -0.5, 0.5, 0.5, 0.5];
			var coords:Vector.<Number>   = new <Number>[0, 1, 1, 1, 0, 0, 1, 0];
			var a:Number=UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
			var verticesStg:Vector.<Number> = new <Number>[-0.5, -a*0.5, 0.5, -a*0.5, -0.5, a*0.5, 0.5, a*0.5];

			mVerts = mCtx3D.createVertexBuffer(4,2);
			mVerts.uploadFromVector(vertices, 0, 4);	
			mCoords = mCtx3D.createVertexBuffer(4,2);
			mCoords.uploadFromVector(coords, 0, 4);	
			mVertsStage = mCtx3D.createVertexBuffer(4, 2);
			mVertsStage.uploadFromVector(verticesStg, 0, 4);	
			
			var indices:Vector.<uint> = new <uint>[0,2,1,2,3,1];
			mIndicies = mCtx3D.createIndexBuffer(6);
			mIndicies.uploadFromVector(indices, 0, 6);
			
			///////////////////////////////////////////////////////////////////////////////////////////
				
			mFBOMatrix = new Matrix3D();
			mFBOMatrix.appendTranslation(-UTItemManager.IMAGE_WIDTH*.5,-UTItemManager.IMAGE_HEIGHT*.5,0);
			mFBOMatrix.appendScale(1/(UTItemManager.IMAGE_WIDTH*.5), 1/(UTItemManager.IMAGE_HEIGHT*.5), 1);
			mFBO= mCtx3D.createTexture(AppVals.TEXTURE_WIDTH , AppVals.TEXTURE_WIDTH,Context3DTextureFormat.BGRA,true);
			
			
			
			
			mUniformMatrix=new <Number>[0.0,0.0,0.0,1.0];
			mUniformColor=new <Number>[1.0,1.0,1.0,1.0];
			
			///////////////////////////////////////////////////////////////////////////////////////////
			mTexParts=null;
			mTexParts=new Vector.<Texture>;
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle01, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle02, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle04, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle05, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle06, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle07, Context3DTextureFormat.BGRA,true,true));
			
			///////////////////////////////////////////////////////////////////////////////////////////
			mDisplayFboMatrix = new Matrix3D();
			mDisplayFboMatrix.appendScale(1/(1024*.5), 1/(1024*.5), 1);
			
			mMipShader=Stage3DHelper.createMainProgram(mCtx3D,true);
			mNoMipShader=Stage3DHelper.createMainProgram(mCtx3D,false);
			
			
			mCtx3D.setVertexBufferAt(1, mCoords, 2, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			mCtx3D.setCulling( Context3DTriangleFace.BACK );
			
			updateTopLayer();
			
			clear();
			
			if(mCacheBmd!=null){

				mUniformMatrix[0] = 0;
				mUniformMatrix[1] = 0;
				mUniformMatrix[2] = 0;
				mUniformMatrix[3] = 1024;
				mUniformColor[0] = 1;
				mUniformColor[1] = 1;
				mUniformColor[2] = 1;
				mUniformColor[3] = 1;
				
				mCtx3D.setProgram(mNoMipShader);
				
				var tmp:Texture=Stage3DHelper.uploadTexture(mCtx3D,mCacheBmd,Context3DTextureFormat.BGRA,false,true);
				mCtx3D.setRenderToTexture(mFBO);
				mCtx3D.clear(0,0,0,0);
				Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,tmp,mVerts,mCoords,mUniformMatrix,mUniformColor);
				
				tmp.dispose();			
				mCacheBmd=null;
				_painted=true;
			}
			
			mCtx3D.setProgram(mMipShader);

			onActive();
			dispatchEvent( new Event(Event.ACTIVATE));
			
		}
		
		public function onActive():void{
			if(mCtx3D==null||mCtx3D.driverInfo=="Disposed"||_mcWidth<1||_mcHeight<1)return;
			AppVals.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);	
		}
		
		public function onDeactive():void{
			AppVals.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private var _mcHeight:Number;
		private var _mcWidth:Number;
		
		public function onResize():void{
			_mcWidth=AppVals.stage.stageWidth/AppVals.GLOBAL_SCALE;
			_mcHeight=AppVals.stage.stageHeight/AppVals.GLOBAL_SCALE-AppVals.STATUSBAR_HEIGHT;
			_currentRect= UTItemManager.getZoomRectMotion(currentScale,_mcWidth,_mcHeight);	
			
			//mStageWidth=AppVals.stage.stageWidth;
			//mStageHeight=AppVals.stage.stageHeight;
			
			if(mCtx3D==null||mCtx3D.driverInfo=="Disposed"||_mcWidth<1||_mcHeight<1)return;
			
			mCtx3D.configureBackBuffer( AppVals.stage.stageWidth,AppVals.stage.stageHeight ,0, false);
			mScreenMatrix.identity();
			mScreenMatrix.appendTranslation(0,-AppVals.STATUSBAR_HEIGHT*.5,0);
			mScreenMatrix.appendScale(1.0/(_mcWidth*.5), 1.0/((_mcHeight+AppVals.STATUSBAR_HEIGHT)*.5), 1);
		}
		
		private function draw():void{
			var num:uint=mParticles.length;
			if(num>0){
				
				if(_eraseMode){
					mCtx3D.setBlendFactors(Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				}else{
					mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				}
				
				mCtx3D.setVertexBufferAt(0, mVerts, 0, Context3DVertexBufferFormat.FLOAT_2);
				mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
				
				var part:PVParticle;
				//var currentTex:int=-1;
				var ac:int=-1;
				for(var i:int=0;i<num;){
					part=mParticles[i];
					if(!(part.flg&&Math.random()>0.5)){
						//如果画点不超出画布范围
						if((part.posX-part.scale*0.55>0&&
							part.posY-part.scale*0.55>0&&
							part.posX+part.scale*0.55<UTItemManager.IMAGE_WIDTH&&
							part.posY+part.scale*0.55<UTItemManager.IMAGE_HEIGHT)||_eraseMode
						){
							
							if(ac!=part.texIndex){
								mCtx3D.setTextureAt(0, mTexParts[part.texIndex]);
								ac=part.texIndex
							}
							
							if(part.flg){
								mUniformMatrix[0] = part.posX+(Math.random()*1-0.5)*part.scale*.06;
								mUniformMatrix[1] = part.posY+(Math.random()*1-0.5)*part.scale*.06;
								mUniformMatrix[3] = part.scale*(Math.random()*0.4+0.8);
								mUniformColor[3]=Math.random();
								mUniformColor[0]     = part.r*mUniformColor[3] ;
								mUniformColor[1]     = part.g*mUniformColor[3] ;
								mUniformColor[2]     = part.b*mUniformColor[3] ;
								
							}else{
								mUniformMatrix[0] = part.posX;
								mUniformMatrix[1] = part.posY;
								mUniformMatrix[3] = part.scale;
								mUniformColor[0]     = part.r ;
								mUniformColor[1]     = part.g ;
								mUniformColor[2]     = part.b ;
								mUniformColor[3]     = 1;
							}
							
							
							mUniformMatrix[2] = part.angle;
							mUniformMatrix[3] = part.scale;
							mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mUniformColor);
							mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mUniformMatrix);
							mCtx3D.drawTriangles(mIndicies);
							
							if(!_painted){
								if(onPainted)onPainted();
								_painted=true;
							}
						}
					}
					if(part.life>0){
						mVF.getForceFromPos(part.posX, part.posY);
						part.setVFupdate(mVF.outX, mVF.outY);//把part的坐标延申outx，outy，幅度为outx，outy的摇动幅度*0.15
						i++;
					}else{
						mParticles.splice(i,1);
						num--;
					}
				}
				mUniformColor[3]     = 1;
			}
			mVF.fadeField(0.96);
			mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		}

		private function onEnterFrame(e:Event):void {
			if(_drawingEnabled){
				mCtx3D.setRenderToTexture(mFBO);
				draw();
			}

			mCtx3D.setRenderToBackBuffer();
			mCtx3D.clear(1,1,1,1);
			
			mUniformColor[0] = 1;
			mUniformColor[1] = 1;
			mUniformColor[2] = 1;
			mUniformMatrix[0] = 0;
			mUniformMatrix[2] = 0;
			
		
			//ベースTシャツ
			mUniformMatrix[0] = -_mcWidth*.5+_currentRect.width*0.5+_currentRect.x;
			mUniformMatrix[1] = -(- _mcHeight*.5+_currentRect.height*0.5+_currentRect.y);
			mUniformMatrix[3] = _currentRect.width;
			Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mScreenMatrix,mTexBaseT,mVerts,mCoords,mUniformMatrix,mUniformColor);

			//ベースTシャツ　FBO
			mUniformMatrix[0]= -_mcWidth*.5+_currentRect.width*0.5+_currentRect.x + _currentRect.width*UTItemManager.wkCenter.x-_currentRect.width*0.5;
			mUniformMatrix[1]=-(- _mcHeight*.5+_currentRect.height*0.5+_currentRect.y + _currentRect.height*UTItemManager.wkCenter.y-_currentRect.height*0.5);
			mUniformMatrix[3]=_currentRect.width*UTItemManager.wkWidth;
			
			Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mScreenMatrix,mFBO,mVertsStage,mCoords,mUniformMatrix,mUniformColor);
			
			//TOPレイヤー
			if(hasTopLayer){
				Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mScreenMatrix,texTopLayer,mVertsStage,mCoords,mUniformMatrix,mUniformColor);
			}
			
			if(_isZoom){
				if(_toScale!=1){
					_toScale=1;
					_frScale=currentScale;
					_ticktime=(new Date).time;
				}
			}else{
				if(_toScale!=0){
					_toScale=0;
					_frScale=currentScale;
					_ticktime=(new Date).time;
				}
			}
			
			if(currentScale!=_toScale&&_drawingEnabled){
				var _v:Number
				_v=((new Date).time-_ticktime)/(1000*0.3);
				if(_v>1.0){
					_v=1;
					currentScale=_toScale;
					_currentRect= UTItemManager.getZoomRectMotion(currentScale,_mcWidth,_mcHeight);	
				}else{
					_v=Easing.easeOutCubic(_v,0,1,1);
					currentScale=_frScale+(_toScale-_frScale)*_v;
					_currentRect= UTItemManager.getZoomRectMotion(currentScale,_mcWidth,_mcHeight);	
				}
			}
			
			if(e!=null)mCtx3D.present();
		}
		
		//private var _zoomTryed:Boolean=false;
		private var _toScale:Number;
		private var _frScale:Number;
		private var _ticktime:Number;
		
		public function captureCurrentBuffer():BitmapData{ 
			AppVals.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			var bmd:BitmapData=new BitmapData(AppVals.stage.stageWidth,AppVals.stage.stageHeight,false,0xFFFFFF);
			onEnterFrame(null);
			mCtx3D.drawToBitmapData(bmd);
			mCtx3D.present();
			return bmd;
		} 
		
		public function drawBufferToBitmap(bmd:BitmapData):void{ 
			onEnterFrame(null);
			mCtx3D.drawToBitmapData(bmd);
		} 
		
		public function captureToBitmap(bmd:BitmapData,cacheBmd:BitmapData):void{ 
			
			if(mTexBaseT)mTexBaseT.dispose();
			mTexBaseT=null;
			
			mUniformColor[0] = 1;
			mUniformColor[1] = 1;
			mUniformColor[2] = 1;
			mUniformColor[3] = 1;
	
			var mWid:int=Math.min(Math.min(AppVals.stage.stageWidth,AppVals.stage.stageHeight),Math.max(bmd.width/2,bmd.height/2));
			if(!UTDeviceCapabilities.isMobilePlatform())mWid=128;
			
			var m:Matrix3D=new Matrix3D;
			var m2:Matrix=new Matrix;
			var b:BitmapData=new BitmapData(mWid,mWid,true,0);
			var x:int,y:int;
			mCtx3D.configureBackBuffer(mWid,mWid ,16, false);	
			
			mCtx3D.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, mUniformColor );
			mCtx3D.setVertexBufferAt(1, mCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setVertexBufferAt(0, mVertsStage, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setProgram(mNoMipShader);
			mCtx3D.setRenderToBackBuffer();
			mCtx3D.setTextureAt( 0, mFBO);

			mUniformMatrix[0] = 0;
			mUniformMatrix[1] = 0;
			mUniformMatrix[2] = 0;
			mUniformMatrix[3] =bmd.width;
			m.identity()
			m.appendScale(1.0/(mWid*.5), 1.0/(mWid*.5), 1);
			mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m,false);
			mCtx3D.setTextureAt( 0, mFBO);
			
			for(x=0;x<Math.ceil(bmd.width/mWid);x++){
				for(y=0;y<Math.ceil(bmd.height/mWid);y++){
					mCtx3D.clear(0,0,0,0);
					mUniformMatrix[0] = -x*mWid + (bmd.width*.5-mWid*.5);
					mUniformMatrix[1] = y*mWid- (bmd.height*.5-mWid*.5) ;
					mCtx3D.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 4, mUniformMatrix );
					mCtx3D.drawTriangles(mIndicies);
					mCtx3D.drawToBitmapData(b);
					bmd.copyPixels(b,b.rect,new Point(mWid*x,mWid*y));
				}
			}
			
			var mHei:int=mWid*UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
			mUniformMatrix[0] = 0;
			mUniformMatrix[1] = 0;
			mUniformMatrix[2] = 0;
			mUniformMatrix[3] =bmd.width;
			
			m.identity()
			m.appendScale(1.0/(mWid*.5), 1.0/(mHei*.5), 1);							
			mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m,false);

			for(x=0;x<Math.ceil(UTItemManager.IMAGE_WIDTH/mWid);x++){
				for(y=0;y<Math.ceil(UTItemManager.IMAGE_HEIGHT/mWid);y++){
					mCtx3D.clear(0,0,0,0);
					mUniformMatrix[0] = -x*mWid + (UTItemManager.IMAGE_WIDTH*.5-mWid*.5);
					mUniformMatrix[1] = y*mHei- (UTItemManager.IMAGE_HEIGHT*.5-mHei*.5) ;
					mCtx3D.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 4, mUniformMatrix );
					mCtx3D.drawTriangles(mIndicies);
					mCtx3D.drawToBitmapData(b);
					cacheBmd.copyPixels(b,b.rect,new Point(mWid*x,mWid*y));
				}
			}
			b.dispose();
		} 
		
		
		public var colArray:Vector.<uint>=new Vector.<uint>;
		public function setColor(color:Array):void{
			colArray.length=0;
			for(var i:int=0;i<color.length;i++)colArray.push(color[i]);
			setColorIndex(selectedColor);
		}
		
		public function setColorIndex(color:int):void{  //选择画笔颜色
			selectedColor=color<colArray.length?color:0;
			mActiveColor=colArray[selectedColor];
			CBcolorChanged();
		}
		
		private  var _cnverted_X:Number;
		private  var _cnverted_Y:Number;
		private function convertMousePos(x:Number,y:Number):void{  //大图变成小图，进行手指作坐标变换
			//ベースTシャツ　FBO  //基本T恤 FBO
			x/=AppVals.GLOBAL_SCALE;
			y/=AppVals.GLOBAL_SCALE;
			var _x:Number= -_mcWidth*.5+_currentRect.width*0.5+_currentRect.x + _currentRect.width*UTItemManager.wkCenter.x-_currentRect.width*0.5;
			var _y:Number=-(- _mcHeight*.5+_currentRect.height*0.5+_currentRect.y + _currentRect.height*UTItemManager.wkCenter.y-_currentRect.height*0.5);
			var _s:Number=_currentRect.width*UTItemManager.wkWidth;
			_cnverted_X=  (x-_mcWidth*.5 - _x)/_s*UTItemManager.IMAGE_WIDTH + UTItemManager.IMAGE_WIDTH*.5 ;
			_cnverted_Y= -(y-_mcHeight*.5 + _y - AppVals.STATUSBAR_HEIGHT)/_s*UTItemManager.IMAGE_WIDTH + UTItemManager.IMAGE_HEIGHT*.5 ;
		}
		
		public function onMousePress(x:Number,y:Number):void{
			if(!_drawingEnabled)return;
			
			convertMousePos(x,y);
			mPrevMouseX=_cnverted_X;
			mPrevMouseY=_cnverted_Y;
			mPrevDiffX=0;
			mPrevDiffY=0;
		}
		
		public function onMouseRelease(x:Number,y:Number):void{  //每画完一笔，抬起手指，换一种颜色
			if(!colorSelectMode&&!_eraseMode){
				selectedColor++;
				if(selectedColor>colArray.length-1)selectedColor=0;
				setColorIndex(selectedColor)
			}
		}
		
		public function onMouseDrag(x:Number,y:Number):void{
			if(!_drawingEnabled)return;
			//选择画笔粗细
			if(AppVals.SELECTED_TOOL_MODE == AppVals.THICK_BRUSH_MODE)
				mFudeSize = 1.2;
			else if(AppVals.SELECTED_TOOL_MODE == AppVals.THIN_BRUSH_MODE)
				mFudeSize = 1.2/16;
			else if(AppVals.SELECTED_TOOL_MODE == AppVals.ERASE_MODE)
				mFudeSize = 1.2;
			
			var pos_x:Number;
			var pos_y:Number;
			var diff_x:Number;
			var diff_y:Number;
			//定位当前坐标
			convertMousePos(x,y);
			pos_x=_cnverted_X;
			pos_y=_cnverted_Y;

			计算和前一个位置的偏移量			
			diff_x=pos_x-mPrevMouseX;
			diff_y=pos_y-mPrevMouseY;
			//计算运动距离
			var v:int=Math.max(Math.sqrt(diff_x*diff_x+diff_y*diff_y)/30.0,1.0);
			var p_x:Number,p_y:Number;
			var d_x:Number,d_y:Number;
			var pR_x:Number,pR_y:Number;
			var f:Number,c:Number;
			
			for(var i:int=0;i<v;i++){	
				f=(i+1)/Number(v);
				p_x=pos_x-mPrevMouseX;
				p_y=pos_y-mPrevMouseY;
				p_x*=f;
				p_y*=f;
				p_x=mPrevMouseX+p_x;
				p_y=mPrevMouseY+p_y;
				d_x=diff_x-mPrevDiffX;
				d_y=diff_y-mPrevDiffY;
				d_x*=f;
				d_y*=f;
				d_x=mPrevDiffX+d_x;
				d_y=mPrevDiffY+d_y;
				var strength:Number=0.2+Math.min(mFudeSize,Math.sqrt(d_x*d_x+d_y*d_y)/50.0);
				//把这段位移部分使用不同大小的圆进行颜色填充
				mVF.addVectorCircle(p_x , p_y, d_x*0.5, d_y*0.5, 80, 0.3);
				//产生多个颗粒，进行飞溅和流动
				var pw:Number;
				for(var a:int=0;a<10;a++){
					var r:int=_eraseMode?1000:Math.random()*1000;
					
					var part:PVParticle =new PVParticle;
					
					part.angle=Math.random()*720;
					part.flg=false;
					
					var  color:uint;
					if(Math.random()<0.1){//里面混的杂色，这个新程序不需要，但需要变浅，修改一下即可
						var coladd:int=(Math.random()*mColorRandRange-mColorRandRange*.5)*255;
						var _colorR:int =( (mActiveColor >> 16) & 0xFF) + coladd;
						var _colorG:int =( (mActiveColor >>  8) & 0xFF) + coladd;
						var _colorB:int =( (mActiveColor >>  0) & 0xFF) + coladd;
						
						_colorR=_colorR<0?0:(_colorR>255?255:_colorR);
						_colorG=_colorG<0?0:(_colorG>255?255:_colorG);
						_colorB=_colorB<0?0:(_colorB>255?255:_colorB);
						
						color=(_colorR << 16) | (_colorG << 8) | (_colorB);
					}else{
						color=mActiveColor;
					}
					
					part.r = ((color >> 16) & 0xFF)/255.0;
					part.g = ((color >> 8) & 0xFF)/255.0;
					part.b = ((color >> 0) & 0xFF)/255.0;
					
					pR_x=Math.random()*100-50;
					pR_y=Math.random()*100-50;
					//pR.normalize(1);
					//计算喷溅颗粒的喷溅方向和距离
					f=Math.sqrt(pR_x*pR_x+pR_y*pR_y);
					pR_x/=f;
					pR_y/=f;
					c=Math.random()*50-25;
					pR_x*=c;
					pR_y*=c;
					//针对不同规模的颗粒，进行如下计算和处理，用于喷溅
					if(r<10){
						if(Math.random()<0.1){
							part.scale=Math.random()*6.0;
						}else{
							part.scale=Math.random()*3.0;
						}
						part.setInitialCondition( p_x+Math.random()*100-50 , p_y+Math.random()*100-50, 0,0,0);
						part.texIndex=Math.random()*6;
					}else if(r<30){
						if(Math.random()<0.1){
							part.scale=Math.random()*4.0;
							part.texIndex=1;
						}else{
							part.scale=Math.random()*0.5+1.0;
							part.texIndex=Math.random()*6;
						}
						pw=Math.random()*0.7+0.3;
						part.setInitialCondition( p_x+d_x*pw*15 , p_y+d_y*pw*15, 0,0,0);
					}else if(r<50){
						pw=Math.random()*0.7+0.3;
						part.scale=Math.random()*0.5+1.0;
						part.setInitialCondition( p_x+pR_x , p_y+pR_y, d_x*pw, d_y*pw,30*Math.pow(strength,0.7));
						part.texIndex=0;
						part.flg=true;
					}else{
						part.setInitialCondition(  p_x+pR_x , p_y+pR_y,  d_x*0.1, d_y*0.1,30);
						part.texIndex=Math.random()<0.2?1:0;
						part.scale=Math.random()*0.3+1.2;
					}
					
					part.scale*=1.2;
					
					//texScaleは解像度fetch
					part.scale*=strength * 50;//?
					mParticles.push(part);
					
					if(mParticles.length>500){
						var cc:int=Math.random()*250;
						mParticles.splice(cc,1);
					}
				}
			}
			mPrevDiffX=diff_x;
			mPrevDiffY=diff_y;
			mPrevMouseX=pos_x;
			mPrevMouseY=pos_y;
		}
		
		public function clear():void{
			_painted=false;
			mParticles.length=0;
			mCtx3D.setRenderToTexture(mFBO);
			mCtx3D.clear(0,0,0,0);

			//Tシャツイメージを作成  //创建基本T恤图案
			if(mTexBaseT==null)canvasChange();
		}
		
		public function canvasChange():void{  //显示T恤大图
			var bmd:BitmapData=new BitmapData(1024,1024,false,0xFFFFFF);
			UTImageBuilder.createPrintedImage(bmd,_bmdBackImage,UTItemManager.wkMultiply,false,false,false);
			mTexBaseT = Stage3DHelper.uploadTexture(mCtx3D,bmd,Context3DTextureFormat.BGRA,true,true);
			_currentRect= UTItemManager.getZoomRectMotion(currentScale,_mcWidth,_mcHeight);	
		}
		
	}
}




