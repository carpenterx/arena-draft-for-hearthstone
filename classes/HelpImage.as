package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import HelpHoverComponent;
	
	public class HelpImage extends MovieClip
	{
		private var bgBitmap:Bitmap;
		private var bgBD:BitmapData;

		public function HelpImage(backgroundBD:BitmapData):void
		{
			bgBD = backgroundBD;
			
			bgBitmap = new Bitmap(bgBD);
			//bgBitmap.alpha = 0.5;
			bgBitmap.smoothing = true;
			addChild(bgBitmap);
		}
	}
}