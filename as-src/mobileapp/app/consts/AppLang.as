package utme.app.consts
{
	import flash.utils.describeType;
	
	import utme.app.NSFuncs.UTCapabilities;
	
	public class AppLang{
		public static const LOADING:String="LOADING...";
		
		////////////////////////////////////////////////////
		public static const ALERT_OK:String="ALERT_OK";	
		public static const ALERT_YES:String="ALERT_YES";
		public static const ALERT_NO:String="ALERT_NO";
		public static const ALERT_MORE:String="ALERT_MORE";
		public static const ALERT_CANCEL:String="ALERT_CANCEL";	
		
		public static const ALERT_END_TITLE:String="ALERT_END_TITLE";
		public static const ALERT_END_MESSAGE:String="ALERT_END_MESSAGE";
		public static const ALERT_ADD3_TITLE:String="ALERT_ADD3_TITLE";
		public static const ALERT_ADD3_MESSAGE:String="ALERT_ADD3_MESSAGE";
		
		public static const ALERT_NET_ERROR_TITLE:String="ALERT_NET_ERROR_TITLE";
		public static const ALERT_NET_ERROR_MESSAGE:String="ALERT_NET_ERROR_MESSAGE";
		
		//v1.0.4
		public static const ALERT_TSHIRT_ID_TITLE:String="ALERT_TSHIRT_ID_TITLE";
		public static const ALERT_TSHIRT_ID_MESSAGE:String="ALERT_TSHIRT_ID_MESSAGE";
		public static const ALERT_TSHIRT_TITLE:String="ALERT_TSHIRT_TITLE";
		public static const ALERT_TSHIRT_MESSAGE:String="ALERT_TSHIRT_MESSAGE";
		//店舗用
		public static const ALERT_ORDER_TITLE:String="ALERT_ORDER_TITLE";
		public static const ALERT_ORDER_MESSAGE:String="ALERT_ORDER_MESSAGE";
		public static const ALERT_STUFF_TITLE:String="ALERT_STUFF_TITLE";
		public static const ALERT_STUFF_MESSAGE:String="ALERT_STUFF_MESSAGE";
		//stamp
		
		
		public static const STAMP_RECENT:String="STAMP_RECENT";
		public static const STAMP_LIST:String="STAMP_LIST";
		
		public static const STAMP_PRINT_CONST:String="STAMP_PRINT_CONST";
		public static const STAMP_PER1TSHUIT:String="STAMP_PER1TSHUIT";
		public static const STAMP_NOPRICE:String="STAMP_NOPRICE";
		
		
		public static const ALERT_API_ERROR_TITLE:String="ALERT_API_ERROR_TITLE";
		public static const ALERT_API_ERROR_MESSAGE:String="ALERT_API_ERROR_MESSAGE";
		
		public static const ALERT_STAMPDISABLE_BYLIST_TITLE:String="ALERT_STAMPDISABLE_BYLIST_TITLE";
		public static const ALERT_STAMPDISABLE_BYLIST_MESSAGE1:String="ALERT_STAMPDISABLE_BYLIST_MESSAGE1";
		public static const ALERT_STAMPDISABLE_BYLIST_MESSAGE2:String="ALERT_STAMPDISABLE_BYLIST_MESSAGE2";
		
		public static const ALERT_STAMPDISABLE_OVERLAP_TITLE:String="ALERT_STAMPDISABLE_OVERLAP_TITLE";
		public static const ALERT_STAMPDISABLE_OVERLAP_MESSAGE:String="ALERT_STAMPDISABLE_OVERLAP_MESSAGE";
		public static const ALERT_STAMPDISABLE_DUPLICATE_TITLE:String="ALERT_STAMPDISABLE_DUPLICATE_TITLE";
		public static const ALERT_STAMPDISABLE_DUPLICATE_MESSAGE:String="ALERT_STAMPDISABLE_DUPLICATE_MESSAGE";
		
		
		public static const ALERT_STAMPDISABLE_SHARE_MESSAGE:String="ALERT_STAMPDISABLE_SHARE_MESSAGE";
		public static const ALERT_STAMPDISABLE_ANYREASON_MESSAGE:String="ALERT_STAMPDISABLE_ANYREASON_MESSAGE";
		public static const ALERT_STAMPDISABLE_LAYER_MESSAGE1:String="ALERT_STAMPDISABLE_LAYER_MESSAGE1";
		public static const ALERT_STAMPDISABLE_LAYER_MESSAGE2:String="ALERT_STAMPDISABLE_LAYER_MESSAGE2";
		public static const ALERT_STAMPDISABLE_LAYER_MESSAGE3:String="ALERT_STAMPDISABLE_LAYER_MESSAGE3";
		
		//////////////////////////////
		public static const ALERT_STAMP_LIMIT_ITEM_AND_COLOR:String="ALERT_STAMP_LIMIT_ITEM_AND_COLOR";
		public static const ALERT_STAMP_LIMIT_ITEM:String="ALERT_STAMP_LIMIT_ITEM";
		public static const ALERT_STAMP_SELECTION_LIMIT_ITEM_AND_COLOR:String="ALERT_STAMP_SELECTION_LIMIT_ITEM_AND_COLOR";
		public static const ALERT_STAMP_SELECTION_LIMIT_ITEM:String="ALERT_STAMP_SELECTION_LIMIT_ITEM";
		
		public static const ALERT_STAMPDISABLE_ALL_LAYER_MESSAGE:String="ALERT_STAMPDISABLE_ALL_LAYER_MESSAGE";
		
		public static const ALERT_UPDATE_TITLE:String="ALERT_UPDATE_TITLE";
		public static const ALERT_UPDATE_REQUIRE_MESSAGE:String="ALERT_UPDATE_REQUIRE_MESSAGE";
		public static const ALERT_UPDATE_RECCOMEND_MESSAGE:String="ALERT_UPDATE_RECCOMEND_MESSAGE";
		public static const ALERT_LATER:String="ALERT_LATER";
		public static const ALERT_UPDATE:String="ALERT_UPDATE";
		
		
		public static const ALERT_SELECTED_ITEM:String="ALERT_SELECTED_ITEM";
		public static const ALERT_SELECTED_ITEM_AND_COLOR:String="ALERT_SELECTED_ITEM_AND_COLOR";
		
		
		public static const LAYER_NAME_PAINT:String="LAYER_NAME_PAINT";
		public static const LAYER_NAME_TYPOGRAPHY:String="LAYER_NAME_TYPOGRAPHY";
		public static const LAYER_NAME_PHOTO:String="LAYER_NAME_PHOTO";
		public static const LAYER_NAME_STAMP:String="LAYER_NAME_STAMP";
		
		public static const LIMIT_DATE:String="LIMIT_DATE";
		public static const LIMIT_DATE2:String="LIMIT_DATE2";
		
		public static const LIMIT_MULTI:String="LIMIT_MULTI";
		public static const LIMIT_SAME:String="LIMIT_SAME";
		public static const LIMIT_ROTATION:String="LIMIT_ROTATION";
		public static const LIMIT_ROTATION_45:String="LIMIT_ROTATION_45";
		public static const LIMIT_OVERLAP:String="LIMIT_OVERLAP";
		public static const LIMIT_LAYER_PAINT:String="LIMIT_LAYER_PAINT";
		public static const LIMIT_LAYER_TYPOGRAPHY:String="LIMIT_LAYER_TYPOGRAPHY";
		public static const LIMIT_LAYER_PHOTO:String="LIMIT_LAYER_PHOTO";
		public static const LIMIT_LAYER_STAMP:String="LIMIT_LAYER_STAMP";
		public static const LIMIT_REMIX_SPLASH:String="LIMIT_REMIX_SPLASH";
		public static const LIMIT_REMIX_GLITCH:String="LIMIT_REMIX_GLITCH";
		public static const LIMIT_REMIX_MOSAIC:String="LIMIT_REMIX_MOSAIC";
		public static const LIMIT_REMIX_LAYOUT:String="LIMIT_REMIX_LAYOUT";
		
		public static const LIMIT_REMIX_MOMA01:String="LIMIT_REMIX_MOMA01";
		public static const LIMIT_REMIX_MOMA02:String="LIMIT_REMIX_MOMA02";
		public static const LIMIT_TIMELINE:String="LIMIT_TIMELINE";
		public static const LIMIT_MARKET:String="LIMIT_MARKET";
		public static const LIMIT_TOPMOST:String="LIMIT_TOPMOST";
		
		public static const ALERT_STAMPDISABLE_SALE_MESSAGE:String="ALERT_STAMPDISABLE_SALE_MESSAGE";
		
		public static const ALERT_SAVED_DELETE_MESSAGE:String="ALERT_SAVED_DELETE_MESSAGE";
		
		
		public static const ALERT_COPU_URL_MESSAGE:String="ALERT_COPU_URL_MESSAGE";
		
		/*
		public static const WEB_TITLE_TIMELINE:String="WEB_TITLE_TIMELINE";
		public static const WEB_TITLE_MYPAGE:String="WEB_TITLE_MYPAGE";
		public static const WEB_TITLE_CART:String="WEB_TITLE_CART";
		public static const WEB_TITLE_SEARCH:String="WEB_TITLE_SEARCH";
		public static const WEB_TITLE_LIKE:String="WEB_TITLE_LIKE";
		public static const WEB_TITLE_OPTION:String="WEB_TITLE_OPTION";
		public static const WEB_TITLE_FACEBOOK:String="WEB_TITLE_FACEBOOK";
		public static const WEB_TITLE_TWITTER:String="WEB_TITLE_TWITTER";
		public static const WEB_TITLE_CART_EDIT:String="WEB_TITLE_CART_EDIT";
		public static const WEB_TITLE_CART_ADD:String="WEB_TITLE_CART_ADD";
		public static const WEB_TITLE_LIST:String="WEB_TITLE_LIST";
		public static const WEB_TITLE_POST:String="WEB_TITLE_POST";
		public static const WEB_TITLE_ITEM_EDIT:String="WEB_TITLE_ITEM_EDIT";
		public static const WEB_TITLE_TERMS:String="WEB_TITLE_TERMS";
		*/
		
		public static const PHOTO_FILTER_NORMAL:String="PHOTO_FILTER_NORMAL";
		public static const PHOTO_FILTER_MONO:String="PHOTO_FILTER_MONO";
		public static const PHOTO_FILTER_HICON:String="PHOTO_FILTER_HICON";
		public static const PHOTO_FILTER_PROCESS:String="PHOTO_FILTER_PROCESS";
		public static const PHOTO_FILTER_FADE:String="PHOTO_FILTER_FADE";
		public static const PHOTO_FILTER_CHROME:String="PHOTO_FILTER_CHROME";
		
		private static const localisedStringSet:Object={
			"ja":{
				ALERT_OK:"OK",
				ALERT_YES:"はい",
				ALERT_NO:"いいえ",				
				ALERT_MORE:"詳細",
				ALERT_CANCEL:"キャンセル",
				
				ALERT_END_TITLE:"はじめからやりなおしますか？",
				ALERT_END_MESSAGE:"ここまでの編集内容は破棄されます。",
				
				ALERT_ADD3_TITLE:"これ以上追加できません",
				ALERT_ADD3_MESSAGE:"レイヤーを追加できるのは\n３回までです。",
				ALERT_NET_ERROR_TITLE:"接続エラー",
				ALERT_NET_ERROR_MESSAGE:"インターネット接続を確認して、再度お試し下さい",
				
				ALERT_TSHIRT_ID_TITLE:"UTID : ",
				ALERT_TSHIRT_ID_MESSAGE:"このIDは一定期間のみ有効です。",
				ALERT_TSHIRT_TITLE:"UTIDを取得しますか？",
				ALERT_TSHIRT_MESSAGE:"「はい」を選択するとこのデザインが送信されます。",
				
				ALERT_ORDER_TITLE:"注文受付いたします。",
				ALERT_ORDER_MESSAGE:"STAFFをお呼びください。",
				ALERT_STUFF_TITLE:"デザインを保存しました。",
				ALERT_STUFF_MESSAGE:"ケーブルを接続してください。",
				
				ALERT_SAVED_DELETE_MESSAGE:"このデザインを削除してもよろしいですか？",
				
				ALERT_COPU_URL_MESSAGE:"URLがコピーされました",
				
				/////////////////////////////////////////////////////////////////////////////////
				
				STAMP_RECENT:"最近つかったスタンプセット",
				STAMP_LIST:"スタンプセット一覧",
				
				STAMP_PRINT_CONST:"スタンププリント代：",
				STAMP_PER1TSHUIT:"＋消費税 / 1アイテム",
				STAMP_NOPRICE:"無料",
				
				ALERT_API_ERROR_TITLE:"エラー",
				ALERT_API_ERROR_MESSAGE:"エラーが発生しました。しばらくしてから再度お試し下さい",
				
				ALERT_STAMPDISABLE_BYLIST_TITLE:"このデザインは選択できません",
				ALERT_STAMPDISABLE_BYLIST_MESSAGE1:"このデザインで使用しているスタンプの利用期限が切れているため選択することができません",
				ALERT_STAMPDISABLE_BYLIST_MESSAGE2:"このデザインで使用されているスタンプの使用条件が変更されたため選択することができません",
				
				ALERT_STAMPDISABLE_OVERLAP_TITLE:"このスタンプは重ねて配置できません",
				ALERT_STAMPDISABLE_OVERLAP_MESSAGE:"スタンプ同士が重ならないよう移動させてください。",
				
				ALERT_STAMPDISABLE_DUPLICATE_TITLE:"このスタンプセットは複数種類のスタンプを貼りつけられません",
				ALERT_STAMPDISABLE_DUPLICATE_MESSAGE:"すでに配置してあるスタンプが削除されます",
				
				ALERT_STAMPDISABLE_SHARE_MESSAGE:"このスタンプを使ったアイテムはタイムラインに投稿できません",
				ALERT_STAMPDISABLE_SALE_MESSAGE:"このスタンプを使ったアイテムはマーケットに出品できません",
				ALERT_STAMPDISABLE_ALL_LAYER_MESSAGE:"このスタンプは他のレイヤーと組み合わせられません",
				ALERT_STAMPDISABLE_ANYREASON_MESSAGE:"ご使用中のスタンプと組み合わせられません",
				
				ALERT_STAMPDISABLE_LAYER_MESSAGE1:"このスタンプセットは",
				ALERT_STAMPDISABLE_LAYER_MESSAGE2:"、",
				ALERT_STAMPDISABLE_LAYER_MESSAGE3:"と組み合わせられません",
				
				/////////////////////////////////////////////////////////////////
				
				ALERT_STAMP_LIMIT_ITEM_AND_COLOR:"%s（%s）は使用中のスタンプと組み合わせられません",
				ALERT_STAMP_LIMIT_ITEM:"%sは使用中のスタンプと組み合わせられません",
				ALERT_STAMP_SELECTION_LIMIT_ITEM_AND_COLOR:"このスタンプは%s（%s）と組み合わせられません",
				ALERT_STAMP_SELECTION_LIMIT_ITEM:"このスタンプは%sと組み合わせられません",			
				
				ALERT_UPDATE_TITLE:"UTme! の新しいバージョンがあります",
				ALERT_UPDATE_REQUIRE_MESSAGE:"今後お使いになるにはアップデートが必須となります。ストアを開き、最新のバージョンにアップデートしてください。",
				ALERT_UPDATE_RECCOMEND_MESSAGE:"ストアを開き、最新のバージョンにアップデートしてください。",
				ALERT_LATER:"後で",
				ALERT_UPDATE:"ストアを開く",
				
				ALERT_SELECTED_ITEM:"%sを選択しました",
				ALERT_SELECTED_ITEM_AND_COLOR:"%s（%s）を選択しました",
				
				LAYER_NAME_PAINT:"PAINT",
				LAYER_NAME_TYPOGRAPHY:"TYPOGRAPHY",
				LAYER_NAME_PHOTO:"PHOTO",
				LAYER_NAME_STAMP:"他のスタンプセット",
				
				LIMIT_DATE:"利用期限 ― ",
				LIMIT_DATE2:"まで",
				
				LIMIT_MULTI:"・複数スタンプの貼り付け",
				LIMIT_SAME:"・同じスタンプの貼付け",
				LIMIT_ROTATION:"・回転",
				LIMIT_ROTATION_45:"・半回転",
				LIMIT_OVERLAP:"・重ねる",
				
				LIMIT_LAYER_PAINT:"・PAINT",
				LIMIT_LAYER_TYPOGRAPHY:"・TYPOGRAPHY",
				LIMIT_LAYER_PHOTO:"・PHOTO",
				LIMIT_LAYER_STAMP:"・STAMP",
				
				LIMIT_REMIX_SPLASH:"・SPLASH",
				LIMIT_REMIX_GLITCH:"・GLITCH",
				LIMIT_REMIX_MOSAIC:"・MOSAIC",
				LIMIT_REMIX_LAYOUT:"・AUTO DESIGNER",
				LIMIT_REMIX_MOMA01:"・MoMA EARLY MODERN STYLE",
				LIMIT_REMIX_MOMA02:"・MoMA COLLAGE",
				
				LIMIT_TIMELINE:"・タイムラインに投稿できません",
				LIMIT_MARKET:"・マーケットに出品できません",
				LIMIT_TOPMOST:"・常に最前面",
				
				/*
				WEB_TITLE_TIMELINE:"タイムライン",
				WEB_TITLE_MYPAGE:"マイページ",
				WEB_TITLE_CART:"ショッピングカート",
				WEB_TITLE_SEARCH:"検索",
				WEB_TITLE_LIKE:"お気に入りしたアイテム",
				WEB_TITLE_OPTION:"オプション",
				WEB_TITLE_FACEBOOK:"Facebookでシェア",
				WEB_TITLE_TWITTER:"Twitterでツイート",
				WEB_TITLE_CART_EDIT:"カートの中身を変更",
				WEB_TITLE_CART_ADD:"カートに追加",
				WEB_TITLE_LIST:"出品のながれ",
				WEB_TITLE_POST:"投稿",
				WEB_TITLE_ITEM_EDIT:"アイテム情報の編集",
				WEB_TITLE_TERMS:"UTme! 利用規約",
				*/
				PHOTO_FILTER_NORMAL:"調整なし",
				PHOTO_FILTER_MONO:"モノクロ",
				PHOTO_FILTER_HICON:"ハイコントラスト",
				PHOTO_FILTER_PROCESS:"プロセス",
				PHOTO_FILTER_FADE:"フェード",
				PHOTO_FILTER_CHROME:"クローム"
				
			},
			
			"en":{
				ALERT_OK:"OK",
				ALERT_YES:"Yes",
				ALERT_NO:"No",
				ALERT_MORE:"More",
				ALERT_CANCEL:"Cancel",	
				
				ALERT_END_TITLE:"Start from the beginning?",
				ALERT_END_MESSAGE:"All unsaved changes will be discarded.",
				
				ALERT_ADD3_TITLE:"Cannot Add Graphic",
				ALERT_ADD3_MESSAGE:"Layers can be added up to 3 times.",
				ALERT_NET_ERROR_TITLE:"Connection error",
				ALERT_NET_ERROR_MESSAGE:"Check your internet connection and try again.",
				
				ALERT_TSHIRT_ID_TITLE:"UTID : ",
				ALERT_TSHIRT_ID_MESSAGE:"This UTID is valid only for a certain period of time.",
				ALERT_TSHIRT_TITLE:"Do you want to get the UTID?",
				ALERT_TSHIRT_MESSAGE:"This design will be sent to the UTme! server when tapping \"Yes\" button.",
				
				ALERT_ORDER_TITLE:"Our Staff will guide you to purchase.",
				ALERT_ORDER_MESSAGE:"Please call staff.",
				ALERT_STUFF_TITLE:"Design has been saved.",
				ALERT_STUFF_MESSAGE:"Please connect the cable.",
				
				ALERT_SAVED_DELETE_MESSAGE:"Are you sure you want to delete this design?",
				ALERT_COPU_URL_MESSAGE:"URL has been copied",
				
				/////////////////////////////////////////////////////////////////////////////////
				
				STAMP_RECENT:"Recent Sticker Set",
				STAMP_LIST:"Browse Sticker Sets",
				
				STAMP_PRINT_CONST:"Sticker Print Fee:",
				STAMP_PER1TSHUIT:"+Tax / 1 Item",
				STAMP_NOPRICE:"Free",
				
				ALERT_API_ERROR_TITLE:"Error",
				ALERT_API_ERROR_MESSAGE:"An error occurred. Please try again later.",
				
				ALERT_STAMPDISABLE_BYLIST_TITLE:"This design can't be selected",
				ALERT_STAMPDISABLE_BYLIST_MESSAGE1:"This design can't be selected. The sticker has expired.",
				ALERT_STAMPDISABLE_BYLIST_MESSAGE2:"This design can't be selected. The terms and conditions for the sticker has changed.",
				
				ALERT_STAMPDISABLE_OVERLAP_TITLE:"This sticker can't be overlapped ",
				ALERT_STAMPDISABLE_OVERLAP_MESSAGE:"Please adjust the stickers so they don't overlap each other.",
				
				ALERT_STAMPDISABLE_DUPLICATE_TITLE:"This sticker set can't be used with other stickers",
				ALERT_STAMPDISABLE_DUPLICATE_MESSAGE:"Using this sticker will delete other stickers in the design.",
				
				ALERT_STAMPDISABLE_SHARE_MESSAGE:"Items with this sticker can’t be posted on the timeline.",
				
				ALERT_STAMPDISABLE_SALE_MESSAGE:"Items with this sticker can’t be listed on the market.",
				
				
				ALERT_STAMPDISABLE_ALL_LAYER_MESSAGE:"This sticker can't be used with other layers.",
				
				ALERT_STAMPDISABLE_ANYREASON_MESSAGE:"This sticker can't be combined with the sticker sets you've already used.",
				
				ALERT_STAMPDISABLE_LAYER_MESSAGE1:"This sticker set can't be used with ",
				ALERT_STAMPDISABLE_LAYER_MESSAGE2:" or ",
				ALERT_STAMPDISABLE_LAYER_MESSAGE3:".",
				
				
				////////////////////////////////////////////////////////////////
				ALERT_STAMP_LIMIT_ITEM_AND_COLOR:"%s （%s） can't be combined with the stickers used.",
				ALERT_STAMP_LIMIT_ITEM:"%s can't be combined with the stickers used.",
				ALERT_STAMP_SELECTION_LIMIT_ITEM_AND_COLOR:"This sticker can't be used with %s （%s）.",
				ALERT_STAMP_SELECTION_LIMIT_ITEM:"This sticker can't be used with %s.",
				
				
				ALERT_UPDATE_TITLE:"New version of UTme! is available",
				ALERT_UPDATE_REQUIRE_MESSAGE:"You must update to continue using this app. Please update to the latest version by pressing the button below.",
				ALERT_UPDATE_RECCOMEND_MESSAGE:"Please update to the latest version by pressing the button below.",
				ALERT_LATER:"Later",
				ALERT_UPDATE:"Update",
				
				ALERT_SELECTED_ITEM:"%s has been selected",
				ALERT_SELECTED_ITEM_AND_COLOR:"%s (%s) has been selected",					
				
				LAYER_NAME_PAINT:"PAINT",
				LAYER_NAME_TYPOGRAPHY:"TYPOGRAPHY",
				LAYER_NAME_PHOTO:"PHOTO",
				LAYER_NAME_STAMP:"other sticker sets",
				
				LIMIT_DATE:"Expires on ",
				LIMIT_DATE2:"",
				
				LIMIT_MULTI:"- Use multiple stickers",
				LIMIT_SAME:"- Duplicate same sticker",
				LIMIT_ROTATION:"- Rotate",
				LIMIT_ROTATION_45:"- Reverse",
				LIMIT_OVERLAP:"- Overlap",
				
				LIMIT_LAYER_PAINT:"- PAINT",
				LIMIT_LAYER_TYPOGRAPHY:"- TYPOGRAPHY",
				LIMIT_LAYER_PHOTO:"- PHOTO",
				LIMIT_LAYER_STAMP:"- STICKER",
				
				LIMIT_REMIX_SPLASH:"- SPLASH",
				LIMIT_REMIX_GLITCH:"- GLITCH",
				LIMIT_REMIX_MOSAIC:"- MOSAIC",
				LIMIT_REMIX_LAYOUT:"- AUTO DESIGNER",
				LIMIT_REMIX_MOMA01:"- MoMA EARLY MODERN STYLE",
				LIMIT_REMIX_MOMA02:"- MoMA COLLAGE",
				
				LIMIT_TIMELINE:"- Can't be posted on timeline",
				LIMIT_MARKET:"- Can't be listed on market",
				LIMIT_TOPMOST:"- Always in front",
				
				/*
				WEB_TITLE_TIMELINE:"Timeline",
				WEB_TITLE_MYPAGE:"My Page",
				WEB_TITLE_CART:"Shopping Cart",
				WEB_TITLE_SEARCH:"Search",
				WEB_TITLE_LIKE:"Favorites",
				WEB_TITLE_OPTION:"Options",
				WEB_TITLE_FACEBOOK:"Share on Facebook",
				WEB_TITLE_TWITTER:"Share on Twitter",
				WEB_TITLE_CART_EDIT:"Edit shopping cart",
				WEB_TITLE_CART_ADD:"Add To Cart",
				WEB_TITLE_LIST:"How to list your item",
				WEB_TITLE_POST:"Post",
				WEB_TITLE_ITEM_EDIT:"Edit item information",
				WEB_TITLE_TERMS:"Terms and Conditions",
				*/
				PHOTO_FILTER_NORMAL:"None",
				PHOTO_FILTER_MONO:"Monochrome",
				PHOTO_FILTER_HICON:"High Contrast",
				PHOTO_FILTER_PROCESS:"Process",
				PHOTO_FILTER_FADE:"Fade",
				PHOTO_FILTER_CHROME:"Chrome"
			},
			
			"zh":{
				ALERT_OK:"OK",
				ALERT_YES:"是",
				ALERT_NO:"否",				
				ALERT_MORE:"具体说明",
				ALERT_CANCEL:"取消",
				
				ALERT_END_TITLE:"是否重新制作？",
				ALERT_END_MESSAGE:"放弃此前编辑的内容",
				
				ALERT_ADD3_TITLE:"无法再添加",
				ALERT_ADD3_MESSAGE:"最多添加３层图层",
				ALERT_NET_ERROR_TITLE:"连接错误",
				ALERT_NET_ERROR_MESSAGE:"请确认网络连接后再次尝试",
				
				ALERT_TSHIRT_ID_TITLE:"UTID : ",
				ALERT_TSHIRT_ID_MESSAGE:"此ID仅在一定期限内有效",
				ALERT_TSHIRT_TITLE:"是否获取UTID？",
				ALERT_TSHIRT_MESSAGE:"如果选择“是”将发送此设计",
				
				ALERT_ORDER_TITLE:"订单制作完成",
				ALERT_ORDER_MESSAGE:"请联系工作人员",
				ALERT_STUFF_TITLE:"设计已保存",
				ALERT_STUFF_MESSAGE:"请连接网络",
				
				ALERT_SAVED_DELETE_MESSAGE:"是否删除此设计？",
				
				ALERT_COPU_URL_MESSAGE:"URL已复制",
				
				/////////////////////////////////////////////////////////////////////////////////
				
				STAMP_RECENT:"最近使用的贴图组套",
				STAMP_LIST:"贴图一览",
				
				STAMP_PRINT_CONST:"贴图印刷费用:",
				STAMP_PER1TSHUIT:"+消费税/1款",
				STAMP_NOPRICE:"免费",
				
				ALERT_API_ERROR_TITLE:"错误",
				ALERT_API_ERROR_MESSAGE:"出现错误。请稍后再尝试",
				
				ALERT_STAMPDISABLE_BYLIST_TITLE:"不能选择此设计",
				ALERT_STAMPDISABLE_BYLIST_MESSAGE1:"此设计使用的贴图已超过使用期，无法选择",
				ALERT_STAMPDISABLE_BYLIST_MESSAGE2:"此设计使用的贴图使用条件已更改，无法选择",
				
				ALERT_STAMPDISABLE_OVERLAP_TITLE:"此贴图不能重叠放置",
				ALERT_STAMPDISABLE_OVERLAP_MESSAGE:"请在移动时避免将相同贴图重叠。",
				
				ALERT_STAMPDISABLE_DUPLICATE_TITLE:"此套贴图不能与多种贴图同时使用",
				ALERT_STAMPDISABLE_DUPLICATE_MESSAGE:"删除已有贴图",
				
				ALERT_STAMPDISABLE_SHARE_MESSAGE:"使用此贴图的款式不能在Timeline上发布",
				ALERT_STAMPDISABLE_SALE_MESSAGE:"使用此贴图的款式不能在UTme！ Market展示",
				ALERT_STAMPDISABLE_ALL_LAYER_MESSAGE:"此贴图不能与其他图层合并",
				ALERT_STAMPDISABLE_ANYREASON_MESSAGE:"使用中的贴图不能合并",
				
				ALERT_STAMPDISABLE_LAYER_MESSAGE1:"此贴图不能与",
				ALERT_STAMPDISABLE_LAYER_MESSAGE2:"，",
				ALERT_STAMPDISABLE_LAYER_MESSAGE3:"组合使用",
				
				/////////////////////////////////////////////////////////////////
				
				ALERT_STAMP_LIMIT_ITEM_AND_COLOR:"%s（%s）不能与使用中的贴图组合使用",
				ALERT_STAMP_LIMIT_ITEM:"%s不能与使用中的贴图组合使用",
				ALERT_STAMP_SELECTION_LIMIT_ITEM_AND_COLOR:"此贴图不能与%s（%s）组合使用",
				ALERT_STAMP_SELECTION_LIMIT_ITEM:"此贴图不能与%s组合使用",			
				
				ALERT_UPDATE_TITLE:"UTme!版本可以更新！",
				ALERT_UPDATE_REQUIRE_MESSAGE:"需先更新才能使用。请打开应用商城，更新至最新版本。",
				ALERT_UPDATE_RECCOMEND_MESSAGE:"请打开应用商城，更新至最新版本。",
				ALERT_LATER:"稍后",
				ALERT_UPDATE:"打开应用商城",
				
				ALERT_SELECTED_ITEM:"已选择%s",
				ALERT_SELECTED_ITEM_AND_COLOR:"已选择%s（%s）",
				
				LAYER_NAME_PAINT:"画图",
				LAYER_NAME_TYPOGRAPHY:"文字",
				LAYER_NAME_PHOTO:"照片",
				LAYER_NAME_STAMP:"其他贴图组套",
				
				LIMIT_DATE:"使用期限 ― ",
				LIMIT_DATE2:"截至",
				
				LIMIT_MULTI:"・贴多张贴图",
				LIMIT_SAME:"・贴同样的贴图",
				LIMIT_ROTATION:"・旋转",
				LIMIT_ROTATION_45:"・半旋转",
				LIMIT_OVERLAP:"・重叠",
				
				LIMIT_LAYER_PAINT:"・PAINT",
				LIMIT_LAYER_TYPOGRAPHY:"・TYPOGRAPHY",
				LIMIT_LAYER_PHOTO:"・PHOTO",
				LIMIT_LAYER_STAMP:"・STAMP",
				
				LIMIT_REMIX_SPLASH:"・SPLASH",
				LIMIT_REMIX_GLITCH:"・GLITCH",
				LIMIT_REMIX_MOSAIC:"・MOSAIC",
				LIMIT_REMIX_LAYOUT:"・AUTO DESIGNER",
				LIMIT_REMIX_MOMA01:"・MoMA EARLY MODERN STYLE",
				LIMIT_REMIX_MOMA02:"・MoMA COLLAGE",
				
				LIMIT_TIMELINE:"・不能在Timeline上发布",
				LIMIT_MARKET:"・不能在UTme！ Market投稿",
				LIMIT_TOPMOST:"・默认置于最上层",
				/*
				WEB_TITLE_TIMELINE:"Timeline",
				WEB_TITLE_MYPAGE:"我的主页",
				WEB_TITLE_CART:"购物车",
				WEB_TITLE_SEARCH:"搜索",
				WEB_TITLE_LIKE:"已收藏款式",
				WEB_TITLE_OPTION:"选项",
				WEB_TITLE_FACEBOOK:"分享到Facebook",
				WEB_TITLE_TWITTER:"分享到Twitter",
				WEB_TITLE_CART_EDIT:"更改购物车商品",
				WEB_TITLE_CART_ADD:"添加到购物车",
				WEB_TITLE_LIST:"投稿流程",
				WEB_TITLE_POST:"发布",
				WEB_TITLE_ITEM_EDIT:"款式信息编辑",
				WEB_TITLE_TERMS:"UTme! 使用协议",
				*/
				PHOTO_FILTER_NORMAL:"不做调整",
				PHOTO_FILTER_MONO:"黑白",
				PHOTO_FILTER_HICON:"高对比度",
				PHOTO_FILTER_PROCESS:"加工",
				PHOTO_FILTER_FADE:"淡出",
				PHOTO_FILTER_CHROME:"金属色"
				
			}
		};
		
		public static function getString(key:String,... args):String{
			var str:String=localisedStringSet[UTCapabilities.getLangCode()][key]||"";
			for (var i:uint = 0; i < args.length; i++) {
				var reg:RegExp=/%s/;
				str=str.replace(reg,String(args[i]));
			}
			return str;
		}
		
		public static function testLanguage():void{
			for (var key1:String in localisedStringSet){
				for (var key2:String in localisedStringSet){
					if(key1==key2)continue;
					var lng1:Object=localisedStringSet[key1];
					var lng2:Object=localisedStringSet[key2];
					trace("CHEKING",key1,"TO",key2 )
					for (var lc:String in lng1){
						if(!lng2.hasOwnProperty(lc))trace(key2 ," Not found",lc);
					}
					for (lc in lng1){
						if(!AppLang.hasOwnProperty(lc))trace("App Not found",lc);
					}
				}
			}
			for each (var key3:XML in describeType(AppLang).constant){
				if(key3.attribute("type")!="String")continue;
				
				for (var key6:String in localisedStringSet){
					var lng4:Object=localisedStringSet[key6];
					if(!lng4.hasOwnProperty(key3.attribute("name").toString()))trace(key6 ," Not found",key3.attribute("name").toString());
				}
			}
		}
	}
}

