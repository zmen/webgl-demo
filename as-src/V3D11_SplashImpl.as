package utme.views.main.stage3d
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	
	import jp.uniqlo.utlab.assets.images.TextureParticle01;
	import jp.uniqlo.utlab.assets.images.TextureParticle02;
	import jp.uniqlo.utlab.assets.images.TextureParticle03;
	import jp.uniqlo.utlab.assets.images.TextureParticle04;
	import jp.uniqlo.utlab.assets.images.TextureParticle05;
	import jp.uniqlo.utlab.assets.images.TextureParticle06;
	import jp.uniqlo.utlab.assets.images.TextureParticle07;
	
	import utme.app.managers.UTItemManager;
	import utme.views.main.stage3d.helpers.PVParticle;
	import utme.views.main.stage3d.helpers.Stage3DHelper;
	
	public class V3D11_SplashImpl extends V3D19_RemixBaseImpl
	{
		private var mParticles:Vector.<PVParticle>;
		private var mColorBmd:BitmapData;
		
		private var mTexParts:Vector.<Texture>;
		
		private var mColorRandRange:Number=0.3;
		private var mFudeSize:Number=5;  //笔刷尺寸
		private var mSrcImage:BitmapData;
		
		public function V3D11_SplashImpl(_weakMode:Boolean){
			super(false,_weakMode);
			
			mParticles=new Vector.<PVParticle>;
			
		}
		public override function initWithData(backBmd:BitmapData,srcBmd:BitmapData):void{  //显示初始图像
			mColorBmd=new BitmapData(UTItemManager.IMAGE_WIDTH*0.05,UTItemManager.IMAGE_HEIGHT*0.05,true,0);
			var m2:Matrix=new Matrix;
			m2.scale(mColorBmd.width/Number(srcBmd.width),mColorBmd.height/Number(srcBmd.height));
			mColorBmd.draw(srcBmd,m2,null,null,null,false);
			mSrcImage=srcBmd;
			super.init3D(backBmd,srcBmd);
		}
		
		public override function dispose():void{
			
			mSrcImage=null;
			
			mParticles.length=0;
			mColorBmd.dispose();
			mColorBmd=null;
			
			for(var i:int=0;i<mTexParts.length;i++){
				mTexParts[i].dispose();
			}
			mTexParts.length=0;
			mTexParts=null;
			super.dispose();
		}
		
		protected override function setup():void{
			mTexParts=null;
			mTexParts=new Vector.<Texture>;
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle01, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle02, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle03, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle04, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle05, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle06, Context3DTextureFormat.BGRA,true,true));
			mTexParts.push(Stage3DHelper.uploadTexture(mCtx3D,new TextureParticle07, Context3DTextureFormat.BGRA,true,true));
		}
		
		protected override function draw():void{     //显示Splash效果
			mCtx3D.setVertexBufferAt(0, mVerts, 0, Context3DVertexBufferFormat.FLOAT_2);  
			mCtx3D.setVertexBufferAt(1, mCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
			
			var part:PVParticle;
			var ac:int=-1;
			var num:uint=mParticles.length;
			for(var i:int=0;i<num;){  //对所有的画点
				part=mParticles[i];
				if(part.posX-part.scale*.55>0&&
					part.posY-part.scale*.55>0&&
					part.posX+part.scale*.55<UTItemManager.IMAGE_WIDTH&&
					part.posY+part.scale*.55<UTItemManager.IMAGE_HEIGHT
				){   //如果喷溅点整体落在画布内
					
					if(!(part.flg&&Math.random()>0.7)){  //大颗粒要按随机概率喷
						
						if(ac!=part.texIndex){  //设置画点的纹理
							mCtx3D.setTextureAt(0, mTexParts[part.texIndex]);
							ac=part.texIndex
						}
						
						mUniformMatrix[0] = part.posX+(Math.random()*1-0.5)*part.scale*.06;
						mUniformMatrix[1] = part.posY+(Math.random()*1-0.5)*part.scale*.06;
						mUniformMatrix[3] = part.scale*(Math.random()*0.4+0.8);
						
						if(part.flg||Math.random()<0.1){   //颜色按随机按颗粒是否飞溅进行变浅或者加深，part.flg标志是否飞溅出去的颗粒
							mUniformColor[3]=Math.random();
							mUniformColor[0]     = part.r*mUniformColor[3] ;
							mUniformColor[1]     = part.g*mUniformColor[3] ;
							mUniformColor[2]     = part.b*mUniformColor[3] ;
						}else{   //否则颜色不变
							mUniformColor[0]     = part.r ;
							mUniformColor[1]     = part.g ;
							mUniformColor[2]     = part.b ;
							mUniformColor[3]=1;
							
						}
						
						mUniformMatrix[2] = part.flg?Math.random()*100:part.angle; //大部分颗粒的纹理设置固定角度
																					//飞溅出去的颗粒的纹理按角度进行处理
						mUniformMatrix[3] = part.scale;
						mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mUniformColor);
						mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mUniformMatrix);
						mCtx3D.drawTriangles(mIndicies);
					}
				}
				if(part.life>0){
					part.update();
					i++;
				}else{  //把life为0的画点，从数组中删除
					mParticles.splice(i,1);
					num--;
				}
			}
			
			mUniformColor[3]     = 1 ;
			
		}
		
		protected override function addedForce(_x:Number,_y:Number):void{  //mousedrag调用该方法
			
			mWeakCounter++
			if(weakMode&&mWeakCounter>100)return;
			
			var pos_x:Number;
			var pos_y:Number;
			var vel_x:Number=-_x*1.3;
			var vel_y:Number=-_y*1.3;
			
			
			
			var pw:Number;
			var mActiveColor:uint;
			var strength:Number=0.2+Math.min(mFudeSize,Math.sqrt(vel_x*vel_x+vel_y*vel_y)/50.0);//喷溅强度，和笔划粗细及摇动强度相关
			var v:int=Math.max(Math.sqrt(vel_x*vel_x+vel_y*vel_y),10.0);  //晃动速度
			
			//if(weakMode){
			//	if(strength>1.2)strength=1.2;
			//}
			
			var pR_x:Number,pR_y:Number;
			var f:Number,c:Number;
			
			//trace(strength);
			var alphaPower:Number;
			var alpha:int;
			for(var i:int=0;i<v;i++){	//随机v个随机点（数），和晃动速度相关
				for(var cl:int=0;cl<50;cl++){  //找到一个透明度大于1的点
					pos_y=Math.random()*UTItemManager.IMAGE_HEIGHT;
					pos_x=Math.random()*UTItemManager.IMAGE_WIDTH;
					mActiveColor=mColorBmd.getPixel32(  
						pos_x/UTItemManager.IMAGE_WIDTH*(UTItemManager.IMAGE_WIDTH*0.05-1),
						(UTItemManager.IMAGE_HEIGHT-pos_y)/UTItemManager.IMAGE_HEIGHT*(UTItemManager.IMAGE_HEIGHT*0.05-1));
					alpha=(mActiveColor>>24 & 0xFF);
					if(alpha>0)break;
				}
				if(alpha<1)return;  //alpha通道值是0-255的数，
				
				alphaPower=Math.pow( alpha/255.0,5);
				if(alphaPower<1.0)alphaPower*=0.5;  //计算alpha通道值
				
				var r:int=Math.random()*1000;
				var part:PVParticle =new PVParticle;
				
				part.angle=Math.random()*720;
				part.flg=false;
				
				var  color:uint;
				if(Math.random()<0.1){   在小概率情况下，变换颜色
					var coladd:int=(Math.random()*mColorRandRange-mColorRandRange*.5)*255;
					var _colorR:int =( (mActiveColor >> 16) & 0xFF) + coladd;
					var _colorG:int =( (mActiveColor >>  8) & 0xFF) + coladd;
					var _colorB:int =( (mActiveColor >>  0) & 0xFF) + coladd;
					
					_colorR=_colorR<0?0:(_colorR>255?255:_colorR);
					_colorG=_colorG<0?0:(_colorG>255?255:_colorG);
					_colorB=_colorB<0?0:(_colorB>255?255:_colorB);
					
					color=(_colorR << 16) | (_colorG << 8) | (_colorB);//RGB的拼接，
				}else{   //大概率情况下，颜色不变
					color=mActiveColor;
				}
				
				part.r = ((color >> 16) & 0xFF)/255.0;
				part.g = ((color >> 8) & 0xFF)/255.0;
				part.b = ((color >> 0) & 0xFF)/255.0;
				
				pR_x=Math.random()*100-50;
				pR_y=Math.random()*100-50;
				//pR.normalize(1);
				f=Math.sqrt(pR_x*pR_x+pR_y*pR_y);
				pR_x/=f;   //将pR_x, pR_y缩小为-1/根号2--1/根号2之间
				pR_y/=f;
				c=Math.random()*50-25;
				pR_x*=c;  //放大
				pR_y*=c;
				
				if(r<10){  //很少的概率下，1%以内，让颗粒飞溅出去，设置很小的颗粒半径
					//小粒　飛距離大
					//continue;
					part.scale=Math.pow(Math.random(),0.3)*2.0*strength*alphaPower*(weakMode?0.3:1.0); //颗粒直径
					part.texIndex=Math.random()*6;
					if(part.texIndex==2)part.texIndex=6;
					part.setInitialCondition( pos_x+Math.random()*400-200 , pos_y+Math.random()*400-200,0,0,0);//喷溅位置和方向
					//part.texIndex=1;
				}else if(r<20){  ////很少的概率下，1%，让颗粒飞溅较近，半径涉及稍大
					//大粒　飛距離小
					//continue;
					part.scale=Math.pow(Math.random(),0.3)*4.0*strength*alphaPower*(weakMode?0.3:1.0);  //颗粒直径
					part.texIndex=Math.random()*6;
					if(part.texIndex==2)part.texIndex=6;
					part.setInitialCondition( pos_x+Math.random()*100-50 , pos_y+Math.random()*100-50,0,0,0);//喷溅位置和方向
					//part.texIndex=1;
				}else if(r<30){
					//continue;
					pw=(Math.random()*0.7+0.3)*0.5*alphaPower*strength*(weakMode?0.3:1.0);
					part.scale=(Math.random()*0.5+1.0)*alphaPower*strength*(weakMode?0.3:1.0);  //颗粒直径
					part.setInitialCondition( pos_x+pR_x , pos_y+pR_y, vel_x*pw, vel_y*pw,weakMode?10:30);//喷溅位置和方向
					part.texIndex=0;
					part.flg=Math.random()<0.8;//随机喷溅
				}else{  //大概率下，颗粒飞溅效果弱，但方向和晃动方向保持一致
					//continue;
					//通常の弱いストローク//通常较弱的形成
					pw=Math.pow(Math.random(),2)*0.3*alphaPower*(weakMode?0.3:1.0);
					part.setInitialCondition(  pos_x+pR_x , pos_y+pR_y,vel_x*pw, vel_y*pw,weakMode?3:10); //飞溅方向和坐标设置
					part.texIndex=Math.random()<0.8?0:2;//Math.random()<0.5?0:Math.random()*7;
					part.scale=(Math.random()*1.6+0.4)*alphaPower*strength*(weakMode?0.3:1.0);  //颗粒直径
					part.flg=part.texIndex==0&&pw<0.2?false:true;//part.texIndex>0;//随机喷溅
				}
				
				
				
				//texScaleは解像度fetch
				part.scale*= 20;//颗粒直径放大
				mParticles.push(part);  //将颗粒压栈
				
				if(mParticles.length>500){  //如果颗粒超过500，随机删除一个，最多500个飞溅颗粒
					var cc:int=Math.random()*250;
					mParticles.splice(cc,1);
				}
			}
		}
		private var mWeakCounter:Number=0; 
		public override function clear():void{
			mWeakCounter=0;
			mParticles.length=0;
			super.clear();
		}
	}
}