package
{
	import flash.display.MovieClip;
	
	public class HearthstoneCardData extends MovieClip
	{
		public var cardName:String;
		public var cardRarity:String;
		public var cardSet:String;
		public var cardClass:String;
		public var cardCost:int;
		public var cardType:String;
		public var cardWeight:int;
		public var cardTierScoreArray:Array;

		public function HearthstoneCardData(cName:String, cRarity:String, cSet:String, cClass:String, cCost:int, cType:String, cWeight:int, cTierScoreArray:Array):void
		{
			cardName = cName;
			cardRarity = cRarity;
			cardSet = cSet;
			cardClass = cClass;
			cardCost = cCost;
			cardType = cType;
			cardWeight = cWeight;
			cardTierScoreArray = cTierScoreArray;
		}

		public function updateCard(cWeight:int, cTierScoreArray:Array):void
		{
			cardWeight = cWeight;
			cardTierScoreArray = cTierScoreArray;
		}
	}
}