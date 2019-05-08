package utme.views.main.stage3d.helpers
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import utme.app.managers.UTItemManager;
	
	public class H_MOMA02CPerticles
	{
		private static const uniformColor:Vector.<Number>=new <Number>[1,1,1,1];
		private var uniformMatrix:Vector.<Number>=new <Number>[0,0,0,1];
		
		private var _texture:Texture;
		public var org_x:Number;
		public var org_y:Number;
		public var org_width:Number;
		public var org_height:Number;
		public var tx:Number;
		public var ty:Number;
		public var texSize:int;
		
		private var org_scale:Number;
		private var org_rad:Number;
		private var rad:Number;
		private var scale:Number;
		private var mCtx3D:Context3D;
		private var realScale:Number;
		public var bAllocated:Boolean=false;
		public var hue:Number=0;
		
		public function H_MOMA02CPerticles(){
		}
		
		public function setCtx(ctx3D:Context3D):void{
			mCtx3D=ctx3D;
		}
		
		public function setOrgRadWithScale(aRad:Number=0,aScale:Number=1):void{		
			org_scale=aScale;
			org_rad=aRad;
		}
		
		public function setPosOrg():void{
			rad=org_rad;
			scale=org_scale;
		}
		
		public function updateTexture(bmd:BitmapData):void{
			if(!bAllocated)return;
			if(_texture)_texture.dispose();
			_texture=Stage3DHelper.uploadTexture(mCtx3D,bmd, Context3DTextureFormat.BGRA,false,true)
		}
		
		public function setup(bmd:BitmapData,aX:Number,aY:Number,aWidth:Number,aHeight:Number,aRad:Number=0,aScale:Number=1):Boolean{
			dispose();
			var rect:Rectangle=bmd.getColorBoundsRect(0xff000000, 0, false);
			//trace("getColorBoundsRect",rect);
			if(!rect||rect.width<1||rect.height<1)return false;
			
			
			texSize=1;
			while(texSize<rect.width||texSize<rect.height)texSize*=2;
			
			trace("texture size:",texSize)		
			var _bmd:BitmapData=new BitmapData(texSize,texSize,true,0);
			var m:Matrix=new Matrix;
			tx=(rect.x+rect.width*.5)-texSize*.5;
			ty=(rect.y+rect.height*.5)-texSize*.5;
			m.translate(-tx,-ty);
			_bmd.draw(bmd,m,null,null,null,true);
			realScale=texSize;
			org_x=aX-bmd.width*.5+(rect.x+rect.width*.5);
			org_y=aY-bmd.height*.5+(rect.y+rect.height*.5);
			
			org_scale=scale=aScale;
			org_rad=rad=aRad;
			org_width=aWidth;
			org_height=aHeight;
			
			scale=0;
			rad=(Math.random()-0.5)*Math.PI;
			
			_texture=Stage3DHelper.uploadTexture(mCtx3D,_bmd, Context3DTextureFormat.BGRA,false,true)
			//trace(x,y,rad,scale);
			bAllocated=_texture!=null;
			return bAllocated;
		}
		
		public function dispose():void{
			destory();
			bAllocated=false;
		}
		public function destory():void{
			if(_texture)_texture.dispose();
		}
		
		public function draw(indexBuffer:IndexBuffer3D):void{
			if(!bAllocated)return;
			
			rad+=(org_rad-rad)*0.2;
			scale+=(org_scale-scale)*0.2;
			
			uniformMatrix[0]=org_x;
			uniformMatrix[1]=UTItemManager.IMAGE_HEIGHT-org_y;
			uniformMatrix[2]=rad;
			uniformMatrix[3]=realScale*scale;
			mCtx3D.setTextureAt(0,_texture);
			mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, uniformColor);
			mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, uniformMatrix);
			mCtx3D.drawTriangles(indexBuffer);
		}
		
		
	}
}
