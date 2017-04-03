package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.Font;
	
	public class FileListComponent extends MovieClip
	{
		private var fileTextFields:Array = new Array();
		private var fileHitboxes:Array = new Array();

		private var selectedFileName:String;

		private var exactMatch:String;
		private var partialMatches:Array;
		private var unmatchedFiles:Array;
		private var currentQuery:String;

		private var warnMode:Boolean = false;

		private var blackTxtFormat:TextFormat = new TextFormat();
		private var greyTxtFormat:TextFormat = new TextFormat();
		private var redTxtFormat:TextFormat = new TextFormat();
		private var greenTxtFormat:TextFormat = new TextFormat();

		public function FileListComponent():void
		{
			fileTextFields = [file1Txt, file2Txt, file3Txt, file4Txt, file5Txt, file6Txt, file7Txt];
			fileHitboxes = [hit1MC, hit2MC, hit3MC, hit4MC, hit5MC, hit6MC, hit7MC];

			var tahomaFnt:Font = new TahomaFnt();
			
			blackTxtFormat.font = tahomaFnt.fontName;
			blackTxtFormat.size = 14;
			blackTxtFormat.color = "0x000000";

			greyTxtFormat.font = tahomaFnt.fontName;
			greyTxtFormat.size = 14;
			greyTxtFormat.color = "0x999999";

			greenTxtFormat.font = tahomaFnt.fontName;
			greenTxtFormat.size = 14;
			greenTxtFormat.color = "0x009933";

			redTxtFormat.font = tahomaFnt.fontName;
			redTxtFormat.size = 14;
			redTxtFormat.color = "0xff0000";

			for(var i:int = 0; i < fileHitboxes.length; i++)
			{
				fileHitboxes[i].buttonMode = true;
				fileHitboxes[i].useHandCursor = true;
				fileHitboxes[i].alpha = 0.01;
				fileHitboxes[i].addEventListener(MouseEvent.CLICK, selectFile);
				fileHitboxes[i].addEventListener(MouseEvent.MOUSE_OVER, highlightFile);
			}
		}

		private function highlightFile(e:MouseEvent):void
		{
			for(var i:int = 0; i < fileHitboxes.length; i++)
			{
				if(e.target == fileHitboxes[i])
				{
					fileHitboxes[i].alpha = 0.3;
				}
				else
				{
					fileHitboxes[i].alpha = 0.01;
				}
			}
		}

		public function clearHighlight():void
		{
			for(var i:int = 0; i < fileHitboxes.length; i++)
			{
				fileHitboxes[i].alpha = 0.01;
			}
		}

		public function setWarnMode(warn:Boolean):void
		{
			warnMode = warn;
		}

		private function selectFile(e:MouseEvent):void
		{
			var fileNameIndex:int = fileHitboxes.indexOf(e.target);
			setSelectedFileName(fileTextFields[fileNameIndex].text);
		}

		private function setSelectedFileName(fileName:String):void
		{
			selectedFileName = fileName;
		}

		public function getSelectedFileName():String
		{
			return selectedFileName;
		}

		public function displayFileList(fileListArray:Array, searchTerm:String = ""):void
		{
			var i:int;
			currentQuery = searchTerm.toLowerCase();
			exactMatch = "";
			var currentInd:int = 0;
			partialMatches = new Array();
			unmatchedFiles = new Array();
			if(searchTerm == "")
			{
				for(i = 0; i < fileTextFields.length; i++)
				{
					if(fileListArray[i] != null)
					{
						fileTextFields[i].text = fileListArray[i].name;
					}
					else
					{
						fileTextFields[i].text = "";
					}
					fileTextFields[i].setTextFormat(blackTxtFormat);
				}
			}
			else
			{
				var textFieldsCount:int = fileTextFields.length;
				partialMatches = fileListArray.filter(partialMatchFilter);
				// display the exact match
				if(exactMatch != "")
				{
					fileTextFields[currentInd].text = exactMatch;
					if(warnMode)
					{
						fileTextFields[currentInd].setTextFormat(redTxtFormat);
					}
					else
					{
						fileTextFields[currentInd].setTextFormat(greenTxtFormat);
					}
					currentInd++;
				}
				// display the partial matches
				for(i = 0; i < partialMatches.length; i++)
				{
					if(currentInd < textFieldsCount)
					{
						fileTextFields[currentInd].text = partialMatches[i].name;
						fileTextFields[currentInd].setTextFormat(blackTxtFormat);
						currentInd++;
					}
					else
					{
						break;
					}
				}
				// display the remaining files
				for(i = 0; i < unmatchedFiles.length; i++)
				{
					if(currentInd < textFieldsCount)
					{
						fileTextFields[currentInd].text = unmatchedFiles[i];
						fileTextFields[currentInd].setTextFormat(greyTxtFormat);
						currentInd++;
					}
					else
					{
						break;
					}
				}
			}
		}

		private function partialMatchFilter(element:*, index:int, arr:Array):Boolean
		{
			var fileName:String = element.name.toLowerCase();

			if(fileName == currentQuery || fileName == currentQuery + ".xml")
			{
				exactMatch = element.name;
				return false;
			}
			else if(fileName.indexOf(currentQuery) != -1)
			{
				return true;
			}
			else
			{
				unmatchedFiles.push(element.name);
				return false;
			}
		}
	}
}