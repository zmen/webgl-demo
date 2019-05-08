package utme.app.managers
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import jp.uniqlo.utlab.app.views.UIMenuStampDisableView;
	
	import utme.app.consts.AppVals;
	import utme.views.main.srcViews.stampSubViews.helpers.StampCopyLightsObject;
	
	public class UTStampManager{	
		
		static public const ThumbnailScale:Number=4.0;
		
		public var data:Object;
		public var Ids:Array;
		public var copyLights:Vector.<StampCopyLightsObject>;
		
		public function UTStampManager(stampSetData:Object){	
			data=stampSetData;
			
			trace(com.adobe.serialization.json.JSON.encode(data));
			
			//2.0.1　©　FIX
			if(data.hasOwnProperty("copyright")&&data.copyright!=null&&String(data.copyright).length>0){
				if(String(data.copyright).indexOf("(L)")>-1){
					data.copyright=String(data.copyright).replace("(L)","Ⓛ");
				}
			}
			
			RemixSplash=data.flag_effect_splash=="OK"?1:(data.flag_effect_splash=="LOOSE_NG"?2:0);
			RemixGlitch=data.flag_effect_glitch=="OK"?1:(data.flag_effect_glitch=="LOOSE_NG"?2:0);
			RemixMosic=data.flag_effect_mosaic=="OK"?1:(data.flag_effect_mosaic=="LOOSE_NG"?2:0);
			RemixLayout=data.flag_effect_layout=="OK"?1:(data.flag_effect_layout=="LOOSE_NG"?2:0);
			RemixMoma01=data.flag_effect_moma01=="OK"?1:(data.flag_effect_moma01=="LOOSE_NG"?2:0);
			RemixMoma02=data.flag_effect_moma02=="OK"?1:(data.flag_effect_moma02=="LOOSE_NG"?2:0);
			
			HasRemixLimitaion=RemixSplash==0||RemixGlitch==0||RemixMosic==0||RemixLayout==0||RemixMoma01==0||RemixMoma02==0?
				(RemixSplash==0&&RemixGlitch==0&&RemixMosic==0&&RemixLayout==0&&RemixMoma01==0&&RemixMoma02==0?2:1):0;
			
			
			DisablePaint=data.flag_layer_paint!="OK";
			DisableTypography=data.flag_layer_text!="OK";
			DisablePhoto=data.flag_layer_photo!="OK";
			DisableStamp=data.flag_layer_stamp!="OK";
			
			HasLayerLimitaion=DisablePaint||DisableTypography||DisablePhoto||DisableStamp?
				(DisablePaint&&DisableTypography&&DisablePhoto&&DisableStamp?2:1):0;
			
			
			LayerTopMost=data.flag_can_other_layer_over=="NG";
			DisableTimeline=data.flag_share!="OK";
			DisableMarket=data.flag_list!="OK";
			
			HasOthreLimitaion=LayerTopMost||DisableTimeline||DisableMarket;
			
			//////
			LayoutRotationType=data.flag_rotation=="OK"?1:(data.flag_rotation=="NG"?0:2);
			LayoutFringe=data.flag_fringe=="OK";
			LayoutOverLapType=data.flag_can_over=="OK"?0:(data.flag_can_over=="NG"?2:1);
			
			DisableMultiStamp=data.flag_used_with_multiple_stamps!="OK";
			DisableSameStamp=data.flag_used_with_same_stamps!="OK";	
			
			HasLayoutLimitaion=LayoutRotationType!=1||DisableMultiStamp||DisableSameStamp||LayoutOverLapType>0;
			
			if(data.flag_scale_by_thumb &&data.flag_scale_by_thumb!=null)ThumbnailScale=Number(data.flag_scale_by_thumb);
			if(data.flag_fringe_color&&data.flag_fringe_color!=null)EdgeColor=uint(data.flag_fringe_color);
			if(data.flag_fringe_width&&data.flag_fringe_width!=null)EdgeWidth=Number(data.flag_fringe_width);
			if(data.flag_fringe_width&&data.flag_fringe_width!=null)EdgeWidth=Number(data.flag_fringe_width);
			
			if(data.flag_effect_blendfunc&&data.flag_effect_blendfunc!=null)DisableBlendFuncs=data.flag_effect_blendfunc!="OK";
			if(LayerTopMost)DisableBlendFuncs=true;
			
			Ids=new Array;
			copyLights=new Vector.<StampCopyLightsObject>;
			
			HasLimitaion=HasLayerLimitaion||HasLayoutLimitaion||HasRemixLimitaion||HasOthreLimitaion;
			
			if(data.flag_out_of_bounds&&data.flag_out_of_bounds!=null)DisableOutOfBounds=data.flag_out_of_bounds!="OK";
			if(data.flag_print_copyright&&data.flag_print_copyright!=null)HideCopyRight=data.flag_print_copyright!="OK";
			
			if(data.hasOwnProperty("item_restrictions")&&data.item_restrictions!=null){
				item_restrictions=data.item_restrictions;
			}
			
			//trace("data.flag_effect_blendfunc",data.flag_effect_blendfunc,DisableBlendFuncs);
		}
		
		public var ThumbnailScale:Number=4.0;
		public var EdgeWidth:Number=4.0;
		public var EdgeColor:uint=0xFFFFFF;
		public var DisableBlendFuncs:Boolean=true;
		
		public var HasLayoutLimitaion:Boolean=false;
		public var HasLayerLimitaion:int=0;
		public var HasRemixLimitaion:int=0;
		public var HasOthreLimitaion:Boolean=false;
		public var HasLimitaion:Boolean=false;
		
		public var DisableOutOfBounds:Boolean=true;
		public var HideCopyRight:Boolean=false;
		
		public var DisableMultiStamp:Boolean;
		public var DisableSameStamp:Boolean;
		
		//REMIX
		public var LayoutRotationType:int;
		public var LayoutFringe:Boolean;
		public var LayoutOverLapType:int;
		
		public var RemixSplash:int=1;
		public var RemixGlitch:int=1;
		public var RemixMosic:int=1;
		public var RemixLayout:int=1;
		public var RemixMoma01:int=1;
		public var RemixMoma02:int=1;
			
		//Add Source
		public var DisablePaint:Boolean=false;
		public var DisableTypography:Boolean=false;
		public var DisablePhoto:Boolean=false;
		public var DisableStamp:Boolean=false;
		
		public var LayerTopMost:Boolean=false;
		public var DisableTimeline:Boolean=false;
		public var DisableMarket:Boolean=false;
		public var item_restrictions:Object={};
		
		//////////////////////////////////////////////////////////////////////////
		//GLOBAL MANAGER

		
		static public function getActive():UTStampManager{
			return StampLayerList[AppVals.HISTORY];
		}
		
		static public function getStampManager(historyIndex:int):UTStampManager{
			return StampLayerList[historyIndex];
		}
		
		static public function used():Boolean{
			for (var i:int=0;i<StampLayerList.length;i++){
				if(StampLayerList[i]!=null)return true;
			}
			return false;
		}
		
		static public function decodeStampSet():String{
			var stampDataObj:Array=new Array;
			for (var i:int=0;i<AppVals.HISTORY+1;i++){
				var s:UTStampManager=UTStampManager.getStampManager(i);
				if(s==null){
					stampDataObj.push(null);
				}else{
					var o:Object=new Object;
					o["data"]=s.data;
					o["ids"]=s.Ids;
					
					var copyLights:Vector.<StampCopyLightsObject>=s.copyLights;
					if(copyLights.length>0){
						var copys:Array=new Array
						for (var j:int=0;j<copyLights.length;j++){
							copys.push(copyLights[j].saveAndJson());
						}
						o["copyrights"]=copys;
					}
					stampDataObj.push(o);
				}
			}
			return com.adobe.serialization.json.JSON.encode(stampDataObj);
		}
		
		static public function encodeStampSet(json:String):void{
			removeAllSet();
			if(json==null||json.length==0)return;
			var obj:Object=com.adobe.serialization.json.JSON.decode(json);
			for (var i:int=0;i<obj.length;i++){
				if(obj[i]==null){
					StampLayerList[i]=null
				}else{
					var o:Object=obj[i];
					var s:UTStampManager=new UTStampManager(o.data);
					s.Ids=o.ids;
					StampLayerList[i]=s;
					
					if(o.hasOwnProperty("copyrights")&&o.copyrights is Array){
						var copys:Array=o.copyrights;
						for (var j:int=0;j<copys.length;j++){
							var co:StampCopyLightsObject=new StampCopyLightsObject;
							co.initWithString(copys[j]);
							s.copyLights.push(co);
						}
					}
				}
			}
			updateGroval();
		}
		
		
		static public function getActiveLayerTop():Boolean{
			var s:UTStampManager=getActive();
			return s==null?false:s.LayerTopMost;
		}
		
		static public function getActiveLayerDisableBlendFunc():Boolean{
			var s:UTStampManager=getActive();
			return s==null?false:s.DisableBlendFuncs;
		}
		
		
		static public function addSet(stampSetData:UTStampManager):void{
			StampLayerList[AppVals.HISTORY]=stampSetData;
			updateGroval();
		}
		static public function removeSet():void{
			StampLayerList[AppVals.HISTORY]=null;
			updateGroval();
		}
		
		static public function removeAllSet():void{
			for (var i:int=0;i<StampLayerList.length;i++){
				StampLayerList[i]=null;
			}
			clearTopLayerImage();
			updateGroval();
		}
		
//		static private var StampLayerList:Vector.<StampManager>= new Vector.<StampManager>(null,null,null);
		static private var StampLayerList:Array= [null,null,null];
		static private var Ids:Array=new Array;
		
	

		
		static public function checkCombinedItem(itemCode:String,colorCode:String=null):Boolean{
			if(item_disables.hasOwnProperty(itemCode)){
				if(colorCode==null){
					if(item_disables.hasOwnProperty(itemCode)){
						var colorCodes:Array=UTItemManager.getColorCodes(itemCode);	
						var checkCodes:Array=item_disables[itemCode];
						for each (var _color:String in colorCodes) {
							if(!(checkCodes.indexOf(_color)>-1))return true;
						}
						return false;
					}
				}else{
					for each (var _colorCode:String in item_disables[itemCode]) {
						if(_colorCode==colorCode){
							return false;
						}	
					}
				}
			}
			return true;
		}
		
		
		static private function updateGroval():void{
			DisablePaint=false;
			DisableTypography=false;
			DisablePhoto=false;
			DisableStamp=false;
			LayerTopMost=false;
			DisableTimeline=false;
			DisableMarket=false;
			Ids.length=0;
			item_disables={};
			
			for(var i:int;i<StampLayerList.length;i++){
				var s:UTStampManager=StampLayerList[i];
				if(StampLayerList[i]==null)continue;
				if(StampLayerList[i].DisablePaint)DisablePaint=true;
				if(StampLayerList[i].DisableTypography)DisableTypography=true;
				if(StampLayerList[i].DisablePhoto)DisablePhoto=true;
				if(StampLayerList[i].DisableStamp)DisableStamp=true;
				if(StampLayerList[i].LayerTopMost)LayerTopMost=true;
				if(StampLayerList[i].DisableTimeline)DisableTimeline=true;
				if(StampLayerList[i].DisableMarket)DisableMarket=true;
				Ids.push(s.Ids);
				
				if(StampLayerList[i].item_restrictions){
					for(var itemCode:String in StampLayerList[i].item_restrictions){
						for each (var colorCode:String in StampLayerList[i].item_restrictions[itemCode]) {
							trace(itemCode,colorCode);
							if(item_disables.hasOwnProperty(itemCode)){
								trace("B");
								(item_disables[itemCode] as Array).push(colorCode);
							}else{
								trace("A");
								item_disables[itemCode]=[colorCode];
							}	
						}
					}	
				}
				
			}
			UTStampManager.createCopyLight();
		}
		
		static public function hasLayerTopMost():Boolean{
			return LayerTopMost&&topLayerThumbImage!=null;
		}
		
		//Add Source
		static public var DisablePaint:Boolean=false;
		static public var DisableTypography:Boolean=false;
		static public var DisablePhoto:Boolean=false;
		static public var DisableStamp:Boolean=false;
		
		static private var LayerTopMost:Boolean=false;
		static public var DisableTimeline:Boolean=false;
		static public var DisableMarket:Boolean=false;
		static private var item_disables:Object={};
		
		static public function menuButtonDisable(menuBtn:MovieClip,disable:Boolean):void{
			if(!disable)return;
			var view:UIMenuStampDisableView=new UIMenuStampDisableView;
			menuBtn.addChild(view);
			menuBtn.mouseEnabled=false;
			menuBtn.mouseChildren=false;
		}
		
		
		static private const cachefilename:String= "StampTopLayer";
		static public function setTopLayerImage(bmd:BitmapData):void{
			//trace(bmd.width);
			//trace("CHACE CURRENT IMAGE");
			clearTopLayerImage();
			var m:Matrix=new Matrix;
			topLayerThumbImage=new BitmapData(UTItemManager.IMAGE_WIDTH*.5,UTItemManager.IMAGE_HEIGHT*.5,true,0);
			m.identity();
			m.scale(topLayerThumbImage.width/bmd.width,topLayerThumbImage.height/bmd.height);
			topLayerThumbImage.draw(bmd,m,null,null,null,true);
			
			m.identity();	 
			FileManager.saveCache(bmd,cachefilename);
		}
		
		static public function getTopLayerThumbTexture():BitmapData{
			if(!hasLayerTopMost())return null;
			var tex:BitmapData=new BitmapData(AppVals.TEXTURE_WIDTH*.5,AppVals.TEXTURE_WIDTH*.5,true,0);
			var m:Matrix=new Matrix;
			m.scale(tex.width/topLayerThumbImage.width,tex.height/topLayerThumbImage.height);
			tex.draw(topLayerThumbImage,m,null,null,null,true);
			return tex;
		}
		
		static public function getTopThumbImage():BitmapData{
			return hasLayerTopMost()?topLayerThumbImage:null;
		}
		
		static public function getTopLayerImage():BitmapData{
			return FileManager.loadCache(cachefilename,UTItemManager.IMAGE_WIDTH,UTItemManager.IMAGE_HEIGHT,true,0);
		}
		
		static private var topLayerThumbImage:BitmapData=null;
		
		static public function clearTopLayerImage():void{
			if(topLayerThumbImage!=null)topLayerThumbImage.dispose();
			topLayerThumbImage=null;
		}
		
		
		public static function getIdsString():String{
			var ret:String="";
			for(var i:int=0;i<StampLayerList.length;i++){
				var sm:UTStampManager=StampLayerList[i];
				if(sm!=null){
					var s:String="";
					for(var t:int=0;t<sm.Ids.length;t++){
						if(s.length>0)s+=","
						s+=String(sm.Ids[t]);
					}
					if(ret.length>0)ret+="|"
					ret+=s;
				}
			}
			return ret;
		}
		
		public static const COPY_SIZE:Number=22;
		public static const COPY_LEADING:Number=25;
		public static const COPY_IMAGE_HEIGHT:Number=200;
		
		public static const COPY_LEFT:Number=5;
		public static const COPY_BOTTOM:Number=5;
		
		private static function createTF(str:String):TextField{
			var font1:Font=UTFontManager.getFont("CopyRightFont");
			
			var copyTextField:TextField=new TextField;
			copyTextField.embedFonts=true;
			copyTextField.multiline=false;
			copyTextField.selectable=false;
			copyTextField.autoSize=TextFieldAutoSize.LEFT;
			copyTextField.antiAliasType=AntiAliasType.ADVANCED;
			copyTextField.gridFitType=GridFitType.NONE;
			copyTextField.thickness=AppVals.TEXT_THICKNESS;  
			copyTextField.border=false;
			copyTextField.alpha=1.0;
			var textForamt:TextFormat=new TextFormat;
			textForamt.size=COPY_SIZE;
			textForamt.kerning=true;
			textForamt.font=font1.fontName;
			textForamt.color=0x000000;
			copyTextField.defaultTextFormat=textForamt;
			copyTextField.text=str;
			return copyTextField;
		}
		
		private static var copyLightsSprite:Sprite=new Sprite();
		public static var hasCopyLights:Boolean;
		
		public static function getCopyLitesSprite(preview:Boolean):Sprite{
			var whiteEdgeAA:GlowFilter;
			if(preview){
				copyLightsSprite.filters =[
					new GlowFilter(0xFFFFFF,0.65,1.2,1.2, 12 , 2 , false ,false )
				];
			}else{
				copyLightsSprite.filters =[
					new DropShadowFilter(0,45,0xFFFFFF,0.65,3,3,25500,BitmapFilterQuality.HIGH)
				];
			}
			return copyLightsSprite;
		}
		
		public static function createCopyLight():void{
			hasCopyLights=false;
			copyLightsSprite.removeChildren();
			
			var width:int;
			var y:Number=0;
			var arr:Array=new Array;
			var sm:UTStampManager;
			for(var i:int=0;i<StampLayerList.length;i++){
				sm=StampLayerList[i];
				if(sm!=null)arr.push(sm);
			}

			var sIds:Array=new Array;	  
			for(i=0;i<arr.length;i++){
				sm=arr[i];
				if(sm==null)continue;
				var copyLights:Vector.<StampCopyLightsObject>=sm.copyLights;
				for(var j:int=0;j<copyLights.length;j++){
					var co:StampCopyLightsObject=copyLights[j];
					var sId:String=co.text;
					if(sIds.indexOf(sId)>-1)continue;
					sIds.push(sId);
					
					//var whiteEdge2:GlowFilter =new GlowFilter(0xFFFFFF,1,2,2,300, 4 , false , false );
					//var whiteEdgeAA:GlowFilter =new GlowFilter(0xFFFFFF,1,2,2, 10 , 4 , false ,false );
					
					if(co.hasImage&&co.loaded){
						var bm:Bitmap=new Bitmap(co.bitmapData,PixelSnapping.AUTO,true);
						bm.height=COPY_IMAGE_HEIGHT;
						bm.width=COPY_IMAGE_HEIGHT/co.bitmapData.height*co.bitmapData.width;
						copyLightsSprite.addChild(bm);
						bm.x=-bm.width;
						bm.y=y;
					}
					else
					{
						var tf:TextField=createTF(co.text);
						copyLightsSprite.addChild(tf);
						tf.y=y+2;
						tf.x=-tf.width;
					}
					
					y+=COPY_LEADING;
					hasCopyLights=true;
				}
			}
		}
	}
}

