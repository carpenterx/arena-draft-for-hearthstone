package
{
	import flash.display.MovieClip;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class SimpleTooltip extends MovieClip
	{
		private var txtField:TextField = new TextField();

		public function SimpleTooltip(displayTxt:String, w:int, h:int, bgColor:uint = 0xFFFFFF):void
		{
			var tahomaFnt:Font = new TahomaFnt();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = tahomaFnt.fontName;
			txtFormat.size = 12;
			txtFormat.align = TextFormatAlign.CENTER;

			//
			//
			//txtField.x = tfX;
			//txtField.y = tfY;
			//txtField.restrict = "0-9";
			//txtField.maxChars = 9;
			//txtField.type = tfType;
			txtField.background = true;
			txtField.backgroundColor = bgColor;
			txtField.border = true;
			txtField.borderColor = 0x333333;
			txtField.selectable = false;
			txtField.defaultTextFormat = txtFormat;
			//txtField.multiline = false;

			txtField.text = displayTxt;

			//trace(txtField.width, txtField.height);
			txtField.width = w;
			txtField.height = h;

			addChild(txtField);
		}

		public function changeText(newTxt:String):void
		{
			txtField.text = newTxt;
		}
	}
}