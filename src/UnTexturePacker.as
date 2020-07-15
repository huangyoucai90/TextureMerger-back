package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	
	public class UnTexturePacker extends Sprite
	{
		private var list:Array=[];
		
		private var index:Number=0;
		private var root:String;
		private var info:TextField;
		private var simp:Sprite;
		public function UnTexturePacker()
		{

			this.info=new TextField();
			this.info.textColor=0xff0000;
			this.info.width=300;
			this.info.height=50;
			this.addChild(this.info);
			this.info.text='请选择需要解压的文件目录';
			
			this.simp=new Sprite();
			this.simp.graphics.beginFill(0xffff00);
			this.simp.graphics.drawRect(0,0,100,50);
			this.simp.graphics.endFill();
			this.simp.width=100;
			this.simp.height=50;
			this.simp.x=300;
			this.addChild(this.simp);
			this.simp.addEventListener(MouseEvent.CLICK,this.chooseDir);

		}
		
		private function chooseDir(e:Event):void{
			if(this.info.text=='逆向解压中'){
				return;
			}
			var self=this;
			var file:File = new File();
			file.addEventListener(Event.SELECT, dirSelected);
			file.addEventListener(Event.CANCEL, cancel);
			file.browseForDirectory("Select a directory");
			
			function cancel(e:Event):void {
				self.info.text='请选择需要解压的文件目录';
			}
			function dirSelected(e:Event):void {
				trace(file.nativePath);
				self.info.text='开始逆向解压';
				self.root=file.nativePath;
				var list:Array = file.getDirectoryListing();
				for(var i:Number=0;i<list.length;i++){
					var temp:File=list[i] as File;
					var nameStr:Array=temp.name.split('.');
					if(temp.extension=='json'){
						self.list.push(nameStr[0]);
					}
				}
				self.index=0;
				self.uppacker();
			}
		}
		
		private function uppacker():void{
			
			this.info.text='逆向解压中';
			if(this.index<this.list.length){
				this.uppackerItem(this.list[this.index]);
			}
			else{
				this.info.text='解压完成';
				trace('全部解析完成');
			}
		}
		
		private function uppackerItem(names:String):void{
			var item:UnPackerItem=new UnPackerItem(this.root,names,fun);
			
			var self=this;
			function fun():void{
				self.index++;
				self.uppacker();
			}
		}
		
		
	}
	
	
}