package utme.views.main.srcViews.stampSubViews.subviews
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	public class StampObject extends Sprite
	{
		public var contents:Bitmap;
		public var id:String;
		public function StampObject(bmd:BitmapData,_id:String){
			super();
			contents=new Bitmap(bmd,"auto",true);
			contents.x=-bmd.width*.5;
			contents.y=-bmd.height*.5;
			this.addChild(contents);
			contents.smoothing=true;
			id=_id;
			willDelete=false;
			selected=false;
		}

		public function BitmapAlphaTest(stageMousePos:Point):Boolean{
			return contents.bitmapData.hitTest(new Point(0,0),1,contents.globalToLocal(stageMousePos));
		}
		
		public var willDelete:Boolean;
		public var selected:Boolean;
	}
}