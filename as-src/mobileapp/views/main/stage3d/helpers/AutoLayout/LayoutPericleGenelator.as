package utme.views.main.stage3d.helpers.AutoLayout
{
	
	
	public class LayoutPericleGenelator
	{
	
		static public function generateTypgraphyLayouts(perticles:Vector.<perticleObject>,layouts:Vector.<LayoutObject>):void{
			var i:int;
			var t:int;
			var j:int;
			var v:Number;
			var y:Number=0;
			var marginX:Number=60;
			var marginY:Number=60;
			var MAX_WIDTH:Number=200;
			var MAX_HEIGHT:Number=7;
			var po:perticleObject;
			var lo:LayoutObject;
			
			var x:Number;
			var scale:Number;
			var angle:Number;
			var width:Number;
			var height:Number;
			var numlines:int;
			var tpo:SimplePerticleObject;
			var maxW:Number
			var maxH:Number
			
			var found:Boolean;
			var MAX_LINE:int;
			var ax:Number;
			var ay:Number;
			var cx:Number;
			var cy:Number;
			
			var rad:Number=0;
			var strechMode:Boolean;
			var addDecoration:Boolean;
			var vert:Boolean;
			var sizes:Vector.<Number>=new Vector.<Number>;
			
			var enableRotation:Boolean;
			var palette:Vector.<int>;
			var divX:int;
			var divY:int;
			var numH:int;
			var numW:int;
			var posX:int;
			var posY:int;
			var size:int;
			var yi:int;
			var xi:int;
			var checkTimes:Number;
			var vec:Boolean;
			var upLeft:Boolean;
			var kaburiNum:int;
			
			
			enableRotation=Math.random()<0.5; 
			palette=new Vector.<int>;
			
			
			divX=20+( 40*1.5-20)*_step;
			divY=25+( 50*1.5-20)*_step;
			MAX_WIDTH=divX*10;
			MAX_HEIGHT=divY*10;
			
			marginX=0;
			
			rad=Math.random()*Math.PI*.5 -Math.PI*0.25;
			if(Math.abs(rad/Math.PI*180)<15)rad=0;
			for(i=0;i<divX*divY;i++)palette.push(0);
			vec=rad>0;
			
			i=Math.floor(Math.random()*layouts.length);
			
			//trace("----");
			
			var objectNum:int=Math.max(layouts.length,2)+50*_step;
			var longlong:Boolean=false;
			for(j=0;j<objectNum;j++){
		
				lo=layouts[i];
				if(j==0){
					//初回文字
					size=lo.width/lo.height>1.2?2:3;
					vert=false;
					numH=1;
					for(t=0;t<size;t++)numH+=numH
					numW=Math.ceil(numH*lo.width/lo.height);
					scale=MAX_HEIGHT/Number(divY)*numH/lo.height;
					posX=(divX-numW)*.5;
					posY=(divY-numH)*.5;
					upLeft=true;
					size=1;
				}else{
					numH=0;
					numW=0;
					longlong=false;
					while(true){
						vert=enableRotation?Math.random()<0.5:false;//;
						numH=1;
						for(t=0;t<size;t++)numH+=numH
						numW=Math.ceil(numH*lo.width/lo.height);
						scale=MAX_HEIGHT/Number(divY)*numH/lo.height;
						if(vert){v=numH;numH=numW;numW=v;}
						if(numH>divY||numW>divX){
							longlong=true;
						}
						if(longlong){
							if(numH+1>divY||numW+1>divX){
								size--;
								if(size<0)goto CHK_NEXT;
							}else{
								size=Math.floor(Math.random()*2);
								break;
							}
						}else{
							if(numH*numW<4){
								size++;
							}else{
								size=Math.floor(Math.random()*2);
								break;
							}
						}
					}

					kaburiNum=0;
					checkTimes=0;
					{
						RE_CHECK:
						
						posX=1+Math.floor((divX-numW-2)*Math.random());
						posY=1+Math.floor((divY-numH-2)*Math.random());
						
						checkTimes++;
						if(checkTimes>500){
							continue;
						}
						for(y=posY;y<posY+numH;y++){
							for(x=posX;x<posX+numW;x++){
								if(palette[y*divX+x]){
									goto RE_CHECK;
								}
							}
						}
						kaburiNum=0;
						
						for(y=posY;y<posY+numH&&!found;y++){
							x=posX-1;
							if(palette[y*divX+x]==1){
								kaburiNum++;
								if(vert){
									upLeft=vec?false:true;
								}else{
									upLeft=true;
								}
							}
							x=posX+numW;
							if(palette[y*divX+x]==1){
								kaburiNum++;
								if(vert){
									upLeft=vec?false:true;
								}else{
									upLeft=false;
								}
							}
						}
						if(kaburiNum<2)
							for(x=posX;x<posX+numW&&!found;x++){
								y=posY-1;
								if(palette[y*divX+x]==1){
									kaburiNum++;
									if(vert){
										upLeft=true;
									}else{
										upLeft=true;
									}
								}
								y=posY+numH;
								if(palette[y*divX+x]==1){
									kaburiNum++;
									if(vert){
										upLeft=false;
									}else{
										upLeft=true;
									}
								}
							}
						if(kaburiNum<2)goto RE_CHECK;	
					}
				}
				
				//パレットにマーキング
				for(yi=posY;yi<posY+numH;yi++){
					for(xi=posX;xi<posX+numW;xi++){
						palette[yi*divX+xi]=1;
						if(vert){
							if(upLeft){
								if(yi==posY+numH-1)palette[yi*divX+xi]=2;
							}else{
								if(yi==posY)palette[yi*divX+xi]=2;
							}
						}else{
							if(upLeft){
								if(xi==posX+numW-1)palette[yi*divX+xi]=2;
							}else{
								if(xi==posX)palette[yi*divX+xi]=2;
							}
						}
					}
				}
				
				marginX=3;
				
				if(vert){
					x=posX/Number(divX)*MAX_WIDTH+lo.height*0.5*scale;
					scale*=(lo.height*scale-marginX)/(lo.height*scale);//margin for Y
					if(upLeft){
						y=posY/Number(divY)*MAX_HEIGHT+lo.width*0.5*scale+marginX*.5;	
					}else{
						y=(posY+numH)/Number(divY)*MAX_HEIGHT-lo.width*0.5*scale-marginX*.5;
					}
				}else{
					y=posY/Number(divY)*MAX_HEIGHT+lo.height*0.5*scale;
					scale*=(lo.height*scale-marginX)/(lo.height*scale);//margin for Y
					if(upLeft){
						x=posX/Number(divX)*MAX_WIDTH+lo.width*0.5*scale+marginX*.5;
					}else{
						x=(posX+numW)/Number(divX)*MAX_WIDTH-lo.width*0.5*scale-marginX*.5;
					}
				}
				
				angle=vert?(vec?-Math.PI*.5:Math.PI*.5):0;
				LayoutsHelper.addPerticleObject(perticles,layouts,i,x,y,scale,angle);
				CHK_NEXT:
				i++;
				if(i+1>layouts.length)i=0;	
			}
			
			LayoutsHelper.debugDrawPalette(divX,divY,palette);
			LayoutsHelper.fixLayouts(perticles,rad);
		}
		
		
		static public function generatePictLayouts2(perticles:Vector.<perticleObject>,layouts:Vector.<LayoutObject>):void{
			var i:int;
			var t:int;
			var j:int;
			var v:Number;
			var y:Number=0;
			var marginX:Number=60;
			var marginY:Number=60;
			var MAX_WIDTH:Number=200;
			var MAX_HEIGHT:Number=7;
			var po:perticleObject;
			var lo:LayoutObject;
			
			var x:Number;
			var scale:Number;
			var angle:Number;
			var width:Number;
			var height:Number;
			var numlines:int;
			var tpo:SimplePerticleObject;
			var maxW:Number
			var maxH:Number
			
			var found:Boolean;
			var MAX_LINE:int;
			var ax:Number;
			var ay:Number;
			var cx:Number;
			var cy:Number;
			
			var rad:Number=0;
			var strechMode:Boolean;
			var addDecoration:Boolean;
			var sizes:Vector.<Number>=new Vector.<Number>;
			
			var palette:Vector.<Boolean>;
			var divX:int;
			var divY:int;
			var numH:int;
			var numW:int;
			var posX:int;
			var posY:int;
			var size:int;
			var yi:int;
			var xi:int;
			var checkTimes:Number;
			var vec:Boolean;
			var kaburiNum:int;
			
			
			palette=new Vector.<Boolean>;
			
			var mw:Number=0;
			var mh:Number=0;
			
			
			
			for(i=0;i<layouts.length;i++){
				lo=layouts[i];
				mw=Math.max(mw,lo.width);
				mh=Math.max(mh,lo.height);
			}
			var aspect:Number= mw/mh;
			
			
			var widM:Boolean=mw>mh;
			var iaspect:int=Math.max(1, Math.round(widM?mw/mh:mh/mw));
			//trace(aspect,iaspect);
			
			divX=Math.max(20+( 40*1.5-20)*_step, widM?8*iaspect:0);
			divY=Math.max(25+( 50*1.5-20)*_step , widM?0: 8*iaspect);
			MAX_WIDTH=divX*10;
			MAX_HEIGHT=divY*10;
			
			marginX=0;
			
			rad=Math.random()*Math.PI*.5 -Math.PI*0.25;
			if(Math.abs(rad/Math.PI*180)<15)rad=0;
			for(i=0;i<divX*divY;i++)palette.push(0);
			vec=rad>0;
			
			i=Math.floor(Math.random()*layouts.length);
			
			//trace("----");
			
			var objectNum:int=Math.max(layouts.length,2)+30*_step;
			
			for(j=0;j<objectNum;j++){
				lo=layouts[i];
				if(j==0){
					//初回文字
					size=3;
					numH=1;
					for(t=0;t<size;t++)numH+=numH
					numW=Math.ceil(numH*lo.width/lo.height);
					scale=MAX_HEIGHT/Number(divY)*numH/lo.height;
					posX=(divX-numW)*.5;
					posY=(divY-numH)*.5;
					size=2;
				}else{
					numH=0;
					numW=0;
					while(numH*numW<4){
						numH=1;
						for(t=0;t<size;t++)numH+=numH
						numW=Math.ceil(numH*lo.width/lo.height);
						scale=MAX_HEIGHT/Number(divY)*numH/lo.height;
						if(numH*numW<4){
							size++;
						}else{
							size=Math.floor(Math.random()*3);
						}
					}
					
					kaburiNum=0;
					checkTimes=0;
					{
						RE_CHECK:
						
						posX=1+Math.floor((divX-numW-2)*Math.random());
						posY=1+Math.floor((divY-numH-2)*Math.random());
						
						checkTimes++;
						if(checkTimes>500){
							//trace("NOT FOUND")
							continue;
						}
						for(y=posY;y<posY+numH;y++){
							for(x=posX;x<posX+numW;x++){
								if(palette[y*divX+x]){
									goto RE_CHECK;
								}
							}
						}
						kaburiNum=0;
						
						for(y=posY;y<posY+numH&&!found;y++){
							x=posX-1;
							if(palette[y*divX+x]==1){
								kaburiNum++;
							}
							x=posX+numW;
							if(palette[y*divX+x]==1){
								kaburiNum++;
							}
						}
						if(kaburiNum<2)
							for(x=posX;x<posX+numW&&!found;x++){
								y=posY-1;
								if(palette[y*divX+x]==1){
									kaburiNum++;
								}
								y=posY+numH;
								if(palette[y*divX+x]==1){
									kaburiNum++;
								}
							}
						if(kaburiNum<2)goto RE_CHECK;	
					}
				}
				
				//パレットにマーキング
				for(yi=posY;yi<posY+numH;yi++){
					for(xi=posX;xi<posX+numW;xi++){
						palette[yi*divX+xi]=1;
					}
				}
				
				marginX=3;
				
		
				y=posY/Number(divY)*MAX_HEIGHT+lo.height*0.5*scale;
				x=posX/Number(divX)*MAX_WIDTH+lo.width*0.5*scale;
					scale*=(lo.height*scale-marginX)/(lo.height*scale);//margin for Y
				LayoutsHelper.addPerticleObject(perticles,layouts,i,x,y,scale,0);
				
				i++;
				if(i+1>layouts.length)i=0;	
			}
			
			LayoutsHelper.debugDrawPalette(divX,divY,palette);
			LayoutsHelper.fixLayouts(perticles,rad);
		}
		
		static public function generatePictLayouts2Single(perticles:Vector.<perticleObject>,layouts:Vector.<LayoutObject>):void{
			var i:int;
			var t:int;
			var j:int;
			var v:Number;
			var y:Number=0;
			var marginX:Number=60;
			var marginY:Number=60;
			var MAX_WIDTH:Number=200;
			var MAX_HEIGHT:Number=7;
			var po:perticleObject;
			var lo:LayoutObject;
			
			var x:Number;
			var scale:Number;
			var angle:Number;
			var width:Number;
			var height:Number;
			var numlines:int;
			var tpo:SimplePerticleObject;
			var maxW:Number
			var maxH:Number
			
			var found:Boolean;
			var MAX_LINE:int;
			var ax:Number;
			var ay:Number;
			var cx:Number;
			var cy:Number;
			
			var rad:Number=0;
			var strechMode:Boolean;
			var addDecoration:Boolean;
			var sizes:Vector.<Number>=new Vector.<Number>;
			
			var palette:Vector.<Boolean>;
			var divX:int;
			var divY:int;
			var numH:int;
			var numW:int;
			var posX:int;
			var posY:int;
			var size:int;
			var yi:int;
			var xi:int;
			var checkTimes:Number;
			var kaburiNum:int;
			
			
			palette=new Vector.<Boolean>;
			
			var mw:Number=0;
			var mh:Number=0;
			
			for(i=0;i<layouts.length;i++){
				lo=layouts[i];
				mw=Math.max(mw,lo.width);
				mh=Math.max(mh,lo.height);
			}
			var aspect:Number= mw/mh;
			
			
			var widM:Boolean=mw>mh;
			var iaspect:int=Math.max(1, Math.round(widM?mw/mh:mh/mw));
		//	trace(aspect,iaspect);
			
			divX=Math.max(20+( 40*1.5-20)*_step, widM?8*iaspect:0);
			divY=Math.max(25+( 50*1.5-20)*_step , widM?0: 8*iaspect);
			MAX_WIDTH=divX*10;
			MAX_HEIGHT=divY*10;
			
			marginX=0;
			
			rad=Math.random()*Math.PI*.5 -Math.PI*0.25;
			if(Math.abs(rad/Math.PI*180)<15)rad=0;
			for(i=0;i<divX*divY;i++)palette.push(0);

			
			i=Math.floor(Math.random()*layouts.length);
			
			//trace("----");
			
			var objectNum:int=Math.max(layouts.length,2)+30*_step;
			
			for(j=0;j<objectNum;j++){
				lo=layouts[i];
				if(j==0){
					//初回文字
					size=3;
					numH=1;
					for(t=0;t<size;t++)numH+=numH
					if(widM){
						numW=numH*iaspect;
					}else{
						numW=numH;
						numH=numW*iaspect;
					}
					scale=MAX_HEIGHT/Number(divY)*numH/lo.height;
					posX=(divX-numW)*.5;
					posY=(divY-numH)*.5;
					size=2;
				}else{
					numH=0;
					numW=0;
					while(numH*numW<4){
						numH=1;
						for(t=0;t<size;t++)numH+=numH
						if(widM){
							numW=numH*iaspect;
						}else{
							numW=numH;
							numH=numW*iaspect;
						}
						scale=MAX_HEIGHT/Number(divY)*numH/lo.height;
						if(numH*numW<4){
							size++;
						}else{
							size=Math.floor(Math.random()*3);
						}
					}
					
					kaburiNum=0;
					checkTimes=0;
					{
						RE_CHECK:
						
						posX=1+Math.floor((divX-numW-2)*Math.random());
						posY=1+Math.floor((divY-numH-2)*Math.random());
						
						checkTimes++;
						if(checkTimes>500){
							//trace("NOT FOUND")
							continue;
						}
						for(y=posY;y<posY+numH;y++){
							for(x=posX;x<posX+numW;x++){
								if(palette[y*divX+x]){
									goto RE_CHECK;
								}
							}
						}
						kaburiNum=0;
						
						for(y=posY;y<posY+numH&&!found;y++){
							x=posX-1;
							if(palette[y*divX+x]){
								kaburiNum++;
							}
							x=posX+numW;
							if(palette[y*divX+x]){
								kaburiNum++;
							}
						}
						if(kaburiNum<2)
							for(x=posX;x<posX+numW&&!found;x++){
								y=posY-1;
								if(palette[y*divX+x]){
									kaburiNum++;
								}
								y=posY+numH;
								if(palette[y*divX+x]){
									kaburiNum++;
								}
							}
						if(kaburiNum<2)goto RE_CHECK;	
					}
				}
				
				//パレットにマーキング
				for(yi=posY;yi<posY+numH;yi++){
					for(xi=posX;xi<posX+numW;xi++){
						palette[yi*divX+xi]=1;
					}
				}
				
				marginX=3;
				
				y=posY*10+numH*10*.5;
				x=(posX*10+numW*10*.5)*aspect*(widM?1.0/Number(iaspect):iaspect);
				//x=(posX+numW)/Number(divX)*MAX_WIDTH-lo.width*0.5*scale-marginX*.5;
				scale*=(lo.height*scale-marginX)/(lo.height*scale);//margin for Y

				angle=0;
				LayoutsHelper.addPerticleObject(perticles,layouts,i,x,y,scale,angle);
				
				i++;
				if(i+1>layouts.length)i=0;	
			}
			
			LayoutsHelper.debugDrawPalette(divX,divY,palette);
			LayoutsHelper.fixLayouts(perticles,rad);
		}
		
		
		
		static public function generatePictLayouts(perticles:Vector.<perticleObject>,layouts:Vector.<LayoutObject>):void{
			var i:int;
			var t:int;
			var j:int;
			var v:Number;
			var y:Number=0;
			var marginX:Number=60;
			var marginY:Number=60;
			var po:perticleObject;
			var lo:LayoutObject;
			
			var x:Number;
			var scale:Number;
			var angle:Number;
			var width:Number;
			var height:Number;
			var numlines:int;
			var tpo:SimplePerticleObject;
			var maxW:Number
			var maxH:Number
			
			var found:Boolean;
			var MAX_LINE:int;
			var ax:Number;
			var ay:Number;
			var cx:Number;
			var cy:Number;
			
			var rad:Number=0;
			var strechMode:Boolean;
			var addDecoration:Boolean;
			var sizes:Vector.<Number>=new Vector.<Number>;
			
			var palette:Vector.<int>;
			var divX:int;
			var divY:int;
			var numH:int;
			var numW:int;
			var posX:int;
			var posY:int;
			var size:int;
			var yi:int;
			var xi:int;
			var checkTimes:Number;
			var vec:Boolean;
			var kaburiNum:int;
			
			
			var mw:Number=0;
			var mh:Number=0;
			var defaultScale:Number=Number.MAX_VALUE;
			for(i=0;i<layouts.length;i++){
				lo=layouts[i];
				mw=Math.max(mw,lo.width);
				mh=Math.max(mh,lo.height);
			}
			
			for(i=0;i<layouts.length;i++){
				lo=layouts[i];
				defaultScale=Math.min(defaultScale,mw/lo.width);
				defaultScale=Math.min(defaultScale,mh/lo.height);
			}
			
			palette=new Vector.<int>;
			
			
			divX=1;
			divY=1;
			marginX=60;
			var iStep:int=Math.pow(_step,0.75)*20+Math.sqrt(layouts.length);
			for(i=0;i<iStep;i++){
				if(divX*mw<divY*mh){
					divX++;
				}else{
					divY++;
				}
			}			
			//trace("LAYOUT STAGE INFO:",divX,divY,mw,mh);
			for(i=0;i<divX*divY;i++)palette.push(0);
			

			marginX=Math.max(divX*mw,divY*mh)*0.02;
			
			rad=Math.random()*Math.PI*.5 -Math.PI*0.25;
			if(Math.abs(rad/Math.PI*180)<15)rad=0;
			rad=0;
			
			i=Math.floor(Math.random()*layouts.length);
			
			//trace("----");

			//startingSize:
			size=Math.min(divX,divY);
			size= Math.min(size<5?Math.ceil(size*.5)+(Math.ceil(size*.5)+1)*Math.random():1+((size-1)*0.8)*Math.random(),size);
			
			if(size>1&&size==divX&&size==divY)size--;
			
			checkTimes=0;
			
			while (size>1){
				lo=layouts[i];
				RECHECK_PICPOS:

				posX=Math.floor((divX-size+1)*Math.random());
				posY=Math.floor((divY-size+1)*Math.random());
				
				for(yi=posY;yi<posY+size;yi++){
					for(xi=posX;xi<posX+size;xi++){
						if(palette[yi*divX+xi]){
							checkTimes++;
							if(checkTimes>500){
								size--;
								checkTimes=0;
								if(size<2)goto ENDCHECK_PICPOS;
							}	
							goto RECHECK_PICPOS;
						};
					}
				}
				
				for(yi=posY;yi<posY+size;yi++){
					for(xi=posX;xi<posX+size;xi++){
						palette[yi*divX+xi]=1;
					}
				}
				scale=size*defaultScale
				x=posX*mw+mw*scale*.5;
				y=posY*mh+mh*scale*.5;
				
				{
					if(lo.width/(mw*scale)>lo.height/(mh*scale)){
						scale=(mw*scale)/lo.width;
						scale*=(lo.width*scale-marginX)/(lo.width*scale);
					}else{
						scale=(mh*scale)/lo.height;
						scale*=(lo.height*scale-marginX)/(lo.height*scale);
					}
				}
				LayoutsHelper.addPerticleObject(perticles,layouts,i,x,y,scale,rad);
			
				i++;
				if(i+1>layouts.length)i=0;	
			}
			ENDCHECK_PICPOS:
			
			//埋める
			for(yi=0;yi<divY;yi++){
				for(xi=0;xi<divX;xi++){
					if(!palette[yi*divX+xi]){
						lo=layouts[i];
						scale=defaultScale;
						x=xi*mw+mw*scale*.5;
						y=yi*mh+mh*scale*.5;
						
						{
							if(lo.width/(mw*scale)>lo.height/(mh*scale)){
								scale=(mw*scale)/lo.width;
								scale*=(lo.width*scale-marginX)/(lo.width*scale);
							}else{
								scale=(mh*scale)/lo.height;
								scale*=(lo.height*scale-marginX)/(lo.height*scale);
							}
						}
						LayoutsHelper.addPerticleObject(perticles,layouts,i,x,y,scale,rad);
						
						i++;
						if(i+1>layouts.length)i=0;
					}
				}
			}
			
			LayoutsHelper.debugDrawPalette(divX,divY,palette);
			LayoutsHelper.fixLayouts(perticles,0);
		}
		
		static private var flag:Boolean=false;;
		static public function generateLayout(perticles:Vector.<perticleObject>,layouts:Vector.<LayoutObject>,isTypography:Boolean,weakMode:Boolean):void{
			try{
				if(isTypography){
					generateTypgraphyLayouts(perticles,layouts);
				}else{
					if(flag){
						generatePictLayouts(perticles,layouts);
					}else{
						if(layouts.length==1){
							generatePictLayouts2Single(perticles,layouts);
						}else{
							generatePictLayouts2(perticles,layouts);
						}
					}
					flag=!flag;
				}
			}catch(e:Error){
				LayoutsHelper.fixLayouts(perticles,0);
				trace(e);
			}
			
			_step+=0.015*0.2;
			if(_step>1.0)_step=1.0;
			if(weakMode&&_step>0.05)_step=0.05;
			
		}
		
		static public var _step:Number=0;

		static public function layoutReset():void{
			_step=0;
		}

		
		
	}
}