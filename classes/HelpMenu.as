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

	import HelpImage;
	import HelpHoverMenu;
	import HelpTab;
	import TabButton;
	
	public class HelpMenu extends MovieClip
	{
		private const TAB_BTN_START_X:int = 20;
		private const TAB_BTN_X_DIST:int = 130;
		private const TAB_BTN_Y:int = 6;

		private var helpXMLLoader:URLLoader = new URLLoader();
		private var helpXML:XML;
		private var dataStorageFile:File = File.applicationDirectory.resolvePath("data/xml/help.xml");

		private const IMG_ROOT:String = "data/images/";
		private var imgLoader:Loader;
		private var imageLoaders:Array = new Array();
		private var tabInd:int = 0;

		private var hoverMenus:Array = new Array();

		private var tabsHolder:MovieClip = new MovieClip();
		private var tabButtonsHolder:MovieClip = new MovieClip();

		public function HelpMenu():void
		{
			var whiteBg:WhiteBg = new WhiteBg();
			addChild(whiteBg);
			var verticalLines:VerticalLines = new VerticalLines();
			addChild(verticalLines);
			var horizontalLines:HorizontalLines = new HorizontalLines();
			addChild(horizontalLines);
			var tabsBg:TabsBg = new TabsBg();
			addChild(tabsBg);

			addChild(tabsHolder);
			addChild(tabButtonsHolder);

			helpXMLLoader.addEventListener(Event.COMPLETE, helpXMLLoaded);
			helpXMLLoader.load(new URLRequest(dataStorageFile.url));
		}

		private function helpXMLLoaded(e:Event):void
		{
			helpXML = XML(e.target.data);

			loadImage();
		}

		private function loadImage():void
		{
			imgLoader = new Loader();
			var imgName:String = helpXML.tab[tabInd].@image;
			imgLoader.load(new URLRequest(File.applicationDirectory.resolvePath(IMG_ROOT + imgName).url));
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			imageLoaders.push(imgLoader);
		}

		private function imgLoaded(e:Event):void
		{
			tabInd++;

			if(tabInd == helpXML.tab.length())
			{
				generateTabs();

				selectTab(0);
			}
			else
			{
				loadImage();
			}
		}

		private function generateTabs():void
		{
			for(var i:int = 0; i < helpXML.tab.length(); i++)
			{
				var helpTab:HelpTab = new HelpTab(helpXML.tab[i], imageLoaders[i].contentLoaderInfo.content.bitmapData);
				tabsHolder.addChild(helpTab);
				helpTab.visible = false;

				var tabBtn:TabButton = new TabButton(helpXML.tab[i].@name, helpTab);
				tabBtn.x = TAB_BTN_START_X + i*TAB_BTN_X_DIST;
				tabBtn.y = TAB_BTN_Y;
				tabButtonsHolder.addChild(tabBtn);
				tabBtn.addEventListener(MouseEvent.CLICK, tabPressed);
			}
		}

		private function tabPressed(e:MouseEvent):void
		{
			//TabButton(e.target).toggle();
			var targetTab:TabButton = TabButton(e.target);
			var tabBtn:TabButton;
			for(var i:int; i < tabButtonsHolder.numChildren; i++)
			{
				tabBtn = TabButton(tabButtonsHolder.getChildAt(i));
				if(targetTab == tabBtn)
				{
					tabBtn.enable();
					tabBtn.tabScreen.visible = true;
				}
				else
				{
					tabBtn.disable();
					tabBtn.tabScreen.visible = false;
				}
			}
		}

		public function selectTab(tabInd:int):void
		{
			var tabBtn:TabButton;
			for(var i:int; i < tabButtonsHolder.numChildren; i++)
			{
				tabBtn = TabButton(tabButtonsHolder.getChildAt(i));
				if(i == tabInd)
				{
					tabBtn.enable();
					tabBtn.tabScreen.visible = true;
				}
				else
				{
					tabBtn.disable();
					tabBtn.tabScreen.visible = false;
				}
			}
		}
	}
}