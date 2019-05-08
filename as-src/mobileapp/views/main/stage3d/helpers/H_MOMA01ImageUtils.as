package utme.views.main.stage3d.helpers
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import utme.views.main.stage3d.helpers.objects.Vec4;

	public class H_MOMA01ImageUtils
	{
		
		static public function clampi(x:int,min:int,max:int):int{
			return x<min?min:(x>max?max:x);
		}
		static public function clampf(x:Number,min:Number,max:Number):Number{
			return x<min?min:(x>max?max:x);
		}
		
		static public function blrImage(_src:BitmapData , size:int):void{
			var  px:int,py:int;
			var rad:int;
			var x:int,y:int,p:int,i:int;
			
			
			px=_src.width;
			py=_src.height;
			
			rad = size;
			
			var Wm:int=rad*2;		//窓幅
			var Rm:int=(Wm-1)/2;	//窓半径
			var msk:Vector.<Number>=new Vector.<Number>;
			msk.length=Wm;
			var su:Number=0;
			
			for(x=0;x<Wm;x++){
				msk[x]=Math.sin(Math.PI*(x+1)/(Wm+1));
				su+=msk[x];
			}
			
			for(x=0;x<Wm;x++)msk[x]=msk[x]/su;
			
			
			var tempPix:Vector.<Number>=new Vector.<Number>;
			tempPix.length=px*py*3;
			
			var out:ByteArray=new ByteArray;
			out.length=px*py*4;
			var src:ByteArray=_src.getPixels(_src.rect);
			var r:Number,g:Number,b:Number;
			
			for(y=0;y<py;y++) {
				for(x=0;x<px;x++){
					r=0;
					g=0;
					b=0;
					for(i=0;i<Wm;i++){
						p=clampi(x+i-Rm,0,px-1);
						r+=src[(y*px+p)*4+1]*msk[i];
						g+=src[(y*px+p)*4+2]*msk[i];
						b+=src[(y*px+p)*4+3]*msk[i];
					}
					tempPix[(x*py+y)*3]=r;
					tempPix[(x*py+y)*3+1]=g;
					tempPix[(x*py+y)*3+2]=b;
				}
			}
			
			
			for(y=0;y<py;y++){
				for(x=0;x<px;x++){
					r=0;
					g=0;
					b=0;
					for(i=0;i<Wm;i++){
						p=clampi(y+i-Rm,0,py-1);
						r+=tempPix[(x*py+p)*3]*msk[i];
						g+=tempPix[(x*py+p)*3+1]*msk[i];
						b+=tempPix[(x*py+p)*3+2]*msk[i];
					}
					out [(y*px+x)*4]=255;
					out [(y*px+x)*4+1]=r;
					out [(y*px+x)*4+2]=g;
					out [(y*px+x)*4+3]=b;
					
				}
			}
			
			_src.setPixels(_src.rect,out);
			tempPix.length=0;
			tempPix=null;
			out.length=0;
			out=null;
			src.length=0;
			src=null;
			msk.length=0;
			msk=null;
		}
		
		static private function getByIndex(i:int):Vec4{
			var ret:Vec4=new Vec4;
			switch (i){
				case 0:ret.x=-1;ret.y=-1;break;
				case 1:ret.x=0;ret.y=-1;break;
				case 2:ret.x=1;ret.y=-1;break;
				case 3:ret.x=-1;ret.y=0;break;
				case 4:ret.x=1;ret.y=0;break;
				case 5:ret.x=-1;ret.y=1;break;
				case 6:ret.x=0;ret.y=1;break;
				case 7:ret.x=1;ret.y=1;break;
			}
			return ret;
		}
		
		static public function calcOpticalFlow(_src:BitmapData):void{
			
			blrImage(_src,2);
			
			var px:int,py:int;
			var rad:int;
			var x:int,y:int,p:int,i:int;
			var index:int;
			var cx:Number,cy:Number,cz:Number;
			var dx:Number,dy:Number,dz:Number;
			
			//var v:Number[8];
			//int _x,_y;
			px=_src.width;
			py=_src.height;
			
			var src:ByteArray=_src.getPixels(_src.rect);
			
			var r:Number,g:Number,b:Number;
			var _r:Number,_g:Number,_b:Number;
			var _v:Number;
			
			
			var idx:int;
			var out:ByteArray=new ByteArray;
			out.length=px*py*4;
			
			var fv:Vec4;
			
			var lim:Vector.<Number>=new Vector.<Number>;
			lim.length=8;
			var maxi:Number;
			var mini:Number;
			var max:Number;
			var min:Number;
			
			for(y=0;y<py;y++) {
				for(x=0;x<px;x++){
					p=(y*px+x)*4;
					_r=src[p+1];
					_g=src[p+2];
					_b=src[p+3];
					
					 maxi=0;
					 mini=0;
					 max=000.0;
					 min=255.0;
					
					for(i=0;i<8;i++){
						fv=getByIndex(i);
						p=(clampi(y+fv.y,0,py-1)*px+clampi(x+fv.x,0,px-1))*4;
						lim[i] = ( 0.298912 * src[p] + 0.586611 * src[p+1] + 0.114478 * src[p+2] );
					}
					
					fv.y=(lim[5]+lim[6]+lim[7])/3.0-(lim[0]+lim[1]+lim[2])/3.0;
					fv.x=(lim[2]+lim[4]+lim[7])/3.0-(lim[0]+lim[3]+lim[5])/3.0;
					fv.rotate2d(90);
					fv.normalize();
					fv.multiply(10);
					
					out[(y*px+x)*4]=0;
					out[(y*px+x)*4+1]=clampi(fv.x+127,0,255);
					out[(y*px+x)*4+2]=clampi(fv.y+127,0,255);
					out[(y*px+x)*4+3]=0;
					
				}
			}
			_src.setPixels(_src.rect,out);
			blrImage(_src,5);
		}
		
		
		static public function blrByteArray3(_src:ByteArray,width:int,height:int,size:int):void{
			var  px:int,py:int;
			var rad:int;
			var x:int,y:int,p:int,i:int;
			px=width;
			py=height;
			rad = size;
			
			var Wm:int=rad*2;		//窓幅
			var Rm:int=(Wm-1)/2;	//窓半径
			var msk:Vector.<Number>=new Vector.<Number>;
			msk.length=Wm;
			var su:Number=0;
			
			for(x=0;x<Wm;x++){
				msk[x]=Math.sin(Math.PI*(x+1)/(Wm+1));
				su+=msk[x];
			}
			
			for(x=0;x<Wm;x++)msk[x]=msk[x]/su;
			var tempPix:Vector.<Number>=new Vector.<Number>;
			tempPix.length=px*py*3;
			var r:Number,g:Number,b:Number;
			
			for(y=0;y<py;y++) {
				for(x=0;x<px;x++){
					r=0;
					g=0;
					b=0;
					for(i=0;i<Wm;i++){
						p=clampi(x+i-Rm,0,px-1);
						r+=_src[(y*px+p)*3+0]*msk[i];
						g+=_src[(y*px+p)*3+1]*msk[i];
						b+=_src[(y*px+p)*3+2]*msk[i];
					}
					tempPix[(x*py+y)*3]=r;
					tempPix[(x*py+y)*3+1]=g;
					tempPix[(x*py+y)*3+2]=b;
				}
			}
			for(y=0;y<py;y++){
				for(x=0;x<px;x++){
					r=0;
					g=0;
					b=0;
					for(i=0;i<Wm;i++){
						p=clampi(y+i-Rm,0,py-1);
						r+=tempPix[(x*py+p)*3]*msk[i];
						g+=tempPix[(x*py+p)*3+1]*msk[i];
						b+=tempPix[(x*py+p)*3+2]*msk[i];
					}
					_src [(y*px+x)*3]=r;
					_src [(y*px+x)*3+1]=g;
					_src [(y*px+x)*3+2]=b;		
				}
			}
			tempPix.length=0;
			tempPix=null;
			msk.length=0;
			msk=null;
		}

		static public function blrByteArray2(_src:ByteArray,width:int,height:int,size:int):void{
			var  px:int,py:int;
			var rad:int;
			var x:int,y:int,p:int,i:int;
			
			px=width;
			py=height;
			rad = size;
			var Wm:int=rad*2;		//窓幅
			var Rm:int=(Wm-1)/2;	//窓半径
			var msk:Vector.<Number>=new Vector.<Number>;
			msk.length=Wm;
			var su:Number=0;
			
			for(x=0;x<Wm;x++){
				msk[x]=Math.sin(Math.PI*(x+1)/(Wm+1));
				su+=msk[x];
			}
			for(x=0;x<Wm;x++)msk[x]=msk[x]/su;
			var tempPix:Vector.<Number>=new Vector.<Number>;
			tempPix.length=px*py*2;
			var r:Number,g:Number;
			
			for(y=0;y<py;y++) {
				for(x=0;x<px;x++){
					r=0;
					g=0;
					for(i=0;i<Wm;i++){
						p=clampi(x+i-Rm,0,px-1);
						r+=_src[(y*px+p)*2]*msk[i];
						g+=_src[(y*px+p)*2+1]*msk[i];
					}
					tempPix[(x*py+y)*2]=r;
					tempPix[(x*py+y)*2+1]=g;
				}
			}
			for(y=0;y<py;y++){
				for(x=0;x<px;x++){
					r=0;
					g=0;
					for(i=0;i<Wm;i++){
						p=clampi(y+i-Rm,0,py-1);
						r+=tempPix[(x*py+p)*2]*msk[i];
						g+=tempPix[(x*py+p)*2+1]*msk[i];
					}
					_src [(y*px+x)*2]=r;
					_src [(y*px+x)*2+1]=g;
				}
			}
			
			tempPix.length=0;
			tempPix=null;
			msk.length=0;
			msk=null;
		}		
		
		static public function blrByteArray1(_src:ByteArray,width:int,height:int,size:int):void{
			var  px:int,py:int;
			var rad:int;
			var x:int,y:int,p:int,i:int;
			
			px=width;
			py=height;
			rad = size;
			var Wm:int=rad*2;		//窓幅
			var Rm:int=(Wm-1)/2;	//窓半径
			var msk:Vector.<Number>=new Vector.<Number>;
			msk.length=Wm;
			var su:Number=0;
			
			for(x=0;x<Wm;x++){
				msk[x]=Math.sin(Math.PI*(x+1)/(Wm+1));
				su+=msk[x];
			}
			for(x=0;x<Wm;x++)msk[x]=msk[x]/su;
			var tempPix:Vector.<Number>=new Vector.<Number>;
			tempPix.length=px*py*2;
			var r:Number;
			
			for(y=0;y<py;y++) {
				for(x=0;x<px;x++){
					r=0;
					for(i=0;i<Wm;i++){
						p=clampi(x+i-Rm,0,px-1);
						r+=_src[(y*px+p)]*msk[i];
					}
					tempPix[(x*py+y)]=r;
				}
			}
			for(y=0;y<py;y++){
				for(x=0;x<px;x++){
					r=0;
					for(i=0;i<Wm;i++){
						p=clampi(y+i-Rm,0,py-1);
						r+=tempPix[(x*py+p)]*msk[i];
					}
					_src [(y*px+x)]=r;
				}
			}
			
			tempPix.length=0;
			tempPix=null;
			msk.length=0;
			msk=null;
		}	
		
		
		static public function calcOpticalFlowByteArray(_src:BitmapData):ByteArray{
			
			var px:int,py:int;
			var x:int,y:int,p:int,i:int;
			px=_src.width;
			py=_src.height;
			
			
			var _copy:ByteArray=_src.getPixels(_src.rect);
			var src:ByteArray=new ByteArray;
			src.length=px*py;
			trace(1);
			var al:Number;
			for(y=0;y<py;y++) {
				for(x=0;x<px;x++){
					p=(y*px+x)*4;
					src[y*px+x]=( 0.298912 * _copy[p+1] + 0.586611 * _copy[p+2] + 0.114478 * _copy[p+3]);
				}
			}
			trace(2);
			
			blrByteArray1(src,px,py,2);
			trace(3);
	
			var out:ByteArray=new ByteArray;
			out.length=px*py*2;
			
			trace(4);

			var fv:Vec4=new Vec4;
			var lim:Vector.<Number>=new Vector.<Number>;
			lim.length=8;
			
			for(y=0;y<py;y++) {
				for(x=0;x<px;x++){
					for(i=0;i<8;i++){
						switch (i){
							case 0:fv.x=-1;fv.y=-1;break;
							case 1:fv.x=0;fv.y=-1;break;
							case 2:fv.x=1;fv.y=-1;break;
							case 3:fv.x=-1;fv.y=0;break;
							case 4:fv.x=1;fv.y=0;break;
							case 5:fv.x=-1;fv.y=1;break;
							case 6:fv.x=0;fv.y=1;break;
							case 7:fv.x=1;fv.y=1;break;
						}
						p=(clampi(y+fv.y,0,py-1)*px+clampi(x+fv.x,0,px-1));
						lim[i] = src[p];
					}
					fv.y=(lim[5]+lim[6]+lim[7])/3.0-(lim[0]+lim[1]+lim[2])/3.0;
					fv.x=(lim[2]+lim[4]+lim[7])/3.0-(lim[0]+lim[3]+lim[5])/3.0;
					if(fv.length()>0){
						fv.rotate2d(90);
					}else{
						fv.x=Math.random()-0.5;
						fv.y=Math.random()-0.5;
					}
					fv.normalize();
					fv.multiply(10);
					out[(y*px+x)*2]=clampi(fv.x+127,0,255);
					out[(y*px+x)*2+1]=clampi(fv.y+127,0,255);					
				}
			}
			trace(5);
			blrByteArray2(out,px,py,5);	
			return out;
		}
	}
}