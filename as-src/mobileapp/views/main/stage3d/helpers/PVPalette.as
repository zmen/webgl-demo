package utme.views.main.stage3d.helpers
{
	import flash.display.MovieClip;
	
	public class PVPalette extends MovieClip
	{
		
		
		public var cbColorSelected:Function=null;
		public var mSelectedIndex:uint;
		private var cols:Array=[
			[0x003399,0xe60013,0xfff000,0x000000],
			[0xff65a4,0xff9e9d,0xffe9a3,0x98cc96,0x3fb8af],
			[0xff65a4 ,0x415587],
			[0xffccff,0x99cc99],
			[0xffff00,0xcccccc],
			[0x000000,0xc7c7d1,0xff0000],
			[0x000000,0x515151,0x858585],			
			[0x0066ff,0xffcc00,0xff0000],
			[0xe60013,0xfebbe4,0xffee00,0x2eaf01,0x00afd5,0x415587,0xff65a4,0x000000]
			
		];
		
		private var cells:Vector.<PVPaletteCell>;
		
		public function PVPalette()
		{
			super();
			cells=new Vector.<PVPaletteCell>;
			var i:int=0;
			for(var _y:int=0;_y<cols.length;_y++){
				var c:PVPaletteCell=new PVPaletteCell(_y);
				c.y=_y*100+22;
				c.setColor(cols[i%cols.length]);
				c.cbColorSelected=colorSelected;
				this.addChild(c);
				cells.push(c);
				i++;
			}
			this.graphics.beginFill(0xFFFFFF,0.5);
			this.graphics.drawRect(0,0,10,cols.length*100+24);
			this.graphics.endFill();
		}
		
		public function colorSelect(index:int):void{
			cells[index].clicked();
		}
		
		public function getSelectedColor():int{
			return mSelectedIndex;
		}
		
		private function colorSelected(colors:Array,index:uint):void{
			mSelectedIndex=index;
			if(cbColorSelected!=null)cbColorSelected(colors);
			for(var i:int;i<cells.length;i++)cells[i].selected(false);
		}
	}
}