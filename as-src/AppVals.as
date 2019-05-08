package utme.app.consts {
import flash.display.Stage;
import flash.display3D.Context3DProfile;

public class AppVals {
    //グローバルパラメータ設定

    //////////////////////////////////////

    static public var DEBUG_THA_DUMMY_CHECK:Boolean = false;
    static public var DEBUG_MODE_SERVER:Boolean = true;
    static public var DEBUG_MODE:Boolean = false;
    static public var DEBUG_MODE_LANG:String = "";

    static public var DEBUG_MODE_NO_MARKET:Boolean = false;
    static public var DEBUG_MODE_NO_EC:Boolean = false;
    static public var DEBUG_MODE_STAMP_ONLY:Boolean = false;


    static public var APPLICATION_STORE_MODE:Boolean = false;
    static public var APPLICATION_MOMA_MODE:Boolean = false;

    static public var API_VERSION:String = "v4";

    static public var TERMS_URL:String = ""
    static public var FAQ_URL:String = ""
    static public var STAMP_URL:String = ""
    static public var MARKET_URL:String = ""
    static public var MYPAGE_URL:String = ""
    static public var CART_URL:String = ""
    static public var SEARCH_URL:String = ""
    static public var LIKES_URL:String = ""
    static public var OPTIONS_URL:String = ""

    //////////////////////////////////////

    //Stage3Dで使うテクスチャサイズ
    static public const TEXTURE_WIDTH:Number = 2048;
    static public const STAGE3D_PROFILE:String = Context3DProfile.BASELINE;

    //一覧サムネイルサイズ
    static public const LIST_SAVE_THUMB_WIDTH:int = 600;

    static public const V1_LIST_IMAGE_WIDTH:int = 294;
    static public const V1_LIST_IMAGE_HEIGHT:int = 331;
    static public const V1_IMAGE_WIDTH:int = 2048;
    static public const V1_IMAGE_HEIGHT:int = 2304;


    //イントロが消える時間
    static public var ANIMATION_FADE_TIME:uint = 3000;
    static public const MENU_FADE_TIME:Number = 0.4;


    //XMLファイル名 リスト、設定
    public static const XML_LIST_NAME:String = "Gu4vBNSMebX5.xml";
    public static const XML_SETTING_NAME:String = "Bi2RY5se6WZr.xml";


    //Notification XML
    //Facebook APIキー
    public static const FLOWER:String = "1409276442672341";
    //Twitter APIキー
    //public static const LEAF:String="+RUkDBBmVAIhW5tu2nt7RIXCrSgpf0ADH01q85ffVJ8tOysb8hGhO1bbGnKvdtPEyx6R5O0h/eReYpqpK7BJMWYfkM3M96HA7oh/jjo/XlnI5WW8V/eqw/LvJ4UZ/43dBi1jVJqlzXnmjlm9SIQkDAwS+PeXUD71thd3h2FFuic=";
    public static const LEAF:String = "mF4pNjvfFpsHo6LfoIfkeFvSt8DxBbKW6rdi4KH2kxAuD7zaTZDk2nCWKIlzg2s+pSrg1BdUWmY9rb7eQLcIaBngh+XW+ZB4/hG/poUxIGhS9MLoCc5wOuKPR5xJhaQ3v2vii1cMOcB/1mBzKCfbIWwks/76YTbbsmj5IBuOU3Q=";

    //stage3D
    public static var ScaleMaxRemix:Number = 0.9;
    public static var ScaleMaxPaint:Number = 1.05;
    public static var ScaleMin:Number = 0.6;
    public static var TEXT_THICKNESS:int = 0;

    public static const StampListRecentNum:int = 3;
    public static const RAD_RAUND:Number = 3.0

    /////////////////////////////////////////////////////////////////////////
    //シングルトン代用
    static public var HISTORY:int;

    static public var REMIX_MOVE_RIMIT:Boolean = false;
    static public var REMIX_MOVE_RIMIT_RATE:Number = 0.3;
    static public var REMIX_PERTICLE_SPEED:Number = 1.0;

    static public var STATUSBAR_HEIGHT:Number = 0;
    static public const HEADER_HEIGHT:Number = 98;

    static public var GLOBAL_SCALE:Number = 0;
    static public var stage:Stage;

    static public var Paint_LastColor:int = 0;
    static public var Paint_LastSelectedColor:int = 0;
    static public var Paint_LastColorSelectMode:Boolean = false;
    static public var Type_LastColor:int = 0;
    static public var Type_LastFontType:int = 0;
    static public var Type_LastFontStyle:int = 2;

    static public var DisplayedDragInfoStamp:Boolean = false;
    static public var DisplayedDragInfoPhoto:Boolean = false;
    static public var DisplayedDragInfoTypography:Boolean = false;

    static public var SavedListUpdated:Boolean = false;

    //タブモードフラグ（動的セット）
    static public var APPLICATION_NO_MARKET_MODE:Boolean = false;
    static public var APPLICATION_NO_EC_MODE:Boolean = false;
    //スタンプ（中国）モードフラグ（動的セット）
    static public var APPLICATION_STAMP_MODE:Boolean = false;


    //キー
    static public var Cat:String = "";
    static public var Dog:String = "";

    //ストーリ
    static public var Story:Vector.<Array> = new Vector.<Array>;
    static public var IPCountryCode:String = "";

    static public var announcementQue:Object = null;

    // Push Notifications
    public static const GCM_ID:String = "785294427645";
    public static const PLATFORM_ARN_APNS:String = "arn:aws:sns:ap-northeast-1:599453524280:app/APNS/prd01_utme_ios";
    public static const PLATFORM_ARN_GCM:String = "arn:aws:sns:ap-northeast-1:599453524280:app/GCM/prd01_utme_android";
//		public static const PLATFORM_ARN_APNS:String = "arn:aws:sns:ap-northeast-1:786520528811:app/APNS_SANDBOX/stg01_utme_ios";
//		public static const PLATFORM_ARN_GCM:String = "arn:aws:sns:ap-northeast-1:786520528811:app/GCM/stg01_utme_android";

    //Paint View
    public static const ERASE_MODE:String = "eraser_selected";
    public static const THICK_BRUSH_MODE:String = "thick_brush_selected";
    public static const THIN_BRUSH_MODE:String = "thin_brush_selected";

    public static var SELECTED_TOOL_MODE:String = THICK_BRUSH_MODE;

    public static var STICKER_SET_THRESHOLD:Number = 5;
}
}
