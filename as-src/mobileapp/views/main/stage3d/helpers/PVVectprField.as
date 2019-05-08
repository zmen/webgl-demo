package  utme.views.main.stage3d.helpers
{
	
	import flash.geom.Point;
	
	public class PVVectprField
	{
		
		private var _buffer:Vector.<Number>;
		
		private var cols:uint;
		private var rows:uint;
		private var cols_m1:uint;
		private var rows_m1:uint;
		private var width:Number;
		private var height:Number
		private var nTotal:uint;
		private var nTotalx2:uint;
		
		public var outX:Number;
		public var outY:Number;
		
		public function PVVectprField():void{
			
			
		}
		
		public function setupField( _cols:uint,  _rows:uint, _width:uint, _height:uint):void{
			cols    = _cols;
			rows    = _rows;
			cols_m1=cols-1;
			rows_m1=rows-1;
			
			width   = _width;
			height  = _height;	
			nTotal = cols * rows;
			nTotalx2=nTotal*2;
			
			dispose();
			_buffer=new Vector.<Number>;	
			for(var j:int = 0; j < nTotalx2; j++){
				_buffer.push(0);
			}
		}		
		public function dispose():void{
			if(_buffer)_buffer.length=0;
			_buffer=null;	
		}
		
		public function  clear():void{
			for (var i:int = 0; i < nTotalx2; i++){
				_buffer[i]=0;
			}	
		}
		
		public function fadeField( fadeAmount:Number):void{
			for (var i:int = 0; i < nTotalx2; i++){
				_buffer[i]*=fadeAmount;
			}
		}
		
		
		public function getIndexFor(xpos:Number,ypos:Number):int{
			
			var xPct:Number = xpos / width;
			var yPct:Number = ypos / height;
			
			if ((xPct < 0 || xPct > 1) || (yPct < 0 || yPct > 1)){
				return 0;
			}
			var fieldPosX:int = xPct * cols;
			var fieldPosY:int = yPct * rows;
			
			if(fieldPosX<0)fieldPosX=0;
			else if(fieldPosX>cols_m1)fieldPosX=cols_m1;
			
			if(fieldPosY<0)fieldPosY=0;
			else if(fieldPosY>rows_m1)fieldPosY=rows_m1;
			
			return fieldPosY * cols + fieldPosX;
		}
		
		public function getForceFromPosPoint( pos:Point):void{
			getForceFromPos(pos.x,pos.y);
		}
		/*
		public function getForceFromPos(xpos:Number, ypos:Number):void{
		var pos:int = getIndexFor(xpos,ypos);
		if (pos == 0){
		outX=0;
		outY=0;
		}else{
		outX=_buffer[pos*2] * 0.1;
		outY=_buffer[pos*2+1] * 0.1;
		}
		}
		*/
		private var fieldPosX:int;
		private var fieldPosY:int;
		private var mPos:int;
		
		public function getForceFromPos(xpos:Number, ypos:Number):void{
			
			xpos = xpos / width;
			ypos = ypos / height;
			
			if ((xpos < 0 || xpos > 1) || (ypos < 0 || ypos > 1)){
				outX=0;
				outY=0;
				return;
			}
			
			fieldPosX = xpos * cols;
			fieldPosY = ypos * rows;
			
			/*
			if(fieldPosX<0)fieldPosX=0;
			else if(fieldPosX>cols_m1)fieldPosX=cols_m1;
			if(fieldPosY<0)fieldPosY=0;
			else if(fieldPosY>rows_m1)fieldPosY=rows_m1;
			*/
			
			mPos = (fieldPosY * cols + fieldPosX)*2;
			outX=_buffer[mPos] * 0.1;
			outY=_buffer[mPos+1] * 0.1;
		}
		
		//------------------------------------------------------------------------------------
		public function addVectorCircle( x:Number,  y:Number,  vx:Number,  vy:Number,  radius:Number,  strength:Number):void{
			
			var fieldPosX:int		= x / width * cols;
			var fieldPosY:int		= y / height * rows;
			var fieldRadius:Number	= radius / width * cols;
			var startx:int	= fieldPosX - fieldRadius;
			var starty:int	= fieldPosY - fieldRadius;
			var endx:int	= fieldPosX + fieldRadius;
			var endy:int	= fieldPosY + fieldRadius;
			
			if(startx<0)startx=0;
			if(starty<0)starty=0;
			if(endx>cols)endx=cols;
			if(endy>rows)endy=rows;
			
			var i:int,j:int,pos:int,distance:Number;
			
			for (i = startx; i < endx; i++){
				for (j = starty; j < endy; j++){
					
					pos = (j * cols + i)*2;
					distance = Math.sqrt((fieldPosX-i)*(fieldPosX-i)+(fieldPosY-j)*(fieldPosY-j));
					
					if (distance < 0.0001) distance = 0.0001; 
					if (distance < fieldRadius){
						distance = 1.0 - (distance / fieldRadius);
						distance = strength * distance;
						_buffer[pos] += vx * distance;
						_buffer[pos+1] += vy * distance;
					}
				}
			}
		}
	}
}

