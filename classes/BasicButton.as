package
{
	import flash.display.MovieClip;
	
	public class BasicButton extends MovieClip
	{
		public var classIndex:int;
		public var labelStr:String;

		public function BasicButton(label:String, classInd:int = 0):void
		{
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;

			labelStr = label;
			labelTxt.text = labelStr;
			classIndex = classInd;
		}

		public function getClassIndex():int
		{
			return classIndex;
		}

		public function setClassIndex(newValue:int):void
		{
			classIndex = newValue;
		}

		public function setLabel(newLabel:String):void
		{
			labelStr = newLabel;
			labelTxt.text = labelStr;
		}
	}
}