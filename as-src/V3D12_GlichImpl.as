package utme.views.main.stage3d{
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import utme.app.managers.UTItemManager;
	import utme.app.consts.AppVals;
	import utme.views.main.remixViews.NV12_RemixGlitchView;
	import utme.app.managers.UTStampManager;
	import utme.views.main.stage3d.helpers.Stage3DHelper;

	
	public class V3D12_GlichImpl extends V3D19_RemixBaseImpl
	{
		
		private var mMom:NV12_RemixGlitchView;
		private var _addShapeLimit:Number;
		private var numLine:uint;
		private var mMainVerts:Vector.<Number>;
		private var mMainCoords:Vector.<Number>;
		private var mMainIndicies:Vector.<uint>;
		private var vertNum:uint;
		private var mTIndicies:IndexBuffer3D;
		private var mTVers:VertexBuffer3D;
		private var mTCoords:VertexBuffer3D;
		private var mainTexture:Texture;
		private var _srcBmd:BitmapData;
		private var indNum:uint;
		public var playing:Boolean;
		
		private var _isMotion:Boolean=false;
		private var centerX:Number
		private var _rad:Number=0;
		private var gliLines:Vector.<Number>
		private var _tx1:Number;
		private var _ty1:Number;
		private var _tx2:Number;
		private var _ty2:Number;		
		private var _tx3:Number;
		private var _ty3:Number;
		private var _tx4:Number;
		private var _ty4:Number;
		private var _range:Number=0;
		private const INIT_NUM_LINE:uint=7;
		public function V3D12_GlichImpl(mom:NV12_RemixGlitchView,_weakMode:Boolean){
			super(true,_weakMode);
			
			mMainVerts=new Vector.<Number>;
			mMainCoords=new Vector.<Number>;
			mMainIndicies=new Vector.<uint>;
			gliLines=new Vector.<Number>;
			
			
			playing=true;
			mMom=mom;
			_addShapeLimit=INIT_NUM_LINE;   //切出来的条数限制
			
			numLine=150;
			if(weakMode)numLine=20;
			
			vertNum=(numLine)*4;  //顶点数
			indNum=(numLine)*6;   //索引数
			
			
			for(var i:int=0;i<numLine;i++){  //每条的四个顶点和索引置为0，索引是为了drawtriangle
				mMainVerts.push(0);
				mMainVerts.push(0);
				mMainVerts.push(0);
				mMainVerts.push(0);
				mMainVerts.push(0);
				mMainVerts.push(0);
				mMainVerts.push(0);
				mMainVerts.push(0);
				mMainCoords.push(0);
				mMainCoords.push(0);
				mMainCoords.push(0);
				mMainCoords.push(0);
				mMainCoords.push(0);
				mMainCoords.push(0);
				mMainCoords.push(0);
				mMainCoords.push(0);
				mMainIndicies.push(0);
				mMainIndicies.push(0);
				mMainIndicies.push(0);
				mMainIndicies.push(0);
				mMainIndicies.push(0);
				mMainIndicies.push(0);
			}
			
			for(i=0;i<numLine;i++){  //drawtriangle的顶点索引顺序
				mMainIndicies[i*6  ]=i*4;
				mMainIndicies[i*6+1]=i*4+2;
				mMainIndicies[i*6+2]=i*4+1;
				mMainIndicies[i*6+3]=i*4+2;
				mMainIndicies[i*6+4]=i*4+3;
				mMainIndicies[i*6+5]=i*4+1;
			}
			
			
		}
		

		public override function initWithData(backBmd:BitmapData,srcBmd:BitmapData):void{
			addedForce(0,0);
			_srcBmd=srcBmd;
			super.init3D(backBmd,null);	
		}
		
		public override function dispose():void{
			_srcBmd=null;
			super.dispose();
		}
		
		
		protected override function setup():void{
			mFBO.dispose();
			mFBO= mCtx3D.createTexture(AppVals.TEXTURE_WIDTH/2 , AppVals.TEXTURE_WIDTH/2,Context3DTextureFormat.BGRA,true);
			
			mTCoords = mCtx3D.createVertexBuffer(vertNum, 2,Context3DBufferUsage.DYNAMIC_DRAW);
			mTVers = mCtx3D.createVertexBuffer(vertNum,2,Context3DBufferUsage.DYNAMIC_DRAW);
			
			mTIndicies=mCtx3D.createIndexBuffer(indNum);
			mTIndicies.uploadFromVector(mMainIndicies,0,indNum);  //加载顶点索引
			mTVers.uploadFromVector(mMainVerts, 0,vertNum);		  //加载顶点
			//UTItemManager.IMAGE_WIDTH==2048
			if(_srcBmd.width==AppVals.TEXTURE_WIDTH&&_srcBmd.height==AppVals.TEXTURE_WIDTH){
				mainTexture = Stage3DHelper.uploadTexture(mCtx3D,_srcBmd,Context3DTextureFormat.BGRA,false,false);
			}else{
				var _bmd:BitmapData=new BitmapData(AppVals.TEXTURE_WIDTH,AppVals.TEXTURE_WIDTH,true,0);
				var m:Matrix=new Matrix();
				m.scale((_bmd.width-2)/_srcBmd.width,(_bmd.height-2)/_srcBmd.height);
				m.translate(1,1);
				_bmd.draw(_srcBmd,m,null,null,null,true);
				mainTexture = Stage3DHelper.uploadTexture(mCtx3D,_bmd,Context3DTextureFormat.BGRA,false,true);
			}
			mTCoords.uploadFromVector(mMainCoords, 0,vertNum); //vertNum=numLine*4
			mTVers.uploadFromVector(mMainVerts, 0,vertNum);    //vertNum=numLine*4
		}
		//停止摇动或滑屏
		public function stop():void{
			playing=false;
			soundEnable=false;
			mMom.playStageChange(playing);  //显示停止（开始）按钮状态
		}
		//开始摇动或滑屏，playStagechange(boolean) 的功能是什么？
		public function start():void{
			playing=true;
			soundEnable=true;
			mMom.playStageChange(playing);   //显示停止（开始）按钮状态
		}
		//UTItemManager.IMAGE_WIDTH==2048
		protected override function draw():void{//显示切片摆动效果
			//if(!_bUpdated)return;
			mCtx3D.clear(0,0,0,0);
			mCtx3D.setProgram(mNoMipShader);
			mUniformMatrix[0] = UTItemManager.IMAGE_WIDTH*.5;
			mUniformMatrix[1] = UTItemManager.IMAGE_HEIGHT*.5;
			mUniformMatrix[2] = 0;
			mUniformMatrix[3] = 1;
			mUniformColor[0] = 1;
			mUniformColor[1] = 1;
			mUniformColor[2] = 1;
			
			if(playing){
				var i:int;
				var v1:Number;
				var v2:Number;
				var _vx1:Number;
				var _vy1:Number;
				var _vx2:Number;
				var _vy2:Number;
				var _r1:Number;
				var _r2:Number;
				var _px1:Number;
				var _py1:Number;
				var _px2:Number;
				var _py2:Number;	
				_r1=Math.random()*_range-_range*.5;     //-_range*.5到_range*.5随机产生的左右摆动距离；
				for(i=0;i<numLine;i++){        //numline是切片数量，对每一个切片进行如下处理
					
					v1=gliLines[i];            //i/Number(numLine);
					v2=gliLines[i+1];          //(i+1)/Number(numLine);
					//下面是切块晃动时的上面两个顶点坐标
					_vx1=_tx1+(_tx3-_tx1)*v1;
					_vy1=_ty1+(_ty3-_ty1)*v1;
					_vx2=_tx2+(_tx4-_tx2)*v1;
					_vy2=_ty2+(_ty4-_ty2)*v1;
					//r1和r2应该是这一个切片摆动的两个幅度，产生切片晃动后的伸长和压缩效果
					_r1=(Math.pow(Math.random(),3))*_range*1*(_r1==0?(Math.random()<0.5?1:-1):(_r1<0?1:-1));
					_r2=_r1;     //Math.random()*_range-_range*.5;
					
					if(_r1>0){
						_r2+=Math.random()*_range*0.25;
					}else{
						_r1-=Math.random()*_range*0.25;
					}

					if(weakMode){
						_r1*=0.1;
						_r2*=0.1;
					}
					
					if(v2-v1>0.1&&_addShapeLimit<20)_r1=_r2=0;   //？
					
					_px1=(_vx2-_vx1)*_r1;
					_py1=(_vy2-_vy1)*_r1;
					_px2=(_vx2-_vx1)*_r2;
					_py2=(_vy2-_vy1)*_r2;
					//原来的图像切块，晃动后的四个顶点坐标（晃动时左右有变形）
					mMainCoords[i*8  ]=_tx1+(_tx3-_tx1)*v1+_px1;
					mMainCoords[i*8+1]=_ty1+(_ty3-_ty1)*v1+_py1;
					mMainCoords[i*8+2]=_tx2+(_tx4-_tx2)*v1+_px2;
					mMainCoords[i*8+3]=_ty2+(_ty4-_ty2)*v1+_py2;
					
					mMainCoords[i*8+4]=_tx1+(_tx3-_tx1)*v2+_px1;
					mMainCoords[i*8+5]=_ty1+(_ty3-_ty1)*v2+_py1;
					mMainCoords[i*8+6]=_tx2+(_tx4-_tx2)*v2+_px2;
					mMainCoords[i*8+7]=_ty2+(_ty4-_ty2)*v2+_py2;
					
				}
				//加载晃动后的顶点集合
				mTCoords.uploadFromVector(mMainCoords, 0,vertNum);
				mTVers.uploadFromVector(mMainVerts, 0,vertNum);
				
				if(_isMotion){//切片是否还在摆动？
					if(_range<0.002){//range是切片移动的幅度，<0.002则停止
						_range=0;
						_addShapeLimit=INIT_NUM_LINE;
						_isMotion=false;
						mMom.motionStateChange(_isMotion);
					}else{
						_range*=0.986;//摆动幅度每次衰减0.014
					}
				}
			}else{
				if(!_isMotion)start();
			}
			//加载和显示
			mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mUniformColor);
			mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mUniformMatrix);
			mCtx3D.setVertexBufferAt(0, mTVers, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setVertexBufferAt(1, mTCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
			mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
			mCtx3D.setTextureAt(0, mainTexture);
			mCtx3D.drawTriangles(mTIndicies);
			mCtx3D.setProgram(mMipShader);
			
		}
		

		
		protected override function addedForce(_x:Number,_y:Number):void{  //(pos_x-mPrevMouseX)*1.2,(pos_y-mPrevMouseY)*1.2)
			if(!playing)return;	
			if(_x!=0||_y!=0){//判断手机是否摇动或者手指滑屏，x，y应该是加速器两个坐标轴的位移
				
				mMom.motionStateChange(_isMotion);
				_addShapeLimit+=0.03; //？
				if(_addShapeLimit>numLine)_addShapeLimit=numLine;//切片数量限制为numLine
				//trace(Math.sqrt(_x*_x+_y*_y),_range);
				if(Math.sqrt(_x*_x+_y*_y)>50||!_isMotion){
					_rad=Math.atan2(-_y,_x);   //计算晃动角度
					if(Math.random()<0.2)gliLines.length=0;
				}
				_range+=Math.sqrt(_x*_x+_y*_y)/UTItemManager.IMAGE_WIDTH*0.25;//range是摆动幅度
				if(!mMom.showingStopAlert&&_range>0.3)mMom.showStopAlert(); //超过一定摆动幅度，显示暂停按钮
				_isMotion=true;
			}
			var divY:Number=UTItemManager.IMAGE_HEIGHT/Number(numLine);
			var width:Number = (UTItemManager.IMAGE_HEIGHT*0.5 + UTItemManager.IMAGE_WIDTH*0.5)*2;  //？
			centerX=width*.5;  //？
			
			var r:Number=_rad+Math.PI*0.25;	//原有的弧度+45度
			//计算centerX在rad+135度，45度，225度，-135度的顶点坐标，也就是原来画布坐标轴四个最大点，进行旋转
			var _x1:Number=Math.cos(r+Math.PI*0.5)*centerX;
			var _y1:Number=-Math.sin(r+Math.PI*0.5)*centerX;
			var _x2:Number=Math.cos(r)*centerX;
			var _y2:Number=-Math.sin(r)*centerX;
			var _x3:Number=Math.cos(r+Math.PI)*centerX;
			var _y3:Number=-Math.sin(r+Math.PI)*centerX;
			var _x4:Number=Math.cos(r-Math.PI*0.5)*centerX;
			var _y4:Number=-Math.sin(r-Math.PI*0.5)*centerX;
			//重置旋转后的画布范围
			var tw:Number= (width/Math.sqrt(2)) / UTItemManager.IMAGE_WIDTH*.5;
			var th:Number= (width/Math.sqrt(2)) / UTItemManager.IMAGE_HEIGHT*.5;
			
			var r2:Number=_rad;
			var sin:Number=Math.sin(r2);
			var cos:Number=Math.cos(r2);
			//这是哪四个点的坐标？旋转后画布扩大后的四个顶点？（坐标范围？）这些点在draw里做什么用？
			_tx1=0.5 -tw*cos-tw*sin;
			_ty1=0.5 +(-tw*sin+tw*cos)*th/tw;	
			_tx2=0.5 +tw*cos-tw*sin;	
			_ty2=0.5 +(+tw*sin+tw*cos)*th/tw;		
			_tx3=0.5 -tw*cos+tw*sin;	
			_ty3=0.5 +(-tw*sin-tw*cos)*th/tw;	
			_tx4=0.5 +tw*cos+tw*sin;	
			_ty4=0.5 +(+tw*sin-tw*cos)*th/tw;	
			
			
			
			var i:int;
			//太さランダム//随机检索
			//gliLines.length=0;
			gliLines.push(0);
			while(gliLines.length <numLine )gliLines.push(1);
			//while(gliLines.length <_addShapeLimit )gliLines.push(Math.random());
			
			for(i=1;i<numLine;i++){
				if(i<_addShapeLimit){          //addShapeLimit是摆动的切片数量限制
					if(gliLines[i]==1)gliLines[i]=Math.random();	
				}else{
					gliLines[i]=1;
				}
			}
			
			////消す//擦除
			gliLines.sort(Array.NUMERIC);
			
			//把_addShapeLimit数量多余的删除掉，包括gliLines[i]==1的	
			for(i=1;i<gliLines.length;){
				if(gliLines[i]-gliLines[i-1]<5/width){
					gliLines.splice(i,1);    //把gliLines[i]从数组中删除
				}else{
					i++;
				}
			}
			while(gliLines.length <numLine)gliLines.push(1);
			/////最後
			gliLines.push(1);	
			
			for(i=0;i<numLine;i++){//每个切片四个顶点坐标，对应旋转后画布的矩形块；
			                       //前面_addShapeLimit块会发生位移，后面的则不会，位移带有形变
				var y:Number=divY*i;
				var y2:Number=divY*(i+1);
				var v1:Number=gliLines[i];//i/Number(numLine);
				var v2:Number=gliLines[i+1];//(i+1)/Number(numLine);
				//产生晃动效果
				mMainVerts[i*8  ]=_x1+(_x3-_x1)*v1;
				mMainVerts[i*8+1]=_y1+(_y3-_y1)*v1;
				mMainVerts[i*8+2]=_x2+(_x4-_x2)*v1;
				mMainVerts[i*8+3]=_y2+(_y4-_y2)*v1;
				mMainVerts[i*8+4]=_x1+(_x3-_x1)*v2;
				mMainVerts[i*8+5]=_y1+(_y3-_y1)*v2;
				mMainVerts[i*8+6]=_x2+(_x4-_x2)*v2;
				mMainVerts[i*8+7]=_y2+(_y4-_y2)*v2;
			}
		}

		public override function captureToBitmap(bmd:BitmapData):void{ 
			if(_isMotion||blendMode==BlendMode.ERASE){
				mFBO.dispose();
				mFBO= mCtx3D.createTexture(AppVals.TEXTURE_WIDTH , AppVals.TEXTURE_WIDTH,Context3DTextureFormat.BGRA,true);
				
				mCtx3D.setRenderToTexture(mFBO,false,4);
				mCtx3D.clear(0,0,0,0);
				mCtx3D.setProgram(mNoMipShader);
				mUniformMatrix[0] = UTItemManager.IMAGE_WIDTH*.5;
				mUniformMatrix[1] = UTItemManager.IMAGE_HEIGHT*.5;
				mUniformMatrix[2] = 0;
				mUniformMatrix[3] = 1;
				mUniformColor[0] = 1;
				mUniformColor[1] = 1;
				mUniformColor[2] = 1;
				mTCoords.uploadFromVector(mMainCoords, 0,vertNum);
				mTVers.uploadFromVector(mMainVerts, 0,vertNum);
				mCtx3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mUniformColor);
				mCtx3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mUniformMatrix);
				mCtx3D.setVertexBufferAt(0, mTVers, 0, Context3DVertexBufferFormat.FLOAT_2);
				mCtx3D.setVertexBufferAt(1, mTCoords, 0, Context3DVertexBufferFormat.FLOAT_2);
				mCtx3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mFBOMatrix, true);
				mCtx3D.setTextureAt(0, mainTexture);
				mCtx3D.drawTriangles(mTIndicies);
				mCtx3D.setProgram(mMipShader);
				
				super.captureToBitmap(bmd);
			}else{
				if(_bmdBackImage!=null&& !UTStampManager.getActiveLayerTop())bmd.copyPixels(_bmdBackImage,_bmdBackImage.rect,new Point(0,0));
				var bm:String=blendMode==BlendMode.ALPHA?null:blendMode;
				var ct:ColorTransform=blendMode==BlendMode.ALPHA? new ColorTransform(1,1,1,0.6):null;
				bmd.draw(_srcBmd,null,ct,bm);
			}
		} 
		
		public override function clear():void{
			_rad=0;
			_addShapeLimit=INIT_NUM_LINE;
			_range=0;
			addedForce(0,0)
			super.clear();
			start();
			mMom.playStageChange(playing);
		}	
	}	
}