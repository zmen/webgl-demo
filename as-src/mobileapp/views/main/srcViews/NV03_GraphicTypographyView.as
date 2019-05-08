package utme.views.main.srcViews
{
	

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import jp.uniqlo.utlab.app.views.UITypographyView;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Cubic;
	import org.libspark.betweenas3.tweens.ITween;
	
	import utme.app.AppMain;
	import utme.app.UTCreateMain;
	import utme.app.NSFuncs.UTDeviceCapabilities;
	import utme.app.NSFuncs.UTUserDefaults;
	import utme.app.NSFuncs.UTUtils;
	import utme.app.consts.AppSound;
	import utme.app.consts.AppVals;
	import utme.app.managers.UTFontManager;
	import utme.app.managers.UTItemManager;
	import utme.app.managers.UTTopLayerManager;
	import utme.views.common.classes.DragInfoViewController;
	import utme.views.common.classes.RectSprite;
	import utme.views.common.classes.ToolViewController;
	import utme.views.common.classes.UTImageBuilder;
	import utme.views.common.classes.dragger.TouchDraggableHelper;
	import utme.views.main.common.AnimateType;
	import utme.views.main.common.INavigatedView;
	import utme.views.main.menuViews.NV10_RemixListView;
	
	public class NV03_GraphicTypographyView extends jp.uniqlo.utlab.app.views.UITypographyView implements INavigatedView
	{
		
		public static function createRenderTextField():TextField{
			var tf:TextField;
			tf=new TextField;
			tf.embedFonts=true;
			
			tf.multiline=true;
			tf.selectable=false;
			tf.autoSize=TextFieldAutoSize.LEFT;
			tf.antiAliasType=AntiAliasType.ADVANCED;
			tf.gridFitType=GridFitType.NONE;
			tf.thickness=AppVals.TEXT_THICKNESS;
			tf.border=false;
			return tf;
		}
		
		private var stageText:StageText;
		private var textField:TextField;
		private var textForamt:TextFormat;
		private var _mcHeight:Number;
		private var _mcWidth:Number;
		private var _bmBase:Bitmap;
		private var _keyboardY:Number=-1;
		private var _textRect:Point=new Point;
		private var _areaRect:Point=new Point;
		private var texScale:Number=1;
		private var texX:Number=0;
		private var texY:Number=0;
		private var keyboard:Boolean;	
		private var _stage:Stage;
		private var _cursor:Shape;
		private const COLLOR_SET:Array=[
			0x000000,0x666666,0xbfbfbf,0xffffff,0xe00011,
			0xf28a00,0xd1bd9d,0xffee00,0xb3e55c,0x2d9900,
			0x85deed,0x0089ce,0x4c37a5,0xfebbf1,0xff65a4
		];
		private var _colorBtns:Vector.<Sprite>		
		private var _embedFont:Font;
		private var _typeT:Sprite
		private const ALIGN_TOP_RATE:Number=0.175;
		///private const ALIGN_MIDDLE_RATE:Number=0.5
		///private const ALIGN_BOTTOM_RATE:Number=1.0;
		private var hsaInput:Boolean;
		private var _tfActive:Boolean=false;
		private var _lastText:String
		private var spHelped:TouchDraggableHelper;
		private var typeWrap:Sprite;
		private var captureView:Sprite;
		
		private var photoMask:RectSprite;
		private const TYPESET_HEIGHT:Number = 132;
		
		private var _TopLayer:Bitmap=null;
		private const IMAGE_MARGIN_Y:Number = 15;
		private const IMAGE_MARGIN_X:Number = 15;
		
		private var IMAGE_INNER_WIDTH:Number;
		private var IMAGE_INNER_HEIGHT:Number;
		
		//private var photo_frame:PhotoFrame;
		public function NV03_GraphicTypographyView(){
			super();
			_typeT=new Sprite;
			_bmBase=new Bitmap();
			this.addChildAt(_typeT,0);
			_typeT.addChild(_bmBase);
			
			//typeSet.fontSet.fontInsideView.fontSelectedView.x=typeSet.fontSet.fontInsideView.fontSelectedView.x+0.5;
			IMAGE_INNER_WIDTH= UTItemManager.IMAGE_WIDTH-IMAGE_MARGIN_X*2;
			IMAGE_INNER_HEIGHT = UTItemManager.IMAGE_HEIGHT-IMAGE_MARGIN_Y*2;
			
			
			_areaRect.x=1024;
			_areaRect.y=_areaRect.x/UTItemManager.IMAGE_WIDTH*UTItemManager.IMAGE_HEIGHT;
			
			_textRect.x=_areaRect.x/UTItemManager.IMAGE_WIDTH*IMAGE_INNER_WIDTH;
			_textRect.y=_textRect.x/IMAGE_INNER_WIDTH*IMAGE_INNER_HEIGHT;
			
			textForamt=new TextFormat;
			rightMargin=new TextFormat;
			rightMargin.rightMargin=0;
			
			textForamt.size=64;
			textForamt.leading=10;
			textForamt.kerning=true;
			
			
			setAlignWidthDisplay(TextFormatAlign.CENTER);
			
			textField=createRenderTextField();
			textField.setTextFormat(textForamt);
			
			captureView=new Sprite;
			typeWrap=new Sprite;
			_typeT.addChildAt(captureView,1);
			captureView.addChild(typeWrap);
			
			typeWrap.addChild(textField);
			
			//photo_frame=new PhotoFrame;
			photoMask = new RectSprite(1, 1, 0xff0000)
			
			photo_frame.x=photoMask.x=0;
			photo_frame.y=photoMask.y=0;
			photoMask.visible = false;	
			
			if(UTTopLayerManager.hasTopLayer()){
				_TopLayer=new Bitmap(UTTopLayerManager.getTopLayerThumbImage(),PixelSnapping.AUTO,true);
				captureView.addChild(_TopLayer);
				_TopLayer.x=0;
				_TopLayer.y=0;
				_TopLayer.height=_areaRect.y;
				_TopLayer.width=_areaRect.x;
			}
			
			
			textField.mask=photoMask;
			
			photo_frame.visible=false;
			
			captureView.addChild(photo_frame);
			captureView.addChild(photoMask);
			spHelped = new TouchDraggableHelper(null, AppVals.stage);
			/*
			typeWrap.graphics.beginFill(0x000000,0.5);
			typeWrap.graphics.drawRect(0,0,_textRect.x,_textRect.y);
			typeWrap.graphics.endFill();
			//spHelped.init((_areaRect.x-_textRect.x)*.5,(_areaRect.y-_textRect.y)*.5,0,1);
			typeWrap.graphics.clear();
			*/
			
			typeWrap.x=(_areaRect.x-_textRect.x)*.5;
			typeWrap.y=(_areaRect.y-_textRect.y)*.5;
			typeWrap.scaleX=typeWrap.scaleY=1;
			typeWrap.rotation=0;
			
			spHelped.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			spHelped.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			spHelped.addEventListener(MouseEvent.CLICK,mouseClickHandler);
			
			_cursor=new Shape;
			_cursor.visible=false;
			typeWrap.addChild(_cursor);
			_cursorCnt=0;
			
			//colorPanel
			//trace(Math.floor((COLLOR_SET.length-1)/5.0));
			var _listH:int=Math.floor((COLLOR_SET.length-1)/5.0+1)*99-10;
			var _h:int=_listH+77+1;
			var ALLORW_HEIGHT:int=31;
			
			typeSet.colorSet.backView.height=_h+88;
			typeSet.colorSet.backView.y=-(_h+88)-30;
			typeSet.colorSet.header.y=-(_h+88)-30;
			
			
			var _sprite:Shape=new Shape();
			_colorBtns=new Vector.<Sprite>;
			var xs:Number=544.0/5.0;
			for (var i:int=0;i<COLLOR_SET.length;i++){
				var col:uint=COLLOR_SET[i];
				var sp:MovieClip=new MovieClip;
				typeSet.colorSet.addChild(sp);
				_colorBtns.push(sp);
				sp.graphics.clear();
				sp.graphics.beginFill(col,0);
				sp.graphics.drawRect(0,0,xs,88);
				sp.x=int(xs*(i%5)+(640-544)*.5);
				sp.y=int(Math.floor(i/5.0)*99-ALLORW_HEIGHT-_h+(_h-_listH)*.5);
				
				var b:BitmapData=new BitmapData(48*AppVals.GLOBAL_SCALE,48*AppVals.GLOBAL_SCALE,true,0);
				_sprite.graphics.lineStyle(0);
				_sprite.graphics.clear();
				_sprite.graphics.beginFill(COLLOR_SET[i]);
				_sprite.graphics.lineStyle(col==0xFFFFFF?1:0,0xCCCCCC,col==0xFFFFFF?1:0);
				
				_sprite.graphics.drawCircle(48/2*AppVals.GLOBAL_SCALE,48/2*AppVals.GLOBAL_SCALE,45/2*AppVals.GLOBAL_SCALE);
				b.drawWithQuality(_sprite,null,null,null,null,true,StageQuality.HIGH);
				var bm:Bitmap=new Bitmap(b);
				bm.width=b.width/AppVals.GLOBAL_SCALE;
				bm.height=b.height/AppVals.GLOBAL_SCALE;
				bm.x=(sp.width-bm.width)*.5;
				bm.y=(sp.height-bm.height)*.5;
				
				sp.addChild(bm);
				sp.mouseChildren=false;
				sp.buttonMode=true;
				sp.index=i;
				sp.addEventListener(MouseEvent.CLICK,colorCell_Touchup);
			}
			
			
			var bmd:BitmapData=new BitmapData(70*AppVals.GLOBAL_SCALE,70*AppVals.GLOBAL_SCALE,true,0);
			_sprite.graphics.clear();
			_sprite.graphics.beginFill(0x333333,0);
			_sprite.graphics.lineStyle(5*AppVals.GLOBAL_SCALE,0x333333,1.0);
			_sprite.graphics.drawCircle(70/2*AppVals.GLOBAL_SCALE,70/2*AppVals.GLOBAL_SCALE,62.5/2*AppVals.GLOBAL_SCALE);
			_sprite.graphics.endFill();
			_sprite.graphics.lineStyle(0);
			bmd.drawWithQuality(_sprite,null,null,null,null,true,StageQuality.HIGH);
			_selectedBm=new Bitmap(bmd);
			_selectedBm.width=bmd.width/AppVals.GLOBAL_SCALE;
			_selectedBm.height=bmd.height/AppVals.GLOBAL_SCALE;
			_selectedBm.x=(sp.width-_selectedBm.width)*.5;
			_selectedBm.y=(sp.height-_selectedBm.height)*.5;
			
			
			
			_isIntro=!UTUserDefaults.finisedTypeIntro;
			
			if(!_isIntro){
				if(whiteBack!=null)removeChild(whiteBack);
				if(inst_mov!=null)removeChild(inst_mov);
				whiteBack=null;
				inst_mov=null;
			}
			
			
			_stage=AppVals.stage;
			activePos=0;
			_lastText="";
			
			_isZoom=false;
			
			
			photo_frame.height=photoMask.height=_areaRect.y;
			photo_frame.width=photoMask.width=_areaRect.x;
			
			
			
			
		}
		private var _selectedBm:Bitmap;
		
		public var htmlText:String;
		private function startMoveListen():void{
			//trace("startMoveListen");
			spHelped.startListen();
		}
		private function stopMoveListen():void{
			//trace("stopMoveListen");
			spHelped.stopListen()		
		}
		
		
		
		
		private function mouseDownHandler(e:Event):void {
			photoMask.visible = false;
			textField.mask = null;
			photo_frame.visible = true;
			if(_cursor.parent)_cursor.parent.removeChild(_cursor);
			spHelped.initWithView(typeWrap);
		}
		
		private function mouseUpHandler(e:Event):void {
			spHelped.initWithView(null);
			
			UTUtils.rotateStrech(typeWrap);
			
			photo_frame.visible = false;
			textField.mask = photoMask;
			photoMask.visible = true;
			typeWrap.addChild(_cursor);
		}
		
		private function mouseClickHandler(e:Event):void {
			//trace("mouseClickHandler");
			//if(typeWrap.hitTestPoint(stage.mouseX,stage.mouseY,false)){
			if(!keyboard){
				dragStage(null);
				stageText.assignFocus();
			}
			//}
		}
		
		private function setColorIndex(colorIndex:uint):void{
			AppVals.Type_LastColor=COLLOR_SET[colorIndex];
			_colorBtns[colorIndex].addChild(_selectedBm);
			var c:uint=COLLOR_SET[colorIndex];
			var r:Number=255-(((c>>16)&0xFF)*0.299+((c>>8)&0xFF)*0.587+((c>>0)&0xFF)*0.114);
			r+=190;
			if(r>255)r=255;
			c= (int(((c>>16)&0xFF)/255*r)<<16)|(int(((c>>8)&0xFF)/255*r)<<8)|(int(((c>>0)&0xFF)/255*r)<<0);
			_cursor.graphics.clear();
			_cursor.graphics.lineStyle(2,c,1.0,false,LineScaleMode.NONE,CapsStyle.NONE);
			_cursor.graphics.moveTo(0,0);
			_cursor.graphics.lineTo(0,-Number(textForamt.size));
			textForamt.color=COLLOR_SET[colorIndex];
		}
		
		private function colorCell_Touchup(e:MouseEvent):void{
			var colorIndex:int=e.target.index;
			AppSound.playSound(2);
			setColorIndex(colorIndex);
			e.stopImmediatePropagation();
			stageText.assignFocus();
			colorModal_Touchup(null);
		}
		
		private function createTextField():void{
			var lp:int=activePos;
			stageText = new StageText(new StageTextInitOptions(true));
			stageText.viewPort =  new Rectangle(0,-120,600,100);				
			//			stageText.viewPort =  new Rectangle(0,120,600,100);				
			//stageText.displayAsPassword=true;
			stageText.addEventListener(FocusEvent.FOCUS_IN,keyboardFocusIn);
			stageText.addEventListener(FocusEvent.FOCUS_OUT,keyboardFocusOut);
			
			if(UTDeviceCapabilities.isAndroid()){
				stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,deactiveKeyBoard);	
			}
			
			stageText.stage=AppVals.stage;
			stageText.text=_lastText;
			if(lp>_lastText.length)lp=_lastText.length;
			stageText.selectRange(lp,lp);
			setFontWithDisplay(AppVals.Type_LastFontType, AppVals.Type_LastFontStyle);
			stageText.textAlign=textForamt.align;
		}
		
		public static var  isKeyboardDisposing:Boolean=false;
		
		private function deactiveKeyBoard(e:SoftKeyboardEvent):void{
			stage.focus=null;
			trace("deactiveKeyBoard");
			isKeyboardDisposing=true;
			setTimeout(function():void{isKeyboardDisposing=false;},500);
		}
		
		private function disposeTextField():void{
			if(stageText==null)return;
			_lastText=stageText.text;
			stageText.removeEventListener(FocusEvent.FOCUS_IN,keyboardFocusIn);
			stageText.removeEventListener(FocusEvent.FOCUS_OUT,keyboardFocusOut);
			stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,deactiveKeyBoard);
			stageText.stage=null;
			stageText.dispose();
			stageText=null;
		}
		
		private function _alignBtn_Touchup(e:MouseEvent):void{
			if(e!=null){
				e.stopImmediatePropagation();
				stageText.assignFocus();
				AppSound.playSound(3);
			}
			ToolViewController.openModalView(typeSet.alignBtn,typeSet.alignSet,colorModal_Touchup);
			typeSet.alignBtn.addEventListener(MouseEvent.CLICK,colorModal_Touchup);
			typeSet.alignBtn.removeEventListener(MouseEvent.CLICK,_alignBtn_Touchup);	
			checkModalHeight(true);	
			typeSet.alignBtn.gray.cache.visible=false;
			typeSet.alignBtn.gray.cache_over.visible=true;
		}
		
		public function fontbtn_Touchup(e:Event):void{
			if(e!=null){
				e.stopImmediatePropagation();
				stageText.assignFocus();
				AppSound.playSound(3);
			}
			typeSet.fontSet.fontInsideView.x=0;
			
			ToolViewController.openModalView(typeSet.fontBtn,typeSet.fontSet,colorModal_Touchup);
			typeSet.fontBtn.addEventListener(MouseEvent.CLICK,colorModal_Touchup);
			typeSet.fontBtn.removeEventListener(MouseEvent.CLICK,fontbtn_Touchup);	
			checkModalHeight(true);	
			typeSet.fontBtn.gray.cache.visible=false;
			typeSet.fontBtn.gray.cache_over.visible=true;
		}
		
		public function colorbtn_Touchup(e:Event):void{
			if(e!=null){
				e.stopImmediatePropagation();
				stageText.assignFocus();
				AppSound.playSound(3);
			}
			ToolViewController.openModalView(typeSet.colorBtn,typeSet.colorSet,colorModal_Touchup);
			typeSet.colorBtn.addEventListener(MouseEvent.CLICK,colorModal_Touchup);
			typeSet.colorBtn.removeEventListener(MouseEvent.CLICK,colorbtn_Touchup);	
			checkModalHeight(true);	
			typeSet.colorBtn.gray.cache.visible=false;
			typeSet.colorBtn.gray.cache_over.visible=true;
		}
		
		private function colorModal_Touchup(e:Event):void{
			if(e!=null){
				e.stopImmediatePropagation();
				stageText.assignFocus();
				AppSound.playSound(4);
			}
			modalCloseAndTrrigers();	
			checkModalHeight(false);
			typeSet.alignBtn.gray.cache.visible=true;
			typeSet.alignBtn.gray.cache_over.visible=false;
			typeSet.colorBtn.gray.cache.visible=true;
			typeSet.colorBtn.gray.cache_over.visible=false;
			typeSet.fontBtn.gray.cache.visible=true;
			typeSet.fontBtn.gray.cache_over.visible=false;
		}
		
		
		private function modalCloseAndTrrigers():void{
			ToolViewController.closeModalView();
			typeSet.alignBtn.removeEventListener(MouseEvent.CLICK,colorModal_Touchup);
			typeSet.fontBtn.removeEventListener(MouseEvent.CLICK,colorModal_Touchup);
			typeSet.colorBtn.removeEventListener(MouseEvent.CLICK,colorModal_Touchup);
			typeSet.fontBtn.removeEventListener(MouseEvent.CLICK,fontbtn_Touchup);	
			typeSet.alignBtn.removeEventListener(MouseEvent.CLICK,_alignBtn_Touchup);	
			typeSet.colorBtn.removeEventListener(MouseEvent.CLICK,colorbtn_Touchup);	
			typeSet.fontBtn.addEventListener(MouseEvent.CLICK,fontbtn_Touchup);	
			typeSet.alignBtn.addEventListener(MouseEvent.CLICK,_alignBtn_Touchup);	
			typeSet.colorBtn.addEventListener(MouseEvent.CLICK,colorbtn_Touchup);	
		}
		
		
		private function setModalHeight(mc:MovieClip):Number{
			
			var keyH:Number=UTDeviceCapabilities.isIOS()?_keyboardY/AppVals.GLOBAL_SCALE:_keyboardY;
			return Math.max(_mcHeight-keyH-TYPESET_HEIGHT,mc.height+20);
		}
		
		private function calcModalYPos(checkMc:Boolean):Number{
			if(checkMc){
				if(typeSet.alignSet.visible)return setModalHeight(typeSet.alignSet);
				if(typeSet.colorSet.visible)return setModalHeight(typeSet.colorSet);
				if(typeSet.fontSet.visible)return setModalHeight(typeSet.fontSet);
			}
			var keyH:Number=UTDeviceCapabilities.isIOS()?_keyboardY/AppVals.GLOBAL_SCALE:_keyboardY;
			return _mcHeight-keyH-TYPESET_HEIGHT;
		}
		
		private function checkModalHeight(checkMc:Boolean):void{
			if(tween2&&tween2.isPlaying)tween2.stop();
			tween2 = BetweenAS3.tween(typeSet,{ y:calcModalYPos(checkMc)},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
			tween2.play();
		}
		
		
		private var _cursorCnt:int;
		
		public function keyBtn_Touchdown(e:MouseEvent):void{
			stageText.assignFocus();
			//trace("keyBtn_Touchdown");
		}
		public function _okBack_Touchdown(e:MouseEvent):void{
			if(keyboard)stageText.assignFocus();
			e.stopPropagation();
		}
		public function disable_Touchdown(e:MouseEvent):void{
			e.stopImmediatePropagation();
		}
		
		public function disableAndFocus_Touchdown(e:MouseEvent):void{
			e.stopImmediatePropagation();
			stageText.assignFocus();
			//trace("disableAndFocus_Touchdown");
		}
		
		public function onResize(aWidth:Number, aHeight:Number):void{
			
			_mcWidth=aWidth;
			_mcHeight=aHeight;
			_keyboardY=-1;
			_activeKeyHeight=-TYPESET_HEIGHT;
			
		}
		
		private var _isIntro:Boolean;
		
		public function canvasChangeWithCapture():BitmapData{
			var _bmd:BitmapData=new BitmapData(AppVals.stage.stageWidth,AppVals.stage.stageHeight,false,0xFFFFFFFF);
			_bmd.draw(AppVals.stage);
			return _bmd;
		}
		
		public function canvasChange():void{
			
			var r:Rectangle= UTItemManager.getZoomRect(_isZoom,_mcWidth,_mcHeight);	
			_typeT.x=r.x;
			_typeT.y=r.y;
			_typeT.scaleX=r.width/1024;
			_typeT.scaleY=r.height/1024;
			
			captureView.scaleX=UTItemManager.wkWidth;
			captureView.scaleY=UTItemManager.wkWidth;
			captureView.x=1024*UTItemManager.wkCenter.x-1024*UTItemManager.wkWidth*.5;
			captureView.y=1024*UTItemManager.wkCenter.y-(1024*UTItemManager.wkWidth/UTItemManager.IMAGE_WIDTH*UTItemManager.IMAGE_HEIGHT)*.5;
			
			var bmd:BitmapData=new BitmapData(1024,1024,false,0xFFFFFF);
			UTImageBuilder.createPrintedImage(bmd,UTCreateMain.getParent(this).getImage(),UTItemManager.wkMultiply,false,false,false);
			_bmBase.bitmapData=bmd;
			_bmBase.smoothing=true;
		}
		
		
		public function viewWillAppear(isNew:Boolean):void{
			
			_mcWidth=AppVals.stage.stageWidth/AppVals.GLOBAL_SCALE;
			_mcHeight=AppVals.stage.stageHeight/AppVals.GLOBAL_SCALE-AppVals.STATUSBAR_HEIGHT;
			
			if(_image!=null){
				_image.dispose();
				_image=null;
			}
			_addedSpace=false;
			keyboard=false;
			_unloadFlg=false;
			if(_bmBase.bitmapData==null)canvasChange();
			
			for(var i:int=0;i<COLLOR_SET.length;i++)if(AppVals.Type_LastColor==COLLOR_SET[i])break;
			if(i==COLLOR_SET.length)i=0;
			setColorIndex(i);
			
			//footerSet.y=AppVals.stage.stageHeight/AppVals.GLOBAL_SCALE-AppVals.STATUSBAR_HEIGHT;
			
			scaleBtn.y=_mcHeight+20;
			
			if(_isIntro){
				UTUserDefaults.finisedTypeIntro=true;
				UTUserDefaults.saveSettings();
				whiteBack.x=0;
				whiteBack.y=-AppVals.STATUSBAR_HEIGHT;
				whiteBack.width=_mcWidth;
				whiteBack.height=_mcHeight+AppVals.STATUSBAR_HEIGHT;
				inst_mov.x=_mcWidth*.5;
				inst_mov.y=_mcHeight*.5;
				inst_mov.mov.gotoAndStop(1);
			}
			
			typeSet.y=AppVals.stage.stageHeight/AppVals.GLOBAL_SCALE-AppVals.STATUSBAR_HEIGHT;
			keyHideBtn.y=-AppVals.STATUSBAR_HEIGHT-keyHideBtn.height;
			
			typeSet.fontSet.visible=false;
			typeSet.alignSet.visible=false;
			typeSet.colorSet.visible=false;
			
			hsaInput=textField.text.length==0;
			setButtonStatus(textField.text.length>0);
			scaleBtn.zoomin.visible=!_isZoom;
			scaleBtn.zoomout.visible=_isZoom;
		}
		
		public function viewDidAppear():void{
			backBtn.addEventListener(MouseEvent.CLICK,_backBtn_Touchup);
			if(_isIntro){
				inst_mov.mov.gotoAndPlay(1);
				UTUtils.setTimeout(openingMovCose,AppVals.ANIMATION_FADE_TIME)
				_stage.addEventListener(MouseEvent.MOUSE_DOWN,openingMovCose);
			}else{
				onStart();
			}
		}
		
		private  function addModalListener():void{
			typeSet.alignBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.colorBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.fontBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			
			typeSet.fontSet.fontInsideView.font1Btn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.fontSet.fontInsideView.font2Btn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.fontSet.fontInsideView.font3Btn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.fontSet.fontInsideView.font4Btn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.fontSet.fontInsideView.fontStyle1Btn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.fontSet.fontInsideView.fontStyle2Btn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.fontSet.fontInsideView.backBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			
			typeSet.fontSet.fontInsideView.fontStyle3Btn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			
			typeSet.alignSet.alignLeftBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.alignSet.alignCenterBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.alignSet.alignRightBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
		}
		
		private function onStart():void{
			if(whiteBack!=null)removeChild(whiteBack);
			if(inst_mov!=null)removeChild(inst_mov);
			whiteBack=null;
			inst_mov=null;
			
			setChildIndex(backBtn,getChildIndex(restartBtn));
			
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,clickStage);
			
			_tfActive=true;
			createTextField();
			
			stageText.assignFocus();
			
			typeSet.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			
			
			backBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			okBtn.addEventListener(MouseEvent.CLICK,_okBtn_Touchup);
			okBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			keyHideBtn.addEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			keyHideBtn.addEventListener(MouseEvent.CLICK,keyHideBtn_Touchdown);
			scaleBtn.addEventListener(MouseEvent.CLICK,scaleBtn_TouchUp);
			
			typeSet.alignBtn.addEventListener(MouseEvent.CLICK,_alignBtn_Touchup);
			typeSet.colorBtn.addEventListener(MouseEvent.CLICK,colorbtn_Touchup);
			
			keyBtn.addEventListener(MouseEvent.CLICK,keyBtn_Touchdown);
			
			addEventListener(Event.ENTER_FRAME,enterFrame);	
			onCursorChanged();			
			
			this.spHelped.disableTouchDownObjects([okBtn,backBtn,keyHideBtn,typeSet,keyBtn,restartBtn,baseBtn]);
			
			typeSet.fontBtn.addEventListener(MouseEvent.CLICK,fontbtn_Touchup);
			
			typeSet.alignSet.alignLeftBtn.addEventListener(MouseEvent.CLICK,alignSelected_Touchdown);
			typeSet.alignSet.alignCenterBtn.addEventListener(MouseEvent.CLICK,alignSelected_Touchdown);
			typeSet.alignSet.alignRightBtn.addEventListener(MouseEvent.CLICK,alignSelected_Touchdown);
			
			
			var MOUSE_EVENT_HACK:String=UTDeviceCapabilities.isIOS()?MouseEvent.MOUSE_DOWN:MouseEvent.CLICK;
			typeSet.fontSet.fontInsideView.font1Btn.addEventListener(MOUSE_EVENT_HACK,fontFuncBtn_Touchup);
			typeSet.fontSet.fontInsideView.font2Btn.addEventListener(MOUSE_EVENT_HACK,fontFuncBtn_Touchup);
			typeSet.fontSet.fontInsideView.font3Btn.addEventListener(MOUSE_EVENT_HACK,fontFuncBtn_Touchup);
			typeSet.fontSet.fontInsideView.font4Btn.addEventListener(MOUSE_EVENT_HACK,fontFuncBtn_Touchup);
			typeSet.fontSet.fontInsideView.fontStyle1Btn.addEventListener(MOUSE_EVENT_HACK,fontFuncBtn_Touchup);
			typeSet.fontSet.fontInsideView.fontStyle2Btn.addEventListener(MOUSE_EVENT_HACK,fontFuncBtn_Touchup);
			typeSet.fontSet.fontInsideView.fontStyle3Btn.addEventListener(MOUSE_EVENT_HACK,fontFuncBtn_Touchup);
			
			typeSet.fontSet.fontInsideView.backBtn.addEventListener(MOUSE_EVENT_HACK,fontWeightBackBtn_Touchup);
			
			
			addModalListener();
			
			_isZoom=true;
			scaleBtn.zoomin.visible=!_isZoom;
			scaleBtn.zoomout.visible=_isZoom;
		}
		
		
		public function alignSelected_Touchdown(e:MouseEvent):void{
			e.stopImmediatePropagation();
			stageText.assignFocus();
			var len:int=textField.text.length;
			
			if(e.target.name=="alignLeftBtn"){
				setAlignWidthDisplay(TextFormatAlign.LEFT);
				textField.htmlText=textField.htmlText.replace(/ALIGN="[A-Z]+"/g,"ALIGN=\"LEFT\"");				
			}
			if(e.target.name=="alignCenterBtn"){
				setAlignWidthDisplay(TextFormatAlign.CENTER);
				textField.htmlText=textField.htmlText.replace(/ALIGN="[A-Z]+"/g,"ALIGN=\"CENTER\"");
			}
			if(e.target.name=="alignRightBtn"){
				setAlignWidthDisplay(TextFormatAlign.RIGHT);
				textField.htmlText=textField.htmlText.replace(/ALIGN="[A-Z]+"/g,"ALIGN=\"RIGHT\"");
			}
			
			if(len<textField.text.length)textField.replaceText(len,textField.text.length,"");
			colorModal_Touchup(null);
			onChangeText(null);
		}
		
		
		public function setAlignWidthDisplay(ALIGN:String):void{
			if(stageText)stageText.textAlign=ALIGN;
			textForamt.align=ALIGN;
			typeSet.alignSet.alignLeftBtn.selected.visible=ALIGN==TextFormatAlign.LEFT;
			typeSet.alignSet.alignCenterBtn.selected.visible=ALIGN==TextFormatAlign.CENTER;
			typeSet.alignSet.alignRightBtn.selected.visible=ALIGN==TextFormatAlign.RIGHT;
			typeSet.alignBtn.left.visible=ALIGN==TextFormatAlign.LEFT;
			typeSet.alignBtn.center.visible=ALIGN==TextFormatAlign.CENTER;
			typeSet.alignBtn.right.visible=ALIGN==TextFormatAlign.RIGHT;
		}
		
		//private var fontType:int=-1;
		//private var fontStyle:int=-1;
		
		private var fTween:ITween;
		
		public function fontFuncBtn_Touchup(e:Event):void{
			
			e.stopImmediatePropagation();
			
			var type:int=AppVals.Type_LastFontType;
			var style:int=AppVals.Type_LastFontStyle;
			
			if(e.target.name=="font1Btn")type=0;
			if(e.target.name=="font2Btn")type=1;
			if(e.target.name=="font3Btn")type=2;
			if(e.target.name=="font4Btn")type=3;
			if(e.target.name=="fontStyle1Btn")style=0;
			if(e.target.name=="fontStyle2Btn")style=1;
			if(e.target.name=="fontStyle3Btn")style=2;
			
			AppVals.Type_LastFontType=type;
			AppVals.Type_LastFontStyle=style;
			
			setFontWithDisplay(type,style);
			
			var lp:int=activePos;
			if(lp>_lastText.length)lp=_lastText.length;
			stageText.selectRange(lp,lp);
			stageText.assignFocus();
			
			if(e.target.name.indexOf("fontStyle")>-1){
				colorModal_Touchup(null);
				if(e!=null)AppSound.playSound(2);
			}else{
				if(e!=null)AppSound.playSound(0);
				if(fTween&&fTween.isPlaying)fTween.stop();
				fTween = BetweenAS3.tween(typeSet.fontSet.fontInsideView,{ x:-640},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				fTween.play();
			}
		}
		
		public function fontWeightBackBtn_Touchup(e:Event):void{
			if(fTween&&fTween.isPlaying)fTween.stop();
			fTween = BetweenAS3.tween(typeSet.fontSet.fontInsideView,{ x:0},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
			fTween.play();
		}
		
		
		public function setFontWithDisplay(type:int , style:int):void{
			
			typeSet.fontSet.fontInsideView.font1Btn.selected.visible=type==0;
			typeSet.fontSet.fontInsideView.font2Btn.selected.visible=type==1;
			typeSet.fontSet.fontInsideView.font3Btn.selected.visible=type==2;
			typeSet.fontSet.fontInsideView.font4Btn.selected.visible=type==3;
			
			typeSet.fontSet.fontInsideView.fontStyle1Btn.selected.visible=style==0;
			typeSet.fontSet.fontInsideView.fontStyle2Btn.selected.visible=style==1;
			typeSet.fontSet.fontInsideView.fontStyle3Btn.selected.visible=style==2;
			
			
			var size:Number=57;
			var isPassword:Boolean=false;
			if(type==0){
				// UNIQLO PRO
				if(style==0){
					_embedFont　= UTFontManager.getFont("uniqlo_l");
				}else if(style==1){
					_embedFont　= UTFontManager.getFont("uniqlo_r");
				}else if(style==2){
					_embedFont　= UTFontManager.getFont("uniqlo_b");
				}
				size=65;
				isPassword=true;
			}else if(type==1){
				// ゴシック
				if(style==0){
					_embedFont　= UTFontManager.getFont("kaku_l");
				}else if(style==1){
					_embedFont　= UTFontManager.getFont("kaku_r");
				}else if(style==2){
					_embedFont　= UTFontManager.getFont("kaku_b");
				}
				size=57;
				isPassword=false;
			}else if(type==2){
				// 丸ゴシック
				if(style==0){
					_embedFont　= UTFontManager.getFont("maru_l");
				}else if(style==1){
					_embedFont　=UTFontManager.getFont("maru_r");
				}else if(style==2){
					_embedFont　= UTFontManager.getFont("maru_b");
				}
				size=57;
				isPassword=false;
			}else if(type==3){
				// 明朝
				if(style==0){
					_embedFont　= UTFontManager.getFont("min_l");
				}else if(style==1){
					_embedFont　= UTFontManager.getFont("min_r");
				}else if(style==2){
					_embedFont　= UTFontManager.getFont("min_b");
				}
				size=57;
				isPassword=false;
			}else return;
			
			textForamt.font=_embedFont.fontName;
			textForamt.size=size;
			if(stageText&&stageText.displayAsPassword!=isPassword){
				stageText.displayAsPassword=isPassword;
				//trace("UPDADE PASS");
			}
			//trace("setFont",_embedFont.fontName);
			//trace(Font.enumerateFonts());
		}
		
		
		
		
		
		public function viewWillDisappear():void{
			if(tween1&&tween1.isPlaying)tween1.stop();
			if(tween2&&tween2.isPlaying)tween2.stop();
			if(tween3&&tween3.isPlaying)tween3.stop();
			if(tween4&&tween4.isPlaying)tween4.stop();
			if(tween5&&tween5.isPlaying)tween5.stop();
			if(tween6&&tween6.isPlaying)tween6.stop();
			
			spHelped.stopListen();
			
			typeSet.fontBtn.removeEventListener(MouseEvent.CLICK,fontbtn_Touchup);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,clickStage);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragStage);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,dragEndStage);
			
			backBtn.removeEventListener(MouseEvent.CLICK,_backBtn_Touchup);
			okBtn.removeEventListener(MouseEvent.CLICK,_okBtn_Touchup);
			backBtn .removeEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			okBtn.removeEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			typeSet.removeEventListener(MouseEvent.MOUSE_DOWN,disableAndFocus_Touchdown);
			keyHideBtn.removeEventListener(MouseEvent.MOUSE_DOWN,_okBack_Touchdown);
			keyHideBtn.removeEventListener(MouseEvent.CLICK,keyHideBtn_Touchdown);
			
			
			typeSet.alignSet.alignLeftBtn.removeEventListener(MouseEvent.CLICK,alignSelected_Touchdown);
			typeSet.alignSet.alignCenterBtn.removeEventListener(MouseEvent.CLICK,alignSelected_Touchdown);
			typeSet.alignSet.alignRightBtn.removeEventListener(MouseEvent.CLICK,alignSelected_Touchdown);
			
			keyBtn.removeEventListener(MouseEvent.CLICK,keyBtn_Touchdown);
			typeSet.alignBtn.removeEventListener(MouseEvent.CLICK,_alignBtn_Touchup);	
			
			removeEventListener(Event.ENTER_FRAME,enterFrame);	
			_tfActive=false;
			this.disposeTextField();
			AppMain.setUIIntaractionEnable(true);
		}	
		
		public function viewDidDisappear():void{
			if(_bmBase.bitmapData!=null){
				_bmBase.bitmapData.dispose();
				_bmBase.bitmapData=null;
			}
		}
		
		private var txtWillChange:Boolean;		
		private var activePos:int;
		private var mTimer:uint=0;
		//private var _VerticalPosition:Number;
		
		private function keyHideBtn_Touchdown(e:MouseEvent):void{
			stage.focus=null;
		}
		
		//private const oneChanacterCheckDecender:RegExp=/[gjpqy,;Q$]/;
		
		private var _addedSpace:Boolean=false;
		
		private var _lastStx:String="";
		private function setButtonStatus(input:Boolean):void{
			///トップボタン制御（テキストは無関係）
			//trace("setButtonStatus",input);
			if(input!=hsaInput){
				UTUtils.buttonStatus(okBtn,input);
				//AppFuncs.buttonStatus(footerSet.resetBtn,input);		
				hsaInput=input;
			}
		}
		
		private function onChangeText(e:Event):void{
			
			if(ToolViewController.isOpen)modalCloseAndTrrigers();
			
			txtWillChange=false;
			var i:int;
			var c:int;
			
			activePos=stageText.selectionActiveIndex;
			
			var body:String=stageText.text.replace(/\r\n|\n\r|\r/g, "\n");
			var n:uint=body.length;
			var stx:String="";
			
			var topDiffPoint:int=0;
			topDiffPoint=Math.min(activePos-(body.length- _lastStx.length),activePos);
			for(i=0,c=0;i<activePos;i++){
				if(body.charAt(i)!=_lastStx.charAt(i)){
					topDiffPoint=i;
					break;
				}
			}
			
			stx=body.substr(0,topDiffPoint);
			for(i=topDiffPoint,c=topDiffPoint;i<activePos;i++){
				if(_embedFont.hasGlyphs(body.charAt(i))){
					stx+=body.charAt(i);
					c++;
				}else　if(body.charAt(i)=="\n"){
					stx+="\n";
					c++;
				}else{  
					if(c<activePos){
						activePos--;
					}
				}
			}
			stx+=body.substr(activePos,body.length-activePos);
			_lastStx=stx;
			if(activePos>stx.length)activePos=stx.length;
			
			setButtonStatus(stx.length>0);
			
			//最後の改行後のスペースを削除
			if(_addedSpace){
				textField.replaceText(textField.text.length-1,textField.text.length-1+1,"");
				_addedSpace=false;
			}
			
			
			if(topDiffPoint<activePos){
				var chage:String=stx.substr(topDiffPoint,activePos-topDiffPoint);
				textField.replaceText(topDiffPoint,topDiffPoint,chage);
				textField.setTextFormat(textForamt,topDiffPoint,activePos>textField.text.length?textField.text.length:activePos);
			}
			if(stx.length<textField.text.length){
				c=textField.text.length-stx.length;
				textField.replaceText(activePos,activePos+c,"");
			}
			
			//横のスペース改行処理////////////////////////////////////////////////////////////////////////////////////////////////////
			
			var l:int;
			var s:String;
			var a:Array;
			var cn:int;
			var r:Rectangle
			var w:Number;
			var wMax:Number;
			
			i=0;l=0;
			rightMargin.rightMargin=0;
			while(i>-1){
				i=textField.text.indexOf("\r",l);
				if(i>-1){
					s=textField.text.substr(l,i-l);
				}else{
					s=textField.text.substr(l);
				}
				if(s.length>0)textField.setTextFormat(rightMargin,l,l+1);
				l=i+1;
			}
			i=0;l=0;wMax=0;
			while(i>-1){
				i=textField.text.indexOf("\r",l);
				if(i>-1){
					s=textField.text.substr(l,i-l);
				}else{
					s=textField.text.substr(l);
				}
				if(s.length>0){
					r=textField.getCharBoundaries(l+s.length-1);
					w=r.x+r.width-textField.getCharBoundaries(l).x;
					if(wMax<w)wMax=w;	
					a=s.match(/\s+$/);
					cn=a && a.length>0?a[0].length:0;
					if(cn>0){					
						rightMargin.rightMargin=r.x+r.width-textField.getCharBoundaries(l+s.length-cn).x;
						textField.setTextFormat(rightMargin,l,l+1);
					}
				}			
				l=i+1;
			}
			
			////////////////////////////////////////////////////////////////////
			
			//最後の改行後のスペースを挿入
			if(textField.text.length>0&&textField.text.substr(textField.text.length-1).match(/\n|\r|\n\r|\r\n/)){
				textField.appendText(" ");
				_addedSpace=true;
			}
			////textField　レイアウト/////////////////////////////////////
			
			//テキストサイズ取得
			textField.autoSize=TextFieldAutoSize.LEFT;
			textField.scaleX=textField.scaleY=1.0;
			
			_textDrawArea.x=0;
			_textDrawArea.y=0;
			_textDrawArea.width=wMax;
			
			var lastLine:String=s;
			
			_textDrawArea.height=textField.height-Number(textForamt.size)*0.228;
			
			
			textField.autoSize=TextFieldAutoSize.NONE;
			textField.height+=300;
			textField.width+=300;
			if(_textRect.y/_textDrawArea.height>_textRect.x/_textDrawArea.width){
				texScale=_textRect.x/_textDrawArea.width;
			}else{
				texScale=_textRect.y/_textDrawArea.height;
			}
			
			textField.scaleX=textField.scaleY=texScale;
			texY=(_textRect.y-_textDrawArea.height*texScale)*ALIGN_TOP_RATE-_textDrawArea.y*texScale-Number(textForamt.size)*0.125*texScale;
			switch(textForamt.align){
				case TextFormatAlign.CENTER:
					texX=(_textRect.x-_textDrawArea.width*texScale)*.5 + (_textDrawArea.width*texScale-textField.width)*.5 - _textDrawArea.x*texScale;
					break;
				case TextFormatAlign.RIGHT:
					texX=(_textRect.x-_textDrawArea.width*texScale)*.5 + (_textDrawArea.width*texScale-textField.width) - _textDrawArea.x*texScale;
					break;
				default:
					texX=(_textRect.x-_textDrawArea.width*texScale)*.5-_textDrawArea.x*texScale;
			}
			textField.x=texX;
			textField.y=texY;
			
			
			////////////////////////////////////////////////
			////UPDATE/////////////////////////////////////
			
			onCursorChanged();
			
			if(body!=stx){
				if(UTDeviceCapabilities.isIOS()){
					clearTimeout(mTimer)
					mTimer = setTimeout(function ():void{
						stageText.text=stx;
					},0);
				}else{
					stageText.text=stx;
					stageText.selectRange(activePos,activePos);
				}
			}
		}
		
		private var rightMargin:TextFormat;
		
		private function onCursorChanged():void{
			var p:int=Math.min(activePos,textField.text.length);
			
			if(textField.text.length==0){
				_cursor.x=_textRect.x*.5;
				_cursor.y=_textRect.y;
				_cursor.scaleX=_cursor.scaleY=_textRect.y/Number(textForamt.size);
			}else{
				var fnd:Boolean=false;
				var r:Rectangle=textField.getCharBoundaries(p-1);
				if(r){
					_cursor.x=texX+(r.x+r.width)*texScale;
					_cursor.scaleY=texScale=texScale;
					_cursor.y=texY+(r.y+r.height)*texScale;
					fnd=true;
				}else{
					r=textField.getCharBoundaries(p);
					
					switch(textForamt.align){
						case TextFormatAlign.CENTER:
							_cursor.x=texX+textField.width*.5;
							break;
						case TextFormatAlign.RIGHT:
							_cursor.x=texX+textField.width;
							break;
						default:
							_cursor.x=texX;
					}
					
					if(r){
						if(!(p==textField.text.length-1&&textField.text.substr(textField.text.length-1)==" ")){
							_cursor.x=texX+(r.x)*texScale;
						}
						_cursor.scaleY=texScale=texScale;
						_cursor.y=texY+(r.y+r.height)*texScale;
						fnd=true;
					}else{
						var i:int=p+1;
						while(i<textField.text.length){
							r=textField.getCharBoundaries(i);
							if(r){
								_cursor.scaleY=texScale=texScale;
								_cursor.y=texY+(r.y+r.height-(i-p)*55.8)*texScale ;
								fnd=true;
								break;
							}
							i++
						}
					}
				}
				if(!fnd){
					_cursor.x=_textRect.x*.5;
					_cursor.y=_textRect.y;
					_cursor.scaleX=_cursor.scaleY=_textRect.y/Number(textForamt.size);
				}
			}
			_cursorCnt=0;
		}
		
		private function clickStage(e:MouseEvent):void{
			//trace("clickStage");
			if(!this.keyboard)return;
			dragStage(null);
			stageText.assignFocus();
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,clickStage);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,dragStage);
			_stage.addEventListener(MouseEvent.MOUSE_UP,dragEndStage);
		}
		
		private function dragStage(e:MouseEvent):void{
			if(e!=null&&tween1&&tween1.isPlaying)return;
			var lastActivePos:int=activePos;
			
			var x:Number=textField.mouseX;
			var y:Number=textField.mouseY;
			
			var i:int=-1;//=textField.getCharIndexAtPoint(x,y);
			var r:Rectangle;
			var l:int=textField.text.match(/\r/g).length+1;
			var rh:Number=_textDrawArea.height/(l);
			var c:int;
			var f:int;
			
			for(c=1;c<l;c++)if(c*rh>y)break;		
			l=0;i=-1;
			var d:int;
			for(d=0;d<c;d++){
				l=i==-1?0:i+1;
				i=textField.text.indexOf("\r",l);				
			}
			if(i>-1){
				c=textField.text.substr(l,i-l).length;
			}else{
				c=textField.text.substr(l).length;
			}			
			for(i=0;i<c;i++){
				r=textField.getCharBoundaries(l+i);
				if(x<r.x+r.width)break;
			}
			i=l+i;
			r=textField.getCharBoundaries(i);
			if(r&&Math.abs(r.x-x)>Math.abs(r.x+r.width-x)){
				i++;
			}
			activePos=Math.min(i,stageText.text.length);
			if(lastActivePos!=activePos){
				stageText.selectRange(activePos,activePos);
			}
			onCursorChanged();	
		}
		
		private function dragEndStage(e:MouseEvent):void{
			
			if(!this.keyboard)return;
			dragStage(e);
			stageText.assignFocus();
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,clickStage);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragStage);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,dragEndStage);
		}
		
		private function openingMovCose(e:MouseEvent=null):void{
			_isIntro=false;
			UTUtils.clearTimeout();
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,openingMovCose);
			var _tween1:ITween = BetweenAS3.tween(whiteBack,{ alpha:0},null,0.5,org.libspark.betweenas3.easing.Cubic.easeOut);
			_tween1.play();
			_tween1.onComplete=onStart;
			var _tween2:ITween = BetweenAS3.tween(inst_mov,{ alpha:0},null,0.5,org.libspark.betweenas3.easing.Cubic.easeOut);
			_tween2.play();
		}		
		
		private function keyboardFocusIn(e:FocusEvent):void{
			keyboard=true;
			_activeKeyHeight=_lastKeyHeight;
			clearTimeout(_timer);
			stopMoveListen();
		}
		
		private var _timer:uint; 
		private function keyboardFocusOut(e:FocusEvent):void{
			_timer=setTimeout(function():void{
				keyboard=false;
				_activeKeyHeight=-TYPESET_HEIGHT;
				startMoveListen();
			},100);
		}
		
		private var _lastKeyHeight:Number=0;
		private var _activeKeyHeight:Number=0;
		private var _textDrawArea:Rectangle=new Rectangle;
		private var _footerPanelY:Number;
		private var _toFooterPanelY:Number;
		private var _frFooterPanelY:Number;
		//private var shape:Shape=new Shape;
		
		private var tween1:ITween;
		private var tween2:ITween;
		private var tween3:ITween;
		private var tween4:ITween;
		private var tween5:ITween;
		private var tween6:ITween;
		
		
		private var _isZoom:Boolean;
		private function scaleBtn_TouchUp(e:MouseEvent):void{
			
			if(e!=null){
				if(_isZoom){
					AppSound.playSound(4);
				}else{
					AppSound.playSound(3);
				}
			}
			_isZoom=!_isZoom;
			//trace("scaleBtn_TouchUp",_isZoom);
			if(tween1&&tween1.isPlaying)tween1.stop();
			if(tween2&&tween2.isPlaying)tween2.stop();
			
			scaleBtn.zoomin.visible=!_isZoom;
			scaleBtn.zoomout.visible=_isZoom;
			
			var r:Rectangle= UTItemManager.getZoomRect(_isZoom,_mcWidth,_mcHeight);			
			tween1 = BetweenAS3.tween(_typeT,{ x:r.x,y:r.y,scaleX:r.width/1024,scaleY:r.height/1024},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
			tween1.play();			
		}
		
		private function onChangedkeyboardHeight():void{
			if(tween1&&tween1.isPlaying)tween1.stop();
			if(tween2&&tween2.isPlaying)tween2.stop();
			if(tween3&&tween3.isPlaying)tween3.stop();
			if(tween4&&tween4.isPlaying)tween4.stop();
			if(tween5&&tween5.isPlaying)tween5.stop();
			if(tween6&&tween6.isPlaying)tween6.stop();
			
			
			var h:Number;
			var w:Number;
			var x:Number;
			var y:Number;
			
			
			if(keyboard){
				var keyH:Number=UTDeviceCapabilities.isIOS()?_keyboardY/AppVals.GLOBAL_SCALE:_keyboardY;
				var cHeight:Number=_mcHeight-keyH-TYPESET_HEIGHT;
				var cWidth:Number=_mcWidth*0.8;
				var pWidth:Number;
				var pHeight:Number;
				if(cHeight/UTItemManager.IMAGE_HEIGHT>cWidth/UTItemManager.IMAGE_WIDTH){
					pWidth=cWidth;
					pHeight=pWidth*UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
				}else{
					pHeight=cHeight;
					pWidth=pHeight*UTItemManager.IMAGE_WIDTH/UTItemManager.IMAGE_HEIGHT;
				}
				
				w=pWidth/UTItemManager.wkWidth;
				x=_mcWidth*.5-w*UTItemManager.wkCenter.x;
				y=cHeight*.5-w*UTItemManager.wkCenter.y;
				
				tween1 = BetweenAS3.tween(_typeT,{ x:x,y:y,scaleX:w/1024,scaleY:w/1024},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween1.play();
				
				tween2 = BetweenAS3.tween(typeSet,{ y:calcModalYPos(true)},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween2.play();
				tween3 = BetweenAS3.tween(scaleBtn,{ y:_mcHeight+20},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween3.play();
				
				tween4 = BetweenAS3.tween(okBtn,{ y:-AppVals.STATUSBAR_HEIGHT-okBtn.height-keyBtn.height},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween4.play();
				tween6 = BetweenAS3.tween(keyBtn,{ y:-AppVals.STATUSBAR_HEIGHT-keyBtn.height},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween6.play();
				
				tween5 = BetweenAS3.tween(keyHideBtn,{y:9},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween5.play();
				
				tween1.onComplete=function():void{
					if(stageText)stageText.assignFocus()
				};
			}else{
				
				
				var r:Rectangle= UTItemManager.getZoomRect(_isZoom,_mcWidth,_mcHeight);		
				
				tween1 = BetweenAS3.tween(_typeT,{ x:r.x,y:r.y,scaleX:r.width/1024,scaleY:r.height/1024},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween1.play();
				tween2 = BetweenAS3.tween(typeSet,{ y:_mcHeight},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween2.play();
				tween3 = BetweenAS3.tween(scaleBtn,{ y:_mcHeight-88-20},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween3.play();
				
				tween4 = BetweenAS3.tween(okBtn,{ y:9},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween4.play();
				tween6 = BetweenAS3.tween(keyBtn,{ y:100},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween6.play();
				
				tween5 = BetweenAS3.tween(keyHideBtn,{y:-AppVals.STATUSBAR_HEIGHT-keyHideBtn.height},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
				tween5.play();
				if(_unloadFlg)tween1.onComplete=_unloadCallBack;
				
				var m:MovieClip=this;
				tween5.onComplete=function():void{
					if(stageText&&stageText.text.length>0){
						DragInfoViewController.show(m);
					}
				}
				if(ToolViewController.isOpen)modalCloseAndTrrigers();
			}
		}
		
		private function enterFrame(e:Event):void{
			var v:Number,w:Number;
			var i:int;
			var h:Number=_stage.softKeyboardRect.height;
			if(h>0&&_lastKeyHeight!=h){
				_lastKeyHeight=h;
				_activeKeyHeight=_lastKeyHeight;
			}
			if(_keyboardY!=_activeKeyHeight)	{
				_keyboardY=_activeKeyHeight ;
				onChangedkeyboardHeight();
			}
			if(_lastText!=stageText.text){
				onChangeText(null);
				_lastText=stageText.text;
			}else if(activePos!=stageText.selectionActiveIndex){
				activePos=stageText.selectionActiveIndex;
				onCursorChanged();
			}
			
			
			if(keyboard){
				if(_cursorCnt<30){
					if(!_cursor.visible)_cursor.visible=true;
				}else{
					if(_cursor.visible)_cursor.visible=false;
				}
				_cursorCnt++;
				if(_cursorCnt>60)_cursorCnt=0;
			}else{
				if(_cursor.visible){
					_cursor.visible=false;
					_cursorCnt=0;
				}
			}
		}
		
		public function animationType():String{
			return AnimateType.RIGHT_TO_LEFT;
		}
		
		
		private var _unloadFlg:Boolean;
		private var _unloadCallBack:Function=null;
		
		public function _backBtn_Touchup(e:MouseEvent):void{
			UTUtils.clearTimeout();
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,openingMovCose);
			
			AppMain.setUIIntaractionEnable(false);
			if(stageText!=null){
				stageText.removeEventListener(FocusEvent.FOCUS_IN,keyboardFocusIn);
				stageText.removeEventListener(FocusEvent.FOCUS_OUT,keyboardFocusOut);
			}
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,clickStage);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragStage);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,dragEndStage);
			_activeKeyHeight=-TYPESET_HEIGHT;
			_stage.focus=null;
			if(keyboard){
				keyboard=false;
				_unloadFlg=true;
				_unloadCallBack=UTCreateMain.popBackView;
			}else{
				UTCreateMain.popBackView();
			}
		}
		
		public function _resetBtn_Touchup(e:MouseEvent):void{
			_addedSpace=false;
			stageText.text="";
			onChangeText(null);
			typeWrap.removeChild( textField);
			//typeWrap.scaleX=typeWrap.scaleY=1;
			//typeWrap.rotation=0;
			//typeWrap.graphics.beginFill(0x000000,0.5);
			//typeWrap.graphics.drawRect(0,0,_textRect.x,_textRect.y);
			//typeWrap.graphics.endFill();
			
			//spHelped.init((_areaRect.x-_textRect.x)*.5,(_areaRect.y-_textRect.y)*.5,0,1);
			
			typeWrap.x=(_areaRect.x-_textRect.x)*.5;
			typeWrap.y=(_areaRect.y-_textRect.y)*.5;
			typeWrap.scaleX=typeWrap.scaleY=1;
			typeWrap.rotation=0;
			
			
			//typeWrap.graphics.clear();
			typeWrap.addChildAt( textField,0);
		}
		
		
		private function _okBtn_Touchup(e:MouseEvent):void{
			
			AppMain.setUIIntaractionEnable(false);
			
			if(stageText!=null){
				stageText.removeEventListener(FocusEvent.FOCUS_IN,keyboardFocusIn);
				stageText.removeEventListener(FocusEvent.FOCUS_OUT,keyboardFocusOut);
			}
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,clickStage);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragStage);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,dragEndStage);
			
			_activeKeyHeight=-TYPESET_HEIGHT;
			_stage.focus=null;
			if(keyboard){
				keyboard=false;
				_unloadFlg=true;
				_unloadCallBack=captureAndNext;
			}else{
				captureAndNext();
			}
		}	
		
		private function captureToBmd():void{
			mouseUpHandler(null);
			var _scale:Number
			var _x:Number
			var _y:Number
			_image = null;
			_image = new BitmapData(UTItemManager.IMAGE_WIDTH,UTItemManager.IMAGE_HEIGHT,true,0x00FFFFFF);
			
			if(UTItemManager.IMAGE_HEIGHT/_areaRect.y>UTItemManager.IMAGE_WIDTH/_areaRect.x){
				_scale=(UTItemManager.IMAGE_WIDTH)/_areaRect.x;
			}else{
				_scale=(UTItemManager.IMAGE_HEIGHT)/_areaRect.y;
			}
			
			var m:Matrix=new Matrix;
			m.scale(_scale,_scale);
			
			if(_TopLayer!=null)_TopLayer.visible=false;
			_image.drawWithQuality(captureView ,m,null,null,null,true,StageQuality.HIGH);
			if(_TopLayer!=null)_TopLayer.visible=true;
			
			/////////////////////////////////////////////////
			
			
			if(IMAGE_INNER_HEIGHT/_textDrawArea.height>IMAGE_INNER_WIDTH/_textDrawArea.width){
				_scale=(IMAGE_INNER_WIDTH)/_textDrawArea.width;
			}else{
				_scale=(IMAGE_INNER_HEIGHT)/_textDrawArea.height;
			}
			
			textField.scaleX=textField.scaleY=_scale;
			_y=(IMAGE_INNER_HEIGHT-_textDrawArea.height*_scale)*ALIGN_TOP_RATE-_textDrawArea.y*_scale-Number(textForamt.size)*0.125*_scale+IMAGE_MARGIN_Y;
			
			switch(textForamt.align){
				case TextFormatAlign.CENTER:
					_x=(IMAGE_INNER_WIDTH-_textDrawArea.width*_scale)*.5 + (_textDrawArea.width*_scale-textField.width)*.5 - _textDrawArea.x*_scale;
					break;
				case TextFormatAlign.RIGHT:
					_x=(IMAGE_INNER_WIDTH-_textDrawArea.width*_scale)*.5 + (_textDrawArea.width*_scale-textField.width) - _textDrawArea.x*_scale;
					break;
				default:
					_x=(IMAGE_INNER_WIDTH-_textDrawArea.width*_scale)*.5-_textDrawArea.x*_scale;
			}
			_x+=IMAGE_MARGIN_X;
			
			textField.scaleX=textField.scaleY=texScale;
			htmlText=textField.htmlText;
			
		}
		
		private function captureAndNext():void{
			
			captureToBmd();
			UTCreateMain.navigateViewTo(new NV10_RemixListView);
		}
		
		public function onDeactive():void{
			if(_tfActive){
				removeEventListener(Event.ENTER_FRAME,enterFrame);	
				disposeTextField();
			}
			keyboard=false;
			startMoveListen();
			_activeKeyHeight=-TYPESET_HEIGHT;
		}
		
		public function onActive():void{
			if(_tfActive){
				this.createTextField();
				addEventListener(Event.ENTER_FRAME,enterFrame);	
			}
		}
		
		public function dispose():void{
			if(_image)_image.dispose();
			_image=null;
			if(stageText)stageText.dispose()
			stageText=null;
			_stage=null;
		}
		
		private var _image:BitmapData
		
		public function getPrevLayer():BitmapData{
			if(_image==null)captureToBmd();
			return _image;
		}
		
		public function getImage():BitmapData{
			return UTCreateMain.getParent(this).getImage();
		}
		
		public function save(viewId:int):void{
			if(_image!=null)_image.dispose();
			_image=null;
		}

	}
}

