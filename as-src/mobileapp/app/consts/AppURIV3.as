package utme.app.consts
{
	import utme.app.NSFuncs.UTCapabilities;

	public class AppURIV3
	{
		public static var commodity_abuses:Object=null;
			
		

		private static const DEMO_URLs:Object={
		//	URL_TIMELINE:{url:"http://utme.p.tha.jp/test/timeline.html?"+Math.random(),command:{url:"header",title:AppLang.getString(AppLang.WEB_TITLE_TIMELINE),backgroundColor:"EEEEEE",searchBtn:true,likeBtn:true,cartBtn:true}},
			URL_MARKET:{url:"http://utme.p.tha.jp/test/market.html?"+Math.random(),command:{url:"header",showUTmeIcon:true,backgroundColor:"FFFFFF",searchBtn:true,likeBtn:true,cartBtn:true}},
			URL_MYPAGE:{url:"http://utme.p.tha.jp/test/mypage.html?"+Math.random(),command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",optionBtn:true}},
			
			URL_CART:{url:"http://utme.p.tha.jp/test/cart.html?"+Math.random(),command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",closeBtn:true}},
			URL_SEARCH:{url:"http://utme.p.tha.jp/test/search.html?"+Math.random(),command:{url:"header",title:AppLang.LOADING,backgroundColor:"FFFFFF",closeBtn:true}},
			URL_LIKES:{url:"http://utme.p.tha.jp/test/like.html?"+Math.random(),command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",closeBtn:true,cartBtn:true}},
			URL_SETTINGS:{url:"http://utme.p.tha.jp/test/option.html?"+Math.random(),command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",closeBtn:true}},	
			
			URL_FAQ:{url:"m/faq/?lang=%s&iso=%s",command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",closeBtn:true}},
			
			URL_SHARE_FACEBOOK:{url:"https://www.facebook.com/sharer/sharer.php",command:{url:"header",closeBtn:true,title:AppLang.LOADING}},	
			URL_SHARE_TWITTER:{url:"http://twitter.com/share",command:{url:"header",closeBtn:true,title:AppLang.LOADING}},	
			
			URL_CART_EDIT:{command:{url:"header",title:AppLang.LOADING,backgroundColor:"FFFFFF",closeBtn:true}},		
			URL_CART_ADD:{command:{url:"header",title:AppLang.LOADING,backgroundColor:"FFFFFF",closeBtn:true}},
			URL_UPLOAD_MARKET:{command:{url:"header",closeBtn:true,title:AppLang.LOADING}},
			URL_SHARE:{command:{url:"header",closeBtn:true,title:AppLang.LOADING}},
			URL_ITEM_EDIT:{command:{url:"header",closeBtn:true,title:AppLang.LOADING}},
			URL_TERMS:{command:{url:"header",title:AppLang.LOADING}}
		}
		
		private static const URLs:Object={
		//	URL_TIMELINE:{url:"front/my/timeline?locale=%s",command:{url:"header",title:AppLang.getString(AppLang.WEB_TITLE_TIMELINE),backgroundColor:"EEEEEE",searchBtn:true,likeBtn:true,cartBtn:true}},
			URL_MARKET:{url:"front/commodities?locale=%s",command:{url:"header",showUTmeIcon:true,backgroundColor:"FFFFFF"}},
			URL_MYPAGE:{url:"front/my?locale=%s",command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",optionBtn:true,faqBtn:true}},
			
			URL_CART:{url:"front/cart?locale=%s",command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",closeBtn:true}},
			URL_SEARCH:{url:"front/commodities/search?locale=%s",command:{url:"header",title:AppLang.LOADING,backgroundColor:"FFFFFF",closeBtn:true}},
			URL_LIKES:{url:"front/my/likes?locale=%s",command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",closeBtn:true}},
			URL_SETTINGS:{url:"front/my/options?locale=%s",command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",closeBtn:true}},	
			
			URL_FAQ:{command:{url:"header",title:AppLang.LOADING,backgroundColor:"EEEEEE",closeBtn:true}},
			
			URL_SHARE_FACEBOOK:{url:"https://www.facebook.com/sharer/sharer.php",command:{url:"header",closeBtn:true,title:AppLang.LOADING}},	
			URL_SHARE_TWITTER:{url:"http://twitter.com/share",command:{url:"header",closeBtn:true,title:AppLang.LOADING}},	
			
			URL_CART_EDIT:{command:{url:"header",title:AppLang.LOADING,backgroundColor:"FFFFFF",closeBtn:true}},		
			URL_CART_ADD:{command:{url:"header",title:AppLang.LOADING,backgroundColor:"FFFFFF",closeBtn:true}},
			URL_UPLOAD_MARKET:{command:{url:"header",closeBtn:true,title:AppLang.LOADING}},
			URL_SHARE:{command:{url:"header",closeBtn:true,title:AppLang.LOADING}},
			URL_ITEM_EDIT:{command:{url:"header",closeBtn:true,title:AppLang.LOADING}},
			URL_TERMS:{command:{url:"header",title:AppLang.LOADING}}
		}
			
		public static function getCommand(id:String):Object{
			return URLs[id].command;
		}
		
		public static function getUrl(id:String):String{
			var url:String;
		if(AppVals.DEBUG_THA_DUMMY_CHECK){
				url=DEMO_URLs[id].url;
			}else{
				if(URLs[id].url.indexOf("http")==0){
					url=URLs[id].url;
				}else{
					url=AppURI.URL_API_DOMAIN+AppVals.IPCountryCode+"/"+URLs[id].url;
				}
			}
			var reg:RegExp=/%s/;
			url=url.replace(reg,String(UTCapabilities.getLangCode().toLowerCase()));
			trace(">>>>> URLV3 >>>>>",url);
			return url;
		}
			
	}
}