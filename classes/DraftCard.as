package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	public class DraftCard extends MovieClip
	{
		public var bmp:Bitmap = new Bitmap();
		public var cardCount:int;
		public var cardName:String;

		public function DraftCard(cardName:String):void
		{
			addChildAt(bmp, 0);
			bmp.x = 122;

			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;

			this.cardName = cardName;
			cardCount = 1;
			displayCardCount();
		}

		public function displayCardCount():void
		{
			var displayStr:String = String(cardCount) + " x " + cardName;
			cardNameTxt.text = displayStr;
		}

		public function incrementCardNumber():void
		{
			cardCount++;
			displayCardCount();
		}
	}
}