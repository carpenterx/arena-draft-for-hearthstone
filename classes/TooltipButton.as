package
{
	import flash.display.MovieClip;
	
	public class TooltipButton extends MovieClip
	{
		public var tooltip:MovieClip

		public function TooltipButton(tooltipReference:MovieClip):void
		{
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;
			tooltip = tooltipReference;
		}
	}
}