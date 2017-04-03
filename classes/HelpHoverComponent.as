package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class HelpHoverComponent extends MovieClip
	{
		private var bmp:Bitmap;

		private const LINE_THICKNESS:int = 3;
		private const LINE_COLOR:uint = 0xFF0000;

		private var infoString:String;

		public function HelpHoverComponent(componentBD:BitmapData, infoStr:String):void
		{
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;

			infoString = infoStr;

			var fullBd:BitmapData = new BitmapData(componentBD.width + 2*LINE_THICKNESS, componentBD.height + 2*LINE_THICKNESS, false, LINE_COLOR);
			fullBd.copyPixels(componentBD, new Rectangle(0, 0, componentBD.width, componentBD.height), new Point(LINE_THICKNESS, LINE_THICKNESS));
			bmp = new Bitmap(fullBd);
			//bmp.alpha = 0.5;
			bmp.smoothing = true;
			bmp.x = -LINE_THICKNESS;
			bmp.y = -LINE_THICKNESS;
			addChild(bmp);
		}

		public function getInfo():String
		{
			return infoString;
		}
	}
}