package utme.app.managers
{
	import com.kentaroid.air.AndroidSupport;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import utme.app.NSFuncs.UTDeviceCapabilities;
	
	public class FileManager
	{
		
		//セーブフォルダ
		static private const LIST_SAVE_DIR:String="com.uniqlo.utme";
		static private const TEMP_DIR:String="com.uniqlo.utme";
		static private const assetBasePath:String="assets/items/";
		
		private static var androidPath:File=null;
		static public function getAppStrageDir():File{
			if(UTDeviceCapabilities.isIOS()){
				return File.documentsDirectory;
			}else if(AndroidSupport.isSupported()){
				if(androidPath==null){
					if(AndroidSupport.refer.getSupportedExternalStorage()){
						var path:String=AndroidSupport.refer.getExternalStoragePath();
						if(path&&path.length>0){
							androidPath=new File(path)
							if(!androidPath.exists)androidPath.createDirectory();
						}
					}
					if(androidPath==null||!androidPath.exists)androidPath=File.applicationStorageDirectory;
				}
				return androidPath;
			}else{
				return File.documentsDirectory;
			}
		}
		
		static public function getStrageDir():File{
			return  getExternalStrageDir().resolvePath("v3");
		}
		
		static public function getExternalStrageDir():File{
			return  getAppStrageDir().resolvePath(LIST_SAVE_DIR);
		}
		static public function getCacheStrageDir():File{
			return  File.cacheDirectory.resolvePath(TEMP_DIR);
		}
		static public function getAssetsDir():File{
			return  getCacheStrageDir().resolvePath(assetBasePath);
		}
		
		
		static public function saveImageToAppLocal(bmd:BitmapData,file:File):Boolean{
			if(file.extension.toLowerCase().indexOf("png")>-1){
				return saveFileAsPng(bmd,file);
			}else if(file.extension.toLowerCase().indexOf("jpg")>-1){
				return saveFileAsJpg(bmd,file);
			}else{
				return saveFileAsByteArray(bmd,file);
			}	
		}
		
		static public function writeData(obj:ByteArray,f:File):Boolean{
			var stream:FileStream = new FileStream();
			try{
				stream.open(f, FileMode.WRITE);
				stream.writeBytes(obj,0,obj.length);
				stream.close();
			}catch(e:Error){
				trace("Writing Data error",f.nativePath);
				return false;
			}
			return true;
		}
		
		static public function loadImageFromAppLocal(f:File,width:int,height:int,callBack:Function):void{
			//trace("loadImageFromAppLocal");
			function _callBack(succes:Boolean,result:BitmapData):void{
				callBack(succes,result);
			}
			
			if(!f.exists)_callBack(false,null);
			if(f.extension.toLowerCase().indexOf("png")>-1||f.extension.toLowerCase().indexOf("jpg")>-1){
				loadImageFromAppLocalPng(f,callBack);
			}else{
				//trace("_loadImageFromAppLocal:RAW",f.nativePath);
				var bmd:BitmapData=loadFileFromByteArray(f,width,height,true,0);
				_callBack(bmd!=null,bmd);
			}
		}
		
		
		static public function loadImageFromAppLocalPng(f:File,callBack:Function):void{
			//trace("loadImageFromAppLocalPng");
			var ba:ByteArray = new ByteArray();
			function _callBack(succes:Boolean,result:BitmapData):void{
				callBack(succes,result);
				if(ba)ba.length=0;
				ba=null;
			}
			
			if(!f.exists)_callBack(false,null);
			
			try{
				//trace("_loadImageFromAppLocal:PNG",f.nativePath);
				var stream:FileStream = new FileStream( );
				stream.open(f, FileMode.READ);
				stream.readBytes(ba);
				stream.close();
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.INIT, function(e:Event):void{
					_callBack(true,(loader.content as Bitmap).bitmapData);
				});
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e:Error):void{
					if(!f.exists)_callBack(false,null);
				});
				loader.loadBytes(ba);
			}catch(e:Error){
				_callBack(false,null);
				trace("AppStorage::loadImageFromAppLocalPng" ,e);
			}
			
		}
		
		static public function saveXml(xml:XML,fileName:String):Boolean{
			var targetDir:File = getExternalStrageDir();
			var f:File=targetDir.resolvePath(fileName);
			var stream:FileStream = new FileStream();
			try{
				stream.open(f, FileMode.WRITE);
				stream.writeUTFBytes(xml.toXMLString());
				stream.close();
			}catch(e:Error){
				trace("XML writing error");
				return false;
			}
			return true;
		}
		
		static public function writeText(text:String,f:File):Boolean{
			var stream:FileStream = new FileStream();
			try{
				stream.open(f, FileMode.WRITE);
				stream.writeUTFBytes(text);
				stream.close();
			}catch(e:Error){
				trace("Writing text error",f.nativePath);
				return false;
			}
			return true;
		}
		
		
		static public function loadText(f:File):String{
			var ret:String="";
			if(f.exists){
				var fileStream:FileStream = new FileStream();
				fileStream.open(f, FileMode.READ); 
				ret=fileStream.readUTFBytes(fileStream.bytesAvailable);
				fileStream.close();
			}
			return ret;
		}
		
		
		static public function saveCache(bmd:BitmapData,fname:String):void{
			var targetDir:File = getCacheStrageDir().resolvePath("tmp");
			var f:File=targetDir.resolvePath(fname);
			saveFileAsByteArray(bmd,f);
			trace("saveCache",f.nativePath);
		}
		
		static public function loadCache(fname:String,width:int,height:int,transparent:Boolean,fillColor:int):BitmapData{
			var targetDir:File = getCacheStrageDir().resolvePath("tmp");
			var f:File=targetDir.resolvePath(fname);
			trace("loadCache",f.nativePath);
			return loadFileFromByteArray(f,width,height,transparent,fillColor);
		}
		
		static public function saveFileAsByteArray(bmd:BitmapData,file:File):void{
			if(file.exists)file.deleteFile();
			var a:ByteArray=bmd.getPixels(bmd.rect);
			try{
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeBytes(a);
				stream.close();
				a.clear();
			}catch(e){
				trace("saveFileAsByteArray",e);
			}
		}
		
		static public function loadFileFromByteArray(file:File,width:int,height:int,transparent:Boolean,fillColor:int):BitmapData{
			
			var bmd:BitmapData=new BitmapData(width,height,transparent,fillColor);	
			var fileStream:FileStream = new FileStream();
			try{
				fileStream.open(file, FileMode.READ); 
				var ba:ByteArray=new ByteArray;
				fileStream.readBytes(ba);
				fileStream.close();
				bmd.setPixels(bmd.rect,ba);
				ba.length=0;
				ba=null;
			}catch(e){
				trace("loadFileFromByteArray",e);
			}
			return bmd;
		}
		
		
		static public function loadFileToByteArray(file:File):ByteArray{
			
			var ba:ByteArray=new ByteArray;
			var fileStream:FileStream = new FileStream();
			try{
				fileStream.open(file, FileMode.READ); 
				ba==new ByteArray;
				fileStream.readBytes(ba);
				fileStream.close();
			}catch(e){
				trace("loadFileFromByteArray",e);
			}
			return ba;
		}
		
		static public function clearCache(all:Boolean):void{
			var targetDir:File = getCacheStrageDir().resolvePath("tmp");
			var targetMiscDir:File = getCacheStrageDir().resolvePath("misc");
			
			try{
				if(targetDir.exists)targetDir.deleteDirectory(true);
				if(all&&targetMiscDir.exists)targetMiscDir.deleteDirectory(true);
			}catch(e){
				trace("clearCache",e);
			}
		}
		
		
		static public function saveFileAsPng(bmd:BitmapData,file:File):Boolean{
			
			var byte:ByteArray=new ByteArray;
			bmd.encode(bmd.rect,new PNGEncoderOptions(true),byte);
			if(file.exists)file.deleteFile();
			var stream:FileStream = new FileStream( );
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(byte, 0, byte.length);
			stream.close();
			byte.clear();
			return true;
		}
		
		static public function saveFileAsJpg(bmd:BitmapData,file:File):Boolean{
			
			var byte:ByteArray=new ByteArray;
			bmd.encode(bmd.rect,new JPEGEncoderOptions(95),byte);
			if(file.exists)file.deleteFile();
			var stream:FileStream = new FileStream( );
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(byte, 0, byte.length);
			stream.close();
			byte.clear();
			return true;
		}
		
	}
}