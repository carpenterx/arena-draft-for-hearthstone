package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	import flash.events.Event;
	import flash.text.TextFieldType;

	import HearthstoneCardData;
	
	public class TierListComponent extends MovieClip
	{
		// card properties
		public var cardName:String;
		public var cardRarity:String;
		public var cardSet:String;
		public var cardClass:String;
		public var cardCost:int;
		public var cardType:String;
		public var cardWeight:int;
		public var cardTierScoreArray:Array = new Array();

		// default card properties
		public var defaultCardWeight:int;
		public var defaultCardTierScoreArray:Array = new Array();

		private var tierScoreTextArr:Array = new Array();
		private var blackTxtFormat:TextFormat = new TextFormat();
		private var greenTxtFormat:TextFormat = new TextFormat();
		public var wasModified:Boolean = false;

		private const classesArr:Array = ["Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"];

		private const ZERO_REPRESENTATION:String = "-";

		public function TierListComponent(cName:String, cRarity:String, cSet:String, cClass:String, cCost:int, cType:String, cWeight:int, cTierScoreArray:Array):void
		{
			cardName = cName;
			cardRarity = cRarity;
			cardSet = cSet;
			cardClass = cClass;
			cardCost = cCost;
			cardType = cType;
			cardWeight = cWeight;
			cardTierScoreArray = cardTierScoreArray.concat(cTierScoreArray);

			defaultCardWeight = cWeight;
			defaultCardTierScoreArray = defaultCardTierScoreArray.concat(cTierScoreArray);

			var tahomaFnt:Font = new TahomaFnt();
			
			blackTxtFormat.font = tahomaFnt.fontName;
			blackTxtFormat.size = 14;
			blackTxtFormat.color = "0x000000";

			greenTxtFormat.font = tahomaFnt.fontName;
			greenTxtFormat.size = 14;
			greenTxtFormat.color = "0x009933";

			tierScoreTextArr = [tierScoreTxt1, tierScoreTxt2, tierScoreTxt3, tierScoreTxt4, tierScoreTxt5, tierScoreTxt6, tierScoreTxt7, tierScoreTxt8, tierScoreTxt9];
			cardNameTxt.text = cardName;
			var auxScore:String;
			for(var i:int = 0; i < cardTierScoreArray.length; i++)
			{
				tierScoreTextArr[i].restrict = "0-9";
				// make tier score text boxes uneditable for the classes that do not have that card
				if(cardClass.indexOf(classesArr[i]) == -1 && cardClass != "Neutral")
				{
					tierScoreTextArr[i].type = TextFieldType.DYNAMIC;
				}
				if(cardTierScoreArray[i] == 0)
				{
					tierScoreTextArr[i].text = ZERO_REPRESENTATION;
				}
				else
				{
					auxScore = String(cardTierScoreArray[i]);
					tierScoreTextArr[i].text = auxScore;
				}
				tierScoreTextArr[i].setTextFormat(blackTxtFormat);
				tierScoreTextArr[i].addEventListener(Event.CHANGE, changeTextValue);
			}
			cardWeightTxt.restrict = "0-9";
			cardWeightTxt.text = String(cardWeight);
			cardWeightTxt.setTextFormat(blackTxtFormat);
			cardWeightTxt.addEventListener(Event.CHANGE, changeTextValue);
		}

		private function changeTextValue(e:Event):void
		{
			var txtField:TextField = TextField(e.target);
			var txtInd:int = tierScoreTextArr.indexOf(txtField);
			//txtField.setTextFormat(greenTxtFormat);
			updateValue(txtField.text, txtInd);
		}

		public function updateDisplay(componentInd:int):void
		{
			var indexStr:String = String(componentInd);
			cardCountTxt.text = indexStr;
			darkenMC.visible = (componentInd % 2 == 0);
		}

		public function updateValue(valueStr:String, valueIndex:int = -1):void
		{
			if(valueStr != "")
			{
				var intValue:int = int(valueStr);
				if(valueIndex == -1)
				{
					if(intValue != defaultCardWeight)
					{
						cardWeight = intValue;
						cardWeightTxt.setTextFormat(greenTxtFormat);
					}
					else
					{
						cardWeight = defaultCardWeight;
						cardWeightTxt.setTextFormat(blackTxtFormat);
					}
				}
				else
				{
					if(cardClass.indexOf(classesArr[valueIndex]) != -1 || cardClass == "Neutral")
					{
						if(intValue != defaultCardTierScoreArray[valueIndex])
						{
							if(intValue == 0)
							{
								tierScoreTextArr[valueIndex].text = ZERO_REPRESENTATION;
							}
							cardTierScoreArray[valueIndex] = intValue;
							tierScoreTextArr[valueIndex].setTextFormat(greenTxtFormat);
						}
						else
						{
							if(intValue == 0)
							{
								tierScoreTextArr[valueIndex].text = ZERO_REPRESENTATION;
							}
							cardTierScoreArray[valueIndex] = defaultCardTierScoreArray[valueIndex];
							tierScoreTextArr[valueIndex].setTextFormat(blackTxtFormat);
						}
					}
				}	
			}
		}

		public function inputValue(valueStr:String, valueIndex:int = -1):void
		{
			if(valueStr != "")
			{
				var intValue:int = int(valueStr);
				if(valueIndex == -1)
				{
					if(intValue != defaultCardWeight)
					{
						cardWeightTxt.text = valueStr;
						cardWeight = intValue;
						cardWeightTxt.setTextFormat(greenTxtFormat);
					}
					else
					{
						cardWeightTxt.text = valueStr;
						cardWeight = defaultCardWeight;
						cardWeightTxt.setTextFormat(blackTxtFormat);
					}
				}
				else
				{
					if(cardClass.indexOf(classesArr[valueIndex]) != -1 || cardClass == "Neutral")
					{
						if(intValue != defaultCardTierScoreArray[valueIndex])
						{
							tierScoreTextArr[valueIndex].text = getStringRepresentation(intValue, valueIndex);
							cardTierScoreArray[valueIndex] = intValue;
							tierScoreTextArr[valueIndex].setTextFormat(greenTxtFormat);
						}
						else
						{
							tierScoreTextArr[valueIndex].text = getStringRepresentation(intValue, valueIndex);
							cardTierScoreArray[valueIndex] = defaultCardTierScoreArray[valueIndex];
							tierScoreTextArr[valueIndex].setTextFormat(blackTxtFormat);
						}
					}
				}	
			}
		}

		public function resetValues():void
		{
			for(var i:int = 0; i < cardTierScoreArray.length; i++)
			{
				tierScoreTextArr[i].text = getStringRepresentation(defaultCardTierScoreArray[i], i);
				tierScoreTextArr[i].setTextFormat(blackTxtFormat);
			}
			cardWeightTxt.text = String(defaultCardWeight);
			cardWeightTxt.setTextFormat(blackTxtFormat);
		}

		public function importValues(xmlData:XML):void
		{
			var importedTierScoresArray:Array = xmlData.@tierScore.split(", ");
			for(var i:int = 0; i < cardTierScoreArray.length; i++)
			{
				tierScoreTextArr[i].text = getStringRepresentation(importedTierScoresArray[i], i);
				tierScoreTextArr[i].setTextFormat(blackTxtFormat);
				cardTierScoreArray[i] = int(importedTierScoresArray[i]);
			}
			cardWeightTxt.text = xmlData.@weight;
			cardWeightTxt.setTextFormat(blackTxtFormat);
			cardWeight = int(xmlData.@weight);
		}

		private function getStringRepresentation(inputValue:int, inputIndex:int):String
		{
			if(inputValue == 0)
			{
				return ZERO_REPRESENTATION;
			}
			else
			{
				return String(inputValue);
			}
		}
	}
}