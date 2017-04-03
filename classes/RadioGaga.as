package
{
	import flash.display.MovieClip;
	
	public class RadioGaga extends MovieClip
	{
		public var label:String;
		public static const ON:String = "on";
		public static const OFF:String = "off";

		public function RadioGaga(labelStr:String, stateStr:String = OFF):void
		{
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;

			label = labelStr;
			labelTxt.text = labelStr;
			setState(stateStr);
		}

		public function setState(stateStr:String):void
		{
			this.gotoAndStop(stateStr);
		}
	}
}