package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.Font;

	import TooltipButton;
	
	public class CardListScreen extends MovieClip
	{
		private const START_X:int = 20;
		private const START_Y:int = 10;
		private const ELEMENT_X_DISTANCE:int = 10;
		private const ELEMENT_Y_DISTANCE:int = 22;
		private const CATEGORY_Y_DISTANCE:int = 30;
		private const NORMAL_HEIGHT:int = 21;
		private const FULL_WIDTH:int = 260;
		private const NORMAL_WIDTH:int = 80;
		private const INPUT_WIDTH:int = 100;
		private const TOOLTIP_WIDTH:int = 21;

		private const ENABLED_COLOR:uint = 0x90CAF9;
		private const DISABLED_COLOR:uint = 0xDDDDDD;

		private var currentX:int = 0;
		private var currentY:int = 0;

		public var classHolder:MovieClip = new MovieClip();
		public var setHolder:MovieClip = new MovieClip();
		public var rarityHolder:MovieClip = new MovieClip();
		public var typeHolder:MovieClip = new MovieClip();
		public var tooltipHolder:MovieClip = new MovieClip();

		public function CardListScreen():void
		{
			filtersTooltip.visible = false;

			addChild(classHolder);
			addChild(setHolder);
			addChild(rarityHolder);
			addChild(typeHolder);
			addChild(tooltipHolder);

			costFilterTxt.restrict = "0-9\\-+";
			tierScoreFilterTxt.restrict = "0-9\\-+";
			weightFilterTxt.restrict = "0-9\\-+";

			druidTierScoreTxt.restrict = "0-9";
			hunterTierScoreTxt.restrict = "0-9";
			mageTierScoreTxt.restrict = "0-9";
			paladinTierScoreTxt.restrict = "0-9";
			priestTierScoreTxt.restrict = "0-9";
			rogueTierScoreTxt.restrict = "0-9";
			shamanTierScoreTxt.restrict = "0-9";
			warlockTierScoreTxt.restrict = "0-9";
			warriorTierScoreTxt.restrict = "0-9";
			cardWeightTxt.restrict = "0-9";

			// Class
			currentY = START_Y;
			generateElementMC(currentX = START_X, currentY += ELEMENT_Y_DISTANCE, NORMAL_WIDTH, "Druid", classHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Hunter", classHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Mage", classHolder);
			generateElementMC(currentX = START_X, currentY += ELEMENT_Y_DISTANCE, NORMAL_WIDTH, "Paladin", classHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Priest", classHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Rogue", classHolder);
			generateElementMC(currentX = START_X, currentY += ELEMENT_Y_DISTANCE, NORMAL_WIDTH, "Shaman", classHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Warlock", classHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Warrior", classHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, NORMAL_WIDTH, "Neutral", classHolder);
			
			// Set
			currentY += CATEGORY_Y_DISTANCE;
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "Basic", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "Classic", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "Reward", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "Curse of Naxxramas", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "Goblins vs Gnomes", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "Blackrock Mountain", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "The Grand Tournament", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "League of Explorers", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "Whispers of the Old Gods", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "One night in Karazan", setHolder);
			generateElementMC(START_X, currentY += ELEMENT_Y_DISTANCE, FULL_WIDTH, "Mean streets of Gadgetzan", setHolder);
			currentY += 3 * ELEMENT_Y_DISTANCE + 8;
			// Rarity
			currentY += CATEGORY_Y_DISTANCE;
			generateElementMC(currentX = START_X, currentY += ELEMENT_Y_DISTANCE, NORMAL_WIDTH, "Common", rarityHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Rare", rarityHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Epic", rarityHolder);
			generateElementMC(currentX = START_X, currentY += ELEMENT_Y_DISTANCE, NORMAL_WIDTH, "Legendary", rarityHolder);

			// Type
			currentY += CATEGORY_Y_DISTANCE;
			generateElementMC(currentX = START_X, currentY += ELEMENT_Y_DISTANCE, NORMAL_WIDTH, "Minion", typeHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Spell", typeHolder);
			generateElementMC(currentX += NORMAL_WIDTH + ELEMENT_X_DISTANCE, currentY, NORMAL_WIDTH, "Weapon", typeHolder);

			// Cost
			generateTooltipButton(START_X + NORMAL_WIDTH + ELEMENT_X_DISTANCE + INPUT_WIDTH + ELEMENT_X_DISTANCE, currentY += CATEGORY_Y_DISTANCE, filtersTooltip);

			// Tier Score
			generateTooltipButton(START_X + NORMAL_WIDTH + ELEMENT_X_DISTANCE + INPUT_WIDTH + ELEMENT_X_DISTANCE, currentY += CATEGORY_Y_DISTANCE, filtersTooltip);

			// Weight
			generateTooltipButton(START_X + NORMAL_WIDTH + ELEMENT_X_DISTANCE + INPUT_WIDTH + ELEMENT_X_DISTANCE, currentY += CATEGORY_Y_DISTANCE, filtersTooltip);
		}

		private function generateTooltipButton(xPos:int, yPos:int, tooltipMC:MovieClip):void
		{
			var tooltipBtn:TooltipButton = new TooltipButton(tooltipMC);
			tooltipBtn.x = xPos;
			tooltipBtn.y = yPos;
			addChild(tooltipBtn);
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

		private function generateCategoryMC(xPos:int, yPos:int, w:int, textStr:String, parentMC:MovieClip):void
		{
			generateTextField(xPos, yPos, w, textStr, parentMC, true);
		}

		private function generateElementMC(xPos:int, yPos:int, w:int, textStr:String, parentMC:MovieClip, hasBorder:Boolean = false, typeStr:String = TextFieldType.DYNAMIC):void
		{
			generateTextField(xPos, yPos, w, textStr, parentMC, hasBorder, typeStr);
		}

		private function generateTextField(xPos:int, yPos:int, w:int, textStr:String, parentMC:MovieClip, hasBorder:Boolean = false, typeStr:String = TextFieldType.DYNAMIC):void
		{
			var tahomaFnt:Font = new TahomaFnt();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = tahomaFnt.fontName;
			txtFormat.size = 14;

			var txtField:TextField = new TextField();
			txtField.x = xPos;
			txtField.y = yPos;
			txtField.width = w;
			txtField.height = NORMAL_HEIGHT;
			txtField.border = hasBorder;
			txtField.type = typeStr;
			txtField.background = true;
			if(typeStr == TextFieldType.DYNAMIC)
			{
				txtField.selectable = false;
				
				txtField.backgroundColor = ENABLED_COLOR;
				if(hasBorder == false)
				{
					txtField.addEventListener(MouseEvent.CLICK, changeColor);
				}
			}
			else
			{
				txtField.backgroundColor = DISABLED_COLOR;
			}
			txtField.defaultTextFormat = txtFormat;
			txtField.embedFonts = true;
			txtField.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			txtField.text = textStr;
			
			parentMC.addChild(txtField);
		}

		private function changeColor(e:MouseEvent):void
		{
			if(e.ctrlKey)
			{
				var parentMC:MovieClip = MovieClip(e.target.parent);
				var parentLen:int = parentMC.numChildren;
				var targetTxt:TextField = TextField(e.target);
				var siblingTxt:TextField;
				for(var i:int = 0; i < parentLen; i++)
				{
					siblingTxt = TextField(parentMC.getChildAt(i));
					if(siblingTxt != targetTxt)
					{
						siblingTxt.backgroundColor = DISABLED_COLOR;
					}
					else
					{
						siblingTxt.backgroundColor = ENABLED_COLOR;
					}
				}
			}
			else
			{
				switch(e.target.backgroundColor)
				{
					case ENABLED_COLOR:
						e.target.backgroundColor = DISABLED_COLOR;
						break;
					case DISABLED_COLOR:
						e.target.backgroundColor = ENABLED_COLOR;
						break;
				}
			}
		}
	}
}