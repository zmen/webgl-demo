package  utme.views.main.stage3d.helpers
{
	import flash.display.BitmapData;

	public class PVParticle
	{
		
		
		public var flg:Boolean;
		public var angle:Number;
		public var scale:Number;
		public var texIndex:int;
		public var velX:Number;
		public var posX:Number;		
		//public var frcX:Number;
		public var velY:Number;
		public var posY:Number;	
		//public var frcY:Number;
		public var life:int;
		//public var color:uint;	
		public var damping:Number = 0.15;
		public var tex:BitmapData;
		
		public var r:Number;
		public var g:Number;
		public var b:Number;
		
		public function PVParticle(){

		}
		
		public function setInitialCondition( px:Number,  py:Number,  vx:Number,  vy:Number, lifeTimes:int):void{
			posX=px,
			posY=py;
			velX=vx;
			velY=vy;
			life=lifeTimes;
		}
		/*
		public function resetForce():void{
			frcX=0;
			frcY=0;
		}
		
		public function addForce( x:Number, y:Number):void{
			frcX = frcX + x;
			frcY = frcY + y;
		}
		
		public function addDampingForce():void{
			frcX = frcX - velX * damping;
			frcY = frcY - velY * damping;
		}
		*/		

		
		public function isAlive():Boolean{
			return life>0;
		}
		
		
		//------------------------------------------------------------
		public function update():void{
			velX -= velX * damping;
			velY -= velY * damping;
			posX += velX;
			posY += velY;
			life-=1;
		}	
		
		public function setVFupdate( x:Number, y:Number):void{
			velX +=  x - velX * damping;
			velY +=  y - velY * damping;
			posX +=  velX;
			posY +=  velY;
			life-=1;
		}
		
	}
}