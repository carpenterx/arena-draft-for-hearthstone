package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	public class HearthstoneLargeCard extends MovieClip
	{
		public var cardName:String;
		public var tierScore:int;
		public var bmp:Bitmap = new Bitmap();

		public function HearthstoneLargeCard(cardName:String, tierScore:int):void
		{
			addChild(bmp);

			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;

			this.cardName = cardName;
			this.tierScore = tierScore;

			tierScoreTxt.text = String(tierScore);
		}
	}
}