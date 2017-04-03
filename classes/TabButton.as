package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class TabButton extends MovieClip
	{
		private var shape1:Shape = new Shape();
		private var shape2:Shape = new Shape();

		private const BG_COLOR:uint = 0xffffff;
		private const LINE_THICKNESS:int = 1;
		private const FOREGROUND_COLOR:uint = 0x999999;
		private const TAB_WIDTH:int = 100;
		private const TAB_HEIGHT:int = 34;

		private var labelTxt:TextField = new TextField();

		public var tabScreen:MovieClip;

		public function TabButton(labelStr:String, tabMC:MovieClip):void
		{
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;

			tabScreen = tabMC;
			
			shape1.graphics.beginFill(BG_COLOR);
			shape1.graphics.drawRect(0, 0, TAB_WIDTH, TAB_HEIGHT);
			shape1.graphics.endFill();
			addChild(shape1);

			shape2.graphics.beginFill(FOREGROUND_COLOR);
			shape2.graphics.drawRect(LINE_THICKNESS, LINE_THICKNESS, TAB_WIDTH - 2*LINE_THICKNESS, TAB_HEIGHT - LINE_THICKNESS);
			shape2.graphics.endFill();
			addChild(shape2);

			var tahomaFnt:Font = new TahomaFnt();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = tahomaFnt.fontName;
			txtFormat.size = 14;
			txtFormat.align = TextFormatAlign.CENTER;
			
			labelTxt.x = 0;
			labelTxt.y = 7;
			labelTxt.width = TAB_WIDTH;
			labelTxt.height = 21;
			labelTxt.defaultTextFormat = txtFormat;

			labelTxt.text = labelStr;

			addChild(labelTxt);
		}

		public function enable():void
		{
			shape2.visible = false;
		}

		public function disable():void
		{
			shape2.visible = true;
		}

		public function toggle():void
		{
			if(shape2.visible)
			{
				shape2.visible = false;
			}
			else
			{
				shape2.visible = true;
			}
		}
	}
}