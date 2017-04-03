package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.display.Loader;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import HelpImage;
	import HelpHoverMenu;
	
	public class HelpTab extends MovieClip
	{
		private const DASH_X_OFFSET:int = 2;
		private const IMAGE_X_OFFSET:int = 230;
		private const IMAGE_Y_OFFSET:int = 50;
		private const IMAGE_SCALE:Number = 0.8;
		private const TAB_START_X:int = 40;
		private const TAB_START_Y:int = 10;
		private const TAB_DIST:int = 100;
		private const HOVER_MENUS_START_X:int = 20;
		private const HOVER_MENUS_START_Y:int = 80;
		private const HOVER_MENUS_DIST:int = 30;

		private const HIDDEN_ALPHA:Number = 0.01;
		private const FADED_ALPHA:Number = 0.5;

		public var aboutString:String;

		private var dashesHolder:MovieClip = new MovieClip();
		private var hoverMenusHolder:MovieClip = new MovieClip();
		private var hoverComponentsHolder:MovieClip = new MovieClip();
		private var tabInd:int = 0;
		private var hoverMenuCount:int = 0;
		private var bgBD:BitmapData;

		private var hoverMenus:Array = new Array();

		private var infoTxt:TextField = new TextField();
		private var help:HelpImage;

		public function HelpTab(tabXML:XML, bd:BitmapData):void
		{
			aboutString = tabXML.@about;
			bgBD = bd;

			addChild(dashesHolder);
			addChild(hoverMenusHolder);
			addChild(hoverComponentsHolder);

			var tahomaFnt:Font = new TahomaFnt();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = tahomaFnt.fontName;
			txtFormat.size = 14;

			infoTxt.defaultTextFormat = txtFormat;

			infoTxt.x = 240;
			infoTxt.y = 610;
			infoTxt.width = 940;
			infoTxt.height = 81;
			infoTxt.multiline = true;
			infoTxt.wordWrap = true;

			addChild(infoTxt);
			infoTxt.text = aboutString;

			help = new HelpImage(bgBD);
			help.scaleX = IMAGE_SCALE;
			help.scaleY = IMAGE_SCALE;
			help.x = IMAGE_X_OFFSET;
			help.y = IMAGE_Y_OFFSET;
			addChildAt(help, 0);

			generateHelpComponents(tabXML);

			hoverComponentsHolder.scaleX = IMAGE_SCALE;
			hoverComponentsHolder.scaleY = IMAGE_SCALE;
			hoverComponentsHolder.x = IMAGE_X_OFFSET;
			hoverComponentsHolder.y = IMAGE_Y_OFFSET;

			generateDashLines();
		}

		private function generateHelpComponents(tabXML:XML):void
		{
			for(var i:int = 0; i < tabXML.hoverMenu.length(); i++)
			{
				var hoverMenu:HelpHoverMenu = generateHoverMenu(tabXML.hoverMenu[i].@name, tabXML.hoverMenu[i].@info);
				for(var j:int = 0; j < tabXML.hoverMenu[i].hoverElement.length(); j++)
				{
					var hoverComponent:HelpHoverComponent = generateHoverComponent(int(tabXML.hoverMenu[i].hoverElement[j].@x), int(tabXML.hoverMenu[i].hoverElement[j].@y), int(tabXML.hoverMenu[i].hoverElement[j].@w), int(tabXML.hoverMenu[i].hoverElement[j].@h), tabXML.hoverMenu[i].@info);
					hoverMenu.hoverComponents.push(hoverComponent);

					hoverComponent.addEventListener(MouseEvent.MOUSE_OVER, showInfo);
					hoverComponent.addEventListener(MouseEvent.MOUSE_OUT, hideInfo);
				}
				hoverMenus.push(hoverMenu);
				hoverMenu.addEventListener(MouseEvent.MOUSE_OVER, showDashes);
				hoverMenu.addEventListener(MouseEvent.MOUSE_OUT, hideDashes);
			}
		}

		private function showInfo(e:MouseEvent):void
		{
			var targetHoverComponent:HelpHoverComponent = HelpHoverComponent(e.target);
			var hoverComponent:HelpHoverComponent;
			
			for(var i:int = 0; i < hoverComponentsHolder.numChildren; i++)
			{
				hoverComponent = HelpHoverComponent(hoverComponentsHolder.getChildAt(i));
				if(targetHoverComponent == hoverComponent)
				{
					hoverComponent.alpha = 1;
				}
				else
				{
					hoverComponent.alpha = HIDDEN_ALPHA;
				}
			}
			help.alpha = FADED_ALPHA;
			infoTxt.text = targetHoverComponent.getInfo();
		}

		private function hideInfo(e:MouseEvent):void
		{
			var hoverComponent:HelpHoverComponent;
			
			for(var i:int = 0; i < hoverComponentsHolder.numChildren; i++)
			{
				hoverComponent = HelpHoverComponent(hoverComponentsHolder.getChildAt(i));
				hoverComponent.alpha = HIDDEN_ALPHA;
			}
			infoTxt.text = aboutString;
			help.alpha = 1;
		}

		private function showDashes(e:MouseEvent):void
		{
			var hoverMenu:HelpHoverMenu = HelpHoverMenu(e.target);
			var i:int;
			for(i = 0; i < hoverMenu.dashLines.length; i++)
			{
				hoverMenu.dashLines[i].visible = true;
			}
			var hoverComponent:HelpHoverComponent;
			for(i = 0; i < hoverComponentsHolder.numChildren; i++)
			{
				hoverComponent = HelpHoverComponent(hoverComponentsHolder.getChildAt(i));
				if(hoverMenu.hoverComponents.indexOf(hoverComponent) != -1)
				{
					hoverComponent.alpha = 1;
				}
				else
				{
					hoverComponent.alpha = HIDDEN_ALPHA;
				}
			}
			help.alpha = FADED_ALPHA;
			infoTxt.text = hoverMenu.infoString;
		}

		private function hideDashes(e:MouseEvent):void
		{
			var hoverMenu:HelpHoverMenu = HelpHoverMenu(e.target)
			var i:int;
			for(i = 0; i < hoverMenu.dashLines.length; i++)
			{
				hoverMenu.dashLines[i].visible = false;
			}
			var hoverComponent:HelpHoverComponent;
			for(i = 0; i < hoverComponentsHolder.numChildren; i++)
			{
				hoverComponent = HelpHoverComponent(hoverComponentsHolder.getChildAt(i));
				hoverComponent.alpha = HIDDEN_ALPHA;
			}
			help.alpha = 1;
			infoTxt.text = aboutString;
		}

		private function generateHoverComponent(xPos:int, yPos:int, w:int, h:int, infoStr:String):HelpHoverComponent
		{
			var bdPart:BitmapData = new BitmapData(w, h);
			bdPart.copyPixels(bgBD, new Rectangle(xPos, yPos, w, h), new Point(0, 0));
			var hoverComponent:HelpHoverComponent = new HelpHoverComponent(bdPart, infoStr);
			hoverComponent.x = xPos;
			hoverComponent.y = yPos;
			hoverComponentsHolder.addChild(hoverComponent);
			return hoverComponent;
		}

		private function generateHoverMenu(menuStr:String, infoStr:String):HelpHoverMenu
		{
			var hoverMenu:HelpHoverMenu = new HelpHoverMenu(menuStr, infoStr);
			hoverMenu.x = HOVER_MENUS_START_X;
			hoverMenu.y = HOVER_MENUS_START_Y + HOVER_MENUS_DIST * hoverMenuCount;
			hoverMenusHolder.addChild(hoverMenu);
			hoverMenuCount++;
			return hoverMenu;
		}

		private function generateDashLines():void
		{
			for(var i:int = 0; i < hoverMenus.length; i++)
			{
				var x1:int = hoverMenus[i].x;
				var y1:int = hoverMenus[i].y;
				for(var j:int = 0; j < hoverMenus[i].hoverComponents.length; j++)
				{
					var x2:int = hoverMenus[i].hoverComponents[j].x;
					var y2:int = hoverMenus[i].hoverComponents[j].y;
					var h2:int = hoverMenus[i].hoverComponents[j].height;
					var mySprite:Sprite = drawLine(x1, y1, x2, y2, h2);
					hoverMenus[i].dashLines.push(mySprite);
				}
			}
		}

		private function drawLine(x1:int, y1:int, x2:int, y2:int, h2:int):Sprite
		{
			var a:Number = Math.abs(IMAGE_X_OFFSET + (x2+DASH_X_OFFSET)*IMAGE_SCALE - (x1+HelpHoverMenu.HOVER_WIDTH-DASH_X_OFFSET));
			var signedB:Number = IMAGE_Y_OFFSET + (y2+h2*0.5)*IMAGE_SCALE - (y1+HelpHoverMenu.HOVER_HEIGHT*0.5);
			var b:Number = Math.abs(signedB);
			var c:Number = Math.sqrt(a*a+b*b);
			var rotationAngle:Number = Math.atan(b / a) * 180 / Math.PI;

			if(signedB < 0)
			{
				rotationAngle = -rotationAngle;
			}
			//trace(rotationAngle);
			var mySprite:Sprite = new Sprite();
			mySprite.visible = false;
			mySprite.graphics.beginBitmapFill(new DashLine(), null, true, true);
			mySprite.graphics.drawRect(0, 0, c, 4);
			mySprite.graphics.endFill();
			dashesHolder.addChild(mySprite);

			mySprite.rotation = rotationAngle;
			mySprite.x = x1+HelpHoverMenu.HOVER_WIDTH-DASH_X_OFFSET;
			mySprite.y = y1+HelpHoverMenu.HOVER_HEIGHT*0.5;

			return mySprite;
		}
	}
}