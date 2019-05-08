package utme.app.consts
{
	import com.adobe.crypto.SHA256;
	
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import jp.uniqlo.utlab.assets.Tkeys;
	import jp.uniqlo.utlab.assets.TkeysD;
	
	import utme.app.NSFuncs.UTCapabilities;
	import utme.app.NSFuncs.UTDeviceCapabilities;
	
	public class AppURI
	{
		//ホワイトリスト
		public static const URL_AUTH_TWITTER_WHITELIST:RegExp=/twitter.com|api\/callback_from_twitter_for_mobile|api\/tw_redirect|auth\/twitter|authorization\/twitter|twitter_for_mobile/;
		public static const URL_AUTH_FACEBOOK_WHITELIST:RegExp=/facebook.com|api\/callback_from_facebook_for_mobile|api\/fb_redirect|auth\/facebook|authorization\/facebook|facebook_for_mobile/;
	
		private static const URL_APP_DOMAIN:String=AppVals.DEBUG_MODE_SERVER?"http://52.68.136.226/":"http://utme.uniqlo.com/";
		public static const URL_API_DOMAIN:String=AppVals.DEBUG_MODE_SERVER?"http://54.92.57.202/":"https://utme.uniqlo.com/";
		public static const _URL_DOMAIN_RANGE:RegExp=new RegExp(AppVals.DEBUG_MODE_SERVER?"\/54.92.57.202\/\\w+\/front\/|\/52.68.136.226\/m\/":"\/utme.uniqlo.com\/\\w+\/front\/|\/utme.uniqlo.com\/m\/");
		
		private static const URL_UTMEAPP_DOWNLOAD_IOS:String="https://itunes.apple.com/app/id860285444";
		private static const URL_UTMEAPP_DOWNLOAD_ANDROID:String="https://play.google.com/store/apps/details?id=air.com.uniqlo.utme";
		public static const URL_UTMEAPP_DOWNLOAD:String=UTDeviceCapabilities.isIOS()?URL_UTMEAPP_DOWNLOAD_IOS:URL_UTMEAPP_DOWNLOAD_ANDROID;
		
		public static const _URL_UNIQLO_APP:String=(UTDeviceCapabilities.isIOS()?"redirect/appstore/?lng=%s":"redirect/googleplay/?lng=%s");		
		
		///////////////////////////////////
		
		public static const URL_DESIGN_OWNER:String="URL_DESIGN_OWNER";

	
		public static const URL_MATERIAL_DESIGNS:String="URL_MATERIAL_DESIGNS";
		public static const URL_COMMODITY_REQUESTS:String="URL_COMMODITY_REQUESTS";
		public static const URL_POST_DESIGNS:String="URL_POST_DESIGNS";
		public static const URL_STAMP_ARE_ABAILABLE:String="URL_STAMP_ARE_ABAILABLE";
			
		public static const URL_ITEMS:String="URL_ITEMS";
		public static const URL_ITEMS_STORE:String="URL_ITEMS_STORE";
		
		public static const URL_APP_ANNNOUNCEMENT:String="URL_APP_ANNNOUNCEMENT";
		
		public static const URL_LOGIN_FACEBOOK:String="URL_LOGIN_FACEBOOK";
		public static const URL_LOGIN_TWITTER:String="URL_LOGIN_TWITTER";
		
		public static const URL_STAMPSET_UPDATED:String="URL_STAMPSET_UPDATED";
		public static const URL_STAMPSET_LIST:String="URL_STAMPSET_LIST";
		public static const URL_STAMPSET:String="URL_STAMPSET";
		
		public static const URL_PROFILE_IMAGE_UPLOAD:String="URL_PROFILE_IMAGE_UPLOAD";
		
		public static const AMAZON_DEVICE_SUBSCRIPTION:String="AMAZON_DEVICE_SUBSCRIPTION";
		
		
	
		
		
		static private const V3URL_MAP:Object={
			URL_APP_ANNNOUNCEMENT:"announcements/latest?lang=%s",
			URL_STAMPSET_UPDATED:"stamp_sets/last_updated_on",
			URL_STAMPSET_LIST:"stamp_sets2",
			URL_STAMPSET:"stamp_sets2/",
			URL_STAMP_ARE_ABAILABLE:"stamps/are_available",
			URL_LOGIN_FACEBOOK:"auth/facebook_for_mobile",
			URL_LOGIN_TWITTER:"auth/twitter_for_mobile",
			URL_ITEMS:"items",
			URL_ITEMS_STORE:"items/store",
			URL_PROFILE_IMAGE_UPLOAD:"profile_image_upload",
			URL_COMMODITY_REQUESTS:"commodity_requests",
			URL_POST_DESIGNS:"post_designs",
			URL_MATERIAL_DESIGNS:"material_designs",
			URL_DESIGN_OWNER:"designs/member",
			AMAZON_DEVICE_SUBSCRIPTION:"subscribe.json"
		}
			
		
		///////////////////////////////////////////////////
		
		
		public static const APP_SCHEME_IOS:String="uniqloapp://";
		public static const APP_SCHEME_ANDROID:String=UTCapabilities.getLangCode().toLowerCase()=="ja"?"com.uniqlo.ja.catalogue":"com.uniqlo.us.catalogue";
		
		static public function GetURL(urlv1:String):String{
			var ret:String;
			ret=URL_APP_DOMAIN+urlv1;
			var reg:RegExp=/%s/;
			ret=ret.replace(reg,String(UTCapabilities.getLangCode() .toLowerCase()));
			ret=ret.replace(reg,String(AppVals.IPCountryCode.toLowerCase()));
			trace(">>>>> URL >>>>>",ret);
			return ret;
		}
		
		static public function GetAPI(urlv1:String):String{
			var ret:String;
			if(V3URL_MAP[urlv1].indexOf("announcements")>-1){
				ret=  URL_API_DOMAIN+"api/"+AppVals.API_VERSION+"/"+V3URL_MAP[urlv1];
			}else{
				ret=  URL_API_DOMAIN+AppVals.IPCountryCode+"/api/"+AppVals.API_VERSION+"/"+V3URL_MAP[urlv1];
			}
			var reg:RegExp=/%s/;			
			ret=ret.replace(reg,String(UTCapabilities.getLangCode().toLowerCase()));
			ret=ret.replace(reg,String(AppVals.IPCountryCode.toLowerCase()));
			trace(">>>>> API >>>>>",ret);
			return ret;
		}
		
		static private var SCData:String="";
		static private var SCTime:Number;
		static public function buildRequestHeader():void{
			if(AppVals.Dog.length==0)initVals();
			var url:URLRequest = new URLRequest("");	
			SCTime=(new Date()).time;
			var salt:String=String("0000000000000000" + SCTime.toString(16)).slice(-16);
			SCData=salt+SHA256.hash(salt+AppVals.Dog);
		}
		
		static public function initVals():void{
			var a:MovieClip=new Tkeys;
			if(AppVals.DEBUG_MODE_SERVER){
				a=new TkeysD;
			}else{
				a=new Tkeys;
			}
			
			var k:String="";
			var p:String="";
			var s:String;
			var l:uint;
			for(var i:int=0;i<a.numChildren;i++){
				s=a.getChildAt(i).name;
				l=s.charAt(1).match(/[_]/)?2:1;
				k=s.substr(0,l).replace("_","-")+k;
				p=s.substr(l)+p;		
			}
			
			AppVals.Cat=k;
			AppVals.Dog=p;
			
			//trace(AppVals.Cat,AppVals.Dog);
			a=null;
		}
		
		static private function getRequestHeader():URLRequestHeader{
			if(SCTime<(new Date()).time-3600000)SCData="";
			if(SCData.length==0)buildRequestHeader();
			return new URLRequestHeader(AppVals.Cat, SCData); 
		}
		static public function getAuthorizedURLRequest(url:String):URLRequest{
			var urlRequest:URLRequest= new URLRequest(url)
			urlRequest.requestHeaders.push(getRequestHeader());
			
			return urlRequest; 
		}
		
		
	}
}

