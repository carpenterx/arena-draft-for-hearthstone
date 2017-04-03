package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.events.MouseEvent;

	import BasicButton;
	import TierDrafterConstants;
	import TooltipButton;
	
	public class RarityScreen extends MovieClip
	{
		private const START_X0:int = 400;
		private const START_X1:int = 424;
		private const START_X2:int = 514;
		private const START_X3:int = 604;
		private const START_X4:int = 694;
		private const START_Y1:int = 20;
		private const START_Y2:int = 50;
		private const START_Y3:int = 80;
		private const Y_DIST:int = 20;

		private const TEXT_WIDTH:int = 80;
		private const COUNT_WIDTH:int = 20;
		private const TEXT_HEIGHT:int = 21;

		private const HEADER_X:int = 290;
		private const HEADER_WIDTH:int = 120;
		private const HEADER_LABEL:String = "Set column value";
		private const RANGE_LABEL:String = "Range";

		private const BUTTON_X:int = 794;
		private const BUTTON_LABEL:String = "Update columns";

		private var commonChancesArr:Array = new Array();
		private var rareChancesArr:Array = new Array();
		private var epicChancesArr:Array = new Array();
		private var legendaryChancesArr:Array = new Array();
		private var headerChancesArr:Array = new Array();
		private var fillBtn:BasicButton;

		private const RANGE_MIN:int = 1;
		private const RANGE_MAX:int = 30;

		private var txtFormat:TextFormat = new TextFormat();

		public function RarityScreen():void
		{
			rarityTooltip.visible = false;

			var tahomaFnt:Font = new TahomaFnt();
			txtFormat.font = tahomaFnt.fontName;
			txtFormat.size = 14;
			txtFormat.align = TextFormatAlign.CENTER;

			var infoFormat:TextFormat = new TextFormat();
			infoFormat.font = tahomaFnt.fontName;
			infoFormat.size = 14;
			infoFormat.align = TextFormatAlign.RIGHT;

			fillBtn = new BasicButton(BUTTON_LABEL);
			fillBtn.x = BUTTON_X;
			fillBtn.y = START_Y2;
			addChild(fillBtn);
			fillBtn.addEventListener(MouseEvent.CLICK, updateRarityValues);

			rangeTxt.restrict = "0-9\\- ;";

			generateTextField("", headerChancesArr, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X1, START_Y1, true, true);
			generateTextField("", headerChancesArr, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X2, START_Y1, true, true);
			generateTextField("", headerChancesArr, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X3, START_Y1, true, true);
			generateTextField("", headerChancesArr, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X4, START_Y1, true, true);

			generateTextField("Common", null, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X1, START_Y2, true, true, TextFieldType.DYNAMIC);
			generateTextField("Rare", null, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X2, START_Y2, true, true, TextFieldType.DYNAMIC, 0x0099ff);
			generateTextField("Epic", null, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X3, START_Y2, true, true, TextFieldType.DYNAMIC, 0xcc33ff);
			generateTextField("Legendary", null, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X4, START_Y2, true, true, TextFieldType.DYNAMIC, 0xff9900);
			for(var i:int = 0; i < 30; i++)
			{
				var countStr:String = String(i+1);
				generateTextField(countStr, null, infoFormat, COUNT_WIDTH, TEXT_HEIGHT, START_X0, (START_Y3 + i * Y_DIST), false, false, TextFieldType.DYNAMIC);

				generateTextField(String(TierDrafterConstants.COMMON_DROP_CHANCE), commonChancesArr, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X1, (START_Y3 + i * Y_DIST), true, true);
				generateTextField(String(TierDrafterConstants.RARE_DROP_CHANCE), rareChancesArr, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X2, (START_Y3 + i * Y_DIST), true, true);
				generateTextField(String(TierDrafterConstants.EPIC_DROP_CHANCE), epicChancesArr, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X3, (START_Y3 + i * Y_DIST), true, true);
				generateTextField(String(TierDrafterConstants.LEGENDARY_DROP_CHANCE), legendaryChancesArr, txtFormat, TEXT_WIDTH, TEXT_HEIGHT, START_X4, (START_Y3 + i * Y_DIST), true, true);
			}

			addTooltipButton(1034, 20, 19, 19, rarityTooltip);
		}

		private function addTooltipButton(xPos:int, yPos:int, w:int, h:int, targetMC:MovieClip):void
		{
			var tooltipBtn:TooltipButton = new TooltipButton(targetMC);
			tooltipBtn.x = xPos;
			tooltipBtn.y = yPos;
			tooltipBtn.width = w;
			tooltipBtn.height = h;
			this.addChild(tooltipBtn);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideTooltip);
		}

		private function showTooltip(e:MouseEvent):void
		{
			var tooltipBtn:TooltipButton = TooltipButton(e.target);
			this.setChildIndex(tooltipBtn.tooltip, this.numChildren - 1);
			tooltipBtn.tooltip.visible = true;
		}

		private function hideTooltip(e:MouseEvent):void
		{
			TooltipButton(e.target).tooltip.visible = false;
		}

		private function updateRarityValues(e:MouseEvent):void
		{
			var ranges:Array;
			if(rangeTxt.text != "")
			{
				ranges = getRanges(rangeTxt.text);
			}
			else
			{
				ranges = getRanges("1-30");
			}

			for(var i:int = 0; i < 30; i++)
			{
				if(ranges.indexOf(i+1) != -1)
				{
					if(headerChancesArr[0].text != "")
					{
						commonChancesArr[i].text = headerChancesArr[0].text;
					}
					if(headerChancesArr[1].text != "")
					{
						rareChancesArr[i].text = headerChancesArr[1].text;
					}
					if(headerChancesArr[2].text != "")
					{
						epicChancesArr[i].text = headerChancesArr[2].text;
					}
					if(headerChancesArr[3].text != "")
					{
						legendaryChancesArr[i].text = headerChancesArr[3].text;
					}
				}
			}
		}

		private function getRanges(rangesStr:String):Array
		{
			var returnArray:Array = new Array();
			rangesStr = rangesStr.replace(/ /mg, "");
			//trace(rangesStr);
			var rangesArray:Array = rangesStr.split(";");
			var numberPat:RegExp = /^[0-9]+$/;
			var rangePat:RegExp = /^[0-9]+\-[0-9]+$/;
			var rangeStr1:String;
			var rangeStr2:String;
			var rangeInt1:int;
			var rangeInt2:int;
			var rangeStart:int;
			var rangeEnd:int;

			for(var i:int = 0; i < rangesArray.length; i++)
			{
				if(rangePat.test(rangesArray[i]))
				{
					rangeStr1 = rangesArray[i].slice(0, rangesArray[i].indexOf("-"));
					rangeStr2 = rangesArray[i].slice(rangesArray[i].indexOf("-") + 1);
					rangeInt1 = parseInt(rangeStr1);
					rangeInt2 = parseInt(rangeStr2);
					rangeStart = Math.min(rangeInt1, rangeInt2);
					rangeEnd = Math.max(rangeInt1, rangeInt2);

					if(rangeStart < RANGE_MIN)
					{
						rangeStart = RANGE_MIN;
					}
					if(rangeEnd > RANGE_MAX)
					{
						rangeEnd = RANGE_MAX;
					}
					for(var j:int = rangeStart; j <= rangeEnd; j++)
					{
						returnArray.push(j);
					}
				}
				else if(numberPat.test(rangesArray[i]))
				{
					var numberInt:int = int(rangesArray[i]);
					if(numberInt >= RANGE_MIN && numberInt <= RANGE_MAX)
					{
						returnArray.push(numberInt);
					}
				}
			}

			return returnArray;
		}

		private function generateTextField(tfText:String, holderArray:Array, tfFormat:TextFormat, tfWidth:int, tfHeight:int, tfX:int, tfY:int, tfBackground:Boolean = false, tfBorder:Boolean = false, tfType:String = TextFieldType.INPUT, bgColor:uint = 0xffffff):void
		{
			var txtField:TextField = new TextField();
			txtField.width = tfWidth;
			txtField.height = tfHeight;
			txtField.x = tfX;
			txtField.y = tfY;
			txtField.restrict = "0-9";
			txtField.maxChars = 9;
			txtField.type = tfType;
			if(tfBackground)
			{
				txtField.background = tfBackground;
				txtField.backgroundColor = bgColor;
			}
			
			txtField.border = tfBorder;
			txtField.defaultTextFormat = tfFormat;
			
			if(holderArray != null)
			{
				holderArray.push(txtField);
			}

			txtField.text = tfText;

			addChild(txtField);
		}

		public function getRarityWeights(pickInd:int):Array
		{
			var weightsArray:Array = new Array();
			weightsArray.push(int(commonChancesArr[pickInd].text));
			weightsArray.push(int(rareChancesArr[pickInd].text));
			weightsArray.push(int(epicChancesArr[pickInd].text));
			weightsArray.push(int(legendaryChancesArr[pickInd].text));

			return weightsArray;
		}

		public function getDropChancesXML():XML
		{
			var outXML:XML = <dropRates></dropRates>;
			for(var i:int = 0; i < commonChancesArr.length; i++)
			{
				var dropRateXML:XML = <dropRate></dropRate>;
				dropRateXML.@common = commonChancesArr[i].text;
				dropRateXML.@rare = rareChancesArr[i].text;
				dropRateXML.@epic = epicChancesArr[i].text;
				dropRateXML.@legendary = legendaryChancesArr[i].text;
				outXML.appendChild(dropRateXML);
			}

			return outXML;
		}

		public function importValues(dataXML:XML):void
		{
			for(var i:int = 0; i < dataXML.card.length(); i++)
			{
				commonChancesArr[i].text = dataXML.card[i].@common;
				rareChancesArr[i].text = dataXML.card[i].@rare;
				epicChancesArr[i].text = dataXML.card[i].@epic;
				legendaryChancesArr[i].text = dataXML.card[i].@legendary;
			}
		}
	}
}