package utme.views.main.stage3d.helpers
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	

	public class Stage3DHelper
	{
		public static function drawTriangles(ctx:Context3D,
											 indicies:IndexBuffer3D,
											 projectionMatrix:Matrix3D,
											 texture:Texture,
											 vartex:VertexBuffer3D,
											 coords:VertexBuffer3D,
											 transformMatrix:Vector.<Number>,
											 colorMatrix:Vector.<Number>
		):void{
			ctx.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, colorMatrix );
			ctx.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 4, transformMatrix );				
			ctx.setVertexBufferAt(0, vartex, 0, Context3DVertexBufferFormat.FLOAT_2);
			ctx.setVertexBufferAt(1, coords, 0, Context3DVertexBufferFormat.FLOAT_2);
			ctx.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, projectionMatrix,true);
			ctx.setTextureAt( 0, texture);
			ctx.drawTriangles(indicies);
		}
		
		
		public static const VERTEX_SHADER:String =
			"mov　vt0, va0 \n"+              
			"mov　vt1, vc4 \n"+  //temp clear 回転計算開始
			"cos　vt1.x, vt1.z \n"+　//sin val tf[2]      
			"sin　vt1.y, vt1.z \n"+ //cos val tf[2]
			"mul vt1.xyzw, vt0.xxyy, vt1.xyyx \n"+
			"sub vt0.x, vt1.x, vt1.z \n"+  
			"add vt0.y, vt1.y, vt1.w \n"+
			"mul vt0.xy, vt0, vc4.ww \n"+   //Scaling tf[3]
			"add vt0.xy, vt0, vc4.xy \n"+   //
			"m44 op, vt0, vc0 \n"+          //座標を表示範囲に正規化
			"mov v0, va1"; // uv を設定
		public static const PIXEL_SHADER:String =
			"tex ft0, v0, fs0<2d,clamp,linear,miplinear> \n"+  //ft0=samplar(fs0,v0.uv)  
			"mul oc, ft0, fc0";    // textureにcolor を 適用
		
		public static const PIXEL_NOMIP_SHADER:String =
			"tex ft0, v0, fs0<2d,clamp,linear> \n"+  //ft0=samplar(fs0,v0.uv)  
			"mul oc, ft0, fc0";    // textureにcolor を 適用
		
		public static function createMainProgram(ctx:Context3D, useMip:Boolean):Program3D{
			var vertexAssembly:AGALMiniAssembler = new AGALMiniAssembler();
			vertexAssembly.assemble(Context3DProgramType.VERTEX, VERTEX_SHADER);
			var fragmentAssembly:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentAssembly.assemble(Context3DProgramType.FRAGMENT, useMip?PIXEL_SHADER:PIXEL_NOMIP_SHADER);
			var shader:Program3D = ctx.createProgram();
			shader.upload(vertexAssembly.agalcode, fragmentAssembly.agalcode);
			vertexAssembly=null;
			fragmentAssembly=null;
			return shader;
		}
		
		
		static private function uploadTextureWithMipMaps( tex:Texture, originalImage:BitmapData , dispose:Boolean):void {
			
			var mipWidth:int = originalImage.width;
			var mipHeight:int = originalImage.height;
			var bmd:BitmapData = originalImage;
			var scaleTransform:Matrix = new Matrix();
			scaleTransform.scale( 0.5, 0.5 );
			var mipLevel:int = 0;
			while ( mipWidth > 0 && mipHeight > 0 ){
				tex.uploadFromBitmapData( bmd, mipLevel );
				mipLevel++;
				mipWidth >>= 1;
				mipHeight >>= 1;
				
				if(mipWidth > 0 && mipHeight > 0 ){
					var tmp:BitmapData=bmd;
					bmd=null;
					bmd=new BitmapData(mipWidth,mipHeight,true,0x00FFFFFF);
					//bmd.draw( tmp, scaleTransform, null, null, null, true );
					bmd.draw(tmp, scaleTransform, null, null, null, true);
					
					if(dispose||tmp!=originalImage)tmp.dispose();
					tmp=null;
				}
			}
			if(dispose||bmd!=originalImage)bmd.dispose();
		}
		
		static public function uploadTexture(ctx:Context3D,bmd:BitmapData,format:String,useMips:Boolean, dispose:Boolean):Texture{
			var tex:Texture= ctx.createTexture(bmd.width,bmd.height,format,false);
			if(useMips){
				Stage3DHelper.uploadTextureWithMipMaps(tex,bmd,dispose);
			}else{
				tex.uploadFromBitmapData( bmd );
			}
			if(dispose)bmd.dispose();
			return tex;
		}
	}
}