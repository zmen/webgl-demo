package utme.app
{
	import flash.display.MovieClip;
	
	import utme.app.consts.AppStoryDefs;
	import utme.app.consts.AppVals;
	import utme.app.managers.FileManager;
	import utme.app.managers.UTStampManager;
	import utme.views.common.classes.AppDisplayState;
	import utme.views.main.common.INavigatedView;
	import utme.views.main.menuViews.NV01_GraphicListView;
	import utme.views.main.menuViews.NV02_GraphicListOneView;
	import utme.views.main.menuViews.NV20_DesignCompleteView;
	import utme.views.main.srcViews.stampSubViews.NV55_StampSetListView;

	public class UTCreateMain
	{
		//createViewManager------------------------------------------------------------------------------
		public static var viewTree:Vector.<INavigatedView>=new Vector.<INavigatedView>;	
		public static function saveFoward():void{
			//一つ前のRemixEndはSaveしない
			for(var i:int=viewTree.length-3;i>-1;i--){
				viewTree[i].save(i);
			}
		}
		
		public static function getActiveSrcType():int{
			for(var i:int=viewTree.length-1;i>-1;i--){
				switch( AppStoryDefs.getViewID(viewTree[i])){
					case AppStoryDefs.VIEW_SRC_PAINT:
					case AppStoryDefs.VIEW_SRC_TYPO:
					case AppStoryDefs.VIEW_SRC_STAMP:
					case AppStoryDefs.VIEW_SRC_PHOTO:
						return  AppStoryDefs.getViewID(viewTree[i]);
				}
			}
			return 0;
		}
		
		public static function getActiveSrcView():INavigatedView{
			for(var i:int=viewTree.length-1;i>-1;i--){
				switch( AppStoryDefs.getViewID(viewTree[i])){
					case AppStoryDefs.VIEW_SRC_PAINT:
					case AppStoryDefs.VIEW_SRC_TYPO:
					case AppStoryDefs.VIEW_SRC_STAMP:
					case AppStoryDefs.VIEW_SRC_PHOTO:
						return  viewTree[i];
				}
			}
			return null;
		}
		
		public static function getActiveView():INavigatedView{
			return viewTree[viewTree.length-1];
		}
		
		
		public static function isBaseViewOnRoot(v:INavigatedView):Boolean{
			return ((v is NV01_GraphicListView)&&(v as NV01_GraphicListView).isRoot)||
					((v is NV02_GraphicListOneView)&&(v as NV02_GraphicListOneView).isRoot);
		}
		public static function isBaseView(v:INavigatedView):Boolean{
			return (v is NV01_GraphicListView)||(v is NV02_GraphicListOneView);
		}
		
		
		public static function getStoryPair():Array{
			var ret:Array=[];
			for(var i:int=viewTree.length-1;i>0;i--){
				var vi:uint=AppStoryDefs.getViewID(viewTree[i]);
				if(vi>0){
					ret.push(vi);
				}
				if(isBaseView(viewTree[i])||viewTree[i] is NV20_DesignCompleteView)break;
			}
			return ret.reverse();
		}
		
		public static function getParent(mom:INavigatedView):INavigatedView{
			for(var i:int=viewTree.length-1;i>0;i--){
				if(mom==viewTree[i])break;
			}
			return i>0?viewTree[i-1]:null;
		}
		
		public static function navigateViewTo(newView:INavigatedView):void{
			viewTree.push(newView);
			AppMain.startTransition(newView,true,isBaseViewOnRoot(newView) &&!AppVals.APPLICATION_NO_MARKET_MODE);
		}
		
		public static var momView:INavigatedView;
		public static function openFromLoadView(newView:INavigatedView,mom:INavigatedView):void{
			momView=mom;
			viewTree.push(newView);
			AppMain.startTransition(newView,true,false);
		}
		
		public static function popBackView():void{
			var newView:INavigatedView;
			var isTab:Boolean;
			if(viewTree.length>1){
				newView=viewTree[viewTree.length-2];
				isTab=isBaseViewOnRoot(newView)  &&!AppVals.APPLICATION_NO_MARKET_MODE;
			}else{
				newView=momView;
				momView=null;
				isTab=true;
			}
			var diposeView:INavigatedView=viewTree.pop();
			AppMain.startTransition(newView,false,isTab);
			(diposeView as MovieClip).removeChildren();
			AppDisplayState.removeBtnState(diposeView as MovieClip);
			diposeView.dispose();
			diposeView=null;
		}
		
		public static function popBackToRootView():void{
			popBackToRootReady();
			popBackView();
		}
				
		public static function popBackToRootReady():void{
			var v:Vector.<INavigatedView>=viewTree.splice(1,viewTree.length-2);
			for(var i:int=0;i<v.length;i++){
				(v[i] as MovieClip).removeChildren();
				AppDisplayState.removeBtnState(v[i] as MovieClip);
				v[i].dispose();
				v[i]=null;
			}
			v.length=0;
			v=null;
			AppVals.Story.length=0;
		}
		
		public static function clearFowardStampListView():void{
			if(viewTree.length>2&& viewTree[viewTree.length-2] is NV55_StampSetListView){
				var v:Vector.<INavigatedView>=viewTree.splice(viewTree.length-2,1);
				for(var i:int=0;i<v.length;i++){
					(v[i] as MovieClip).removeChildren();
					AppDisplayState.removeBtnState(v[i] as MovieClip);
					v[i].dispose();
					v[i]=null;
				}
				v.length=0;
				v=null;
			}
		}
		
		public static function closeAllView():void{
			for(var i:int=0;i<viewTree.length;i++){
				(viewTree[i] as MovieClip).removeChildren();
				AppDisplayState.removeBtnState(viewTree[i] as MovieClip);
				viewTree[i].dispose();
				viewTree[i]=null;
			}
			viewTree.length=0;
			
			AppVals.HISTORY=0;
			UTStampManager.removeAllSet();
			AppVals.Story.length=0;
			FileManager.clearCache(false);
		
		}
		
		//createViewManager------------------------------------------------------------------------------
	}
}