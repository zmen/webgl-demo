package utme.views.main.stage3d{
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
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
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.sensors.Accelerometer;
	
	import jp.uniqlo.utlab.assets.sound.shake04;
	import jp.uniqlo.utlab.assets.sound.shake05;
	import jp.uniqlo.utlab.assets.sound.shake06;
	import jp.uniqlo.utlab.assets.sound.shake07;
	
	import utme.app.NSFuncs.UTDeviceCapabilities;
	import utme.app.consts.AppSound;
	import utme.app.consts.AppVals;
	import utme.views.common.classes.UTImageBuilder;
	import utme.app.managers.UTStampManager;
	import utme.app.managers.UTTopLayerManager;
	import utme.app.managers.UTItemManager;
	import utme.views.common.classes.dragger.DraggablePlateRect;
	import utme.views.common.classes.viewHelpers.Easing;
	import utme.views.main.stage3d.helpers.Stage3DHelper;
	
	public class V3D19_RemixBaseImpl extends EventDispatcher{
		public var stage3d:Stage3D;
		
		//depend on context 3d
		
		protected var mCtx3D:Context3D;
		protected var weakMode:Boolean=false;
		protected var mFBO:Texture;
		protected var mTexBaseT:Texture;
		
		protected var mNeedCache:Boolean;
		
		private var mFBOBlendBuffer:Texture;
		private var mBlendDistTexture:Texture;
		private var mDisplayFbo:Texture;
		private var mFBOFrontBuffer:Texture;
		private var mFrontTexture:Texture;
		
		
		protected var mMipShader:Program3D;
		protected var mNoMipShader:Program3D;
		
		protected var mVerts:VertexBuffer3D;
		protected var mCoords:VertexBuffer3D;
		protected var mIndicies:IndexBuffer3D;
		private var mVertsStage:VertexBuffer3D;

		
		//private 
		
		protected var mFBOMatrix:Matrix3D;
		private var mScreenMatrix:Matrix3D;
		protected var mDisplayFboMatrix:Matrix3D;
		
		protected var mUniformMatrix:Vector.<Number>;
		protected var mUniformColor:Vector.<Number>;
		private var sounds:Vector.<Sound>;
		protected  var _bmdBackImage:BitmapData;
		private var _bmdFrontImage:BitmapData;
		private var mAccl:Accelerometer;
		private var mDPlate:DraggablePlateRect;
		
		private var soundNum:uint;


		public var _isZoom:Boolean;
		public var blendMode:String;
		private var _sensorAlltime:Boolean;
		private var _useFrontBuffer:Boolean
		public var mCacheBmd:BitmapData;
		private var _drawingEnabled:Boolean;

		private var mPrevMouseX:Number; 
		private var mPrevMouseY:Number; 
		private var mAcc_x:Number=0;
		private var mAcc_y:Number=0;
		private var mAccVel_x:Number=0;
		private var mAccVel_y:Number=0;	
		private var mAccPos_x:Number=0;
		private var mAccPos_y:Number=0;
		public var currentScale:Number=0;
		private var _currentRect:Rectangle;

		private var _zoomTryed:Boolean=false;
		private var _toScale:Number;
		private var _frScale:Number;
		private var _ticktime:Number;
		private var _accelerationX:Number;
		private var _accelerationY:Number;	
		private var _lastRad:Number=0;
		private var _weakforce:Boolean;
		protected var soundEnable:Boolean;
		private var countUpForce:Number=0;
		
		///constant
		
		private const FACTOR:Number = 0.25;
		private const ACC_INTERVAL_TIME:Number=33.3;
		
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function V3D19_RemixBaseImpl(sensorAlltime:Boolean,_weakMode:Boolean){
			mNeedCache=false;
			weakMode=_weakMode;
			_isZoom=false;
			currentScale=_isZoom?1:0;
			blendMode=null;
			soundEnable=true;
			_sensorAlltime=sensorAlltime;
		}
		
		
		public function initWithData(backBmd:BitmapData,srcBmd:BitmapData):void{	
			
		}
		
		public function dispose():void{
			
			stopRendering();
			stage3d.removeEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);
			AppVals.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (mAccl) {
				mAccl.removeEventListener(AccelerometerEvent.UPDATE, updateHandler); 
				mAccl=null;
			}
			
			mNoMipShader.dispose();
			mNoMipShader=null;
			
			mUniformMatrix.length=0;
			mUniformMatrix=null;
			mUniformColor.length=0;
			mUniformColor=null;
			
			mScreenMatrix=null;
			mFBOMatrix=null;
			mDisplayFboMatrix=null;
			
			sounds.length=0;
			sounds=null;
			

			
			
			if(mTexBaseT)mTexBaseT.dispose();
			if(mFBOBlendBuffer)mFBOBlendBuffer.dispose();
			if(mBlendDistTexture)mBlendDistTexture.dispose();
			if(mDisplayFbo)mDisplayFbo.dispose();
			if(mFBOFrontBuffer)mFBOFrontBuffer.dispose();
			if(mFrontTexture)mFrontTexture.dispose();
			if(texTopLayer)texTopLayer.dispose();
			mTexBaseT=null;
			mFBOBlendBuffer=null;
			mBlendDistTexture=null;
			mDisplayFbo=null;
			mFBOFrontBuffer=null;
			mFrontTexture=null;	
			
			mMipShader.dispose();
			mMipShader=null;
			

			_bmdFrontImage=null;
			_bmdBackImage=null;
			
			mVerts.dispose();
			mVerts=null;
			mCoords.dispose();
			mCoords=null;
			mVertsStage.dispose();
			mVertsStage=null;
			mIndicies.dispose();
			mIndicies=null;
			
			
			mFBO.dispose();
			mFBO=null;
			
			mDPlate=null;
			
			
			mCtx3D.dispose();
			mCtx3D=null;
			stage3d=null;	
		}
		
		public function stopRendering():void{
			_drawingEnabled=false;
			if (Accelerometer.isSupported) {
				mAccl.removeEventListener(AccelerometerEvent.UPDATE, updateHandler); 
			}
		}
		
		public function startRendering():void{
			_drawingEnabled=true;
			_toScale=0;
			if (Accelerometer.isSupported) { 
				mAccl.addEventListener(AccelerometerEvent.UPDATE, updateHandler); 
			}
			mAcc_x=0;
			mAcc_y=0;
		}
		
		public function toggleScale():void{
			_isZoom=!_isZoom;
		}
		
		protected function setup():void{}
		
		
		protected function init3D(back:BitmapData,front:BitmapData):void{
			
			sounds=new Vector.<Sound>;
			sounds.push(new shake04);
			sounds.push(new shake05);
			sounds.push(new shake06);
			sounds.push(new shake07);
			soundNum=sounds.length;
			
			_drawingEnabled=false;
			_bmdBackImage=back;
			_bmdFrontImage=front;
			_useFrontBuffer=_bmdFrontImage!=null;
			
			mScreenMatrix = new Matrix3D();
			
			stage3d=AppVals.stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);
			stage3d.requestContext3D(Context3DRenderMode.AUTO,AppVals.STAGE3D_PROFILE);

			
			mDPlate= new DraggablePlateRect;
			mDPlate.setup(0,0,0,1024,1024);
			
			if (Accelerometer.isSupported) { 
				mAccl = new Accelerometer();
				mAccl.setRequestedUpdateInterval(ACC_INTERVAL_TIME);
			}
		}
		protected var hasTopLayer:Boolean;
		protected var texTopLayer:Texture;
		
		private function updateTopLayer():void{
			hasTopLayer=UTTopLayerManager.hasTopLayer();
			if(hasTopLayer){
				texTopLayer=Stage3DHelper.uploadTexture(mCtx3D,UTTopLayerManager.getTopLayerThumbImage(),Context3DTextureFormat.BGRA,true,true);
			}
		}
		
		
		protected function context3DCreateHandler(e:Event):void {
			trace("context created");
			//Begin Stage 3Ds////////////////////////////////////////////////////////////////
			//stage3d.removeEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);
			onDeactive();
			
			mTexBaseT=null;
			mBlendDistTexture=null;			
			mCtx3D = Stage3D(e.target).context3D;
			if(AppVals.DEBUG_MODE)mCtx3D.enableErrorChecking=true;

			onResize();
			
			//mCtx3D.enableErrorChecking = true;
			var vertices:Vector.<Number> = new <Number>[-0.5, -0.5, 0.5, -0.5, -0.5, 0.5, 0.5, 0.5];
			var coords:Vector.<Number>   = new <Number>[0, 1, 1, 1, 0, 0, 1, 0];
			var aspct:Number=UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
			var verticesStg:Vector.<Number> = new <Number>[-0.5, -aspct*0.5, 0.5, -aspct*0.5, -0.5, aspct*0.5, 0.5, aspct*0.5];
			
			mVerts = mCtx3D.createVertexBuffer(4,2);
			mVerts.uploadFromVector(vertices, 0, 4);	
			mCoords = mCtx3D.createVertexBuffer(4,2);
			mCoords.uploadFromVector(coords, 0, 4);	
			mVertsStage = mCtx3D.createVertexBuffer(4, 2);
			mVertsStage.uploadFromVector(verticesStg, 0, 4);	
			
			var indices:Vector.<uint> = new <uint>[0,2,1,2,3,1];
			mIndicies = mCtx3D.createIndexBuffer(6);
			mIndicies.uploadFromVector(indices, 0, 6);
			
			mUniformMatrix=new <Number>[0.0,0.0,0.0,1.0];
			mUniformColor=new <Number>[1.0,1.0,1.0,1.0];
			
			///////////////////////////////////////////////////////////////////////////////////////////

			
			mFBOMatrix = new Matrix3D();
			mFBOMatrix.appendTranslation(-UTItemManager.IMAGE_WIDTH*.5,-UTItemManager.IMAGE_HEIGHT*.5,0);
			mFBOMatrix.appendScale(1/(UTItemManager.IMAGE_WIDTH*.5), 1/(UTItemManager.IMAGE_HEIGHT*.5), 1);
			
			mFBO= mCtx3D.createTexture(AppVals.TEXTURE_WIDTH , AppVals.TEXTURE_WIDTH,Context3DTextureFormat.BGRA,true);
			
			mFBOBlendBuffer= mCtx3D.createTexture(1024 , 1024,Context3DTextureFormat.BGRA,true);
			
			if(_useFrontBuffer){
				mFBOFrontBuffer= mCtx3D.createTexture(1024 , 1024,Context3DTextureFormat.BGRA,true);
				var bmd:BitmapData=new BitmapData(1024,1024,true,0x0);
				var m:Matrix=new Matrix;
				m.scale(bmd.width/_bmdFrontImage.width,bmd.height/_bmdFrontImage.height);
				bmd.draw(_bmdFrontImage,m,null,null,null,true);
				mFrontTexture=Stage3DHelper.uploadTexture(mCtx3D,bmd,Context3DTextureFormat.BGRA,true,true);
			}
			
			mDisplayFboMatrix = new Matrix3D();
			mDisplayFboMatrix.appendScale(1/(1024*.5), 1/(1024*.5), 1);
			mMipShader=Stage3DHelper.createMainProgram(mCtx3D,true);
			mNoMipShader=Stage3DHelper.createMainProgram(mCtx3D,false);
			
			//texture cooords
			mCtx3D.setVertexBufferAt(1, mCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			mCtx3D.setCulling( Context3DTriangleFace.BACK );
			
			
			updateTopLayer();
			
			_clear();
			
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
			}
			
			mCtx3D.setProgram(mMipShader);
			
			setup();
			onActive();
			dispatchEvent(new Event(Event.ACTIVATE));
		}
		
		public function onActive():void{
			if (Accelerometer.isSupported&&mAccl&&_drawingEnabled) {
				mAccl.addEventListener(AccelerometerEvent.UPDATE, updateHandler); 
			}
			if(mCtx3D==null||mCtx3D.driverInfo=="Disposed"||_mcWidth<1||_mcHeight<1)return;
			AppVals.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);	
		}
		
		public function onDeactive():void{
			if (Accelerometer.isSupported&&mAccl) {
				mAccl.removeEventListener(AccelerometerEvent.UPDATE, updateHandler); 
			}
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
		
		protected function draw():void{}
		
		
		private function setBlendMode(bMode:String):void{
			
			mUniformColor[0] = 1;
			mUniformColor[1] = 1;
			mUniformColor[2] = 1;
			mUniformColor[3] = 1;
			switch( bMode ) {
				case BlendMode.ALPHA://OK
					mUniformColor[0] = 0.6;
					mUniformColor[1] = 0.6;
					mUniformColor[2] = 0.6;
					mUniformColor[3] = 0.6;
					mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
					break;
				case BlendMode.ADD://OK
					mCtx3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
					break;
				case BlendMode.MULTIPLY://OK
					if(UTItemManager.wkMultiply){
						mCtx3D.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
					}else{
						mCtx3D.setBlendFactors(Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.SOURCE_COLOR);
					}
					break;
				case "MULTI_ADD":
					mCtx3D.setBlendFactors(Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.ONE);
					break;
				case BlendMode.SCREEN://OK
					mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
					break;
				case BlendMode.ERASE:
					mCtx3D.setBlendFactors(Context3DBlendFactor.ZERO, Context3DBlendFactor.SOURCE_ALPHA);
					break;
				default://OK
					mCtx3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
					break;
			}
		}
		
		private function onEnterFrame(e:Event):void {
			var h:Number;
			var w:Number;
			
			mCtx3D.setRenderToTexture(mFBO);
			draw();
			
			/////////////////////////////////////////////CLEATE BLEND BUFFER
			
			mUniformColor[0] = 1;
			mUniformColor[1] = 1;
			mUniformColor[2] = 1;
			mUniformColor[3] = 1;
			mUniformMatrix[0] = 0;
			mUniformMatrix[1] = 0;
			mUniformMatrix[2] = 0;
			mUniformMatrix[3] = 1024;
			if(_useFrontBuffer){
				mCtx3D.setRenderToTexture(mFBOFrontBuffer);
				mCtx3D.clear(0,0,0,0);
				Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,mFrontTexture,mVerts,mCoords,mUniformMatrix,mUniformColor);
				Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,mFBO,mVerts,mCoords,mUniformMatrix,mUniformColor);
			}
			
			mCtx3D.setRenderToTexture(mFBOBlendBuffer);
			if(blendMode==BlendMode.MULTIPLY){
				if(UTItemManager.wkMultiply){
				mCtx3D.clear(1,1,1,1);
				}else{
					mCtx3D.clear(1,1,1,0);
				}
			}else{
				mCtx3D.clear(0,0,0,0);
			}
			
			Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,mBlendDistTexture,mVerts,mCoords,mUniformMatrix,mUniformColor);

			setBlendMode(blendMode);
			Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,_useFrontBuffer?mFBOFrontBuffer:mFBO,mVerts,mCoords,mUniformMatrix,mUniformColor);

			if(blendMode==BlendMode.MULTIPLY&&!UTItemManager.wkMultiply){
				setBlendMode("MULTI_ADD");
				Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,mBlendDistTexture,mVerts,mCoords,mUniformMatrix,mUniformColor);
			}
			
			setBlendMode(null);
			if(hasTopLayer){
				Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,texTopLayer,mVerts,mCoords,mUniformMatrix,mUniformColor);
			}

			///////////////////////////////////////////////////////
			
			mUniformMatrix[0] = 0;
			mUniformMatrix[1] = 0;
			mUniformMatrix[2] = 0;
			mUniformMatrix[3] = 1;
			

				
				
			mCtx3D.setRenderToBackBuffer();
			mCtx3D.clear(1,1,1,1);
			mDPlate.update();
			mUniformColor[0] = 1;
			mUniformColor[1] = 1;
			mUniformColor[2] = 1;
			mUniformMatrix[2] = mDPlate.rad;
			
			var _s:Number=_currentRect.width*UTItemManager.wkWidth;
			
			mUniformMatrix[0] = -_mcWidth*.5+_currentRect.width*0.5+_currentRect.x+  mAccPos_x + mDPlate.pos_x*_s/1024;
			mUniformMatrix[1] = -(- _mcHeight*.5+_currentRect.height*0.5+_currentRect.y)+ mAccPos_y + mDPlate.pos_y*_s/1024;
			mUniformMatrix[3] = _currentRect.width;
			
			
			Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mScreenMatrix,mTexBaseT,mVerts,mCoords,mUniformMatrix,mUniformColor);
			
			var _x:Number= _currentRect.width*0.5 - _currentRect.width*UTItemManager.wkCenter.x;
			var _y:Number= _currentRect.height*UTItemManager.wkCenter.y-_currentRect.height*0.5;
			var cx:Number = _x*Math.cos(mDPlate.rad)-_y*Math.sin(mDPlate.rad);
			var cy:Number = _x*Math.sin(mDPlate.rad)+_y*Math.cos(mDPlate.rad);
			mUniformMatrix[0]= -_mcWidth*.5+_currentRect.width*0.5+_currentRect.x + mAccPos_x + mDPlate.pos_x*_s/1024  - cx;
			mUniformMatrix[1]=-(- _mcHeight*.5+_currentRect.height*0.5+_currentRect.y)+ mAccPos_y + mDPlate.pos_y*_s/1024 - cy;
			mUniformMatrix[3]=_currentRect.width*UTItemManager.wkWidth;
			
			if(UTItemManager.wkMultiply)setBlendMode(BlendMode.MULTIPLY);
			Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mScreenMatrix,mFBOBlendBuffer,mVertsStage,mCoords,mUniformMatrix,mUniformColor);
			setBlendMode(null);
			
			
			
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
			acc();
		}
		
		

		private function updateHandler(evt:AccelerometerEvent):void { 
			var _x:Number=evt.accelerationX;
			var _y:Number=evt.accelerationY;
			if(mAcc_x==0&&mAcc_y==0){
				mAcc_x=_x;
				mAcc_y=_y;	
				_accelerationX=0;
				_accelerationY=0;
				countUpForce=0;
			}else{			
				_accelerationX=(mAcc_x-_x); 
				_accelerationY=(mAcc_y-_y); 
				mAcc_x = (_x * FACTOR) + (mAcc_x * (1 - FACTOR))
				mAcc_y = (_y * FACTOR) + (mAcc_y * (1 - FACTOR))
			}
		}
		
		private function acc():void{
			
			var _x:Number=_accelerationX;
			var _y:Number=_accelerationY;
			var l:Number= Math.sqrt(_x*_x+_y*_y);
			if(l>0.45){
				var f:Number=40+10*l*(1+countUpForce);
				if(f>250)f=250;
				_x=_x/l*f;
				_y=_y/l*f;
				mAccVel_x+=_x/5;
				mAccVel_y+=_y/5;	
				if(_sensorAlltime||Math.random()<(1.0-Math.pow((f)/250.0,1.3))*.5)addPerticles(_x,_y);
				soundForce(_x,_y);
				countUpForce+=0.09;
			}else{
				countUpForce*=0.9;
			}
			
			mAccVel_x=0.75*(mAccVel_x-(mAccPos_x)*0.1);
			mAccVel_y=0.75*(mAccVel_y-(mAccPos_y)*0.1);
			mAccPos_x+=mAccVel_x;
			mAccPos_y+=mAccVel_y;
			
		}
		
		
		private  var _cnverted_X:Number;
		private  var _cnverted_Y:Number;
		private function convertMousePos(x:Number,y:Number):void{
			//ベースTシャツ　FBO
			x/=AppVals.GLOBAL_SCALE;
			y/=AppVals.GLOBAL_SCALE;
			
			
			var _x:Number= -_mcWidth*.5+_currentRect.width*0.5+_currentRect.x ;
			var _y:Number= -_mcHeight*.5+_currentRect.height*0.5+_currentRect.y ;
			var _s:Number=_currentRect.width*UTItemManager.wkWidth;			
			_cnverted_X=  ( x-_mcWidth*.5   -_x )/_s*1024 ;
			_cnverted_Y= -( y-_mcHeight*.5  - _y-AppVals.STATUSBAR_HEIGHT)/_s*1024  ;
			
			var mx:Number= UTItemManager.wkWidth+(1-UTItemManager.wkWidth)*currentScale *0.1 ;
			
			_cnverted_X*=mx ;
			_cnverted_Y*=mx;
		}
		
		
		
		public function onMousePress(x:Number,y:Number):void{
			if(!_drawingEnabled)return;
			mDPlate.drag(mAccPos_x,mAccPos_y,false,false);
			var pos_x:Number;
			var pos_y:Number;
			
			convertMousePos(x,y);
			pos_x=_cnverted_X;
			pos_y=_cnverted_Y;
			//pos_x=(x - mStageWidth*.5)/(mStageWidth*currentScale*AppCanvas.IMAGE_ASPECTRATE*AppCanvas.BASET_HEIGHT_SCALE/1024.0);
			//pos_y=-(y - mStageHeight*.5)/(mStageWidth*currentScale*AppCanvas.IMAGE_ASPECTRATE*AppCanvas.BASET_HEIGHT_SCALE/1024.0);
			
			
			if(AppVals.REMIX_MOVE_RIMIT){	
				mDPlate.drag(pos_x*AppVals.REMIX_MOVE_RIMIT_RATE,pos_y*AppVals.REMIX_MOVE_RIMIT_RATE,true,false);
			}else{
				mDPlate.drag(pos_x,pos_y,true,false);
			}
			
			mPrevMouseX=pos_x;
			mPrevMouseY=pos_y;
		}
		
		public function onMouseDrag(x:Number,y:Number):void{
			if(!_drawingEnabled)return;
			var pos_x:Number;
			var pos_y:Number;
			convertMousePos(x,y);
			pos_x=_cnverted_X;
			pos_y=_cnverted_Y;
			//pos_x=(x - mStageWidth*.5)/(mStageWidth*currentScale*AppCanvas.IMAGE_ASPECTRATE*AppCanvas.BASET_HEIGHT_SCALE/1024.0);
			//pos_y=-(y - mStageHeight*.5)/(mStageWidth*currentScale*AppCanvas.IMAGE_ASPECTRATE*AppCanvas.BASET_HEIGHT_SCALE/1024.0);
			
			if(AppVals.REMIX_MOVE_RIMIT){	
				mDPlate.drag(pos_x*AppVals.REMIX_MOVE_RIMIT_RATE,pos_y*AppVals.REMIX_MOVE_RIMIT_RATE,true,false);
			}else{
				mDPlate.drag(pos_x,pos_y,true,false);
			}
			
			addPerticles((pos_x-mPrevMouseX)*1.2,(pos_y-mPrevMouseY)*1.2);
			soundForce(pos_x-mPrevMouseX,pos_y-mPrevMouseY);
			mPrevMouseX=pos_x;
			mPrevMouseY=pos_y;
		}
		
		public function onMouseUp(x:Number,y:Number):void{
			if(!_drawingEnabled)return;
			var pos_x:Number;
			var pos_y:Number;
			
			convertMousePos(x,y);
			pos_x=_cnverted_X;
			pos_y=_cnverted_Y;
			//pos_x=(x - mStageWidth*.5)/(mStageWidth*currentScale*AppCanvas.IMAGE_ASPECTRATE*AppCanvas.BASET_HEIGHT_SCALE/1024.0);
			//pos_y=-(y - mStageHeight*.5)/(mStageWidth*currentScale*AppCanvas.IMAGE_ASPECTRATE*AppCanvas.BASET_HEIGHT_SCALE/1024.0);
			
			if(AppVals.REMIX_MOVE_RIMIT){	
				mDPlate.drag(pos_x*AppVals.REMIX_MOVE_RIMIT_RATE,pos_y*AppVals.REMIX_MOVE_RIMIT_RATE,false,false);
			}else{
				mDPlate.drag(pos_x,pos_y,false,false);
			}
			
			mPrevMouseX=pos_x;
			mPrevMouseY=pos_y;
		}
		
		protected function addedForce(x:Number,y:Number):void{}
		
		public function addPerticles(x:Number,y:Number):void{
			if(!_drawingEnabled)return;
			addedForce(x,y);
		}
		
		public function soundForce(x:Number,y:Number):void{
			if(!_drawingEnabled)return;
			if(soundEnable){
				var _rad:Number=Math.atan2(y,x);
				var _ld:Number=Math.abs(_lastRad-_rad);
				if(Math.PI<_ld)_ld=Math.PI*2-_ld;
				if(_ld>Math.PI*0.5||_weakforce){
					if(Math.sqrt(x*x+y*y)>25){
						_lastRad=_rad;
						if(AppSound.checkSoundEnable())sounds[int(Math.floor(Math.random()*soundNum))].play();
					}
				}	
				if(Math.sqrt(x*x+y*y)==0)_weakforce=true;
			}
		}
		
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
		
		public function captureToBitmap(bmd:BitmapData):void{ 	
			
			
			if(mTexBaseT)mTexBaseT.dispose();
			if(mFBOBlendBuffer)mFBOBlendBuffer.dispose();
			if(mBlendDistTexture)mBlendDistTexture.dispose();
			if(mDisplayFbo)mDisplayFbo.dispose();
			if(mFBOFrontBuffer)mFBOFrontBuffer.dispose();
			if(mFrontTexture)mFrontTexture.dispose();
			mTexBaseT=null;
			mFBOBlendBuffer=null;
			mBlendDistTexture=null;
			mDisplayFbo=null;
			mFBOFrontBuffer=null;
			mFrontTexture=null;	
			
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
			
			if(_useFrontBuffer||mNeedCache){
				mCtx3D.setRenderToBackBuffer();
				mCacheBmd=new BitmapData(AppVals.TEXTURE_WIDTH,AppVals.TEXTURE_WIDTH,true,0);
				var mHei:int=mWid*UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
				mUniformMatrix[2] = 0;
				mUniformMatrix[0] = 0;
				mUniformMatrix[1] = 0;
				mUniformMatrix[3] =bmd.width;
				m.identity()
				m.appendScale(1.0/(mWid*.5), 1.0/(mHei*.5), 1);				
				
				mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m,false);
				mCtx3D.setTextureAt( 0, mFBO);
				
				for(x=0;x<Math.ceil(bmd.width/mWid);x++){
					for(y=0;y<Math.ceil(bmd.height/mWid);y++){
						mCtx3D.clear(0,0,0,0);
						mUniformMatrix[0] = -x*mWid + (bmd.width*.5-mWid*.5);
						mUniformMatrix[1] = y*mHei- (bmd.height*.5-mHei*.5) ;
						mCtx3D.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 4, mUniformMatrix );
						mCtx3D.drawTriangles(mIndicies);
						mCtx3D.drawToBitmapData(b);
						mCacheBmd.copyPixels(b,b.rect,new Point(mWid*x,mWid*y));
					}
				}
			}
			
			
			
			
			if(blendMode==BlendMode.ERASE){
				//mask blend
				
				var	mFBOBack:Texture=mCtx3D.createTexture(AppVals.TEXTURE_WIDTH , AppVals.TEXTURE_WIDTH,Context3DTextureFormat.BGRA,true);
				mUniformMatrix[0] = 0;
				mUniformMatrix[1] = 0;
				mUniformMatrix[2] = 0;
				mUniformMatrix[3] = 1024;
				
				var tmp:Texture;
				
				if(_useFrontBuffer){
					mCtx3D.setRenderToTexture(mFBOBack);
					mCtx3D.clear(0,0,0,0);
					m2.identity()
					m2.scale(AppVals.TEXTURE_WIDTH/_bmdFrontImage.width,AppVals.TEXTURE_WIDTH/_bmdFrontImage.height);
					bmd.draw(_bmdFrontImage,m2,null,null,null,true);
					tmp=mCtx3D.createTexture(AppVals.TEXTURE_WIDTH,AppVals.TEXTURE_WIDTH,Context3DTextureFormat.BGRA,false);
					tmp.uploadFromBitmapData(bmd);
					Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,tmp,mVerts,mCoords,mUniformMatrix,mUniformColor);
					tmp.dispose();
					tmp=null;
					Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,mFBO,mVerts,mCoords,mUniformMatrix,mUniformColor);
					bmd.fillRect(bmd.rect,0);
				}
				
				mCtx3D.setRenderToTexture(_useFrontBuffer?mFBO:mFBOBack);
				mCtx3D.clear(0,0,0,0);
				m2.identity()
				m2.scale(AppVals.TEXTURE_WIDTH/_bmdBackImage.width,AppVals.TEXTURE_WIDTH/_bmdBackImage.height);
				bmd.draw(_bmdBackImage,m2,null,null,null,true);
				tmp=mCtx3D.createTexture(AppVals.TEXTURE_WIDTH,AppVals.TEXTURE_WIDTH,Context3DTextureFormat.BGRA,false);
				tmp.uploadFromBitmapData(bmd);
				Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,tmp,mVerts,mCoords,mUniformMatrix,mUniformColor);
				tmp.dispose();
				tmp=null;
				
				setBlendMode(blendMode);
				Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,_useFrontBuffer?mFBOBack:mFBO,mVerts,mCoords,mUniformMatrix,mUniformColor);
				setBlendMode(null);
				
				if(_useFrontBuffer){
					mFBOBack.dispose();
				}else{
					mFBO.dispose();
				}
				
				mCtx3D.setRenderToBackBuffer();
				mUniformMatrix[2] = 0;
				mUniformMatrix[0] = 0;
				mUniformMatrix[1] = 0;
				mUniformMatrix[3] =bmd.width;
				m.identity()
				m.appendScale(1.0/(mWid*.5), 1.0/(mWid*.5), 1);
				mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m,false);
				mCtx3D.setTextureAt( 0, _useFrontBuffer?mFBO:mFBOBack);
				mCtx3D.setVertexBufferAt(1, mCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
				mCtx3D.setVertexBufferAt(0, mVertsStage, 0, Context3DVertexBufferFormat.FLOAT_2);
				
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
				
				
			}else if(blendMode==BlendMode.ALPHA||
				blendMode==BlendMode.ADD||
				blendMode==BlendMode.MULTIPLY||
				blendMode==BlendMode.SCREEN){
				///////////////////customBlend
				if(_bmdBackImage!=null)bmd.copyPixels(_bmdBackImage,_bmdBackImage.rect,new Point(0,0));
				
				var bm:String=blendMode==BlendMode.ALPHA?null:blendMode;
				var ct:ColorTransform=blendMode==BlendMode.ALPHA? new ColorTransform(1,1,1,0.6):null;
				
				mCtx3D.setRenderToBackBuffer();
				mUniformMatrix[2] = 0;
				mUniformMatrix[0] = 0;
				mUniformMatrix[1] = 0;
				mUniformMatrix[3] =bmd.width;
				m.identity()
				m.appendScale(1.0/(mWid*.5), 1.0/(mWid*.5), 1);
				mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m,false);
				mCtx3D.setTextureAt( 0, mFBO);
				
				if(_useFrontBuffer){
					var r:Rectangle=new Rectangle(0,0,mWid,mWid);
					var b2:BitmapData=new BitmapData(mWid,mWid,true,0);
				}
				
				for(x=0;x<Math.ceil(bmd.width/mWid);x++){
					for(y=0;y<Math.ceil(bmd.height/mWid);y++){
						mCtx3D.clear(0,0,0,0);
						mUniformMatrix[0] = -x*mWid + (bmd.width*.5-mWid*.5);
						mUniformMatrix[1] = y*mWid- (bmd.height*.5-mWid*.5) ;
						mCtx3D.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 4, mUniformMatrix );
						mCtx3D.drawTriangles(mIndicies);
						mCtx3D.drawToBitmapData(b);
						m2.identity();
						m2.translate(mWid*x,mWid*y);
						if(_useFrontBuffer){
							r.x=mWid*x;
							r.y=mWid*y;
							b2.copyPixels(_bmdFrontImage,r,new Point(0,0));
							b2.draw(b);
							bmd.draw(b2,m2,ct,bm);
						}else{
							bmd.draw(b,m2,ct,bm);
						}
					}
				}
				
			}else{
				/////////////////////////normal		

				if(_bmdBackImage!=null && !UTStampManager.getActiveLayerTop()){
					bmd.copyPixels(_bmdBackImage,_bmdBackImage.rect,new Point(0,0));
					if(_useFrontBuffer)bmd.draw(_bmdFrontImage);
				}else{
					if(_useFrontBuffer)bmd.copyPixels(_bmdFrontImage,_bmdFrontImage.rect,new Point(0,0));
				}
			
				
				mCtx3D.setRenderToBackBuffer();		
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
						m2.identity();
						m2.translate(mWid*x,mWid*y);
						bmd.draw(b,m2);
					}
				}
				
			}
			b.dispose();
		}
		
		
		private function _clear():void{	
			if(!mCtx3D)return;
			mCtx3D.setRenderToTexture(mFBO);
			mCtx3D.clear(0,0,0,0);

			mCtx3D.setRenderToTexture(mFBOBlendBuffer);
			mCtx3D.clear(0,0,0,0);
			if(_useFrontBuffer){
				mCtx3D.setRenderToTexture(mFBOFrontBuffer);
				mCtx3D.clear(0,0,0,0);
			}
			
			
			if(mTexBaseT==null)canvasChange();
			
			if(mBlendDistTexture==null){
				var bmd:BitmapData;
				bmd=new BitmapData(1024,1024,true,0x0);
				if(_bmdBackImage){
					var m:Matrix=new Matrix;
					m.scale(bmd.width/_bmdBackImage.width,bmd.height/_bmdBackImage.height);
					bmd.draw(_bmdBackImage,m,null,null,null,true);
				}
				mBlendDistTexture=Stage3DHelper.uploadTexture(mCtx3D,bmd,Context3DTextureFormat.BGRA,true,true);
			}
		}
		
		public function canvasChange():void{
			var bmd:BitmapData;
			bmd=new BitmapData(1024,1024,false,0xFFFFFF);
			UTImageBuilder.createPrintedImage(bmd,null,false,false,false,false);
			mTexBaseT = Stage3DHelper.uploadTexture(mCtx3D,bmd,Context3DTextureFormat.BGRA,true,true);
			_currentRect= UTItemManager.getZoomRectMotion(currentScale,_mcWidth,_mcHeight);	
		}
		
		
		public function clear():void{_clear();}
		
		
	}
}
