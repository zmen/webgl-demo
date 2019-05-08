package utme.views.main.stage3d{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.StageQuality;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import utme.app.UTCreateMain;
	import utme.app.consts.AppStoryDefs;
	import utme.app.consts.AppVals;
	import utme.app.managers.FileManager;
	import utme.app.managers.UTItemManager;
	import utme.app.managers.UTStampManager;
	import utme.app.managers.UTStorageManager;
	import utme.views.main.srcViews.NV03_GraphicTypographyView;
	import utme.views.main.srcViews.NV05_GraphicStampView;
	import utme.views.main.srcViews.stampSubViews.subviews.StampObject;
	import utme.views.main.stage3d.helpers.Stage3DHelper;
	import utme.views.main.stage3d.helpers.AutoLayout.LayoutObject;
	import utme.views.main.stage3d.helpers.AutoLayout.LayoutPericleGenelator;
	import utme.views.main.stage3d.helpers.AutoLayout.perticleObject;
	
	public class V3D14_LayoutImpl extends V3D19_RemixBaseImpl{
		
		private var layouts:Vector.<LayoutObject>=new Vector.<LayoutObject>;
		private var perticles:Vector.<perticleObject>=new Vector.<perticleObject>;
		private var textField:TextField
		private var _stampView:NV05_GraphicStampView;
		
		public function V3D14_LayoutImpl(_weakMode:Boolean){	
			super(true,_weakMode);
			//投影位移和缩放规模
			projectionMatrix = new Matrix3D();			
			projectionMatrix.appendTranslation(-UTItemManager.IMAGE_WIDTH*.5,-UTItemManager.IMAGE_HEIGHT*.5,0);
			projectionMatrix.appendScale(1.0/(UTItemManager.IMAGE_WIDTH*.5), -1.0/(UTItemManager.IMAGE_HEIGHT*.5), 1);
			
			srcViewId=UTCreateMain.getActiveSrcType();
			
			if(srcViewId==AppStoryDefs.VIEW_SRC_TYPO){   //如果是文字
				//_typeObject=(AppMain.getActiveSrcView() as NV03_TypographyView).typeObject;
				texts=(UTCreateMain.getActiveSrcView() as NV03_GraphicTypographyView).htmlText .split("</TEXTFORMAT>");
				for(var i:int=0;i<texts.length;i++)texts[i]+="</TEXTFORMAT>";
				texts.pop();
				textField=NV03_GraphicTypographyView.createRenderTextField();
			}if(srcViewId==AppStoryDefs.VIEW_SRC_STAMP){   //如果是stamp
				_stampView=(UTCreateMain.getActiveSrcView() as NV05_GraphicStampView);
			}
			_step=0;
		}

		private var _srcBmd:BitmapData;
		//private var _typeObject:TypeObject=null;
		private var _isMotion:Boolean;
		
		private var srcViewId:int;
		public override function initWithData(backBmd:BitmapData,srcBmd:BitmapData):void{
			_srcBmd=srcBmd;
			super.init3D(backBmd,null);
			LayoutPericleGenelator._step=_step;
		}
		private var _step:Number;
		public override function dispose():void{
			//Stage3D関連オブジェクトを削除//删除相关对象
			_step=LayoutPericleGenelator._step;

			super.dispose();
		}
		private var texts:Array
		private var typeMainLayouts:LayoutObject;

		private var mainTexture:Texture;
		private var projectionMatrix:Matrix3D;
		
		static private var bm:Bitmap=new Bitmap;
		
		protected override function setup():void{
			mFBO.dispose();
			mFBO= mCtx3D.createTexture(AppVals.TEXTURE_WIDTH/2 , AppVals.TEXTURE_WIDTH/2,Context3DTextureFormat.BGRA,true);
			
			var i:int, j:int;
			for(i=0;i<layouts.length;i++)layouts[i].dispose();//清除原有的布局
			layouts.length=0;
			//var tmp:BitmapData=new BitmapData(2048,2048,true,0xffff0000);
			//tex=Stage3DHelper.uploadTexture(mCtx3D,tmp,Context3DTextureFormat.BGRA,true,true);
			var rect:Rectangle;
			var m:Matrix=new Matrix();
			var canvas:BitmapData;
			var bmd:BitmapData;
			var _drawX:Number=0;
			var _drawY:Number=0;
			var m2:Matrix=new Matrix;
			var lo:LayoutObject;//布局对象
			var col:int=0;
			var _bmd:BitmapData;
			var s2:Number;
			var scale:Number;
			canvas=new BitmapData(700,700,true,0);
			if(srcViewId==AppStoryDefs.VIEW_SRC_TYPO||srcViewId==AppStoryDefs.VIEW_SRC_STAMP){//如果是文字或者stamp
			
				bmd=new BitmapData(AppVals.TEXTURE_WIDTH,AppVals.TEXTURE_WIDTH,true,0);
				if(srcViewId==AppStoryDefs.VIEW_SRC_TYPO){//如果是文字
					for(i=0;i<texts.length;i++){//对所有行文字
						textField.htmlText=texts[i];//每行文字内容
						textField.autoSize=TextFieldAutoSize.LEFT;//靠左自动大小
						textField.scaleX=textField.scaleY=1.0;//宽度和高度缩放比例
						var wid:Number=textField.width;//每行文字的宽度
						var hei:Number=textField.height;//每行文字的高度
						var wFlg:Boolean;
						var x:Number;
						var y:Number;
						wFlg=textField.width>textField.height;//每行文字扁平为1，竖直为0；
						scale=wFlg? 500/textField.width:500/textField.height;//根据每行文字扁平或者竖直调整scale缩放函数
						m.identity()
						m.scale(scale,scale);//根据scale缩放文字图像
						x=(700-textField.width*scale)*.5;//水平位移量
						y=(700-textField.height*scale)*.5;//垂直位移量
						m.translate(x,y);//将文字图像显示在当前位移量位置
						
						canvas.fillRect(canvas.rect,0);
						canvas.drawWithQuality(textField,m,null,null,null,true,StageQuality.HIGH);//在新的位置显示文字
						rect=canvas.getColorBoundsRect(0xFF000000,0x00000000,false);//rect是对字符图像的抠图矩形
						
						if(rect&&rect.width>0&&rect.height>0){//如果有内容显示，非全白
							if(_drawY+rect.height>AppVals.TEXTURE_WIDTH){//如果文字行显示超过范围（正方形区域)
								col++;//多增加一列文字
								if(col>3){//最多增加到三列，否则提醒
									trace("SORRY,OVER THE TEXTURE!!!",layouts.length);
									break;
								}
								//则将超出的部分显示在第一行右侧（+512）
								_drawY=0;
								_drawX+=512;
							}
							m2.identity()
							m2.scale(scale,scale);
							//无论是否有右侧多的部分，如果有右侧部分，只显示右侧部分
							m2.translate(x-rect.x+_drawX,y-rect.y+_drawY);//重新调整水平和垂直位移量

							bmd.drawWithQuality(textField,m2,null,null,null,true,StageQuality.HIGH);//显示新布局的图像
							lo=new LayoutObject;
							lo.setup(mCtx3D,mIndicies,projectionMatrix);
							lo.textIndex=i;
							lo.setRectangleType(rect,_drawX,_drawY,1.0/scale);
							lo.orgX=(x-rect.x-rect.width*.5)/scale;
							lo.orgY=(y-rect.y-rect.height*.5)/scale;
							
							layouts.push(lo);//新的布局压栈
							_drawY+=rect.height+2;//ちょっと隙間空けとく//留出一点儿空隙
						}
					}
					
				}else if(srcViewId==AppStoryDefs.VIEW_SRC_STAMP){	
					var _stamps:Vector.<StampObject>=_stampView._stamps;
					for(i=0;i<_stamps.length;i++){
						//未登録
						var bm:BitmapData=_stamps[i].contents.bitmapData;
						canvas.fillRect(canvas.rect,0);
						scale=1.0//缩放比例为1
						m.identity();
						if(bm.width>512||bm.height>512){
							scale = bm.width>bm.height?512.0/bm.width:512.0/bm.height;根据stamp的高度和宽度调整缩放比例
						}
						m.scale(scale,scale);
						canvas.draw(bm,m,null,null,null,true);
						rect=canvas.getColorBoundsRect(0xFF000000,0x00000000,false);
						if(rect&&rect.width>0&&rect.height>0){
							if(_drawY+rect.height>AppVals.TEXTURE_WIDTH){
								col++;
								if(col>3){
									trace("SORRY,OVER THE TEXTURE!!!",layouts.length);
									break;
								}
								_drawY=0;
								_drawX+=512;
							}
							m2.identity()
							m2.scale(scale,scale);
							m2.translate(-rect.x+_drawX,-rect.y+_drawY);
							bmd.draw(bm,m2,null,null,null,true);
							lo=new LayoutObject;
							lo.setup(mCtx3D,mIndicies,projectionMatrix);
							lo.textIndex=i;
							lo.setRectangleType(rect,_drawX,_drawY,1.0/scale);
							lo.orgX=(rect.x-rect.width*.5)/scale;
							lo.orgY=(rect.y-rect.height*.5)/scale;
							lo.stampID=_stamps[i].id;
							layouts.push(lo);
							_drawY+=rect.height+2;//ちょっと隙間空けとく//留出点儿空隙
						}
					}
				}
				mainTexture=Stage3DHelper.uploadTexture(mCtx3D,bmd,Context3DTextureFormat.BGRA,true,true);
				for(i=0;i<layouts.length;i++){
					if(layouts[i].texture==null)layouts[i].setTexture(mainTexture);
				}
			}else{    //如果不是文字和stamp
				if(_srcBmd.width==AppVals.TEXTURE_WIDTH&&_srcBmd.height==AppVals.TEXTURE_WIDTH){
					mainTexture=Stage3DHelper.uploadTexture(mCtx3D,_srcBmd,Context3DTextureFormat.BGRA,true,false);
				}else{
					_bmd=new BitmapData(AppVals.TEXTURE_WIDTH,AppVals.TEXTURE_WIDTH,true,0);
					m.scale(_bmd.width/_srcBmd.width,_bmd.height/_srcBmd.height);
					_bmd.draw(_srcBmd,m,null,null,null,true);
					mainTexture=Stage3DHelper.uploadTexture(mCtx3D,_bmd,Context3DTextureFormat.BGRA,true,true);
				}	
				rect=_srcBmd.getColorBoundsRect(0xFF000000,0x00000000,false)  //抠图图像区域
				var lo2:LayoutObject=new LayoutObject
				lo2.setup(mCtx3D,mIndicies,projectionMatrix);
				lo2.setRectangle(rect,1);
				lo2.setTexture(mainTexture);
				layouts.push(lo2);
			}
			
			/////////////////////////////////////////////////////////////////////////////////初期イメージ//初期图像
			scale=canvas.width/Math.max(UTItemManager.IMAGE_WIDTH,UTItemManager.IMAGE_HEIGHT)
			m.identity();
			m.scale(scale,scale);
			canvas.fillRect(canvas.rect,0);
			canvas.draw(_srcBmd,m,null,null,null,true);				
			rect=canvas.getColorBoundsRect(0xFF000000,0x00000000,false);
			_bmd=new BitmapData(512,512,true,0);
			s2=512/Math.max(rect.width,rect.height);
			m.identity();
			m.scale(scale,scale);
			m.translate(-rect.x,-rect.y);
			m.scale(s2,s2);
			_bmd.draw(_srcBmd,m,null,null,null,true);
			rect.width=rect.width*s2*4;
			rect.height=rect.height*s2*4;
			s2=1/(scale*s2*4);
			typeMainLayouts=new LayoutObject;
			typeMainLayouts.setup(mCtx3D,mIndicies,projectionMatrix);
			typeMainLayouts.setRectangleType(rect,0,0,s2);
			typeMainLayouts.setTexture(Stage3DHelper.uploadTexture(mCtx3D,_bmd,Context3DTextureFormat.BGRA,true,true));
			typeMainLayouts.x=rect.width*.5*s2+rect.x/scale;
			typeMainLayouts.y=rect.height*.5*s2+rect.y/scale;
			
			if(perticles.length>0&&_isMotion){
				trace("restore perticle layouts");
				for(i=0;i<perticles.length;i++){
					perticles[i].updateLayoutObject(layouts[perticles[i].index]);
				}
			}else{
				clear();
			}
		}
				
		protected override function draw():void{ //显示产生的多个图像
			var i:int;
			//mCtx3D.clear(0,0,1,1);
			mCtx3D.clear(0,0,0,0);
			for(i=0;i<perticles.length;i++){
				perticles[i].draw();
				perticles[i].dumpingForce=force;
			}
			force*=0.95;
		}
		
		private var counter:int;
		private var force:Number;
		
		protected override function addedForce(_x:Number,_y:Number):void{   //当手机晃动或划动时
			if(force<0.3)counter=51;
			force=1;
			counter++;
			if( counter>10 ){
				_isMotion=true;
				
				//perticles.length=0;	
				var num:int=perticles.length;
				for(var i:int=0;i<num;){
					if(perticles[i].willDelete){
						perticles.splice(i,1);
						num--;
					}else{
						perticles[i].willDelete=true;
						i++;
					}
				}
				LayoutPericleGenelator.generateLayout(perticles,layouts,srcViewId==AppStoryDefs.VIEW_SRC_TYPO,weakMode);
				//根据图像类型，晃动时，产生多个图像图层
				//这个方法里，有摇动时，产生多个图像的方法；
				counter=0;
			}
			
			for(i=0;i<num;){  //对不需要显示的图层，进行删除
				if(perticles[i].willDelete){
					perticles.splice(i,1);
					num--;
				}else{
					i++;
				}
			}
		}
		
		public override function captureToBitmap(bmd:BitmapData):void{
			var btmap:BitmapData;
			var m:Matrix;
			var bmode:String;
			
			if(srcViewId==AppStoryDefs.VIEW_SRC_TYPO||srcViewId==AppStoryDefs.VIEW_SRC_STAMP){
				if(_isMotion){
					var i:int;
					var po:perticleObject;
					var lo:LayoutObject;
					var num:int=perticles.length;
					m=new Matrix;
					btmap=new BitmapData(UTItemManager.IMAGE_WIDTH,UTItemManager.IMAGE_HEIGHT,true,0);
					if(srcViewId==AppStoryDefs.VIEW_SRC_TYPO){//如果是文字，根据perticles每个文字行，进行不同位置显示
						for(i=0;i<perticles.length;i++){
							po=perticles[i];
							m.identity();
							lo=layouts[po.index];
							textField.htmlText=texts[lo.textIndex];
							m.translate(lo.orgX,lo.orgY);
							m.rotate(po._angle);
							m.scale(po._scale,po._scale);
							m.translate(po._x,po._y);
							btmap.drawWithQuality(textField,m,null,null,null,true,StageQuality.HIGH);
						}
					}else{
						//スタンプDRAW//stampDRAW
				
						var scale:Number;
						var _bm:Bitmap=new Bitmap(null,"auto",true);
						var stampManager:UTStampManager=UTStampManager.getActive();
						var stampCacheObject:Object=_stampView.stampCacheObject;
						
						var _bd:BitmapData=null;
						
						for(var j:int=0;j<layouts.length;j++){
							lo=layouts[j];	
							for(i=0;i<perticles.length;i++){
								po=perticles[i];
								if(po.index!=j)continue;
								
								var useThumb:Boolean=po._scale<0.5;
								var _mbd:BitmapData;
								var _thumbScale:Number=0;
								if(useThumb){
									var _stamps:Vector.<StampObject>=_stampView._stamps;
									_mbd=stampCacheObject[lo.stampID][0];
									_thumbScale=1.0;
								}else{
									if(_bd==null)_bd=FileManager.loadCache(stampCacheObject[lo.stampID][4],stampCacheObject[lo.stampID][2],stampCacheObject[lo.stampID][3],true,0);
									_mbd=_bd;
									_thumbScale=stampManager.ThumbnailScale;
								}
								_bm.bitmapData=_mbd;
								_bm.smoothing=true;
								
								scale = 1;//AppVals.IMAGE_WIDTH / photoMask.width;
								
								var stampScale:Number=po._scale;
								
								var r:Number=lo.angle;
								m.identity();
								m.translate(-_mbd.width*.5,-_mbd.height*.5);
								m.rotate(po._angle);
								
								m.scale(stampScale/_thumbScale*scale,stampScale/_thumbScale*scale);	
								m.translate(po._x,po._y);
								
								if(stampManager.LayoutFringe){
									var whiteEdgeAA:GlowFilter =new GlowFilter(stampManager.EdgeColor,1,2, 2 , 10 , 4 , false , false );
									var whiteEdge2:GlowFilter =new GlowFilter(stampManager.EdgeColor,1,stampManager.EdgeWidth*stampScale*scale, stampManager.EdgeWidth*stampScale*scale , 300 , 4 , false , false );
									_bm.filters=[whiteEdge2,whiteEdgeAA];
									btmap.drawWithQuality(_bm,m, null, null, null, true,StageQuality.HIGH);
								}else{
									btmap.drawWithQuality(_mbd,m, null, null, null, true,StageQuality.HIGH);
								}
							}
							if(_bd!=null)_bd.dispose();
							_bd=null;
						}
						
						
					}
				}else{
					btmap=_srcBmd;
				}
				
				if(blendMode==BlendMode.ERASE){
					mFBO.dispose();
					mFBO= mCtx3D.createTexture(AppVals.TEXTURE_WIDTH , AppVals.TEXTURE_WIDTH,Context3DTextureFormat.BGRA,true);
					
					mCtx3D.setRenderToTexture(mFBO,false,4);
					mCtx3D.clear(0,0,0,0);
					mUniformMatrix[0] = 0;
					mUniformMatrix[1] = 0;
					mUniformMatrix[2] = 0;
					mUniformMatrix[3] = 1024;
					mUniformColor[0] = 1;
					mUniformColor[1] = 1;
					mUniformColor[2] = 1;
					var mainTexture:Texture;
					if(btmap.width==AppVals.TEXTURE_WIDTH&&btmap.height==AppVals.TEXTURE_WIDTH){
						mainTexture = Stage3DHelper.uploadTexture(mCtx3D,btmap,Context3DTextureFormat.BGRA,false,false);
					}else{
						var _bmd:BitmapData=new BitmapData(AppVals.TEXTURE_WIDTH,AppVals.TEXTURE_WIDTH,true,0);
						m=new Matrix;
						m.scale(_bmd.width/btmap.width,_bmd.height/btmap.height);
						_bmd.draw(btmap,m,null,null,null,true);
						mainTexture = Stage3DHelper.uploadTexture(mCtx3D,_bmd,Context3DTextureFormat.BGRA,false,false);
					}
					mCtx3D.setProgram(mNoMipShader);
					Stage3DHelper.drawTriangles(mCtx3D,mIndicies,mDisplayFboMatrix,mainTexture,mVerts,mCoords,mUniformMatrix,mUniformColor);
					mCtx3D.setProgram(mMipShader);
					super.captureToBitmap(bmd);
				}else{
					if(_bmdBackImage!=null&&!UTStampManager.getActiveLayerTop())bmd.copyPixels(_bmdBackImage,_bmdBackImage.rect,new Point(0,0));
					bmode=blendMode==BlendMode.ALPHA?null:blendMode;
					var ct:ColorTransform=blendMode==BlendMode.ALPHA? new ColorTransform(1,1,1,0.6):null;
					bmd.draw(btmap,null,ct,bmode);
				}
				if(_isMotion)btmap.dispose();
			}else{
				if(_isMotion||blendMode==BlendMode.ERASE){
					super.captureToBitmap(bmd);
				}else{
					if(_bmdBackImage!=null&&!UTStampManager.getActiveLayerTop())bmd.copyPixels(_bmdBackImage,_bmdBackImage.rect,new Point(0,0));
					bmode=blendMode==BlendMode.ALPHA?null:blendMode;
					var _ct:ColorTransform=blendMode==BlendMode.ALPHA? new ColorTransform(1,1,1,0.6):null;
					bmd.draw(_srcBmd,null,_ct,bmode);
				}
			}
		}		
		
		public override function clear():void{
			LayoutPericleGenelator.layoutReset();
			trace("clear");
			_isMotion=false;
			counter=0;
			force=1;
			perticles.length=0;
			var i:int;
			var po:perticleObject;
			
			po=new perticleObject(typeMainLayouts,-1);
			po.willDelete=false;
			po.setPositon(typeMainLayouts.x,typeMainLayouts.y,typeMainLayouts.scale,typeMainLayouts.angle);
			perticles.push(po);
		}	
		
	}	
	

}
