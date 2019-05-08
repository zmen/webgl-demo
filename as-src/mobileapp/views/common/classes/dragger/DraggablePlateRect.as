package utme.views.common.classes.dragger
{
	public class DraggablePlateRect{
		
		//元に戻ろうとする力　: 有効
		//props
		public var backToRatateZero:Boolean=true;
		public var backToOrgPosition:Boolean=true;
		
		public var pos_x:Number;
		public var pos_y:Number;
		public var rad:Number;
		
		//メッシュ表示
		//vals
		protected var _width:Number;
		protected var _height:Number;
		private var _dragging:Boolean;
		
		private var _updateTime:Number;

		protected var _lockState:Boolean=false;
		public var limitRotateMinRad:Number=0;
		public var limitRotateMaxRad:Number=0;
		
		protected var _bAllocated:Boolean=false;
		
		private var _dragPos_x:Number;
		private var _dragPos_y:Number;
		private var _orgPos_y:Number;
		private var _orgPos_x:Number;
		private var _activeForce_x:Number;
		private var _activeForce_y:Number;
		protected var _lastDragPos_x:Number;
		protected var _lastDragPos_y:Number;
		
		
		protected var _wk1_x:Number;
		protected var _wk1_y:Number;
		protected var _wk2_x:Number;
		protected var _wk2_y:Number;
		
		public function DraggablePlateRect(){
			_orgPos_x=0;
			_orgPos_y=0;
			pos_x=0;
			pos_y=0;
			_activeForce_x=0;
			_activeForce_y=0;
			_lastDragPos_x=0;
			_lastDragPos_y=0;
			_dragPos_x=0;
			_dragPos_y=0;
		}
		
		public function setup(orign_x:Number, orign_y:Number,orgRad:Number,aWidth:Number,aHeight:Number):void{
					
			_orgPos_x=orign_x;
			_orgPos_y=orign_y;
			_activeForce_x=0;
			_activeForce_y=0;
			
			_width=aWidth;
			_height=aHeight;
			pos_x=orign_x;
			pos_y=orign_y;
			rad=orgRad;
			
			_lastDragPos_x=0;
			_lastDragPos_y=0;
			_dragPos_x=0;
			_dragPos_y=0;
			
			_updateTime=0;
			_dragging=false;			
			_bAllocated=true;
		}
		
		
		//ラジアン正規化 inline
		private function REG_RAD(val:Number):Number {
			while(val>Math.PI)val-=Math.PI*2;
			while(val<-Math.PI)val+=Math.PI*2;
			return val;
		}
		
		protected function calcDragPos(_x:Number,_y:Number):void{
			var va:Number,vb:Number,vs:Number,vm:Number,r:Number,vl:Number;
			_dragPos_x=_x;
			_dragPos_y=_y;
			_wk1_x=_lastDragPos_x -pos_x;
			_wk1_y=_lastDragPos_y -pos_y;
			_wk2_x=_dragPos_x -pos_x;
			_wk2_y=_dragPos_y -pos_y;
			vl=Math.sqrt(_wk1_x*_wk1_x+_wk1_y*_wk1_y);
			va=Math.atan2(_wk1_y,_wk1_x);
			vb=Math.atan2(_wk2_y,_wk2_x);
			vs=va-rad;
			vm=vb-va;
			r=Math.min(1.0,vl/(Math.sqrt(_width*_width+_height*_height)*.5)) ;
			r=1-Math.sin((1.0-r)*Math.PI*0.5);
			if(_lockState)r=0;
			vm=REG_RAD(vm);
			rad=rad + vm * r ;
			
			if(!_lockState&&limitRotateMinRad<limitRotateMaxRad){
				rad=REG_RAD(rad);
				if(rad<limitRotateMinRad)rad=limitRotateMinRad;
				if(rad>limitRotateMaxRad)rad=limitRotateMaxRad;
			}
			
			pos_x=_dragPos_x-vl*Math.cos(rad+vs);
			pos_y=_dragPos_y-vl*Math.sin(rad+vs);
			rad=REG_RAD(rad);
			_lastDragPos_x=_dragPos_x;
			_lastDragPos_y=_dragPos_y;
		}
		

		protected var _updated:Boolean;
		public function update():void{
			
			if(!_bAllocated)return;
			if(!_dragging){
				if(Math.sqrt(_activeForce_x*_activeForce_x+_activeForce_y*_activeForce_y)>0.5){
					calcDragPos(_dragPos_x+_activeForce_x,_dragPos_y+_activeForce_y);
					_activeForce_x*=0.9;
					_activeForce_y*=0.9;
				}
			}
			
			_updated=false;
			if(backToRatateZero&&rad!=0){
				rad*=0.95;
				if(Math.abs(rad)<0.001)rad=0;
				_updated=true;
			}
			if(backToOrgPosition&&!_dragging){
				if(pos_x!=_orgPos_x){
					pos_x=pos_x+(_orgPos_x-pos_x)*0.2;
					if(Math.abs(pos_x-_orgPos_x)<0.1)pos_x=_orgPos_x;
					_updated=true;	
				}
				if(pos_y!=_orgPos_y){
					pos_y=pos_y+(_orgPos_y-pos_y)*0.2;
					if(Math.abs(pos_y-_orgPos_y)<0.1)pos_y=_orgPos_y;
					_updated=true;	
				}
			}
		}
		
		public function drag(_x:Number,_y:Number,aDragging:Boolean,needLock:Boolean):void{
			_lockState=needLock;
			if(!aDragging){
				if(_dragging){
					_dragging=false;
					if(_updateTime!=(new Date()).getTime() ){
						_activeForce_x=0;
						_activeForce_y=0;
					}
				}
				return;
			}
			if(!_dragging){
				_lastDragPos_x=_x;
				_lastDragPos_y=_y;
				_dragging=true;
				return;
			}
			_updateTime=(new Date()).getTime();
			_activeForce_x=_x-_lastDragPos_x;
			_activeForce_y=_y-_lastDragPos_y;
			calcDragPos(_x,_y);
		}
	}
}

