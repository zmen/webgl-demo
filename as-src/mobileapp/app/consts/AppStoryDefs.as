package utme.app.consts
{
	import flash.utils.getQualifiedClassName;
	
	import jp.uniqlo.utlab.app.views.IcoRemix_01;
	import jp.uniqlo.utlab.app.views.IcoRemix_02;
	import jp.uniqlo.utlab.app.views.IcoRemix_03;
	import jp.uniqlo.utlab.app.views.IcoRemix_04;
	import jp.uniqlo.utlab.app.views.IcoRemix_05;
	import jp.uniqlo.utlab.app.views.IcoRemix_06;
	import jp.uniqlo.utlab.app.views.IcoSRC_01;
	import jp.uniqlo.utlab.app.views.IcoSRC_02;
	import jp.uniqlo.utlab.app.views.IcoSRC_03;
	import jp.uniqlo.utlab.app.views.IcoSRC_04;
	
	import utme.views.main.common.INavigatedView;
	import utme.views.main.srcViews.NV02_GraphicPaintView;
	import utme.views.main.srcViews.NV03_GraphicTypographyView;
	import utme.views.main.srcViews.NV04_GraphicPhotoView;
	import utme.views.main.srcViews.NV05_GraphicStampView;
	import utme.views.main.remixViews.NV11_RemixSplashView;
	import utme.views.main.remixViews.NV12_RemixGlitchView;
	import utme.views.main.remixViews.NV13_RemixMosaicView;
	import utme.views.main.remixViews.NV14_RemixAutoLayoutView;
	import utme.views.main.remixViews.NV15_RemixMOMA01View;
	import utme.views.main.remixViews.NV16_RemixMOMA02View;


	public class AppStoryDefs
	{
		IcoSRC_01;
		IcoSRC_02;
		IcoSRC_03;
		IcoSRC_04;
		IcoRemix_01;
		IcoRemix_02;
		IcoRemix_03;
		IcoRemix_04;
		IcoRemix_05;
		IcoRemix_06;
		
		static public function getClassName(index:Number,Remix:Boolean):String{
			return "jp.uniqlo.utlab.app.views.Ico"+(Remix?"Remix":"SRC")+"_"+(index<10?"0"+String(index):String(index));
		}
		
		static public const VIEW_SRC_PAINT:uint=1;
		static public const VIEW_SRC_TYPO:uint=2;
		static public const VIEW_SRC_PHOTO:uint=3;
		static public const VIEW_SRC_STAMP:uint=4;
		static public const VIEW_REMIX_INK:uint=1;
		static public const VIEW_REMIX_GLITCH:uint=2;
		static public const VIEW_REMIX_MOSIC:uint=3;
		static public const VIEW_REMIX_LAYOUT:uint=4;
		static public const VIEW_REMIX_MOMA01:uint=5;
		static public const VIEW_REMIX_MOMA02:uint=6;
			
		static public function getViewID(mc:INavigatedView):uint{
			if(mc is NV02_GraphicPaintView){
				return VIEW_SRC_PAINT;
			}
			if(mc is NV03_GraphicTypographyView){
				return VIEW_SRC_TYPO;
			}
			if(mc is NV04_GraphicPhotoView){
				return VIEW_SRC_PHOTO;
			}
			if(mc is NV05_GraphicStampView){
				return VIEW_SRC_STAMP;
			}
			
			if(mc is NV11_RemixSplashView){
				return VIEW_REMIX_INK;
			}
			if(mc is NV12_RemixGlitchView){
				return VIEW_REMIX_GLITCH;
			}
			if(mc is NV13_RemixMosaicView){
				return VIEW_REMIX_MOSIC;
			}
			if(mc is NV14_RemixAutoLayoutView){
				return VIEW_REMIX_LAYOUT;
			}
			if(mc is NV15_RemixMOMA01View){
				return VIEW_REMIX_MOMA01;
			}
			if(mc is NV16_RemixMOMA02View){
				return VIEW_REMIX_MOMA02;
			}
			
			return 0;
		}
		
		static public function getViewName(mc:INavigatedView):String{
			var str:String=getQualifiedClassName(mc);
			if(str.indexOf("::")>-1)str=str.substr(str.indexOf("::")+2);
			if(str.indexOf("_")>-1)str=str.substr(str.indexOf("_")+1);
			return str;
		}
		
		public static function getStoryJson():String{
			var ret:String="";
			var data:Vector.<Array>=AppVals.Story;
			for(var i:int=0;i<data.length;i++){
				if(data[i].length>0){
					var s:String="";
					for(var t:int=0;t<data[i].length;t++){
						if(s.length>0)s+=","
						s+=String(data[i][t]);
					}
					if(ret.length>0)ret+=","
					ret+="["+s+"]";
				}
			}
			return "["+ret+"]";
		}
		
		

		
		
	}
}