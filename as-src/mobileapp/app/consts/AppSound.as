package utme.app.consts
{
	import com.kentaroid.air.AndroidSupport;
	
	import flash.events.MouseEvent;
	import flash.media.AudioPlaybackMode;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	
	import jp.uniqlo.utlab.assets.sound.click01;
	import jp.uniqlo.utlab.assets.sound.click02;
	import jp.uniqlo.utlab.assets.sound.click03;
	import jp.uniqlo.utlab.assets.sound.click04;
	import jp.uniqlo.utlab.assets.sound.click05;
	
	public class AppSound
	{
		
		SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
		
		public static function checkSoundEnable():Boolean{
			return AndroidSupport.RingerMode==2;
		}
		
		private static var sounds:Vector.<Sound>=Vector.<Sound>([new click01,new click02,new click03,new click04,new click05]);
		
		public static function onSound(e:MouseEvent):void{
			if(!checkSoundEnable())return;
			
			//trace(e.currentTarget.name);
			
			if(e.currentTarget.name.indexOf("stampCell")>-1){
				sounds[3].play();
				return;
			}
			if(e.currentTarget.name.indexOf("stampObj")>-1){
				sounds[2].play();
				return;
			}
			if(e.currentTarget.name.indexOf("itemCell")>-1){
				return;
			}
			if(e.currentTarget.name.match(/shape[0-9]+Btn|filter[0-9]+Btn|style[0-9]+Btn|report[0-9]+Btn/)){
				sounds[2].play();
				return;
			}
			
			switch(e.currentTarget.name){
				//進むときのクリック音ポジティブ
				case "reportBtn":
				case "drawingBtn":
				case "typographyBtn":
				case "libraryBtn":
				case "inkBtn":
				case "glitchBtn":
				case "particleBtn":
				case "okBtn":
				case "startBtn":
				case "skipBtn":
				case "nextBtn":
				case "cellBtn":
				case "stampBtn":
				case "noEffectBtn":
				case "layoutBtn":
				case "moma01Btn":
				case "moma02Btn":

				case "addLayerBtn":
				
				case "createBtn":
				case "timelineBtn":
				case "marketBtn":
				case "mypageBtn":
				case "agreeBtn":
				case "linkBtn":
				case "reloadBtn":
				case "albumBtn":
				case "cameraBtn":
					
					sounds[0].play();
					break;
				
				//アイテム選択ボタン
				

				case "blendNormalBtn":
				case "blendAlphaBtn":
				case "blendScreenBtn":
				case "blendMultiBtn":
				case "blendMaskBtn":

				case "alignLeftBtn":
				case "alignCenterBtn":
				case "alignRightBtn":
					
				case "alignLeftBtn":
				case "alignCenterBtn":
				case "alignRightBtn":
				case "alignLeftBtn":
				case "alignCenterBtn":
				case "alignRightBtn":
					
				case "postBtn":					
				case "mosic3Btn":
				case "mosic2Btn":
				case "mosic1Btn":

					sounds[2].play();
					break;		
				//開く 決定
				case "searchBtn":
				case "likeBtn":
				case "optionBtn":
				case "searchBtn":
				case "cartBtn":

				case "cropCompleteBtn":

				
				case "shareBtn":
				case "upMarketBtn":	
				case "buyBtn":
					
				case "photoBtn":
				case "keyBtn":
				case "editBtn":	
				case "saveBtn":
					
				case "postedListBtn":
				case "savedListBtn":
				case "tutorialBtn":
				case "utwebBtn":
				case "utappBtn":
				case "termBtn":
				case "memberBtn":	
				case "policyBtn":
				case "myAccountBtn":
				case "helpBtn":
				case "settingsBtn":		

				case "aboutBtn":
				case "stampSelectBtn":
				case "stampListBtn":
				case "stampDetailBtn":
				case "faqBtn":
				case "guidelineBtn":
				case "regulationBtn":
				case "licenceBtn":
				case "aboutStampBtn":
				
				case "saveSetBtn":
				case "saveRollBtn":
				
				case "groupBtn":
				case "funcBtn":
				case "addBtn":
					
				case "okGroupAddBtn":
				case "disableStampMarketBtn":
				case "uploadMarketBtn":
				case "removeMarketBtn":
				case "itemEditBtn":
				case "itemDeleteBtn":
				case "twitterBtn":
				case "facebookBtn":
				case "copyBtn":
					
					
					sounds[3].play();
					break;
				//閉じる、キャンセル
				
				case "deleteBtn":
				case "editEndBtn":	
				case "keyHideBtn":
				case "closeBtn":
				case "endBtn":
				case "storeEndBtn":
					sounds[4].play();
					
					break;
				//DISABLE プログラム制御するボタン
				case "moma01StyleBtn":
				case "moma02StyleBtn":
				case "filterBtn":	
				case "zoomBtn":
				case "scaleBtn":
				case "stopBtn":
				case "menuBtn":
				case "cancelBtn":
				case "eraseBtn":
				case "blendBtn":
				case "colorBtn":
				case "alignBtn":
				case "mosaicBtn":
				case "copylightBtn":
				case "fontBtn":
				case "restartBtn":
				case "resetBtn":
				case "baseBtn":
				case "tagBtn":
					
				case "fontStyle1Btn":
				case "fontStyle2Btn":
				case "fontStyle3Btn":
				case "font1Btn":
				case "font2Btn":
				case "font3Btn":
				case "font4Btn":
				case "cropShapeBtn":
				case "agreeBtn":
					break;
				
				default:
					//戻るときのクリック音ネガティブ
					sounds[1].play();
					break;
				
			}
		}
		
		
		
		public static function playSound(index:int):void{
			if(index<sounds.length&&checkSoundEnable())sounds[index].play();
		}
	}
}