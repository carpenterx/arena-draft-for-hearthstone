package
{
	import flash.display.MovieClip;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import HelpHoverComponent;
	
	public class HelpHoverMenu extends MovieClip
	{
		private var txtField:TextField = new TextField();

		public static const HOVER_WIDTH:int = 160;
		public static const HOVER_HEIGHT:int = 22;

		public var hoverComponents:Array = new Array();
		public var dashLines:Array = new Array();
		public var infoString:String;

		public function HelpHoverMenu(displayTxt:String, infoStr:String):void
		{
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;

			infoString = infoStr;
			
			var tahomaFnt:Font = new TahomaFnt();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = tahomaFnt.fontName;
			txtFormat.size = 14;
			//txtFormat.align = TextFormatAlign.CENTER;

			txtField.background = true;
			txtField.backgroundColor = 0xffffff;
			txtField.border = true;
			txtField.borderColor = 0x333333;
			txtField.selectable = false;
			txtField.defaultTextFormat = txtFormat;

			txtField.text = displayTxt;

			txtField.width = HOVER_WIDTH;
			txtField.height = HOVER_HEIGHT;

			addChild(txtField);
		}
	}
}