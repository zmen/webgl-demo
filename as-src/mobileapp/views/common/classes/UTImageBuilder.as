package utme.views.common.classes
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	
	
	import utme.app.managers.UTItemManager;
	import utme.app.managers.UTStampManager;
	import utme.app.managers.UTTopLayerManager;

	public class UTImageBuilder
	{
		static public function createPrintedImage(out:BitmapData,src:BitmapData,multiply:Boolean,logo:Boolean,copyright:Boolean,renderTop:Boolean):void{
			
			var m:Matrix=new Matrix;
			UTItemManager.writeCanvas(out,logo);
			
			var top:BitmapData=renderTop?UTTopLayerManager.getTopLayerThumbImage():null;
			
			if(src==null&&top==null)return;

			var h:Number;
			var w:Number;
			var x:Number;
			var y:Number;
			
			if(logo){
				w=out.width*UTItemManager.outWidth;
				h=w*UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
				x=out.width*UTItemManager.outCenter.x-w*.5;
				y=out.width*UTItemManager.outCenter.y-h*.5;	
			}else{
				w=out.width*UTItemManager.wkWidth;
				h=w*UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
				x=out.width*UTItemManager.wkCenter.x-w*.5;
				y=out.width*UTItemManager.wkCenter.y-h*.5;
			}

			if(multiply&&((src!=null?1:0)+(top!=null?1:0)>1)){
				var tmp:BitmapData=new BitmapData(w,h,false,0xFFFFFF);
				if(src!=null){
					m.identity();
					m.scale(w/src.width,h/src.height);
					tmp.draw(src,m,null,null,null,true);
				}
				if(top!=null){
					m.identity();
					m.scale(w/top.width,h/top.height);
					tmp.draw(top,m,null,null,null,true);
				}
				
				m.identity();
				m.translate(x,y);
				out.draw(tmp,m,null,BlendMode.MULTIPLY,null,true);
				tmp.dispose();
			}else{
				if(src!=null){
					m.identity();
					m.scale(w/src.width,h/src.height);
					m.translate(x,y);
					out.draw(src,m,null,multiply?BlendMode.MULTIPLY:null,null,true);	
				}
				if(top!=null){
					m.identity();
					m.scale(w/top.width,h/top.height);
					m.translate(x,y);
					out.draw(top,m,null,multiply?BlendMode.MULTIPLY:null,null,true);	
				}
			}
			
			
			if(copyright && UTStampManager.used() && UTStampManager.hasCopyLights){
				var copyLightsSprite:Sprite=UTStampManager.getCopyLitesSprite(true);
				m.identity();
				m.translate(-UTStampManager.COPY_LEFT,-copyLightsSprite.height-UTStampManager.COPY_BOTTOM+copyLightsSprite.height+20);
				m.scale(w/UTItemManager.IMAGE_WIDTH,h/UTItemManager.IMAGE_HEIGHT);
				m.translate(x+w,y+h);
				out.drawWithQuality(copyLightsSprite,m,null,null,null,true,StageQuality.HIGH);
			}
			
		}
		
		static public function createPrintedImageWithMultiSrc(out:BitmapData,src:BitmapData,src2:BitmapData,multiply:Boolean,renderTop:Boolean):void{
			
			var m:Matrix=new Matrix;
			
			UTItemManager.writeCanvas(out,false);
			
			var h:Number;
			var w:Number;
			var x:Number;
			var y:Number;
			
			
			w=out.width*UTItemManager.wkWidth;
			h=w*UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
			x=out.width*UTItemManager.wkCenter.x-w*.5;
			y=out.width*UTItemManager.wkCenter.y-h*.5;
			
			
			var top:BitmapData=renderTop?UTTopLayerManager.getTopLayerThumbImage():null;
			
			if(multiply&&((src!=null?1:0)+(src2!=null?1:0)+(top!=null?1:0)>1)){
				
				var tmp:BitmapData=new BitmapData(w,h,false,0xFFFFFF);
				if(src!=null){
					m.identity();
					m.scale(w/src.width,h/src.height);
					tmp.draw(src,m,null,null,null,true);
				}
				if(src2!=null){
					m.identity();
					m.scale(w/src2.width,h/src2.height);
					tmp.draw(src2,m,null,null,null,true);
				}
				if(top!=null){
					m.identity();
					m.scale(w/top.width,h/top.height);
					tmp.draw(top,m,null,null,null,true);
				}
				
				m.identity();
				m.translate(x,y);
				out.draw(tmp,m,null,BlendMode.MULTIPLY,null,true);
				tmp.dispose();
			}else{
				if(src!=null){
					m.identity();
					m.scale(w/src.width,h/src.height);
					m.translate(x,y);
					out.draw(src,m,null,multiply?BlendMode.MULTIPLY:null,null,true);
				}
				if(src2!=null){
					m.identity();
					m.scale(w/src2.width,h/src2.height);
					m.translate(x,y);
					out.draw(src2,m,null,multiply?BlendMode.MULTIPLY:null,null,true);
				}
				if(top!=null){
					m.identity();
					m.scale(w/top.width,h/top.height);
					m.translate(x,y);
					out.draw(top,m,null,multiply?BlendMode.MULTIPLY:null,null,true);
				}
			}
		}
		
		static public function createPrintImageByLayer(out:BitmapData,src:BitmapData,multiply1:Boolean,src2:BitmapData,multiply2:Boolean,renderTop:Boolean):void{
			var m:Matrix=new Matrix;
			UTItemManager.writeCanvas(out,false);
			
			var h:Number;
			var w:Number;
			var x:Number;
			var y:Number;
			
			
			w=out.width*UTItemManager.wkWidth;
			h=w*UTItemManager.IMAGE_HEIGHT/UTItemManager.IMAGE_WIDTH;
			x=out.width*UTItemManager.wkCenter.x-w*.5;
			y=out.width*UTItemManager.wkCenter.y-h*.5;
			
			
			var top:BitmapData=renderTop?UTTopLayerManager.getTopLayerThumbImage():null;
			
			if(src!=null){
				m.identity();
				m.scale(w/src.width,h/src.height);
				m.translate(x,y);
				out.draw(src,m,null,multiply1?BlendMode.MULTIPLY:null,null,true);
			}
			if(src2!=null){
				m.identity();
				m.scale(w/src2.width,h/src2.height);
				m.translate(x,y);
				out.draw(src2,m,null,multiply2?BlendMode.MULTIPLY:null,null,true);
			}
			
			if(top!=null){
				m.identity();
				m.scale(w/top.width,h/top.height);
				m.translate(x,y);
				out.draw(top,m,null,null,null,true);
			}
		}
	}
}