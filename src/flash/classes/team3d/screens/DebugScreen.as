package team3d.screens
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import team3d.objects.World;

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class DebugScreen extends Sprite
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		public static var Text:TextField = new TextField();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the DebugScreen object.
		 */
		public function DebugScreen()
		{
			super();
			
			this.mouseEnabled	= false;
			this.mouseChildren	= false;
			World.instance.ScreenChange.add(clearText);
		}
		
		private function clearText():void 
		{
			Text.text = "";
		}
		
		public function Begin()
		{
			var format:TextFormat = new TextFormat();
			format.size = 30;
			format.bold = true;
			
			Text.defaultTextFormat = format;
			Text.autoSize = TextFieldAutoSize.LEFT;
            Text.mouseEnabled = false;
            Text.selectable = false;
			Text.textColor = 0x000000;
			Text.background = true;
			Text.backgroundColor = 0xFFFFFF;
			Text.border = true;
			Text.borderColor = 0xCC0066;
			Text.visible = true;
			Text.alpha = 1;
			
			Text.x = Text.y = 0;
            Text.text = "why?!";
			this.addChild(Text);
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		public function destroy():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

