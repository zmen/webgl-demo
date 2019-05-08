package utme.views.main.stage3d.helpers
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import utme.app.consts.AppSound;
	
	public class PVPaletteCell extends MovieClip
	{
		private var mColor:Array;
		
		public var cbColorSelected:Function=null;
		public var isSelected:Boolean=false;
		private var mIndex:uint;
		
		public function PVPaletteCell(index:int)
		{
			super();
			this.addEventListener(MouseEvent.CLICK,onMouseUp);
			this.mouseChildren=false;
			this.buttonMode=true;
			isSelected=false;
			mIndex=index;
		}
		
		private function onMouseOver(e:MouseEvent):void{
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		private function onMouseOut(e:MouseEvent):void{
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);	
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		private function onMouseDown(e:MouseEvent):void{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		private function onMouseUp(e:MouseEvent):void{
			clicked();
			AppSound.playSound(2);
		}
		
		public function clicked():void{
			cbColorSelected(mColor,mIndex);
			selected(true);
		}
		
		
		public function selected(selected:Boolean):void{
			this.graphics.clear();
			var i:int;
			var w:Number=600/Number(mColor.length);
			if(selected){
				this.graphics.beginFill(0x333333,1);
				this.graphics.drawRect(20,0,600,80);
				this.graphics.endFill();
				
				for(i=0;i<mColor.length;i++){
					this.graphics.beginFill(mColor[i],1);
					this.graphics.drawRect((i>0?w*i:10)+20,10,i<mColor.length-1?w:(w-10),60);
					this.graphics.endFill();
				}
			}else{
				for(i=0;i<mColor.length;i++){
					this.graphics.beginFill(mColor[i],1);
					this.graphics.drawRect(w*i+20,0,w,80);
					this.graphics.endFill();
				}
			}
		}
		
		public function setColor(col:Array):void{
			mColor=col;
		}
		public function getColor():Array{
			return mColor;
		}
	}
}