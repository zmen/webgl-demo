package utme.views.main.stage3d.helpers.AutoLayout
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	
	import utme.app.managers.UTItemManager;
	import utme.app.consts.AppVals;
	import utme.views.main.stage3d.helpers.Stage3DHelper;

	public class LayoutObject
	{
		private var ctx:Context3D;
		private var indicies:IndexBuffer3D;
		private var projectionMatrix:Matrix3D;
		public var texture:Texture=null;
		private var bVartex:VertexBuffer3D;
		private var bCoords:VertexBuffer3D;
		private var transformMatrix:Vector.<Number>=new Vector.<Number>;
		private var colorMatrix:Vector.<Number>=new Vector.<Number>;
		public var vartex:Vector.<Number>=new Vector.<Number>;
		public var coords:Vector.<Number>=new Vector.<Number>;
			
		
		public var scale:Number;
		public var angle:Number;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var textIndex:int;
		private var globalScale:Number;
		
		public var orgScale:Number=1;
		public var orgX:Number=0;
		public var orgY:Number=0;
		
		public var stampID:String;
		
		public function LayoutObject(){
			transformMatrix.push(0,0,0,1);
			colorMatrix.push(1,1,1,1);
			
			vartex.push(0,0,UTItemManager.IMAGE_WIDTH,0,0,UTItemManager.IMAGE_HEIGHT,UTItemManager.IMAGE_WIDTH,UTItemManager.IMAGE_HEIGHT);
			coords.push(0, 1, 1, 1, 0, 0, 1, 0);
		}
		
		public function setRectangle(rect:Rectangle,gScale:Number):void{
			orgScale=gScale;
			
			vartex[0]=vartex[4]=rect.width*.5*orgScale;
			vartex[1]=vartex[3]=-rect.height*.5*orgScale;
			vartex[2]=vartex[6]=-rect.width*.5*orgScale;
			vartex[5]=vartex[7]=rect.height*.5*orgScale;
			
			coords[0]=coords[4]=(rect.x+rect.width)/UTItemManager.IMAGE_WIDTH;
			coords[1]=coords[3]=rect.y/UTItemManager.IMAGE_HEIGHT;
			coords[2]=coords[6]=rect.x/UTItemManager.IMAGE_WIDTH;
			coords[5]=coords[7]=(rect.y+rect.height)/UTItemManager.IMAGE_HEIGHT;
			
			bVartex.uploadFromVector(vartex,0,4);	
			bCoords.uploadFromVector(coords,0,4);
			
			x=(rect.x+rect.width*.5)*orgScale;
			y=(rect.y+rect.height*.5)*orgScale;
			
			scale=1;
			angle=0;
			
			width=rect.width*orgScale;
			height=rect.height*orgScale;
		}
		
		public function setRectangleType(rect:Rectangle,coordx:Number,coordy:Number,gScale:Number):void{
			orgScale=gScale;
			
			vartex[0]=vartex[4]=rect.width*.5*orgScale;
			vartex[1]=vartex[3]=-rect.height*.5*orgScale;
			vartex[2]=vartex[6]=-rect.width*.5*orgScale;
			vartex[5]=vartex[7]=rect.height*.5*orgScale;
			
			coords[0]=coords[4]=(coordx+rect.width)/AppVals.TEXTURE_WIDTH;
			coords[1]=coords[3]=coordy/AppVals.TEXTURE_WIDTH;
			coords[2]=coords[6]=coordx/AppVals.TEXTURE_WIDTH;
			coords[5]=coords[7]=(coordy+rect.height)/AppVals.TEXTURE_WIDTH;
			
			x=(rect.x+rect.width*.5)*orgScale;
			y=(rect.y+rect.height*.5)*orgScale;
			
			bVartex.uploadFromVector(vartex,0,4);	
			bCoords.uploadFromVector(coords,0,4);
			
			scale=1;
			angle=0;
			
			width=rect.width*orgScale;
			height=rect.height*orgScale;
		}
		
		public function setup(_ctx:Context3D,_indicies:IndexBuffer3D,_projectionMatrix:Matrix3D):void{
			ctx=_ctx;
			indicies=_indicies;
			projectionMatrix=_projectionMatrix;
			bVartex=ctx.createVertexBuffer(4, 2,Context3DBufferUsage.STATIC_DRAW);
			bCoords=ctx.createVertexBuffer(4, 2,Context3DBufferUsage.STATIC_DRAW);
			bVartex.uploadFromVector(vartex,0,4);	
			bCoords.uploadFromVector(coords,0,4);	
		}
		
		public function setTexture(_texture:Texture):void{
			texture=_texture;
		}
		
		public function dispose():void{
			
		}
		
		public function draw():void{	
			transformMatrix[0] = x;
			transformMatrix[1] = y;
			transformMatrix[2] = angle;
			transformMatrix[3] = scale;
			Stage3DHelper.drawTriangles(ctx,indicies,projectionMatrix,texture,bVartex,bCoords,transformMatrix,colorMatrix);
		}
		
	}
}