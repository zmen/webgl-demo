package utme.views.main.remixViews
{
	import flash.events.MouseEvent;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Cubic;
	import org.libspark.betweenas3.tweens.ITween;
	
	import utme.app.NSFuncs.UTUtils;
	import utme.app.consts.AppSound;
	import utme.app.managers.UTStampManager;
	import utme.views.main.stage3d.V3D12_GlichImpl;
	
	public class NV12_RemixGlitchView extends NV19_RemixBaseView{
		
		private var _closing:Boolean;
		private var _closingStatePlay:Boolean;
		public var showingStopAlert:Boolean=false;

		
		public function NV12_RemixGlitchView(){
			super();
			viewName="Gritch"
				
			_impl=new V3D12_GlichImpl(this,UTStampManager.getActive()!=null&&UTStampManager.getActive().RemixGlitch==2);
			
			motionStateChange(false);
			_closingStatePlay=false;
		}
		
		public function motionStateChange(motion:Boolean):void{
			UTUtils.buttonStatus(stopBtn,motion);
			if(!motion)hideStopAlert()
		}
		
		public override  function viewWillAppear(isNew:Boolean):void{
			stopAlert.alpha=0;
			super.viewWillAppear(isNew);
			if(blendSet){
				if(stopAlert.cache_left.parent)stopAlert.removeChild(stopAlert.cache_left);
			}else{
				if(stopAlert.cache_center.parent)stopAlert.removeChild(stopAlert.cache_center);
			}
		}
		
		public override function onStart():void{
			stopBtn.addEventListener(MouseEvent.CLICK,_stopPlayBtn_Touchup);
			super.onStart();
			if(_closingStatePlay)(_impl as V3D12_GlichImpl).start();
			_closing=false;
		}
		
		
		public override function viewWillDisappear():void{		
			stopBtn.removeEventListener(MouseEvent.CLICK,_stopPlayBtn_Touchup);
			super.viewWillDisappear();
		}	
		
		private function _stopPlayBtn_Touchup(e:MouseEvent):void{
			if(e!=null){
				if((_impl as V3D12_GlichImpl).playing){
					AppSound.playSound(2);
				}else{
					AppSound.playSound(3);
				}
			}
			if((_impl as V3D12_GlichImpl).playing){
				(_impl as V3D12_GlichImpl).stop();
			}else{
				(_impl as V3D12_GlichImpl).start();
			}
		}

		public function playStageChange(playing:Boolean):void{
			if(_closing)return;
			stopBtn.playIcon.visible=!playing;
			stopBtn.stopIcon.visible=playing;
			if(!playing)hideStopAlert()
		}
		
		public override function _okBtn_Touchup(e:MouseEvent):void{
			_closing=true;
			_closingStatePlay=(_impl as V3D12_GlichImpl).playing;
			if(_closingStatePlay)(_impl as V3D12_GlichImpl).stop();
			super._okBtn_Touchup(e);
		}
		
		public override function _backBtn_Touchup(e:MouseEvent):void{
			_closing=true;
			_closingStatePlay=(_impl as V3D12_GlichImpl).playing;
			if(_closingStatePlay)(_impl as V3D12_GlichImpl).stop();
			super._backBtn_Touchup(e);
		}
				
		private var _tween4:ITween;
		
		public function showStopAlert():void{
			showingStopAlert=true;
			if(_tween4!=null)_tween4.stop();
			_tween4 = BetweenAS3.tween(stopAlert,{ alpha:1},null,0.5,org.libspark.betweenas3.easing.Cubic.easeOut);
			_tween4.onComplete=function():void{_tween4=null;}
			_tween4.play();
		}
		
		public function hideStopAlert():void{
			if(showingStopAlert){
				if(_tween4!=null)_tween4.stop();
				_tween4 = BetweenAS3.tween(stopAlert,{ alpha:0},null,0.5,org.libspark.betweenas3.easing.Cubic.easeOut);
				_tween4.onComplete=function():void{_tween4=null;}
				_tween4.play();
				showingStopAlert=false;
			}
		}
		
		/*
		public override function _blendBtn_Touchup(e:MouseEvent):void{
			_closing=true;
			_closingStatePlay=(_impl as V3D12_GlichImpl).playing;
			if(_closingStatePlay)(_impl as V3D12_GlichImpl).stop();
			super._blendBtn_Touchup(e);
		}
		
		public override function _blendClose_Touchup(e:MouseEvent):void{
			if(_closingStatePlay)(_impl as V3D12_GlichImpl).start();
			_closing=false;
			super._blendClose_Touchup(e);
		}
		*/
		
		public override function setBlendMode(isOpen:Boolean,name:String):void{
			if(isOpen){
				_closing=true;
				_closingStatePlay=(_impl as V3D12_GlichImpl).playing;
				if(_closingStatePlay)(_impl as V3D12_GlichImpl).stop();
			}else{
				if(_closingStatePlay)(_impl as V3D12_GlichImpl).start();
				_closing=false;
			}
			super.setBlendMode(isOpen,name);
		}

	}
}