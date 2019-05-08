package utme.app.NSFuncs
{
	import flash.system.Capabilities;
	
	public class UTDeviceCapabilities
	{
		public static function isIOS():Boolean{
			//return true;
			return Capabilities.manufacturer.toLowerCase().indexOf('ios') > -1;
		}
		
		public static function isAndroid():Boolean{
			//return true;
			return Capabilities.manufacturer.toLowerCase().indexOf('android') > -1;
		}
		
		public static function isIosStandardResolution():Boolean{
			if(isIOS()){
				if(Capabilities.screenDPI>200){
					return false;
				}else{
					return true;	
				}
			}else{
				return false;
			}
		}
		public static function isMobilePlatform():Boolean{
			return Capabilities.manufacturer.toLowerCase().indexOf('ios') > -1 || 
				Capabilities.manufacturer.toLowerCase().indexOf('android') > -1;
		}
		
	}
}