package utme.app.managers
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import utme.app.consts.AppVals;
	
	public class UTTopLayerManager
	{
	
		static public function hasTopLayer():Boolean{
			var ret:Boolean=false;
			if(UTStampManager.hasLayerTopMost())ret=true;
			trace("hasTopLayer",ret);
			return ret;
		}
		
		static public function getTopLayerThumbImage():BitmapData{
			if(!hasTopLayer())return null;
			
			var tex:BitmapData=new BitmapData(AppVals.TEXTURE_WIDTH*.5,AppVals.TEXTURE_WIDTH*.5,true,0);
			var m:Matrix=new Matrix;				
			var top:BitmapData;
			
			if(UTStampManager.hasLayerTopMost()){
				top=UTStampManager.getTopThumbImage();
				m.identity();
				m.scale(tex.width/top.width,tex.height/top.height);
				tex.draw(top,m,null,null,null,true);
			}
			
			return tex;
		}
		
	}
}