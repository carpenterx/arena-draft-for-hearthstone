package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class AdvancedTooltip extends MovieClip
	{
		private var txtField:TextField = new TextField();

		private var lineShape:Shape = new Shape();
		private var bgShape:Shape = new Shape();

		private const H_MARGIN:int = 4;
		private const V_MARGIN:int = 4;

		public function AdvancedTooltip(displayTxt:String, w:int, h:int):void
		{
			var tahomaFnt:Font = new TahomaFnt();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = tahomaFnt.fontName;
			txtFormat.size = 12;
			//txtFormat.align = TextFormatAlign.CENTER;

			txtField.selectable = false;
			txtField.defaultTextFormat = txtFormat;
			txtField.multiline = true;

			txtField.text = displayTxt;

			//trace(txtField.width, txtField.height);
			txtField.width = w - 2 * H_MARGIN;
			txtField.height = h - 2 * V_MARGIN;
			txtField.x = H_MARGIN;
			txtField.y = V_MARGIN;

			lineShape.graphics.beginFill(0x1E88E5);
			lineShape.graphics.drawRoundRect(0, 0, w, h, 10);
			lineShape.graphics.endFill();

			bgShape.graphics.beginFill(0xFFFFFF);
			bgShape.graphics.drawRoundRect(1, 1, w-2, h-2, 10);
			bgShape.graphics.endFill();

			addChild(lineShape);
			addChild(bgShape);
			addChild(txtField);
		}

		public function changeText(newTxt:String):void
		{
			txtField.text = newTxt;
		}
	}
}