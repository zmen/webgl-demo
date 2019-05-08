package utme.app.managers
{
	import com.adobe.crypto.SHA1;
	import com.sociodox.utils.Base64;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLLoader;
	
	import utme.app.UTO;
	import utme.app.consts.AppLang;
	import utme.app.consts.AppStoryDefs;
	import utme.app.consts.AppURI;
	import utme.app.consts.AppVals;
	import utme.views.common.UTSocialManager;
	import utme.views.common.VC_AlertView;
	import utme.views.common.classes.UTImageBuilder;

	public class UTStorageManager{
		private static var _db:DBUtils;
		private static var inited:Boolean;
		public static function get DB():DBUtils{return _db};
		
		public static var _initCallBack:Function;
		public static function init(callback:Function):void{
			_initCallBack=callback;
			var targetDir:File = FileManager.getStrageDir();
			if(!targetDir.exists)targetDir.createDirectory();
			_db=new DBUtils;
			_db.addEventListener(DBUtils.CONNECT_COMPLETE,openDB);
			_db.addEventListener(SQLErrorEvent.ERROR,dbError);
			_db.open(targetDir.resolvePath('A2MHVYE9.DB'));
		}
		
		static private function dbError(e:Event):void{
			_db.removeEventListener(DBUtils.CONNECT_COMPLETE,openDB);
			_db.removeEventListener(SQLErrorEvent.ERROR,dbError);
			trace("dbError:SQL connection Error !");	
		}
		static private function openDB(e:Event):void{
			_db.removeEventListener(DBUtils.CONNECT_COMPLETE,openDB);
			_db.removeEventListener(SQLErrorEvent.ERROR,dbError);
			trace("openDB:SQL connection complete !");
			initDB(function():void{
				UTStrageV2Funcs.moveOldData(function(progress:Number):void{
					trace("END MOVE DATA !");
					if(progress>1.0){
						checkLocalFiles(function(result:Boolean):void{
							trace("END CHECK DATA !");
							_initCallBack(99);
						})
					}else{
						_initCallBack(progress);
					}
				});
			});
		}
			
		static private function initDB(callback:Function):void{
			//MainTable
			_db.query(UTStrorageData.DB_DESIGN_CREATE,function(result:Boolean,data:Array):void{
				//trace(result,Dumper.toString(data));
				//OwnerTable
				_db.query(UTStrorageData.DB_OWNER_CREATE2,function(result:Boolean,data:Array):void{
					//trace(result,Dumper.toString(data));
					callback();
				});
			});
		}
		
		/////////////////////////////////////////////////////////////////////////////		
		

		static private var _mimeTypes:Object = {
			".css":"text/css",
			".gif":"image/gif",
			".htm":"text/html",
			".html":"text/html",
			".ico":"image/x-icon",
			".jpg":"image/jpeg",
			".js":"application/x-javascript",
			".png":"image/png"
		
		}
		static private function getMimeType(path:String):String
		{
			var mimeType:String;
			var index:int = path.lastIndexOf(".");
			if (index > -1)
			{
				mimeType = _mimeTypes[path.substring(index)];
			}
			return mimeType == null ? "text/html" : mimeType; // default to text/html for unknown mime types
		}
		

		static public function checkLocalFiles(callback:Function):void{
			function _callback(result:Boolean):void{
				callback(result);
			}
			
			UTStorageManager.DB.query(UTStrorageData.getItemSQL(),function(result:Boolean,data:Array):void{
				//trace("CHECK DB******************\n",result,Dumper.toString(data),"\n**********************************");
				if(!result)callback(false);
				
				var i:int;
				var j:int;
				
				var imageDir:File=FileManager.getStrageDir().resolvePath("images");
				var thumbDir:File=FileManager.getStrageDir().resolvePath("thumbs");	
				var deleteList:Vector.<Object>=new Vector.<Object>;
				
				try{
					var files:Array=imageDir.getDirectoryListing().concat(thumbDir.getDirectoryListing());
					var fileNames:Vector.<String>=new Vector.<String>;
					var fileUsed:Vector.<Boolean>=new Vector.<Boolean>;
					for(i=0;i<files.length;i++){
						//trace((files[i] as File).name);
						fileNames.push((files[i] as File).name);
						fileUsed.push(false);
					}
					for(j=0;j<data.length;j++){
						i=fileNames.indexOf(UTO.toString(data[j],"file"));//convert to string
						if(i>-1)fileUsed[i]=true;
						i=fileNames.indexOf(UTO.toString(data[j],"thumb"));
						if(i>-1)fileUsed[i]=true;
						i=fileNames.indexOf(UTO.toString(data[j],"layer_front"));
						if(i>-1)fileUsed[i]=true;
						i=fileNames.indexOf(UTO.toString(data[j],"layer_back"));
						if(i>-1)fileUsed[i]=true;
					}
					for(i=0;i<files.length;i++){
						if(!fileUsed[i]){
							trace("FILE-DELETE",fileNames[i]);	
							if((files[i] as File).isDirectory){
								(files[i] as File).deleteDirectory(true);
							}else{
								(files[i] as File).deleteFile();
							}					
						}
					}
					for(j=0;j<data.length;j++){
						/////////////////////////////////////////////////////////////////////////////////////////////////////
						var f:File=imageDir.resolvePath(UTO.toString(data[j],"file"));
						var thumb:File=thumbDir.resolvePath(UTO.toString(data[j],"thumb"));
						var top:File=UTO.toString(data[j],"layer_front").length>0?imageDir.resolvePath(UTO.toString(data[j],"layer_front")):null;
						var back:File=UTO.toString(data[j],"layer_back").length>0?imageDir.resolvePath(UTO.toString(data[j],"layer_back")):null;
						
						if(!f.exists||!thumb.exists||(top!=null&&!top.exists)||(back!=null&&!back.exists)){
							if(f.exists)f.deleteFile();
							if(thumb.exists)thumb.deleteFile();
							if(top!=null&&top.exists)top.deleteFile();
							if(back!=null&&back.exists)back.deleteFile();
							deleteList.push(data[j]);
							trace("DELETE-RECORD",UTO.toString(data[j],"id"));	
						}
					}	
					trace("DETA CHECK DELETE-RECORD",Dumper.toString(deleteList));	
					
					j=0;
					deletionDatas();
					function deletionDatas():void{
						if(j<deleteList.length){
							deleteRecordWithFile(deleteList[j],function(result:Boolean):void{
								j++;
								deletionDatas();
							});
						}else{
							_callback(true);
						}
					}
					
				}catch(e:Error){
					trace("DELETE FILE ERROR",e);
					_callback(false);
				}
				
			});
		}
		
		static private function deleteRecordWithFile(data:Object,callback:Function=null):void{
			try{
				var imageDir:File=FileManager.getStrageDir().resolvePath("images");
				var thumbDir:File=FileManager.getStrageDir().resolvePath("thumbs");	
				
				var f:File=imageDir.resolvePath(UTO.toString(data,"file"));
				var thumb:File=thumbDir.resolvePath(UTO.toString(data,"thumb"));
				var top:File=UTO.toString(data,"layer_front").length>0?imageDir.resolvePath(UTO.toString(data,"layer_front")):null;
				var back:File=UTO.toString(data,"layer_back").length>0?imageDir.resolvePath(UTO.toString(data,"layer_back")):null;
				
				if(f.exists)f.deleteFile();
				if(thumb.exists)thumb.deleteFile();
				if(top!=null&&top.exists)top.deleteFile();
				if(back!=null&&back.exists)back.deleteFile();
				
			}catch(e:Error){
				trace("deleteRecordWithFile:DELETE FILE ERROR",e);
			}
			UTStorageManager.DB.query(UTStrorageData.deleteSQL(UTO.toString(data,"id")),function(result:Boolean,_data:Array):void{
				UTStorageManager.DB.query(UTStrorageData.deleteDesignOwnerSQL(UTO.toString(data,"id"),"",""));
				trace("delete result",result,Dumper.toString(_data),result&&_data.length>0&&UTO.toNumber(_data[0],"rows")>0);
				if(callback!=null)callback(result&&_data.length>0&&UTO.toNumber(_data[0],"rows")>0);
			});
		}
		
		static public function deleteRecord(id:String,callback:Function=null):void{
			if(id.length>0){
				UTStorageManager.DB.query(UTStrorageData.getItemSQL(id),function(result:Boolean,data:Array):void{
					trace(UTStrorageData.getItemSQL(id));
					if(result&&data.length==1){
						deleteRecordWithFile(data[0],callback);
					}else{
						callback(false);
					}
				});
			}else{
				callback(false);
			}
		}
		
		static public function updateDesignOwner(id:String,t_shirt_id:String,userID:String="",callBack:Function=null):void{
			if(id==null||t_shirt_id==null||id.length==0||t_shirt_id.length==0){
				if(callBack!=null)callBack(false);
				return ;
			}
			UTStorageManager.DB.query(UTStrorageData.getDesignOwnerByDesignIDSQL(id,t_shirt_id),function(result:Boolean,data:Array):void{
				if(result&&data.length==1&&UTO.toString(data[0],"userId").length>0&&userID.length==0){
					trace("updateDesignOwner:NO UPDATE");
					if(callBack!=null)callBack(false);
				}else{
					trace("updateDesignOwner:UPDATE OR INSERT");
					if(userID.length>0){
						UTStorageManager.DB.query(UTStrorageData.deleteDesignOwnerSQL(id,"",userID),function(result:Boolean,data:Array):void{
							//削除してからinsertする
							UTStorageManager.DB.query(UTStrorageData.updateDesignOwnerSQL(id,t_shirt_id,userID),function(result:Boolean,data:Array):void{
								if(callBack!=null)callBack(result);	
							});
						});
					}else{
						UTStorageManager.DB.query(UTStrorageData.updateDesignOwnerSQL(id,t_shirt_id,userID),function(result:Boolean,data:Array):void{
							if(callBack!=null)callBack(result);	
						});
					}
				}
			});
		}
		
		static public function deleteDesignOwner(id:String,t_shirt_id:String,callBack:Function):void{
			if(id==null||t_shirt_id==null||id.length==0||t_shirt_id.length==0){
				if(callBack!=null)callBack(false);
				return ;
			}
			trace("deleteDesignOwner:DELETE");
			UTStorageManager.DB.query(UTStrorageData.deleteDesignOwnerSQL(id,t_shirt_id,""),function(result:Boolean,data:Array):void{
				if(callBack!=null)callBack(result);	
			});
		}
		
		
		static public function getDesignOwner(id:String,callback:Function):void{
			UTStorageManager.DB.query(UTStrorageData.getDesignOwnerSQL(id),callback);
		}
		
		static public function SaveDataToLocal(bmd:BitmapData,callBack:Function):void{
			var dt:Number=(new Date).getTime();
			var newId:String;
			var extention:String=AppVals.DEBUG_MODE?".png":".bin";
			var f:File;
			var imageDir:File;
			var thumbDir:File
			try{
				var targetDir:File =FileManager.getStrageDir();
				if(!targetDir.exists)targetDir.createDirectory();
				imageDir=targetDir.resolvePath("images");
				thumbDir=targetDir.resolvePath("thumbs");
				if(!imageDir.exists)imageDir.createDirectory();
				if(!thumbDir.exists)thumbDir.createDirectory();
				fase1();
			}catch(e:Error){
				trace("SaveToLocalApp1",e);
				_callBack(false,"");
				return;
			}
			
			function fase1():void{
				newId=SHA1.hash(String(dt)+"-"+String(int(Math.random()*100000)));
				UTStorageManager.DB.query(UTStrorageData.getExistsItemSQL(newId),function(result:Boolean,data:Array):void{
					if(result){
						if(data[0].CNT>0){
							fase1();
						}else{
							fase2();
						}
					}else{
						_callBack(false,"");
					}
				});
			}
			
			var fn:String;
			var ftn:String;
			var front:String
			var back:String;
			
			function fase2():void{
				try{
					fn="utme_"+String(newId)+extention;
					ftn="utme_"+String(newId)+"_thumb.jpg";
					front="utme_"+String(newId)+"_front"+extention;
					back="utme_"+String(newId)+"_back"+extention;
					
					var top:BitmapData=UTStampManager.hasLayerTopMost()?UTStampManager.getTopLayerImage():null;
					var hasTopLayer:Boolean=top!=null;
					var hasBackLayer:Boolean=hasTopLayer&&bmd!=null;
					
					
					var thumb:BitmapData=new BitmapData(320,320,false,0xFFFFFFFF);
					UTImageBuilder.createPrintedImage(thumb,bmd,UTItemManager.outMultiply ,true,true,true);
					FileManager.saveImageToAppLocal(thumb,thumbDir.resolvePath(ftn));
					thumb.dispose();
					
					/////// main 
					if(hasTopLayer){
						var main:BitmapData=new BitmapData(UTItemManager.IMAGE_WIDTH,UTItemManager.IMAGE_HEIGHT,true,0);
						if(bmd!=null)main.copyPixels(bmd,bmd.rect,new Point(0,0));
						main.draw(top);
						if(UTStampManager.used() && UTStampManager.hasCopyLights){
							var m:Matrix=new Matrix;
							var copyLightsSprite:Sprite=UTStampManager.getCopyLitesSprite(false);
							m.identity();
							m.translate(-UTStampManager.COPY_LEFT,-copyLightsSprite.height-UTStampManager.COPY_BOTTOM);
							m.translate(main.width,main.height);
							main.drawWithQuality(copyLightsSprite,m,null,null,null,true,StageQuality.HIGH);
						}
						FileManager.saveImageToAppLocal(main,imageDir.resolvePath(fn));
						main.dispose();
						main=null;
						FileManager.saveImageToAppLocal(top,imageDir.resolvePath(front));
						top.dispose();
						top=null;
						if(bmd!=null)FileManager.saveImageToAppLocal(bmd,imageDir.resolvePath(back));
					}else{
						FileManager.saveImageToAppLocal(bmd,imageDir.resolvePath(fn));
					}
					
					var write:UTStrorageData=new UTStrorageData;
					write.id=newId;
					write.file=fn;
					write.thumb=ftn;
					write.imageSize=UTItemManager.IMAGE_WIDTH+","+UTItemManager.IMAGE_HEIGHT;
					write.story=AppStoryDefs.getStoryJson();
					write.itemCode=UTItemManager.currentItem.itemId;
					write.itemColorCode=UTItemManager.currentItem.id;

					if(UTStampManager.used()){
						write.stamp_data=UTStampManager.decodeStampSet();
						if(hasTopLayer){
							write.layer_front=front;
						}
						if(hasBackLayer){
							write.layer_back=back;
						}
					}
					write.time=dt;	
					UTStorageManager.DB.query(write.getInsertSQL(),function(result:Boolean,data:Array):void{
						trace(result,Dumper.toString(data));
						_callBack(result,result?newId:"");
					});
					
					
				}catch(e:Error){
					trace("SaveToLocalApp2",e);
					_callBack(false,"");
					return;
				}
					
			}
			
			function _callBack(succes:Boolean,_newID:String):void{
				if(!succes){
					if(fn)f=imageDir.resolvePath(fn);
					if(f&&f.exists)f.deleteFile();
					if(ftn)f=thumbDir.resolvePath(ftn);
					if(f&&f.exists)f.deleteFile();
					if(front)f=imageDir.resolvePath(front);
					if(f&&f.exists)f.deleteFile();
					if(back)f=imageDir.resolvePath(back);
					if(f&&f.exists)f.deleteFile();
				}
				callBack(succes,_newID);
			}
		}
		
		static public function getSaveListArray(start:int,num:int,callBack:Function):void{
			if(num<1)num=10;	
			UTStorageManager.DB.query(UTStrorageData.getListSQL(start,num<1?10:num),function(result:Boolean,data:Array):void{
				if(result){
					var ret:Array=new Array
					for(var i:int=0;i<data.length;i++){
						if(data[i].hasOwnProperty("id"))
							ret.push({
								id:data[i].id,
								//image_url:"http://localhost:"+AppAPIServer.PORT+"/"+data[i].thumb
								image_url:"data:"+getMimeType(data[i].thumb)+";base64,"+Base64.encode(FileManager.loadFileToByteArray(FileManager.getStrageDir().resolvePath("thumbs/"+data[i].thumb)))
						});
					}
					callBack(UTSocialManager.STATUS_SUCCESS,ret)
				}else{
					callBack(UTSocialManager.STATUS_ERROR,null)				
				}
			});
		}
		
		static public function LoadDataFromLocal(id:String,callBack:Function):void{
			var imageDir:File;
			imageDir=FileManager.getStrageDir().resolvePath("images");
			UTStorageManager.DB.query(UTStrorageData.getItemSQL(id),function(result:Boolean,data:Array):void{
				if(result){
					var write:UTStrorageData=UTStrorageData.assignStorageItem(data); 
					if(write!=null){
						fase1(write);
					}else{
						_callBack(false,null,null);
					}
				}else{
					_callBack(false,null,null);
				}
			});
	
			
			function fase1(data:UTStrorageData):void{
				if(data.story.length>0){
					var _data:Object = JSON.parse(data.story);
					AppVals.Story.length=0;
					for(var i:int=0;i<_data.length;i++){
						if(_data[i].length>0){
							var a:Array=new Array;
							for(var t:int=0;t<_data[i].length;t++){
								a.push(_data[i][t]);
							}
							AppVals.Story.push(a);
						}
					}
				}
				AppVals.HISTORY=AppVals.Story.length-1;
				UTStampManager.removeAllSet();
				
				var __w:int=AppVals.V1_IMAGE_WIDTH;
				var __h:int=AppVals.V1_IMAGE_HEIGHT;
				var pos:Array=data.imageSize.split(",");
				if(pos.length==2){
					__w=pos[0];
					__h=pos[1];
				}
				
				if(data.stamp_data.length>0){
					UTStampManager.encodeStampSet(data.stamp_data);
					if(data.layer_front.length>0){
						FileManager.loadImageFromAppLocal(imageDir.resolvePath(data.layer_front),__w,__h,function(success:Boolean,front:BitmapData):void{
							if(success){
								UTStampManager.setTopLayerImage(front);
								front.dispose();
								front=null;
								if(data.layer_back.length>0){
									FileManager.loadImageFromAppLocal(imageDir.resolvePath(data.layer_back),__w,__h,function(success:Boolean,back:BitmapData):void{
										if(success){
											_callBack(true,back,data);										
										}else{
											_callBack(false,null,null);
										}
									});
								}else{
									_callBack(true,null,data);
								}
							}else{
								_callBack(false,null,null);
							}
						});
					}else{
						_loadMainImage();
					}
				}else{
					_loadMainImage();
				}
				
				function _loadMainImage():void{
					FileManager.loadImageFromAppLocal(imageDir.resolvePath(data.file),__w,__h,function(success:Boolean,main:BitmapData):void{
						if(success){
							_callBack(true,main,data);										
						}else{
							_callBack(false,null,null);
						}
					});
				}
			}
			
			function _callBack(succes:Boolean,result:BitmapData,data:UTStrorageData):void{
				function onAPIError(e:Event):void{ 
					VC_AlertView.showErrorDialog(true);
					callBack(false,null,null);
				}
				if(succes){
					if(UTStampManager.used()){
						var url:String=AppURI.GetAPI(AppURI.URL_STAMP_ARE_ABAILABLE)+"?ids="+UTStampManager. getIdsString();
						trace(url);
						var url_loader : URLLoader = new URLLoader();
						url_loader.addEventListener (Event.COMPLETE,function(e:Event):void{
							try{
								var r:String = e.target.data;
								trace(r);
								var json:Object = JSON.parse(r);
								if(json.success){
									var err_code:int=1;
									if(json.is_stamps_available){
										callBack(true,result,data);
										return;
									}else{
										err_code=int(json.error_code);
									}
									VC_AlertView.showAlert(
										AppLang.getString(err_code==0?AppLang.ALERT_STAMPDISABLE_BYLIST_MESSAGE1:AppLang.ALERT_STAMPDISABLE_BYLIST_MESSAGE2),
										AppLang.getString(AppLang.ALERT_STAMPDISABLE_BYLIST_TITLE),
										Vector.<String>[AppLang.getString(AppLang.ALERT_OK)],null
									);
									callBack(false,null,null);
									return;
								}
							}catch(e:SyntaxError){}
							VC_AlertView.showErrorDialog(false);
							callBack(false,null,null);
						});	
						url_loader.addEventListener(IOErrorEvent.IO_ERROR,onAPIError);
						url_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onAPIError);
						url_loader.load(AppURI.getAuthorizedURLRequest(url));
					}else{
						callBack(true,result,data);
					}
				}else{
					VC_AlertView.showErrorDialog(false);
					callBack(false,null,null);
				}	
			}
		}	
	}
}