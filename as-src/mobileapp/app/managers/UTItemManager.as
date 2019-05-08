package utme.app.managers
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jp.uniqlo.utlab.assets.images.baseT_1024;
	
	import utme.app.NSFuncs.UTCapabilities;
	
	public class UTItemManager{
		
		static public var items:Object;
		static public var currentItem:Object;
		static private var _callbackFunction:Function;
		static public var enableList:Boolean=false;
		static public var itemCount:int;
		
		static public function init(callback:Function):void{
			_callbackFunction=callback;
			var f:File=FileManager.getAssetsDir().resolvePath("list.json");
			var r:String=FileManager.loadText(f);
			if(r.length==0){
				errorLoading();
				return;
			}
			try{
				items = JSON.parse(r).items;		
				itemCount=0;
				for(var i:int=0;i< items.length;i++){
					for(var ii:int=0;ii< items[i].colors.length;ii++){
						itemCount++;
					}
				}
				enableList=itemCount>1;
				trace("ITEM LIST LOADED... NUM:",itemCount,"ENABLE LIST:",enableList);
				callbackFunction(true);
			}catch(e:Error){
				trace(e);
				errorLoading();
			}
		}
		
		static private function callbackFunction(result:Boolean):void{
			if(_callbackFunction!=null){
				var f:Function=_callbackFunction;
				_callbackFunction=null;
				f(result);
				f=null;
			}
		}
		
		
		static public function getNames(itemCode:String,colorCode:String):Array{
			var arr:Array=[];
			if(items!=null){
				for(var i:int=0;i< items.length;i++){
					if(items[i].id==itemCode){
						if(items[i].name.hasOwnProperty(UTCapabilities.getLangCode())){
							arr.push(String(items[i].name[UTCapabilities.getLangCode()]));
						
						}else{
							arr.push(String(items[i].name["en"]));
						
						}
						
						if(items[i].colors.length>1){
							for(var ii:int=0;ii< items[i].colors.length;ii++){
								if(items[i].colors[ii].id==colorCode){
									arr.push(String(items[i].colors[ii].name));
									break;
								}
							}
						}
						break;
					}
				}
			}
			return arr;
		}
		
		static public function getItemInf(itemCode:String,colorId:String):Object{
			var r:Object=null;
			if(items==null){
				r=new Object;
				r["id"]="000000";
				r["itemId"]="000000";
				return r;
			}
			for(var i:int=0;i< items.length;i++){
				if(items[i].id==itemCode){
					for(var ii:int=0;ii< items[i].colors.length;ii++){
						if(items[i].colors[ii].id==colorId){
							r=items[i].colors[ii];
							r["itemId"]=items[i].id;
							break;
						}
					}
					if(r==null){
						r=items[i].colors[0];
						r["itemId"]=items[i].id;
					}
					break;
				}
			}
			if(r==null){
				r=new Object;
				r=items[0].colors[0];
				r["itemId"]=items[0].id;
			}
			return r;
		}
		
		static public function getColorCodes(itemCode:String):Array{
			var arr:Array=[];
			if(items!=null){
				for(var i:int=0;i< items.length;i++){
					if(items[i].id==itemCode){
						for(var ii:int=0;ii< items[i].colors.length;ii++){
							arr.push(String(items[i].colors[ii].id));
						}
						break;
					}
				}
			}
			return arr;
		}
		
		
		static public function writeCanvasById(bmd:BitmapData,itemCode:String,colorCode:String):void{
			trace("LOADING CANVAS",itemCode);
			var desingItem:Object;
			var itemInf:Object=getItemInf(itemCode,colorCode);
			if(itemInf.hasOwnProperty("complete_layout")&&itemInf.complete_layout!=null){
				desingItem=itemInf.complete_layout;
			}else{
				desingItem=itemInf.design_layout;
			}
			
			var f:File=FileManager.getAssetsDir().resolvePath("images/"+encodeURIComponent(desingItem.image));
			
			FileManager.loadImageFromAppLocalPng(f,function(result:Boolean,upBmd:BitmapData):void{
				if(result){
					write(upBmd,bmd);
				}else{
					write(new  baseT_1024,bmd);
				}		
			});
			
			function write(src:BitmapData,dst:BitmapData):void{
				var m:Matrix=new Matrix
				m.scale(dst.width/src.width,dst.height/src.height);
				dst.draw(src,m,null,null,null,true);	
			}
		}
		
		static public function makeCanvas(bmd:BitmapData,itemCode:String,colorCode:String,callBack:Function):void{
			trace("LOADING CANVAS",itemCode);
			var desingItem:Object;
			var itemInf:Object=getItemInf(itemCode,colorCode);
			if(itemInf.hasOwnProperty("complete_layout")&&itemInf.complete_layout!=null){
				desingItem=itemInf.complete_layout;
			}else{
				desingItem=itemInf.design_layout;
			}
			trace(Dumper.toString(itemInf));
			var f:File=FileManager.getAssetsDir().resolvePath("images/"+encodeURIComponent(desingItem.image));
			
			FileManager.loadImageFromAppLocalPng(f,function(result:Boolean,upBmd:BitmapData):void{
				if(result){
					write(upBmd,bmd);
				}else{
					write(new  baseT_1024,bmd);
				}		
			});
			
			function write(src:BitmapData,dst:BitmapData):void{
				var m:Matrix=new Matrix
				m.scale(dst.width/src.width,dst.height/src.height);
				dst.draw(src,m,null,null,null,true);	
				callBack();
			}
		}
		
		
		static public function load(itemCode:String,colorCode:String,callBack:Function):void{
			_callbackFunction=callBack;
			
			try{
				
				currentItem=null;
				
				if(itemCount==0){
					currentItem={};
					currentItem["itemId"]="ITEM_UNDEFINED";
					currentItem["id"]="COLOR_UNDEFINED";
					errorLoading();
					return;
				}
				
				for(var i:int=0;i< items.length;i++){
					if(items[i].id==itemCode){
						for(var ii:int=0;ii< items[i].colors.length;ii++){
							//trace(items[i].colors[ii].id);
							if(items[i].colors[ii].id==colorCode){
								currentItem=items[i].colors[ii];
								currentItem["itemId"]=items[i].id;
								break;
							}
						}
						if(currentItem==null){
							currentItem=items[i].colors[0];
							currentItem["itemId"]=items[i].id;
						}
						break;
					}
				}
				if(currentItem==null){
					currentItem=items[0].colors[0];
					currentItem["itemId"]=items[0].id;
				}
				
				
				isDark=currentItem.isDark=="1";
				
				var center:Array=currentItem.design_layout.center.split(",");
				wkCenter.x=Number(center[0]);
				wkCenter.y=Number(center[1]);
				wkWidth=Number(currentItem.design_layout.width);
				wkMultiply=currentItem.design_layout.multiply=="1";
				
				var f:File=FileManager.getAssetsDir().resolvePath("images/"+encodeURIComponent(currentItem.design_layout.image));
				FileManager.loadImageFromAppLocalPng(f,function(result:Boolean,bmd:BitmapData):void{
					if(result){
						CanvasWork = bmd;
						loadOutImage();
					}else{
						errorLoading();
					}
				});
				
			}catch(e:Error){
				trace(e);
				errorLoading();
			}
		}
		
		
		static private function loadOutImage():void{
			if(currentItem.hasOwnProperty("complete_layout")&&currentItem.complete_layout!=null){
				var center:Array=currentItem.complete_layout.center.split(",");
				outCenter.x=Number(center[0]);
				outCenter.y=Number(center[1]);
				outWidth=Number(currentItem.complete_layout.width);
				outMultiply=currentItem.complete_layout.multiply=="1";
				
				var f:File=FileManager.getAssetsDir().resolvePath("images/"+encodeURIComponent(currentItem.complete_layout.image));
				//trace(f.nativePath);
				FileManager.loadImageFromAppLocalPng(f,function(result:Boolean,bmd:BitmapData):void{
					if(result){
						CanvasOut = bmd;
						callbackFunction(true);
					}else{
						loadCopyOutTemplete(false);
					}
				});
				
			}else{
				loadCopyOutTemplete(true);
			}
		}
		
		static private function loadCopyOutTemplete(result:Boolean):void{
			CanvasOut=CanvasWork;
			outCenter.x=wkCenter.x;
			outCenter.y=wkCenter.y;
			outWidth=wkWidth;
			outMultiply=wkMultiply;
			callbackFunction(result);
		}
		
		static public function errorLoading():void{
			
			
			isDark=false;
			
			wkMultiply=true;
			outMultiply=true;
			
			CanvasWork=new  baseT_1024;
			CanvasOut=CanvasWork;
			
			wkCenter.x=0.5;
			wkCenter.y=0.4911602209944751;// 0.5-1.0/1.81*0.016;
			wkWidth=0.4910988336402701;//1.0/1.81/2304.0*2048.0;
			
			outCenter.x=0.5;
			outCenter.y=0.4911602209944751;// 0.5-1.0/1.81*0.016;
			outWidth=0.4910988336402701;//1.0/1.81/2304.0*2048.0;
			
			callbackFunction(false);
			trace("ITEM LOAD ERROR");
		}
		
		
		static public function getZoomRectOut(zoom:Boolean,aWidth:Number,aHeight:Number):Rectangle{
			var r:Rectangle=new Rectangle;
			if(zoom){
				var w:Number= aWidth*UTItemManager.wkNearScale;
				r.height=r.width=w/UTItemManager.outWidth;
				r.x=aWidth*.5-r.width*UTItemManager.outCenter.x;
				r.y=aHeight*.5-r.height*UTItemManager.outCenter.y;
			}else{
				r.height=r.width=aWidth*UTItemManager.wkFarScale;
				r.x=(aWidth-r.width)*.5;
				r.y=(aHeight-r.width)*.5;
			}
			return r;
		}
		
		
		static public function getZoomRect(zoom:Boolean,aWidth:Number,aHeight:Number):Rectangle{
			var r:Rectangle=new Rectangle;
			if(zoom){
				var w:Number= aWidth*UTItemManager.wkNearScale;
				r.height=r.width=w/UTItemManager.wkWidth;
				r.x=aWidth*.5-r.width*UTItemManager.wkCenter.x;
				r.y=(aHeight-29)*.5-r.height*UTItemManager.wkCenter.y;
			}else{
				r.height=r.width=aWidth*UTItemManager.wkFarScale;
				r.x=(aWidth-r.width)*.5;
				r.y=((aHeight-29)-r.width)*.5;
			}
			return r;
		}
		
		static public function getZoomRectMotion(t:Number,aWidth:Number,aHeight:Number):Rectangle{
			var r:Rectangle=getZoomRect(false,aWidth,aHeight);
			var r2:Rectangle=getZoomRect(true,aWidth,aHeight);
			r.x=r.x+(r2.x-r.x)*t;
			r.y=r.y+(r2.y-r.y)*t;
			r.width=r.width+(r2.width-r.width)*t;
			r.height=r.height+(r2.height-r.height)*t;
			return r;
		}
		
		static public var isDark:Boolean=false;
		static public var wkMultiply:Boolean=false;
		static public var outMultiply:Boolean=false;
		static public var CanvasWork:BitmapData;
		static public var CanvasOut:BitmapData;
		static public var wkCenter:Point=new Point;
		static public var wkWidth:Number;
		static public const wkFarScale:Number=1.3;		
		static public const wkNearScale:Number=0.95;
		
		static public var outCenter:Point=new Point;		
		static public var outWidth:Number;		
		
		static public var IMAGE_WIDTH:Number = 2048;
		static public var IMAGE_HEIGHT:Number = 2304;
		
		/*
		static public var IMAGE_MARGIN_Y:Number = 128;
		static public var IMAGE_MARGIN_X:Number = 170;
		
		static public var IMAGE_INNER_WIDTH:Number = IMAGE_WIDTH-IMAGE_MARGIN_X*2;
		static public var IMAGE_INNER_HEIGHT:Number = IMAGE_HEIGHT-IMAGE_MARGIN_Y*2;
		*/
		
		static public function writeCanvas(out:BitmapData,logo:Boolean):void{
			var bmdT:BitmapData;
			if(logo){
				bmdT= UTItemManager.CanvasOut;
			}else{
				bmdT= UTItemManager.CanvasWork
			}
			var m:Matrix=new Matrix();
			m.scale(out.height/bmdT.height,out.height/bmdT.height);
			out.draw(bmdT,m,null,null,null,true);
		}
	}
}

