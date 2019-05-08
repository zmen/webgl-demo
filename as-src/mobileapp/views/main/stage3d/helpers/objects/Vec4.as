package utme.views.main.stage3d.helpers.objects
{
	public class Vec4
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		private var _depth:uint;
		
		//map xyz to rgb like glsl
		/*
		public function get r():Number{return r;}
		public function get g():Number{return g;}
		public function get b():Number{return b;}
		public function get a():Number{return a;}
		public function set r(_v:Number):void{x=_v;}
		public function set g(_v:Number):void{y=_v;}
		public function set b(_v:Number):void{z=_v;}
		public function set a(_v:Number):void{w=_v;}
		*/
		public override function Vec4(_x:Number=0,_y:Number=0,_z:Number=0,_w:Number=0){
			x=_x;
			y=_y;
			z=_z;
			w=_w;
		}
		
		
		public function multiply4(src:Vec4):void{
			this.x*=src.x;
			this.y*=src.y;
			this.z*=src.z;
			this.w*=src.w;
		}
		
		public function multiplyed4(src:Vec4):Vec4{
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.multiply4(src);return ret;
		}
		
		public function add4(src:Vec4):void{
			this.x+=src.x;
			this.y+=src.y;
			this.z+=src.z;
			this.w+=src.w;
		}
		
		public function added4(src:Vec4):Vec4{
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.add4(src);return ret;
		}
		
		public function substract4(src:Vec4):void{
			this.x-=src.x;
			this.y-=src.y;
			this.z-=src.z;
			this.w-=src.w;
		}
		
		public function substracted4(src:Vec4):Vec4{
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.substract4(src);return ret;
		}
		
		public function division4(src:Vec4):void{
			this.x/=src.x;
			this.y/=src.y;
			this.z/=src.z;
			this.w/=src.w;
		}
		
		public function divisioned4(src:Vec4):Vec4{
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.division4(src);return ret;
		}
		
		//////////////////////////////////////////////////////////////
		
		public function multiply(src:Number):void{
			this.x*=src;
			this.y*=src;
			this.z*=src;
			this.w*=src;
		}

		public function multiplyed(src:Number):Vec4{
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.multiply(src);return ret;
		}
		
		public function add(src:Number):void{
			this.x+=src;
			this.y+=src;
			this.z+=src;
			this.w+=src;
		}
		
		public function added(src:Number):Vec4{
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.add(src);return ret;
		}
		
		public function substract(src:Number):void{
			this.x-=src;
			this.y-=src;
			this.z-=src;
			this.w-=src;
		}
		
		public function substracted(src:Number):Vec4{
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.substract(src);return ret;
		}
		
		public function division(src:Number):void{
			this.x/=src;
			this.y/=src;
			this.z/=src;
			this.w/=src;
		}
		
		public function divisioned(src:Number):Vec4{
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.division(src);return ret;
		}
		
		
		public function dot(src:Vec4):Number{
			return this.x*src.x+this.y*src.y+this.z*src.z+this.w*src.w;
		}
		
		
		public function rotate2d( angle:Number ):void {
			rotate2dRad(angle * Math.PI/180.0);
		}
		public function rotate2dRad( angle:Number ):void {
			var xrot:Number = x*Math.cos(angle) - y*Math.sin(angle);
			this.y = x*Math.sin(angle) + y*Math.cos(angle);
			this.x = xrot;
		}
		
		public function normalize():void {
			var l:Number = length();
			if( l > 0 ) {
				this.x /= l;
				this.y /= l;
				this.z /= l;
				this.w /= l;
			}
		}
		
		public function length():Number {
			return Math.sqrt(this.x*this.x + this.y*this.y+this.z*this.z + this.w*this.w);
			
		}
		
		
		public function normalized():Vec4 {
			var ret:Vec4=new Vec4(this.x,this.y,this.z,this.w);ret.normalize();return ret;
		}

		
	}
}