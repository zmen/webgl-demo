package utme.views.main.stage3d.helpers.AutoLayout
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import utme.app.managers.UTItemManager;
	import utme.app.consts.AppVals;

	public class LayoutsHelper
	{
		static public function addSimplePerts(
			perticles:Vector.<perticleObject>,
			layouts:Vector.<LayoutObject>,
			vert:Boolean,
			ay:Number,
			ax:Number,
			MAX_WIDTH:Number,
			Line_Height:Number,
			marginY:Number,
			marginX:Number,
			MAX_LINE:Number,
			startIndex:int=0,
			MAX_HEIGHT:Number=0
		):void{
			var sizes:Vector.<Number>=new Vector.<Number>;
			var nums:Vector.<int>=new Vector.<int>;
			
			var i:int;
			var t:int;
			
			var y:Number=0;
			var po:perticleObject;
			var lo:LayoutObject;
			
			var x:Number;
			var scale:Number;
			var angle:Number;
			var numlines:int;
			var maxW:Number
			var rad:Number;
			var cx:Number;
			var cy:Number;
			
			var tpo:SimplePerticleObject;
			rad=vert?-Math.PI*.5:0;;
			
			numlines=0;
			i=startIndex;
			y=0;
			x=0;
			t=0;
			maxW=0;
			tmpPerticle.length=0;
			sizes.length=0;
			nums.length=0;
			angle=0;
			
			lo=layouts[0];
			scale=Line_Height/lo.height;
			while(true){
				lo=layouts[i];
				
				if(x>0&&x+lo.width*scale>MAX_WIDTH){
					sizes.push(x-marginX);
					nums.push(t);
					x=0;
					t=0;
					y+=Line_Height+marginY;
					numlines++;
					
					i=Math.floor(Math.random()*layouts.length);
					lo=layouts[i];
					
					if(numlines>MAX_LINE-1)break;
				}
				
				tpo=new SimplePerticleObject;
				tpo.flg=x==0;
				tpo.lid=i;
				tpo.x= x+lo.width*scale*.5;
				tpo.y= y+lo.height*scale*.5;
				tpo.scale=scale;
				tpo.angle=angle;
				tmpPerticle.push(tpo);
				t++;
				maxW=Math.max(maxW,x+lo.width*scale);
				x+=lo.width*scale+marginX;
				i++;
				if(i+1>layouts.length)i=0;
			}
			
			scale=MAX_WIDTH/maxW;
			t=-1;
			
			for(i=0;i<tmpPerticle.length;i++){
				tpo=tmpPerticle[i];
				if(tpo.flg){
					t++;
					x=0;
				}else{
					x+=(maxW-(sizes[t]-(nums[t]-1)*marginX))/Number((nums[t]-1))-marginX;
				}
				tpo.x=tpo.x*scale+x*scale;
				tpo.y=tpo.y*scale;
				tpo.scale*=scale;
				
				if(MAX_HEIGHT>0&&MAX_HEIGHT<tpo.y-layouts[tpo.lid].height*tpo.scale*.5)break;
				
				cx = tpo.x*Math.cos(rad)-tpo.y*Math.sin(rad);
				cy = tpo.x*Math.sin(rad)+tpo.y*Math.cos(rad);
				
				tpo.x=cx;
				tpo.y=cy;
				tpo.angle+=rad;
				
				
				
				addPerticleObject(perticles,layouts,tpo.lid,tpo.x+ax,tpo.y+ay,tpo.scale,tpo.angle);
			}
			
			tmpPerticle.length=0;
			sizes.length=0;
			nums.length=0;	
		}
		
		static public function addPerticleObject(perticles:Vector.<perticleObject>,layouts:Vector.<LayoutObject>,pid:int,ax:Number,ay:Number,ascale:Number,aangle:Number):void{
			var j:int;
			var found:Boolean;
			var po:perticleObject;
			found=false;
			for(j=0;j<perticles.length;j++){
				if(perticles[j].willDelete&&perticles[j].index==pid){
					po=perticles[j];
					found=true;
				}
			}
			if(!found){
				po=new perticleObject(layouts[pid],pid);
				po.setPositon(Math.random()*UTItemManager.IMAGE_WIDTH,Math.random()*UTItemManager.IMAGE_HEIGHT,0,Math.random()*Math.PI*2-Math.PI);
			}
			po.setPositonWithAnimate(ax,ay,ascale,aangle);
			po.willDelete=false;
			if(!found)perticles.push(po);	
		}	
		
		static public function fixLayouts(perticles:Vector.<perticleObject>,rad:Number=0):void{
			var found:Boolean;
			var i:int;
			var po:perticleObject;
			var hh:Number;
			var hw:Number;
			var cx:Number;
			var cy:Number;
			var minX:Number;
			var maxX:Number;
			var minY:Number;
			var maxY:Number;
			var w:Number;
			var h:Number;
			var movX:Number=0;
			var movY:Number=0;
			var s:Number;
			
			if(rad!=0){
				for(i=0;i<perticles.length;i++){
					po=perticles[i];
					if(po.willDelete)continue;
					cx = po.toX*Math.cos(rad)-po.toY*Math.sin(rad);
					cy = po.toX*Math.sin(rad)+po.toY*Math.cos(rad);
					po.toX=cx;
					po.toY=cy;
					po.toAngle+=rad;
					
				}
			}
			
			
			found=false;
			for(i=0;i<perticles.length;i++){
				po=perticles[i];
				if(po.willDelete)continue;
				hh=po.height()*.5;
				hw=po.width()*.5;	
				
				cx = Math.max(Math.abs(hw*Math.cos(po.toAngle)-hh*Math.sin(po.toAngle)),Math.abs(hw*Math.cos(po.toAngle)+hh*Math.sin(po.toAngle)));
				cy = Math.max(Math.abs(hw*Math.sin(po.toAngle)+hh*Math.cos(po.toAngle)),Math.abs(hw*Math.sin(po.toAngle)-hh*Math.cos(po.toAngle)));
				
				if(!found){
					found=true;
					minX=po.toX-cx;
					maxX=po.toX+cx;
					minY=po.toY-cy;
					maxY=po.toY+cy;
				}else{
					minX=Math.min(minX,po.toX-cx);
					maxX=Math.max(maxX,po.toX+cx);
					minY=Math.min(minY,po.toY-cy);
					maxY=Math.max(maxY,po.toY+cy);
				}
			}
			
			w=maxX-minX;
			h=maxY-minY;
			
			var MaxW:Number=UTItemManager.IMAGE_WIDTH-200;
			var MaxH:Number=UTItemManager.IMAGE_HEIGHT;
			
			if(MaxH/h<MaxW/w){
				s=MaxH/h;
				//if(w*s>AppVals.IMAGE_WIDTH*.5)movX=(AppVals.IMAGE_WIDTH-w*s)*.5;
				//else movX=(AppVals.IMAGE_WIDTH-w*s)*(Math.random());
			}else{
				s=MaxW/w;
				//if(Math.random()<0.6) movY=(AppVals.IMAGE_HEIGHT-h*s)*.2;
				//else movY=(AppVals.IMAGE_HEIGHT-h*s)*(Math.random());

			}
			movX=(UTItemManager.IMAGE_WIDTH-w*s)*.5;
			movY=(UTItemManager.IMAGE_HEIGHT-h*s)*.2;	
			
			
			//位置を再定義する。
			for(i=0;i<perticles.length;i++){
				po=perticles[i];
				if(po.willDelete)continue;
				po.toX-=minX;
				po.toY-=minY;
				po.toScale*=s;
				po.toX*=s;
				po.toY*=s;
				po.toX+=movX;
				po.toY+=movY;	
			}
		}
		
		static private var debugBmd:Bitmap=new Bitmap;
		static private var tmpPerticle:Vector.<SimplePerticleObject>=new Vector.<SimplePerticleObject>;

		static public function debugDrawPalette(divX:int,divY:int,palette:Vecotr.<int>):void{
			if(!AppVals.DEBUG_MODE)return;
			var y:int;
			var x:int;
			var bmd:BitmapData=new BitmapData(divX,divY,true,0);	
			for(y=0;y<divY;y++){
				for(x=0;x<divX;x++){
					bmd.setPixel32(x,y,palette[y*divX+x]==1?0x990000FF:(palette[y*divX+x]==2?0x99FF0000:0x99FFFFFF));
				}
			}
			
			debugBmd.bitmapData=bmd;
			debugBmd.x=0;
			debugBmd.y=200;
			debugBmd.rotation=0;
			//debugBmd.rotation=rad/Math.PI*180;
			debugBmd.smoothing=false;
			debugBmd.width=divX*2;
			debugBmd.height=divY*2;
			AppVals.stage.addChild(debugBmd);
		}

	}
}