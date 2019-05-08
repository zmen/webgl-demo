package utme.views.main.srcViews
{
	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import jp.uniqlo.utlab.app.views.UIStampView;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Cubic;
	import org.libspark.betweenas3.tweens.ITween;
	
	import utme.app.AppMain;
	import utme.app.UTCreateMain;
	import utme.app.NSFuncs.UTUtils;
	import utme.app.consts.AppLang;
	import utme.app.consts.AppSound;
	import utme.app.consts.AppURI;
	import utme.app.consts.AppVals;
	import utme.app.managers.FileManager;
	import utme.app.managers.UTItemManager;
	import utme.app.managers.UTStampManager;
	import utme.app.managers.UTTopLayerManager;
	import utme.views.common.VC_AlertView;
	import utme.views.common.VC_ItemSelectView;
	import utme.views.common.VC_ProgressView;
	import utme.views.common.classes.DragInfoViewController;
	import utme.views.common.classes.RectSprite;
	import utme.views.common.classes.UTImageBuilder;
	import utme.views.common.classes.dragger.TouchDraggableHelper;
	import utme.views.main.common.AnimateType;
	import utme.views.main.common.INavigatedView;
	import utme.views.main.menuViews.NV10_RemixListView;
	import utme.views.main.srcViews.stampSubViews.NV56_StampListView;
	import utme.views.main.srcViews.stampSubViews.helpers.StampCopyLightsObject;
	import utme.views.main.srcViews.stampSubViews.helpers.StampViewUtils;
	import utme.views.main.srcViews.stampSubViews.subviews.StampObject;
	
	public class NV05_GraphicStampView extends UIStampView implements INavigatedView
	{
		private var _image:BitmapData;
		private var _bmBase:Bitmap;
		private var testView:Sprite;
		private var startPoint:Point;
		private var standardPoint:Point;
		private var baseWidth:Number;
		private var baseHeight:Number;
		//private var frameRect:Rectangle;
		//private var wrapper:Sprite;
		private var spHelped:TouchDraggableHelper;
		private var photoMask:RectSprite;
		//private var captureView:Sprite
		private var _saveName:String="";
		private var _srcWidth:int;
		private var _srcHeight:int;
		private var touchCount:int = 0
		private var _loaded:Boolean;
		
		
		
		//private var _stampSetData:Object;
		private var _isZoom:Boolean;
		
		//最初のソース選択で選択されている場合、コンストラクタで画像を渡します。
		private var _typeT:Sprite;
		private var captureView:Sprite;
		private var stampManager:UTStampManager;
		
		private var _TopLayer:Bitmap=null;
		private var viewdidLoad:Boolean;
		private var _viewDisposed:Boolean=false;
		private var _checkBmd:BitmapData;
		private var _checkMat:Matrix;
		private var _checkBounds:Rectangle;
		private var _checkScale:Number=0.8*0.5;
		public function NV05_GraphicStampView(manager:UTStampManager)
		{
			super();
			stampManager=manager;
			
			if(stampManager.data.hasOwnProperty("copyright_image_url")&&stampManager.data.copyright_image_url!=null&&String(stampManager.data.copyright_image_url).length>0)
			{
				UTItemManager.IMAGE_HEIGHT = 1880;
			}
			
			UTStampManager.addSet(stampManager);
			
			_typeT=new Sprite;
			addChildAt(_typeT, 0);
			
			_bmBase = new Bitmap();
			_typeT.addChild(_bmBase);
			
			captureView=new Sprite;
			_typeT.addChild(captureView);
			
			photoMask = new RectSprite(1, 1, 0xff0000)
			
			_progressView=new VC_ProgressView(this);
			//frameRect = new Rectangle();
			_isZoom=false;
			_loaded=false;
			footer.scaleBtn.zoomout.visible=_isZoom;
			footer.scaleBtn.zoomin.visible=!_isZoom;
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			
			var w:Number= 512;
			var h:Number= w*UTItemManager.IMAGE_HEIGHT / UTItemManager.IMAGE_WIDTH;

			
			photo_frame.x = 0;
			photo_frame.y = 0;
			photo_frame.width = w;
			photo_frame.height = h;
			
			photoMask.x = 0;
			photoMask.y = 0;
			photoMask.width = w;
			photoMask.height = h;
			
			captureView.addChild(photoMask);
			captureView.addChild(photo_frame);
			
			if(UTTopLayerManager.hasTopLayer()){
				_TopLayer=new Bitmap(UTTopLayerManager.getTopLayerThumbImage(),PixelSnapping.AUTO,true);
				
				captureView.addChild(_TopLayer);
				_TopLayer.x = 0;
				_TopLayer.y = 0;
				_TopLayer.width = w;
				_TopLayer.height = h;
			}
			
			
			spHelped = new TouchDraggableHelper(null, AppVals.stage);
			if(stampManager.LayoutRotationType==2){
				spHelped.rotatable=true;
				spHelped.limitRotateMin=-45;
				spHelped.limitRotateMax=45;
			}else if(stampManager.LayoutRotationType==1){
				spHelped.rotatable=true;
				spHelped.limitRotateMin=0;
				spHelped.limitRotateMax=0;
			}else{
				spHelped.rotatable=false;
			}
			spHelped.limitScaleMin= 0.2*photo_frame.width/UTItemManager.IMAGE_WIDTH*stampManager.ThumbnailScale;
			
			if(stampManager.DisableOutOfBounds){
				spHelped.limitScaleMax= 1.5*photo_frame.width/UTItemManager.IMAGE_WIDTH*stampManager.ThumbnailScale;
			}else{
				spHelped.limitScaleMax= 1.5*photo_frame.width/UTItemManager.IMAGE_WIDTH*stampManager.ThumbnailScale;
			}
			
			deleteIcon.visible=false;
			
			if(!stampManager.HideCopyRight){
				if(stampManager.data.hasOwnProperty("copyright")&&stampManager.data.copyright!=null&&String(stampManager.data.copyright).length>0){
					//trace("HAS COPYLIGHT!",stampManager.data.copyright,stampManager.data.copyright_image_url);
					copyStampSet=new StampCopyLightsObject();
					copyStampSet.initWithData(stampManager.data,true);
				}
			}
			_viewDisposed=false;
			
			_checkBmd=new BitmapData(w,h,true,0);
			_checkMat=new Matrix();
			_checkBounds=new Rectangle((w-w*_checkScale)*.5,(h-h*_checkScale)*.5,w*_checkScale,h*_checkScale);
			_checkMat.scale(_checkScale,_checkScale);
			_checkMat.translate((w-w*_checkScale)*.5,(h-h*_checkScale)*.5);
			
			
		}
		
		private var tween1:ITween;
		private function _scaleBtn_Touchup(e:MouseEvent):void{
			
			if(e!=null){
				if(_isZoom){
					AppSound.playSound(4);
				}else{
					AppSound.playSound(3);
				}
			}
			
			_isZoom=!_isZoom;
			
			if(tween1&&tween1.isPlaying)tween1.stop();
			
			footer.scaleBtn.zoomout.visible=_isZoom;
			footer.scaleBtn.zoomin.visible=!_isZoom;
			
			var r:Rectangle= UTItemManager.getZoomRect(_isZoom,_mcWidth,_mcHeight);			
			tween1 = BetweenAS3.tween(_typeT,{ x:r.x,y:r.y,scaleX:r.width/1024,scaleY:r.height/1024},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
			tween1.play();
		}
		
		private function _stampBtn_Touchup(e:MouseEvent):void{
			UTCreateMain.navigateViewTo(new NV56_StampListView(stampManager,this));
		}
		
		public var stampCacheObject:Object=new Object;
		public var copyCacheObject:Object=new Object;
		public var copyStampSet:StampCopyLightsObject;
		
		public function loadStamp(data:Object):void{
			isLoading=true;
			if(stampManager.DisableMultiStamp&&_stamps.length>0){
				_resetBtn_Touchup(null);
			}
			
			if(stampCacheObject[data.id]){
				//trace("USE LOADED CACHE");
				addStampObject(stampCacheObject[data.id][0],data.id);
			}else{
				var loader:Loader=new Loader;
				var info : LoaderInfo = loader.contentLoaderInfo;
				info.addEventListener (Event.INIT,function(e:Event):void{LoadedThumblData(data,(e.target as LoaderInfo).loader);});
				info.addEventListener(IOErrorEvent.IO_ERROR,errorLoadingData);
				info.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorLoadingData);	
				loader.load(AppURI.getAuthorizedURLRequest(data.stamp_thumbnail_image_url));
				
			}
		}
		
		private function showLoading():void{
			if(!isLoading)return;
			if(_progressView==null)return;
			_progressView.setMode(VC_ProgressView.LOADING,false);
			_progressView.show();
			_progressView.backView.visible=false;
		}
		
		private var isLoading:Boolean;
		private function LoadedThumblData (data:Object,ld:Loader):void {
			if(_viewDisposed)return;
			if(!viewdidLoad){
				setTimeout(function():void{
					LoadedThumblData(data,ld);
				},20);
			}else{
				
				//trace("LoadedThumblData ",data.id);
				var bmd:BitmapData;
				if(stampManager.LayoutFringe){
					var whiteEdgeQuater:GlowFilter = new GlowFilter(stampManager.EdgeColor,1, stampManager.EdgeWidth , stampManager.EdgeWidth , 100 , 4 , false , false );
					var m:Matrix=new Matrix;
					var b:BitmapData=(ld.content as Bitmap).bitmapData;
					ld.filters=[whiteEdgeQuater];
					bmd=new BitmapData(b.width+stampManager.EdgeWidth *4,b.height+stampManager.EdgeWidth*4,true,0);
					m.translate(stampManager.EdgeWidth*2,stampManager.EdgeWidth*2);
					bmd.drawWithQuality(ld,m,null,null,null,true,StageQuality.HIGH);
					b.dispose();
				}else{
					bmd=(ld.content as Bitmap).bitmapData;
				}
				
				stampCacheObject[data.id]=[];
				stampCacheObject[data.id][0]=bmd;
				stampCacheObject[data.id][1]=false;
				addStampObject(stampCacheObject[data.id][0],data.id);
				
				var loader:Loader=new Loader;
				stampCacheObject[data.id][5]=loader;
				var info : LoaderInfo = loader.contentLoaderInfo;
				info.addEventListener(IOErrorEvent.IO_ERROR,errorLoadingData);
				info.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorLoadingData);
				info.addEventListener (Event.INIT,function(e:Event):void{LoadedOriginalData(data);});
				loader.load(AppURI.getAuthorizedURLRequest(data.stamp_image_url));
				trace(data.stamp_image_url);
			}
		}
		
		private function errorLoadingData (e:ErrorEvent):void {
			//trace(e,_viewDisposed);
			if(_viewDisposed){
				//trace("_viewDisposed",_viewDisposed);
				return;
			}
			if(!viewdidLoad){
				setTimeout(function():void{
					errorLoadingData(e);
				},20);
			}else{
				_progressView.hide();
				VC_AlertView.showErrorDialog(true,function():void{
					UTCreateMain.popBackView();
				});
			}
		}
		
		private function LoadedOriginalData (data:Object):void {
			if(_viewDisposed)return;
			if(!viewdidLoad){
				setTimeout(function():void{
					LoadedOriginalData(data);
				},20);
			}else{
				//trace("LoadedOriginalData AND SAVE",data.id );
				var l:Loader=stampCacheObject[data.id][5];
				var b:BitmapData=(l.content as Bitmap).bitmapData;
				stampCacheObject[data.id][1]=true;
				stampCacheObject[data.id][2]=b.width;
				stampCacheObject[data.id][3]=b.height;
				stampCacheObject[data.id][4]="stampCache_"+String(data.id);
				FileManager.saveCache(b,stampCacheObject[data.id][4]);
				b.dispose();
				stampCacheObject[data.id][5]=null;
			}
		}
		
		public var _stamps:Vector.<StampObject>=new Vector.<StampObject>;
		
		private function addStampObject(a:BitmapData,id:String):void{
			
			var bm:StampObject=new StampObject(a,id);
			bm.x=photo_frame.width*.5;
			bm.y=photo_frame.height*.5;
			bm.scaleX=bm.scaleY=0.7 * photo_frame.width/UTItemManager.IMAGE_WIDTH*stampManager.ThumbnailScale; // 60%
			captureView.addChild(bm);
			_stamps.push(bm);
			
			isLoading=false;
			_progressView.hide();
			mouseUpHandler(null);
			
			captureView.addChild(photoMask);
			if(_TopLayer)captureView.addChild(_TopLayer);
			captureView.addChild(photo_frame);
		}
		
		private function changeStageStamps():void{
			stampManager.Ids.length=0;
			for(var i:int=0;i<_stamps.length;i++){
				var s:StampObject= _stamps[i];
				stampManager.Ids.push(s.id);
			}
			stampManager.copyLights.length=0;
			var arr:Array=new Array;
			if(copyStampSet!=null){
				for(i=0;i<_stamps.length;i++){
					if(!copyCacheObject.hasOwnProperty(_stamps[i].id)){
						stampManager.copyLights.push(copyStampSet);
						break;
					}
				}
			}
			
			for(i=0;i<_stamps.length;i++){
				if(copyCacheObject.hasOwnProperty(_stamps[i].id)&&arr.indexOf(_stamps[i].id)==-1){
					arr.push(_stamps[i].id);
					stampManager.copyLights.push(copyCacheObject[_stamps[i].id]);
				}
			}
			
			UTStampManager.createCopyLight();
			
			if(_stamps.length==0&&!isLoading){
				var tw:ITween;
				footer.addStampView.alpha=0;
				footer.addStampView.visible=true;
				tw = BetweenAS3.tween(footer.addStampView,{alpha:1},null,0.5,org.libspark.betweenas3.easing.Cubic.easeOut);
				tw.play();
				spHelped.stopListen();
			}
			
			UTUtils.buttonStatus(okBtn,_stamps.length>0);
			
		}
		
		
		
		
		
		private var _mcWidth:Number;
		private var _mcHeight:Number;
		//Stageのリサイズ時と viewWillAppearの後に呼ばれます。
		public function onResize(aWidth:Number, aHeight:Number):void{
			_mcWidth=aWidth;
			_mcHeight=aHeight;
			footer.y = aHeight
		}
		
		
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
			
			captureView.scaleX=UTItemManager.wkWidth*2;
			captureView.scaleY=UTItemManager.wkWidth*2;
			captureView.x=1024*UTItemManager.wkCenter.x-1024*UTItemManager.wkWidth*.5;
			captureView.y=1024*UTItemManager.wkCenter.y-(1024*UTItemManager.wkWidth/UTItemManager.IMAGE_WIDTH*UTItemManager.IMAGE_HEIGHT)*.5;
			
			
			var bmd:BitmapData = new BitmapData(1024, 1024, false, 0xFFFFFF);
			UTImageBuilder.createPrintedImage(bmd, UTCreateMain.getParent(this).getImage(),UTItemManager.wkMultiply,false,false,false);
			_bmBase.bitmapData = bmd;
			_bmBase.smoothing=true;
			_bmBase.height =1024;
			_bmBase.width =1024
			_bmBase.x=0;
			_bmBase.y=0;
		}
		
		//ビューを表示する前に呼ばれます。
		public function viewWillAppear(isNew:Boolean):void{
			
			_mcWidth=AppVals.stage.stageWidth/AppVals.GLOBAL_SCALE;
			_mcHeight=AppVals.stage.stageHeight/AppVals.GLOBAL_SCALE-AppVals.STATUSBAR_HEIGHT;
			
			if (_image != null){
				_image.dispose();
				_image = null;
			}
			
			if (_bmBase.bitmapData == null)canvasChange();
			photoMask.visible = false
			photo_frame.visible = false;
			footer.addStampView.visible=false;
			UTUtils.buttonStatus(okBtn,_stamps.length>0);
			
			viewdidLoad=false;
		}
		
		
		//ビューが表示された後に呼ばれます。
		public function viewDidAppear():void
		{
			//AppMain.clearFowardStampListView();
			okBtn.addEventListener(MouseEvent.CLICK, _okBtn_Touchup);
			backBtn.addEventListener(MouseEvent.CLICK, _backBtn_Touchup);
			
			footer.stampSelectBtn.addEventListener(MouseEvent.CLICK,_stampBtn_Touchup);
			footer.scaleBtn.addEventListener(MouseEvent.CLICK,_scaleBtn_Touchup);
			
			spHelped.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			spHelped.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			spHelped.addEventListener(MouseEvent.CLICK,mouseClickHandler);	
			spHelped.onChange=dragChanged;
			spHelped.disableTouchDownObjects([okBtn,backBtn,footer.stampSelectBtn,footer.scaleBtn]);
			spHelped.startListen();
			
			AppVals.stage.quality=StageQuality.HIGH;
			changeStageStamps();
			
			if(_stamps.length>0||isLoading){
				if(!_loaded){
					_loaded=true;
					if(!_isZoom)_scaleBtn_Touchup(null)	;
					DragInfoViewController.show(this);
				}
			}
			if(isLoading)setTimeout(showLoading,250);
			viewdidLoad=true;
			
			
			if(!UTStampManager.checkCombinedItem(UTItemManager.currentItem.itemId,UTItemManager.currentItem.id)){
				var arr:Array=UTItemManager.getNames(UTItemManager.currentItem.itemId,UTItemManager.currentItem.id);
				if(arr.length==0){
				}else if(arr.length==1){
					VC_AlertView.showAlert("",AppLang.getString(AppLang.ALERT_STAMP_SELECTION_LIMIT_ITEM,arr[0]),
						Vector.<String>([AppLang.getString(AppLang.ALERT_OK)]),function(id:int):void{
							reloadItem();
						});
				}else{
					VC_AlertView.showAlert("",AppLang.getString(AppLang.ALERT_STAMP_SELECTION_LIMIT_ITEM_AND_COLOR,arr[0],arr[1]),
						Vector.<String>([AppLang.getString(AppLang.ALERT_OK)]),function(id:int):void{
							reloadItem();
						});
				}
			}
		}
		
		private function reloadItem():void{
			UTItemManager.init(function():void{
				UTItemManager.load("0","0",function(result:Boolean):void{
					canvasChange();
					VC_ItemSelectView.refer .updateiconImage(UTItemManager.currentItem.itemId);
				});
			});	
		}
		
		
		private function mouseDownHandler(e:Event):void {
			//trace("mouseDownHandler");
			photoMask.visible = false;
			captureView.mask = null;
			photo_frame.visible = true;
			var i:int=0;
			var found:Boolean=false;
			var b:StampObject;
			var a:StampObject;
			for(i=_stamps.length-1;i>-1;i--){
				b=_stamps[i];
				if(b.hitTestPoint(stage.mouseX,stage.mouseY,true)){
					if(b.BitmapAlphaTest(new Point(stage.mouseX,stage.mouseY))){
						b.selected=true;
						spHelped.initWithView(b);
						a=_stamps.splice(i,1)[0];
						_stamps.push(a);
						a.parent.addChild(a);
						found=true;
						break;				
					}
				};
			}
			for(i=_stamps.length-1;i>-1;i--){
				b=_stamps[i];
				if(b.hitTestPoint(stage.mouseX,stage.mouseY,true)){
					b.selected=true;
					spHelped.initWithView(b);
					a=_stamps.splice(i,1)[0];
					_stamps.push(a);
					a.parent.addChild(a);
					found=true;
					break;				
				};
			}
			
			for(i=0;i<_stamps.length;i++){
				_stamps[i].alpha=1.0;
				_stamps[i].filters=[];
			}
			
			captureView.addChild(photoMask);
			if(_TopLayer)captureView.addChild(_TopLayer);
			captureView.addChild(photo_frame);
		}
		
		private const RAD_INCL:Number=3;
		private function mouseUpHandler(e:Event):void {
			//trace("mouseUpHandler");
			photo_frame.visible = false;
			//_Layer.mask = photoMask;
			//photoMask.visible = true;
			spHelped.initWithView(null);
			var i:int;
			deleteIcon.visible=false;
			
			for(i=0;i<_stamps.length;){
				if(_stamps[i].willDelete){
					var s:StampObject= _stamps.splice(i,1)[0];
					var tw:ITween;
					tw = BetweenAS3.tween(s,{ scaleX:0.01,scaleY:0.01,rotation:s.rotation+15},null,0.3,org.libspark.betweenas3.easing.Cubic.easeOut);
					tw.onComplete=function():void{
						s.parent.removeChild(s);
					}
					tw.play();
				}else{
					_stamps[i].alpha=1.0;
					_stamps[i].filters=[];
					i++
				}
			}
			
			var so:StampObject=null;
			for(i=0;i<_stamps.length;i++){
				if(_stamps[i].selected){
					so=_stamps[i];
					break;
				}
			}
			if(so!=null){
				var rad:Number=so.rotation;
				while(-180>rad)rad+=360;
				while(180<rad)rad-=360;
				if(rad<-180+RAD_INCL || rad>180-RAD_INCL)rad=180;
				if(90-RAD_INCL<rad && rad<90+RAD_INCL)rad=90;
				if(-RAD_INCL<rad && rad<RAD_INCL)rad=0;
				if(-90-RAD_INCL<rad && rad<-90+RAD_INCL)rad=-90;
				so.rotation=rad;
			}
			
			
			if(stampManager.DisableOutOfBounds){
				//はみ出しCHECK
				so=null;
				//////////////////////////////////////////////////////////////////////////
				for(i=0;i<_stamps.length;i++){
					if(_stamps[i].selected){
						so=_stamps[i];
						_stamps[i].visible=true;
					}else{
						_stamps[i].visible=false;
					}
				}
				if(so!=null){
					_checkBmd.fillRect(_checkBmd.rect,0);
					_checkBmd.draw(captureView,_checkMat);
					var r:Rectangle=_checkBmd.getColorBoundsRect(0xFF000000,0x00000000,false);
					if(_checkBounds.containsRect(r)){
						//trace("OK")
					}else{
						AppMain.setUIIntaractionEnable(false);
						//trace("HAMIDASHITERU!")
						var addscale:Number=1;
						if(r.height>_checkBounds.height||r.width>_checkBounds.width){
							if(r.height/_checkBounds.height>r.width/_checkBounds.width){
								addscale=_checkBounds.height/r.height;
							}else{
								addscale=_checkBounds.width/r.width;
							}
						}
						var _x:Number=r.x+(r.width-r.width*addscale)*.5;
						var _y:Number=r.y+(r.height-r.height*addscale)*.5;
						var addX:Number=0;
						var addY:Number=0;
						if(_x<_checkBounds.x)addX=_checkBounds.x-_x;
						else if	(_x+r.width*addscale>_checkBounds.x+_checkBounds.width)addX=_checkBounds.x+_checkBounds.width-(_x+r.width*addscale);				
						if(_y<_checkBounds.y)addY=_checkBounds.y-_y;
						else if	(_y+r.height*addscale>_checkBounds.y+_checkBounds.height)addY=_checkBounds.y+_checkBounds.height-(_y+r.height*addscale);				
						/*
						so.scaleX*=addscale;
						so.scaleY=so.scaleX;
						so.x+=addX/_checkScale;
						so.y+=addY/_checkScale;
						*/
						var tw2:ITween=BetweenAS3.tween(so,{scaleX:so.scaleX*addscale,scaleY:so.scaleX*addscale,x:so.x+addX/_checkScale,y:so.y+addY/_checkScale},null,0.2,org.libspark.betweenas3.easing.Cubic.easeInOut);	
						tw2.onComplete=function():void{AppMain.setUIIntaractionEnable(true);}
						tw2.play();
					}
					
					//_checkBmd.fillRect(_checkBmd.rect,0xFFFF0000);
					//_checkBmd.fillRect(_checkBounds,0xFF0000FF);
					//_checkBmd.draw(_Layer,_checkMat);
					//testBm.bitmapData=_checkBmd;
					//AppVals.stage.addChild(testBm);
				}
			}
			
			for(i=0;i<_stamps.length;i++){
				_stamps[i].selected=false;
				_stamps[i].visible=true;
			}
			
			changeStageStamps();
		}
		
		public static var testBm:Bitmap=new Bitmap
		
		public function dragChanged(view:DisplayObject):void{
			var p:Point=new Point();
			p.x=view.x
			p.y=view.y
			p=captureView.localToGlobal(p);
			
			if(!photoMask.hitTestPoint(p.x,p.y,true)){
				if(!deleteIcon.visible)deleteIcon.visible=true;
				p=globalToLocal(p);
				deleteIcon.x=Math.max(44+10,Math.min( p.x ,_mcWidth-44-10));
				deleteIcon.y=Math.max(deleteIcon.height+10 ,Math.min( p.y-300*view.scaleY ,_mcHeight-10));
				view.alpha=0.4;
				(view as StampObject).willDelete=true;
			}else{
				if(deleteIcon.visible)deleteIcon.visible=false
				view.alpha=1.0;
				(view as StampObject).willDelete=false;
			}
		}
		
		
		private function mouseClickHandler(e:Event):void {
			//trace("mouseClickHandler");
		}
		
		//ビューが閉じる前に呼ばれます。(Disposeではありません)
		public function viewWillDisappear():void{
			
			
			okBtn.removeEventListener(MouseEvent.CLICK, _okBtn_Touchup);
			backBtn.removeEventListener(MouseEvent.CLICK, _backBtn_Touchup);
			
			
			okBtn.removeEventListener(MouseEvent.CLICK, _okBtn_Touchup);
			backBtn.removeEventListener(MouseEvent.CLICK, _backBtn_Touchup);
			
			footer.stampSelectBtn.removeEventListener(MouseEvent.CLICK,_stampBtn_Touchup);
			footer.scaleBtn.removeEventListener(MouseEvent.CLICK,_scaleBtn_Touchup);
			
			if(spHelped!=null){
				spHelped.stopListen();
				spHelped.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
				spHelped.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
				spHelped.removeEventListener(MouseEvent.CLICK,mouseClickHandler);	
			}
			
		}
		
		
		public function viewDidDisappear():void{
			if(_bmBase.bitmapData!=null){
				_bmBase.bitmapData.dispose();
				_bmBase.bitmapData=null;
			}
			
		}
		
		static private var _overLappedFilter:ColorMatrixFilter=new ColorMatrixFilter(new Array(
			1, 0, 0, 0, 0,
			0, 0.5, 0, 0, 0,
			0, 0, 0.5, 0, 0,
			0, 0, 0, 1, 0
		));
		
		//画像を保存する
		
		private function captureToBmd():void{
			mouseUpHandler(null);
			if (_image != null) _image.dispose();
			_image = null;
			
			var scale:Number;
			scale = UTItemManager.IMAGE_WIDTH / photoMask.width;
			_image = new BitmapData(UTItemManager.IMAGE_WIDTH, UTItemManager.IMAGE_HEIGHT,true, 0);
			var _bm:Bitmap=new Bitmap(null,"auto",true);
			var m:Matrix=new Matrix;
			for(var i:int=0;i<_stamps.length;i++){
				var stamp:StampObject=_stamps[i];
				var _bd:BitmapData=FileManager.loadCache(stampCacheObject[stamp.id][4],
					stampCacheObject[stamp.id][2],stampCacheObject[stamp.id][3],true,0);
				
				_bm.bitmapData=_bd;
				_bm.smoothing=true;
				
				scale = UTItemManager.IMAGE_WIDTH / photoMask.width;
				
				var r:Number=stamp.rotation/180.0*Math.PI;
				m.identity();
				m.translate(-_bd.width*.5,-_bd.height*.5);
				m.rotate(r);
				
				m.scale(stamp.scaleX/stampManager.ThumbnailScale*scale,stamp.scaleY/stampManager.ThumbnailScale*scale);	
				m.translate(stamp.x*scale,stamp.y*scale);
				
				if(stampManager.LayoutFringe){
					var whiteEdgeAA:GlowFilter =new GlowFilter(stampManager.EdgeColor,1,2, 2 , 10 , 4 , false , false );
					var whiteEdge2:GlowFilter =new GlowFilter(stampManager.EdgeColor,1,stampManager.EdgeWidth*stamp.scaleX*scale, stampManager.EdgeWidth*stamp.scaleX*scale , 300 , 4 , false , false );
					_bm.filters=[whiteEdge2,whiteEdgeAA];
					_image.drawWithQuality(_bm,m, null, null, null, true,StageQuality.HIGH);
				}else{
					_image.drawWithQuality(_bd,m, null, null, null, true,StageQuality.HIGH);
				}
				
				_bd.dispose();
				_bd=null;
			}
		}
		
		//画像取得完了 _image に現在のBitmapDataをレンダリングして NV10_RemixView をコール
		private function _okBtn_Touchup(e:MouseEvent):void{
			var i:int;
			if(stampManager.LayoutOverLapType>0){
				var overLapIDs:Array=StampViewUtils.stampCollitsion(_stamps,stampManager.LayoutOverLapType==1);
				if(overLapIDs.length>0){
					for(i=0;i<_stamps.length;i++){
						if(overLapIDs.indexOf(i)>-1)_stamps[i].filters=[_overLappedFilter];
					}
					VC_AlertView.showAlert(
						AppLang.getString(AppLang.ALERT_STAMPDISABLE_OVERLAP_MESSAGE),
						AppLang.getString(AppLang.ALERT_STAMPDISABLE_OVERLAP_TITLE),
						Vector.<String>[AppLang.getString(AppLang.ALERT_OK)],
						function(i:int):void{});		
					return ;
				}
			}
			
			//AppMain.setUIIntaractionEnable(false);
			spHelped.stopListen();
			okBtn.mouseEnabled=false;
			
			timer=setTimeout(showProgressView,500);
			stopDownloading=false;
			checkDownloadData();
		}
		
		private function showProgressView():void{
			
			_progressView.setMode(VC_ProgressView.DONWLOADING,true);
			_progressView.show();
			_progressView.backView.visible=true;
			_progressView.addEventListener(Event.CANCEL,onCansel);
		}
		
		private function onCansel(e:Event):void{
			stopDownloading=true;
			_progressView.hide();
			spHelped.startListen();
			okBtn.mouseEnabled=true;
		}
		
		private var _progressView:VC_ProgressView=null;
		private var timer:uint=0;
		private var stopDownloading:Boolean=false;
		private function checkDownloadData():void{
			if(stopDownloading)return;
			if(_viewDisposed)return;
			var ngFound:Boolean=false;
			var totalBytes:Number=0;
			var loadBytes:Number=0;
			var loader:Loader;
			for(var i:int=0;i<_stamps.length;i++){
				var stamp:StampObject=_stamps[i];
				if(!stampCacheObject[stamp.id][1]){
					loader=stampCacheObject[stamp.id][5];
					if(loader!=null){
						var t:Number=Number( loader.contentLoaderInfo .bytesTotal)||0;
						loadBytes += t==0 ? 0 : loader.contentLoaderInfo.bytesLoaded  /t;
					}
					ngFound=true;
				}else{
					loadBytes+=100;
				}
				totalBytes+=100;
			}
			
			for(var key:String in copyCacheObject){
				var co:StampCopyLightsObject=copyCacheObject[key];
				if(!co.loaded )ngFound=true;
				else loadBytes+=100;
				totalBytes+=100;
			}
			//trace("DATA PROGRESS=",(loadBytes/totalBytes)*100);
			if(ngFound){
				//trace(">>>>>>>>  DOWNLOADING STAMP LARGE IMAGE..." );
				setTimeout(checkDownloadData,100);
				
			}else{
				spHelped.startListen();
				okBtn.mouseEnabled=true;
				
				clearTimeout(timer);
				captureToBmd();
				//AppMain.setUIIntaractionEnable(true);
				UTCreateMain.navigateViewTo(new NV10_RemixListView);
				NV56_StampListView.clearCaches();
				if(_progressView){
					_progressView.hideWithoutFade();	
				}
			}
		}
		
		
		
		public function _backBtn_Touchup(e:MouseEvent):void{
			UTCreateMain.popBackView();		
		}
		
		public function _resetBtn_Touchup(e:MouseEvent):void{
			for(var i:int=0;i<_stamps.length;i++){
				var s:StampObject= _stamps[i];
				s.parent.removeChild(s);
			}
			_stamps.length=0;
			changeStageStamps();
		}	
		
		
		
		
		public function onDeactive():void{
		}
		
		public function onActive():void{
		}
		
		//クラス破棄
		public function dispose():void
		{
			_viewDisposed=true;
			//trace("STAMP VIEW DISPOSE");
			if (spHelped){
				spHelped.dispose()
				spHelped = null
			}
			
			if (photoMask && photoMask.parent) photoMask.parent.removeChild(photoMask)
			photoMask = null
			
			_image = null;
			_bmBase = null;
			
			UTStampManager.removeSet();
			NV56_StampListView.clearCaches();	
			_progressView.dispose();
			_progressView=null;
			UTItemManager.IMAGE_HEIGHT = 2304;
		}
		
		//Veiwのアニメーションタイプを返します。
		public function animationType():String
		{
			return AnimateType.RIGHT_TO_LEFT;
		}
		
		//この関数で外部から参照されます
		public function getPrevLayer():BitmapData
		{
			if(_image==null){
				captureToBmd();
			}
			return _image;
		}
		
		public function getImage():BitmapData
		{
			return UTCreateMain.getParent(this).getImage();
		}
		
		public function save(viewId:int):void{
			if(_image!=null)_image.dispose();
			_image=null;
		}

	}
}