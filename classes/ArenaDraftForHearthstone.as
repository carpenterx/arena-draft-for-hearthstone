package
{
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.Clipboard;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.net.navigateToURL;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;

	import HearthstoneLargeCard;
	import HearthstoneCardData;
	import DraftCard;
	import TierListComponent;

	import BasicButton;
	import RadioGaga;
	import RarityScreen;
	import TooltipButton;
	import SimpleTooltip;
	import HelpMenu;
	import AdvancedTooltip;
	
	public class ArenaDraftForHearthstone extends MovieClip
	{
		// 76% Common, 20% Rare, 3% Epic, 1% Legendary
		// msog offerings: class cards including tri-class = 180%, neutral = 200%
		/*75 20 3.75 1.25
		0 80 15 5
		65 28 5.25 1.75

		80 15 4 1
		0 80 16 4
		69.3 23.6 5.6 1.4*/
		private var rarityWeights:Array; // = [76, 20, 3, 1]
		private var raritiesWeightSum:int;
		private var cardWeights:Array = new Array();
		private var weightSums:Array = new Array();

		private var dataLoader:URLLoader = new URLLoader();
		private var tierListLoader:URLLoader = new URLLoader();
		private var dropChancesLoader:URLLoader = new URLLoader();
		private var dataFile:File = File.applicationDirectory.resolvePath("data/xml/data.xml");
		private var dataXML:XML;

		private const classesArr:Array = ["Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"];
		private var classesXPos:Array = [390, 540, 690, 390, 540, 690, 390, 540, 690];
		private var classesYPos:Array = [160, 160, 160, 220, 220, 220, 280, 280, 280];
		private const raritiesArr:Array = ["Common", "Rare", "Epic", "Legendary"];
		private const raritiesConstructedLimit:Array = [2, 2, 2, 1];

		private var commonCardsArr:Array;
		private var rareCardsArr:Array;
		private var epicCardsArr:Array;
		private var legendaryCardsArr:Array;
		private var allCards:Array = new Array;

		private var classPickMC:MovieClip = new MovieClip();
		private var classSelectMC:MovieClip = new MovieClip();
		private var classRandomMC:MovieClip = new MovieClip();

		private var cardDraft1:MovieClip = new MovieClip();
		private var cardDraft2:MovieClip = new MovieClip();
		private var cardDraft3:MovieClip = new MovieClip();
		private var draftScreens:Array = [cardDraft1, cardDraft2, cardDraft3];

		private var draftsXPos:Array = [20, 326, 632];
		private var draftsYPos:int = 80;

		private var cardCount:int;
		private var deckScore:int;
		private var draftArr:Array = new Array();

		private var cardDataArr:Array = new Array();

		private const NEWEST_SET:String = "Mean streets of Gadgetzan";
		private const NORMAL_WEIGHT:String = "10";
		private const NEW_SET_CLASS_WEIGHT:String = "18";
		private const NEW_SET_NEUTRAL_WEIGHT:String = "20";
		private const NEUTRAL_CARD:String = "Neutral";

		private const IMG_ROOT:String = "Card images/";
		private var shuffledChoicesArr:Array;
		private var loadersArray:Array;
		private var imagesLoaded:int;

		private var draftHolder:MovieClip = new MovieClip();
		private const DRAFT_X:int = 993;
		private const DRAFT_START_Y:int = 30;
		private const DRAFT_DIST:int = 21;

		private var settingsObj:Object = new Object();
		private const REGULAR_DRAFT:String = "Regular draft";
		private const TIER_SORT:String = "Tier sort";
		private const NO_DUPLICATES:String = "No duplicates"; // Not allowed
		private const ALLOW_DUPLICATES:String = "Allow duplicates"; // Allowed
		private const CONSTRUCTED_DUPLICATES:String = "Constructed"; // Constructed
		private const NORMAL_CLASS_SELECTION:String = "Normal selection"; // Normal
		private const PICK_CLASS:String = "Pick class";
		private const RANDOM_CLASS:String = "Random class"; // Random

		private var radioXPos:Array = [340, 530, 340, 530, 720, 340, 530, 720];
		private var radioYPos:Array = [220, 220, 310, 310, 310, 400, 400, 400];

		private var radioHelpXPos:Array = [488, 678, 488, 678, 868, 488, 678, 868];

		private var settingsObject:SharedObject = SharedObject.getLocal("carpenter.com.ArenaDraftForHearthstone");

		private const TIER_LIST_X:int = 300;
		private const TIER_LIST_Y:int = 106;
		private const TIER_LIST_DIST:int = 24;
		private const TIER_LIST_MASK_HEIGHT:int = 576;
		private var tierListHolder:MovieClip = new MovieClip();

		private const ENABLED_COLOR:uint = 0x90CAF9;
		private const DISABLED_COLOR:uint = 0xDDDDDD;

		private const SEARCH_STR:String = "search";

		private var rarityFilterArray:Array;
		private var setFilterArray:Array;
		private var classFilterArray:Array;
		private var typeFilterArray:Array;
		private var tierScoreFilterArray:Array;
		private var allFiltersArray:Array;
		private var allAttributesArray:Array;
		private var componentCount:int = 0;
		private var resultsIndices:Array;

		private var cardListTierScoreInputs:Array = new Array();

		private const SAVE_TIER_LIST:String = "Save tier list";
		private const LOAD_TIER_LIST:String = "Load tier list";
		private const SAVE_DROP_CHANCES:String = "Save drop chances";
		private const LOAD_DROP_CHANCES:String = "Load drop chances";
		private const EXTENSION:String = "xml";
		private const TIER_LISTS_FOLDER:String = "Tier Lists";
		private const DROP_CHANCES_FOLDER:String = "Drop Chances";

		private var currentFolder:File;
		private var fileListArr:Array = new Array();

		private var ioFileTextFields:Array = new Array();

		private var mouseDeltaY:int;
		private var previousY:int;
		private var scrollMinY:int = TIER_LIST_Y;
		private var scrollMaxY:int;

		private var rarityFilter:String;
		private var classFilter:String;

		private const TIER_SCORE_STR:String = " tier score";
		private const TOOLTIP_X_OFFSET:int = 10; 
		private const TOOLTIP_Y_OFFSET:int = 20; 
		private var tierScoreTooltip:SimpleTooltip = new SimpleTooltip("Hunter tier score", 110, 19);
		private var tierScoreClassIcons:Array = new Array();
		private var helpMenu:HelpMenu = new HelpMenu();
		private var screenTabs:Array = new Array();

		private var regularDraftTT:AdvancedTooltip;
		private var tierSortDraftTT:AdvancedTooltip;
		private var noDuplicatesTT:AdvancedTooltip;
		private var allowDuplicatesTT:AdvancedTooltip;
		private var constructedDuplicatesTT:AdvancedTooltip;

		private var normalSelectionTT:AdvancedTooltip;
		private var pickClassTT:AdvancedTooltip;
		private var randomClassTT:AdvancedTooltip;

		private var ttHolder:MovieClip = new MovieClip();

		public function ArenaDraftForHearthstone():void
		{
			cardListTierScoreInputs = [cardListScreen.druidTierScoreTxt, cardListScreen.hunterTierScoreTxt, cardListScreen.mageTierScoreTxt, cardListScreen.paladinTierScoreTxt, cardListScreen.priestTierScoreTxt, cardListScreen.rogueTierScoreTxt, cardListScreen.shamanTierScoreTxt, cardListScreen.warlockTierScoreTxt, cardListScreen.warriorTierScoreTxt];

			ioFileTextFields = [ioScreen.file1Txt, ioScreen.file2Txt, ioScreen.file3Txt, ioScreen.file4Txt, ioScreen.file5Txt, ioScreen.file6Txt, ioScreen.file7Txt, ioScreen.file8Txt, ioScreen.file9Txt];

			tierScoreClassIcons = [cardListScreen.druidMC, cardListScreen.hunterMC,cardListScreen. mageMC, cardListScreen.paladinMC, cardListScreen.priestMC, cardListScreen.rogueMC, cardListScreen.shamanMC, cardListScreen.warlockMC, cardListScreen.warriorMC];

			screenTabs = [classChoiceScreen, draftScreen, settingsScreen, rarityScreen, cardListScreen, ioScreen];

			helpScreen.addChildAt(helpMenu, 0);

			cardListScreen.addChild(tierScoreTooltip);
			tierScoreTooltip.visible = false;

			cardListScreen.addChild(tierListHolder);
			tierListHolder.mask = cardListScreen.tierListMask;
			classChoiceScreen.addChild(classPickMC);
			classChoiceScreen.addChild(classSelectMC);
			classChoiceScreen.addChild(classRandomMC);
			draftScreen.addChild(cardDraft1);
			draftScreen.addChild(cardDraft2);
			draftScreen.addChild(cardDraft3);
			draftScreen.addChild(draftHolder);

			if(settingsObject.data.draftType == undefined)
			{
				settingsObject.data.draftType = REGULAR_DRAFT;
				settingsObject.data.duplicates = ALLOW_DUPLICATES;
				settingsObject.data.classSelection = NORMAL_CLASS_SELECTION;
				settingsObject.flush();
			}

			draftScreen.copyBtn.buttonMode = true;
			draftScreen.copyBtn.useHandCursor = true;

			cardListScreen.addChild(tierScoreTooltip);

			settingsBtn.buttonMode = true;
			settingsBtn.useHandCursor = true;

			helpBtn.buttonMode = true;
			helpBtn.useHandCursor = true;

			cardListBtn.buttonMode = true;
			cardListBtn.useHandCursor = true;

			aboutBtn.buttonMode = true;
			aboutBtn.useHandCursor = true;

			rarityBtn.buttonMode = true;
			rarityBtn.useHandCursor = true;

			settingsScreen.closeBtn.buttonMode = true;
			settingsScreen.closeBtn.useHandCursor = true;

			draftScreen.closeBtn.buttonMode = true;
			draftScreen.closeBtn.useHandCursor = true;

			aboutScreen.closeBtn.buttonMode = true;
			aboutScreen.closeBtn.useHandCursor = true;

			rarityScreen.closeBtn.buttonMode = true;
			rarityScreen.closeBtn.useHandCursor = true;

			cardListScreen.closeBtn.buttonMode = true;
			cardListScreen.closeBtn.useHandCursor = true;

			helpScreen.closeBtn.buttonMode = true;
			helpScreen.closeBtn.useHandCursor = true;

			cardListScreen.loadBtn.buttonMode = true;
			cardListScreen.loadBtn.useHandCursor = true;

			cardListScreen.saveBtn.buttonMode = true;
			cardListScreen.saveBtn.useHandCursor = true;

			cardListScreen.searchBtn.buttonMode = true;
			cardListScreen.searchBtn.useHandCursor = true;

			cardListScreen.resetFiltersBtn.buttonMode = true;
			cardListScreen.resetFiltersBtn.useHandCursor = true;

			cardListScreen.filterBtn.buttonMode = true;
			cardListScreen.filterBtn.useHandCursor = true;

			cardListScreen.updateColumnsBtn.buttonMode = true;
			cardListScreen.updateColumnsBtn.useHandCursor = true;

			cardListScreen.resetColumnsBtn.buttonMode = true;
			cardListScreen.resetColumnsBtn.useHandCursor = true;

			draftScreen.newDraftBtn.buttonMode = true;
			draftScreen.newDraftBtn.useHandCursor = true;

			ioScreen.closeBtn.buttonMode = true;
			ioScreen.closeBtn.useHandCursor = true;

			ioScreen.saveBtn.buttonMode = true;
			ioScreen.saveBtn.useHandCursor = true;

			ioScreen.loadBtn.buttonMode = true;
			ioScreen.loadBtn.useHandCursor = true;

			ioScreen.folderBtn.buttonMode = true;
			ioScreen.folderBtn.useHandCursor = true;

			rarityScreen.saveBtn.buttonMode = true;
			rarityScreen.saveBtn.useHandCursor = true;

			rarityScreen.loadBtn.buttonMode = true;
			rarityScreen.loadBtn.useHandCursor = true;
			
			cardListScreen.scrollMC.buttonMode = true;
			cardListScreen.scrollMC.useHandCursor = true;

			settingsScreen.addChild(ttHolder);

			setScreenVisibility(settingsScreen, false);
			setScreenVisibility(draftScreen, false);
			setScreenVisibility(aboutScreen, false);
			setScreenVisibility(rarityScreen, false);
			setScreenVisibility(cardListScreen, false);
			setScreenVisibility(ioScreen, false);
			setScreenVisibility(helpScreen, false);

			var style:StyleSheet = new StyleSheet();

			var hover:Object = new Object();
			hover.color = "#2482CD";
			var link:Object = new Object();
			link.textDecoration= "underline";
			 
			style.setStyle("a:link", link);
			style.setStyle("a:hover", hover);
			 
			aboutScreen.devAboutTxt.styleSheet = style;
			aboutScreen.hpwnAboutTxt.styleSheet = style;
			aboutScreen.harenaAboutTxt.styleSheet = style;
			aboutScreen.gitAboutTxt.styleSheet = style;

			aboutScreen.devAboutTxt.htmlText = "Developed by <a href=\"event:https://github.com/carpenterx\">carpenter</a>";
			aboutScreen.devAboutTxt.addEventListener(TextEvent.LINK, openLink);
			aboutScreen.hpwnAboutTxt.htmlText = "Card images and data from <a href=\"event:http://www.hearthpwn.com/\">hearthpwn.com</a>";
			aboutScreen.hpwnAboutTxt.addEventListener(TextEvent.LINK, openLink);
			aboutScreen.harenaAboutTxt.htmlText = "Arena tier scores from <a href=\"event:http://www.heartharena.com/\">heartharena.com</a>";
			aboutScreen.harenaAboutTxt.addEventListener(TextEvent.LINK, openLink);
			aboutScreen.gitAboutTxt.htmlText = "<a href=\"event:https://github.com/carpenterx/arena-draft-for-hearthstone/\">Github source</a>";
			aboutScreen.gitAboutTxt.addEventListener(TextEvent.LINK, openLink);

			dataLoader.addEventListener(Event.COMPLETE, dataLoaded);
			dataLoader.load(new URLRequest(dataFile.url));
		}

		private function displayCardListComponents(dataArr:Array):void
		{
			tierListHolder.y = 0;
			var dataLen:int = cardDataArr.length;
			var tComponent:TierListComponent;
			componentCount = 0;
			for(var i:int = 0; i < dataLen; i++)
			{
				tComponent = TierListComponent(tierListHolder.getChildAt(i));
				if(resultsIndices.indexOf(i) == -1)
				{
					tComponent.visible = false;
				}
				else
				{
					tComponent.visible = true;
					tComponent.updateDisplay(componentCount+1);
					tComponent.y = TIER_LIST_Y + TIER_LIST_DIST * componentCount;
					componentCount++;
				}
			}

			updateScrollBar();
		}

		private function removeAllChildrenFromMC(mc:MovieClip):void
		{
			if (mc.numChildren)
			{
				while (mc.numChildren)
				{
					mc.removeChildAt(0);
				}
			}
		}

		private function dataLoaded(e:Event):void
		{
			dataXML = XML(e.target.data);

			generateCardArrays();
			generateSettingsTooltips();
			generateClassChoiceScreens();
			showSelectedClassChoiceSubscreen();
			generateSettingsScreen();

			settingsBtn.addEventListener(MouseEvent.CLICK, openSettings);
			helpBtn.addEventListener(MouseEvent.CLICK, openHelp);
			aboutBtn.addEventListener(MouseEvent.CLICK, openAbout);
			aboutScreen.closeBtn.addEventListener(MouseEvent.CLICK, closeParent);
			rarityScreen.closeBtn.addEventListener(MouseEvent.CLICK, closeParent);
			cardListScreen.closeBtn.addEventListener(MouseEvent.CLICK, closeParent);
			draftScreen.closeBtn.addEventListener(MouseEvent.CLICK, startNewDraft);
			helpScreen.closeBtn.addEventListener(MouseEvent.CLICK, closeParent);
			cardListBtn.addEventListener(MouseEvent.CLICK, openCardList);
			rarityBtn.addEventListener(MouseEvent.CLICK, openRarityScreen);

			cardListScreen.addEventListener(MouseEvent.MOUSE_WHEEL, scrollCardList);

			cardListScreen.filterBtn.addEventListener(MouseEvent.CLICK, filterCards);
			cardListScreen.searchBtn.addEventListener(MouseEvent.CLICK, filterCards);
			cardListScreen.classFilterBtn.addEventListener(MouseEvent.CLICK, classFilterClick);
			cardListScreen.setFilterBtn.addEventListener(MouseEvent.CLICK, setFilterClick);
			cardListScreen.wildFilterBtn.addEventListener(MouseEvent.CLICK, wildFilterClick);
			cardListScreen.standardFilterBtn.addEventListener(MouseEvent.CLICK, standardFilterClick);
			cardListScreen.randomFilterBtn.addEventListener(MouseEvent.CLICK, randomFilterClick);
			cardListScreen.rarityFilterBtn.addEventListener(MouseEvent.CLICK, rarityFilterClick);
			cardListScreen.typeFilterBtn.addEventListener(MouseEvent.CLICK, typeFilterClick);
			cardListScreen.costFilterBtn.addEventListener(MouseEvent.CLICK, costFilterClick);
			cardListScreen.tierScoreFilterBtn.addEventListener(MouseEvent.CLICK, tierScoreFilterClick);
			cardListScreen.weightFilterBtn.addEventListener(MouseEvent.CLICK, weightFilterClick);
			cardListScreen.resetFiltersBtn.addEventListener(MouseEvent.CLICK, resetAllFilters);
			cardListScreen.updateColumnsBtn.addEventListener(MouseEvent.CLICK, updateColumns);
			cardListScreen.resetColumnsBtn.addEventListener(MouseEvent.CLICK, resetColumns);
			cardListScreen.addEventListener(KeyboardEvent.KEY_DOWN, submitSearchQuery);

			for(var i:int = 0; i < tierScoreClassIcons.length; i++)
			{
				tierScoreClassIcons[i].addEventListener(MouseEvent.MOUSE_OVER, showTierScoreTooltip);
				tierScoreClassIcons[i].addEventListener(MouseEvent.MOUSE_OUT, hideTierScoreTooltip);
			}
			

			ioScreen.saveBtn.addEventListener(MouseEvent.CLICK, saveData);
			ioScreen.loadBtn.addEventListener(MouseEvent.CLICK, loadData);
			ioScreen.folderBtn.addEventListener(MouseEvent.CLICK, openFolder);
			cardListScreen.saveBtn.addEventListener(MouseEvent.CLICK, openSaveTierListMenu);
			cardListScreen.loadBtn.addEventListener(MouseEvent.CLICK, openLoadTierListMenu);
			ioScreen.closeBtn.addEventListener(MouseEvent.CLICK, closeParent);
			ioScreen.fileNameTxt.addEventListener(Event.CHANGE, updateFileList);
			ioScreen.fileListComponent.addEventListener(MouseEvent.CLICK, selectFileName);
			rarityScreen.saveBtn.addEventListener(MouseEvent.CLICK, openSaveDropChancesMenu);
			rarityScreen.loadBtn.addEventListener(MouseEvent.CLICK, openLoadDropChancesMenu);

			cardListScreen.scrollMC.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			cardListScreen.addEventListener(MouseEvent.MOUSE_UP, stopDragging);

			setScreenVisibility(transitionScreen, false);
		}

		private function generateSettingsTooltips():void
		{
			regularDraftTT = new AdvancedTooltip("The normal type of draft.\rCards are chosen based\ron rarity", 148, 60);
			tierSortDraftTT = new AdvancedTooltip("The cards are sorted by\rtheir tier score instead\rof rarity", 156, 60);

			noDuplicatesTT = new AdvancedTooltip("A card will appear in a\rdraft only once", 136, 42);
			allowDuplicatesTT = new AdvancedTooltip("A card will never be\rremoved from the card\rpool no matter how\rmany times it is drafted", 146, 76);
			constructedDuplicatesTT = new AdvancedTooltip("The draft can have up\rto two copies of the\rsame common, rare or\repic card, but only one\rcopy of legendaries", 138, 93);

			normalSelectionTT = new AdvancedTooltip("You are offered a\rselection of three\rclasses at random", 110, 60);
			pickClassTT = new AdvancedTooltip("All nine classes are\ravailable for selection", 128, 43);
			randomClassTT = new AdvancedTooltip("The class will be\rselected at random", 118, 43);

			regularDraftTT.x = 520;
			regularDraftTT.y = 208;
			tierSortDraftTT.x = 710;
			tierSortDraftTT.y = 208;

			noDuplicatesTT.x = 520;
			noDuplicatesTT.y = 304;
			allowDuplicatesTT.x = 710;
			allowDuplicatesTT.y = 290;
			constructedDuplicatesTT.x = 900;
			constructedDuplicatesTT.y = 280;

			normalSelectionTT.x = 520;
			normalSelectionTT.y = 386;
			pickClassTT.x = 710;
			pickClassTT.y = 392;
			randomClassTT.x = 900;
			randomClassTT.y = 392;

			ttHolder.addChild(regularDraftTT);
			ttHolder.addChild(tierSortDraftTT);
			ttHolder.addChild(noDuplicatesTT);
			ttHolder.addChild(allowDuplicatesTT);
			ttHolder.addChild(constructedDuplicatesTT);
			ttHolder.addChild(normalSelectionTT);
			ttHolder.addChild(pickClassTT);
			ttHolder.addChild(randomClassTT);

			regularDraftTT.visible = false;
			tierSortDraftTT.visible = false;
			noDuplicatesTT.visible = false;
			allowDuplicatesTT.visible = false;
			constructedDuplicatesTT.visible = false;
			normalSelectionTT.visible = false;
			pickClassTT.visible = false;
			randomClassTT.visible = false;
		}

		private function openFolder(e:MouseEvent):void
		{	
			var storageFolder:File;
			switch(ioScreen.ioScreenTitleTxt.text)
				{
					case LOAD_TIER_LIST:
						storageFolder = File.applicationStorageDirectory.resolvePath(TIER_LISTS_FOLDER);
						break;

					case LOAD_DROP_CHANCES:
						storageFolder = File.applicationStorageDirectory.resolvePath(DROP_CHANCES_FOLDER);
						break;

					case SAVE_TIER_LIST:
						storageFolder = File.applicationStorageDirectory.resolvePath(TIER_LISTS_FOLDER);
						break;

					case SAVE_DROP_CHANCES:
						storageFolder = File.applicationStorageDirectory.resolvePath(DROP_CHANCES_FOLDER);
						break;
				}

				if(!storageFolder.exists)
				{
					storageFolder.createDirectory();
				}
				storageFolder.openWithDefaultApplication();
		}

		private function showTierScoreTooltip(e:MouseEvent):void
		{
			e.target.addEventListener(MouseEvent.MOUSE_MOVE, updateTierScoreTooltip);
			tierScoreTooltip.changeText(classesArr[tierScoreClassIcons.indexOf(e.target)] + TIER_SCORE_STR);
			
			updateTierScoreTooltip(null);
			tierScoreTooltip.visible = true;
		}

		private function updateTierScoreTooltip(e:MouseEvent):void
		{
			tierScoreTooltip.x = stage.mouseX + TOOLTIP_X_OFFSET;
			tierScoreTooltip.y = stage.mouseY + TOOLTIP_Y_OFFSET;
		}

		private function hideTierScoreTooltip(e:MouseEvent):void
		{
			tierScoreTooltip.visible = false;
		}

		private function submitSearchQuery(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				filterCards(null);
			}
		}

		private function selectFileName(e:MouseEvent):void
		{
			ioScreen.fileNameTxt.text = ioScreen.fileListComponent.getSelectedFileName();
			updateFileList(null);
		}

		private function openSaveDropChancesMenu(e:MouseEvent):void
		{
			ioScreen.ioScreenTitleTxt.text = SAVE_DROP_CHANCES;
			currentFolder = File.applicationStorageDirectory.resolvePath(DROP_CHANCES_FOLDER);
			if(currentFolder.exists)
			{
				fileListArr = currentFolder.getDirectoryListing();
			}
			else
			{
				fileListArr = new Array();
			}
			ioScreen.fileNameTxt.text = "";
			updateFileList(null);
			stage.focus = ioScreen.fileNameTxt;
			ioScreen.saveBtn.visible = true;
			ioScreen.loadBtn.visible = false;
			ioScreen.fileListComponent.clearHighlight();
			ioScreen.fileListComponent.setWarnMode(true);
			setScreenVisibility(ioScreen, true);
			ioScreen.addEventListener(KeyboardEvent.KEY_DOWN, submitFileName);
		}

		private function startDragging(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragScrollbar);
			previousY = stage.mouseY;
		}

		private function stopDragging(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragScrollbar);
		}

		private function dragScrollbar(e:MouseEvent):void
		{
			mouseDeltaY = previousY - stage.mouseY;
			previousY = stage.mouseY;
			var newY:int = cardListScreen.scrollMC.y - mouseDeltaY;
			if(newY <= scrollMinY)
			{
				cardListScreen.scrollMC.y = scrollMinY;
			}
			else if(newY >= scrollMaxY)
			{
				cardListScreen.scrollMC.y = scrollMaxY;
			}
			else
			{
				cardListScreen.scrollMC.y = newY;
			}
			updateCardListPosition();
		}

		private function updateCardListPosition():void
		{
			tierListHolder.y = -(cardListScreen.scrollMC.y - TIER_LIST_Y) / (scrollMaxY - scrollMinY) * (componentCount * TIER_LIST_DIST - TIER_LIST_MASK_HEIGHT);
		}

		private function openLoadDropChancesMenu(e:MouseEvent):void
		{
			ioScreen.ioScreenTitleTxt.text = LOAD_DROP_CHANCES;
			currentFolder = File.applicationStorageDirectory.resolvePath(DROP_CHANCES_FOLDER);
			if(currentFolder.exists)
			{
				fileListArr = currentFolder.getDirectoryListing();
			}
			else
			{
				fileListArr = new Array();
			}
			ioScreen.fileNameTxt.text = "";
			updateFileList(null);
			stage.focus = ioScreen.fileNameTxt;
			ioScreen.saveBtn.visible = false;
			ioScreen.loadBtn.visible = true;
			ioScreen.fileListComponent.clearHighlight();
			ioScreen.fileListComponent.setWarnMode(false);
			setScreenVisibility(ioScreen, true);
			ioScreen.addEventListener(KeyboardEvent.KEY_DOWN, submitFileName);
		}

		private function submitFileName(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				switch(ioScreen.ioScreenTitleTxt.text)
				{
					case LOAD_TIER_LIST:
						loadTierList();
						break;

					case LOAD_DROP_CHANCES:
						loadDropChances();
						break;

					case SAVE_TIER_LIST:
						saveTierList();
						break;

					case SAVE_DROP_CHANCES:
						saveDropChances();
						break;
				}
			}
		}

		private function updateFileList(e:Event):void
		{
			ioScreen.fileListComponent.displayFileList(fileListArr, ioScreen.fileNameTxt.text);
		}

		private function loadData(e:MouseEvent):void
		{
			switch(ioScreen.ioScreenTitleTxt.text)
			{
				case LOAD_TIER_LIST:
					loadTierList();
					break;

				case LOAD_DROP_CHANCES:
					loadDropChances();
					break;
			}
		}

		private function loadTierList():void
		{
			var loadFile:File = currentFolder.resolvePath(ioScreen.fileNameTxt.text);
			if(loadFile.exists)
			{
				// trace("load exact file");
				loadTierListXML(loadFile);
			}
			else
			{
				loadFile = currentFolder.resolvePath(ioScreen.fileNameTxt.text + "." + EXTENSION);
				if(loadFile.exists)
				{
					// trace("load file with extension");
					loadTierListXML(loadFile);
				}
			}
		}

		private function loadTierListXML(xmlFile:File):void
		{
			setScreenVisibility(transitionScreen, true);
			tierListLoader = new URLLoader();
			tierListLoader.addEventListener(Event.COMPLETE, tierListXMLLoaded);
			tierListLoader.load(new URLRequest(xmlFile.url));
		}

		private function tierListXMLLoaded(e:Event):void
		{
			setScreenVisibility(transitionScreen, false);

			var tierListXML:XML = XML(e.target.data);
			var tComponent:TierListComponent;
			for(var i:int = 0; i < tierListHolder.numChildren; i++)
			{
				tComponent = TierListComponent(tierListHolder.getChildAt(i));
				tComponent.importValues(tierListXML.card.(@name == tComponent.cardName)[0]);
			}
			setScreenVisibility(ioScreen, false);
		}

		private function loadDropChances():void
		{
			var loadFile:File = currentFolder.resolvePath(ioScreen.fileNameTxt.text + "." + EXTENSION);
			if(loadFile.exists)
			{
				// trace("load exact file");
				loadDropChancesXML(loadFile);
			}
			else
			{
				loadFile = currentFolder.resolvePath(ioScreen.fileNameTxt.text + "." + EXTENSION);
				if(loadFile.exists)
				{
					// trace("load file with extension");
					loadDropChancesXML(loadFile);
				}
			}
		}

		private function loadDropChancesXML(xmlFile:File):void
		{
			setScreenVisibility(transitionScreen, true);
			dropChancesLoader = new URLLoader();
			dropChancesLoader.addEventListener(Event.COMPLETE, dropChancesXMLLoaded);
			dropChancesLoader.load(new URLRequest(xmlFile.url));
		}

		private function dropChancesXMLLoaded(e:Event):void
		{
			setScreenVisibility(transitionScreen, false);
			
			rarityScreen.importValues(XML(e.target.data));
			setScreenVisibility(ioScreen, false);
		}

		private function saveData(e:MouseEvent):void
		{
			switch(ioScreen.ioScreenTitleTxt.text)
			{
				case SAVE_TIER_LIST:
					saveTierList();
					break;

				case SAVE_DROP_CHANCES:
					saveDropChances();
					break;
			}
		}

		private function saveDropChances():void
		{
			var outXML:XML = rarityScreen.getDropChancesXML();
			
			saveXML(outXML.toXMLString(), currentFolder, ioScreen.fileNameTxt.text);
		}

		private function saveTierList():void
		{
			var outXML:XML = <cards></cards>;
			for(var i:int = 0; i < cardDataArr.length; i++)
			{
				var cardXML:XML = <card></card>;
				cardXML.@name = cardDataArr[i].cardName;
				cardXML.@weight = String(cardDataArr[i].cardWeight);
				cardXML.@tierScore = cardDataArr[i].cardTierScoreArray.join(", ");
				outXML.appendChild(cardXML);
			}
			
			saveXML(outXML.toXMLString(), currentFolder, ioScreen.fileNameTxt.text);
		}

		private function saveXML(dataStr:String, folderFile:File, fileName:String):void
		{
			if(fileName != "")
			{
				var myFile:File = folderFile.resolvePath(fileName + "." + EXTENSION);
				

				var myFileStream:FileStream = new FileStream(); 
				myFileStream.openAsync(myFile, FileMode.WRITE); 
				myFileStream.writeUTFBytes(dataStr);
			}
			else
			{
				trace("ERROR: Enter a filename");
			}
			setScreenVisibility(ioScreen, false);
			ioScreen.removeEventListener(KeyboardEvent.KEY_DOWN, submitFileName);
		}

		private function openSaveTierListMenu(e:MouseEvent):void
		{
			ioScreen.ioScreenTitleTxt.text = SAVE_TIER_LIST;
			currentFolder = File.applicationStorageDirectory.resolvePath(TIER_LISTS_FOLDER);
			if(currentFolder.exists)
			{
				fileListArr = currentFolder.getDirectoryListing();
			}
			else
			{
				fileListArr = new Array();
			}
			ioScreen.fileNameTxt.text = "";
			updateFileList(null);
			ioScreen.fileListComponent.clearHighlight();
			ioScreen.fileListComponent.setWarnMode(true);
			stage.focus = ioScreen.fileNameTxt;
			ioScreen.saveBtn.visible = true;
			ioScreen.loadBtn.visible = false;
			setScreenVisibility(ioScreen, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, submitFileName);
		}

		private function openLoadTierListMenu(e:MouseEvent):void
		{
			ioScreen.ioScreenTitleTxt.text = LOAD_TIER_LIST;
			currentFolder = File.applicationStorageDirectory.resolvePath(TIER_LISTS_FOLDER);
			if(currentFolder.exists)
			{
				fileListArr = currentFolder.getDirectoryListing();
			}
			else
			{
				fileListArr = new Array();
			}
			ioScreen.fileNameTxt.text = "";
			updateFileList(null);
			stage.focus = ioScreen.fileNameTxt;
			ioScreen.saveBtn.visible = false;
			ioScreen.loadBtn.visible = true;
			ioScreen.fileListComponent.clearHighlight();
			ioScreen.fileListComponent.setWarnMode(false);
			setScreenVisibility(ioScreen, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, submitFileName);
		}

		private function updateColumns(e:MouseEvent):void
		{
			var tComponent:TierListComponent;
			for(var i:int = 0; i < resultsIndices.length; i++)
			{
				tComponent = TierListComponent(tierListHolder.getChildAt(resultsIndices[i]));

				tComponent.inputValue(cardListScreen.druidTierScoreTxt.text, 0);
				tComponent.inputValue(cardListScreen.hunterTierScoreTxt.text, 1);
				tComponent.inputValue(cardListScreen.mageTierScoreTxt.text, 2);
				tComponent.inputValue(cardListScreen.paladinTierScoreTxt.text, 3);
				tComponent.inputValue(cardListScreen.priestTierScoreTxt.text, 4);
				tComponent.inputValue(cardListScreen.rogueTierScoreTxt.text, 5);
				tComponent.inputValue(cardListScreen.shamanTierScoreTxt.text, 6);
				tComponent.inputValue(cardListScreen.warlockTierScoreTxt.text, 7);
				tComponent.inputValue(cardListScreen.warriorTierScoreTxt.text, 8);
				tComponent.inputValue(cardListScreen.cardWeightTxt.text);
			}
		}

		private function resetColumns(e:MouseEvent):void
		{
			var tComponent:TierListComponent;
			for(var i:int = 0; i < resultsIndices.length; i++)
			{
				tComponent = TierListComponent(tierListHolder.getChildAt(resultsIndices[i]));
				tComponent.resetValues();
			}
		}

		private function filterCards(e:MouseEvent):void
		{
			// order: search (name), rarity, set, class, cost, type, weight, tier score

			allFiltersArray = new Array();
			allAttributesArray = new Array();
			// search
			if(cardListScreen.searchTxt.text != "")
			{
				// only perform the search when the search button is pressed or the event is null because it is called by the keyboard event
				if(e == null || e.target.name == "searchBtn")
				{
					allFiltersArray.push(cardListScreen.searchTxt.text.split("; "));
					allAttributesArray.push(SEARCH_STR);
				}
			}
			// rarity
			rarityFilterArray = getFilterArray(cardListScreen.rarityHolder);
			if(rarityFilterArray.length < cardListScreen.rarityHolder.numChildren)
			{
				allFiltersArray.push(rarityFilterArray);
				allAttributesArray.push("cardRarity");
			}
			// set
			setFilterArray = getFilterArray(cardListScreen.setHolder);
			if(setFilterArray.length < cardListScreen.setHolder.numChildren)
			{
				allFiltersArray.push(setFilterArray);
				allAttributesArray.push("cardSet");
			}
			// class
			classFilterArray = getFilterArray(cardListScreen.classHolder);
			if(classFilterArray.length < cardListScreen.classHolder.numChildren)
			{
				allFiltersArray.push(classFilterArray.join(", "));
				allAttributesArray.push("cardClass");
			}
			// cost
			if(cardListScreen.costFilterTxt.text != "")
			{
				allFiltersArray.push(getRangeArray(cardListScreen.costFilterTxt.text));
				allAttributesArray.push("cardCost");
			}
			// type
			typeFilterArray = getFilterArray(cardListScreen.typeHolder);
			if(typeFilterArray.length < cardListScreen.typeHolder.numChildren)
			{
				allFiltersArray.push(typeFilterArray);
				allAttributesArray.push("cardType");
			}
			// weight
			if(cardListScreen.weightFilterTxt.text != "")
			{
				allFiltersArray.push(getRangeArray(cardListScreen.weightFilterTxt.text));
				allAttributesArray.push("cardWeight");
			}
			// tier score
			tierScoreFilterArray = getRangeArray(cardListScreen.tierScoreFilterTxt.text);
			if(cardListScreen.tierScoreFilterTxt.text != "")
			{
				allFiltersArray.push(tierScoreFilterArray);
				allAttributesArray.push("cardTierScoreArray");
			}

			resultsIndices = new Array();
			var resultsArray:Array = cardDataArr.filter(cardsFilter);
			displayCardListComponents(resultsArray);
		}

		private function getRangeArray(rangeStr:String):Array
		{
			var rangeArray:Array = new Array();

			var range0Pat:RegExp = /^[0-9]+$/;
			var range1Pat:RegExp = /^[0-9]+\+$/;
			var range2Pat:RegExp = /^[0-9]+-$/;
			var range3Pat:RegExp = /^[0-9]+\-[0-9]+$/;

			if(range0Pat.test(rangeStr))
			{
				rangeArray.push(parseInt(rangeStr));
				rangeArray.push(parseInt(rangeStr));
			}
			else if(range1Pat.test(rangeStr))
			{
				rangeArray.push(parseInt(rangeStr));
				rangeArray.push(int.MAX_VALUE);
			}
			else if(range2Pat.test(rangeStr))
			{
				rangeArray.push(int.MIN_VALUE);
				rangeArray.push(parseInt(rangeStr));
			}
			else if(range3Pat.test(rangeStr))
			{
				var rangeArrayStr:Array = rangeStr.split("-");
				rangeArray.push(int(rangeArrayStr[0]));
				rangeArray.push(int(rangeArrayStr[1]));
			}
			else
			{
				rangeArray.push(int.MIN_VALUE);
				rangeArray.push(int.MAX_VALUE);
			}

			return rangeArray;
		}

		private function getFilterArray(mc:MovieClip):Array
		{
			var txtField:TextField;
			var filterArray:Array = new Array();
			for( var i:int = 0; i < mc.numChildren; i++)
			{
				txtField = TextField(mc.getChildAt(i));
				if(txtField.backgroundColor == ENABLED_COLOR)
				{
					filterArray.push(txtField.text);
				}
			}

			return filterArray;
		}

		private function cardsFilter(element:*, index:int, arr:Array):Boolean
		{
			// order: search (name), rarity, set, class, cost, type, weight, tier score
			var j:int;
			for(var i:int = 0; i < allAttributesArray.length; i++)
			{
				if(allAttributesArray[i] == SEARCH_STR)
				{
					if(!searchTermWasFoundInElement(element))
					{
						return false;
						break;
					}
				}
				else if(allAttributesArray[i] == "cardRarity" || allAttributesArray[i] == "cardSet" || allAttributesArray[i] == "cardType")
				{
					if(allFiltersArray[i].indexOf(element[allAttributesArray[i]]) == -1)
					{
						return false;
						break;
					}
				}
				else if(allAttributesArray[i] == "cardClass")
				{

					if(!classWasFoundInElement(element, allFiltersArray[i]))
					{
						return false;
						break;
					}
				}
				else if(allAttributesArray[i] == "cardCost" || allAttributesArray[i] == "cardWeight")
				{
					if(element[allAttributesArray[i]] < allFiltersArray[i][0] || element[allAttributesArray[i]] > allFiltersArray[i][1])
					{
						return false;
						break;
					}
				}
				else if(allAttributesArray[i] == "cardTierScoreArray")
				{
					//trace(element.cardName, tierScoreWasFoundInRange(element, allFiltersArray[i]));
					if(!tierScoreWasFoundInRange(element, allFiltersArray[i]))
					{
						return false;
						break;
					}
				}
			}

			resultsIndices.push(index);
			return true;
		}

		private function tierScoreWasFoundInRange(element:*, rangeArr:Array):Boolean
		{
			var i:int;
			// if the filter only has the neutral tab selected, search all the classes
			if(classFilterArray[0] == "Neutral")
			{
				for(i = 0; i < classesArr.length; i++)
				{
					if(element.cardTierScoreArray[i] >= rangeArr[0] && element.cardTierScoreArray[i] <= rangeArr[1])
					{
						return true;
						break;
					}
				}
			}
			// if there are some classes selected, search only these classes
			else
			{
				for(i = 0; i < classesArr.length; i++)
				{
					// we also need to check that the card can belong to the selected class / or if the neutral tab is selected and the card is neutral
					if(classFilterArray.indexOf(classesArr[i]) != -1 && (element.cardClass.indexOf(classesArr[i]) != -1 || (classFilterArray.indexOf("Neutral") != -1 && element.cardClass == "Neutral")))
					{
						if(element.cardTierScoreArray[i] >= rangeArr[0] && element.cardTierScoreArray[i] <= rangeArr[1])
						{
							return true;
							break;
						}
					}
				}
			}

			return false;
		}

		private function searchTermWasFoundInElement(element:*):Boolean
		{
			// add more properties to this array to extend the range of the search
			var searchAttributesArr:Array = ["cardName"];
			for(var i:int = 0; i < searchAttributesArr.length; i++)
			{
				var searchTerm:String = String(cardListScreen.searchTxt.text).toLowerCase();
				var searchData:String = element[searchAttributesArr[i]].toLowerCase();
				if(searchData.indexOf(searchTerm) != -1)
				{
					return true;
					break;
				}
			}

			return false;
		}

		private function classWasFoundInElement(element:*, filterClassesStr:String):Boolean
		{
			var individualClasses:Array = element["cardClass"].split(", ");
			for(var i:int = 0; i < individualClasses.length; i++)
			{
				if(filterClassesStr.indexOf(individualClasses[i]) != -1)
				{
					return true;
					break;
				}
			}

			return false;
		}

		private function classFilterClick(e:MouseEvent):void
		{
			if(e.ctrlKey)
			{
				invertFilter(cardListScreen.classHolder);
			}
			else
			{
				resetFilter(cardListScreen.classHolder);
			}
		}

		private function setFilterClick(e:MouseEvent):void
		{
			if(e.ctrlKey)
			{
				invertFilter(cardListScreen.setHolder);
			}
			else
			{
				resetFilter(cardListScreen.setHolder);
			}
		}

		private function wildFilterClick(e:MouseEvent):void
		{
			var filterArr:Array = [false, false, true, true, true, true, true, false, false, false, false];
			setFilter(cardListScreen.setHolder, filterArr);
		}

		private function standardFilterClick(e:MouseEvent):void
		{
			var filterArr:Array = [true, true, false, false, false, false, false, true, true, true, true];
			setFilter(cardListScreen.setHolder, filterArr);
		}

		private function randomFilterClick(e:MouseEvent):void
		{
			var filterArr:Array = getRandomSetFilter();
			setFilter(cardListScreen.setHolder, filterArr);
		}

		private function getRandomSetFilter():Array
		{
			var returnArr:Array = [false, false, false, false, false, false, false, false, false, false, false];
			var adventureIndexes:Array = [3, 5, 7, 9];
			var expansionIndexes:Array = [0, 1, 4, 6, 8, 10];
			var randomIndex:int;
			var expLen:int = expansionIndexes.length;
			for(var i:int = 0; i < 3; i++)
			{
				randomIndex = Math.floor(Math.random() * expLen);
				returnArr[expansionIndexes[randomIndex]] = true;
				expLen--;
				expansionIndexes[randomIndex] = expansionIndexes[expLen];
			}
			returnArr[adventureIndexes[Math.floor(Math.random() * adventureIndexes.length)]] = true;

			return returnArr;
		}

		private function rarityFilterClick(e:MouseEvent):void
		{
			if(e.ctrlKey)
			{
				invertFilter(cardListScreen.rarityHolder);
			}
			else
			{
				resetFilter(cardListScreen.rarityHolder);
			}
		}

		private function typeFilterClick(e:MouseEvent):void
		{
			if(e.ctrlKey)
			{
				invertFilter(cardListScreen.typeHolder);
			}
			else
			{
				resetFilter(cardListScreen.typeHolder);
			}
		}

		private function resetFilter(mc:MovieClip):void
		{
			var txtField:TextField;
			for( var i:int = 0; i < mc.numChildren; i++)
			{
				txtField = TextField(mc.getChildAt(i));
				txtField.backgroundColor = ENABLED_COLOR;
			}
		}

		private function invertFilter(mc:MovieClip):void
		{
			var txtField:TextField;
			for( var i:int = 0; i < mc.numChildren; i++)
			{
				txtField = TextField(mc.getChildAt(i));
				if(txtField.backgroundColor == ENABLED_COLOR)
				{
					txtField.backgroundColor = DISABLED_COLOR;
				}
				else
				{
					txtField.backgroundColor = ENABLED_COLOR;
				}
			}
		}

		private function setFilter(mc:MovieClip, filterArr:Array):void
		{
			var txtField:TextField;
			for( var i:int = 0; i < mc.numChildren; i++)
			{
				txtField = TextField(mc.getChildAt(i));
				if(filterArr[i] == true)
				{
					txtField.backgroundColor = ENABLED_COLOR;
				}
				else
				{
					txtField.backgroundColor = DISABLED_COLOR;
				}
			}
		}

		private function costFilterClick(e:MouseEvent):void
		{
			cardListScreen.costFilterTxt.text = "";
		}

		private function tierScoreFilterClick(e:MouseEvent):void
		{
			cardListScreen.tierScoreFilterTxt.text = "";
		}

		private function weightFilterClick(e:MouseEvent):void
		{
			cardListScreen.weightFilterTxt.text = "";
		}

		private function resetAllFilters(e:MouseEvent):void
		{
			resetFilter(cardListScreen.classHolder);
			resetFilter(cardListScreen.setHolder);
			resetFilter(cardListScreen.rarityHolder);
			resetFilter(cardListScreen.typeHolder);
			costFilterClick(null);
			tierScoreFilterClick(null);
			weightFilterClick(null);
		}

		private function scrollCardList(e:MouseEvent):void
		{
			var scrollDistance:int = 2 * e.delta;
			var listHeight:int = componentCount * TIER_LIST_DIST;
			
			if(scrollDistance > 0)
			{
				if(tierListHolder.y + scrollDistance > 0)
				{
					tierListHolder.y = 0;
				}
				else
				{
					tierListHolder.y += scrollDistance;
				}
			}
			else
			{
				
				if(listHeight > TIER_LIST_MASK_HEIGHT)
				{
					var listMinY:int = TIER_LIST_MASK_HEIGHT - listHeight;
					if(tierListHolder.y + scrollDistance < listMinY)
					{
						tierListHolder.y = listMinY;
					}
					else
					{
						tierListHolder.y += scrollDistance;
					}
				}
			}

			updateScrollBar();
		}

		private function updateScrollBar():void
		{
			var listHeight:int = componentCount * TIER_LIST_DIST;
			if(listHeight > TIER_LIST_MASK_HEIGHT)
			{
				cardListScreen.scrollMC.height = TIER_LIST_MASK_HEIGHT * TIER_LIST_MASK_HEIGHT / listHeight;
				var scrollMoveDist:int = -tierListHolder.y * (TIER_LIST_MASK_HEIGHT - cardListScreen.scrollMC.height) / (listHeight - TIER_LIST_MASK_HEIGHT);
				var scrollOffset:int = TIER_LIST_Y;
				cardListScreen.scrollMC.y = scrollMoveDist + scrollOffset;
				cardListScreen.scrollMC.visible = true;
				scrollMaxY = TIER_LIST_MASK_HEIGHT - cardListScreen.scrollMC.height + TIER_LIST_Y;
			}
			else
			{
				cardListScreen.scrollMC.visible = false;
			}
		}

		private function openCardList(e:MouseEvent):void
		{
			setScreenVisibility(cardListScreen, true);
			setScreenVisibility(helpScreen, false);
			setScreenVisibility(settingsScreen, false);
			setScreenVisibility(aboutScreen, false);
			setScreenVisibility(rarityScreen, false);
		}

		private function openRarityScreen(e:MouseEvent):void
		{
			setScreenVisibility(rarityScreen, true);
			setScreenVisibility(helpScreen, false);
			setScreenVisibility(cardListScreen, false);
			setScreenVisibility(settingsScreen, false);
			setScreenVisibility(aboutScreen, false);
		}

		private function openAbout(e:MouseEvent):void
		{
			setScreenVisibility(aboutScreen, true);
			setScreenVisibility(helpScreen, false);
			setScreenVisibility(cardListScreen, false);
			setScreenVisibility(settingsScreen, false);
			setScreenVisibility(rarityScreen, false);
		}

		private function closeParent(e:MouseEvent):void
		{
			e.target.parent.visible = false;
		}

		private function openSettings(e:MouseEvent):void
		{
			setScreenVisibility(settingsScreen, true);
			setScreenVisibility(helpScreen, false);
			setScreenVisibility(cardListScreen, false);
			setScreenVisibility(aboutScreen, false);
			setScreenVisibility(rarityScreen, false);
		}

		private function openHelp(e:MouseEvent):void
		{
			//setScreenVisibility(settingsScreen, false);
			setScreenVisibility(helpScreen, true);
			//setScreenVisibility(cardListScreen, false);
			//setScreenVisibility(aboutScreen, false);
			//setScreenVisibility(rarityScreen, false);
		}

		private function generateSettingsScreen():void
		{
			var radioInd:int = 0;
			var radio:RadioGaga;
			var tooltipBtn:TooltipButton;
			var draftTypeRadioGroup:MovieClip = new MovieClip();
			var duplicatesRadioGroup:MovieClip = new MovieClip();
			var selectionRadioGroup:MovieClip = new MovieClip();
			settingsScreen.addChild(draftTypeRadioGroup);
			settingsScreen.addChild(duplicatesRadioGroup);
			settingsScreen.addChild(selectionRadioGroup);
			
			radio = new RadioGaga(REGULAR_DRAFT, settingIsOnOrOff(REGULAR_DRAFT, settingsObject.data.draftType));
			radio.x = radioXPos[radioInd];
			radio.y = radioYPos[radioInd];
			draftTypeRadioGroup.addChild(radio);
			radio.addEventListener(MouseEvent.CLICK, selectDraftType);

			tooltipBtn = new TooltipButton(regularDraftTT);
			tooltipBtn.x = radioHelpXPos[radioInd];
			tooltipBtn.y = radioYPos[radioInd];
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showSettingsTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideSettingsTooltip);
			settingsScreen.addChild(tooltipBtn);

			radioInd++;

			radio = new RadioGaga(TIER_SORT, settingIsOnOrOff(TIER_SORT, settingsObject.data.draftType));
			radio.x = radioXPos[radioInd];
			radio.y = radioYPos[radioInd];
			draftTypeRadioGroup.addChild(radio);
			radio.addEventListener(MouseEvent.CLICK, selectDraftType);

			tooltipBtn = new TooltipButton(tierSortDraftTT);
			tooltipBtn.x = radioHelpXPos[radioInd];
			tooltipBtn.y = radioYPos[radioInd];
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showSettingsTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideSettingsTooltip);
			settingsScreen.addChild(tooltipBtn);

			radioInd++;

			radio = new RadioGaga(NO_DUPLICATES, settingIsOnOrOff(NO_DUPLICATES, settingsObject.data.duplicates));
			radio.x = radioXPos[radioInd];
			radio.y = radioYPos[radioInd];
			duplicatesRadioGroup.addChild(radio);
			radio.addEventListener(MouseEvent.CLICK, selectDuplicates);

			tooltipBtn = new TooltipButton(noDuplicatesTT);
			tooltipBtn.x = radioHelpXPos[radioInd];
			tooltipBtn.y = radioYPos[radioInd];
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showSettingsTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideSettingsTooltip);
			settingsScreen.addChild(tooltipBtn);

			radioInd++;

			radio = new RadioGaga(ALLOW_DUPLICATES, settingIsOnOrOff(ALLOW_DUPLICATES, settingsObject.data.duplicates));
			radio.x = radioXPos[radioInd];
			radio.y = radioYPos[radioInd];
			duplicatesRadioGroup.addChild(radio);
			radio.addEventListener(MouseEvent.CLICK, selectDuplicates);

			tooltipBtn = new TooltipButton(allowDuplicatesTT);
			tooltipBtn.x = radioHelpXPos[radioInd];
			tooltipBtn.y = radioYPos[radioInd];
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showSettingsTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideSettingsTooltip);
			settingsScreen.addChild(tooltipBtn);

			radioInd++;

			radio = new RadioGaga(CONSTRUCTED_DUPLICATES, settingIsOnOrOff(CONSTRUCTED_DUPLICATES, settingsObject.data.duplicates));
			radio.x = radioXPos[radioInd];
			radio.y = radioYPos[radioInd];
			duplicatesRadioGroup.addChild(radio);
			radio.addEventListener(MouseEvent.CLICK, selectDuplicates);

			tooltipBtn = new TooltipButton(constructedDuplicatesTT);
			tooltipBtn.x = radioHelpXPos[radioInd];
			tooltipBtn.y = radioYPos[radioInd];
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showSettingsTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideSettingsTooltip);
			settingsScreen.addChild(tooltipBtn);

			radioInd++;

			radio = new RadioGaga(NORMAL_CLASS_SELECTION, settingIsOnOrOff(NORMAL_CLASS_SELECTION, settingsObject.data.classSelection));
			radio.x = radioXPos[radioInd];
			radio.y = radioYPos[radioInd];
			selectionRadioGroup.addChild(radio);
			radio.addEventListener(MouseEvent.CLICK, selectClassChoice);

			tooltipBtn = new TooltipButton(normalSelectionTT);
			tooltipBtn.x = radioHelpXPos[radioInd];
			tooltipBtn.y = radioYPos[radioInd];
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showSettingsTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideSettingsTooltip);
			settingsScreen.addChild(tooltipBtn);

			radioInd++;

			radio = new RadioGaga(PICK_CLASS, settingIsOnOrOff(PICK_CLASS, settingsObject.data.classSelection));
			radio.x = radioXPos[radioInd];
			radio.y = radioYPos[radioInd];
			selectionRadioGroup.addChild(radio);
			radio.addEventListener(MouseEvent.CLICK, selectClassChoice);

			tooltipBtn = new TooltipButton(pickClassTT);
			tooltipBtn.x = radioHelpXPos[radioInd];
			tooltipBtn.y = radioYPos[radioInd];
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showSettingsTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideSettingsTooltip);
			settingsScreen.addChild(tooltipBtn);

			radioInd++;

			radio = new RadioGaga(RANDOM_CLASS, settingIsOnOrOff(RANDOM_CLASS, settingsObject.data.classSelection));
			radio.x = radioXPos[radioInd];
			radio.y = radioYPos[radioInd];
			selectionRadioGroup.addChild(radio);
			radio.addEventListener(MouseEvent.CLICK, selectClassChoice);

			tooltipBtn = new TooltipButton(randomClassTT);
			tooltipBtn.x = radioHelpXPos[radioInd];
			tooltipBtn.y = radioYPos[radioInd];
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OVER, showSettingsTooltip);
			tooltipBtn.addEventListener(MouseEvent.MOUSE_OUT, hideSettingsTooltip);
			settingsScreen.addChild(tooltipBtn);
			
			radioInd++;

			// place the tooltips holder on top of everything
			settingsScreen.setChildIndex(ttHolder, settingsScreen.numChildren - 1);

			settingsScreen.closeBtn.addEventListener(MouseEvent.CLICK, closeSettings);
		}

		private function showSettingsTooltip(e:MouseEvent):void
		{
			var tooltipBtn:TooltipButton = TooltipButton(e.target);
			tooltipBtn.tooltip.visible = true;
		}

		private function hideSettingsTooltip(e:MouseEvent):void
		{
			var tooltipBtn:TooltipButton = TooltipButton(e.target);
			tooltipBtn.tooltip.visible = false;
		}

		private function settingIsOnOrOff(settingString:String, settingObject:*):String
		{
			if(settingString == settingObject)
			{
				return RadioGaga.ON;
			}
			else
			{
				return RadioGaga.OFF;
			}
		}

		private function closeSettings(e:MouseEvent):void
		{
			setScreenVisibility(settingsScreen, false);
		}

		private function selectDraftType(e:MouseEvent):void
		{
			var radioTarget:RadioGaga = RadioGaga(e.target);
			var radioGroup:MovieClip = e.target.parent;
			var radio:RadioGaga; 
			for(var i:int = 0; i < radioGroup.numChildren; i++)
			{
				radio = RadioGaga(radioGroup.getChildAt(i));
				if(radio != radioTarget)
				{
					radio.setState("off");
				}
				else
				{
					radio.setState("on");
				}
			}
			settingsObject.data.draftType = radioTarget.label;
			settingsObject.flush();
		}

		private function selectDuplicates(e:MouseEvent):void
		{
			var radioTarget:RadioGaga = RadioGaga(e.target);
			var radioGroup:MovieClip = e.target.parent;
			var radio:RadioGaga; 
			for(var i:int = 0; i < radioGroup.numChildren; i++)
			{
				radio = RadioGaga(radioGroup.getChildAt(i));
				if(radio != radioTarget)
				{
					radio.setState("off");
				}
				else
				{
					radio.setState("on");
				}
			}
			settingsObject.data.duplicates = radioTarget.label;
			settingsObject.flush();
		}

		private function selectClassChoice(e:MouseEvent):void
		{
			var radioTarget:RadioGaga = RadioGaga(e.target);
			var radioGroup:MovieClip = e.target.parent;
			var radio:RadioGaga; 
			for(var i:int = 0; i < radioGroup.numChildren; i++)
			{
				radio = RadioGaga(radioGroup.getChildAt(i));
				if(radio != radioTarget)
				{
					radio.setState("off");
				}
				else
				{
					radio.setState("on");
				}
			}
			settingsObject.data.classSelection = radioTarget.label;
			settingsObject.flush();
			showSelectedClassChoiceSubscreen();
		}

		private function calculateWeightSum(weightsArr:Array):int
		{
			var len:int = weightsArr.length;
			var weightsSum:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				weightsSum += weightsArr[i];
			}

			return weightsSum;
		}

		private function generateClassChoiceScreens():void
		{
			var i:int;
			var btn:BasicButton;
			var randIndex:int;

			for(i = 0; i < classesArr.length; i++)
			{
				btn = new BasicButton(classesArr[i], i);
				btn.x = classesXPos[i];
				btn.y = classesYPos[i];
				classPickMC.addChild(btn);
				btn.addEventListener(MouseEvent.CLICK, selectClass);
			}

			var classesArrCopy:Array = new Array();
			classesArrCopy = classesArrCopy.concat(classesArr);
			for(i = 0; i < 3; i++)
			{
				randIndex = Math.floor(Math.random()*classesArrCopy.length);
				btn = new BasicButton(classesArrCopy[randIndex], classesArr.indexOf(classesArrCopy[randIndex]));
				btn.x = classesXPos[i + 3];
				btn.y = classesYPos[i + 3];
				classSelectMC.addChild(btn);
				btn.addEventListener(MouseEvent.CLICK, selectClass);
				classesArrCopy.splice(randIndex, 1);
			}

			randIndex = Math.floor(Math.random()*classesArr.length);
			btn = new BasicButton("Random", randIndex);
			btn.x = classesXPos[4];
			btn.y = classesYPos[4];
			classRandomMC.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, selectClass);
		}

		private function showSelectedClassChoiceSubscreen():void
		{
			switch(settingsObject.data.classSelection)
			{
				case PICK_CLASS:
				classPickMC.visible = true;
				classSelectMC.visible = false;
				classRandomMC.visible = false;
				break;

				case NORMAL_CLASS_SELECTION:
				classPickMC.visible = false;
				classSelectMC.visible = true;
				classRandomMC.visible = false;	
				break;

				case RANDOM_CLASS:
				classPickMC.visible = false;
				classSelectMC.visible = false;
				classRandomMC.visible = true;	
				break;
			}
		}

		private function setScreenVisibility(mc:MovieClip, visibility:Boolean):void
		{
			mc.visible = visibility;
		}

		private function selectClass(e:MouseEvent):void
		{
			var btn:BasicButton = BasicButton(e.target);
			var classIndex:int = btn.getClassIndex();
			
			cardCount = 0;
			deckScore = 0;
			draftScreen.deckScoreTxt.visible = false;
			updateCardCount();

			setScreenVisibility(classChoiceScreen, false);

			generateDraftArray(classIndex);

			setScreenVisibility(draftScreen, true);
			var draftName:String = classesArr[classIndex] + " draft";
			draftScreen.draftClassTxt.text = draftName;

			draftScreen.copyBtn.addEventListener(MouseEvent.CLICK, copyDraftToClipboard);
			draftScreen.newDraftBtn.addEventListener(MouseEvent.CLICK, startNewDraft);
		}

		private function updateCardCount():void
		{
			var countTxt:String = cardCount + "/30";
			draftScreen.cardCountTxt.text = countTxt;
		}

		private function startNewDraft(e:MouseEvent):void
		{
			removeAllChildrenFromMC(cardDraft1);
			removeAllChildrenFromMC(cardDraft2);
			removeAllChildrenFromMC(cardDraft3);
			removeAllChildrenFromMC(draftHolder);

			setScreenVisibility(draftScreen, false);

			var classesArrCopy:Array = new Array();
			classesArrCopy = classesArrCopy.concat(classesArr);
			var btn:BasicButton;
			var randIndex:int;
			for(var i:int = 0; i < classSelectMC.numChildren; i++)
			{
				randIndex = Math.floor(Math.random()*classesArrCopy.length);
				btn = BasicButton(classSelectMC.getChildAt(i));
				btn.setClassIndex(classesArr.indexOf(classesArrCopy[randIndex]));
				btn.setLabel(classesArrCopy[randIndex]);
				classesArrCopy.splice(randIndex, 1);
			}

			randIndex = Math.floor(Math.random()*classesArr.length);
			btn = BasicButton(classRandomMC.getChildAt(0));
			btn.setClassIndex(Math.floor(Math.random()*classesArr.length));

			setScreenVisibility(classChoiceScreen, true);
		}

		private function copyDraftToClipboard(e:MouseEvent):void
		{
			var draftCard:DraftCard;
			var clipboardText:String = "";
			for(var i:int = 0; i < draftHolder.numChildren; i++)
			{
				draftCard = DraftCard(draftHolder.getChildAt(i));
				clipboardText += draftCard.cardNameTxt.text + "\n";
			}

			Clipboard.generalClipboard.clear();
 			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, clipboardText);
		}

		private function generateDraftArray(classIndex:int):void
		{
			draftArr = new Array();
			var rarityInd:int;
			var i:int;
			var chosenRarities:Array = new Array();
			var rarityCount:Array = new Array();
			var rarityDrafts:Array = new Array();
			rarityDrafts[0] = new Array();
			rarityDrafts[1] = new Array();
			rarityDrafts[2] = new Array();
			rarityDrafts[3] = new Array();
			var chosenRarityIndex:int;
			rarityWeights = new Array();

			switch(settingsObject.data.duplicates)
			{
				case ALLOW_DUPLICATES:
				for(i = 0; i < 30; i++)
				{
					rarityWeights = rarityScreen.getRarityWeights(i);
					raritiesWeightSum = calculateWeightSum(rarityWeights);
					rarityInd = getRandomWeightedIndex(rarityWeights, raritiesWeightSum);
					draftArr = draftArr.concat(chooseXCards(3, classesArr[classIndex], raritiesArr[rarityInd]));
				}
				break;

				case NO_DUPLICATES:
				for(i = 0; i < raritiesArr.length; i++)
				{
					rarityCount[i] = 0;
				}
				for(i = 0; i < 30; i++)
				{
					rarityWeights = rarityScreen.getRarityWeights(i);
					raritiesWeightSum = calculateWeightSum(rarityWeights);
					rarityInd = getRandomWeightedIndex(rarityWeights, raritiesWeightSum);
					rarityCount[rarityInd]++;
					chosenRarities.push(rarityInd);
				}
				for(i = 0; i < rarityCount.length; i++)
				{
					// we do this only if a rarity has been chosen at least once or we get an error
					if(rarityCount[i] > 0)
					{
						rarityDrafts[i] = rarityDrafts[i].concat(chooseXCards(rarityCount[i]*3, classesArr[classIndex], raritiesArr[i]));
					}
				}
				for(i = 0; i < chosenRarities.length; i++)
				{
					draftArr = draftArr.concat(rarityDrafts[chosenRarities[i]].splice(0, 3));
				}
				break;

				case CONSTRUCTED_DUPLICATES:
				for(i = 0; i < raritiesArr.length; i++)
				{
					rarityCount[i] = 0;
				}
				for(i = 0; i < 30; i++)
				{
					rarityWeights = rarityScreen.getRarityWeights(i);
					raritiesWeightSum = calculateWeightSum(rarityWeights);
					rarityInd = getRandomWeightedIndex(rarityWeights, raritiesWeightSum);
					rarityCount[rarityInd]++;
					chosenRarities.push(rarityInd);
				}
				for(i = 0; i < rarityCount.length; i++)
				{
					// we do this only if a rarity has been chosen at least once or we get an error
					if(rarityCount[i] > 0)
					{
						rarityDrafts[i] = rarityDrafts[i].concat(chooseXCards(rarityCount[i]*3, classesArr[classIndex], raritiesArr[i], true));
					}
				}
				for(i = 0; i < chosenRarities.length; i++)
				{
					draftArr = draftArr.concat(rarityDrafts[chosenRarities[i]].splice(0, 3));
				}
				break;
			}
			
			switch(settingsObject.data.draftType)
			{
				case REGULAR_DRAFT:
				break;

				case TIER_SORT:
				draftArr.sort(tierScoreSort);
				break;
			}

			showImprovedCardDraft();
		}

		private function showImprovedCardDraft():void
		{
			var randIndex:int = Math.floor(Math.random()*(draftArr.length/3));
			var choicesArr:Array = new Array();
			choicesArr = choicesArr.concat(draftArr.splice(0, 3));
			//choicesArr.push(draftArr[0]);
			//choicesArr.push(draftArr[1]);
			//choicesArr.push(draftArr[2]);
			//draftArr.splice(randIndex*3, 3);
			
			generateImprovedDraftCards(choicesArr);
		}

		private function generateImprovedDraftCards(choicesArr:Array):void
		{
			shuffledChoicesArr = shuffleChoices(choicesArr);
			loadCardImages(shuffledChoicesArr);
		}

		private function loadCardImages(imagesArr:Array):void
		{
			imagesLoaded = 0;
			loadersArray = new Array();
			for(var i:uint = 0; i < shuffledChoicesArr.length; i++)
			{
				var imgLoader:Loader = new Loader();
				var imgName:String = shuffledChoicesArr[i].cardName;
				// filenames cannot contain ":"
				imgName = imgName.replace(/:/mg, "");
				imgLoader.load(new URLRequest(File.applicationDirectory.resolvePath(IMG_ROOT+imgName+".png").url));
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
				loadersArray.push(imgLoader);
			}
		}

		private function imgLoaded(e:Event):void
		{
			imagesLoaded++;

			if(imagesLoaded == 3)
			{
				showCards();
			}
		}

		private function showCards():void
		{
			for(var i:uint = 0; i < shuffledChoicesArr.length; i++)
			{
				var card:HearthstoneLargeCard = shuffledChoicesArr[i];
				card.bmp.bitmapData = loadersArray[i].contentLoaderInfo.content.bitmapData;
				card.x = draftsXPos[i];
				card.y = draftsYPos;
				draftScreens[i].addChild(card);
				card.addEventListener(MouseEvent.CLICK, improvedPickCard);
			}
		}

		private function shuffleChoices(choicesArr:Array):Array
		{
			var shuffledChoicesArr:Array = new Array();
			var initLength:int = choicesArr.length;
			var randIndex:int;

			for(var i:uint = 0; i < initLength; i++)
			{
				randIndex = Math.floor(Math.random()*(choicesArr.length));
				shuffledChoicesArr.push(choicesArr[randIndex]);
				choicesArr.splice(randIndex, 1);
			}

			return shuffledChoicesArr;
		}

		private function improvedPickCard(e:MouseEvent):void
		{
			var card:HearthstoneLargeCard = HearthstoneLargeCard(e.target);
			var draftCard:DraftCard;
			var draftCardInd:int = draftCardIndex(card.cardName);
			
			if(draftCardInd != -1)
			{
				draftCard = DraftCard(draftHolder.getChildAt(draftCardInd));
				draftCard.incrementCardNumber();
			}
			else
			{
				draftCard = new DraftCard(card.cardName);
				draftCard.x = DRAFT_X;
				draftCard.y = DRAFT_START_Y + DRAFT_DIST * draftHolder.numChildren;

				var bd:BitmapData = new BitmapData(130, 40, false, 0x00000000);
				var sourceBd:BitmapData = card.bmp.bitmapData;
				bd.copyPixels(sourceBd, new Rectangle(77, 83, 130, 40), new Point(0, 0));

				draftCard.bmp.bitmapData = bd;
				draftCard.bmp.scaleX = 0.5;
				draftCard.bmp.scaleY = 0.5;
				draftCard.bmp.smoothing = true;
				draftHolder.addChild(draftCard);
			}

			sortDraft();

			cardCount++;
			deckScore += card.tierScore;
			updateCardCount();

			removeAllChildrenFromMC(cardDraft1);
			removeAllChildrenFromMC(cardDraft2);
			removeAllChildrenFromMC(cardDraft3);
			
			if(draftArr.length > 0)
			{
				showImprovedCardDraft();
			}
			else
			{
				draftScreen.deckScoreTxt.visible = true;
				var stringScore:String = "Deck Score: " + String(Number(deckScore/30).toFixed(2));
				draftScreen.deckScoreTxt.text = stringScore;
			}
		}

		private function sortDraft():void
		{
			var i:int;
			var draftArr = new Array();
			var draftCard:DraftCard;
			for(i = 0; i < draftHolder.numChildren; i++)
			{
				draftCard = DraftCard(draftHolder.getChildAt(i));
				draftArr.push(draftCard.cardName);
			}
			draftArr.sort(draftSort);
			for(i = 0; i < draftHolder.numChildren; i++)
			{
				draftCard = DraftCard(draftHolder.getChildAt(i));
				draftCard.y = DRAFT_START_Y + draftArr.indexOf(draftCard.cardName) * DRAFT_DIST;
			}
		}

		private function draftSort(a:String, b:String):Number
		{
			var aCost:int = int(dataXML.card.(@name == a).@cost);
			var bCost:int = int(dataXML.card.(@name == b).@cost);
			if(aCost>bCost)
			{
				return 1;
			}
			else if(aCost<bCost)
			{
				return -1;
			}
			else
			{
				if(a>b)
				{
					return 1;
				}
				else if(a<b)
				{
					return -1;
				}
				else
				{
					return 0;
				}
			}
		}

		private function draftCardIndex(cardName:String):int
		{
			var cardIndex:int = -1;
			var draftCard:DraftCard;
			for(var i:int = 0; i < draftHolder.numChildren; i++)
			{
				draftCard = DraftCard(draftHolder.getChildAt(i));
				if(draftCard.cardName == cardName)
				{
					cardIndex = i;
					break;
				}
			}

			return cardIndex;
		}

		private function tierScoreSort(a:*, b:*):int
		{
			if(a.tierScore>b.tierScore)
			{
				return 1;
			}
			else if(a.tierScore<b.tierScore)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}

		private function getWeights(classStr:String, rarityStr:String):Array
		{
			var weightsArray:Array = new Array();
			var arrayLen:int = allCards[classStr][rarityStr].length;
			for(var i:int = 0; i < arrayLen; i++)
			{
				weightsArray.push(allCards[classStr][rarityStr][i].cardWeight);
			}
			return weightsArray;
		}

		private function chooseXCards(cardNumber:int, classStr:String, rarityStr:String, constructedRestrictions:Boolean = false):Array
		{
			var choicesArr:Array = new Array();
			var card:HearthstoneLargeCard;
			var cardIndex:int;
			
			var weightsCopy:Array = getWeights(classStr, rarityStr);
			var currentWeightSum:int = calculateWeightSum(weightsCopy);
			//weightsCopy = weightsCopy.concat(cardWeights[classStr][rarityStr]);
			var selectedCardIndices:Array = new Array();
			var selectedCardCount:Array = new Array();
			var selectedInd:int;

			for(var i:int = 0; i < cardNumber; i++)
			{
				cardIndex = getRandomWeightedIndex(weightsCopy, currentWeightSum);
				card = new HearthstoneLargeCard(allCards[classStr][rarityStr][cardIndex].cardName, allCards[classStr][rarityStr][cardIndex].cardTierScoreArray[classesArr.indexOf(classStr)]);
				choicesArr.push(card);
				if(constructedRestrictions)
				{
					selectedInd = selectedCardIndices.indexOf(cardIndex);
					if(selectedInd != -1)
					{
						selectedCardCount[selectedInd]++;
						if(selectedCardCount[selectedInd] == raritiesConstructedLimit[raritiesArr.indexOf(rarityStr)])
						{
							currentWeightSum -= weightsCopy[cardIndex];
							weightsCopy[cardIndex] = 0;
						}
					}
					else
					{
						selectedCardIndices.push(cardIndex);
						selectedCardCount.push(1);

						if(selectedCardCount[selectedInd] == raritiesConstructedLimit[raritiesArr.indexOf(rarityStr)])
						{
							currentWeightSum -= weightsCopy[cardIndex];
							weightsCopy[cardIndex] = 0;
						}
					}
				}
				else
				{
					currentWeightSum -= weightsCopy[cardIndex];
					weightsCopy[cardIndex] = 0;
				}
			}
			
			return choicesArr;
		}

		private function getRandomWeightedIndex(weightsArr:Array, weightsSum:int):int
		{
			var randomValue:int = Math.floor(Math.random()*weightsSum);
			var weightsLen:int = weightsArr.length;
			var currentWeight:int = 0;
			var retIndex:int = -1;
			for(var i:int = 0; i < weightsLen; i++)
			{
				currentWeight += weightsArr[i];

				if(randomValue < currentWeight)
				{
					retIndex = i;
					break;
				}
			}

			return retIndex;
		}

		private function generateCardArrays():void
		{
			var cardsLen:int = dataXML.card.length();
			var cardName:String;
			var tierScoreStr:String;
			var cardWeight:int;
			var cardClass:String;
			var cardRarity:String;
			var cardCost:int;
			var tierScore:int;
			var cardType:String;
			var cardSet:String;
			var cardClassesArr:Array;
			var scoresArray:Array;
			var i:int;
			var j:int;

			resultsIndices = new Array();

			for(i = 0; i < classesArr.length; i++)
			{
				allCards[classesArr[i]] = new Array();

				for(j = 0; j < raritiesArr.length; j++)
				{
					allCards[classesArr[i]][raritiesArr[j]] = new Array();
				}
			}

			for(i = 0; i < cardsLen; i++)
			{
				cardClassesArr = new Array();
				scoresArray = new Array();

				cardName = String(dataXML.card[i].attribute("name"));
				cardClass = String(dataXML.card[i].attribute("playerClass"));
				cardRarity = String(dataXML.card[i].attribute("rarity"));
				tierScoreStr = String(dataXML.card[i].attribute("tierScore"));
				cardCost = int(dataXML.card[i].attribute("cost"));
				cardType = String(dataXML.card[i].attribute("type"));
				tierScoreStr = String(dataXML.card[i].attribute("tierScore"));
				cardSet = String(dataXML.card[i].attribute("set"));

				if(cardClass == "Neutral")
				{
					cardClassesArr = cardClassesArr.concat(classesArr);
					scoresArray = tierScoreStr.split(", ");
				}
				else
				{
					scoresArray = [0, 0, 0, 0, 0, 0, 0, 0, 0];
					if(cardClass == "Mage, Priest, Warlock" || cardClass == "Hunter, Paladin, Warrior" || cardClass == "Druid, Rogue, Shaman")
					{
						cardClassesArr = cardClass.split(", ");
						var splitValues:Array;
						splitValues = tierScoreStr.split(", ");
						var classesLen:int = cardClassesArr.length;
						for(var k:int = 0; k < classesLen; k++)
						{
							scoresArray[classesArr.indexOf(cardClassesArr[k])] = splitValues[k];
						}
					}
					else
					{
						cardClassesArr.push(cardClass);
						scoresArray[classesArr.indexOf(cardClass)] = int(tierScoreStr);
					}
				}

				cardWeight = int(dataXML.card[i].attribute("weight"));

				
				var tComponent:TierListComponent = new TierListComponent(cardName, cardRarity, cardSet, cardClass, cardCost, cardType, cardWeight, scoresArray);
				tComponent.x = TIER_LIST_X;
				tComponent.y = TIER_LIST_Y + TIER_LIST_DIST * tierListHolder.numChildren;
				tierListHolder.addChild(tComponent);
				resultsIndices.push(i);
				cardDataArr.push(tComponent);
				for(j = 0; j < cardClassesArr.length; j++)
				{
					allCards[cardClassesArr[j]][cardRarity].push(tComponent);
				}
			}

			displayCardListComponents(cardDataArr);
		}

		private function openLink(e:TextEvent):void
		{
			navigateToURL(new URLRequest(e.text), "_blank");
		}
	}
}