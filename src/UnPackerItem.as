package
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.graphics.codec.PNGEncoder;

	public class UnPackerItem
	{
		private var sourceBitmap:BitmapData;
		private var list:Array=[];
		private var data:Object;
		private var names:String;
		private var fun:Function;
		private var root:String;
		public function UnPackerItem(root:String,names:String,fun:Function)
		{
			this.root=root;
			this.names=names;
			this.loadJson();
			this.fun=fun;
		}
		
		private function loadJson():void{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(this.root+'/'+this.names+".json"));
			urlLoader.addEventListener(Event.COMPLETE, decodeJSONHandler);
			
		}
		private function decodeJSONHandler(event:Event):void
		{
			var jsonObj:Object = new Object();
			jsonObj = com.adobe.serialization.json.JSON.decode(event.target.data);
			
			this.data=jsonObj.frames;
			this.list=[];
			for(var obj:String in this.data){
				var tempData:Object=this.data[obj] ;
				var names:String=obj;
				var w:Number=tempData.w;
				var h:Number=tempData.h;
				var sw:Number=w;
				if(tempData.sourceW)
					sw=tempData.sourceW;
				var sh:Number=h;
				if(tempData.sourceH)
					h=tempData.sourceH;
				var ox:Number=0;
				if(tempData.offX)
				 ox=tempData.offX;
				var oy:Number=0;
				if(tempData.offY)
					oy=tempData.offY;
				var x:Number=tempData.x;
				var y:Number=tempData.y;
				
				this.list.push({names:names,w:w,h:h,sw:sw,sh:sh,ox:ox,oy:oy,x:x,y:y});
			}
			
			
			var img:ImageLoader = new ImageLoader(this.root+'/'+this.names+'.png',pngComplate); 
		}
		
		private function pngComplate(source:BitmapData):void{
			this.sourceBitmap=source;
			this.index=0;
			this.listLogic();
		}
		
		private var index:Number=0;
		private function listLogic():void{
			if(this.index<this.list.length){
				var obj:Object=this.list[this.index];
//				this.writePNG(obj.w,obj.h,obj.x,obj.y,this.names+'_'+obj.names);
				this.writePNG(obj);
			}
			else{
				this.fun();
			}
		}
		
//		private function writePNG(w:Number,h:Number,ox:Number,oy:Number,name:String):void{
		private function writePNG(obj:Object):void{
			var jpgSource:BitmapData=new BitmapData(obj.sw,obj.sh);//mc为绘制图片的Sprite 
			for(var i:Number=0;i<obj.sw;i++){
				for(var j:Number=0;j<obj.sh;j++)
					jpgSource.setPixel32 (i,j,0x00000000);
			}

			jpgSource.copyPixels(this.sourceBitmap,new Rectangle(obj.x,obj.y,obj.w,obj.h),new Point(obj.ox,obj.oy));
			var myMatrix:Matrix=new Matrix ;
			myMatrix.scale(1,1);

			var jpg: PNGEncoder= new PNGEncoder();
			var fileFullName:String = 'd:/export/'+this.names+"/"+this.names+'_'+obj.names+".png" ;//File.desktopDirectory.nativePath(name+".png").nativePath;
			var file:File = new File(fileFullName);
			trace(file.nativePath);        
			var stream:FileStream = new FileStream();
			stream.openAsync(file,FileMode.WRITE);
			stream.addEventListener(Event.COMPLETE, this.fileCompleteHandler); 
			stream.addEventListener(Event.CLOSE, this.fileCompleteHandler); 
			stream.writeBytes(jpg.encode(jpgSource));
			stream.close();
			
		}
		
		private function fileCompleteHandler(e:Event):void {
			this.index++;
			trace('writePNG',this.index);
			this.listLogic();
		}
		
		
	}
	
	
}
import com.adobe.serialization.json.JSON;

import flash.display.BitmapData;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.graphics.codec.PNGEncoder;

